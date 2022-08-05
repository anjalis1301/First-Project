/*************************************************************************************@@
Class Name     :  LazyLoadingTest
Purpose        :  Test class for the class LazyLoadingController
DATE           :  10/03/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
@isTest
private class LazyLoadingTest {
    @TestSetup
    static void makeData(){
       List <Account> acc = new List<Account>();
       for(integer i = 1; i<= 10 ; i++) {
            acc.add(new Account(Name='Acc'+i));
       }
       insert acc;
       
    }
    
	@isTest
     private static void dataTest() {
        Account acc = [SELECT Id,Name FROM Account WHERE Name = 'Acc4'];
       
        Test.startTest();
        Integer count = LazyLoadingController.totalCount();
        System.assertEquals(count,10);
        List<Account> accList =  LazyLoadingController.fetchList(acc.Id);
        System.assertEquals(accList.size(), 6);
        Test.stopTest();
    }
}