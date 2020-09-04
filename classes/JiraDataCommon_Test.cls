@isTest
private class JiraDataCommon_Test{
   static testMethod void test_JiraUser(){
    Test.startTest();
    JiraDataCommon.JiraUser obj1 = new JiraDataCommon.JiraUser();
    obj1.name = 'test data';
    obj1.emailAddress = 'sfadmin@demandblue.com';
    obj1.accountId ='01pR0000002bIUH';
    obj1.displayName = 'sfdc';
    Test.stopTest();
   }
    static testMethod void test_JiraSearchRequest(){
        Test.startTest();
        JiraDataCommon.JiraSearchRequest obj2 = new JiraDataCommon.JiraSearchRequest();
    obj2.expand = new List<String>();
    obj2.jql = 'test data';
    obj2.maxResults = 10;
    obj2.fieldsByKeys = false;
    obj2.fields = new List<String>();
    obj2.startAt = 10;
        Test.stopTest();
    }
    static testMethod void test_JiraNotificationRequest(){
        test.startTest();
    JiraDataCommon.JiraNotificationRequest obj3 = new JiraDataCommon.JiraNotificationRequest();
    obj3.htmlBody = 'htmlbo';
    obj3.subject = 'subject';
    obj3.textBody = 'body';
    obj3.to = new Map<String,Object>();
    Test.stopTest();
  }
}