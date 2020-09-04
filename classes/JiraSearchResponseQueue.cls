public without sharing class JiraSearchResponseQueue implements Queueable {
    private ID id;

    public JiraSearchResponseQueue(Id id) {
        this.id = id;
    }

    public void execute(QueueableContext context){
        JIRA_Issue_Key__c jiraIssue = [SELECT Id,Key_Name__c,Request_Body__c,
            Jira_Search_Response__c,Is_Search_Processed__c, Jira_User_Account__r.Email_Address__c FROM JIRA_Issue_Key__c WHERE Id = :id];
      
        Map<String, Object> searchResponse = (Map<String, Object>)JSON.deserializeUntyped(jiraIssue.Jira_Search_Response__c);

        List<Object> issues = (List<Object>)searchResponse.get(JiraUtility.KEY_ISSUES);
            
        if(issues.size() > 0){
            processSearchResponse(issues, jiraIssue);
        }
    }

    //https://developer.atlassian.com/cloud/jira/platform/rest/v3/#api-rest-api-3-issue-issueIdOrKey-notify-post
    private static void processSearchResponse(List<Object> issues, JIRA_Issue_Key__c jiraIssue){
        Map<String, Object> matchingIssues = new Map<String,Object>();
        for(Object matchingIssue : issues){
            Map<String, Object> issue = (Map<String,Object>)matchingIssue;//key
            Map<String, Object> fields = (Map<String, Object>)issue.get(JiraUtility.KEY_FIELDS);//issue summary
            if(issue.get(JiraUtility.KEY_KEY).toString() != jiraIssue.Key_Name__c){
                matchingIssues.put(issue.get(JiraUtility.KEY_KEY).toString(), fields.get(JiraUtility.KEY_SUMMARY).toString());
            }
        }
        if(matchingIssues.size() > 0){
            /*Map<String, Object> requestBody = (Map<String, Object>)JSON.deserializeUntyped(jiraIssue.Request_Body__c);

            JiraDataCommon.JiraUser loginUser = JiraUtility.getUserInfoByType(requestBody, JiraUtility.KEY_USER);
            
            Map<String, Object> issue = JiraUtility.getMapValue(requestBody, JiraUtility.KEY_ISSUE);
            Map<String, Object> fields = JiraUtility.getMapValue(issue, JiraUtility.KEY_FIELDS);
			JiraDataCommon.JiraUser reporterInfo = JiraUtility.getUserInfoByType(fields, JiraUtility.KEY_REPORTER);
           

            JiraDataCommon.JiraNotificationRequest jnr = new JiraDataCommon.JiraNotificationRequest();
            jnr.subject = JiraUtility.MAIL_SUBJECT_LABEL + jiraIssue.Key_Name__c;
            jnr.htmlBody = getHTMLFormatMessage(matchingIssues, jiraIssue.Key_Name__c);
            jnr.textBody = getTextFormatMessage(matchingIssues, jiraIssue.Key_Name__c);
            jnr.to = JiraUtility.createNotifyRequestData(loginUser, reporterInfo);    

            String jsonRequest = JSON.serialize(jnr);

            System.debug(jsonRequest);*/

            jiraIssue.Request_Body__c = null;
            jiraIssue.Jira_Search_Response__c = null;
            jiraIssue.Is_Search_Processed__c = true;
            //jiraIssue.Notification_Recipients__c = (''+jnr.to);
            update jiraIssue;

			JIRA_Issue_Key__c jiraIssueEmail = [SELECT Id,Key_Name__c,Jira_User_Account__r.Email_Address__c,Jira_User_Account__r.Name FROM JIRA_Issue_Key__c WHERE Id =:jiraIssue.Id];
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] { jiraIssueEmail.Jira_User_Account__r.Email_Address__c };
            message.subject = JiraUtility.MAIL_SUBJECT_LABEL + jiraIssueEmail.Key_Name__c;
            message.htmlbody = getHTMLFormatMessage(matchingIssues, jiraIssueEmail.Key_Name__c,jiraIssueEmail.Jira_User_Account__r.Name);
            message.plaintextbody = getTextFormatMessage(matchingIssues, jiraIssueEmail.Key_Name__c,jiraIssueEmail.Jira_User_Account__r.Name);
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) {
                System.debug('Similar issues found notification email was sent successfully.');
            } else {
                System.debug('Similar issues found notification email failed to send: '
                      + results[0].errors[0].message);
            }

            //8/21
            //JiraUtility.jiraApiCalloutPOST(JiraUtility.getNotificationUrl(jiraIssue.Key_Name__c), jsonRequest, jiraIssue.Id);
        }else{
            delete jiraIssue;
            System.debug('@@NO SIMILAR ISSUES IDENTIFIED OTHER THAN THE SEARCHED ISSUE@@');
        }
    }

    private static string getHTMLFormatMessage(Map<String, Object> matchingIssues, String jiraKey, String recipient){
        string htmlMessage = '';
        htmlMessage += '<div style="font-family:Consolas"><p>Hi ' + recipient + ', </p><p></p>';
        htmlMessage += '<p>Please be aware that about ' + matchingIssues.size() + ' issue(s) similar to '+ jiraKey +' exist in Jira. Please check if the solutions provided for any of these similar issues can be reused for development, testing, and deployment of issue/user story ('+ jiraKey +').</p><p></p>';
        for(String key: matchingIssues.keySet()){
            htmlMessage += '<p> # <a href="' + JiraUtility.BASE_URL + key + '">' + key + '-' + matchingIssues.get(key) +'</a></p>';
        }
        htmlMessage += '<p></p><p>Thanks, <br/>DemandBlue Jira Admin</p></div>';
        return htmlMessage;
    }

    private static string getTextFormatMessage(Map<String, Object> matchingIssues, String jiraKey, String recipient){
        string textMessage = '';
        textMessage += 'Hi ' + recipient + ', Please be aware that about ';
        textMessage += matchingIssues.size() + ' issue(s) similar to '+ jiraKey +' exist in Jira. Please check if the solutions provided for any of these similar issues can be reused for development, testing, and deployment of issue/user story ('+ jiraKey +').';
        for(String key: matchingIssues.keySet()){
            textMessage += ' # ' + key + '-' + matchingIssues.get(key) + '; ';
        }
        textMessage += 'Thanks, DemandBlue Jira Admin';
        return textMessage;
    }
}