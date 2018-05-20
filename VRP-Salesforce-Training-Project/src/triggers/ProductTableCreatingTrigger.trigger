trigger ProductTableCreatingTrigger on Product_Table__c (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        TriggerHandler.CreateNewProductTables(Trigger.New);
    }
}