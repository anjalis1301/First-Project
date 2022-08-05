/*************************************************************************************@@
Class Name     :  LookUpControllerTest
Purpose        :  Test class for the class LookUpController
DATE           :  20/03/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
@isTest
private class LookUpControllerTest {
    
    //method to test if objects names are fetched correctly and selected object fieldsand picklist fields are fetched correctly
    @isTest
    private static void objTest() {
        Account ac = new Account(Name='Test1');
        insert ac;
        LookUpController look = new LookUpController();
        List<sobject> data = LookUpController.fetchRecords('tes','Account','Name');
        System.assertEquals(data.size(), 1);
    }
}