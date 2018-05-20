public class ProductDescriptionAndPurchaseController {
    public string PreviousPageId { get; set;}
    
    private Contact contact { get; set; }
    private Product_Table__c productTable { get; set; }    
    
    // Table values from input fields
    public string Email { get; set;}
    public string FirstName { get; set;}
    public string LastName { get; set;}
    public string UnitCount { get; set;}    
    
    @TestVisible private Id Contact_Id;
    
    @TestVisible private Database.SaveResult updateExistingOrSaveNewContactResult;    
    @TestVisible private Database.SaveResult saveOrderTableResult;
    @TestVisible private Database.SaveResult updateProductTableResult;
    
    public ProductDescriptionAndPurchaseController () {
        PreviousPageId = ApexPages.currentPage().getParameters().get('id');
        productTable = [SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, 
                        Units_Available__c, Added_Date__c FROM Product_Table__c where Id =: PreviousPageId ];
    }
    
    public Product_Table__c getProductTable() {        
        return productTable;
    }
    
    public void DebugResult(Database.SaveResult result) {
    	if (result.isSuccess()) {        
        	System.debug('Successfully inserted/updated. ID: ' + result.getId());
    	} else {                   
        	for(Database.Error err : result.getErrors()) {
            	System.debug('The following error has occurred: ');                   
            	System.debug(err.getStatusCode() + ': ' + err.getMessage());
            	System.debug('Account fields that affected this error: ' + err.getFields());
        	}
    	}    
    }
    
    // Buy
    public void buy() {
        
        if(Integer.valueof(productTable.Units_Available__c) == 0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Sorry! Currently there is no this product in stock.' ));
        }
        
        if( Integer.valueof(UnitCount) > 0 ) {
            
            Savepoint savePoint = Database.setSavepoint();
            
            // Ищем контакт по введенному пользователем емейлу
            List<Contact> ct = [select Id, FirstName, LastName, Email from Contact where Email =: Email limit 1];
        
        	if(ct.size() > 0) {
                contact = ct[0];
            	contact.FirstName = FirstName;
            	contact.LastName = LastName;
                updateExistingOrSaveNewContactResult = Database.update(contact, true);
                Contact_Id = contact.Id;
                
                DebugResult(updateExistingOrSaveNewContactResult);
        	} else {
            	Contact newCt = new Contact(FirstName = FirstName, LastName = LastName, Email = Email);
            	updateExistingOrSaveNewContactResult = Database.insert(newCt, true);            
            	Contact_Id = newCt.Id;
            
            	DebugResult(updateExistingOrSaveNewContactResult);
        	}
            // Attempt to de-reference a null object
            if(updateExistingOrSaveNewContactResult.isSuccess()) {
            	Order_Table__c newOrder = new Order_Table__c(Name = 'Order [' + productTable.Name + ', ' + UnitCount + ' pieces ]', 
                                                     		Product__c = productTable.Id, 
                                                     		Units__c = Integer.valueof(UnitCount), 
                                                     		Order_Amount__c = Integer.valueof(UnitCount) * Integer.valueof(productTable.Unit_Price__c), 
                                                     		Contact__c = Contact_Id);
                
            saveOrderTableResult = Database.insert(newOrder, true);
            
            DebugResult(saveOrderTableResult);
                
            }
            
            // Логика проверки на кол-во
            if(saveOrderTableResult.isSuccess()) {
                Integer purchasedGoodsQuantityResult = Integer.valueof(productTable.Units_Available__c) - Integer.valueof(UnitCount);
                
                if(purchasedGoodsQuantityResult >= 0) {
                    productTable.Units_Available__c = purchasedGoodsQuantityResult;
            		updateProductTableResult = Database.update(productTable, true);
            
            		DebugResult(updateProductTableResult);
                    
                    if(updateProductTableResult.isSuccess()) {							
        				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Purchase is successfully completed! Thank you for choosing our store!')); 
        			}
                    
                } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cant buy products more then its available!' ));
                    
                    // RollBack all Database operations
                    Database.rollback(savePoint);                    
                }
        	}
        }           
    } 
}