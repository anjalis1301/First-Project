/*************************************************************************************@@
Class Name     :  UploadCSVRecordTest
Purpose        :  Test class for the class UplaodCSVRecord
DATE           :  03/02/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
@isTest
private class UploadCSVRecordTest {
    
	 /**
    *   @method testUploadWithValidType
    *   method to test cases on a vaild .csv extension file
    */
    @isTest
    private static void testUploadWithValidType() {
        String name = 'testData.csv';
        String body = 'LastName,Description,FirstName,Birthdate,NRI__c,Last_Change__c,Sequence_Number__c\r"sharma,\ntiwari",hello,anj,2021-02-02,TRUE\rfri,,day,2021-03-01,FALSE,2021-03-01 08:50:00,5\r,dasy,2021-03-01,FALSE';
        
        Test.startTest();
        UploadCSVRecord obj = new UploadCSVRecord();
        obj.csvName = name;
        obj.csvBody = blob.valueOf(body);
        obj.uploadCSVFile();
        //System.assertEquals(obj.conUpsertList.size(), 3);
        Contact con = [SELECT Id,FirstName,LastName FROM Contact WHERE LastNAme ='fri'];
        System.assertEquals(con.FirstName, 'day');
        String name1 = 'testData.csv';
        String body1 = 'LastName,Id\r"sharma,\nAnji"\rShimla,'+con.Id+'\r,dasy';
        obj.csvName = name1;
        obj.csvBody = blob.valueOf(body1);
        obj.uploadCSVFile();
        Contact con1 = [SELECT Id,FirstName,LastName FROM Contact WHERE id = :con.id];
        System.assertEquals(con1.LastName, 'Shimla');
        Test.stopTest();
    }
    
     /**
    *   @method testUploadInvalidType
    *   method to test cases on a invaild extension file
    */
    @isTest
    private static void testUploadInvalidType() {
        String name2 = 'testData2.pptx';
        String body2 ='LastName\rAll';
        Test.startTest();
        UploadCSVRecord obj = new UploadCSVRecord();
        obj.csvName = name2;
        obj.csvBody = blob.valueOf(body2);
        obj.uploadCSVFile();
        Test.stopTest();
    }
    
}