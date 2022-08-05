/*************************************************************************************@@
ClassName	: BoxIntegrationService
Author		: Anjali Sharma
CreateDate	: 19/04/2021
Purpose		: To fetch data from box and return to BoxIntegration class
Test Suite  : BoxIntegrationTest
******************************************************************************************************/

public with sharing class BoxIntegrationService {
    public static List<Integration_Data__c> objData = new List<Integration_Data__c>();
    static { 
        objData = [SELECT ID,AccessToken__c, RefreshToken__c FROM Integration_Data__c WHERE UserId__c =:userInfo.getUserId() AND IntegrationApp__c ='Box' LIMIT 1];
   }

    //method create the url to get the authorization code
    public static String authorization(String clientId,String redirectUri) {
        String authURL =  BoxIntegrationConstants.AUTHURL+clientId+'&redirect_uri='+redirectUri;
        return authURL;
    }
	
    //method to make am api request to get the access token
     public static Integration_Data__c getAccessToken(String authCode, String clientId, String clientSecret) {
        String body='grant_type=authorization_code&code='+authCode+'&client_id='+clientId+'&client_secret='+clientSecret;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BoxIntegrationConstants.ACCESSTOKENURL);
        request.setBody(body);
        request.setMethod('POST');
        request.setTimeout(60*1000);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        Http h = new Http();
        HttpResponse resp = h.send(request);
        Integration_Data__c intData = new Integration_Data__c();
        Map<String,object> respMap  = (Map<String,object>)JSON.deserializeUntyped(resp.getBody());
        if(resp.getBody() != null) {
           intData.AccessToken__c = String.valueOf(respMap.get('access_token'));
            intData.UserId__c = userInfo.getUserId();
            intData.RefreshToken__c = String.valueOf(respMap.get('refresh_token'));
            intData.IntegrationApp__c = 'Box';
        }
       return intData;
     }
    
  //  method to make an api request to get the files and folders
    public static BoxIntegrationWrapper.FileWrapper3 getFileFolders(String accessToken,String refreshToken,String folderPath,LwcCommunityBoxIntegrateMeta__mdt metaInfo) {
        BoxIntegrationWrapper.FileWrapper3 result;
            Http http = new Http();
            HttpRequest request = new HttpRequest();        
            request.setMethod('GET');
            request.setEndpoint(BoxIntegrationConstants.GETFILESANDFOLDERS+'/'+folderPath);       
            request.setHeader(BoxIntegrationConstants.HEADERS[2], BoxIntegrationConstants.HEADERS[3]+accessToken);  
                         
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200){ 
                result = (BoxIntegrationWrapper.FileWrapper3)JSON.deserialize(response.getBody(), BoxIntegrationWrapper.FileWrapper3.class);
            }
            else if(response.getStatusCode() == 401){
             
                    Map<String,object> responseMap = updateAccessTknByRefresh(metaInfo.Client_Id__c, metaInfo.Client_Secret__c, refreshToken, metaInfo.Redirect_Uri__c);
                	if(responseMap != null){
                        String access_Tokenn = String.valueOf(responseMap.get('access_token'));
                        String refresh_Tokenn = String.valueOf(responseMap.get('refresh_token'));
                        result = getFileFolders( access_Tokenn,refresh_Tokenn,folderPath,metaInfo);
                        if(result != null) { 
                            updateRecord(access_Tokenn,refresh_Tokenn);
                        }
                    }
                
            }
        return result;
    }
           
    public static String displaySelectedFile(String accessToken,String refreshToken, String filePathId,LwcCommunityBoxIntegrateMeta__mdt metaInfo){     		
        string body = '{"shared_link": {"access": "open"}}';   	
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BoxIntegrationConstants.GETFILE+filePathId+'?fields=shared_link');
        request.setMethod('PUT');        
        request.setHeader(BoxIntegrationConstants.HEADERS[0],BoxIntegrationConstants.HEADERS[1]);              
        request.setBody(body);
        request.setHeader(BoxIntegrationConstants.HEADERS[2],BoxIntegrationConstants.HEADERS[3]+ accessToken);
        Http httpObj = new Http();
        HTTPResponse response = httpObj.send(request);
        String viewLink;
        if(response.getStatusCode() == 200){
            Map<String,Object> respMap = (Map<String,object>)JSON.deserializeUntyped(response.getBody());
            Map<String,Object> shar = (Map<String,Object>)respMap.get('shared_link');
            viewLink = (String) shar.get('url');
        }else if(response.getStatusCode() == 401){
            Map<String,object> responseMap = updateAccessTknByRefresh(metaInfo.Client_Id__c, metaInfo.Client_Secret__c, refreshToken, metaInfo.Redirect_Uri__c);
                    if(responseMap != null){
                        String access_Tokenn = String.valueOf(responseMap.get('access_token'));
                        String refresh_Tokenn = String.valueOf(responseMap.get('refresh_token'));
                        viewLink = displaySelectedFile( access_Tokenn,refresh_Tokenn,filePathId,metaInfo);
                        updateRecord(access_Tokenn,refresh_Tokenn);
                    } else {
                        return null;
                    }
        }
        return  viewLink;
    }
        
    
        public static Map<String,object> updateAccessTknByRefresh(String clientId,String clientSecret,String refreshToken ,string redirectUri){
            HttpResponse response;
            Map<String,Object> responseMap;
            String accessToken;
            if(clientId != null && clientSecret != null && refreshToken != null ) {
                String body='grant_type=refresh_token&refresh_token='+refreshToken+'&client_id='+clientId+'&client_secret='+clientSecret;
                Http httpObj = new Http();
                HttpRequest request = new HttpRequest();
                request.setTimeout(60*1000);
                request.setEndpoint(BoxIntegrationConstants.ACCESSTOKENURL);
                request.setBody(body);
                
                request.setHeader(BoxIntegrationConstants.HEADERS[0], 'application/x-www-form-urlencoded');
                request.setMethod('POST'); 
                response = httpObj.send(request);
                if(response.getStatusCode() == 200) {
                    responseMap =(Map<String,object>)JSON.deserializeUntyped(response.getBody()) ; 
                }else if( response.getStatusCode() == 401 || response.getStatusCode() == 400) {
                    if(objData.size() > 0){
                        delete objData;
                    }
                    return null;
                }   
            }
            return responseMap;   
        }
        
        public static void updateRecord(String accessToken ,String refreshToken ) {	
            objData[0].AccessToken__c = accessToken;
            objData[0].RefreshToken__c = refreshToken;
            update objData[0];
        }

        public static BoxIntegrationWrapper.FileWrapper3 deleteSelectedData(String accessToken,String refreshToken, String parentId,String type, String selectedId,LwcCommunityBoxIntegrateMeta__mdt metaInfo){
                String result;
                BoxIntegrationWrapper.FileWrapper3 res;
                HttpRequest request = new HttpRequest();
                if(type == 'folder'){
                    request.setEndpoint(BoxIntegrationConstants.GETFILESANDFOLDERS+'/'+selectedId+'?recursive=true');
                } else {
                    request.setEndpoint(BoxIntegrationConstants.GETFILE + selectedId);
                } 
                request.setMethod('DELETE');        
                request.setHeader(BoxIntegrationConstants.HEADERS[2] , BoxIntegrationConstants.HEADERS[3] +  accessToken);
                request.setHeader('Accept', BoxIntegrationConstants.HEADERS[1]);
                Http httpObj = new Http();
                HTTPResponse response = httpObj.send(request);
                if(response.getStatusCode() == 204) {
                    result = 'File_Deleted';
                    res = BoxIntegrationService.getFileFolders(accessToken, refreshToken, parentId, metaInfo);

                }else if(response.getStatusCode() == 401) {
                    Map<String,object> responseMap = updateAccessTknByRefresh(metaInfo.Client_Id__c, metaInfo.Client_Secret__c, refreshToken, metaInfo.Redirect_Uri__c);
                    if(responseMap != null){
                        String access_Tokenn = String.valueOf(responseMap.get('access_token'));
                        String refresh_Tokenn = String.valueOf(responseMap.get('refresh_token'));
                         res = deleteSelectedData(access_Tokenn,refresh_Tokenn,parentId,type,selectedId,metaInfo);
                        updateRecord(access_Tokenn,refresh_Tokenn);
                    } else {
                        return null;
                    }                    
                }
                return res;
        }

        public static String downloadFile(String accessToken,String refreshToken,String selectedFileId , LwcCommunityBoxIntegrateMeta__mdt metaInfo ) {
            String downloadUrl;  
            Http httpObj = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(BoxIntegrationConstants.GETFILE +selectedFileId+'/content');
            request.setHeader(BoxIntegrationConstants.HEADERS[2], BoxIntegrationConstants.HEADERS[3]+accessToken);
            request.setHeader('content-type', 'application/json');
            request.setHeader('Accept','application/json');
            request.setMethod('GET');
            HttpResponse response = httpObj.send(request);
            if(response.getStatusCode() == 302) {
            downloadURL=response.getHeader('Location');
            }else if(response.getStatusCode() == 401) {
                Map<String,object> responseMap = updateAccessTknByRefresh(metaInfo.Client_Id__c, metaInfo.Client_Secret__c, refreshToken, metaInfo.Redirect_Uri__c);
                if(responseMap != null){
                    String access_Tokenn = String.valueOf(responseMap.get('access_token'));
                    String refresh_Tokenn = String.valueOf(responseMap.get('refresh_token'));
                     downloadUrl = downloadFile(access_Tokenn,refresh_Tokenn,selectedFileId,metaInfo);
                    updateRecord(access_Tokenn,refresh_Tokenn);
                } else {
                    return null;
                }
            }
            return downloadUrl;
        }

        public static BoxIntegrationWrapper.FileWrapper3 createFolder(String accessToken,String refreshToken, String parentId, String newFolName, LwcCommunityBoxIntegrateMeta__mdt metaInfo) {
            BoxIntegrationWrapper.FileWrapper3 res;
            string querystring = '{"name": "' + newFolName + '", "parent": {"id": "' + parentId + '"}}';
            HttpRequest request = new HttpRequest();
            request.setEndpoint(BoxIntegrationConstants.GETFILESANDFOLDERS);
            request.setMethod('POST');
            request.setHeader(BoxIntegrationConstants.HEADERS[0], BoxIntegrationConstants.HEADERS[1]);
            request.setBody(querystring);
            request.setHeader(BoxIntegrationConstants.HEADERS[2] , BoxIntegrationConstants.HEADERS[3]+ accessToken);
            Http httpObj = new Http();
            HTTPResponse response = httpObj.send(request);
            if(response.getStatusCode() == 201) {
                res = getFileFolders(accessToken, refreshToken, parentId, metaInfo);

            }else if(response.getStatusCode() == 401) {
                Map<String,object> responseMap = updateAccessTknByRefresh(metaInfo.Client_Id__c, metaInfo.Client_Secret__c, refreshToken, metaInfo.Redirect_Uri__c);
                if(responseMap != null){
                    String access_Tokenn = String.valueOf(responseMap.get('access_token'));
                    String refresh_Tokenn = String.valueOf(responseMap.get('refresh_token'));
                     res = createFolder(access_Tokenn,refresh_Tokenn,parentId,newFolName,metaInfo);
                    updateRecord(access_Tokenn,refresh_Tokenn);
                } else {
                    return null;
                }
                
            }
            return res;
        }

        public static BoxIntegrationWrapper.FileWrapper3 uploadFile(String accessToken,String refreshToken,String fileBody, String fileName, String parentFolId,LwcCommunityBoxIntegrateMeta__mdt metaInfo) {
            String boundary = '-----seprator';
            String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+fileName+'";\nContent-Type: application/octet-stream';
            String footer = '--'+boundary+'--';             
            String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
          
            String bodyEncoded = fileBody;
            Blob bodyBlob = null;
            String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
            if(last4Bytes.endsWith('==')) {
                last4Bytes = last4Bytes.substring(0,2) + '0K';
                bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
                String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
            } else if(last4Bytes.endsWith('=')) {
                last4Bytes = last4Bytes.substring(0,3) + 'N';
                bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
                footer = '\n' + footer;
                String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
            } else {
                footer = '\r\n' + footer;
                String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
                bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
            }
            
            HttpRequest request = new HttpRequest();
            request.setHeader(BoxIntegrationConstants.HEADERS[0],'multipart/form-data; boundary='+boundary);
            request.setMethod('POST');
            request.setEndpoint(BoxIntegrationConstants.UPLOADFILE+parentFolId);
            request.setBodyAsBlob(bodyBlob);
            request.setTimeout(60000);
            request.setHeader(BoxIntegrationConstants.HEADERS[2], BoxIntegrationConstants.HEADERS[3]+accessToken);
            request.setHeader('Content-Length',String.valueof(request.getBodyAsBlob().size()));
            Http httpObj = new Http();
            HTTPResponse response = httpObj.send(request);
            BoxIntegrationWrapper.FileWrapper3 res;
            if(response.getStatusCode() == 201) {
                res = getFileFolders(accessToken, refreshToken, parentFolId, metaInfo);
            }else if(response.getStatusCode() == 401) {
                Map<String,object> responseMap = updateAccessTknByRefresh(metaInfo.Client_Id__c, metaInfo.Client_Secret__c, refreshToken, metaInfo.Redirect_Uri__c);
                if(responseMap != null){
                    String access_Tokenn = String.valueOf(responseMap.get('access_token'));
                    String refresh_Tokenn = String.valueOf(responseMap.get('refresh_token'));
                     res = uploadFile(access_Tokenn,refresh_Tokenn,fileBody, fileName, parentFolId,metaInfo);
                    updateRecord(access_Tokenn,refresh_Tokenn);
                } else {
                    return null;
                }
            }
            return res;
        }
}