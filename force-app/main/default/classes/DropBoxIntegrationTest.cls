/*************************************************************************************@@
Class Name     :  DropBoxIntegrationTest
Purpose        :  Test class for DropBoxIntegrationTest
DATE           :  02/04/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
@isTest
private class DropBoxIntegrationTest {
    
	//setup method to create a community user and insert the record integration data object
	@TestSetup
    public static void createData(){
        Id profileId = [select id from profile where name='Custom Customer Community Plus Login User'].id;
        Account ac = new Account(name ='TestAccount') ;
        insert ac;        
        Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
        insert con;
        
        User usr = new User(alias = 'test123', email='test123@noemail.com',
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = profileId, country='United States',IsActive =true,
        ContactId = con.Id,
        timezonesidkey='America/Los_Angeles', username='tester@noemail.com');
        insert usr;
        
        System.runAs(usr){
            Integration_Data__c objData = new Integration_Data__c(AccessToken__c = 'fakeAccessToken123',UserId__c = usr.Id);
        	insert objData;
        }
        
    }
    
	//For test dropBoxAuthorizationTest method when Integration_Data__c object has no records
		@isTest  
    	public static void dropBoxAuthorizationTest() {
            Test.startTest();
            DropBoxIntegration.AuthCodeData authData = new DropBoxIntegration.AuthCodeData();
            authData = DropBoxIntegration.dropBoxAuthorization();
            system.assertNotEquals(true, authData.Flag);
            Test.stopTest();                    
    }
    
    //For test dropBoxAuthorizationTest method  when Integration_Data__c object has records
    @isTest  
    public static void dropBoxAuthorizationUserTest() {
        User u = [SELECT Id FROM User WHERE UserName='tester@noemail.com'];
        System.runAs(u) {
            Test.startTest();
            DropBoxIntegration.AuthCodeData authData = new DropBoxIntegration.AuthCodeData();
            authData = DropBoxIntegration.dropBoxAuthorization();
            system.assertNotEquals(false, authData.Flag);
            Test.stopTest();                    
        }
    }   
             
    @isTest
    //For test fetchAccessTokenTest method    
    public static void fetchAccessTokenTest() {
        User u = [SELECT Id FROM User WHERE UserName='tester@noemail.com'];
        System.runAs(u){
            Test.setMock(HttpCalloutMock.class, new DropBoxIntegrationMockResponse());
            Test.startTest();
            DropBoxIntegration.fetchAccessToken('FakeAuthCode1233333k');
            Test.stopTest();
        }
    }
    
    //For test getDropboxFilesTest method 
    @isTest   
    	public static  void getDropboxFilesTest(){
            User u = [SELECT Id FROM User WHERE UserName='tester@noemail.com'];
            System.runAs(u){
                Test.setMock(HttpCalloutMock.class, new DropBoxIntegrationMockResponse());           
                Test.startTest();                    
                   List<DropBoxIntegrationWrapper.FileFolder> data =  DropBoxIntegration.getDropboxFiles(' ');
                   System.assertEquals(data.size(), 6);           
                Test.stopTest();
            }
    }
    
  
     //For test displayFile method
     @isTest    
    public static void displayFileTest(){
        User u = [SELECT Id FROM User WHERE UserName='tester@noemail.com'];
        System.runAs(u) {
            Test.setMock(HttpCalloutMock.class, new DropBoxIntegrationMockResponse());
            Test.startTest();
                String url = DropBoxIntegration.displayFile('/get started with dropbox.pdf');
                System.assertNotEquals(null, url);
            Test.stopTest();
        }
    }
    
     //For test createNewFolder method 
    @isTest   
    public static void createNewFolderTest() {
        User u = [SELECT Id FROM User WHERE UserName='tester@noemail.com'];
        System.runAs(u) {
            Test.setMock(HttpCalloutMock.class, new DropBoxIntegrationMockResponse());
            Test.startTest();
            List<DropBoxIntegrationWrapper.FileFolder> data =  DropBoxIntegration.createNewFolder(' ','TestData');
            System.assertNotEquals(null, data);
            Test.stopTest();
        }
    }
    
    //For test deleteSelected method 
    @isTest
    public static void deleteSelectedTest() {
        User u = [SELECT Id FROM User WHERE UserName='tester@noemail.com'];
        System.runAs(u){
            Test.setMock(HttpCalloutMock.class, new DropBoxIntegrationMockResponse());       
            Test.startTest();
                List<DropBoxIntegrationWrapper.FileFolder> data =  DropBoxIntegration.deleteSelected(' ','/testdata');
                System.assertNotEquals(null, data);
            Test.stopTest();
        }
    } 
    
    //For test downloadSelected method  
    @isTest  
    public static void downloadSelectedTest() {
        User u = [SELECT Id FROM User WHERE UserName='tester@noemail.com'];
        System.runAs(u) {
            Test.setMock(HttpCalloutMock.class, new DropBoxIntegrationMockResponse());
            Test.startTest();
                String link = DropBoxIntegration.downloadSelected('/download.png');
                System.assertNotEquals(null, link);
            Test.stopTest();
        }
    }
        
    //For test uploadSelectedData method
    @isTest    
    public static void uploadSelectedDataTest() {
        User u = [SELECT Id FROM User WHERE UserName='tester@noemail.com'];
        System.runAs(u) {
            Test.setMock(HttpCalloutMock.class, new DropBoxIntegrationMockResponse());
            Test.startTest();
            String fileName = 'test';
            String fileBody = 'testing1234';
            List<DropBoxIntegrationWrapper.FileFolder> data =  DropBoxIntegration.uploadSelectedData(' ',fileName,fileBody);
            System.assertNotEquals(null, data);
            Test.stopTest();
        }
    }
    
}