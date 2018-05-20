@isTest(SeeAllData=true)
public class TestProductTableVisualforceController {
    
    // Tестирование вывода на страницу заданного кол-ва рекордов (size = 3)
    @isTest static void testGetProductTables() {
        ProductTableVisualforcePageController controller = new ProductTableVisualforcePageController();        
        System.assertEquals(3, controller.getProductTables().size());
    }
    
     // Testing Pagination ---------------------------->
    @isTest static void testPaginationFunctions() {
        
    	ProductTableVisualforcePageController controller = new ProductTableVisualforcePageController();
        
        controller.setPages = new ApexPages.StandardSetController(Database.getQueryLocator(
                'SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, Units_Available__c, Added_Date__c ' + 
                'FROM Product_Table__c ' + 'ORDER BY Name ASC LIMIT 100'));
        controller.setPages.setPageSize(6);
         
        System.assert(controller.hasNext);
        System.assert(!controller.hasPrevious);
        
        controller.Next();
        System.assert(controller.hasPrevious);
        System.assert(controller.hasPrevious);
        
        controller.First();
        controller.Last();
        controller.Previous();        
    }
    
    // Testing Sorting ---------------------------->
    @isTest static void testSortingByName() {
        ProductTableVisualforcePageController controller = new ProductTableVisualforcePageController(); 
        
        Test.startTest();
        controller.sortByName();
        Test.stopTest();
        
        List<Product_Table__c> productTablesFromOrg = [SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, Units_Available__c, Added_Date__c FROM Product_Table__c ORDER BY Name ASC LIMIT 3];
        
        System.assertEquals(productTablesFromOrg, controller.setPages.getRecords());
    }
    
    @isTest static void testSortingByAddedDate() {
        ProductTableVisualforcePageController controller = new ProductTableVisualforcePageController(); 
        
        Test.startTest();
        controller.sortByAddedDate();
        Test.stopTest();
        
        List<Product_Table__c> productTablesFromOrg = [SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, Units_Available__c, Added_Date__c FROM Product_Table__c ORDER BY Added_Date__c ASC LIMIT 3];
        
        System.assertEquals(productTablesFromOrg, controller.setPages.getRecords());
    }
    
    @isTest static void testSortingByUnitPrice() {
        ProductTableVisualforcePageController controller = new ProductTableVisualforcePageController(); 
        
        Test.startTest();
        controller.sortByUnitPrice();
        Test.stopTest();
        
        List<Product_Table__c> productTablesFromOrg = [SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, Units_Available__c, Added_Date__c FROM Product_Table__c ORDER BY Unit_Price__c ASC LIMIT 3];
        
        System.assertEquals(productTablesFromOrg, controller.setPages.getRecords());
    }
    
    @isTest static void testSortingByUnitsAvailable() {
        ProductTableVisualforcePageController controller = new ProductTableVisualforcePageController(); 
        
        Test.startTest();
        controller.sortByUnitsAvailable();
        Test.stopTest();
        
        List<Product_Table__c> productTablesFromOrg = [SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, Units_Available__c, Added_Date__c FROM Product_Table__c ORDER BY Units_Available__c ASC LIMIT 3];
        
        System.assertEquals(productTablesFromOrg, controller.setPages.getRecords());
    }
}