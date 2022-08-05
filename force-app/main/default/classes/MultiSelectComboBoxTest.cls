/*************************************************************************************@@
Class Name     :  MultiSelectComboBoxTest
Purpose        :  Test class for the class MultiSelectComboBox
DATE           :  16/04/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
@isTest
private class MultiSelectComboBoxTest {
    
    //method to test if the account and its related contact are fetched correctly and contact recod has been updated correctly
    @isTest
    private static void objTest() {
        Account ac = new Account(Name='Test1');
        insert ac;
        Contact con = new Contact(LastName='Loss', FirstName='Bill',Test_Results__c='Positive',Recent_Visits__c='Jaipur',AccountId=ac.Id);
        insert con;
        Account acc = MultiSelectComboBox.getRecord(ac.Id);
        System.assertEquals(acc.Name,'Test1');
        con.Test_Results__c = 'Negative';
        MultiSelectComboBox.updateCon(con);
        System.assertEquals(con.Test_Results__c,'Negative');
    }
}