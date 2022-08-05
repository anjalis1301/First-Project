/*************************************************************************************@@
ClassName	: AutoCompleteComponentController
Author		: Anjali Sharma
CreateDate	: 28/01/2021
Purpose		: To show suggestion in the input field and display selected and provide inline editing 
*************************************************************************************/

global  class AutoCompleteComponentController {
    public String fields {get; set;}
    public String objName {get; set;}
    public string selectedId {get; set;}
    public boolean showDetail {get; private set;}
    public sobject record {get; set;}
    public List<String> fieldName {get;private set;}
    
    /**
    *   @method autoCompleteRecords
    *   Remote method to show suggestions
    */
    @RemoteAction  
    global static List<RecordsWrapper> autoCompleteRecords(String stSearch,String objName) {  
        List<RecordsWrapper> recordsWrappers = new List<RecordsWrapper>();  
        String searchStr = '%'+stSearch+'%';
        String searchQuery = 'SELECT Id, Name FROM '+objName+' WHERE Name like \''+searchStr +'\'';
        List<sObject> searchObjects = Database.query(searchQuery);
        for(sObject obj: searchObjects) {
            for(String objFieldName :obj.getPopulatedFieldsAsMap().keySet()) {
                if(objFieldName == 'Name') {
                    System.debug(obj.getPopulatedFieldsAsMap().get(objFieldName));
                    RecordsWrappers.add(new recordsWrapper((String)obj.getPopulatedFieldsAsMap().get(objFieldName), obj.Id));  
                }
            }
        }
        return recordsWrappers;  
        }
        
        global class RecordsWrapper {  
            public String label { get; private set; }  
            public String value { get; private set; }  
            public recordsWrapper (String label, String value) {  
                this.label = label;  
                this.value = value;  
            }  
        }
        
        public void save() {
            try{
                //PageReference newpage = new PageReference(System.currentPageReference().getURL());    
        		//newpage.setRedirect(false);
                System.debug('rec'+record);
                update record;
                System.debug('rec'+record);
            }
            catch(Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot Edit this'));
            }
            //return null;
        }
        
        public void cancel() {    
        }
        
        /**
        *   @method displayObjectDetail
        *   method to display selected record
        */
        public void displayObjectDetail() {
            fieldName = fields.split(',');
            String selectQuery = 'SELECT '+fields+' FROM '+objName +' WHERE Id = :selectedId LIMIT 1';
            record = Database.query(selectQuery);
            showDetail = true;
        }
    }