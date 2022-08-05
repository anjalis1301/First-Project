@isTest
public class ComponentControllerTest {
	@isTest
    private static void testInitiate(){
        ComponentController obj=new ComponentController();
        Test.startTest();
        obj.selectedIds = new Set<Id>();
        obj.fieldsToShow= new List<String>();
        obj.fieldOption = new List<String>();
        obj.fromValue='Account';
        obj.fieldOption.add('Name');
        obj.fieldOption.add('Id');
        obj.initiate();
        Test.stopTest();
        System.assertEquals(obj.cQuery !=null, true);
    }
    
    @isTest
    private static void testPrepareWrapper(){
        Test.startTest();
        ComponentController obj = new ComponentController();
       
        obj.fromValue='Account';
        obj.fieldOption=new string[]{'Name','BillingCity'};
         tempData();
        obj.initiate();
        obj.selectedIds.add(obj.wrapList[0].obj.id);
        obj.prepareWrapper();
        obj.first();
        obj.last();
        obj.previous();
        obj.next();
        obj.changePageNumber();
        obj.changeRecordsOnPage();
        Test.stopTest();
        System.assertEquals(obj.setCon.getResultSize()>0, true);
    }
	
    @isTest
    private static void testsortByCol(){
        ComponentController obj = new ComponentController();
        Test.startTest();
        obj.fromValue = 'Account';
        obj.fieldOption = new String[]{'Name','BillingCity'};
        obj.sortDirection='DESC';
        obj.sortByCol();
        obj.sortByValue = 'Name';
        obj.sortDirection='ASC';
        obj.sortByCol();
        obj.sortByValue = 'Name';
        obj.sortDirection='ASC';
        obj.sortByCol();
        Test.stopTest();
    }
    
    @isTest
    private static void testRefreshList(){
         ComponentController obj = new ComponentController();
        Test.startTest();
        PageReference vfPage = Page.PaginationVfPage;
        Test.setCurrentPageReference(vfPage);
        obj.fromValue='Account';
        obj.fieldOption=new String[]{'Name','BillingCity'};
        tempData();
        obj.initiate();
        ApexPages.currentPage().getParameters().put('filter','ALL');
        obj.refreshList();
        ApexPages.currentPage().getParameters().put('filter','Others');
        obj.refreshList();
        ApexPages.currentPage().getParameters().put('filter','E');
        obj.refreshList();
        Test.stopTest();
    }
    
    @isTest
    private static void testDeleteOneRecord(){
         ComponentController obj = new ComponentController();
        Test.startTest();
        PageReference vfPage = Page.PaginationVfPage;
		Test.setCurrentPageReference(vfPage);
        obj.fromValue='Account';
        obj.fieldOption= new String[]{'Name','BillingCity'};
        tempData();
        obj.initiate();
       	ApexPages.currentPage().getParameters().put('recId',obj.wrapList[0].obj.id);
        obj.deleteOneRec();
        ApexPages.currentPage().getParameters().put('recId',obj.wrapList[19].obj.id);
        obj.deleteOneRec();
        Test.stopTest();
        System.assertEquals(obj.recIdd != null, true);
        
    }
   
    @isTest static void testDeleteSelectedRecords(){
        Test.startTest();
        ComponentController obj = new ComponentController();
        obj.fromValue='Account';
        obj.fieldOption = new string[]{'Name','BillingCity'};
        tempData();
        obj.initiate();
        obj.wrapList[0].check_box=true;
        obj.wrapList[1].check_box=false;
        obj.deleteSelectedRecords();
        obj.wrapList[19].check_box=true;
        obj.deleteSelectedRecords();
        Test.stopTest();
    }

	@isTest static void testStateMaintain(){
        Test.startTest();
        ComponentController obj = new ComponentController();
        obj.selectedIds = new Set<Id>();
        obj.fromValue = 'Account';
        obj.fieldOption = new String[]{'Name','BillingCity'}; 
        tempData();
        obj.initiate();
        obj.wrapList[0].check_box=true;
        obj.wrapList[1].check_box=false;
        obj.selectedIds.add(obj.wrapList[1].obj.id);
        obj.StateMaintain();
        Test.stopTest();
        
    }
    
    @isTest static void testdownloadCSV(){
        Test.startTest();
        ComponentController obj = new ComponentController();
        obj.fromValue = 'Account';
        obj.fieldOption = new string[]{'Name','BillingCity'};
        tempData();
        obj.initiate();
        obj.wrapList[0].check_box=true;
        obj.wrapList[1].check_box=true;
        obj.downloadCSV();
        Test.stopTest();
        System.assertEquals(obj.csvString != null, true);
        
    }
    
    @isTest
    private static void tempData(){
        List<Account> tempAcc= new List<Account>();
        for(integer i=0;i<20;i++){
            tempAcc.add(new Account(Name='Acc'+i,BillingCity='C'+i));
        }
        Account ac = new Account(Name='CSVCheck');
        tempAcc.add(ac);
        Case c1 = new Case(Status='New',Origin='Phone',AccountId=ac.Id);
        insert tempAcc;
    }
}