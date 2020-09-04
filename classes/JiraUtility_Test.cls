@isTest(SeeAllData=true)
private class JiraUtility_Test{
          static testMethod void test_isDemandBlueUser(){
                JiraUtility obj01 = new JiraUtility();
                 String a='sf@demandblue.com';
                Boolean ju=JiraUtility.isDemandBlueUser(a);
                System.assert(a.Contains('@demandblue'));
            
            }
    
              static testMethod void test_isDemandBlueUser1(){
                    JiraUtility obj01 = new JiraUtility();
                    string a='sf@preludesys.com';
                    Boolean ju=JiraUtility.isDemandBlueUser(a);
                    System.assert(a.Contains('@preludesys.com'));
            
            }
         static testMethod void test_isDemandBlueUser2(){
                    JiraUtility obj01 = new JiraUtility();
                    string a=' ';
                    Boolean ju=JiraUtility.isDemandBlueUser(a);
                    //System.assert(a.Contains('@preludesys.com'));
            
            }
    
              static testMethod void test_buildJqlQueryFromLabels(){
                JiraUtility obj01 = new JiraUtility();
                  List<String> Labels=new List<String>{'test1'};
                JiraUtility.buildJqlQueryFromLabels(Labels);  
                  string a='test2';
                  Labels.add(a);
                  JiraUtility.buildJqlQueryFromLabels(Labels);  
                
                }
                
                         
              
    
              static testMethod void test_getLongValue(){
                JiraUtility obj01 = new JiraUtility();
                JiraUtility.getLongValue(new Map<String,Object>(),'test data');
              }
              static testMethod void test_getStringValue(){
               // JiraUtility obj01 = new JiraUtility();
                 // string key='Testdata';
                //JiraUtility.getStringValue(new Map<String,Object>(),key);
               map<string, object> userdata=new map<string, object>{'name'=>'yuvaraj','key'=>'yuvaraj','accountId'=>'5b03dc8556a','emailAddress'=>'yuvaraj@preludesys.com','displayName'=>'Yuvaraj M'};
                string a=' ';
                   JiraUtility.getStringValue(userdata,a);
                  string b='name';
                  JiraUtility.getStringValue(userdata,b);
              }
              static testMethod void test_getMapValue_UseCase1(){
                JiraUtility obj01 = new JiraUtility();
             //  map<string,object> emptymap=new map<string, object>();
               // JiraUtility.getMapValue(emptymap,' ');
                 map<string,object> emptymap1=new map<string, object>{'name'=>'yuvaraj','key'=>'yuvaraj'};
                  JiraUtility.getMapValue(emptymap1,'yuvaraj');  
              }
              static testMethod void test_isUserStory_UseCase1(){
                JiraUtility obj01 = new JiraUtility();
                JiraUtility.isUserStory(new Map<String,Object>());
               map<string, object> Issuetype=new map<string, object>{'self'=>'https=>//demandblue.atlassian.net/rest/api/2/issuetype/10001','id'=>'10001','description'=>'A user story. Created by Jira Software - do not edit or delete.','iconUrl'=>'https=>//demandblue.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype','name'=>'Story','subtask'=>false,'avatarId'=>10315};
                JiraUtility.isUserStory(Issuetype);
              }
              /*static testMethod void test_getUserInfoByType_Usecase1(){
                  map<string, object>newuser=new map<string, object>{'name'=>'yuvaraj','accountId'=>'5b03dc8556a','emailAddress'=>'yuvaraj@preludesys.com','displayName'=>'Yuvaraj M'};
                  map<string, object> Issuetype=new map<string, object>{'Usertype'=>newuser };

                JiraUtility.getUserInfoByType(Issuetype,'Usertype');
              }
    
               static testMethod void test_getJiraUserInfo(){
                JiraUtility obj01 = new JiraUtility();
                   JiraDataCommon.JiraUser juser = new JiraDataCommon.JiraUser();
                   map<string, object> userdata=new map<string, object>{'name'=>'yuvaraj','key'=>'yuvaraj','accountId'=>'5b03dc8556a','emailAddress'=>'yuvaraj@preludesys.com','displayName'=>'Yuvaraj M'};
                   
        
                JiraUtility.getJiraUserInfo(userdata);
              }*/
    
