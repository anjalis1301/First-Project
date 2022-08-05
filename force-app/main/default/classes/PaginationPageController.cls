/*Author---- Anjali Sharma
createDate-----
Purpose---- To Manage the Control of Main VisualforcePage 
*/

public class PaginationPageController {

    public List<SelectOption> objectOptions{get;set;} //select object options
    public String choosenObject{get;set;}             // object thet is choosen from the options
    public Set<String> fieldSet {get;private set;}            //set of fields of selected object
    public List<SelectOption> fieldOptions{get;set;}   //fields options that are displayed
    public List<SelectOption> selectedOptions{get;set;} //fields options that are available in selected field list
    public List<String> displayFields{get;set;}          //list of selected items of the left list
    public List<String> addedFields{get;set;}             //list of selected items of the right list
    public List<String> sOptionsString{get;set;}
    public boolean checkProcess{get;private set;}
    public String componentObject{get;private set;}
    
    Map<String,Schema.SObjectType> objectMap= Schema.getGlobalDescribe();
    
    public PaginationPageController(){
        objectOptions = new List<SelectOption>();
        objectOptions.add(new selectOption(' None','None'));
        objectSelection();
        /*List<Schema.SObjectType> ObjectList = ObjectMap.values();
        List<String> supportedObject = System.label.standardSetObjects.split(' ');
        for(Schema.SObjectType sot:ObjectList){
            Schema.DescribeSObjectResult sr = sot.getDescribe();
            if(sr.isAccessible() && sr.isCreateable()&& sr.isQueryable()&& sr.isUpdateable()){
                if(sr.isCustom()){
                    objectOptions.add(new selectOption(sot.getDescribe().getName(),sot.getDescribe().getLabel()));
                }
                else{
                    if(supportedObject.contains(sr.getLabel())){
                        objectOptions.add(new selectOption(sot.getDescribe().getName(),sot.getDescribe().getLabel()));   
                    }
                }
            }
        }*/
        
        fieldSet = new Set<String>();
        fieldOptions = new List<SelectOption>();
        displayFields = new List<String>();
        checkProcess = false;
    }
    
    public void objectSelection() {
        List<Schema.SObjectType> ObjectList = ObjectMap.values();
        List<String> supportedObject = System.label.standardSetObjects.split(' ');
        for(Schema.SObjectType sot:ObjectList){
            Schema.DescribeSObjectResult sr = sot.getDescribe();
            if(sr.isAccessible() && sr.isCreateable()&& sr.isQueryable()&& sr.isUpdateable()){
                if(sr.isCustom()){
                    objectOptions.add(new selectOption(sot.getDescribe().getName(),sot.getDescribe().getLabel()));
                }
                else{
                    if(supportedObject.contains(sr.getLabel())){
                        objectOptions.add(new selectOption(sot.getDescribe().getName(),sot.getDescribe().getLabel()));   
                    }
                }
            }
        }
       objectOptions.sort(); 
    }
    public void fieldDisplay() {
        fieldOptions.clear();
        objectOptions.clear();
        objectOptions.add(new SelectOption(' None','None',true));
        objectSelection();
        if(choosenObject != ' None') {
            Map<String,Schema.SobjectField> fieldMap = objectMap.get(choosenObject).getDescribe().fields.getMap();        
            fieldSet = fieldMap.keySet();
            for(String s:fieldSet){
                Schema.DescribeFieldResult fr= fieldMap.get(s).getDescribe();
                if(fr.isSortable() && fr.isAccessible() && fr.isCreateable() && fr.isUpdateable()){
                    fieldOptions.add(new SelectOption(fr.getName(),fr.getLabel()));
                }
            }
            sortSelectOptions(fieldOptions);
            selectedOptions= new List<SelectOption>();
            addedFields=new List<String>();
            sOptionsString= new List<String>();
            checkProcess=false;
        } else {
           
        }
        
    }
    
    public void addSelected(){
        for(String st:displayFields){
            for(integer i=0;i<fieldOptions.size();i++){
                if(fieldOptions[i].getValue() == st){
                    selectedOptions.add(new SelectOption(fieldOptions[i].getValue(),fieldOptions[i].getLabel()));
                    fieldOptions.remove(i);
                }
            }
        }
        sortSelectOptions(selectedOptions);
        sortSelectOptions(fieldOptions);
    }
    
    public void removeSelected(){
        for(String st:addedFields){
            for(integer i=0;i<selectedOptions.size();i++){
                if(selectedOptions[i].getValue() == st){
                    fieldOptions.add(new SelectOption(selectedoptions[i].getValue(),selectedOptions[i].getLabel()));
                    selectedOptions.remove(i);                                              
                }
            }
        }
        sortSelectOptions(selectedOptions);
        sortSelectOptions(fieldOptions);
    }
   
    public PageReference resetCall() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());    
        newpage.getParameters().clear();
        newpage.setRedirect(true);
        return newpage;
    }
    
    public void showRec(){
        sOptionsString.clear();
        componentObject = '';
        for(integer i = 0;i<selectedOptions.size();i++){
            sOptionsString.add(selectedOptions[i].getValue());
        }
        componentObject = choosenObject;
        checkProcess = true; 
    }
    
    public void sortSelectOptions(List<SelectOption> sortingList) {
        for (Integer i =0; i < sortingList.size(); i++) {
            for (Integer j = i; j > 0; j--) {
                if (sortingList[j-1].getLabel() > sortingList[j].getLabel()){
                    SelectOption temp = sortingList[j];
                    sortingList[j] = sortingList[j-1];
                    sortingList[j-1] = temp;
                }
            }
        }
    }
}