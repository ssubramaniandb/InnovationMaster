@isTest
public class TestContactTrigger {
    public TestMethod static void InsertContact(){
        Account acc = new Account(Name='Sivag Account');
        insert acc;
        Contact con = new Contact(LastName='Test',FirstName='Sivag', AccountId=acc.id, Is_Primary__c = False);
        insert con;
        List<Contact> lstCon = [Select Id, Is_Primary__c from Contact Where LastName='Test' and FirstName='Sivag'];
        for(Contact cont : lstCon){
            cont.Is_Primary__c = True;
        }
        if(lstCon != null)
            update lstcon;
        
    }
    
   }