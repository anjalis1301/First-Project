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

public with sharing class InsertDiagnosisStage {

    @AuraEnabled
    public static void fetchData(Id contentDocumentId){
        ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
            // split the file data
            list<String> csvRecordsList = contentVersionObj.VersionData.toString().split('\n');
            System.debug(contentVersionObj);
            System.debug(csvRecordsList);
            Map<String, Schema.SObjectField> stagingFields = Schema.getGlobalDescribe().get('Diagnosis_Code_Stage__c').getDescribe().fields.getMap();
            System.debug(stagingFields);
            Map<String,String> fieldAPINameMap = new Map<String,String>();
            for (Schema.SObjectField field : stagingFields.values()) {
                System.debug(field.getDescribe().getName());
                System.debug(field.getDescribe().getLabel());
                fieldAPINameMap.put(field.getDescribe().getLabel(),field.getDescribe().getName());

            }
            System.debug(fieldAPINameMap);
    }
    
    /**
    *   @method uploadCSVFile
    *   method to upload the CSV FILE
    */
    @AuraEnabled
    public static stageResWrapper uploadCSVFile(Id contentDocumentId) {
        ContentVersion contentVersionObj = [SELECT Id, VersionData FROM ContentVersion WHERE ContentDocumentId =:contentDocumentId];
        // split the file data
        list<String> csvRecordsList = contentVersionObj.VersionData.toString().split('\n');
        
        Map<String, Schema.SObjectField> stagingFields = Schema.getGlobalDescribe().get('Diagnosis_Code_Stage__c').getDescribe().fields.getMap();
        System.debug(stagingFields);
        Map<String,String> fieldAPINameMap = new Map<String,String>();
        for (Schema.SObjectField field : stagingFields.values()) {
            System.debug(field.getDescribe().getName());
            System.debug(field.getDescribe().getLabel());
            fieldAPINameMap.put(field.getDescribe().getLabel(),field.getDescribe().getName());

        }
        System.debug(fieldAPINameMap);
        List<String> csvRows = new List<String>();
        List<string> fieldLabelList = new List<string>();
        stageResWrapper wrapData = new stageResWrapper();
        List<String> recordRes = new List<String>();
        List<Diagnosis_Code_Stage__c> stageList = new List<sObject>(); 
        csvRows = contentVersionObj.VersionData.toString().trim().split('\r');
        for(String st : csvRows[0].split(',')) {
            fieldLabelList.add(st.trim());
        }
        System.debug(csvRows);

        Map<String, SObjectField>   fieldDataMap  = Schema.getGlobalDescribe().get('Diagnosis_Code_Stage__c').getDescribe().fields.getMap();
        for(integer i = 1; i< csvRows.size(); i++) {
            Diagnosis_Code_Stage__c stageRec = new Diagnosis_Code_Stage__c();
            String[] csvRecordData = csvRows[i].trim().split(',(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)');
            for(integer j=0; j < csvRecordData.size(); j++) {
                csvRecordData[j] = csvRecordData[j].unescapeCsv();
                String fldName = fieldLAbelList[j].trim();
                if(fieldAPINameMap.containsKey(fldName)) {
                    Schema.DisplayType fldType = stagingFields.get(fieldAPINameMap.get(fieldLabelList[j])).getDescribe().getType();
                    try {
                        if(fldType == Schema.DisplayType.DATE) {
                            stageRec.put(fieldAPINameMap.get(fldName), Date.valueOf(csvRecordData[j].trim()));
                        }
                        else if(fldType == Schema.DisplayType.DATETIME) {
                            stageRec.put(fieldAPINameMap.get(fldName), DateTime.valueOf(csvRecordData[j].trim()));
                        }
                        else if(fldType == Schema.DisplayType.BOOLEAN) {
                            stageRec.put(fieldAPINameMap.get(fldName), Boolean.valueOf(csvRecordData[j].trim()));
                        }
                         else if(fldType == Schema.DisplayType.DOUBLE) {
                            stageRec.put(fieldAPINameMap.get(fldName), DECIMAL.valueOf(csvRecordData[j].trim()));
                        }
                        else {
                            stageRec.put(fieldAPINameMap.get(fldName), csvRecordData[j].trim());
                        }
                    }
                    catch(Exception e) {
                        System.debug('Errorrrr'+e);
                    }
                } else {
                    System.debug('Incorrect field name');
                }
            }
            System.debug(stageRec+'rec');
            stageList.add(stageRec);
        }
        wrapData.summaryDisplay = true;
        Database.SaveResult[] resultList = Database.insert(stageList, false);
        for (Database.SaveResult rl : resultList) {
            if(!rl.isSuccess()) {
                wrapData.failed++;
                wrapData.total++;
                String error;
                for(Database.Error err : rl.getErrors()) {
                   error += err.getStatusCode() + ': ' + err.getMessage();
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                }
                recordRes.add(error);
            } else {
                // if(rl.isCreated()) {
                   wrapData.inserted++; 
                //  }
                //   else {
                //     wrapData.updated++;
                // } 
                wrapData.total++;
            } 
            wrapData.failedRecordDetail = new List<String>();
            wrapData.failedRecordDetail = recordRes;
        }
        System.debug(wrapData+'data');
        return wrapData;
    }
    public class stageResWrapper {
        public stageResWrapper(){ 
            inserted = 0;
            total = 0;
            failed = 0;            
        }
        @AuraEnabled public Integer total;                  //Total number of records in CSV File
        @AuraEnabled public Integer inserted;                       //Number of records successfully inserted
        @AuraEnabled public Integer failed ;                        //Number of failed records
        @AuraEnabled public List<String> failedRecordDetail;
        @AuraEnabled public Boolean summaryDisplay;				 //Boolean Variable to render summary of upload
    }
}