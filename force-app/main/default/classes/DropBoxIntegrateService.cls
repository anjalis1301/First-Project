public class DropBoxIntegrateService {
	/*
* @ description :This class created as service class for LDropBoxController which contain callout method of DropBox integration
* @ 
*/

    public static DropBoxIntegrateWrapper.ForAccessToken tokenwrap;
    public static String Authentication(String clientid,String redirectionurl){
        String Authenticationurl = 'https://www.dropbox.com/oauth2/authorize?client_id='+clientid+'&response_type=code&redirect_uri='+redirectionurl;
        system.debug('Authenticationurl>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>' + Authenticationurl);
        return Authenticationurl;   
    }
    /*
*@ description : This method call for get access token  
*@ params : 1. authorizationcode :- auth code which is use in get access token
			2. clientid:- client id of Box app
			3. clientsecretcode :- secretcode of box app
			4. redirectionurl : - where have to redirect while geting access token
*@ returns : method returns string
*/
    public static String getToken(String authorizationcode,String clientid,String clientsecretcode,String redirect_uri){
        String endpoint = 'https://api.dropboxapi.com/1/oauth2/token?grant_type=authorization_code&code='+authorizationcode+'&redirect_uri='+redirect_uri; 
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setTimeout(60*1000);
        System.debug('clientid >>>>> '+clientid);
        System.debug('clientsecretcode >>>  '+clientsecretcode);
        Blob headerValue = Blob.valueOf(clientid+ ':'+ clientsecretcode);  
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        System.debug('request is : '+request);
        Http httpObj = new Http();
        HttpResponse response = httpObj.send(request);  
        if(response.getBody() != null){
            tokenwrap = (DropBoxIntegrateWrapper.ForAccessToken)JSON.deserialize(response.getBody(),DropBoxIntegrateWrapper.ForAccessToken.class);
            Integration_Data__c newdata = new Integration_Data__c();
            newdata.AccessToken__c = tokenwrap.access_token;
            newdata.RefreshToken__c ='Empty';
            newdata.userID__c = userInfo.getUserId();
            System.debug('>>>>>>>>>>>>>>>>>>>>>>> '+newdata);
            insert newdata;
            system.debug('<<<<<<<<<<<<>>>>>>>>>>>>before return');
            System.debug(' response >>::: ' + response.getBody());
        }
        
        return tokenwrap.access_token;
    }
    /*
*@ description : This method call for get all files and folders of root folder  
*@ params : 1. accessToken :- auth code which is use in get all files and folders
			2. path :- folder id/path which want to get all metadata
*@ returns : method returns object of  DropBoxIntegrateWrapper.FileFolderListWrap type
*/ 
    public static DropBoxIntegrateWrapper.FileFolderListWrap getFileFolders(String accessToken, String path) { /*Get all file and folder data*/
        String responseBody;
        System.debug('accessToken : ' + accessToken);
        DropBoxIntegrateWrapper.FileFolderListWrap result= new DropBoxIntegrateWrapper.FileFolderListWrap();
        if(accessToken != null){
            Http http = new Http();
            HttpRequest request = new HttpRequest();        
            request.setMethod('POST');
            String body = ('{\"path\": \"'+path+'\",\"recursive\": false,\"include_media_info\": false,\"include_deleted\": false,\"include_has_explicit_shared_members\": false,\"include_mounted_folders\": true}');
            request.setEndpoint('https://api.dropboxapi.com/2/files/list_folder');       
            request.setHeader('Content-Type', 'Application/json');  
            request.setHeader('Authorization','Bearer '+ accessToken);
            request.setBody(body);
            request.setTimeOut(60*1000);              
            HttpResponse response = http.send(request);     
            responseBody = response.getBody(); 
            System.debug('drive reocrd : ' + responseBody); 
            String str =  JSON.serialize(responseBody) ;
            str=str.replace('.tag','type');
            System.debug('str after replace ----->' + str);
            str = str.removeStart('"');
            str = str.removeEnd('"');
            System.debug('str after replace ----->' + str);
            result = (DropBoxIntegrateWrapper.FileFolderListWrap)JSON.deserialize(str.remove('\\'), DropBoxIntegrateWrapper.FileFolderListWrap.class);
            System.debug('result ----->' + result);
            
            
            // System.debug('type ----->' + type);
        }
        else{
            result = null;
        }
        return result;
    }
    /*
*@ description : This method make callout for open  files  
*@ params : 1. accessToken :- access Token code 
			2. path :-  file id/path which we want to open 
*@ returns : method returns string
*/ 
    public static String viewFiles(String path ,String accessToken){
        System.debug('viewFiles called : ' + path); 
        Http http = new Http();
        HttpRequest request = new HttpRequest();        
        request.setMethod('POST');
        String body = ('{\"path\": \"'+path+'\",\"short_url\": false}'); 
        request.setEndpoint('https://api.dropboxapi.com/2/sharing/create_shared_link');     
        request.setHeader('Content-Type', 'Application/json');  
        request.setHeader('Authorization','Bearer '+ accessToken);
        request.setBody(body);
        request.setTimeOut(60*1000);              
        HttpResponse response = http.send(request);     
        String responseBody = response.getBody(); 
        System.debug('drive reocrd : ' + responseBody);
        Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(response.getBody()) ; 
        String webContentLink = String.valueOf(responseMap.get('url'));
        System.debug('Link   : ' + webContentLink); 
        return webContentLink;
    }
    /*
*@ description : This method make callout for download Files
*@ params : 1. accessToken :- auth code 
			2. path :- file id/path which we want to download
*@ returns : method returns String
*/    
    public static String downloadFiles(String path ,String accessToken){
        System.debug('downloadFiles called : ' + path); 
        Http http = new Http();
        HttpRequest request = new HttpRequest();        
        request.setMethod('POST');
        String body = ('{\"path\": \"'+path+'\"}');  //for download link
        request.setEndpoint('https://api.dropboxapi.com/2/files/get_temporary_link');        
        request.setHeader('Content-Type', 'Application/json');  
        request.setHeader('Authorization','Bearer '+ accessToken);
        request.setBody(body);
        request.setTimeOut(60*1000);              
        HttpResponse response = http.send(request);     
        String responseBody = response.getBody(); 
        System.debug('drive reocrd : ' + responseBody);
        String webContentLink;
        system.debug('response.getStatusCode()   '+response.getStatusCode());
        if(response.getStatusCode() == 200){
            Map<String,object> responseMap =(Map<String,object>)JSON.deserializeUntyped(response.getBody()) ; 
            webContentLink = String.valueOf(responseMap.get('link'));
            System.debug('Link   : ' + webContentLink); 
            return webContentLink;
        }else{
            
            return webContentLink = null; 
        }
    }
    /*
*@ description : This method make callout for delete  folder/file  
*@ params : 1. accessToken :- contain access Token
			2. path :-  folder id/path in which we want to delete 
*@ returns : method returns string
*/    
    public static String deleteFilesAndFolders(String path ,String accessToken){
        string body = '{\"path\": \"'+path+'\"}';        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.dropboxapi.com/2/files/delete_v2');
        request.setMethod('POST');        
        request.setHeader('Content-Type','application/json');              
        request.setBody(body);
        request.setHeader('Authorization' , 'Bearer'+' '+ accessToken);
        Http httpObj = new Http();
        HttpResponse response = httpObj.send(request); 
        System.debug('Response =' + response.getbody());
        return 'deleted';
    }
    /*
*@ description : This method make callout for create New Folder  
*@ params : 1. accesstoken :- contain access Token 
			2. FolderName :- contain name of new folder
			3. path :- parent folder id/path in which specify in which folder create new folder 
*@ returns : method returns Integer type value
*/   
    public static Integer createFolder(String FolderName, String accesstoken, string path){
        System.debug('=pathName====='+path);
        string querystring = '{\"path\": \"'+path+'/'+FolderName+'\",\"autorename\": false}';        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.dropboxapi.com/2/files/create_folder');
        request.setMethod('POST');        
        request.setHeader('Content-Type','application/json');              
        request.setBody(querystring);
        request.setHeader('Authorization' , 'Bearer'+' '+ accesstoken);
        Http httpObj = new Http();
        HttpResponse response = httpObj.send(request);
        System.debug('Response =' + response.getbody());
        return response.getStatusCode();
    }  
    /*
*@ description : This method make callout forr upload file in any folder  
*@ params : 1. access_Token :- auth code which is use in get all files and folders
			2. file :- body of file which we want to upload 
			3. filename :- store file name we want to upload 
			4. ParentPath :- parent folder id/path in which we want to upload file
*@ returns : method returns string
*/   
    public static string filesUpload(String ParentPath, string filename, string access_Token, String file){
        system.debug('file data >>>>> '+file);
        Blob decodeString = EncodingUtil.base64Decode(file);
        system.debug('file data >>>>> '+decodeString);
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://content.dropboxapi.com/2/files/upload');
        request.setHeader('Authorization', 'Bearer '+access_Token);
        request.setHeader('Dropbox-API-Arg','{\"path\": \"'+ParentPath+'/'+filename+'\",\"mode\": \"add\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}');
        request.setHeader('Content-Type', 'application/octet-stream');
        request.setBodyAsBlob(decodeString);
        Http httpObj = new Http();
        HttpResponse response = httpObj.send(request); 
        system.debug('response.getbody()>>'+response.getbody());
        return response.getbody();
    }
    

}