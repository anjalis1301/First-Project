public class objectSelect {

   public list<SelectOption> selectedobject { get; set; }

    public String objectName { get; set; }    
    public set<string> flds{get;set;}
    
    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    public objectSelect(){
                   
                selectedobject = new list<SelectOption>();  
                  selectedobject.add(new selectoption('','-None-'));
                  list<schema.SobjectType> lst=schemaMap.values();
                  for(schema.SobjectType ss:lst){
                      selectedobject.add(new selectoption(ss.getDescribe().getLocalName(),ss.getDescribe().getLabel()));
                      selectedobject.sort();
               }
                 flds= new set<string>();
                  lsps=new list<SelectOption>();
    }
 	public list<sobject> selctd_objRecords { get; set; }

        public PageReference query() {
        selctd_objRecords=new list<sobject>();
        Schema.sobjectType sobj=schemaMap.get(objectName);
            selctd_objRecords=Database.query('select Id,name from'+sobj);
            System.Debug('see the details'+selctd_objRecords);
        return null;
    }

      
      public String fields { get; set; }
      
       public list<SelectOption> lsps{get;set;}
      
       public void function() {
       
         if(objectName!=null || objectName!=''){
           Map<string,Schema.SObjectField> mpConField=schemaMap.get(objectName).getDescribe().fields.getMap();
               flds=mpConField.keySet();
                                
                   for(string name:flds){
                   Schema.DescribeFieldResult fldResult=mpConField.get(name).getDescribe();
                    lsps.add(new SelectOption(fldResult.getName(),fldResult.getName()));
                    lsps.sort();                    
                   }
                }        
    }
    
        

}