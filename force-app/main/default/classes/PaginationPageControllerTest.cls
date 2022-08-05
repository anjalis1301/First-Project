@isTest
public class PaginationPageControllerTest {
	@isTest
    private static void testRemoveSelected(){
        Test.startTest();
        PaginationPageController obj = new PaginationPageController();
        obj.addedFields=new List<String>();
        obj.addedFields.add('Name');
        obj.selectedOptions = new List<SelectOption>();
        obj.selectedOptions.add(new SelectOption('Name','Name'));
        obj.fieldOptions = new List<SelectOption>();
        obj.removeSelected();
        obj.sortSelectOptions(obj.fieldOptions);
        Test.stopTest();
        System.assertEquals(obj.fieldOptions.size()>0, true);
    }
    
    @isTest
    private static void testFieldDisplay(){
		Test.startTest();
        PaginationPageController obj = new PaginationPageController();        
        obj.choosenObject ='Account';
        obj.fieldOptions=new List<SelectOption>();
        obj.fieldDisplay();
        Test.stopTest();
        System.assertEquals(obj.fieldOptions.size()>0, true);
    }
    
    @isTest
    private static void testAddSelected(){
        Test.startTest();
        PaginationPageController obj = new PaginationPageController();
        obj.displayFields = new List<String>();
        obj.displayFields.add('Name');
        obj.fieldOptions = new List<SelectOption>();
         
        obj.fieldOptions.add(new SelectOption('Name','Name'));
        obj.selectedOptions = new List<SelectOption>();
        obj.addSelected();
        obj.sortSelectOptions(obj.selectedOptions);
        Test.stopTest();
        System.assertEquals(obj.selectedOptions.size()>0, true);
    }
    @isTest
    private static void testShowRec(){
        Test.startTest();
        PaginationPageController obj = new PaginationPageController();
        obj.choosenObject='Account';
        obj.sOptionsString = new List<String>();
        obj.selectedOptions = new List<SelectOption>();
        obj.selectedOptions.add(new SelectOption('Name','Name'));
        //obj.componentObject='';
        obj.showRec();
        Test.stopTest();
        System.assertEquals(obj.sOptionsString.size()>0, true);
    }
    
    @isTest
    private static void testResetCall(){
        PageReference vfPage = Page.PaginationVfPage;
        PaginationPageController obj = new PaginationPageController();
        Test.setCurrentPageReference(vfPage);
        obj.ResetCall();
        System.assertEquals(ApexPages.currentPage().getURL(),vfPage.getUrl());
    } 
}