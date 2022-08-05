public class DeletingCheckedRowsController {
    public List<WrapperClass> listWrapper {get;set;}
    public Boolean allBool {get;set;}
    
    public DeletingCheckedRowsController() {
        listWrapper = new List<WrapperClass>();
        List<Contact> listCon = [SELECT Id, Name FROM Contact];
        if(listCon.size() > 0) {
            for(Contact con : listCon) {
                listWrapper.add(new WrapperClass(con));
            }
        }
    }
    
    public class WrapperClass {
        public Boolean checked {get;set;}
        public Contact con {get;set;}
        public WrapperClass(Contact con) {
            this.con = con;
        }
    }
    
    public void del() {
        List<Contact> listConForDel = new List<Contact>();
        List<WrapperClass> listTempWrapper = new List<WrapperClass>();
        for(WrapperClass w : listWrapper) {
            if(w.checked) {
                listConForDel.add(w.con);
            } else {
                listTempWrapper.add(w);
            }
        }
        if(listConForDel.size() > 0) {
            delete listConForDel;
            listWrapper = listTempWrapper;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Select atleast one employee to delete'));
        }
    }
    
    public void selectAll() {
        if(allBool) {
            for(WrapperClass w : listWrapper) {
                w.checked = true;
            }
        } else {
            for(WrapperClass w : listWrapper) {
                w.checked = false;
            }
        }
    }
}