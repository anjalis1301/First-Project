public class ClientSidePaginationDynamicController {
   
    @AuraEnabled
    public static List<String> listAllObject(){
        List<String> objectList = new List<String>();
        For(Schema.sObjectType sobj: schema.getGlobalDescribe().values()){
            if(sobj.getDescribe().isQueryable())
                objectList.add(sobj.getDescribe().getName()+'####'+sobj.getDescribe().getLabel());
        }
        return objectList;
    }
    
    
    @AuraEnabled
    public static  List<DynamicWrapper> dataList(String objectName,string fieldList){
        List<DynamicWrapper> dyWrap = new List<DynamicWrapper>();
        system.debug(objectName+ ' object');
        system.debug('fieldName '+ fieldList);
        
        String fields = (string)fieldList;
        String query = 'SELECT ' + fieldList + ' from '+objectName; 
        system.debug('query '+query);
      	List<sObject> data = Database.Query(query);
        System.debug('data'+data);
        for(sObject sObj:data){
            dyWrap.add(new DynamicWrapper(false,sObj));
        }
        system.debug('dataWrapper '+dyWrap);
        return dyWrap;
    }
        
    @AuraEnabled
    public static List<fieldDataWrapper> listFields(String objectName) {
        Map<String,String> fieldVal = new Map<String,String>();        
        List<fieldDataWrapper> wrapperList =  new List<fieldDataWrapper>();
        Map<String, Schema.SObjectField> objFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        for(Schema.SObjectField field : objFields.values()) {
            if(field.getDescribe().isAccessible() && field.getDescribe().isSortable()) {
                fieldDataWrapper wrapper = new fieldDataWrapper();
                wrapper.label = field.getDescribe().getLabel();
                wrapper.apiName = field.getDescribe().getName();
                wrapperList.add(wrapper);
                //fieldVal.put(field.getDescribe().getName(), field.getDescribe().getLabel());
            }
        }
        return wrapperList;
    }
    
   /* @AuraEnabled
    public static DynamicBindingWrapper listAllFields(String objectName){
        DynamicBindingWrapper dynamicData = new DynamicBindingWrapper();
        List<fieldDataWrapper> wrapperList =  new List<fieldDataWrapper>();
        // Create Dynamic Query Start ..
        String theQuery = 'SELECT ';
        SObjectType sObjectName = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = sObjectName.getDescribe().fields.getMap();
        For(Schema.SObjectField field : mfields.values()){
            If(field.getDescribe().isAccessible() && !field.getDescribe().getName().EndsWith('Id')
               && field.getDescribe().getName()!='CreatedDate' && field.getDescribe().getName()!='LastModifiedDate'
               && field.getDescribe().getName()!='LastReferencedDate' && field.getDescribe().getName()!='LastReferencedDate'
               && field.getDescribe().getName()!='LastActivityDate' && field.getDescribe().getName()!='LastViewedDate'
               && field.getDescribe().getName()!='IsDeleted'){
               fieldDataWrapper wrapper = new fieldDataWrapper();
               theQuery += field.getDescribe().getName() + ',' ;
                wrapper.label = field.getDescribe().getLabel();
                wrapper.apiName = field.getDescribe().getName();
                wrapperList.add(wrapper);
           } 
        }
        // Trim last comma
        theQuery = theQuery.subString(0, theQuery.length() - 1);
        // Finalize query string
        theQuery += ' FROM '+objectName+' LIMIT 15';
        // Query End ..
        System.debug('#### theQuery = '+theQuery);
        List<sObject> objectData = Database.Query(theQuery);
        if(objectData!=null && objectData.size()>0)
            dynamicData.sObjectData = objectData;
        else
            dynamicData.sObjectData = new List<sObject>{};
        dynamicData.fieldList = wrapperList;
        System.debug('#### dynamicData '+dynamicData);
        return dynamicData;
    }
    /* Class to store the dynamic data 
     * and list of related fields
     */ 
    /*public class DynamicBindingWrapper{
        @AuraEnabled
        public List<sObject> sObjectData    { get; set; }
        @AuraEnabled
        public List<fieldDataWrapper> fieldList { get; set; }
    }*/
    /*
     * Class to store the field information
     */
    public class DynamicWrapper {
        @AuraEnabled
        public sObject sObjectData{get;set;} 
        @AuraEnabled
        public boolean isChecked{get;set;}
        public DynamicWrapper(boolean isChecked, sObject sObjectData){
            this.isChecked = isChecked;
            this.sObjectData = sObjectData;
        }
    }
    public class fieldDataWrapper{
        @AuraEnabled
        public String label { get; set; }
        @AuraEnabled
        public String apiName { get; set; }
    }
}