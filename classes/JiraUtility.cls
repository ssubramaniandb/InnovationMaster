public without sharing class JiraUtility {
    public final static String KEY_TIMESTAMP = 'timestamp';
    public final static String KEY_WEBHOOK_EVENT = 'webhookEvent';
    public final static String KEY_ISSUE_EVENT_TYPE_NAME = 'issue_event_type_name';
    public final static String KEY_USER = 'user';
    public final static String KEY_USERS = 'users';
    public final static String KEY_ISSUE = 'issue';
    public final static String KEY_ISSUES = 'issues';
    public final static String KEY_FIELD = 'field';
    public final static String KEY_FIELDS = 'fields';
    public final static String KEY_GROUPS = 'groups';
    public final static String KEY_ISSUE_TYPE = 'issuetype';
    public final static String KEY_CREATOR = 'creator';
    public final static String KEY_REPORTER = 'reporter';
    public final static String KEY_WATCHERS = 'watchers';
    public final static String KEY_LABELS = 'labels';
    public final static String KEY_NAME = 'name';
    public final static String KEY_KEY = 'key';
    public final static String KEY_EMAIL_ADDRESS = 'emailAddress';
    public final static String KEY_ACCOUNT_ID = 'accountId';
    public final static String KEY_DISPLAY_NAME = 'displayName';
    public final static String KEY_SUMMARY = 'summary';
    public final static String KEY_CHANGELOG = 'changelog';
    public final static String KEY_ITEMS = 'items';
    public final static String KEY_PERMISSIONS = 'permissions';
    public final static String TEXT_STORY = 'Story';

    private final static String JIRA_NAMED_CREDENTIAL = 'callout:Jira_API';
    public final static String BASE_URL = 'https://demandblue.atlassian.net/browse/';
    public final static String MAIL_SUBJECT = 'Missing Label information on the issue: ';
    public final static String MAIL_SUBJECT_LABEL = 'Issues found similar to issue: ';

    public final static String LABELS_TO_EXCLUDE = 'requirement,analysis,code,functionality,fields,date';

    public final static String GROUP_CSM = 'csm';

    public static Boolean isDemandBlueUser(String emailAddress){
        if(String.isBlank(emailAddress))
        {
            return false;
        }
        return (emailAddress.toLowerCase().contains('@preludesys.com') || emailAddress.toLowerCase().contains('@demandblue.com'));
    }

    public static String buildJqlQueryFromLabels(List<String> labels){
        string jql = '';
        if(!labels.isEmpty()){
            if(labels.size() == 1){
                jql = 'labels = ' + labels[0];
            }else{
                jql = 'labels IN ('+ String.join(labels, ',') +')';
            }
        }
        return jql;
    }

    public static Long getLongValue(Map<String, Object> source, String key){
        return (Long) source.get(key);
    }

    public static String getStringValue(Map<String, Object> source, String key){
        if(source.get(key) == null){
            return '';    
        }
        return (String) source.get(key).toString();
    }

    public static Map<String, Object> getMapValue(Map<String, Object> source, String key){
             
        if(source == null){
            return new Map<String, Object>();
        }
        return (Map<String, Object>) source.get(key);
    }    

    public static Boolean isUserStory(Map<String,Object> issueType){
        if(issueType == null || issueType.get(KEY_NAME) == null){
            return false;
        }        
        return (issueType.get(KEY_NAME).toString().equalsIgnoreCase(TEXT_STORY));
    }

    /*public static JiraDataCommon.JiraUser getUserInfoByType(Map<String,Object> response, String userType){
        Map<String, Object> userInfo = (Map<String, Object>)response.get(userType);
        return getJiraUserInfo(userInfo);
    }

    public static JiraDataCommon.JiraUser getJiraUserInfo(Map<String, Object> user){
        JiraDataCommon.JiraUser juser = new JiraDataCommon.JiraUser();
        juser.accountId = user.get(KEY_ACCOUNT_ID).toString();
        if(user.get(KEY_NAME) != null){
            juser.name = user.get(KEY_NAME).toString();
        }        
        if(user.get(KEY_EMAIL_ADDRESS) != null){
            juser.emailAddress = user.get(KEY_EMAIL_ADDRESS).toString();
        }
        if(user.get(KEY_DISPLAY_NAME) != null){
            juser.displayName = user.get(KEY_DISPLAY_NAME).toString(); 
        }
        return juser;
    }*/
    
    /*public static Map<String,Object> getNotifyRestrictTo(){
        List<Map<String,Object>> groupsList = new List<Map<String,Object>>();
        List<Map<String,Object>> permissionsList = new List<Map<String,Object>>();
        Map<String,Object> groups = new Map<String,Object>();
        Map<String,Object> permissions = new Map<String,Object>();
        Map<String,Object> restrictTo = new Map<String,Object>();
              
        groups.put(KEY_NAME, 'jira-notification-group');
        groupsList.add(groups);

        permissions.put(KEY_KEY, 'SET_ISSUE_SECURITY');
        permissionsList.add(permissions);        
        
        restrictTo.put(KEY_PERMISSIONS, permissionsList);
        restrictTo.put(KEY_GROUPS, groupsList);
        System.debug('@@RESTRICTED_TO: ' + restrictTo);
        return restrictTo;
    }*/

    public static Map<String,Object> createNotifyRequestData(JiraDataCommon.JiraUser loginUser, JiraDataCommon.JiraUser reporter){
        Boolean notifyCSM = true;
        List<Map<String,Object>> usersList = new List<Map<String,Object>>();
        Map<String,Object> users = new Map<String,Object>();
        Map<String,Object> recipients = new Map<String,Object>();

        //users.put(KEY_NAME, 'admin');
        //usersList.add(users);
        
        users = new Map<String,Object>();
        users.put(KEY_NAME, 'yuvaraj'); /* users.put(KEY_ACCOUNT_ID, '5b03dc8556a2a01a412c5bfb');*/
        usersList.add(users);
        
        System.debug('@@LOGIN_USER: ' + loginUser);

        //notification to login user
        if(isDemandBlueUser(loginUser.EmailAddress) && !String.isBlank(loginUser.name)){
            users = new Map<String,Object>();
            users.put(KEY_NAME, loginUser.name);
            usersList.add(users);
        }
        
        if(usersList.size() > 0){
            recipients.put(KEY_USERS, usersList);
            //remove this condition before moving this code to production and comment-out/remove email to yuvaraj.
            if(usersList.size() > 1){
                notifyCSM = false;
            }
        }

        //notification to reporter only if demandblue email
        if(isDemandBlueUser(reporter.EmailAddress)){
            recipients.put(KEY_REPORTER, true);
            notifyCSM = false;
        }
        
        recipients.put(KEY_WATCHERS, false);

        //notification to CSM group
        /*if(notifyCSM){
            Map<String,Object> groups = new Map<String,Object>();
            groups.put(KEY_NAME, GROUP_CSM);
            List<Map<String,Object>> groupList = new List<Map<String,Object>>();
            groupList.add(groups);
            recipients.put(KEY_GROUPS, groupList);
        }*/

        System.debug('@@RECIPIENTS: ' + recipients);

        return recipients;
    }

    public static String getNotificationUrl(String keyName){
        return (JIRA_NAMED_CREDENTIAL + '/rest/api/3/issue/'+ keyName +'/notify');
    }

    public static String getSearchUrl(){
        return (JIRA_NAMED_CREDENTIAL + '/rest/api/3/search');
    }
    
    /*
     * Unauthorized endpoint, please check Setup->Security->Remote site settings. 
     * endpoint = https://demandblue.atlassian.net/rest/api/3/search
     *
     * JIRA API help - https://developer.atlassian.com/cloud/jira/platform/rest/v3/
     */
    @future(callout = true)
    public static void jiraApiCalloutPOST(string endpoint, string jsonRequest, Id recordId){
        jiraApiPOST(endpoint, jsonRequest, recordId);
    }

    public static void jiraApiPOST(string endpoint, string jsonRequest, Id recordId){
        HttpRequest request = createHttpRequest(endpoint, 'POST');
        if(!String.isBlank(jsonRequest)){
            request.setBody(jsonRequest);
        }
        
        /*System.debug(req.getBody());*/
        
        Http http = new Http();
        System.HttpResponse response = http.send(request);
        
        System.debug(response.getBody());

        processJiraResponse(endpoint, recordId, response);
    }

    private static HttpRequest createHttpRequest(String endpoint, String method){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method);        
        request.setHeader('Content-Type', 'application/json');
        return request;
    }

    private static void processJiraResponse(string endpoint, Id recordId, System.HttpResponse response){
        System.debug('@@processJiraResponse@@ : ' + endpoint);
        if(endpoint.endsWithIgnoreCase('/search')){
            if(!Test.isRunningTest()){
                JIRA_Issue_Key__c jiraIssue = [SELECT Id,Jira_Search_Response__c,Is_Search_Processed__c FROM JIRA_Issue_Key__c WHERE Id = :recordId];
    
                if(jiraIssue != null){
                    jiraIssue.Jira_Search_Response__c = response.getBody();
                    jiraIssue.Is_Search_Processed__c = false;
                    update jiraIssue;
    
                    JiraSearchResponseQueue searchResponseQueue = new JiraSearchResponseQueue(recordId);
                    ID jobID = System.enqueueJob(searchResponseQueue);
                }
            }
        }
    }

    @future(callout = true)
    public static void jiraApiCalloutGET(string endpoint, Id recordId){
        HttpRequest request = createHttpRequest(endpoint, 'GET');
        
        /*System.debug(req.getBody());*/
        
        Http http = new Http();
        System.HttpResponse response = http.send(request);
        //response.getBody();
        System.debug(response.getBody());
    }
}