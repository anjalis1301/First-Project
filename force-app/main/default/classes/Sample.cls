public with sharing class Sample {

    //Public Variables----------------------------------------------------------------------------------------------------------------------------------------------
    public transient Blob    fileBody{ get; set; }                              //fileBody
    public transient Integer fileSize{ get; set; }                              //fileSize
    public transient String  fileName{ get; set; }                              //fileName
    public List<Contact>     contactsList{ get; set; }                          //List of inserted contacts
    public List<String>      fieldNamesList{ get; set; }                        //List of fields in Contact Object's fields which are avaiable in CSV
    public Boolean           reVariableSave{ get; set; }                        //Variable to render Save Button
    public Boolean           reVariableBlock{ get; set; }                       //Variable to render PageBlock with inserted record details
    public Boolean           reVariable{ get; set; }                            //Variable to render Record Details Table    
    public Integer           totalRecords{ get; set; }                          //Total number of records in CSV File
    public Integer           insertedRecords{ get; set; }                       //Number of records successfully inserted
    public Integer           failedRecords{ get; set; }                         //Number of failed records

    //Private Variables----------------------------------------------------------------------------------------------------------------------------------------------
    String fileBodyAsString = '';                                               //String value of file Body
    String header           = '';

    //Constructor----------------------------------------------------------------------------------------------------------------------------------------------------
    public Sample(){
        contactsList        = new List<SObject>();
        fieldNamesList      = new List<String>();
        reVariableSave      = false;
        reVariableBlock     = false;
        reVariable          = false;
        totalRecords        = 0;
        insertedRecords     = 0;
        failedRecords       = 0;    
    }

    //Method to check file size and whether the file body is readable------------------------------------------------------------------------------------------------
    public void ReadFromFile(){
        reVariableBlock = false;
		if(fileSize < 3280760 && fileName.substringAfterLast('.').equalsIgnoreCase('csv')){
            try{
                fileBodyAsString = fileBody.toString();
                ReadCSVFile();
            }
            catch(exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error reading CSV file'));
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No File Chosen or,'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'File Size greater than 50 KB or,'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'File is not of CSV type'));
        }
    }

    //Method to read the file and create a contact list which will be inserted and check exceptions in CSV file------------------------------------------------------
    private void ReadCSVFile(){
        if(fileBodyAsString.length() > 100000){
            header = fileBodyAsString.substring(0, 2000).split('\n')[0];
        }
        else{
            header = fileBodyAsString.split('\n')[0];
        }
        fileBodyAsString = fileBodyAsString.substringAfter('\n');

        contactsList.clear();
        fieldNamesList.clear();
        for(String str : header.split(',')){
            fieldNamesList.add(str.trim());
        }
        String                      contactDetails      = '';
        Map<string, SObjectField>   fieldNamesMap       = Schema.getGlobalDescribe().get('Contact').getDescribe().fields.getMap();

        if(fieldNamesList[0].equalsIgnoreCase('LastName')){
            Contact con             = new Contact();
            Integer flag            = 0; 
            while( !String.isEmpty(fileBodyAsString)){                                                                 //Itereation over each contact
                if(fileBodyAsString.length() > 100000){
                    contactDetails = fileBodyAsString.substring(0, 100000).split('\n')[0];
                }
                else{
                    contactDetails = fileBodyAsString.split('\n')[0];
                }
                fileBodyAsString = fileBodyAsString.substringAfter('\n');
                String lastnameValue = contactDetails.substringBefore(',').trim();
                for(Integer j=0; j<fieldNamesList.size(); j++){                                                                 //Iterating over the fields & assigning value to them for each contact 
                    Schema.DisplayType fieldType = fieldNamesMap.get(fieldNamesList[j]).getDescribe().getType();
                    if( fieldType == Schema.DisplayType.DATE ){              //Setting value of fields which are of Date Type
                        try{
                            con.put(fieldNamesList[j].trim(), Date.valueOf(contactDetails.substringBefore(',').trim()));
                        }
                        catch(Exception e){
                            flag = 1;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Empty ' + fieldNamesList[j].trim() + ' field or Date is not in format \"YYYY-MM-DD\" for record with LastName = ' + lastnameValue));
                        }
                    }
                    else if( fieldType == Schema.DisplayType.DATETIME ){ //Setting value of fields which are of DateTime Type
                        try{
                            con.put(fieldNamesList[j].trim(), Datetime.valueOf(contactDetails.substringBefore(',').trim()));
                        }
                        catch(Exception e){
                            flag = 1;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Empty ' + fieldNamesList[j].trim() + ' field or DateTime is not in format \"YYYY-MM-DD HH:MM:SS\" for record with LastName = ' + lastnameValue));
                        }
                    }
                    else if( fieldType == Schema.DisplayType.BOOLEAN ){  //Setting value of fields which are of Boolean Type
                        if(contactDetails.substringBefore(',').trim().equalsIgnoreCase('true') || contactDetails.substringBefore(',').trim().equalsIgnoreCase('false') || contactDetails.substringBefore(',').trim() == ''){
                            con.put(fieldNamesList[j].trim(), Boolean.valueOf(contactDetails.substringBefore(',').trim()));
                        }
                        else{
                            flag = 1;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'Acceptable value for ' + fieldNamesList[j].trim() + ' field is \"TRUE/FALSE\" for record with LastName = ' + lastnameValue));
                        }
                    }
                    else if( fieldType == Schema.DisplayType.TEXTAREA ){ //Setting value of fields which are of TextArea Type
                        if(contactDetails.left(1) != '\"'){                                                                 //Setting value of fields which are of TextArea Type with comma
                            con.put(fieldNamesList[j].trim(), contactDetails.substringBefore(',').trim());
                        }
                        else{                                                                                               //Setting value of fields which are of TextArea Type without comma
                            con.put(fieldNamesList[j].trim(), contactDetails.substringBetween('\"', '\"') .trim());
                            contactDetails = contactDetails.substringAfter('\"').substringAfter('\"');
                        }
                    }
                    else{                                                                                                   //Setting value of all other type of fields
                        try{
                            con.put(fieldNamesList[j].trim(), contactDetails.substringBefore(',').trim());
                        }
                        catch(Exception e){
                            flag = 1;
                        }
                    }
                    contactDetails = contactDetails.substringAfter(',');
                }
                contactsList.add(con);
                con = new Contact();
            }                  
            if(flag != 1){                                                                                                  //If there is no exception, show Save button
                reVariableSave = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,  'Click Save Button to insert the Records '));
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  'First Column in CSV file is not LastName. Set the first column in CSV file as LastName'));
        }
    }

    //Save method to insert the Contact Recods and counting inserted records and failed records----------------------------------------------------------------------
    public Pagereference save(){
        reVariableBlock = true;
        Database.SaveResult[] srList = Database.insert(contactsList, false);
        contactsList.clear();
        Set<Id> savedContactIdSet = new Set<Id>();
        totalRecords    = 0;
        insertedRecords = 0;
        failedRecords   = 0;
        for (Database.SaveResult sr : srList) {
            ++totalRecords;
            if (!sr.isSuccess()) {
                ++failedRecords;               
                for(Database.Error err : sr.getErrors()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,  err.getStatusCode() + ': ' + err.getMessage() + ' for Record at Line Number: ' + (totalRecords + 1)));
                }
            }
            else{
                ++insertedRecords;
                savedContactIdSet.add(sr.getId());
            }
        }
        contactsList = Database.query('SELECT ' + header + ' FROM Contact WHERE Id in :savedContactIdSet');
        if(contactsList.size() > 0 && contactsList.size()<400){
            reVariable = true;
        }
        return null;
    }
}