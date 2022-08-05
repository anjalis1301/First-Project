/*************************************************************************************@@
Class Name     :  RecordsFromEmailTest
Purpose        :  Test class for the class RecordsFromEmail
DATE           :  05/02/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
@isTest
private class RecordsFromEmailTest {
    
    /**
    *   @method testEmailData
    *   method to test cases on a vaild records String
    */
    @isTest
    private static void testEmailData() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Records To Create';
        email.fromAddress = 'anjali@briskminds.com';
        email.plainTextBody = 'Contact#FirstName#Test#LAstNAme#Contact 1##Contact#LastName#Test Contact 2\n\n';
        RecordsFromEmail em = new RecordsFromEmail();
        em.handleInboundEmail(email, env);
        Contact con = [SELECT Id,FirstName,LastNAme FROM CONTACT WHERE FirstName = 'Test'];
        System.assertEquals(con.LastName, 'Contact 1');
        
    }
    
    @isTest
    private static void testEmailInvalidData() {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Records To Create';
        email.fromAddress = 'anjali@briskminds.com';
        email.plainTextBody = 'Conta#FirstName#Test#LAstNAme#Contact 1##Contact#LastName#Test Contact 2\n\n';
        RecordsFromEmail em = new RecordsFromEmail();
        Messaging.InboundEmailResult res = em.handleInboundEmail(email, env);
        System.assertEquals(res.success, false);
       
       email.plainTextBody = 'Contact#FirstName#Test#LAstNAme#Contact 1##Contact#LastName\n\n';
       em.handleInboundEmail(email, env);
       System.assertEquals(res.success, false);
    }
    
    
	
}