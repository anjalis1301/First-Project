/*************************************************************************************@@
ClassName	: RecordsFromEmail
Author		: Anjali Sharma
CreateDate	: 05/02/2021
Purpose		: To insert or update the records of any object comming from an email 
*************************************************************************************/

global class RecordsFromEmail implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String recordString = email.plainTextBody.subStringBefore('\n\n');
        List<sObject> recordsToUpsert = new List<sObject>();
        List<String> objectRecords = recordString.split('##');
        try {
            for(String recordLine : objectRecords) {
                String[] recordData = recordLine.split('#');
                SObject sObj = (SObject)Type.forName(recordData[0]).newInstance();
                for(integer i = 1; i<recordData.size(); i += 2) {
                    sObj.put(recordData[i], recordData[i+1]);
                }
                recordsToUpsert.add(sObj);
            }
            List<Database.UpsertResult> upRes =  Database.upsert(recordsToUpsert,false);
            for(Database.UpsertResult res : upRes) {
                if(!res.isSuccess()) {
                    for(Database.Error err : res.getErrors()) {
                    	result.message = 'Cannot upsert record because '+ err.getMessage();
                	}
                }
            }
        }
        
        catch (Exception e) {
            result.success = false;
            result.message = 'Cannot upsert records because '+e.getMessage();
        }
        return result;
    }
    
}


/*
String objName = recordLine.subStringBefore('#');
                recordLine = recordLine.subStringAfter('#');
                SObject sObj = (SObject)Type.forName(objName).newInstance();
                for(integer i=0;i<recordLine.length();i++) {
                    String fldName = recordLine.subStringBefore('#');
                    recordLine = recordLine.subStringAfter('#');
                    String fldValue = recordLine.subStringBefore('#');
                    recordLine=recordLine.subStringAfter('#');
                    sObj.put(fldName, fldValue);
                }

*/