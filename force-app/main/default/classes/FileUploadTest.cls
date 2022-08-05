/*************************************************************************************@@
Class Name     :  FileUploadTest
Purpose        :  Test class for the class FileUploadController
DATE           :  22/01/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
@isTest 
public class FileUploadTest 
{
    @isTest
	static void testInsert() {
        Test.StartTest(); 
		Account testAccount = new Account();
		testAccount.Name='Test Account' ;
		insert testAccount;

        String name = 'Unit Test Attachment';
        String Body = 'Unit Test Attachment Body';
        Map<String,String> obj = new Map<String,String>();
        obj.put(name,Body);
        String objS = JSON.serialize(obj);
        FileUploadController.attachBlob(testAccount.id,objS);
    	Attachment a = [SELECT Name FROM Attachment WHERE parentId = :testAccount.id];
     	System.assertEquals(a.Name,'Unit Test Attachment');
     	name = '';
     	obj.put(name,body);
       	objS = JSON.serialize(obj);
      	FileUploadController.attachBlob(testAccount.id,objS);
     	
		Test.StopTest();
	}
}