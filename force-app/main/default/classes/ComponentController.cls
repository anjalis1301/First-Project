/*Author---- Anjali Sharma
createDate-----
Purpose---- To Manage the Control of component 
*/
public class ComponentController {
    public String[] fieldOption{get;set;}
    public String fromValue{get;set;}
    public String cQuery{get;set;}
    public List<String> characters{get;set;}
    public String whereClause{get;set;}
    public String sortByValue{get;set;}
    public List<sObject> queryedRecords{get;set;}
    public List<WrapClass> wrapList{get;set;} 
    public Id recIdd{get;set;}
    public Set<Id> selectedIds;
    public List<SelectOption> recordsOnPageList{get;set;}
    public Integer recordsOnPage{get;set;}
    public Integer pageNumber{get;set;}
    public Integer count{get;set;}
    public ApexPages.StandardSetController setCon{get;set;}
    public List<String> fieldsToShow {get;set;}
    public String sortOrder {get;set;}
    public String sortDirection{get;set;}
    private String chkColName;
    public String csvString{get;set;}
    public String newRecordPrefix{get;set;}
    
    //Constructor
    public ComponentController(){
        characters = new String[]{'A','B','C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z','ALL','Others'};
            csvString='hello all,hii';   
        sortByValue='Id';
        whereClause='';
        fromValue='';
        count =0;
       
        wrapList=new List<WrapClass>();
        queryedRecords=new List<sObject>();
        selectedIds = new Set<Id>();
        recordsOnPageList=new List<SelectOption>();
        recordsOnPage=5;
        sortOrder=' ASC';
        chkColName='';
        pageNumber=1;
        fieldsToShow = new List<String>();
        recordsOnPageList.add(new selectOption('5','5') );
        recordsOnPageList.add(new selectOption('10','10'));
        recordsOnPageList.add(new selectOption('15','15'));
        recordsOnPageList.add(new selectOption('20','20'));
    }
    
    //method to initiate standardSetController 
    public void initiate(){
        wrapList.clear();  
        if(fieldsToShow.size() != fieldOption.size()){
            sortByValue='Id';
            whereClause='';
            selectedIds.clear();
        }
        fieldsToShow.clear();
        
        fieldsToShow.addAll(fieldOption);
        
        String sel=fieldOption[0];
        for(integer i=1;i<fieldOption.size();i++){
            sel=sel+' , '+fieldOption[i];
        }
        cQuery ='SELECT ' +sel+ ' FROM '+ fromValue+' '+whereClause+' ORDER BY '+sortByValue+' '+sortOrder;
         newRecordPrefix = Schema.getGlobalDescribe().get(fromValue).getDescribe().getKeyPrefix();
        setCon= new ApexPages.StandardSetController(Database.query(cQuery));
        prepareWrapper();
    }
    
    //To prepare Wrapper
    public void prepareWrapper(){
        wrapList.clear();
        if(setCon.getResultSize()>0){           
            this.PageNumber = setCon.getPageNumber();
            setCon.setPageSize(recordsOnPage);
            for(sObject tempSObjectList : (List<sObject>)setCon.getRecords()){
                if(selectedIds.contains(tempSObjectList.Id)){
                    wrapList.add(new WrapClass(tempSObjectList, true));
                } 
                else {
                    wrapList.add(new WrapClass(tempSObjectList, false));
                }
            }
        }
        else if(setCon.getResultSize()==0){
            setCon.setPageNumber(0);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No Data To Show'));
        }
    }
    
    //method to change the records per page 
    public void changeRecordsOnPage(){
        stateMaintain();
        setCon.setPageSize(RecordsOnPage);
        prepareWrapper();
    }    
    
    
    public void changePageNumber(){
        stateMaintain();
        setCon.setPageNumber(this.pageNumber);
        prepareWrapper();
    }
    
