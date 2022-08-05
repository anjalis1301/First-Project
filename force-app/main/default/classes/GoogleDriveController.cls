/*************************************************************************************@@
Class Name     :  GoogleDriveController
Purpose        :  To get all the necessary information from page and pass it to service class   
DATE           :  09/02/2021
Author         :  Anjali Sharma
*********************************************************************************************************/


public class GoogleDriveController {
    private String code ; //Fetched from URL
    private string key ;// '365607917896-qpharcdjf4b9ott5lcc1rj0kh9pg9pbc.apps.googleusercontent.com' ;
    private string secret ;// 'yeDSO8QsxPerTYHwzYRurg9F' ;
    private string redirect_uri ;//'https://'+System.Url.getSalesforceBaseUrl().getHost()+'/apex/GoogleDrivePage' ;
    public String accessToken;
    private String refreshToken;   //1//0eH5e9VIcX6eXCgYIARAAGA4SNwF-L9IremD4kxfDueQMmdi3bTWdwS6ndHyvj7eGu5wyeatrCvJVmNL4ex8VQGu6NjUJO4Phf0s
    public String selectId {get;set;}
    Drive_Setting__mdt metaSettings = new Drive_Setting__mdt();
    GoogleDrive__c driveToken = new GoogleDrive__c();
    public List<ItemsData> driveData{get;private set;} 
    public Integer driveDataSize {get;private set;}
    public blob file {get;set;}
    public String  filetype {get;set;}
    public String   uFileName {get;set;}
    public Integer uFileSize{get; set;}
    public List<ItemsData> driveNav{get;private set;}
    public String delSelectId {get;set;}
    public String newFolderName {get;set;}
    public Boolean refreshFlag;
    public Boolean accessThroughCode{get;set;}
    public Boolean uploadShow {get;private set;}
    
    public GoogleDriveController() {
        driveData = new List<ItemsData>();
        driveNav = new List<ItemsData>();
        selectId = 'root';
        uploadShow = false;
        driveDataSize=0;
        refreshFlag = false;
        accessThroughCode = false;
        driveNav.add(new ItemsData('root','My Drive','','',''));
    }
    
    public void displayUpload() {
        uploadShow = true;  
    }
    
    //Authenticating
    public PageReference DriveAuth() {
        metaSettings = [Select id,Client_Id__c,Client_secret__c,Redirect_Url__c from Drive_Setting__mdt limit 1];
        try {
            driveToken = [SELECT id, Access_token__c,Refresh_Token__c,Expire_In__c FROM GoogleDrive__c];
        }
        catch(Exception e) {
            accessThroughCode = true;
        }
        PageReference pg;
        key = metaSettings.Client_Id__c;
        secret = metaSettings.Client_secret__c;
        redirect_uri = metaSettings.Redirect_Url__c; 
        if(accessThroughCode || refreshFlag ) {
            code = ApexPages.currentPage().getParameters().get('code');
            if(code == '' || code == null) {
                pg = new PageReference(GoogleDriveServiceController.googleDriveAuthUri(key , redirect_uri)) ;
            } else if(code != '' && code != null) {
                AccessToken();
                fileDetails();
                upsert driveToken;
            }
        }
        else {
            System.debug('expireTime '+  driveToken.Expire_In__c);
            if(System.now() >= driveToken.Expire_In__c) {
                System.debug('driveToken.Expire_In__c'+driveToken.Expire_In__c);
                AccessThroughRefreshToken();
                fileDetails();
                update driveToken;
            } else {
                fileDetails();
            }
        }
        return pg ;
    }
    //Access Token through code
    public void AccessToken() {
        if(refreshFlag) {
            
        }
        HttpResponse res = GoogleDriveServiceController.accessTokenById(code,key,secret,redirect_uri);
        if(res.getBody() != null && res.getStatusCode() == 200 ) {
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            if(results.get('access_token') != null) {
                accessToken=string.valueOf(results.get('access_token'));
                driveToken.Access_Token__c = accessToken;
            }
            if(results.get('refresh_token') != null) {
                refreshToken=string.valueOf(results.get('refresh_token'));
                driveToken.Refresh_Token__c = refreshToken;
            }
            if(results.get('expires_in') != null) {
                driveToken.Expire_In__c =System.now().addSeconds(integer.valueOf(results.get('expires_in')));
            }
        }      
    }
    
