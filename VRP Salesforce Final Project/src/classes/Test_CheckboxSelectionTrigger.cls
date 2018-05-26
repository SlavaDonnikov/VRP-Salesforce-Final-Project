@isTest
public class Test_CheckboxSelectionTrigger {                            
    @isTest public static void SelectCheckbox() {
        List<Product_Item__c> testProducts = new List<Product_Item__c> {new Product_Item__c(Name = 'Product 1', Amount__c = 10), 
    																	new Product_Item__c(Name=  'Product 2'),
        																new Product_Item__c(Name = 'Product 3', Amount__c = 100),
        																new Product_Item__c(Name = 'Product 4'),
        																new Product_Item__c(Name = 'Product 5', Amount__c = 20),
        																new Product_Item__c(Name = 'Product 6')};
                                                                            
        Database.SaveResult[] TestProductsSaveResult = Database.Insert(testProducts, true);
        
        for(Database.SaveResult sr : TestProductsSaveResult) {
            System.assert(sr.isSuccess());
        }        
        
        
        List<Product_Item__c> productsWithSelectedCkeckbox = [select Id, Name, Amount__c, InStock__c from Product_Item__c where InStock__c = true];
        List<Product_Item__c> productsWithNotSelectedCkeckbox = [select Id, Name, Amount__c, InStock__c from Product_Item__c where InStock__c = false];
                
        System.assertEquals(3, productsWithSelectedCkeckbox.size());
        System.assertEquals(3, productsWithNotSelectedCkeckbox.size());
        
        for(Product_Item__c product : productsWithSelectedCkeckbox) {
            System.assert(product.Amount__c != 0);
            System.assert(product.Amount__c > 0);            
            System.assertNotEquals(null, product.Amount__c);
        }
        
        for(Product_Item__c product : productsWithNotSelectedCkeckbox) {
            System.assert(product.Amount__c == 0);                        
            System.assertNotEquals(null, product.Amount__c);
        }                                                                  
    } 
}