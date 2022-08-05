public class IntegrateGeneralWrapper {
	/*
* @ description : These wrapper classes are use Box.com intifration classes IntegrationWithBoxServiceClass and IntegrationWithBoxController
* 
* @ date : 6 june 2019
*/
    public class FileWrapper3{
        @AuraEnabled
        public FileWrapper2 item_collection{get;set;}
    }
    public Class FileWrapper2{
        @AuraEnabled
        public List<FileWrapper1> entries{get;set;}
    }
    public class FileWrapper1{
        @AuraEnabled public String type{get;set;}
        @AuraEnabled public String id{get;set;}
        @AuraEnabled public String name{get;set;}
        @AuraEnabled public Boolean temp;
    }
    public class TokenWrapper{
        @AuraEnabled public String access_token{get;set;}
        @AuraEnabled public String Refresh_Token;
    }
    public class checkaccesstoken{
        @AuraEnabled public Boolean flag;
        @AuraEnabled public String str;
    } 
    
    public class OpenFileWrap{
        @AuraEnabled public Shared_linkWrap shared_link;
    }
    public class Shared_linkWrap{
        @AuraEnabled public String url;
        @AuraEnabled public String download_url;
    }
}