              static testMethod void test_createNotifyRequestData(){
                JiraUtility obj01 = new JiraUtility();
                  JiraDataCommon.JiraUser obj02=new  JiraDataCommon.JiraUser();
                  obj02.name='testname';
                  obj02.emailAddress='test@demandblue.com';
                  obj02.accountid='62137263821783';
                  obj02.displayname='itstest';
                  JiraDataCommon.JiraUser obj03=new  JiraDataCommon.JiraUser();
                  obj03.name='testname1';
                  obj03.emailAddress=' ';
                  obj03.accountid='621398263821783';
                  obj03.displayname='itstest1';

                JiraUtility.createNotifyRequestData(obj02,obj03);
                  obj03.emailAddress='test1@demandblue.com';
                   JiraUtility.createNotifyRequestData(obj02,obj03);
                  obj02.emailAddress=' ';
                  obj03.emailAddress='test@gmail.com';
                   JiraUtility.createNotifyRequestData(obj02,obj03);
              }

              static testMethod void test_getNotificationUrl(){
                JiraUtility obj01 = new JiraUtility();
                JiraUtility.getNotificationUrl('test data');
              }
    
              static testMethod void test_getSearchUrl(){
                JiraUtility obj01 = new JiraUtility();
                JiraUtility.getSearchUrl();
              }
    
 @istest
     static void test_jiraApiCalloutPOST(){
      Test.setMock(HttpCalloutMock.class, new jiraMockHttpResponseGenerator());
        Jira_User_Account__c jiraUserAccount = new Jira_User_Account__c(Email_Address__c = 'sfadmin@demandblue.com', 
                                                                        Jira_User_Account_Id__c = '5b03dc8556a',
                                                                        Name = 'DemandBlue Jira Admin');
        insert jiraUserAccount;
         
    List<JIRA_Issue_Key__c> JIK_1 = new List<JIRA_Issue_Key__c>();    
                      JIRA_Issue_Key__c obj_1=new JIRA_Issue_Key__c(Key_Name__c = 'test_1', Jira_User_Account__c = jiraUserAccount.Id,
                                                                    Request_Body__c=
                                                                    '{"user":{"name":"yuvaraj","accountId":"5b03dc8556a","emailAddress":"yuvaraj@preludesys.com","displayName":"Yuvaraj M"},"issue":{"reporter":{"name":"yuvaraj","accountId":"5b03dc8556a","emailAddress":"yogesg@gmail.com","displayName":"Yuvaraj M"}}}'    
                                                                   );
                JIK_1.add(obj_1);
                insert JIK_1;
                id recordid=JIK_1[0].id;
    string endpoint='https://demandblue.atlassian.net/rest/api/3/search';
    List<String> labels = new List<String>();
              string l1='requirement';
              labels.add(l1);
    string jql = JiraUtility.buildJqlQueryFromLabels(labels);
    JiraDataCommon.JiraSearchRequest jr = new JiraDataCommon.JiraSearchRequest();
        jr.expand = new List<String>{'names', 'schema'};
        jr.jql = jql;
        jr.maxResults = 50;
        jr.fieldsByKeys = false;
        jr.fields = new List<String>{'summary', 'status','assignee'};
        jr.startAt = 0;

        String jsonRequest = JSON.serialize(jr);
        test.startTest();            
        JiraUtility.jiraApiCalloutPOST(endpoint,jsonRequest,recordid);
        Test.stoptest();
}

