public class ControllerPageTest {
    private String sortOrder='LastName';
    public List<String> characters{get;set;}
    public String filterChar='';
    public String whereClause='';
    public String fieldOption{get;set;}
    public String fieldss='';
    public List<WrapperClass> recordsWrap{get;set;}
    public Boolean selectAll{get;set;}
    public String fromValue{get;set;}
     public ApexPages.StandardSetController setCon {get; set; }
   // public String sortDirection ='^';
    public ControllerPageTest(){
        
       // RecordsOnPage=10;
        characters = new String[]{'A','B','C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z','ALL','Others'};
        initiateCon();
    }
    // ApexPages.StandardSetController must be instantiated
    // for standard list controllers
   
    
        public void initiateCon() {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController( Database.query(
                    														'SELECT Name, FirstName, LastName, MailingCity,MailingState, MailingPostalCode '+
                                                                            'FROM Contact '+
                    														whereClause+
                                                                            'ORDER BY '+sortOrder+' ASC'
                                                                           
                                                                            //'SELECT Id,Name'+
                                                                            //'FROM Contact'
                    														//whereClause+
                                                                            //'ORDER BY '+sortOrder+' ASC'
                                                                           
                                                                            ));
            }
            //setCon.setPageSize(RecordsOnPage);
            recordsWrap = new List<WrapperClass>();
            List<Contact> listObj=(List<Contact>)setCon.getRecords();
            if(listObj.size()>0){
                for(Contact con:listObj){
                    recordsWrap.add(new WrapperClass(con));
                }
            }
            
        }
    
    
    
    public PageReference refreshList(){
        setCon=null;
        String temp;
        if(ApexPages.currentPage().getParameters().get('filter')=='ALL'){
            temp='';
            whereClause='';
        }
        else{
            temp=ApexPages.currentPage().getParameters().get('filter');
            filterChar=temp;
            whereClause='WHERE Name like ' +'\'' +filterChar+'%'+'\'';
        }
        initiateCon();
        return null;
    }
    // Initialize setCon and return a list of records
    
    
    public List<Contact> getcontactResult(){
       initiateCon();
        return (List<Contact>) setCon.getRecords();        
    }
    
    public class WrapperClass{
        public Boolean Checked{get;set;} 
        public Contact con{get;set;}
        public WrapperClass(Contact con){
            this.con=con;
        }
        
    }
    
    
    public void deleteSelected(){
        List<Contact> listToDel=new List<Contact>();
        List<WrapperClass> listToSave=new List<WrapperClass>();
        for(WrapperClass d:recordsWrap){
            if(d.Checked){
                listToDel.add(d.con);
            }
            else{
                listToSave.add(d);
            }
        }
        if(listToDel.size()>0){
            delete listToDel;
            recordsWrap = listToSave;
        }
    }
     public void sortByFirstName(){
            this.sortOrder='FirstName';
        }
    public void sortByLastName(){
            this.sortOrder='LastName';
        }
   // public void sortByFirstName(){
     //   this.sortOrder='FirstName';
    //}
    //public void sortByLastName(){
       // if (sortDirection == '^') {
         //   sortDirection = 'v';
      //  	this.sortOrder='LastName';
        
       
    //}
}