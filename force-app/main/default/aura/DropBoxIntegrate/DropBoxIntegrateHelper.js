({	
    //to get data when the page is loaded
    getData : function(cmp) {
        var currentPageUrl = new URL(window.location.href);
        var code = currentPageUrl.searchParams.get("code");
        if(code == null) { 
            var actionDataOrCode = cmp.get("c.dropBoxAuthorization");            
            actionDataOrCode.setCallback(this,function(response) {
                if(response.getState() === 'SUCCESS') {
                    var auth = response.getReturnValue();
                    if(auth.Flag == false) {
                        window.open(auth.authCodeUrl,'_top');  
                    } else {
                        var actionToGetData = cmp.get("c.getDropboxFiles");
                        actionToGetData.setParams({
                            "path":'' 
                        });
                        actionToGetData.setCallback(this,function(response) {
                            if(actionToGetData.getState() === 'SUCCESS') {
                                var breadCrumb = {
                                    'dType' : 'folder',
                                    'id' : '',
                                    'name' : 'Dropbox',
                                    'path_lower' : '',
                                    'path_display' : '',
                                    
                                }
                                cmp.set('v.breadCrumb',breadCrumb);
                                cmp.set('v.dataList',response.getReturnValue());
                            }                            
                        });
                        $A.enqueueAction(actionToGetData);
                    }
                }                
            });
            $A.enqueueAction(actionDataOrCode);
        } else {
            var actionToGetAccessToken = cmp.get("c.fetchAccessToken");
            actionToGetAccessToken.setParams({
                "authCode" : code
            });
            actionToGetAccessToken.setCallback(this,function(response) {
                if(response.getState() === 'SUCCESS') {
                    var url = 'https://myintegrationcommunity-developer-edition.ap18.force.com/s/DropBoxPage';
                    window.open(url,'_top');
                }
            });
            $A.enqueueAction(actionToGetAccessToken);
        }
    },
    
    //to open the clicked folder or to view the clicked file
    openClicked : function(cmp,event,helper) {
        var index = event.currentTarget.getAttribute('data-index');
        var data = cmp.get('v.dataList');
        var breadCrumb = cmp.get('v.breadCrumb');
        var selected = data[index];
        if(selected.dType === 'folder') {
            breadCrumb.push(selected);
            cmp.set('v.breadCrumb',breadCrumb);
            cmp.set('v.currentFolder',selected.path_lower);
            var actionFolder = cmp.get('c.getDropboxFiles');
            actionFolder.setParams({
                'path' : selected.path_lower
            });
            actionFolder.setCallback(this,function(response) {
                $A.util.addClass(cmp.find('Spinner'), 'slds-hide');
                if(response.getState()==='SUCCESS') {
                    cmp.set('v.dataList',response.getReturnValue());
                }
            });
            $A.enqueueAction(actionFolder);
        } else {
            var actionFile = cmp.get("c.displayFile");
            actionFile.setParams({
                'path' : selected.path_lower
            });
            actionFile.setCallback(this,function(response) {
                $A.util.addClass(cmp.find('Spinner'), 'slds-hide');
                if(response.getState()==='SUCCESS'){
                    window.open(response.getReturnValue());
                }
            });
            $A.enqueueAction(actionFile);
        }
    },
    
    //to create a new folder
    createFolder : function(cmp,event,helper,folderName) {
        var parentFolderUrl = cmp.get('v.currentFolder');
        var actionCreate = cmp.get("c.createNewFolder");
        actionCreate.setParams({
            'pathUrl' : parentFolderUrl,
            'name' : folderName
        });
        actionCreate.setCallback(this,function(response){
            $A.util.addClass(cmp.find('Spinner'), 'slds-hide');
            if(response.getState()==='SUCCESS') {
                if(response.getReturnValue() === null) {
                    alert('Please Enter a valid folder name don\'t use special characters like \'\\,\/,\),\[,\'etc..');
                } else {
                    cmp.set('v.dataList',response.getReturnValue());   
                }
            }
        });
        $A.enqueueAction(actionCreate);
    },
    
    //to delete the selected file or folder
    deleteData : function(cmp,event) {
        var index = event.currentTarget.getAttribute('data-index');
        var data = cmp.get('v.dataList');
        var parentUrl = cmp.get('v.currentFolder');
        var selected = data[index];
        var actionDelete = cmp.get("c.deleteSelected");
        actionDelete.setParams({
            'parentUrl' :parentUrl,
            'selfUrl' : selected.path_lower,
        });
        actionDelete.setCallback(this,function(response){
            $A.util.addClass(cmp.find('Spinner'), 'slds-hide');
            if(response.getState()==='SUCCESS') {
                cmp.set('v.dataList',response.getReturnValue());
            }
        });
        $A.enqueueAction(actionDelete);
    },
    
    //manage the changes when breadcrumb is clicked
    breadCrumbChange : function(cmp,event,helper){ 
        var indx = event.currentTarget.getAttribute('data-index');
        var breadCrumbList = cmp.get('v.breadCrumb');
        var temp = [];
        for(var i = 0;i <= indx;i++){
            temp.push(breadCrumbList[i]);
        }
        cmp.set('v.breadCrumb',temp);
        var selected = breadCrumbList[indx];
        cmp.set('v.currentFolder',selected.path_lower);
            var actionCrumb = cmp.get('c.getDropboxFiles');
            actionCrumb.setParams({
                'path' : selected.path_lower
            });
            actionCrumb.setCallback(this,function(response) {
                $A.util.addClass(cmp.find('Spinner'), 'slds-hide');
                if(response.getState()==='SUCCESS') {
                    cmp.set('v.dataList',response.getReturnValue());
                }
            });
            $A.enqueueAction(actionCrumb);
        
    },
    
    //to download the selected file
    downloadFile : function(cmp,event) {
    var index = event.currentTarget.getAttribute('data-index');
    var data = cmp.get('v.dataList');
    var selected = data[index];
    var actionDownload = cmp.get("c.downloadSelected");
    actionDownload.setParams({
    	'selfUrl' : selected.path_lower,
    });
    actionDownload.setCallback(this,function(response){
        if(response.getState()==='SUCCESS') {
            $A.util.addClass(cmp.find('Spinner'), 'slds-hide');
            if(response.getReturnValue() === null) {
                alert('SORRY!!     You Are Not Allowed To Download This File...');
            } else {
                window.open(response.getReturnValue(),'_top');                    
            }
        }
    });
    $A.enqueueAction(actionDownload);
    },
    
    //to upload a selected file
    uploadFile :function(cmp,file) {
        var filename = file.name;
        var parentUrl = cmp.get('v.currentFolder');
        var reader = new FileReader();
        reader.onload = $A.getCallback(function() {
            var content = reader.result;
            var len = 7; //length of base64,
            var start = content.indexOf('base64,') + len;
            content = content.substring(start);
            var actionUpload = cmp.get("c.uploadSelectedData");
            actionUpload.setParams({
                'fileBody' : content,
                'fileName' : file.name,
                'parentUrl' : cmp.get('v.currentFolder')
            });
            actionUpload.setCallback(this,function(response) {
                $A.util.addClass(cmp.find('Spinner'), 'slds-hide');
                if(response.getState() === 'SUCCESS') {
                    cmp.set('v.dataList',response.getReturnValue());
                }
            });
            $A.enqueueAction(actionUpload);   
        });
        reader.readAsDataURL(file);     
    }
})