/*************************************************************************************@@
ClassName	: LookUpController
Author		: Anjali Sharma
CreateDate	: 18/03/2021
Purpose		: To query the records based on search term and return it to the component
Test Suite  : LookUpControllerTest
*************************************************************************************/
public with sharing class LookUpController {

   @AuraEnabled
    public static List<sObject> fetchRecords(String searchTerm, String objectName, String fieldName) {
       String query = 'SELECT Id, Name FROM '+objectName+' WHERE '+fieldName+' LIKE \'%'+searchTerm+'%\' LIMIT 50000';
       return Database.query(query);
   }
}