/*************************************************************************************@@
ClassName	: TrueLayer
Author		: Anjali Sharma
CreateDate	: 24/04/2021
Purpose		: To fetch data from server and return it to TrueLayer component 

******************************************************************************************************/

public with sharing class TrueLayer {
    public static TrueLayer__mdt metaInfo;
    public static List<Integration_Data__c> objData = new List<Integration_Data__c>();
   
    static {
        objData = [SELECT ID,AccessToken__c, RefreshToken__c FROM Integration_Data__c WHERE UserId__c =:userInfo.getUserId() AND IntegrationApp__c ='TrueLayer' LIMIT 1];
         metaInfo= [SELECT ClientID__c,ClientSecret__c,Redirect_Uri__c FROM TrueLayer__mdt where Label = 'TrueLayerMeta']; 
    }

    //method to get the url to generate url to ask for user consent and get the authorization code
    @AuraEnabled 
    public static AuthCodeData authorization(){
        AuthCodeData authData = new AuthCodeData();
        if(objData.size() == 0) {
            String url = TrueLayerService.authorization(metaInfo.ClientID__c,metaInfo.Redirect_Uri__c);
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
        Integration_Data__c intData = TrueLayerService.getAccessToken(authCode,metaInfo.ClientId__c,metaInfo.ClientSecret__c);
       // insert intData;
    }
    
    /*//method to get the data of the selected folder using its path
    @AuraEnabled
    public static List<BoxIntegrationWrapper.FileWrapper1> getBoxFiles(String folderPath) {
        BoxIntegrationWrapper.FileWrapper3 resData = BoxIntegrationService.getFileFolders(objData[0].AccessToken__c,objData[0].RefreshToken__c,folderPath,metaInfo);
        System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@entries'+resData.item_collection.entries);
        return resData.item_collection.entries;
    }

    //method to generate the url to view the selected file using its path
   @AuraEnabled
   public static String displayFile(String filePathId) {
       String url = BoxIntegrationService.displaySelectedFile(objData[0].AccessToken__c,objData[0].RefreshToken__c,filePathId,metaInfo);
       return url;
   }
  
   //method to create a new folder in the parent folder using parentUrl and name of the folder
   @AuraEnabled
   public static List<BoxIntegrationWrapper.FileWrapper1> createNewFolder(String parentFolId, String newFolName){
    BoxIntegrationWrapper.FileWrapper3 response = BoxIntegrationService.createFolder(objData[0].AccessToken__c,objData[0].RefreshToken__c,parentFolId,newFolName,metaInfo);
    return response.item_collection.entries;
    }
    
    //method to delete the selected file of folder using its selfUrl and return the refreshed data through its parentUrl
    @AuraEnabled
    public static List<BoxIntegrationWrapper.FileWrapper1> deleteSelected(String parentUrl,String type, String selectedId) {
        BoxIntegrationWrapper.FileWrapper3 response =  BoxIntegrationService.deleteSelectedData(objData[0].AccessToken__c,objData[0].refreshToken__c,parentUrl,type,selectedId,metaInfo);
        return response.item_collection.entries;
    }
    
    //method to download the selected file using its selfUrl
    @AuraEnabled 
    public static String downloadSelected(String selectedId) {
        String url = BoxIntegrationService.downloadFile(objData[0].AccessToken__c,objData[0].RefreshToken__c ,selectedId,metaInfo);
        return url;
    }
    
    //method to upload a selected file using its fileName and fileBody and then return the refreshed data using its parentUrl
   @AuraEnabled
    public static List<BoxIntegrationWrapper.FileWrapper1> uploadSelectedData(String parentUrl, String fileName, String fileBody) {
        BoxIntegrationWrapper.FileWrapper3 resp = BoxIntegrationService.uploadFile(objData[0].AccessToken__c,objData[0].RefreshToken__c,fileBody,fileName,parentUrl,metaInfo);
        return resp.item_collection.entries;        
    }*/
    
    //wrapper class to manage the authorization code url
    public class AuthCodeData {
       @AuraEnabled public Boolean Flag;
       @AuraEnabled public String authCodeUrl;
    }
}