public with sharing class MultiSelectComboBox {
/*************************************************************************************@@
ClassName	: MultiSelectComboBox
Author		: Anjali Sharma
CreateDate	: 16/04/2021
Purpose		: To query the contact and update its fields
TestSuite   : MultiSelectComboBoxTest
*************************************************************************************/
    @AuraEnabled 
    public static Account getRecord(String accId) { 
        String query = 'SELECT Name, (SELECT Id,LastName, FirstName, Email, Name, Test_Results__c, Recent_Visits__c FROM Contacts LIMIT 1) FROM Account WHERE Id = :accId LIMIT 1';        
        return Database.query(query);
    }
    
    @AuraEnabled
    public static void updateCon(sObject conObj) {
        update conObj;
    }
    
    
}