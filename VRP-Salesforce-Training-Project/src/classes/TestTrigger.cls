@isTest(SeeAllData=true)
public class TestTrigger {
    // Тест работы методов InsertWarehouseData() & InsertProductTableData() класса TestHelper
    @isTest static void testTestDataClassInsertMethods() {
        Warehouse_Name__c[] warehouses = TestHelper.InsertWarehouseData();  
        Product_Table__c[] productTables = TestHelper.InsertProductTableData();
        
        System.assert(warehouses.size() > 0);
        System.assert(productTables.size() > 0);
    }

    // Тест сохранения списка Warehouse
    @isTest static void testBulkWarehouseSave() {
        Warehouse_Name__c[] warehouses = TestHelper.InsertWarehouseData();
        
        Test.startTest();
        Database.SaveResult[] result = Database.insert(warehouses, false);
        Test.stopTest();
        
        for(Database.SaveResult dbsr : result) {
            System.assert(dbsr.isSuccess());
        	System.assert(dbsr.getErrors().size() == 0);
        }
    }
    
    // Тест сохранения списка Product Table
    @isTest static void testBulkProductTableSave() {
        Warehouse_Name__c[] warehouses = TestHelper.InsertWarehouseData();
        insert warehouses;
        
        Product_Table__c[] productTables = TestHelper.InsertProductTableData();
        
        Test.startTest();
        Database.SaveResult[] result = Database.insert(productTables, false);
        Test.stopTest();
        
        for(Database.SaveResult dbsr : result) {
            System.assert(dbsr.isSuccess());
            System.assert(dbsr.getErrors().size() == 0);
        }
    }
    
    // Тест каскадного удаления Product Table при удалении Warehouse
    @isTest static void DeleteProductTablesThroughtWarehouseMasterDetail() {
      	Warehouse_Name__c[] warehouses = TestHelper.InsertWarehouseData();
        insert warehouses;
        
        Product_Table__c[] productTables = TestHelper.InsertProductTableData();
        insert productTables;        
        
        Test.startTest();
        Database.DeleteResult[] result = Database.delete(warehouses, false);
        Test.stopTest();
        
        for(Database.DeleteResult dbdr : result) {
            System.assert(dbdr.isSuccess());
            System.assert(dbdr.getErrors().size() == 0);
        }
    }
    
    // Тест сохранения Product Table в существующий в орге Warehouse
    @isTest static void testSaveProductTableInExistingWarehouse() {
        Warehouse_Name__c warehouse = new Warehouse_Name__c(Name = 'Warehouse 1', Period_Start__c = date.parse('04/29/2018'), Period_End__c = date.parse('05/05/2018'));
        insert warehouse;
        
        Product_Table__c productTable = new Product_Table__c(Name = 'Product Table 1', Added_Date__c = date.parse('05/01/2018'), Unit_Price__c = 1000.00);
        insert productTable;
        
        Product_Table__c[] product = [select Id, Name, Product_Table__c.Warehouse__c from Product_Table__c where Name = 'Product Table 1'];
        
        System.assertEquals(warehouse.Id, product[0].Warehouse__c);
    }
    
    // Тест создания нового Warehouse при сохранении Product Table
    @isTest static void testSaveProductTableInNewCreatedWarehouse() {
                
        // В этот Warehouse создаваемый Product_Table НЕ должен попасть.
        Warehouse_Name__c warehouse = new Warehouse_Name__c(Name = 'Warehouse 1', Period_Start__c = date.parse('04/29/2018'), Period_End__c = date.parse('05/01/2018'));
        insert warehouse;
        Id Wh_Id = warehouse.Id;
        
        // Создаваемый Product_Table.
        Product_Table__c productTable = new Product_Table__c(Name = 'Product Table 1', Added_Date__c = date.parse('05/21/2018'), Unit_Price__c = 2000.00);
        insert productTable;
                
        // Получаем заинсерченный Product_Table и список Warehouse 
        Warehouse_Name__c[] warehousesInOrg = [select Id, Name, Period_Start__c, Period_End__c from Warehouse_Name__c];
        Product_Table__c[] product = [select Id, Name, Added_Date__c, Product_Table__c.Warehouse__c from Product_Table__c where Name = 'Product Table 1'];
        
        // Список, в который мы получим автоматически созданный триггером Warehouse
        List<Warehouse_Name__c> ExpectedWhList = new List<Warehouse_Name__c>();
        for(Warehouse_Name__c wh : warehousesInOrg) {
            if(wh.Id != Wh_Id && product[0].Warehouse__c == wh.Id) {
                ExpectedWhList.add(wh);
            }
        }
        
        Org_Configuration__c configuration = Org_Configuration__c.getInstance();
        Integer periodTerm = configuration.Period_Term__c != NULL ? Integer.valueOf(configuration.Period_Term__c) : 0;
        Date aDate = product[0].Added_Date__c;                    
        aDate = aDate.addDays(periodTerm);
         
        System.assert(ExpectedWhList.size() == 1);       					 // Подтверждение того, что создался новый Warehouse 
        System.assertEquals(ExpectedWhList[0].Id, product[0].Warehouse__c);  // Подтверждение того, что Id нового Warehouse == связи созданного Product Table 1
        // Подтверждение того, что Name нового Warehouse == формуле, определеннойв алгоритме триггера на основе Product Table 1
        System.assertEquals('Warehouse 2018-05-21 00:00:00 2018-05-21 00:00:00 1', ExpectedWhList[0].Name);
        // Подтверждение того, что Period_Start__c нового Warehouse == Product Table 1.Added_Date__c
        System.assertEquals(product[0].Added_Date__c, ExpectedWhList[0].Period_Start__c);					
        // Подтверждение того, что Period_End__c нового Warehouse == Product Table 1.Period_End__c + Org_Configuration__c.Period_Term__c
        System.assertEquals(aDate, ExpectedWhList[0].Period_End__c); 
        System.assertNotEquals(Wh_Id, productTable.Warehouse__c);	// Подтверждение того, что Id Warehouse 1 !=  связи созданного Product Table 1
    }
}