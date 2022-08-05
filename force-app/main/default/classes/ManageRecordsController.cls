public with sharing class ManageRecordsController {  
    @AuraEnabled(cacheable = true)  
    public static List<Account> getAccountsList(Integer pagenumber, Integer numberOfRecords, Integer pageSize, String searchString) {  
      String searchKey = '%' + searchString + '%';  
      String query = 'select id from Case ';  
       
      query += ' limit ' + pageSize + ' offset ' + (pageSize * (pagenumber - 1));  
      return Database.query(query);  
    }  
    @AuraEnabled(cacheable = true)  
    public static Integer getAccountsCount(String searchString) {  
      String query = 'select count() from Case ';  
       
      return Database.countQuery(query);  
    }  
  }