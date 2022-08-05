({	//Handler function load initial Values  
    doInit : function(cmp, event, helper) {
        helper.getData(cmp, event, helper);
    },
    
	//method to open fileOrFolder
    openFileOrFolder : function(cmp,event,helper) {
        $A.util.removeClass(cmp.find('Spinner'), 'slds-hide');
        helper.openClicked(cmp,event,helper);
    },

    //method to open modal to take foldername 
    createClicked :function(cmp,event,helper) {
        cmp.set("v.isOpen", true);
    },

    // method to close the modal
    closeModel : function(cmp,event,helper) {
        cmp.set("v.isOpen", false);
    },

    //method to create a folder
    folderCreate : function(cmp,event,helper) {
        var name = cmp.get("v.newFolderName");
        if(name == '' || name == null){
          name = 'New Folder'; 
        } else {
            if(name.trim().length === 0) {
                alert('Please provide a valid name');
                cmp.set("v.isOpen", false);
                cmp.set("v.newFolderName",'');
                return;
            }
        }
        $A.util.removeClass(cmp.find('Spinner'), 'slds-hide');
        helper.createFolder(cmp,event,helper,name);
        cmp.set("v.isOpen", false);
        cmp.set("v.newFolderName",'');

    },
    
    //method to delete fileOrFolder
    deleteClicked : function(cmp,event,helper) {
        $A.util.removeClass(cmp.find('Spinner'), 'slds-hide');
        helper.deleteData(cmp,event);
    },
    
    //method to download a file
    downloadClicked : function(cmp,event,helper) {
        $A.util.removeClass(cmp.find('Spinner'), 'slds-hide');
        helper.downloadFile(cmp,event);
    },
    
    //method to upload File
    uploadClicked : function(cmp,event,helper) {
        var input = document.createElement('input');
        input.type='file';
        input.style.display = 'none';
        input.click();        
        input.onchange = () => {
            var selectedFile = input.files[0];
            if(selectedFile.size < 4350000) {
                $A.util.removeClass(cmp.find('Spinner'), 'slds-hide');
            	helper.uploadFile(cmp,selectedFile);
        	} else {
            	alert('File Size Too Big. It Should be less than 4.35Mb');
        	}
        }
    },
    
    //method to manage breadCrumb changes
    breadCrumbClicked : function(cmp,event,helper) {
    	helper.breadCrumbChange(cmp,event,helper);        
    },
})