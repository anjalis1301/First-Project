({
    doInit : function(component, event, helper) {
        helper.showSpinner( component );
        component.set("v.fileName",null);
        component.set('v.newFolderName',null);
        console.log("start js doInit method called>>>>>>>>");
        helper.Login(component, event, helper);
        console.log("After login call js>>>>>>>>");    
    },
    
    openF : function(component, event, helper) {
        helper.showSpinner( component );
        component.set("v.fileName",null);
        component.set('v.newFolderName',null);
        console.log('js openF function called ');
        helper.openFileAndFolder(component, event, helper);
    },
    
    download : function(component, event, helper){
        helper.showSpinner( component );
        component.set("v.fileName",null);
        component.set('v.newFolderName',null);
        console.log('js download function called ');
        helper.downloadFile(component, event, helper);
    },
    
    deleteF : function(component, event, helper){
        helper.showSpinner( component );
        component.set("v.fileName",null);
        component.set('v.newFolderName',null);
        console.log('js deleteF function called ');
        helper.deleteFileAndFolders(component, event, helper);
    },
    
    handlebreadcrums : function(component, event, helper){
        helper.showSpinner( component );
        component.set("v.fileName",null);
        component.set('v.newFolderName',null);
        console.log('handlebreadcrums method called');
        helper.breadCrumb(component, event, helper);
        
    },
    
    createFolder : function(component, event, helper){
        component.set("v.fileName",null);
        console.log('js createFolder function called ');
        if(component.get("v.newFolderName") == '' || component.get("v.newFolderName") == null ){
            alert('please first enter folder name');
        }else{
            helper.showSpinner( component );
            helper.folderCreate(component, event, helper);  
        }
    },
    
    
    doSave: function(component, event, helper) {
        console.log('js doSave function called ');
        var filename = component.get("v.fileName");
        if( filename != null ){
        	if (component.find("fileId").get("v.files").length > 0) {
                helper.showSpinner( component );
            	console.log('js doSave function if true part ');
            	helper.uploadHelper(component, event);
        	} else {
            			alert('Please Select a Valid File');
        		}
        	component.set('v.newFolderName',null);
            }else{
            	alert('Please Select a File');
        }
    },
    
    handleFilesChange: function(component, event, helper) {
        console.log('js handleFilesChange function called ');
        var fileName = 'No File Selected..';
        console.log('length of file : '+event.getSource().get("v.files").length);
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
})