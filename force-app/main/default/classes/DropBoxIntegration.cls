/*************************************************************************************@@
ClassName	: DropBoxIntegration
Author		: Anjali Sharma
CreateDate	: 26/03/2021
Purpose		: To fetch data from drop box and return to DropBoxIntegrate component helper
Test Suite  : DropBoxIntegrationTest
******************************************************************************************************/

public with sharing class DropBoxIntegration {
    public static IntegrationMeta__mdt metaInfo;
    public static List<Integration_Data__c> objData = new List<Integration_Data__c>();

    static {
         metaInfo= [SELECT Client_ID__c,Client_Secret__c,Redirect_Uri__c FROM IntegrationMeta__mdt where Label = 'DropBox']; 
         objData = [SELECT ID,AccessToken__c FROM Integration_Data__c WHERE UserId__c =:userInfo.getUserId() AND IntegrationApp__c = 'Dropbox' LIMIT 1];
    }

    //method to get the url to generate url to ask for user consent and get the authorization code
    @AuraEnabled
    public static AuthCodeData dropBoxAuthorization(){
        AuthCodeData authData = new AuthCodeData();
        if(DropBoxIntegration.objData.size() == 0) {
            String url = DropBoxIntegrationService.authorization(metaInfo.Client_ID__c,metaInfo.Redirect_Uri__c);
            authData.Flag = false;
            authData.authCodeUrl = url;            
        } else {
            authData.Flag = true;
        }
        return authData;
    }

    //method to generate the generate the access token through authorization code
    @AuraEnabled 
    public static void fetchAccessToken(String authCode) {
       DropBoxIntegrationService.getAccessToken(authCode,metaInfo.Client_Id__c,metaInfo.Client_Secret__c,metaInfo.Redirect_Uri__c);
    }
    
    //method to get the data of the selected folder using its path
    @AuraEnabled
    public static List<DropBoxIntegrationWrapper.FileFolder> getDropboxFiles(String path) {
        DropBoxIntegrationWrapper.FileFolderList resData = DropBoxIntegrationService.getFileFolders(objData[0].AccessToken__c,path);
        return resData.entries;
    }
    
    //method to generate the url to view the selected file using its path
   @AuraEnabled
   public static String displayFile(String path) {
       String url = DropBoxIntegrationService.displaySelectedFile(objData[0].AccessToken__c,path);
       return url;
   }
  
   //method to create a new folder in the parent folder using parentUrl and name of the folder
   @AuraEnabled
   public static List<DropBoxIntegrationWrapper.FileFolder> createNewFolder(String pathUrl,String name){
    List<DropBoxIntegrationWrapper.FileFolder> response = DropBoxIntegrationService.createFolder(objData[0].AccessToken__c,pathUrl,name);
    return response;
    }
    
    //method to delete the selected file of folder using its selfUrl and return the refreshed data through its parentUrl
    @AuraEnabled
    public static List<DropBoxIntegrationWrapper.FileFolder> deleteSelected(String parentUrl,String selfUrl) {
        List<DropBoxIntegrationWrapper.FileFolder> response =  DropBoxIntegrationService.deleteSelectedData(objData[0].AccessToken__c,parentUrl,selfUrl);
        return response;
    }
    
    //method to download the selected file using its selfUrl
    @AuraEnabled 
    public static String downloadSelected(String selfUrl) {
        String url = DropBoxIntegrationService.downloadFile(objData[0].AccessToken__c,selfUrl);
        return url;
    }
    
    //method to upload a selected file using its fileName and fileBody and then return the refreshed data using its parentUrl
    @AuraEnabled
    public static List<DropBoxIntegrationWrapper.FileFolder> uploadSelectedData(String parentUrl, String fileName, String fileBody) {
        List<DropBoxIntegrationWrapper.FileFolder> resp = DropboxIntegrationService.uploadSelected(objData[0].AccessToken__c,parentUrl,fileName,fileBody);
        return resp;        
    }
    
    //wrapper class to manage the authorization code url
    public class AuthCodeData {
       @AuraEnabled public Boolean Flag;
       @AuraEnabled public String authCodeUrl;
    }
}