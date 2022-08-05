@isTest
public class ContactSequenceTest {
     @testSetup
    static void setup(){
        List<Account> acc = ContactSequenceDataFactory.accountsAndCon(2,5);     
    }

    @isTest static void testafterInsert() {
        Test.startTest();
		Contact con = [SELECT Id, LastName, Sequence_Number__c, AccountId FROM Contact WHERE Sequence_Number__c = 1 AND Account.Name = 'Account 0'];
        System.assertEquals(con.LastName == 'c1', true);
        Test.stopTest();
    }
    
     @isTest static void testafterDeleteRecords() {
        Test.startTest();
        Contact con = [SELECT Id, LastName, Sequence_Number__c, AccountId FROM Contact WHERE Sequence_Number__c = 2 AND Account.Name = 'Account 0'];
        delete con;
        Contact con1 = [SELECT Id, LastName, Sequence_Number__c, AccountId, isDeleted FROM Contact WHERE LastName = 'c3' AND Account.Name = 'Account 0' ALL ROWS];
        System.assertEquals(con1.Sequence_Number__c, 2);
        Test.stopTest();
    }
    
    @isTest static void testafterContactUndelete() {
        Contact con = [SELECT Id, LastName, Sequence_Number__c, AccountId FROM Contact WHERE Sequence_Number__c = 3 AND Account.Name = 'Account 0'];
        delete con;
        Test.startTest();
        Contact con1 = [SELECT Id,LastName, Sequence_Number__c, AccountId FROM Contact WHERE LastName = 'c3' AND Account.Name = 'Account 0' ALL ROWS];
        Database.undelete(con1.id);
        Test.stopTest();
        Contact con2 = [SELECT Id,LastName, Sequence_Number__c, AccountId FROM Contact WHERE LastName = 'c3' AND Account.Name = 'Account 0'];
        System.assertEquals(con2.Sequence_Number__c, 5);
        
    }
    
    @isTest static void testbeforeUpdateRecords() {
    	Test.startTest();
        Contact con = [SELECT Id, LastName, Sequence_Number__c, AccountId FROM Contact WHERE Sequence_Number__c = 3 AND Account.Name = 'Account 0'];
 		Contact conAcc2 = [SELECT Id, LastName, Sequence_Number__c, AccountId FROM Contact WHERE LastName = 'c1' AND Account.Name = 'Account 1'];
        Id acc2Id = conAcc2.AccountId;
        System.debug(acc2Id);
        con.AccountId = acc2Id;
        System.debug('con '+con.AccountId);
        update con;
        Contact conQ = [SELECT Id, LastName, Sequence_Number__c, AccountId FROM Contact WHERE LastName = 'c4' AND Account.Name = 'Account 0'];
        System.assertEquals(conQ.Sequence_Number__c , 3);
        Test.stopTest();
    }
    
    @isTest static void testafterUpdateRecords() {
        Test.startTest();
        Contact con = [SELECT Id, LastName, Sequence_Number__c, AccountId FROM Contact WHERE Sequence_Number__c =2 AND Account.Name = 'Account 0' ORDER BY Sequence_Number__c];
        con.Sequence_Number__c = 4;
        update con;
       Contact con1 = [SELECT Id, LastName, Sequence_Number__c, AccountId FROM Contact WHERE LastName = 'c4'AND Account.Name = 'Account 0'];
        System.assertEquals(con1.Sequence_Number__c, 3);
        con1.Sequence_Number__c = 1;
        update con1;
        List<Contact> conQ = [SELECT Id, LastName, Sequence_Number__c, AccountId FROM Contact WHERE Account.Name = 'Account 0'];
        System.debug('conq'+conQ);
        Test.stopTest();
    }
}