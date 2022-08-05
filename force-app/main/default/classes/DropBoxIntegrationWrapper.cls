public with sharing class DropBoxIntegrationWrapper {
    public class FileFolder{
        @AuraEnabled public String dType;
        @AuraEnabled public String path_lower;
        @AuraEnabled public String path_display;
        @AuraEnabled public String id;
        @AuraEnabled public String name;             
    }
    public class FileFolderList{
        @AuraEnabled public List<FileFolder> entries = new List<FileFolder>();
    }
}