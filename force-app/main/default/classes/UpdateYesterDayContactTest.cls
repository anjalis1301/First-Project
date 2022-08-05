/*************************************************************************************@@
Class Name     :  UpdateYesterDayContactTest
Purpose        :  Test class for the class UpdateYesterDayContact
DATE           :  08/02/2021
Author         :  Anjali Sharma
*********************************************************************************************************/

@isTest
private class UpdateYesterDayContactTest {
    /**
    *   @method testUpdateContact
    *   method to test vaild data being updated
    */
	@isTest
    static void testUpdateContact() {
        Contact con = new Contact(LastName='Test Contact',FirstName = '1',Last_Change__c=Datetime.valueOf('2021-02-02 05:50:22'),Description='Hello');
        insert con;
        Datetime backDate = Datetime.now().addDays(-1);
        Test.setCreatedDate(con.Id, backDate);     
        Test.startTest();
        ID batchId = Database.executeBatch(new UpdateYesterdayContacts());
        Test.stopTest();
        Contact con1 = [SELECT Id,LastName,Status__c,CreatedDate FROM Contact where LastName='Test Contact'];
        System.assertEquals(con1.Status__c,'Ready For Approval');
    }
     /**
    *   @method testBatchScheduling
    *   method to test scheduling of batch
    */
    @isTest
    static  void testBatchScheduling() {
        Test.StartTest();
        UpdateYesterdayContacts schdule = new UpdateYesterdayContacts();
        String cronExp = '55 5 10 * * ?';
        system.schedule('Update Contact', cronExp, schdule );
        Test.stopTest();
    }
}