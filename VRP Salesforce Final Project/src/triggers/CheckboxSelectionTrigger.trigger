trigger CheckboxSelectionTrigger on Product_Item__c (before insert, before update) {
    if(Trigger.isBefore) {
        for(Product_Item__c product : Trigger.New) {
            if(product.Amount__c > 0) {
                product.InStock__c = true;
            } else {
                product.Amount__c = 0;
                product.InStock__c = false;
            }
        }
    }
}