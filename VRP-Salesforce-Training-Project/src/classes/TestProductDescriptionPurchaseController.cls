@isTest(SeeAllData=true) 
public class TestProductDescriptionPurchaseController {
    
	 @isTest static void testGetProductTableFromReferencedPage() {  
		Product_Table__c productTable = [SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, 
                                         Units_Available__c, Added_Date__c FROM Product_Table__c where Name = 'Berserk, Vol. 2' ];
		
		PageReference pRefSetted = Page.DetailedProductDescription;
		pRefSetted.getParameters().put('id', productTable.Id); 
        Test.setCurrentPage(pRefSetted);
        
        ProductDescriptionAndPurchaseController controller = new ProductDescriptionAndPurchaseController();
         
        System.assertEquals(controller.PreviousPageId, productTable.Id);
         
        Product_Table__c pt = controller.getProductTable();
        System.assertEquals(productTable, pt);
    }
    
    @isTest static void testBuy_Success() {
        Product_Table__c productTable = [SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, 
                                         Units_Available__c, Added_Date__c FROM Product_Table__c where Name = 'Berserk, Vol. 2' ];
                
        PageReference pRefSetted = Page.DetailedProductDescription;
		pRefSetted.getParameters().put('id', productTable.Id); 
        Test.setCurrentPage(pRefSetted);
                        
        ProductDescriptionAndPurchaseController controller = new ProductDescriptionAndPurchaseController();
        controller.Email = 'slavadonnikov@gmail.com';
        controller.FirstName = 'Viachaslau';
        controller.LastName = 'Donnikov';
        controller.UnitCount = '10';
        
        Integer AmountBeforeBuy = Integer.valueOf(productTable.Units_Available__c);
        
        Test.startTest();
        controller.buy();
        Test.stopTest();
        
        Contact testContact = [select Id, FirstName, LastName, Email from Contact where Email =: controller.Email limit 1];
        System.assertNotEquals(null, testContact);
        System.assertEquals(controller.Contact_Id, testContact.Id);
        System.assert(controller.updateExistingOrSaveNewContactResult.isSuccess());
        
        List<Order_Table__c> orderTableList = new List<Order_Table__c>();
        for(Order_Table__c ordt : [select Name, Product__c, Units__c, Order_Amount__c, Contact__c from Order_Table__c]) {
            if(ordt.Name == 'Order [' + productTable.Name + ', ' + controller.UnitCount + ' pieces ]' 
               && ordt.Product__c == productTable.Id
               && ordt.Units__c == Integer.valueof(controller.UnitCount) 
               && ordt.Order_Amount__c == Integer.valueof(controller.UnitCount) * Integer.valueof(productTable.Unit_Price__c)
               && ordt.Contact__c == controller.Contact_Id) {
                	orderTableList.add(ordt);
            }
        }
        System.assert(orderTableList.size() > 0);        
        System.assert(controller.saveOrderTableResult.isSuccess());
        
        System.assert(controller.updateProductTableResult.isSuccess());
        
        Product_Table__c productTableChanged = [SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, 
                                                Units_Available__c, Added_Date__c FROM Product_Table__c where Id =: productTable.Id ];
        System.assertEquals(Integer.valueof(productTableChanged.Units_Available__c), AmountBeforeBuy - Integer.valueof(controller.UnitCount));
        
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
    		System.assertEquals('Purchase is successfully completed! Thank you for choosing our store!', msg.getSummary());
    		System.assertEquals(ApexPages.Severity.CONFIRM, msg.getSeverity()); 
		}
    }
    
    @isTest static void testBuy_Error() {
        Product_Table__c productTable = [SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, 
                                         Units_Available__c, Added_Date__c FROM Product_Table__c where Name = 'Berserk, Vol. 2' ];
        
        PageReference pRefSetted = Page.DetailedProductDescription;
		pRefSetted.getParameters().put('id', productTable.Id); 
        Test.setCurrentPage(pRefSetted);
        
        ProductDescriptionAndPurchaseController controller = new ProductDescriptionAndPurchaseController();
        controller.Email = 'slavadonnikov@gmail.com';
        controller.FirstName = 'Viachaslau';
        controller.LastName = 'Donnikov';
        controller.UnitCount = '1000';
        
        Integer AmountBeforeBuy = Integer.valueOf(productTable.Units_Available__c);
        
        Test.startTest();
        controller.buy();
        Test.stopTest();
        
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
    		System.assertEquals('You cant buy products more then its available!', msg.getSummary());
    		System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity()); 
		}
        
        List<Order_Table__c> orderTableList = new List<Order_Table__c>();
        for(Order_Table__c ordt : [select Name, Product__c, Units__c, Order_Amount__c, Contact__c from Order_Table__c]) {
            if(ordt.Name == 'Order [' + productTable.Name + ', ' + controller.UnitCount + ' pieces ]' 
               && ordt.Product__c == productTable.Id
               && ordt.Units__c == Integer.valueof(controller.UnitCount) 
               && ordt.Order_Amount__c == Integer.valueof(controller.UnitCount) * Integer.valueof(productTable.Unit_Price__c)
               && ordt.Contact__c == controller.Contact_Id) {
                	orderTableList.add(ordt);
            }
        }
        System.assertNotEquals(null, orderTableList);        
        System.assert(orderTableList.size() != 1);
        
        System.assertNotEquals(Integer.valueof(productTable.Units_Available__c), AmountBeforeBuy - Integer.valueof(controller.UnitCount));
        System.assertEquals(Integer.valueof(productTable.Units_Available__c), AmountBeforeBuy);
       
    }
    
    @isTest static void testBuy_NoProductAvailable() {
        Product_Table__c productTable = [SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, 
                                         Units_Available__c, Added_Date__c FROM Product_Table__c where Name = 'Berserk, Vol. 1' ];
        
        PageReference pRefSetted = Page.DetailedProductDescription;
		pRefSetted.getParameters().put('id', productTable.Id); 
        Test.setCurrentPage(pRefSetted);
        
        ProductDescriptionAndPurchaseController controller = new ProductDescriptionAndPurchaseController();
        controller.Email = 'slavadonnikov@gmail.com';
        controller.FirstName = 'Viachaslau';
        controller.LastName = 'Donnikov';
        controller.UnitCount = '0';
        
        Test.startTest();
        controller.buy();
        Test.stopTest();
        
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
    		System.assertEquals('Sorry! Currently there is no this product in stock.', msg.getSummary());
    		System.assertEquals(ApexPages.Severity.INFO, msg.getSeverity()); 
		}
    }
    
    @isTest static void testCreatingNewContact() {
        Product_Table__c productTable = [SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, 
                                         Units_Available__c, Added_Date__c FROM Product_Table__c where Name = 'Berserk, Vol. 3' ];
        
        PageReference pRefSetted = Page.DetailedProductDescription;
		pRefSetted.getParameters().put('id', productTable.Id); 
        Test.setCurrentPage(pRefSetted);
        
        ProductDescriptionAndPurchaseController controller = new ProductDescriptionAndPurchaseController();
        controller.Email = 'notexistingemail@gmail.com';
        controller.FirstName = 'Miranda';
        controller.LastName = 'Ellecon';
        controller.UnitCount = '10';
        
        Integer NumberOfContactsBefore = [select Id, FirstName, LastName, Email from Contact].size();           
        
        Test.startTest();
        controller.buy();
        Test.stopTest();
        
        Integer NumberOfContactsAfter = [select Id, FirstName, LastName, Email from Contact].size();
        
        System.assertNotEquals(NumberOfContactsBefore, NumberOfContactsAfter);
        
        System.assert(controller.updateExistingOrSaveNewContactResult.isSuccess());
        
        List<Contact> newContact = [select Id, FirstName, LastName, Email from Contact where Email =: controller.Email limit 1];
        System.assertNotEquals(null, newContact);
        System.assertNotEquals(0, newContact.size());
    }
    
    @isTest static void testDebugErrors() {
        Product_Table__c productTable = [SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, 
                                         Units_Available__c, Added_Date__c FROM Product_Table__c where Name = 'Berserk, Vol. 1' ];
        
        PageReference pRefSetted = Page.DetailedProductDescription;
		pRefSetted.getParameters().put('id', productTable.Id); 
        Test.setCurrentPage(pRefSetted);
        
        ProductDescriptionAndPurchaseController controller = new ProductDescriptionAndPurchaseController();
        controller.Email = 'notexistingemail@gmail.com';
        controller.FirstName = 'Miranda';
        controller.LastName = 'Ellecon';
        controller.UnitCount = '10';
        
        Test.startTest();
        Contact newContact = new Contact(Email = controller.Email);
        controller.updateExistingOrSaveNewContactResult = Database.insert(newContact, false);            
           
        controller.DebugResult(controller.updateExistingOrSaveNewContactResult);
        Test.stopTest();
        
        System.assert(! controller.updateExistingOrSaveNewContactResult.isSuccess());
        System.assertNotEquals(null, controller.updateExistingOrSaveNewContactResult.getErrors());
    }
}