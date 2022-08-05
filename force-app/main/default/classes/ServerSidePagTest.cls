/*************************************************************************************@@
Class Name     :  ServerSidePagTest
Purpose        :  Test class for the class ServerSidePagination
DATE           :  03/03/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
@isTest
private class ServerSidePagTest {
     @TestSetup
    static void makeData(){
       List <Account> acc = new List<Account>();
       for(integer i = 1; i<= 10 ; i++) {
            acc.add(new Account(Name='Acc'+i));
       }
       insert acc;
       
    }
	@isTest
    private static void testPagination() {
        Test.startTest();
        ServerSidePagination.RecordsWrapper accWrap = ServerSidePagination.getRecords(1,'',10,'Name','asc');
        System.debug(accWrap);
        Test.stopTest();
    }
      
}