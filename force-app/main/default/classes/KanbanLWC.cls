/*************************************************************************************@@
Class Name     :  KanbanViewLWC
Purpose        :  To query the necessary data and return it to the js helper  
DATE           :  18/05/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
public with sharing class KanbanLWC {
    
    /**  @method getData
    *   Remote method to return records and selected pickList values as a wrapper to the component helper	    
    */
    @AuraEnabled public static  Map<String,List<sObject>> getData(String objName, List<String> fields, String pickListName) {
        List<String> pickListVals = new List<String>();
        for(Schema.PicklistEntry val: Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(pickListName).getDescribe().getPickListValues()) {
            pickListVals.add(val.getValue());
        } 
        if(!fields[0].contains(pickListName)) {
            fields[0] += ', '+pickListName;
        }
        String query = 'SELECT '+ fields[0] + ' FROM '+ objName;
        List<sObject> records = Database.query(query);
        Map<String,List<sObject>> actualRec = new Map<String,List<sObject>>();
        for(sObject rec:records) {
            for(String val :pickListVals) {
                if(!actualRec.keySet().contains(val)) {
                    actualRec.put(val,new List<sObject>());
                }
                if(rec.get(pickListName) == val) {
                    actualRec.get(val).add(rec);
                }                
            }    
        }
        return actualRec;
    }
    
    /**  @method updatePickVal
    *   Remote method to update the pickList value of a record	    
    */
    @AuraEnabled
    public static void updatePickVal(Id selectId, String selectPickFld, String newVal) {
        SObject obj = selectId.getSObjectType().newSObject(selectId);
        obj.put(selectPickFld,newVal);
        update obj;
    }
    
}