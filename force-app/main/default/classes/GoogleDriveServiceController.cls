/*************************************************************************************@@
Class Name     :  GoogleDriveController
Purpose        :  To get all the necessary information from controller class and return response after api callouts   
DATE           :  13/02/2021
Author         :  Anjali Sharma
*********************************************************************************************************/

public class GoogleDriveServiceController {
    static final String  endPointUrl = 'https://www.googleapis.com/drive/v2/files';
    public static HttpResponse createAndSendRequest(String endPt,String method, String body, Map<String,String> header) {
      	HttpRequest req = new HttpRequest();
        req.setEndpoint(endpt);
        req.setMethod(method);
        if(body != '' && body != null) {
            System.debug('in body');
            req.setBody(body);
        }
        if(!header.isEmpty()) {
            for(String head : header.keySet()) {
                req.setHeader(head, header.get(head));
            }
        }
        req.setTimeout(60 *1000);
        Http h = new Http();
        HttpResponse resp = h.send(req);
        return resp;
        
    }
    
    public static String googleDriveAuthUri(String Clientkey,String redirect_uri) {
        String key = EncodingUtil.urlEncode(Clientkey,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        System.debug('uri'+uri);
        String authuri = '';
        authuri = 'https://accounts.google.com/o/oauth2/auth?'+
            'client_id='+key+
            '&response_type=code'+
            '&scope=https://www.googleapis.com/auth/drive'+
            '&redirect_uri='+uri+
            '&state=security_token%3D138r%26url%3Dhttps://oa2cb.example.com/myHome&'+
            '&login_hint=xyz@example.com&'+
            'access_type=offline';
        return authuri;
    }
    
     public static HttpResponse accessTokenById(String code, String key, String secret, String redirectUri) {
        String method = 'POST';
        String endPoint = 'https://accounts.google.com/o/oauth2/token';
        Map<String,String> header1 = new Map<String,String>();
        String messageBody = 'code=' + code + '&client_id=' + key + '&client_secret=' + secret + '&redirect_uri=' + redirectUri + '&grant_type=authorization_code';
        header1.put('content-type', 'application/x-www-form-urlencoded');
        header1.put('Content-length', String.valueOf(messageBody.length()));
        HttpResponse resp = createAndSendRequest(endPoint,method,messageBody,header1);
        return resp;
    }
    
    public static HttpResponse accessTokenByRefreshToken(String refreshToken, String key, String secret) {
        String method = 'POST';
        String endPoint = 'https://accounts.google.com/o/oauth2/token';
        Map<String,String> header1 = new Map<String,String>();
        String messageBody = '&client_id=' + key + '&client_secret=' + secret + '&refresh_token=' + refreshToken + '&grant_type=refresh_token';
        header1.put('content-type', 'application/x-www-form-urlencoded');
        header1.put('Content-length', String.valueOf(messageBody.length()));
        HttpResponse resp = GoogleDriveServiceController.createAndSendRequest(endPoint,method,messageBody,header1);
        return resp;
    }
    
     public static HttpResponse fetchFiles(String AccessToken,String parentFolder) {
        String method = 'GET';
        String endPoint = endPointUrl+'?q='+'\''+parentFolder+'\'%20in%20parents%20and%20trashed%20%3D%20false';
        Map<String,String> header1 = new Map<String,String>();
        header1.put('Content-Type','application/json');
        header1.put('Authorization' , 'Bearer'+' '+ AccessToken);
        HttpResponse resp = createAndSendRequest(endPoint,method,'',header1);
        return resp;
    }
    
    public static HttpResponse createFolder(String AccessToken,String newFolderName,String parentFolder) {
        String method = 'POST';
        String endPoint = endPointUrl;
        Map<String,String> header1 = new Map<String,String>();
        header1.put('Authorization', 'Bearer ' + AccessToken);
        Header1.put('content-type', 'application/json');
        String body = '{"title":"'+newFolderName+'","mimeType":"application/vnd.google-apps.folder","parents": [{"kind": "drive#fileLink","id": "'+parentFolder+'"}]}';  
      	HttpResponse resp = createAndSendRequest(endpoint,method,body,header1);
        return resp;
    }
    
    public static HttpResponse deleteData(String AccessToken, String idToDelete) {
        String method = 'DELETE';
        String endPoint = endPointUrl+'/'+idToDelete;
        Map<String,String> header1 = new Map<String,String>();
        header1.put('Authorization', 'Bearer ' + AccessToken);
        HttpResponse resp = createAndSendRequest(endPoint,method,'',header1);
        return resp;
    }
    
    public static HttpResponse uploadFile(String AccessToken,String fName,String fType,String parentFolder,String bodyEncoded ) {
        String boundary = '--cfg';
            String delimiter = '\r\n--' + boundary + '\r\n';
            String close_delim = '\r\n--' + boundary + '--';
           	String body = delimiter + 'Content-Type: application/json\r\n\r\n' + '{ "title" : "' + fName + '","mimeType" : "' + fType + '","parents" :[{"id":"'+ parentFolder + '"}]}' + delimiter + 'Content-Type: ' + ftype + '\r\n' + 'Content-Transfer-Encoding: base64\r\n' + '\r\n' + bodyEncoded + close_delim;
            String method = 'POST';
            String endPoint = 'https://www.googleapis.com/upload/drive/v2/files?uploadType=multipart';
            Map<String,String> header1 = new Map<String,String>();
            header1.put('Authorization', 'Bearer ' + AccessToken);
            Header1.put('Content-Type', 'multipart/mixed; boundary="' + boundary + '"');
            header1.put('Content-length', String.valueOf(body.length()));
            HttpResponse resp = createAndSendRequest(endPoint,method,body,header1);
        return resp;
    }
    
   
    
   
    
    
    
}