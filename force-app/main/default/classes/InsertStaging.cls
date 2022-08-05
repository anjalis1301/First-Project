/***********************************************************************************************
Apex Class Name     : InsertDiagnosisStage
Version             : 1.0
Created Date        : 13 August 2021
Description         : Insert Diagnosis Code Staging Records through CSV
Author              : Anjali Sharma

Modification Log    : 
* Developer                   Date                    Description
* ----------------------------------------------------------------------------------                 
* Anjali Sharma             13/August/2021           Original Version. Refer: SAL-227
************************************************************************************************/

public with sharing class InsertStaging {  
    
    //methos to return if any records with queued status 
    @AuraEnabled
    public static List<SObject> checkStageRecords(String objName){
        String query = 'SELECT Id FROM '+objName+' WHERE ';
        if(objName == 'Diagnosis_Code_Stage__c') {
            query += 'Processing_Status__c = \'Queued\'';
            
        }else {
            query += 'Status__c = '+null;            
        }
        System.debug(query+'Query');
        List<sobject> stageList = Database.query(query);
        
        if(stageList.size() > 0) {
            return stageList;
        } else {
            return null;
        }
    }  
    /**
    *   @method uploadCSVFile
    *   method to upload the CSV FILE
    */
    @AuraEnabled
    public static StageResWrapper uploadCSVFile(Id contentDocumentId, String objectName) {
        //Query the ContentVersion based on id
        ContentDocument doc = [SELECT id  from ContentDocument WHERE Id = :contentDocumentId];
        ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
        Map<String, Schema.SObjectField> stagingFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        Map<String,String> fieldAPINameMap = new Map<String,String>();
        List<String> csvRows = new List<String>();
        List<string> fieldLabelList = new List<string>();
        Set<String> fieldNameSet = new Set<String>();
        StageResWrapper wrapData = new StageResWrapper();
        List<String> recordRes = new List<String>();
        List<sobject> stageList = new List<sObject>();

        //loop to get fill the label and name map
        for (Schema.SObjectField field : stagingFields.values()) {
            fieldAPINameMap.put(field.getDescribe().getLabel(),field.getDescribe().getName());
        }
         
        //stored data row wise
        csvRows = contentVersionObj.VersionData.toString().trim().split('\r');

        // get the header label list
        for(String st : csvRows[0].split(',')) {
            fieldLabelList.add(st.trim());
        }
        Boolean isException = false;
        //Process the rows data except of the first row that contains field label
        for(Integer i = 1; i< csvRows.size(); i++) {
            Type customType = Type.forName(objectName);
            sobject stageRec = (sobject)customType.newInstance();
            //Diagnosis_Code_Stage__c stageRec = new Diagnosis_Code_Stage__c();
            String[] csvRecordData = csvRows[i].trim().split(',(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)');
            //Process the field data (columns) 
            List<String> keyList = new List<String>();
            keyList.addAll(fieldAPINameMap.keySet());
            System.debug('list' +keyList);
            String keyStr = '-,-' + String.join(keyList, '-,-') + '-,-';
            System.debug('string '+keyStr);
            //System.debug(keyStr.containsIgnoreCase('AGE'));
            for(Integer j=0; j < csvRecordData.size(); j++) {
                csvRecordData[j] = csvRecordData[j].unescapeCsv();
                String fldName = fieldLabelList[j].trim();
               // if(fieldAPINameMap.containsKey(fldName)) {
                if(keyStr.containsIgnoreCase('-,-' +fldName + '-,-')) {
                    String newSubStr = keyStr.substring(0, keyStr.indexOfIgnoreCase('-,-'+fldName+'-,-'));
                    Integer indexNumber = newSubStr.countMatches('-,-');
                    System.debug('index'+indexNumber);
                    System.debug('val'+keyList[indexNumber]);
                    String fldLabel = keyList[indexNumber].trim();
                    Schema.DisplayType fldType = stagingFields.get(fieldAPINameMap.get(fldLabel)).getDescribe().getType();
                    try {
                        if(fldType == Schema.DisplayType.DATE) {
                            stageRec.put(fieldAPINameMap.get(fldLabel), Date.valueOf(csvRecordData[j].trim()));
                        }
                        else if(fldType == Schema.DisplayType.DATETIME) {
                            stageRec.put(fieldAPINameMap.get(fldLabel), DateTime.valueOf(csvRecordData[j].trim()));
                        }
                        else if(fldType == Schema.DisplayType.BOOLEAN) {
                            stageRec.put(fieldAPINameMap.get(fldLabel), Boolean.valueOf(csvRecordData[j].trim()));
                        }
                         else if(fldType == Schema.DisplayType.DOUBLE) {
                            stageRec.put(fieldAPINameMap.get(fldLabel), DECIMAL.valueOf(csvRecordData[j].trim()));
                        }
                        else {
                            stageRec.put(fieldAPINameMap.get(fldLabel), csvRecordData[j].trim());
                        }
                    }
                    catch(Exception e) {
                        isException = true;
                        recordRes.add('Error : '+ e +'<br /> In field : '+fldLabel +'<br /> Record : '+stageRec);
                        wrapData.failed++;
                        wrapData.total++;
                        // ErrorLogHandler.LogException(e,'InsertStaging');                        
                    }
                } else {
                    fieldNameSet.add('Incorrect field label(Column Ignored) : '+ fldName);
                }
            }
            if(!isException){
                stageList.add(stageRec);
            }
            isException = false;
            
        }
        wrapData.summaryDisplay = true;
        Database.SaveResult[] resultList = Database.insert(stageList, false);
        Integer index = 0;
        for (Database.SaveResult res : resultList) {
            
            if(!res.isSuccess()) {
                wrapData.failed++;
                wrapData.total++;
                String error;
                for(Database.Error err : res.getErrors()) {
                   error += 'Error : '+err.getStatusCode()+ err.getMessage()+ ' In record '+ stageList[index];
                }
                // ErrorLogHandler.LogException(String.valueOf(res.getErrors()),'InsertStaging','uploadCSVFile');
                recordRes.add(error);
            } else {
                wrapData.inserted++;
                wrapData.total++;
            } 
            index++;
        }
            wrapData.errorDetails = new List<String>();
            
        	if(fieldNameSet.size() > 0 ){
                recordRes.addAll(fieldNameSet);
            }
        	wrapData.errorDetails = recordRes;
            
        delete doc;
        return wrapData;
    }

    //Wrapper class to store the processed stage records results
    public class StageResWrapper {
        public StageResWrapper(){ 
            inserted = 0;
            total = 0;
            failed = 0;            
        }
        @AuraEnabled public Integer total;                          //Total number of records in CSV File
        @AuraEnabled public Integer inserted;                       //Number of records successfully inserted
        @AuraEnabled public Integer failed ;                        //Number of failed records
        @AuraEnabled public List<String> errorDetails;        //Details of failed records if any
        @AuraEnabled public Boolean summaryDisplay;				 //Boolean Variable to render summary of upload
    }
}