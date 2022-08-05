public with sharing class BoxIntegrationWrapper {
    
        public class FileWrapper3{
            @AuraEnabled
            public FileWrapper2 item_collection{get;set;}
        }
        public class FileWrapper2{
            @AuraEnabled public List<FileWrapper1> entries{get;set;}
        }
        public class FileWrapper1{
            @AuraEnabled public String type;
            @AuraEnabled public String id;
            @AuraEnabled public String name;
			@AuraEnabled public String errorMess;
			@AuraEnabled public Boolean folderCheck;
        } 
        
       
}