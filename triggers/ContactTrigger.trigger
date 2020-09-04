trigger ContactTrigger on Contact (after insert, after update) {
    for(Contact con:Trigger.New){
        if(con.Is_Primary__c){
            Account acc = [Select Id, Has_Primary_Contact__c from Account Where Id =:con.AccountId];
            if(acc != null){
                acc.Has_Primary_Contact__c = True;
                update acc;
            }
        }
    }
}