    //method for alphabetical sorting
    public void refreshList(){
        if(ApexPages.currentPage().getParameters().get('filter')=='ALL'){
            whereClause=' ';
        }
        else If(ApexPages.currentPage().getParameters().get('filter')=='Others'){
            whereClause=' WHERE Name < \'a\'';
            
        }
        else{
            whereClause= 'WHERE Name like '+'\''+ApexPages.currentPage().getParameters().get('filter')+'%'+'\'';
        }
        initiate();
    }
    
    //To sort the data according to choosen column
    public void sortByCol(){
        if(chkColName == sortByValue){
            if(sortOrder == 'ASC'){
                sortDirection = 'v';
                sortOrder='DESC';                           
            }
            else{
                sortDirection='^';
                sortOrder='ASC';
            }
        }
        else{
            sortOrder='ASC';
            sortDirection='^';
        }
        chkColName=sortByValue;
        initiate();
        stateMaintain();
    }
    
    //Wrapper Class
    public class WrapClass{
        public Boolean check_box{get;set;}
        public sObject obj{get;set;}
        public WrapClass(sObject obj, Boolean check_box){
            this.obj=obj;
            this.check_box = check_box;
        }
    }
    
    public void deleteOneRec(){
        recIdd= ApexPages.currentPage().getParameters().get('recId');
        String deleteQ ='SELECT Id from '+fromValue+ ' WHERE Id = '+'\'' +recIdd+ '\'';
        sObject objToBedel=Database.query(deleteQ);
        try{
            delete objToBedel;
        }
        catch(DMLException e){
            ApexPages.addMessages(e);
        }
        statemaintain();
        initiate();
    }
    
    public void deleteSelectedRecords(){
        List<ID> recordsToDel= new List<ID>();
        for(Id delId : SelectedIds){
            recordsToDel.add(delId);
        }
       
        if(recordsToDel.size()>0){
            try{
                Database.delete(recordsToDel);	 
            }
            catch(Exception e){
                ApexPages.addMessages(e);
            }
            selectedIds.clear();
            count=0;
            initiate();
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select atleast one record to delete'));
        }
    }
    
    public void stateMaintain(){
        for(WrapClass tempData:WrapList){
            if(tempData.check_box){
                if(!this.selectedIds.contains(tempData.obj.Id)){
                    selectedIds.add(tempData.obj.Id);
                    count++;
                }            
            }
            else{
                if(this.selectedIds.contains(tempData.obj.Id)){
                    selectedIds.remove(tempData.obj.Id);
                    count--;
                }
            }
        }
    }
    
    public void next(){
        stateMaintain();
        setCon.next();
        this.PageNumber=setCon.getPageNumber();
        prepareWrapper();
    }
    
    public void first(){
        stateMaintain();
        setCon.first();
        this.PageNumber=setCon.getPageNumber();
        prepareWrapper();
    }
    
    public void last(){
        stateMaintain();
        setCon.last();
        this.PageNumber=setCon.getPageNumber();
        prepareWrapper();
    }
    
    public void previous(){
        stateMaintain();
        setCon.previous();
        this.PageNumber=setCon.getPageNumber();
        prepareWrapper();
    }
    
    public void downloadCSV(){
        stateMaintain(); 
        if(SelectedIds.size()<0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select atleast one record to download its CSV'));
        }
        else{
            String tempFld=fieldOption[0];
            for(integer i=1;i<fieldOption.size();i++){
                tempFld +=' , '+fieldOption[i];
            }
            whereClause=' WHERE Id In :selectedIds';
            String queryForSelected='SELECT '+tempfld+' FROM '+fromValue + whereClause ;
            csvString = tempfld+'\\n';
            List<sObject> queryedRecords=Database.query(queryForSelected);
            for(sObject tempRec:queryedRecords){
                for(String tempF:fieldOption){
                    String gName =String.valueOf(tempRec.get(tempF));
                    if(gName == null){
                        gName = ' ';
                    }
                    csvString += gName + ' , ';
                }
                csvString += '\\n';
            }
        }
    }
}