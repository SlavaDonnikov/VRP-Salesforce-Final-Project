@isTest	// Класс с методами, создающими данные для тестового класса с тестовыми методами.
public class TestHelper {
@isTest	public static List<Warehouse_Name__c> InsertWarehouseData() {
        List<Warehouse_Name__c> whList = new List<Warehouse_Name__c> { 
        	new Warehouse_Name__c(Name = 'Sklad1', Period_Start__c = date.parse('12/01/2017'), 
                          					   	   Period_End__c = date.parse('01/02/2018')),
   			new Warehouse_Name__c(Name = 'Sklad2', Period_Start__c = date.parse('02/01/2018'), 
                          					   	   Period_End__c = date.parse('02/20/2018')),
    		new Warehouse_Name__c(Name = 'Sklad3', Period_Start__c = date.parse('03/01/2018'), 
                          					   	   Period_End__c = date.parse('04/01/2018'))};
 		return whList;   		
    }
    
@isTest public static List<Product_Table__c> InsertProductTableData() {        
		List<Product_Table__c> ptList = new List<Product_Table__c> {
    	new Product_Table__c(Name = 'Product Table 1', Added_Date__c = date.parse('01/01/2018'), Unit_Price__c = 500.50),  // Должен попасть в Sklad1      
    	new Product_Table__c(Name = 'Product Table 2', Added_Date__c = date.parse('02/10/2018'), Unit_Price__c = 1000.33), // Должен попасть в Sklad2       
    	new Product_Table__c(Name = 'Product Table 3', Added_Date__c = date.parse('02/19/2018'), Unit_Price__c = 1200.77), // Должен попасть в Sklad2
        new Product_Table__c(Name = 'Product Table 4', Added_Date__c = date.parse('03/10/2018'), Unit_Price__c = 1200.77), // Должен попасть в Sklad3 
    	new Product_Table__c(Name = 'Product Table 5', Added_Date__c = date.parse('04/05/2018'), Unit_Price__c = 1600.99), // Должен быть создан новый Warehouse       
    	new Product_Table__c(Name = 'Product Table 6', Added_Date__c = date.parse('04/20/2018'), Unit_Price__c = 1800.99), // Должен быть создан новый Warehouse
        new Product_Table__c(Name = 'Product Table 7', Added_Date__c = date.parse('05/01/2018'), Unit_Price__c = 1800.99)};// Должен быть создан новый Warehouse
            
 		return ptList;
    }
    
@isTest public static void DeleteData() {
        Warehouse_Name__c[] wh = [select Id from Warehouse_Name__c];
		if(!wh.isEmpty()) delete wh;
        System.debug('All Warehouse_Name__c and Product_Table__c records was successfully deleted from Org');
    }
}