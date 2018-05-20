public with sharing class TriggerHandler {
    public static void CreateNewProductTables(List<Product_Table__c> incomingProductTables) {
        
    	Org_Configuration__c configuration = Org_Configuration__c.getInstance();
        Integer periodTerm = configuration.Period_Term__c != NULL ? Integer.valueOf(configuration.Period_Term__c) : 0;
        
        // Все имеющиеся в орге рекорды Warehouse.
        Warehouse_Name__c[] warehouses = [SELECT Id, Name, Period_Start__c, Period_End__c FROM Warehouse_Name__c ORDER By Period_Start__c];
        
        // Список Warehouse, которые подходят по параметрам : 
        // Warehouse_Name__c.Period_Start__c <= Product_Table.Added_Date__c &
        // Warehouse_Name__c.Period_End__c >= Product_Table.Added_Date__c
        List<Warehouse_Name__c> approachCriteriaWhs = new List<Warehouse_Name__c>();
        
        // Список новых Warehouse, которые создаются если подходящих по параметрам нет
        List<Warehouse_Name__c> whsToInsert = new List<Warehouse_Name__c>();
        
        // Список Product_Table__c для которых необходимо создавать новые Warehouse
        List<Product_Table__c> newWhRequiredProductTables = new List<Product_Table__c>();
        
        for(Product_Table__c product : incomingProductTables) {
            for(Integer i = 0; i < warehouses.size(); i++) {
                if(product.Added_Date__c == null) product.Added_Date__c = System.Date.today();
                if(warehouses[i].Period_Start__c <= product.Added_Date__c && warehouses[i].Period_End__c >= product.Added_Date__c) {
                    approachCriteriaWhs.Add(warehouses[i]);         	 					// Помещаем рекорды соответствующие условиям в отдельный список.                    
                }                 
                if(i == warehouses.size() - 1 && !approachCriteriaWhs.isEmpty()) {
                    product.Warehouse__c = approachCriteriaWhs[0].Id;    					// Добавляем к первому в массиве Warehouse данный Product_Table__c              
                    approachCriteriaWhs.clear();                         					// Oбнуляем список Warehouse соотв условиям, т.к. он должен быть уникальным для каждого Product_Table__c
                } else if(i == warehouses.size() - 1 && approachCriteriaWhs.isEmpty()) {	// Если просмотрен весь массив Warehouse, но нет записей
                    newWhRequiredProductTables.add(product);			 					// Пополняем список Product_Table__c для которых будут создаваться новые Warehouse
                }
            }
        }
        
        // Пробегаемся по списку оставшихся Product_Table__c и каждому создаем Warehouse
        for(Product_Table__c product : newWhRequiredProductTables) {
            Date aDate = product.Added_Date__c;                    
            aDate = aDate.addDays(periodTerm);
            
            Warehouse_Name__c newWarehouse = new Warehouse_Name__c(Name = 'Warehouse ' + product.Added_Date__c + ' ' + product.Added_Date__c + ' ' + periodTerm,
                                                                   Period_Start__c = product.Added_Date__c, 
                                                                   Period_End__c = aDate);
            // Помещаем в список подлежащих инсерту.
            whsToInsert.Add(newWarehouse);
        }
        insert whsToInsert;
        
        // Пробегаемся по списку оставшихся Product_Table__c и каждому заполняем связь Id соответствующего Warehouse
        for(Integer i = 0; i < newWhRequiredProductTables.size(); i++) {
            newWhRequiredProductTables[i].Warehouse__c = whsToInsert[i].Id;
        }
        
        // Отражаем в логе создание новых Warehouse_Name__c        
        System.debug('New Warehous objects was successfully created');
        System.debug('Number of records: ' + whsToInsert.size());
        for(Warehouse_Name__c wh : whsToInsert) {
            System.debug('Name: ' + wh.Name);
            System.debug('Period Start : ' + wh.Period_Start__c + ' , Period End : ' + wh.Period_End__c);
        }
        System.debug('-----------------------');
    }
}