/*************************************************************************************@@
Class Name     :  KanbanLWCTest
Purpose        :  Test class for the class KanbanLWC
DATE           :  20/05/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
@isTest
private class KanbanLWCTest {
    
    //method to test if data is fetched correctly
    @isTest
    private static void dataTest(){
        Account ac = new Account(Name='Test1',Type='Prospect',Rating='Hot');        
        Account ac1 = new Account(Name='Test2',Type='Customer-Direct',Rating='Warm');
        insert ac;
        insert ac1;
        Test.startTest();
        List<String> fld = new List<String>();
        fld.add('Name,Rating');
        Map<String,List<Account>> accListMap = KanbanLWC.getData('Account', fld, 'Type');
        System.assertEquals(accListMap.get('Prospect').size(),1);
		Test.stopTest();        
    }
    
    //method to test if data is updated 
    @isTest
    private static void updateTest() {
        Account ac = new Account(Name='Test1',Type='Prospect',Rating='Hot'); 
        insert ac;
        Test.startTest();
        KanbanLWC.updatePickVal(ac.Id, 'Type', 'Customer-Direct'); 
        Account acChk = [SELECT Id,Name,Type FROM Account WHERE Name='Test1'];
        System.assertEquals(acChk.Type, 'Customer-Direct');
        Test.stopTest();
    }
}