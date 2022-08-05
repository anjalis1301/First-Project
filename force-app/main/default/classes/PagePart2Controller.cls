/*Author---- Anjali Sharma
createDate-----
Purpose---- To Manage the Control of Main VisualforcePage 
*/

public class PagePart2Controller {
    public List<SelectOption> objectOptions{get;set;} //select object options
    public String choosenObject{get;set;}             // object thet is choosen from the options
    public Set<String> fieldSet {get;set;}            //set of fields of selected object
    public List<SelectOption> fieldOptions{get;set;}   //fields options that are displayed
    public List<SelectOption> selectedOptions{get;set;} //fields options that are available in selected field list
    public List<String> displayFields{get;set;}          //list of selected items of the left list
    public List<String> addedFields{get;set;}             //list of selected items of the right list
    public List<String> sOptionsString{get;set;}
    // public String check='name,billingcity';
    public boolean checkProcess{get;set;}
    public String componentObject{get;set;}
    
    
    
    
    Map<String,Schema.SObjectType> objectMap= Schema.getGlobalDescribe();
    public PagePart2Controller(){
        objectOptions = new List<SelectOption>();
        objectOptions.add(new selectOption(' None','None'));
        List<Schema.SObjectType> ObjectList = ObjectMap.values();
        system.debug(objectMap);
        List<String> supportedObject = System.label.standardSetObjects.split('\n');
        for(Schema.SObjectType sot:ObjectList){
            Schema.DescribeSObjectResult sr = sot.getDescribe();
            if(sr.isCustom()){
                objectOptions.add(new selectOption(sot.getDescribe().getName(),sot.getDescribe().getLabel()));
            }
            else{
                for(String supportObj:supportedObject){
                    if(supportObj.trim() == sr.getLabel()){
                        objectOptions.add(new selectOption(sot.getDescribe().getName(),sot.getDescribe().getLabel()));
                    }
                }
            }
        }
        objectOptions.sort();
        System.debug(objectOptions.size());
        fieldSet = new Set<String>();
        fieldOptions = new List<SelectOption>();
        displayFields = new List<String>();
        checkProcess = false;
        System.debug('PageConstructor');
        
    }
    public void fieldDisplay(){
        fieldOptions.clear();
        if(choosenObject != ' None'){
            Map<String,Schema.SobjectField> fieldMap = objectMap.get(choosenObject).getDescribe().fields.getMap();
            
            fieldSet = fieldMap.keySet();
            for(String s:fieldSet){
                Schema.DescribeFieldResult fr= fieldMap.get(s).getDescribe();
                if(fr.isSortable() && fr.isAccessible() && fr.isCreateable() && fr.isUpdateable()){
                    fieldOptions.add(new SelectOption(fr.getName(),fr.getLabel()));
                }
            }
            fieldOptions.sort();
            System.debug(fieldOptions.size());
            selectedOptions= new List<SelectOption>();
            addedFields=new List<String>();
            sOptionsString= new List<String>();
        }
        System.debug('FieldOptionsPageWale');
    }
    
    public void addSelected(){
        if(displayFields.size() > 0){
            for(String st:displayFields){
                if(!(addedFields.contains(st))){
                    for(integer i=0;i<fieldOptions.size();i++){
                        if(fieldOptions[i].getValue() == st){
                            selectedOptions.add(new SelectOption(fieldOptions[i].getValue(),fieldOptions[i].getLabel()));
                            
                            fieldOptions.remove(i);
                        }
                        
                    }
                }
            }
            
            system.debug(displayFields);
        }
        selectedOptions.sort();
        fieldOptions.sort();
    }
    
    public void removeSelected(){
        if(addedFields.size()>0){
            for(String st:addedFields){
                for(integer i=0;i<selectedOptions.size();i++){
                    if(selectedOptions[i].getValue() == st){
                        fieldOptions.add(new SelectOption(selectedoptions[i].getValue(),selectedOptions[i].getLabel()));
                        System.debug(selectedOptions[i].getValue());
                        selectedOptions.remove(i);                                              
                    }
                }
                
            }
        }
        selectedOptions.sort();
        fieldOptions.sort();
    }
   
    public PageReference resetCall() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());    
        newpage.getParameters().clear();
        newpage.setRedirect(true);
        return newpage;
    }
    
    public void showRec(){
        System.debug('runn');
        sOptionsString.clear();
        componentObject = '';
        System.debug(componentObject);
        System.debug(sOptionsString);
        for(integer i = 0;i<selectedOptions.size();i++){
            sOptionsString.add(selectedOptions[i].getValue());
        }
        componentObject = choosenObject;
        System.debug(sOptionsString);
        System.debug(componentObject);
        checkProcess = true; 
    }
   
    
}