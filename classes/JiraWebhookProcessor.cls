public without sharing class JiraWebhookProcessor {
    private static JIRA_Issue_Key__c jiraIssue;
    private static JiraDataCommon.JiraUser loginUser;
    private static JiraDataCommon.JiraUser creatorInfo;
    private static JiraDataCommon.JiraUser reporterInfo;

    private static Map<String, Object> fields;

    private final static String ISSUE_CREATED = 'issue_created';
    private final static String ISSUE_UPDATED = 'issue_updated';

    private final static Integer RSP_REQ_PROCESSED = 1;
    private final static Integer RSP_REQ_DELETED = -1;

    @InvocableMethod(label='Process Jira Webhook Request' description='Process the request sent by Jira via webhook.')
    public static List<Integer> processJiraWebhookRequest(List<Id> ids){
        List<Integer> returnValue = new List<Integer>();

        jiraIssue = [SELECT Id,Key_Name__c,Request_Body__c,Issue_Event_Type_Name__c,Jira_User_Account__c,Jira_User_Account__r.Email_Address__c FROM JIRA_Issue_Key__c WHERE Id in :ids LIMIT 1];

        Map<String, Object> requestBody = (Map<String, Object>)JSON.deserializeUntyped(jiraIssue.Request_Body__c);
        Map<String, Object> requestedUser = JiraUtility.getMapValue(requestBody, JiraUtility.KEY_USER);

        String accountId = JiraUtility.getStringValue(requestedUser, JiraUtility.KEY_ACCOUNT_ID);
        
        system.debug('@@@accountId: ' + accountId);
        
        //process requests from DemandBlue Users only
        List<Jira_User_Account__c> jiraUserAccount = [Select Id FROM Jira_User_Account__c WHERE Jira_User_Account_Id__c =:accountId LIMIT 1];
        
        system.debug('@@@isDemandBlueUserAccount: ' + !jiraUserAccount.isEmpty());        
        
        if (!jiraUserAccount.isEmpty()){
            Long timestamp = JiraUtility.getLongValue(requestBody, JiraUtility.KEY_TIMESTAMP);
            String webhookEvent = JiraUtility.getStringValue(requestBody, JiraUtility.KEY_WEBHOOK_EVENT);
            String issueEventTypeName = JiraUtility.getStringValue(requestBody, JiraUtility.KEY_ISSUE_EVENT_TYPE_NAME);
                    
            system.debug('@@@issue_event_type_name: ' + issueEventTypeName);
    
            jiraIssue.Issue_Event_Type_Name__c = issueEventTypeName;
            jiraIssue.Jira_User_Account__c = jiraUserAccount[0].Id;
            
            //on creation of new issues or updation of issues for labels
            //if(issueEventTypeName.equalsIgnoreCase(ISSUE_CREATED) || (issueEventTypeName.equalsIgnoreCase(ISSUE_UPDATED) && isLabelChangeInRequest(requestBody))){
            if(issueEventTypeName.equalsIgnoreCase(ISSUE_CREATED) || issueEventTypeName.equalsIgnoreCase(ISSUE_UPDATED)){
                system.debug('@@processResponse@@:YES');
                processResponse(requestBody);
                returnValue.add(RSP_REQ_PROCESSED);
            }else{
                deleteJiraIssue();
                system.debug('@@DELETED DUE TO NOT A VALID REQUEST FOR LABEL ENGAGEMENT@@');
                returnValue.add(RSP_REQ_DELETED);
            }
        }else{
            deleteJiraIssue();            
            system.debug('@@DELETED DUE TO NOT A REQUEST FROM A VALID DEMANDBLUE USER@@');
            returnValue.add(RSP_REQ_DELETED);            
        }
        return returnValue;
    }

    private static Boolean isLabelChangeInRequest(Map<String,Object> requestBody){
        Map<String,Object> changelog = JiraUtility.getMapValue(requestBody, JiraUtility.KEY_CHANGELOG);
        List<Object> itemsList = (List<Object>)changelog.get(JiraUtility.KEY_ITEMS);
        for(object item: itemsList){
            Map<String,Object> itemValue = (Map<String,Object>)item;
            if(JiraUtility.getStringValue(itemValue, JiraUtility.KEY_FIELD).equalsIgnoreCase(JiraUtility.KEY_LABELS)){
                //System.debug('@@LABEL CHANGE EXIST IN THE REQUEST@@');   
                return true;
            }
        }
        //System.debug('@@NO LABEL CHANGE EXISTS IN THE REQUEST@@');
        return false;
    }

    private static void processResponse(Map<String,Object> requestBody){
        String issueEventTypeName = JiraUtility.getStringValue(requestBody, JiraUtility.KEY_ISSUE_EVENT_TYPE_NAME);
        //loginUser = JiraUtility.getUserInfoByType(requestBody, JiraUtility.KEY_USER);
        
        Map<String, Object> issue = JiraUtility.getMapValue(requestBody, JiraUtility.KEY_ISSUE); //(Map<String, Object>)requestBody.get(JiraUtility.KEY_ISSUE);
        fields = JiraUtility.getMapValue(issue, JiraUtility.KEY_FIELDS); //(Map<String, Object>)issue.get(JiraUtility.KEY_FIELDS);
        
        Map<String, Object> issueType = JiraUtility.getMapValue(fields, JiraUtility.KEY_ISSUE_TYPE); //(Map<String, Object>)fields.get(JiraUtility.KEY_ISSUE_TYPE);

        if(JiraUtility.isUserStory(issueType)){
            //creatorInfo = JiraUtility.getUserInfoByType(fields, JiraUtility.KEY_CREATOR);
            //reporterInfo = JiraUtility.getUserInfoByType(fields, JiraUtility.KEY_REPORTER);

            List<Object> labelsTemp = (List<Object>)fields.get(JiraUtility.KEY_LABELS);
            List<String> labels = new List<String>();
            List<String> labelsToExclude = JiraUtility.LABELS_TO_EXCLUDE.toLowerCase().split(',');
            for(Object l: labelsTemp){
                if(!labelsToExclude.contains(((string)l).toLowerCase())){
                    labels.add((string)l);
                }
            }
            
            string jql = JiraUtility.buildJqlQueryFromLabels(labels);
            if(string.isBlank(jql)){
                //no labels found 
                noLabelNotification();
            }else{
                if(issueEventTypeName.equalsIgnoreCase(ISSUE_CREATED) || (issueEventTypeName.equalsIgnoreCase(ISSUE_UPDATED) && isLabelChangeInRequest(requestBody))){
                    searchIssuesByLabels(jql);
                }else{
                    deleteJiraIssue();
                    System.debug('@@DELETED DUE TO NOT A LABEL UPDATE REQUEST.@@' + jiraIssue.Key_Name__c);
                }
            }
        }else {
            deleteJiraIssue();
            System.debug('@@DELETED DUE TO NOT A VALID EVENT TYPE/ISSUE TYPE.@@' + jiraIssue.Key_Name__c);
        }
    }

    private static void deleteJiraIssue(){
        delete jiraIssue;
    }

    private static void noLabelNotification(){
        //System.debug('@@Inside-noLabelNotification@@');
        /*JiraDataCommon.JiraNotificationRequest jnr = new JiraDataCommon.JiraNotificationRequest();
        jnr.subject = JiraUtility.MAIL_SUBJECT + jiraIssue.Key_Name__c;
        jnr.htmlBody = '<p>Hi, </p><p>Label/keyword information is not available on ' + jiraIssue.Key_Name__c + '. Please add valid labels/keywords to it so that similar issue(s) can be identified and their solution(s) can be utilized for '+ jiraIssue.Key_Name__c +'.</p><p></p>';
        jnr.textBody = 'Hi, Label/keyword information is not available on ' + jiraIssue.Key_Name__c + '. Please add valid labels/keywords to it so that similar issue(s) can be identified and their solution(s) can be utilized for '+ jiraIssue.Key_Name__c +'.';
        jnr.to = JiraUtility.createNotifyRequestData(loginUser, reporterInfo);
        jnr.restrict = JiraUtility.getNotifyRestrictTo();
        
        String jsonRequest = JSON.serialize(jnr);*/

        jiraIssue.Request_Body__c = null;
        jiraIssue.No_Label_Notification_Sent__c = true;
        //jiraIssue.Notification_Recipients__c = (''+jnr.to);
        update jiraIssue;
        
        JIRA_Issue_Key__c jiraIssueEmail = [SELECT Id,Key_Name__c,Jira_User_Account__r.Email_Address__c,Jira_User_Account__r.Name FROM JIRA_Issue_Key__c WHERE Id =:jiraIssue.Id];

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { jiraIssueEmail.Jira_User_Account__r.Email_Address__c };
        message.subject = JiraUtility.MAIL_SUBJECT + jiraIssueEmail.Key_Name__c;
        message.htmlbody = '<div style="font-family:Consolas"><p>Hi ' + jiraIssueEmail.Jira_User_Account__r.Name + ', </p><p>Label/keyword information is not available on ' + jiraIssueEmail.Key_Name__c + '. Please add valid labels/keywords to it so that similar issue(s) can be identified and their solution(s) can be utilized for '+ jiraIssueEmail.Key_Name__c +'.</p><p></p><p></p><p>Thanks, <br/>DemandBlue Jira Admin</p></div>';
        message.plaintextbody = 'Hi ' + jiraIssueEmail.Jira_User_Account__r.Name + ', Label/keyword information is not available on ' + jiraIssueEmail.Key_Name__c + '. Please add valid labels/keywords to it so that similar issue(s) can be identified and their solution(s) can be utilized for '+ jiraIssueEmail.Key_Name__c +'. Thanks, DemandBlue Jira Admin';
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if (results[0].success) {
            System.debug('No label notification email was sent successfully.');
        } else {
            System.debug('No label notification email failed to send: '
                         + results[0].errors[0].message);
        }
        
        /*if(!Test.isRunningTest()){
            JiraUtility.jiraApiCalloutPOST(JiraUtility.getNotificationUrl(jiraIssue.Key_Name__c), jsonRequest, jiraIssue.Id);
        }*/
    }

    private static void searchIssuesByLabels(string jql){
        JiraDataCommon.JiraSearchRequest jr = new JiraDataCommon.JiraSearchRequest();
        jr.expand = new List<String>{'names', 'schema'};
        jr.jql = jql;
        jr.maxResults = 50;
        jr.fieldsByKeys = false;
        jr.fields = new List<String>{'summary', 'status','assignee'};
        jr.startAt = 0;

        String jsonRequest = JSON.serialize(jr);
        
        //any pending updates - event type name, jira user account
        update jiraIssue;

        System.debug(jsonRequest);

        if(!Test.isRunningTest()){
            JiraUtility.jiraApiCalloutPOST(JiraUtility.getSearchUrl(), jsonRequest, jiraIssue.Id);
        }
    }
}