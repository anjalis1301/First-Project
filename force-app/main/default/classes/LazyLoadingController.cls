/*************************************************************************************@@
ClassName	: LazyLoadingController
Author		: Anjali Sharma
CreateDate	: 0/03/2021
Purpose		: To query the accounts data and return it to the component
*************************************************************************************/

public with sharing class LazyLoadingController {
    /**  @method totalCount
    *   Remote method to return total number of accounts to the component controller	    
    */
    @AuraEnabled public static Integer totalCount() {
        return [SELECT count() FROM Account];
    }
    
    /**  @method fetchList
    *   Remote method to return account Records to the component controller	    
    */
    @AuraEnabled public static List<sObject> fetchList(String lastID, String objName, String fields) {
        String query = 'SELECT '+fields +' FROM '+objName +' WHERE Id > :lastId ORDER BY Id LIMIT 20';
        List<sObject> accList = Database.query(query);
        return accList;
    }
}