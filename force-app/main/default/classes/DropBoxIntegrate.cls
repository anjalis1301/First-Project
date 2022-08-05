public class DropBoxIntegrate {

    private static IntegrationMeta__mdt googledt = [select Client_ID__c,Client_Secret__c,Redirect_Uri__c from IntegrationMeta__mdt where  Label='DropBox'];
    private static String redirectionurl = googledt.Redirect_Uri__c;
    private static String clientid = googledt.Client_ID__c;
    private static String clientsecretcode = googledt.Client_Secret__c;
    private static String accesstoken;
    Private static List<DropBoxIntegrateWrapper.FileFolderWrap> data ;
    Private static DropBoxIntegrateWrapper.FileFolderListWrap filefolder;
    private static String folderid;	
    @AuraEnabled
    /*
*@ description : This method call when user click in tab and check the access_token that saved in object or not
*@ params : none
*@ returns : method returns IntegrateGeneralWrapper.checkaccesstoken object
*/
    public static IntegrateGeneralWrapper.checkaccesstoken getLogin(){
        system.debug('getLogin  called>> ');
        IntegrateGeneralWrapper.checkaccesstoken result = new IntegrateGeneralWrapper.checkaccesstoken();
        String url;
        IntegrateGeneralWrapper.FileWrapper3 fileandfolder;
        System.debug('<<<<<<<<<<<>>>> user id' + userInfo.getUserId());
        list<Integration_Data__c> info = [select AccessToken__c,RefreshToken__c from Integration_Data__c where userID__c =: userInfo.getUserId()];
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>> ' +info.size());
        if(info.size() == 0){
            url = DropBoxIntegrateService.Authentication(clientid,redirectionurl);
            result.flag = false;	
            result.str = url;           
        }else{
            System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Else Part');
            result.flag = true;	
            result.str = info[0].AccessToken__c;
            //fileandfolder = LBoxIntegrationControllerService.getRootFolder(folderid, info[0].Access_Token__c);
        }
        system.debug('result>>>>>>>>>>>>>>>>>>>>>>> '+result);
        return result;
    }
    /*
*@ description : This method call for get access token  
*@ params : 1. authorizationcode :- auth code which is use in get access token
*@ returns : method returns string
*/
    @AuraEnabled
    public static String getAccessTkn(String authorizationcode){
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>getAccessTkn authorizationcode' + authorizationcode );
        //accesstoken = DropBoxIntegrateService.getToken(authorizationcode,clientid,clientsecretcode,redirectionurl);
        DropBoxIntegrateService.getToken(authorizationcode,clientid,clientsecretcode,redirectionurl);
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>getAccessTkn called' + accesstoken );
        return accesstoken;
    }
    /*
*@ description : This method call for get all files and folders of root folder  
*@ params : 1. accesstoken :- auth code which is use in get all files and folders
*@ returns : method returns List of DropBoxIntegrateWrapper.FileFolderWrap type
*/   
    @AuraEnabled
    public static List<DropBoxIntegrateWrapper.FileFolderWrap> getFileFolder(String accesstoken){
        data = new List<DropBoxIntegrateWrapper.FileFolderWrap>();
        filefolder = new DropBoxIntegrateWrapper.FileFolderListWrap();
        String fid= '';
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>getFileFolder authorizationcode' + accesstoken );
        filefolder = DropBoxIntegrateService.getFileFolders(accesstoken,fid);
        data=listConversion(filefolder);
        system.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>getFileFolder called' + data );
        return data;
    }
    /*
*@ description : This method call for open folder and get metadata of folder  
*@ params : 1. accesstoken :- auth code which is use in get all files and folders
			2. Path :- this is path/id of folder which we want to open
*@ returns : method returns List of DropBoxIntegrateWrapper.FileFolderWrap type
*/   
    @AuraEnabled
    public static List<DropBoxIntegrateWrapper.FileFolderWrap> openFolders(String Path, String accesstoken){
        System.debug('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< openFolders called >>>>>>>>>>>>>>>>>>>>>>>>>>>');
        System.debug('accesstoken>> ' + accesstoken);
        data = new List<DropBoxIntegrateWrapper.FileFolderWrap>();
        filefolder = new DropBoxIntegrateWrapper.FileFolderListWrap();
        System.debug('entry.path>> ' + Path);
        filefolder = DropBoxIntegrateService.getFileFolders(accesstoken,Path); 
        data=listConversion(filefolder);
        return data;
    }
    /*
*@ description : This method call for open file  
*@ params : 1. accesstoken :- auth code which is use in get all files and folders
			2. FilePath :- this is path/id of file which we want to open
*@ returns : method returns List of IntegrateGeneralWrapper.FileWrapper1 type
*/     
    @AuraEnabled
    public static String openFiles(String accesstoken,String FilePath){
        System.debug('openFiles called' );
        return  DropBoxIntegrateService.viewFiles(FilePath,accesstoken);
    }
    /*
*@ description : This method call for download file  
*@ params : 1. accesstoken :- auth code which is use in get all files and folders
			2. Path :- this is path/id of folder which we want to download
*@ returns : method returns string
*/  
    @AuraEnabled
    public static String downloadFiles(String accesstoken,String Path){
        return DropBoxIntegrateService.downloadFiles(path,accesstoken);
    }
    /*
*@ description : This method call for delete file and folder  
*@ params : 1. accesstoken :- auth code which is use in get all files and folders
			2. Path :- this is path/id of folder/file which we want to delete
			3. parentPath :- parent folder id/path in which use to get updated files 
*@ returns : method returns List of DropBoxIntegrateWrapper.FileFolderWrap type
*/   
    @AuraEnabled
    public static List<DropBoxIntegrateWrapper.FileFolderWrap> deletefileFolder(String accesstoken,String Path,String parentPath){
        System.debug(' deletefileFolder called >>>>>>>>>>>');
        data = new List<DropBoxIntegrateWrapper.FileFolderWrap>();
        filefolder = new DropBoxIntegrateWrapper.FileFolderListWrap();
        DropBoxIntegrateService.deleteFilesAndFolders(Path,accesstoken);
        filefolder = DropBoxIntegrateService.getFileFolders(accesstoken,parentPath); 
        data=listConversion(filefolder);
        return data; 
    }
    /*
*@ description : This method call for createNewFolder  
*@ params : 1. access_Token :- auth code which is use in get all files and folders
			2. newFolderName :- contain name of new folder
			3. parentPath :- parent folder id/path in which use to get updated files 
*@ returns : method returns List of DropBoxIntegrateWrapper.FileFolderWrap type
*/      
    @AuraEnabled
    public static List<DropBoxIntegrateWrapper.FileFolderWrap> createNewFolder(String newFolderName, String access_Token, String ParentPath){
        system.debug('createNewFolder>>>>>>>>>>> ');
        data = new List<DropBoxIntegrateWrapper.FileFolderWrap>();
        filefolder = new DropBoxIntegrateWrapper.FileFolderListWrap();
        Integer statusCode = DropBoxIntegrateService.createFolder(newFolderName,access_Token,ParentPath);
        if(statusCode == 200){
            filefolder = DropBoxIntegrateService.getFileFolders(access_Token,ParentPath);
            data = listConversion(filefolder);
        }
        system.debug('data>>>' + data);
        return data;
        
    }
    /*
*@ description : This method call for upload file in any folder  
*@ params : 1. accesstoken :- auth code which is use in get all files and folders
			2. filebody :- body of file which we want to upload 
			3. filename :- store file name we want to upload 
			4. parentPath :- parent folder id/path in which use to get updated files 
			5. filetype :- contain file type we want to upload
*@ returns : method returns List of DropBoxIntegrateWrapper.FileFolderWrap type
*/   
    @AuraEnabled
    public static List<DropBoxIntegrateWrapper.FileFolderWrap> upload(String filebody,String filename,String ParentPath, String accesstoken,String filetype ){
        System.debug('filebody is main controller : '+filebody);
        data = new List<DropBoxIntegrateWrapper.FileFolderWrap>();
        filefolder = new DropBoxIntegrateWrapper.FileFolderListWrap();
        system.debug('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>filename   '+filename);
        if(filename !=null && filebody != null){
            DropBoxIntegrateService.filesUpload(ParentPath, filename, accesstoken,  filebody );
            filebody = '';
            filefolder = DropBoxIntegrateService.getFileFolders(accesstoken,ParentPath);
            data = listConversion(filefolder);
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please choose a file first'));
        }
        return data;
    }
    /*
*@ description : This method call for convet response of file folder to a list of DropBoxIntegrateWrapper.FileFolderWrap type
*@ params : 1. fileandfolder :- DropBoxIntegrateWrapper.FileFolderListWrap obj contain filesAndFolders
*@ returns : method returns List of DropBoxWrapper.FileFolderWrap type
*/      
    public static List<DropBoxIntegrateWrapper.FileFolderWrap> listConversion(DropBoxIntegrateWrapper.FileFolderListWrap fileandfolder){
        data = new List<DropBoxIntegrateWrapper.FileFolderWrap>();
        For(DropBoxIntegrateWrapper.FileFolderWrap record : fileandfolder.entries){
            System.debug(' e1 >>>>>>>>>>>'+record);
            if(record.type == 'folder'){
                record.temp = true;
            }else{
                record.temp = false;
            }
            data.add(record);
        }
        return data;
    }

}