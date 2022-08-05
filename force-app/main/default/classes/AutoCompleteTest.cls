/*************************************************************************************@@
Class Name     :  FileUploadTest
Purpose        :  Test class for the class AutoCompleteComponentController
DATE           :  28/01/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
/*cancel on inline edit enable
name should be display in input box
rerender list not page
no record found should not be filled
add an output panel and rerender it
add SOQL instead sosl

TestClass
Comment private

use upsert instead of insert in uploadCSv*/

@isTest
private class AutoCompleteTest {
    
    @isTest
    private static void testQuery() {
        list<Account> aa = new list<Account>{
            new Account(Name='Test Account'),
                new Account(Name='Another Account', BillingCity='Test City'),
                new Account(Name='Third Account')
             };
               insert aa;
        
        Test.startTest();
        AutoCompleteComponentController aCon = new AutoCompleteComponentController();
        aCon.objName ='Account';
        aCon.selectedId = aa[0].id;
        aCon.fields = 'Name,Phone,Fax,CreatedDate';
        aCon.fieldName = new List<String>();
        list<AutoCompleteComponentController.RecordsWrapper> accts = AutoCompleteComponentController.autoCompleteRecords('test', 'Account');
        system.assertEquals(1, accts.size());
        aCon.displayObjectDetail();
        Account acc = (Account)aCon.record;
        acc.Name = 'Testt Account';
        aCon.record = acc;
        aCon.save();
        acc = (Account)aCon.record;
        System.assertEquals(acc.Name,'Testt Account');
        aCon.cancel();
        Test.stopTest(); 
    }
    
}