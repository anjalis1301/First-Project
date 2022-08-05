/*************************************************************************************@@
ClassName	: ServerSidePagination
Author		: Anjali Sharma
CreateDate	: 01/03/2021
Purpose		: To query the accounts data and return it to the component
*************************************************************************************/
public  with sharing class ServerSidePagination {
    
    @AuraEnabled public static Integer totalCount() {
      
        return [SELECT count() FROM Account];
    }
     /**
    *   @method getRecords
    *   Remote method to return accountRecordsWrapper to the component controller
    * 	    
    */
    @AuraEnabled 
    public static RecordsWrapper getRecords(Integer pageNumber ,String lastId,Integer recordToDisplay, String sortColName, String sortDirection) {
       
        RecordsWrapper recObj = new RecordsWrapper(); 
        recObj.recPerPage = recordToDisplay; 
        recObj.currentPageNo = pageNumber; 
        System.debug('**** Offset '+(pageNumber - 1) * recordToDisplay);
        String subQuery = 'SELECT Id FROM Account LIMIT '+recordToDisplay+' OFFSET '+ (pageNumber - 1) * recordToDisplay;
        List<Account> subQueryIds = new List<Account>();
        subQueryIds = Database.query(subQuery);
        String query = 'SELECT Id, Name, Phone, Website, Industry FROM Account WHERE ID IN :subQueryIds ORDER BY '	+sortColName +' '+ sortDirection+'LIMIT 50000';
        //+' LIMIT '+recordToDisplay +' OFFSET '+ (pageNumber - 1) * recordToDisplay;
        System.debug('q'+query);
        recObj.recordsList = Database.query(query);
        System.debug('res'+recObj.recordsList);
        return recObj; 
        /*RecordsWrapper recObj = new RecordsWrapper(); 
        
        recObj.recPerPage = recordToDisplay;
        
        recObj.currentPageNo = pageNumber; 
        
       
       // recObj.totalAccRecords = Integer.valueof(countResult[0].get('totalCount')); 
        System.debug('**** Offset '+(pageNumber - 1) * recordToDisplay+'   @@@@@ '+lastId );
        
        String subQuery = 'SELECT Id FROM Account WHERE Id > :lastId ORDER BY Id  LIMIT '+recordToDisplay;
        List<Account> subQueryIds = new List<Account>();
        subQueryIds = Database.query(subQuery);
        String query = 'SELECT Id, Name, Phone, Website, Industry,CreatedDate FROM Account WHERE ID IN :subQueryIds ORDER BY '	+sortColName +' '+ sortDirection;
        //+' LIMIT '+recordToDisplay +' OFFSET '+ (pageNumber - 1) * recordToDisplay;
        System.debug('q'+query);
        recObj.recordsList = Database.query(query);
        System.debug('res'+recObj.recordsList);
        return recObj; */
    } 
     
    // create a wrapper class with @AuraEnabled Properties     
    public class RecordsWrapper {
        @AuraEnabled public Integer recPerPage;
        @AuraEnabled public Integer currentPageNo;  
       // @AuraEnabled public Integer totalAccRecords; 
        @AuraEnabled public List<Account> recordsList;  
    } 
}