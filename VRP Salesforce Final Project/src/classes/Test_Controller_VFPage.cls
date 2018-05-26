@isTest
public class Test_Controller_VFPage {
    // Test the output to the page of the specified number of records (10)
    @isTest static void testProductItemsNumberAtPage() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
                
        ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc);        
        System.assertEquals(10, controller.getProduct().size());
    }
    
    // Test Pagination 
    @isTest static void testPaginationFunctions() {
		List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc); 
        
        controller.setNumberOfPageItems = new ApexPages.StandardSetController(Database.getQueryLocator(
                'SELECT Id, Name, Type__c, Amount__c, Price__c, Added_date__c, Release_Date__c, InStock__c FROM Product_Item__c ORDER BY Name ASC LIMIT 100'));
        controller.setNumberOfPageItems.setPageSize(10);
         
        System.assert(controller.hasNext);
        System.assert(!controller.hasPrevious);
        
        controller.Next();
        System.assert(controller.hasPrevious);
        System.assert(controller.hasPrevious);
        
        controller.First();
        controller.Last();
        controller.Previous();        
    }

	// Test Sorting 
	@isTest static void testSortingByName() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc); 
        
        Test.startTest();
        controller.sortByName();
        Test.stopTest();
        
        List<Product_Item__c> productsFromOrg = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c ORDER BY Name ASC LIMIT 10];
        
        System.assertEquals(productsFromOrg, controller.setNumberOfPageItems.getRecords());
    }    
    @isTest static void testSortingByType() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc); 
        
        Test.startTest();
        controller.sortByType();
        Test.stopTest();
        
        List<Product_Item__c> productsFromOrg = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c ORDER BY Type__c ASC LIMIT 10];
        
        System.assertEquals(productsFromOrg, controller.setNumberOfPageItems.getRecords());
    }
    @isTest static void testSortingByPrice() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc); 
        
        Test.startTest();
        controller.sortByPrice();
        Test.stopTest();
        
        List<Product_Item__c> productsFromOrg = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c ORDER BY Price__c ASC LIMIT 10];
        
        System.assertEquals(productsFromOrg, controller.setNumberOfPageItems.getRecords());
    }
    @isTest static void testSortingByAmount() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc); 
        
        Test.startTest();
        controller.sortByAmount();
        Test.stopTest();
        
        List<Product_Item__c> productsFromOrg = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c ORDER BY Amount__c ASC LIMIT 10];
        
        System.assertEquals(productsFromOrg, controller.setNumberOfPageItems.getRecords());
    }
    @isTest static void testSortingByReleaseDate() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc); 
        
        Test.startTest();
        controller.sortByReleaseDate();
        Test.stopTest();
        
        List<Product_Item__c> productsFromOrg = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c ORDER BY Release_Date__c ASC LIMIT 10];
        
        System.assertEquals(productsFromOrg, controller.setNumberOfPageItems.getRecords());
    }
    @isTest static void testSortingByAddedDate() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc); 
        
        Test.startTest();
        controller.sortByAddedDate();
        Test.stopTest();
        
        List<Product_Item__c> productsFromOrg = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c ORDER BY Added_Date__c ASC LIMIT 10];
        
        System.assertEquals(productsFromOrg, controller.setNumberOfPageItems.getRecords());
    }
    
    // Test adding new empty record (trigger an error message: 'Please fill in at least a Name field!')
    @isTest static void testAddingNewEmptyRecord() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc);
        
        List<Product_Item__c> productsFromOrg = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c ORDER BY Added_Date__c ASC];
        
        controller.newProduct = new Product_Item__c();
        
        Test.startTest();
        controller.addNewProduct();
        Test.stopTest();        
        
        System.assertEquals(null, controller.productSaveResult);
        
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
    		System.assertEquals(' Please fill in at least a Name field!', msg.getSummary());
    		System.assertEquals(ApexPages.Severity.FATAL, msg.getSeverity()); 
		}
        
        List<Product_Item__c> productsFromOrgAfterAddNewRecord = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c ORDER BY Added_Date__c ASC];
        
        // Check that the number of records has not changed. The new record was not saved.
        System.assertEquals(productsFromOrg, productsFromOrgAfterAddNewRecord);
    }
    
    // Test сreating a new record with all the restrictions. Must be successfully saved.
    @isTest static void testAddingNewValidRecord() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc);
        
        List<Product_Item__c> productsFromOrg = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c ORDER BY Added_Date__c ASC];
        
        controller.newProduct = new Product_Item__c(Name = 'Test Product', Amount__c = 10, Price__c = 200.00, Type__c = 'Mobile Phone', 
                                                    Release_Date__c = date.parse('05/01/2018'), Added_Date__c = date.parse('05/05/2018'));
        Test.startTest();
        controller.addNewProduct();
        Test.stopTest();

        System.assert(controller.productSaveResult.isSuccess());
                
        List<Product_Item__c> productsFromOrgAfterAddNewRecord = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c ORDER BY Added_Date__c ASC];
        
        // Check that the number of records has changed. The new record was saved.
        System.assertNotEquals(productsFromOrg, productsFromOrgAfterAddNewRecord);
        System.assertEquals(productsFromOrg.size() + 1, productsFromOrgAfterAddNewRecord.size());
    }
    
    // Test "Add" & "Delete" popups
    @isTest static void testPupups() {
        ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc);
        
        controller.showAddPopup();
        System.assertEquals(true, controller.displayAddPopup);
        
        controller.closeAddPopup();
		System.assertEquals(false, controller.displayAddPopup);

		controller.showDeletePopup();
        System.assertEquals(true, controller.displayDeletePopup);
        
        controller.closeDeletePopup();
        System.assertEquals(false, controller.displayDeletePopup);
    }    
    
    // Test throwing an error when we try to delete not identified record
    @isTest static void testDeletingProduct_Error() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc);
        
        List<Product_Item__c> productsFromOrg = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c ORDER BY Added_Date__c ASC];
        controller.productId = null;
        
        Test.startTest();
        controller.deleteProduct();
        Test.stopTest();
        
        System.assertEquals(null, controller.productDeleteResult);
        
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
    		System.assertEquals('productId == null!', msg.getSummary());
    		System.assertEquals(ApexPages.Severity.FATAL, msg.getSeverity()); 
		}
        
        List<Product_Item__c> productsFromOrgAfterAddNewRecord = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c ORDER BY Added_Date__c ASC];
        
        // Check that the number of records has not changed. The record wasn't deleted.
        System.assertEquals(productsFromOrg, productsFromOrgAfterAddNewRecord);
    }
    
    // Test successfull deleting record.
    @isTest static void testDeletingProduct_Success() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc);
        
        List<Product_Item__c> productsFromOrg = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c ORDER BY Added_Date__c ASC];
        
        Product_Item__c productToDelete = productsFromOrg[0];
        
        controller.productId = productToDelete.Id;
        
        Test.startTest();
        controller.deleteProduct();
        Test.stopTest();
        
        System.assertNotEquals(null, controller.productDeleteResult);
        System.assert(controller.productDeleteResult.isSuccess());
        
        List<Product_Item__c> deletedProduct = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      Added_date__c, Release_Date__c, InStock__c 
                                                      FROM Product_Item__c WHERE Id =: productToDelete.Id];
        
        System.assertEquals(0, deletedProduct.size());
        
        List<Product_Item__c> productsFromOrgAfterDelete = [SELECT Id, Name, Type__c, Amount__c, Price__c, 
                                                      		Added_date__c, Release_Date__c, InStock__c 
                                                      		FROM Product_Item__c ORDER BY Added_Date__c ASC];
        
        System.assertNotEquals(productsFromOrg, productsFromOrgAfterDelete);
        System.assertEquals(productsFromOrg.size(), productsFromOrgAfterDelete.size() + 1);        
    }
    
    // Test search by Added Date
    @isTest static void testSearchByAddedDate() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc);
                
    	// new Product_Item__c(Name = 'Meizu MX4', Amount__c = 50, Price__c = 190.00, Type__c = 'Mobile Phone', Release_Date__c = date.parse('05/01/2018'), Added_Date__c = date.parse('05/05/2018'))
    	controller.searchAddedDate = date.parse('05/05/2018');
        controller.searchTitle = null;
        
        Test.startTest();
        controller.searchProduct();
        Test.stopTest();
        
        List<Product_Item__c> foundProduct = controller.getProduct();
        
        System.assertEquals(1, foundProduct.size());
        
        System.assertEquals('Meizu MX4', foundProduct[0].Name);
        System.assertEquals(50, foundProduct[0].Amount__c);
        System.assertEquals(190.00, foundProduct[0].Price__c);
        System.assertEquals('Mobile Phone', foundProduct[0].Type__c);
        System.assertEquals(Date.parse('05/01/2018'), foundProduct[0].Release_Date__c);
        System.assertEquals(true, foundProduct[0].InStock__c);        
    }
    
    // Test search by product name of part of product name (title)
    @isTest static void testSearchByProductTitleOrItsPart() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc);
                
    	//new Product_Item__c(Name = 'Thunderobot 911GT-Y6', Amount__c = 10, Price__c = 3193.33, Type__c = 'Laptop', Release_Date__c = date.parse('05/19/2018'), Added_Date__c = date.parse('05/22/2018'))    	
    	controller.searchAddedDate = null;
        controller.searchTitle = 'robot';
        
        Test.startTest();
        controller.searchProduct();
        Test.stopTest();
        
        List<Product_Item__c> foundProduct = controller.getProduct();
        
        System.assertEquals(1, foundProduct.size());
        
        System.assertEquals('Thunderobot 911GT-Y6', foundProduct[0].Name);
        System.assertEquals(10, foundProduct[0].Amount__c);
        System.assertEquals(3193.33, foundProduct[0].Price__c);
        System.assertEquals('Laptop', foundProduct[0].Type__c);
        System.assertEquals(Date.parse('05/19/2018'), foundProduct[0].Release_Date__c);
        System.assertEquals(true, foundProduct[0].InStock__c);
    }
    
    // Test search by both product name(or its part) and added date
    @isTest static void testSearchProductByNameAndAddedDate() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc);
                
    	//new Product_Item__c(Name = 'Thunderobot 911GT-Y6', Amount__c = 10, Price__c = 3193.33, Type__c = 'Laptop', Release_Date__c = date.parse('05/19/2018'), Added_Date__c = date.parse('05/22/2018'))
    	//new Product_Item__c(Name = 'Meizu Pro 6', Amount__c = 600, Price__c = 299.99, Type__c = 'Mobile Phone', Release_Date__c = date.parse('05/04/2018'), Added_Date__c = date.parse('05/22/2018'))    	
    	controller.searchAddedDate = date.parse('05/22/2018');
        controller.searchTitle = 'ro';
        
        Test.startTest();
        controller.searchProduct();
        Test.stopTest();
        
        List<Product_Item__c> foundProduct = controller.getProduct();
        
        System.assertEquals(2, foundProduct.size());
        
        System.assertEquals('Meizu Pro 6', foundProduct[0].Name);
        System.assertEquals(600, foundProduct[0].Amount__c);
        System.assertEquals(299.99, foundProduct[0].Price__c);
        System.assertEquals('Mobile Phone', foundProduct[0].Type__c);
        System.assertEquals(Date.parse('05/04/2018'), foundProduct[0].Release_Date__c);
        System.assertEquals(true, foundProduct[0].InStock__c);
        
        System.assertEquals('Thunderobot 911GT-Y6', foundProduct[1].Name);
        System.assertEquals(10, foundProduct[1].Amount__c);
        System.assertEquals(3193.33, foundProduct[1].Price__c);
        System.assertEquals('Laptop', foundProduct[1].Type__c);
        System.assertEquals(Date.parse('05/19/2018'), foundProduct[1].Release_Date__c);
        System.assertEquals(true, foundProduct[1].InStock__c);
    }
    
    // Test empty search request
    @isTest static void testEmptySearchRequest() {
        List<Product_Item__c> products = Test_helper.getProductList();
        Database.SaveResult[] saveProductsResult = Database.insert(products, true);
        
    	ApexPages.StandardController sc = new ApexPages.StandardController(new Product_Item__c());
        Controller_ProductListVisualforcePage controller = new Controller_ProductListVisualforcePage(sc);
                    		
    	controller.searchAddedDate = null;
        controller.searchTitle = null;
        
        Test.startTest();
        controller.searchProduct();
        Test.stopTest();
        
        System.assertEquals(10, controller.getProduct().size());
        
        List<Product_Item__c> foundProduct = controller.getProduct();
        System.assertEquals(10, foundProduct.size());
    }
}