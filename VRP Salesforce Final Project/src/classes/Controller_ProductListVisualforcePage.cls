public with sharing class Controller_ProductListVisualforcePage {
	@TestVisible private String sortOrder = 'Name';
    @TestVisible private Integer size = 10;
    
    @TestVisible private ApexPages.StandardSetController setNumberOfPageItems {
        get {
            if(setNumberOfPageItems == null) {
                setNumberOfPageItems = new ApexPages.StandardSetController(
                    Database.getQueryLocator('SELECT Id, Name, Type__c, Amount__c, Price__c, Added_date__c, Release_Date__c, InStock__c FROM Product_Item__c' + soqlWhere + 'ORDER BY ' + sortOrder + ' ASC LIMIT 100'));
                setNumberOfPageItems.setPageSize(size);                
            }
            return setNumberOfPageItems;
        }
        set;        
    }
    
    // Product records to visualforce page
    public List<Product_Item__c> getProduct() {
        return (List<Product_Item__c>) setNumberOfPageItems.getRecords();
    }
    
    private void RerenderPage() {
        this.setNumberOfPageItems = null;
    }    
    
    // Sort by all Fields
    public void sort(string modifier) {
        this.sortOrder = modifier;
        this.RerenderPage();
    }
    public void sortByName() {
        this.sort('Name');        
    }
	public void sortByType() {
        this.sort('Type__c');        
    }      
    public void sortByPrice() {
        this.sort('Price__c');        
    }
    public void sortByAmount() {
        this.sort('Amount__c');
    }  
    public void sortByAddedDate() {
        this.sort('Added_Date__c');
    }
    public void sortByReleaseDate() {
        this.sort('Release_Date__c');        
    }
    
    // Pagination
    public Boolean hasNext {
        get {
            return setNumberOfPageItems.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setNumberOfPageItems.getHasPrevious();
        }
        set;
    }
    
    public void First() {
        setNumberOfPageItems.first();
    }
    public void Previous() {
        setNumberOfPageItems.previous();
    }
    public void Next() {
        setNumberOfPageItems.next();
    }
    public void Last() {
        setNumberOfPageItems.last();
    }
    
    
    // Add New Record Popup
    public Boolean displayAddPopup { get; set; }
    
    public void closeAddPopup() {
        displayAddPopup = false;
    }
    public void showAddPopup() {
        displayAddPopup = true;
    }
    
    // Delete Record Popup
    public Boolean displayDeletePopup { get; set; }
    
    public void closeDeletePopup() {
        displayDeletePopup = false;
    }
    public void showDeletePopup() {
        displayDeletePopup = true;
    }
    
    
    // Add New record
    public Product_Item__c newProduct { get; set;}    
    public Date added_date { get; set;}
    public Date release_date { get; set;}    
    
    public Controller_ProductListVisualforcePage(ApexPages.StandardController controller) {       
        newProduct = (Product_Item__c)controller.getRecord();      
    }
    
    @TestVisible private transient Database.SaveResult productSaveResult;
    public void addNewProduct() {       
        
        if(newProduct.Name == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,' Please fill in at least a Name field!'));
			return;            
        }
        
        newProduct.Release_Date__c = release_date;        
        newProduct.Added_Date__c = added_date;
        
    	try{
        	productSaveResult = Database.insert(newProduct, true);
        }
    	catch(DMLException e) {	// catch validation rule
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, e.getDmlMessage(0)));            
        }
        catch(Exception ex) { // catch other possible exceptions
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, ex.getMessage()));            
        }
        
        this.RerenderPage();
        this.closeAddPopup();
        newProduct = new Product_Item__c();
    }
    
    // Delete record
    @TestVisible private transient Database.DeleteResult productDeleteResult;
    public Id productId { get; set; }
    
    public void deleteProduct() {
        
        if(productId == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'productId == null!'));
            return;
        }
        
        List<Product_Item__c> productToDelete = [select Id from Product_Item__c where Id =: productId];
        
        if(productToDelete.size() > 0) {
            productDeleteResult = Database.delete(productToDelete[0], true);
        }
        if(productDeleteResult.isSuccess()) {
            this.RerenderPage();
			this.closeDeletePopup();            
        }
    }
    
    // Search
    public Date searchAddedDate { get; set; } 
    public String searchTitle { get; set; }
    
    private String soqlWhere = ' ';
        
    public void searchProduct() {
        if(searchAddedDate != null && searchTitle != null) {
            // If user fill up both of search fields
        	searchTitle = String.escapeSingleQuotes(searchTitle.trim());
            
            soqlWhere = ' WHERE Added_Date__c =: searchAddedDate AND Name LIKE ' + '\'%' + searchTitle + '%\'' + ' ';
            this.RerenderPage();
            
        } else if (searchAddedDate != null && searchTitle == null) {
            // If user fill up only Added Date search field
            soqlWhere = ' WHERE Added_Date__c =: searchAddedDate ';
            this.RerenderPage();
                       
        } else if (searchAddedDate == null && searchTitle != null) {
            // If user fill up only Product Name search field
            searchTitle = String.escapeSingleQuotes(searchTitle.trim());
            
            soqlWhere = ' WHERE Name LIKE ' + '\'%' + searchTitle + '%\'' + ' ';            
            this.RerenderPage(); 
            
        } else if(searchAddedDate == null && searchTitle == null) { 
            // If search fields are empty - "soqlWhere" variable dont change and = ' '
            this.RerenderPage();
        }        
    }
}