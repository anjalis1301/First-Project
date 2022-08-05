/*************************************************************************************@@
Class Name     :  KanbanView
Purpose        :  To query the necessary data an d return it to the javascript helper  
DATE           :  11/03/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
public with sharing class KanbanView {
    /**  @method objectNames
    *   Remote method to return Map of objects label and api name to the component helper	    
    */
    @AuraEnabled 
    public static Map<String,String> objectNames() {
        Map<String,String> objNames = new Map<String,String>();
        Map<String,Schema.SObjectType> globalData = Schema.getGlobalDescribe();
        for(Schema.SObjectType obj: globalData.values()) {            
            Schema.DescribeSObjectResult sObjRes = obj.getDescribe();
            if(sObjRes.isAccessible() && sObjRes.isQueryable() && sObjRes.isCreateable() && sObjRes.isUpdateable() && sObjRes.isSearchable()) {
                Integer count = 0;
                for(Schema.SObjectField sObjField :sObjRes.fields.getMap().values()) {                    
					Schema.DisplayType fldType = sObjField.getDescribe().getType();
                   	if(fldType == Schema.DisplayType.PickList) {
                        count++;
                    } 
                }
                if(count > 0) {
                    objNames.put(obj.getDescribe().getLabel() , obj.getDescribe().getName());
                }
            }
        }
        return objNames;
    }
    
    /**  @method fieldsAndPkLst
    *   Remote method to return fields and pickList fields label and api name as a wrapper to the component helper	    
    */
    @AuraEnabled
     public static fieldsAndPkLstWrapper fieldsAndPkLst(String objName) {
        fieldsAndPkLstWrapper dataWrap = new fieldsAndPkLstWrapper();
        dataWrap.pickLst = new Map<String,String>();
        dataWrap.fieldMap = new Map<String,String>();
        Map<String,Schema.SObjectField> fields = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        for(Schema.SObjectField sObjField : fields.values()) {
            Schema.DisplayType fldType = sObjField.getDescribe().getType();
            if(fldType == Schema.DisplayType.PickList) {
                dataWrap.pickLst.put(sObjField.getDescribe().getLabel(),sObjField.getDescribe().getName());
            } 
            dataWrap.fieldMap.put(sObjField.getDescribe().getLabel(), sObjField.getDescribe().getName());            
        }
        return dataWrap;
    }
    
    /**  @method getData
    *   Remote method to return records and selected pickList values as a wrapper to the component helper	    
    */
    @AuraEnabled public static dataAndPickListWrapper getData(String objName, List<String> fields, String pickListName) {
        List<String> pickListVals = new List<String>();
        dataAndPickListWrapper dataWrap = new dataAndPickListWrapper();
        for(Schema.PicklistEntry val: Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(pickListName).getDescribe().getPickListValues()) {
            pickListVals.add(val.getValue());
        } 
        dataWrap.pickListValues = pickListVals;
        String query = 'SELECT '+ fields[0] + ' FROM '+ objName;
        List<sObject> records = Database.query(query);
        dataWrap.objRecords = records;
        return dataWrap;
    }
    
    /**  @method updatePickVal
    *   Remote method to update the pickList value of a record	    
    */
    @AuraEnabled
    public static void updatePickVal(Id selectId, String selectPickFld, String newVal,String selectObj, String selectFlds) {
        SObject obj = selectId.getSObjectType().newSObject(selectId);
        obj.put(selectPickFld,newVal);
        update obj;
    }
    
    
    public class fieldsAndPkLstWrapper {
        @AuraEnabled public Map<String,String> fieldMap;
        @AuraEnabled public Map<String,String> pickLst;
        
    }
    
    public class dataAndPickListWrapper {
        @AuraEnabled public List<sObject> objRecords;
        @AuraEnabled public List<String> pickListValues;
    }
}