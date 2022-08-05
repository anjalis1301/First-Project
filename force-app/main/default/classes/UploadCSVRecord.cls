/*************************************************************************************@@
ClassName	: UploadCSVRecord
Author		: Anjali Sharma
CreateDate	: 02/02/2021
Purpose		: To insert or update the records of contact comming from a csv file 
*************************************************************************************/

public class UploadCSVRecord {
    public Blob csvBody {get; set;}
    public String csvName {get; set;}
    public WrpClass wrapData {get;private set;}
    
    public UploadCSVRecord() {
        wrapData = new wrpClass();
        wrapData.inserted = 0;
        wrapData.total = 0;
        wrapData.failed = 0;
        wrapData.updated = 0;
    }
    
    public class wrpClass {
        public Integer total {get; private set;}                         //Total number of records in CSV File
        public Integer inserted {get; private set;}                      //Number of records successfully inserted
        public Integer failed {get; private set;}                        //Number of failed records
        public Integer updated {get; private set;} 						//Number of updated records
        public Boolean summaryDisplay {get; private set;}				 //Variable to render summary of upload
    }
    
    /**
    *   @method uploadCSVFile
    *   method to upload the CSV FILE
    */
    public void uploadCSVFile() {
        List<String> csvRows = new List<String>();
        List<string> fieldList = new List<string>();
        List<Contact> conUpsertList = new List<sObject>(); 
        if(! csvName.substringAfter('.').equalsIgnoreCase('csv')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'File is not in csv format'));
        }
        csvRows = csvBody.toString().trim().split('\r');
        for(String st : csvRows[0].split(',')) {
            fieldList.add(st.trim());
        }
        Map<string, SObjectField>   fieldNamesMap  = Schema.SObjectType.Contact.fields.getMap();
        for(integer i = 1; i< csvRows.size(); i++) {
            Contact conRec = new Contact();
            String[] csvRecordData = csvRows[i].trim().split(',(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)');
            for(integer j=0; j < csvRecordData.size(); j++) {
                csvRecordData[j] = csvRecordData[j].unescapeCsv();
                String fldName = fieldList[j].trim();
                if(fieldNamesMap.containsKey(fldName)) {
                    Schema.DisplayType fldType = fieldNamesMap.get(fieldList[j]).getDescribe().getType();
                    try {
                        if(fldType == Schema.DisplayType.DATE) {
                            conRec.put(fldName, Date.valueOf(csvRecordData[j].trim()));
                        }
                        else if(fldType == Schema.DisplayType.DATETIME) {
                            conRec.put(fldName, DateTime.valueOf(csvRecordData[j].trim()));
                        }
                        else if(fldType == Schema.DisplayType.BOOLEAN) {
                            conRec.put(fldName, Boolean.valueOf(csvRecordData[j].trim()));
                        }
                         else if(fldType == Schema.DisplayType.DOUBLE) {
                            conRec.put(fldName, DECIMAL.valueOf(csvRecordData[j].trim()));
                        }
                        else {
                            conRec.put(fldName, csvRecordData[j].trim());
                        }
                    }
                    catch(Exception e) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  e.getMessage()));
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Incorrect field Name'));
                }
            }
            conUpsertList.add(conRec);
        }
        wrapData.summaryDisplay = true;
        Database.UpsertResult[] resultList = Database.upsert(conUpsertList, false);
        for (Database.UpsertResult rl : resultList) {
            if(!rl.isSuccess()) {
                wrapData.failed++;
                wrapData.total++;
                for(Database.Error err : rl.getErrors()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  err.getStatusCode() + ': ' + err.getMessage()));
                }
            } else {
                if(rl.isCreated()) {
                   wrapData.inserted++; 
                } else {
                    wrapData.updated++;
                } 
                wrapData.total++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, wrapData.inserted + wrapData.updated + ' Record(s) inserted or updated sucessfully!!'));
            } 
        }
    }
}