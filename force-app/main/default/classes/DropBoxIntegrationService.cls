/*************************************************************************************@@
ClassName	: DropBoxIntegrationService
Author		: Anjali Sharma
CreateDate	: 26/03/2021
Purpose		: To fetch data from drop box and return to DropBoxIntegration class
Test Suite  : DropBoxIntegrationTest
******************************************************************************************************/

public with sharing class DropBoxIntegrationService {
    //method create the url to get the authorization code
    public static String authorization(String clientId,String redirectUri) {
        String authURL =  'https://www.dropbox.com/oauth2/authorize?client_id='+clientId+'&response_type=code&redirect_uri='+redirectUri;
        return authURL;
    }
	
    //method to make am api request to get the access token
     public static String getAccessToken(String authCode, String clientId, String clientSecret, String redirectUri) {
        String endpoint = 'https://api.dropboxapi.com/1/oauth2/token?grant_type=authorization_code&code='+authCode+'&force_reauthentication=true&redirect_uri='+redirectUri;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setTimeout(60*1000);
        Blob headerValue = Blob.valueOf(clientId+ ':'+ clientSecret);  
        String header = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', header);
        Http h = new Http();
        HttpResponse resp = h.send(request);       
        Integration_Data__c intData = new Integration_Data__c();
        if(resp.getBody() != null) {
           intData.AccessToken__c = resp.getBody().split(',')[0].remove('"').split(':')[1];
            intData.UserId__c = userInfo.getUserId();
            intData.RefreshToken__c = '';
            intData.IntegrationApp__c = 'Dropbox';
            insert intData;  
        }
       return intData.AccessToken__c;
     }
    
  //  method to make an api request to get the files and folders
    public static DropBoxIntegrationWrapper.FileFolderList getFileFolders(String accessToken,String path) {
        DropBoxIntegrationWrapper.FileFolderList result;
     if(accessToken != null){
            Http http = new Http();
            HttpRequest request = new HttpRequest();        
            request.setMethod('POST');
            String body = ('{\"path\": \"'+path+'\",\"recursive\": false,\"include_deleted\": false,\"include_has_explicit_shared_members\": false,\"include_mounted_folders\": true}');
            request.setEndpoint(DropBoxIntegrationConstants.LISTFOLDERS);       
            request.setHeader(DropBoxIntegrationConstants.HEADERS[0],DropBoxIntegrationConstants.HEADERS[1]);  
            request.setHeader(DropBoxIntegrationConstants.HEADERS[2],DropBoxIntegrationConstants.HEADERS[3]+ accessToken);
            request.setBody(body);
            request.setTimeOut(60*1000);              
            HttpResponse response = http.send(request);
            System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+response.getBody());
            String responseBody = response.getBody().replace('.tag','dType'); 
            result = (DropBoxIntegrationWrapper.FileFolderList)JSON.deserialize(responseBody, DropBoxIntegrationWrapper.FileFolderList.class);
        } else {
            result = null;
        }
        return result;
    }
	
    //method to make an api request to get the url to view the selected file
    public static String displaySelectedFile(String accessToken,String path) {        
        HttpRequest req = new HttpRequest(); 
        String body = '{\"path\":\"'+path+'\",\"short_url\":false}';
        req.setMethod('POST');
        req.setEndpoint(DropBoxIntegrationConstants.CREATESHAREDLINK);     
        req.setHeader(DropBoxIntegrationConstants.HEADERS[0],DropBoxIntegrationConstants.HEADERS[1]);  
        req.setHeader(DropBoxIntegrationConstants.HEADERS[2],DropBoxIntegrationConstants.HEADERS[3]+ accessToken);
        req.setBody(body);
        req.setTimeOut(60*1000);
        Http h = new Http();
        HttpResponse response = h.send(req);
        String url = response.getBody().split(',')[0].remove('"').substringAfter(' ');
        return url;
    }

    //method to make an api request to create a folder and then return refreshed data
    public static List<DropBoxIntegrationWrapper.FileFolder> createFolder(String accessToken,String parentUrl,String newFolderName) {
        string body = '{\"path\": \"'+parentUrl+'/'+newFolderName+'\",\"autorename\": false}';        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(DropBoxIntegrationConstants.CREATEFOLDER);
        req.setMethod('POST');        
        req.setHeader('Content-Type','application/json');      
        req.setHeader('Authorization' , 'Bearer'+' '+ accessToken);
        req.setBody(body);
        Http h = new Http();
        HttpResponse response = h.send(req);
        if(response.getStatusCode() == 200) {
            DropBoxIntegrationWrapper.FileFolderList resp =  DropBoxIntegrationService.getFileFolders(accessToken, parentUrl);
            return resp.entries;
        }
        return null;
    }
   
    //to make an api request to delete the selected file or folder and return the refreshed data
    public static List<DropBoxIntegrationWrapper.FileFolder> deleteSelectedData(String accessToken,String parentUrl,String selfUrl) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader(DropBoxIntegrationConstants.HEADERS[2],DropBoxIntegrationConstants.HEADERS[3]+accessToken);
        req.setHeader(DropBoxIntegrationConstants.HEADERS[0],DropBoxIntegrationConstants.HEADERS[1]);
        req.setEndpoint(DropBoxIntegrationConstants.DELETEV2);
        String body = '{\"path\":\"'+selfUrl+'\"}';
        req.setBody(body);
        HttpResponse response = h.send(req);
        if(response.getStatusCode() == 200) {
            DropBoxIntegrationWrapper.FileFolderList res = DropBoxIntegrationService.getFileFolders(accessToken, parentUrl);
            return res.entries;
        }
        return null;        
    }
     
    //to make an api request get the link to download a file
    public static String downloadFile(String accessToken, String selfUrl) {
 
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader(DropBoxIntegrationConstants.HEADERS[2],DropBoxIntegrationConstants.HEADERS[3]+accessToken);
        req.setHeader(DropBoxIntegrationConstants.HEADERS[0],DropBoxIntegrationConstants.HEADERS[1]);
        req.setEndpoint(DropBoxIntegrationConstants.TEMPLINK);
        String body = '{\"path\":\"'+selfUrl+'\"}';
        req.setBody(body);
		Http h = new Http();
        HttpResponse response = h.send(req);
        if(response.getStatusCode() == 200) {
           String[] resp = response.getBody().split(',');
            Integer last = resp.size();
            String link = resp[last-1].remove('"').substringAfter(': ');
            return link;
        }
        return null;         
    }
    
    //to make an api request to upload a selected file and return the refreshed data
    public static List<DropBoxIntegrationWrapper.FileFolder> uploadSelected(String accessToken,String parentUrl, String fileName, String fileBody) {
        Http h = new Http();
        Blob blobBody = EncodingUtil.base64Decode(fileBody);
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(DropBoxIntegrationConstants.UPLOADFILES);
        req.setHeader(DropBoxIntegrationConstants.HEADERS[2],DropBoxIntegrationConstants.HEADERS[3]+accessToken);
        req.setHeader('Dropbox-API-Arg','{\"path\": \"'+ParentUrl+'/'+filename+'\",\"mode\": \"add\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}');
        req.setHeader(DropBoxIntegrationConstants.HEADERS[0] , 'application/octet-stream');
        req.setBodyAsBlob(blobBody);
        HttpResponse response = h.send(req); 
        if(response.getStatusCode() == 200) {
            DropBoxIntegrationWrapper.FileFolderList res = DropBoxIntegrationService.getFileFolders(accessToken, parentUrl);
            return res.entries;
        }
        return null;
    }
}