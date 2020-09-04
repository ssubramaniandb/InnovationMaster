@RestResource(urlMapping='/jiraapi/*')
global without sharing class JiraWebhookHandler {
    global class DefaultApiResponse{
        public String apiName;
        public Integer status;
    }

    @HttpPost
    global static DefaultApiResponse processJiraApiRequest(){
        RestRequest rrequest = RestContext.request;
        String keyId = rrequest.requestURI.substring(rrequest.requestURI.lastIndexOf('/')+1);     
        
        DefaultApiResponse response = new DefaultApiResponse();
        response.apiName = keyId;
        response.status = 200;
        
        JIRA_Issue_Key__c jir = new JIRA_Issue_Key__c();
        jir.Key_Name__c = keyId;
        jir.Request_Url__c = rrequest.requestURI;
        jir.Request_Body__c = rrequest.requestBody.toString();

        insert jir;
        /*if(Schema.SObjectType.JIRA_Issue_Key__c.isCreateable()){
            insert jir;
        }*/

        return response;
    }
}