    @istest
    static void test_jiraApiCalloutGET()
    {
        string endpoint='https://demandblue.atlassian.net/rest/api/3/search';
                      Test.startTest();
        Jira_User_Account__c jiraUserAccount = new Jira_User_Account__c(Email_Address__c = 'sfadmin@demandblue.com', 
                                                                        Jira_User_Account_Id__c = '5b03dc8556a',
                                                                        Name = 'DemandBlue Jira Admin');
        insert jiraUserAccount;


        List<JIRA_Issue_Key__c> JIK_1 = new List<JIRA_Issue_Key__c>();    
                      JIRA_Issue_Key__c obj_1=new JIRA_Issue_Key__c(Key_Name__c = 'test_1', Jira_User_Account__c = jiraUserAccount.Id,
																	Request_Body__c='{"timestamp":1567169833616,"webhookEvent":"jira:issue_created","issue_event_type_name":"issue_created","user":{"self":"https://demandblue.atlassian.net/rest/api/2/user?accountId=5b03dc8556a","name":"yuvaraj","key":"yuvaraj","accountId":"5b03dc8556a","emailAddress":"yuvaraj@preludesys.com","displayName":"Yuvaraj M","active":true,"timeZone":"America/Los_Angeles","accountType":"atlassian"},"issue":{"id":"15102","self":"https://demandblue.atlassian.net/rest/api/2/issue/15102","key":"DL-21","fields":{"statuscategorychangedate":"2019-08-30T05:57:13.765-0700","issuetype":{"self":"https://demandblue.atlassian.net/rest/api/2/issuetype/10001","id":"10001","description":"A user story. Created by Jira Software - do not edit or delete.","iconUrl":"https://demandblue.atlassian.net/secure/viewavatar?size=medium&avatarId=10315&avatarType=issuetype","name":"Story","subtask":false,"avatarId":10315},"reporter":{"self":"https://demandblue.atlassian.net/rest/api/2/user?accountId=5b03dc8556a","name":"yuvaraj","key":"yuvaraj","accountId":"5b03dc8556a","emailAddress":"yuvaraj@preludesys.com","displayName":"Yuvaraj M","active":true,"timeZone":"America/Los_Angeles","accountType":"atlassian"},"timespent":null,"project":{"self":"https://demandblue.atlassian.net/rest/api/2/project/10050","id":"10050","key":"DL","name":"DemandBlue Labs","projectTypeKey":"software","simplified":false},"fixVersions":[],"aggregatetimespent":null,"resolution":null,"resolutiondate":null,"workratio":0,"lastViewed":null,"watches":{"self":"https://demandblue.atlassian.net/rest/api/2/issue/DL-21/watchers","watchCount":0,"isWatching":true},"created":"2019-08-30T05:57:13.551-0700","customfield_10140":null,"customfield_10141":null,"customfield_10142":null,"priority":{"self":"https://demandblue.atlassian.net/rest/api/2/priority/3","iconUrl":"https://demandblue.atlassian.net/images/icons/priorities/medium.svg","name":"Medium","id":"3"},"labels":["webhook"],"customfield_10138":null,"customfield_10139":null,"customfield_10018":null,"aggregatetimeoriginalestimate":3600,"timeestimate":3600,"versions":[],"issuelinks":[],"assignee":{"self":"https://demandblue.atlassian.net/rest/api/2/user?accountId=5b03dc8556a","name":"yuvaraj","key":"yuvaraj","accountId":"5b03dc8556a","emailAddress":"yuvaraj@preludesys.com","displayName":"Yuvaraj M","active":true,"timeZone":"America/Los_Angeles","accountType":"atlassian"},"updated":"2019-08-30T05:57:13.551-0700","status":{"self":"https://demandblue.atlassian.net/rest/api/2/status/1","description":"The issue is open and ready for the assignee to start work on it.","iconUrl":"https://demandblue.atlassian.net/images/icons/statuses/open.png","name":"New","id":"1","statusCategory":{"self":"https://demandblue.atlassian.net/rest/api/2/statuscategory/2","id":2,"key":"new","colorName":"blue-gray","name":"New"}},"components":[],"timeoriginalestimate":3600,"description":null,"customfield_10131":null,"customfield_10010":null,"customfield_10011":"1|i00lar:","customfield_10132":null,"customfield_10012":null,"customfield_10133":null,"customfield_10134":[],"customfield_10013":null,"customfield_10014":null,"timetracking":{"originalEstimate":"1h","remainingEstimate":"1h","originalEstimateSeconds":3600,"remainingEstimateSeconds":3600},"security":null,"customfield_10008":null,"customfield_10009":{"hasEpicLinkFieldDependency":false,"showField":false,"nonEditableReason":{"reason":"PLUGIN_LICENSE_ERROR","message":"Portfolio for Jira must be licensed for the Parent Link to be available."}},"aggregatetimeestimate":3600,"attachment":[],"summary":"Sample Webhook Request","creator":{"self":"https://demandblue.atlassian.net/rest/api/2/user?accountId=5b03dc8556a","name":"yuvaraj","key":"yuvaraj","accountId":"5b03dc8556a","emailAddress":"yuvaraj@preludesys.com","displayName":"Yuvaraj M","active":true,"timeZone":"America/Los_Angeles","accountType":"atlassian"},"subtasks":[],"reporter":{"self":"https://demandblue.atlassian.net/rest/api/2/user?accountId=5b03dc8556a","name":"yuvaraj","key":"yuvaraj","accountId":"5b03dc8556a","emailAddress":"yuvaraj@preludesys.com","displayName":"Yuvaraj M","active":true,"timeZone":"America/Los_Angeles","accountType":"atlassian"},"aggregateprogress":{"progress":0,"total":3600,"percent":0},"customfield_10000":"{}","customfield_10001":null,"customfield_10004":null,"environment":null,"duedate":null,"progress":{"progress":0,"total":3600,"percent":0},"votes":{"self":"https://demandblue.atlassian.net/rest/api/2/issue/DL-21/votes","votes":0,"hasVoted":false}}},"changelog":{"id":"31094","items":[{"field":"assignee","fieldtype":"jira","fieldId":"assignee","from":null,"fromString":null,"to":"yuvaraj","toString":"Yuvaraj M","tmpFromAccountId":null,"tmpToAccountId":"5b03dc8556a"},{"field":"priority","fieldtype":"jira","fieldId":"priority","from":null,"fromString":null,"to":"3","toString":"Medium"},{"field":"reporter","fieldtype":"jira","fieldId":"reporter","from":null,"fromString":null,"to":"yuvaraj","toString":"Yuvaraj M","tmpFromAccountId":null,"tmpToAccountId":"5b03dc8556a"},{"field":"Status","fieldtype":"jira","fieldId":"status","from":null,"fromString":null,"to":"1","toString":"New"},{"field":"summary","fieldtype":"jira","fieldId":"summary","from":null,"fromString":null,"to":null,"toString":"Sample Webhook Request"}]}}}',
                                                                    Jira_Search_Response__c='{"expand":"schema,names","startAt":0,"maxResults":50,"total":24,"issues":[{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"14659","self":"https://demandblue.atlassian.net/rest/api/3/issue/14659","key":"US-1","fields":{"summary":"Lightning Migration","assignee":{"self":"https://demandblue.atlassian.net/rest/api/3/user?accountId=5b1edc8723905d49c5b332ee","accountId":"5b1edc8723905d49c5b332ee","displayName":"ssubramanian@demandblue.com","active":true,"timeZone":"America/Los_Angeles","accountType":"atlassian"},"status":{"self":"https://demandblue.atlassian.net/rest/api/3/status/10032","description":"","iconUrl":"https://demandblue.atlassian.net/images/icons/statuses/generic.png","name":"UAT","id":"10032","statusCategory":{"self":"https://demandblue.atlassian.net/rest/api/3/statuscategory/4","id":4,"key":"indeterminate","colorName":"yellow","name":"In Progress"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"15677","self":"https://demandblue.atlassian.net/rest/api/3/issue/15677","key":"UOSA-3","fields":{"summary":"Lightning Migration","assignee":null,"status":{"self":"https://demandblue.atlassian.net/rest/api/3/status/1","description":"The issue is open and ready for the assignee to start work on it.","iconUrl":"https://demandblue.atlassian.net/images/icons/statuses/open.png","name":"New","id":"1","statusCategory":{"self":"https://demandblue.atlassian.net/rest/api/3/statuscategory/2","id":2,"key":"new","colorName":"blue-gray","name":"To Do"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"16417","self":"https://demandblue.atlassian.net/rest/api/3/issue/16417","key":"TL-66","fields":{"summary":"lightning migration for sales cloud","assignee":{"self":"https://demandblue.atlassian.net/rest/api/3/user?accountId=5e5e2ffda17f930c9b9687aa","accountId":"5e5e2ffda17f930c9b9687aa","displayName":"Bharathi C A","active":true,"timeZone":"America/Los_Angeles","accountType":"atlassian"},"status":{"self":"https://demandblue.atlassian.net/rest/api/3/status/10033","description":"","iconUrl":"https://demandblue.atlassian.net/images/icons/statuses/generic.png","name":"Estimation Submitted","id":"10033","statusCategory":{"self":"https://demandblue.atlassian.net/rest/api/3/statuscategory/4","id":4,"key":"indeterminate","colorName":"yellow","name":"In Progress"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"15261","self":"https://demandblue.atlassian.net/rest/api/3/issue/15261","key":"TIS-11","fields":{"summary":"Deployment Manual","assignee":{"self":"https://demandblue.atlassian.net/rest/api/3/user?accountId=5cc331cbca2840100ac3c076","accountId":"5cc331cbca2840100ac3c076","displayName":"Vinoth Kannan","active":true,"timeZone":"America/Los_Angeles","accountType":"atlassian"},"status":{"self":"https://demandblue.atlassian.net/rest/api/3/status/6","description":"The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.","iconUrl":"https://demandblue.atlassian.net/images/icons/statuses/closed.png","name":"Closed","id":"6","statusCategory":{"self":"https://demandblue.atlassian.net/rest/api/3/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}},{"expand":"operations,versionedRepresentations,editmeta,changelog,renderedFields","id":"15260","self":"https://demandblue.atlassian.net/rest/api/3/issue/15260","key":"TIS-10","fields":{"summary":"System Testing","assignee":{"self":"https://demandblue.atlassian.net/rest/api/3/user?accountId=5cc331cbca2840100ac3c076","accountId":"5cc331cbca2840100ac3c076","displayName":"Vinoth Kannan","active":true,"timeZone":"America/Los_Angeles","accountType":"atlassian"},"status":{"self":"https://demandblue.atlassian.net/rest/api/3/status/6","description":"The issue is considered finished, the resolution is correct. Issues which are closed can be reopened.","iconUrl":"https://demandblue.atlassian.net/images/icons/statuses/closed.png","name":"Closed","id":"6","statusCategory":{"self":"https://demandblue.atlassian.net/rest/api/3/statuscategory/3","id":3,"key":"done","colorName":"green","name":"Done"}}}}],"names":{"summary":"Summary","assignee":"Assignee","status":"Status"},"schema":{"summary":{"type":"string","system":"summary"},"assignee":{"type":"user","system":"assignee"},"status":{"type":"status","system":"status"}}}'  
                                                                   );
                JIK_1.add(obj_1);
                insert JIK_1;
                id recordid=JIK_1[0].id;
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('getapicallout');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);
        jirautility.jiraApiCalloutGET(endpoint,recordid);
        Test.stopTest(); 
        
    }
   
}