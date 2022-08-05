/*************************************************************************************@@
Class Name     :  KanbanViewTest
Purpose        :  Test class for the class KanbanView
DATE           :  16/03/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
@isTest
private class KanbanViewTest {
    
    //method to test if objects names are fetched correctly and selected object fieldsand picklist fields are fetched correctly
    @isTest
    private static void objTest() {
        Account ac = new Account(Name='Test1');
        insert ac;
        KanbanView knbn = new KanbanView();
        Map<String,String> data = KanbanView.objectNames();
        System.assertNotEquals(data.size(), 0);
        Map<String,String> fldMap = KanbanView.fieldsAndPkLst('Account').fieldMap;
        System.assertNotEquals(fldMap.size(), 0);
        Map<String,String> pickList =  KanbanView.fieldsAndPkLst('Account').pickLst;
        System.assertNotEquals(pickList.size(), 0);
    }
    
    //method to test if data is fetched correctly
    @isTest
    private static void dataTest(){
        Account ac = new Account(Name='Test1',Type='Prospect',Rating='Hot');        
        Account ac1 = new Account(Name='Test2',Type='Customer-Direct',Rating='Warm');
        insert ac;
        insert ac1;
        List<String> fld = new List<String>();
        fld.add('Name,Type,Rating');
        List<Account> accList = KanbanView.getData('Account', fld, 'Type').objRecords;
        System.assertEquals(accList.size(),2);
    }
    
    //method to test if data is updated 
    @isTest
    private static void updateTest() {
        Account ac = new Account(Name='Test1',Type='Prospect',Rating='Hot'); 
        insert ac;
        Test.startTest();
        KanbanView.updatePickVal(ac.Id, 'Type', 'Customer-Direct', 'Account', ''); 
        Account acChk = [SELECT Id,Name,Type FROM Account WHERE Name='Test1'];
        System.assertEquals(acChk.Type, 'Customer-Direct');
        Test.stopTest();
    }
}