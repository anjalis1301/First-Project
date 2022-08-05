public class DropBoxIntegrateWrapper {
	
    
     public class FileFolderWrap{
     @AuraEnabled public String type;
     @AuraEnabled public String path_lower;
     @AuraEnabled public String path_display;
     @AuraEnabled public String id;
     @AuraEnabled public boolean temp;
     @AuraEnabled public String name;
          
    }
    public class FileFolderListWrap{
      @AuraEnabled public List<FileFolderWrap> entries = new List<FileFolderWrap>();
    }
    
    

}