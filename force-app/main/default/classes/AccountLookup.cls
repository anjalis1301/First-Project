/*************************************************************************************@@
ClassName	: AccountLookup
Author		: Anjali Sharma
CreateDate	: 23/03/2021
Purpose		: To query the contact and update its fields
*************************************************************************************/
public with sharing class AccountLookup {

    @AuraEnabled 
    public static Account getRecord(String accId) {
        String query = 'SELECT Name, (SELECT Id,LastName, FirstName, Email, Name FROM Contacts LIMIT 1) FROM Account WHERE Id = :accId LIMIT 1';
        return Database.query(query);         
    }
    
    @AuraEnabled
    public static void updateCon(sObject conObj,String accId) {
        conObj.put('AccountId',accId);
        update conObj;
    }
}