    //Access Token Through Refresh Token
    public void AccessThroughRefreshToken() {
        String refreshT = driveToken.Refresh_Token__c;
        HttpResponse res = GoogleDriveServiceController.accessTokenByRefreshToken(refreshT,key,secret);
        if(res.getBody() != null && res.getStatusCode() == 200 ) {
            Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            if(results.get('access_token') != null) {
                accessToken=string.valueOf(results.get('access_token'));
                driveToken.Access_Token__c = accessToken;
            }
            if(results.get('expires_in') != null) {
                driveToken.Expire_In__c =System.now().addSeconds(integer.valueOf(results.get('expires_in')));
            }
        }
        else if(res.getStatusCode() == 400) {
            refreshflag = true;
            driveAuth();
        }      
    }
    //Details of files and folders inside a particular folder
    public void fileDetails() {
        Integer index = -1 ;
        for(ItemsData iData : driveData) {
            if(iData.id == selectId) {
                driveNav.add(iData);
                break;
            }
        }
        driveData.clear();
        for(ItemsData iData:driveNav) {
            index++;
            if(iData.id == selectId) {
                break;
            } 
        }
        List<ItemsData> tempNav = new List<ItemsData>();
        for(integer i = 0;i <= index;i++) {
            tempNav.add(driveNav[i]);
        }
        driveNav = tempNav;
        String accT = driveToken.Access_Token__c;
        HttpResponse resp = GoogleDriveServiceController.fetchFiles(accT,selectId);
        fromJSON parser = fromJSON.parse(resp.getBody());
        for(fromJSON.Items itemObj:parser.items) {
            driveData.add(new ItemsData(itemObj.id,itemObj.title,itemObj.mimeType,itemObj.alternateLink,itemObj.downloadUrl));
        }
        driveDataSize = driveData.size();
        if(driveDataSize > 0) {
            driveData.sort();
        }
    }
    
    public void upload() {
        if(uFileSize < 5000000) {
            String accT = driveToken.Access_Token__c;
            String bodyEncoded = EncodingUtil.base64Encode(file);
            HttpResponse resp =GoogleDriveServiceController.uploadFile(accT,uFileName,filetype,selectId,bodyEncoded);
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'File Size Too Big Must Be < 5Mb'));
        } 
        file = null;
        filetype = '';
        uFileName = '';
        uploadShow = false; 
        fileDetails();
    }
    
    public void deleteData() {
        System.debug('id'+delSelectId);
        String accT = driveToken.Access_Token__c;
        HttpResponse resp = GoogleDriveServiceController.deleteData(accT,delSelectId);
        fileDetails();
    }
    
    public void createFolder() {
        System.debug('inCreate');
        String accT = driveToken.Access_Token__c;
        HttpResponse resp = GoogleDriveServiceController.createFolder(accT,newFolderName,selectId);
        newFolderName='';
        fileDetails();
    }
    public PageReference downloadFile() {
        String url;
        for(ItemsData ida:driveData) {
            if(ida.id == selectId) {
              url  = ida.downloadLink;
            }
        }
        if(url == '') {
            return null;
        }
       
       
       
        String downUrl = url+'&access_token='+driveToken.Access_Token__c;
        System.debug('downUrl'+downUrl);
         
     PageReference pag = new PageReference(downUrl);
     return pag;
    }
    public class ItemsData implements Comparable{
        public String id {get;set;} 
        public String title {get;set;} 
        public String mimeType {get;set;} 
        public String alternateLink {get;set;}
        public String type{get;set;}
        public String downloadLink {get;set;}
        public String downloadUrl {get;set;}
        public ItemsData(String id,String title,String mimeType,String alternateLink, String downloadUrl) {
            this.id = id;
            this.title = title;
            this.mimeType = mimeType;
            this.alternateLink = alternateLink;
            this.downloadUrl = downloadUrl;
            String down = 'https://drive.google.com/u/0/uc?id='+id+'&export=download';
            downloadLink= mimeType.contains('application/vnd.google-apps')?'':down;
            type=mimeType.substringAfterLast('.')=='Folder'?'Folder':mimeType.contains('application/vnd.google-apps')?'Drive File':'File';
            
        }
        public Integer compareTo(Object compareTo) {
            ItemsData iData = (ItemsData)compareTo;
            Integer retVal=0;
            if(iData.type.contains('File')) {
                retVal = 1;
            } else if(iData.type.contains('Folder')) {
                retVal = -1;
            }
            return retVal;
        }
    }  
}