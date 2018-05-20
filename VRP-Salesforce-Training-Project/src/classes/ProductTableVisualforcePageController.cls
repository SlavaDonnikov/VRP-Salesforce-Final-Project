public class ProductTableVisualforcePageController {
	private string sortOrder = 'Name';
    
    public List<Product_Table__c> getProductTables() {
        return (List<Product_Table__c>) setPages.getRecords();               
    }
    
    public void sortByName() {
        this.sortOrder = 'Name';
        this.setPages = null;
    }
    
    public void sortByAddedDate() {
        this.sortOrder = 'Added_Date__c';
        this.setPages = null;
    }
    
    public void sortByUnitPrice() {
        this.sortOrder = 'Unit_Price__c';
        this.setPages = null;
    }
    
    public void sortByUnitsAvailable() {
        this.sortOrder = 'Units_Available__c';
        this.setPages = null;
    }
    
    // ------------------ Pagination ---------------------
    Public Integer size = 3; 
    
    public ApexPages.StandardSetController setPages {
        get {
            if(setPages == null) {             
                setPages = new ApexPages.StandardSetController(Database.getQueryLocator(
                'SELECT Id, Name, Image_Uri__c, Product_Description__c, Unit_Price__c, Units_Available__c, Added_Date__c ' + 
                'FROM Product_Table__c ' + 'ORDER BY ' + sortOrder + ' ASC' + ' LIMIT 100'));
                setPages.setPageSize(size);
            }
            return setPages;
        }
        set;
    }    
    
    public Boolean hasNext {
        get {
            return setPages.getHasNext();
        }
        set;
    }
 
    public Boolean hasPrevious {
        get {
            return setPages.getHasPrevious();
        }
        set;
    } 
 
    public void Previous() {
        setPages.previous();
    }
    
    public void Next() {
        setPages.next();
    }
    
    public void First() {
        setPages.first();
    }
    
    public void Last() {
        setPages.last();
    }
}