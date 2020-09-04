@isTest
private class JiraWebhookHandler_Test {
   
    @IsTest static void testprocessJiraApiRequest(){
      
    	RestRequest req = new RestRequest();
    	string JSONMsg='{"timestamp":1567169833616,"webhookEvent":"jira:issue_created","issue_event_type_name":"issue_created"}';
    	req.requestURI='/services/apexrest/jiraapi/SFDC-101'; 
    	req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(JSONMsg);
    	RestContext.request = req;
        
    	Test.startTest();
    	JiraWebhookHandler.DefaultApiResponse result=JiraWebhookHandler.processJiraApiRequest();
    	test.stopTest();   
        system.assertEquals(result.apiName, 'SFDC-101');
        JIRA_Issue_Key__c j=[select Key_Name__c,Request_Body__c from JIRA_Issue_Key__c where Key_Name__c=:result.apiName ];
        system.debug(j.Request_Body__c);
        System.assert(J != null);
        
      }
}