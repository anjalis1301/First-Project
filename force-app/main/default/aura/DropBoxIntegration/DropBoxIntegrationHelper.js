({
    showSpinner : function(component) {
        console.log('showSpinner called');
        var spinner = component.find( 'spinner1' );
        $A.util.removeClass( spinner, 'slds-hide' );
        
    },
    hideSpinner : function(component) {
        console.log('hideSpinner called');
        var spinner = component.find( 'spinner1' );
        $A.util.addClass( spinner, 'slds-hide' );
    },
    Login : function(component, event, helper) {
        
        console.log('helper fun calll');
        var url = new URL(window.location.href);
        var authcode = url.searchParams.get("code");
        alert(authcode);
        //check authencatin
        if(authcode == null){
            var action1 = component.get("c.getLogin");
            console.log('after call getLogin');
            action1.setCallback(this,function(response1){
                var result = response1.getReturnValue();
                console.log('response1.getState() : ',response1.getState());
                console.log('response1.getReturnValue() : ', response1.getReturnValue());
                if(response1.getState() === 'SUCCESS'){
                    if(result.flag == false){
                        alert(result.str);
                        window.open(result.str,'_top');
                    }else{
                        console.log('enter in else part getFileFolder');
                        component.set('v.accesstoken',result.str);
                        var action3 = component.get("c.getFileFolder"); 
                        console.log('enter>>>> 1');
                        action3.setParams({'accesstoken' : result.str });
                        action3.setCallback(this,function(response3){
                            console.log('result>>' +response3.getState());
                            if(response3.getState() === 'SUCCESS'){
                                var resul = response3.getReturnValue();
                                console.log('result>> ',resul);
                                component.set('v.FileAndFolder',response3.getReturnValue());
                                var obj = {
                                    
                                    "name" : "ROOT",
                                    "id" : '',
                                    "type" : 'folder',
                                    "path_lower":''
                                }
                                component.set('v.breadcrumbCollection',obj);
                                this.hideSpinner(component);
                            }
                        });
                        $A.enqueueAction(action3);
                    }
                    // component.set("v.token",response1.getReturnValue());
                }
            }); 
            $A.enqueueAction(action1);
        }else{
            console.log('authcode <<>> '+authcode);
            var action2 = component.get("c.getAccessTkn");//authorizationcode       
            action2.setParams({ 'authorizationcode' : authcode});
            action2.setCallback(this,function(response2){
                console.log('after call getAccessTkn');
                console.log('response2.getState()' + response2.getState());
                if(response2.getState() === 'SUCCESS'){
                    var url = 'https://myintegrationcommunity-developer-edition.ap18.force.com/s/DropBoxPage';
                    window.open(url,'_top');
                }
            });
            $A.enqueueAction(action2);
        }  
        
    },
    
    openFileAndFolder : function(component, event,helper){
        var accesstoken = component.get("v.accesstoken");
        var index = event.target.getAttribute('data-index');
        var fileFolderList = component.get( "v.FileAndFolder" );
        var selectedFileFolder = fileFolderList[ index ];
        console.log( '@@@@@ index : ', index );
        console.log( '@@@@@ selectedFileFolder : ', selectedFileFolder );
        console.log( '@@@@@ selectedFileFolder : ', selectedFileFolder.type );
        if(selectedFileFolder.type === 'folder'){
            var brecumoldval = component.get("v.breadcrumbCollection");
            console.log("brecumoldval ",brecumoldval);
            var obj =   {
                "name" : selectedFileFolder.name,
                "id" : selectedFileFolder.id,
                "type" : selectedFileFolder.type,
                "path_lower":selectedFileFolder.path_lower
            }
            brecumoldval.push(obj);
            component.set('v.breadcrumbCollection',brecumoldval);
            //if we click on Folder this function open folder and show files
            console.log( '@@@@@ Inside folder part : ' );
            component.set('v.parentId',selectedFileFolder.path_lower);
            console.log("selectedFileFolder.path_lower  :",selectedFileFolder.path_lower);
            var action = component.get("c.openFolders");
            console.log("befor set perams");
            action.setParams({ 
                'Path' : selectedFileFolder.path_lower,
                'accesstoken' : accesstoken
            });
            action.setCallback(this,function(response){
                console.log('response.getState()' + response.getState());
                if(response.getState() === 'SUCCESS'){
                    console.log('result>> ', response.getReturnValue());
                    component.set('v.FileAndFolder',response.getReturnValue());
                    this.hideSpinner(component);
                }
            });
            $A.enqueueAction(action);   
        }else{
            //if we click on file this function open file 
            console.log("file section");
            var accesstoken = component.get("v.accesstoken");
            var action = component.get("c.openFiles");
            console.log("befor set perams    " ,selectedFileFolder.path_lower);
            
            action.setParams({
                'FilePath' : selectedFileFolder.path_lower,
                'accesstoken':accesstoken
            });
            action.setCallback(this,function(response){
                console.log('response.getState()' + response.getState());
                if(response.getState() === 'SUCCESS'){
                    console.log('result>> ', response.getReturnValue());
                    window.open(response.getReturnValue());
                    this.hideSpinner(component);
                }
            });
            $A.enqueueAction(action);  
        }  
    },
    
    breadCrumb : function(component, event, helper){
        console.log('breadCrumb method called');
        var index = event.getSource().get("v.name");
        console.log('>>>>>>>>>>>>', index);
        var FolderList = component.get( "v.breadcrumbCollection" );
        var selectedFileFolder = FolderList[ index ];
        console.log('selectedFileFolder.name >',selectedFileFolder);
        var accesstoken = component.get("v.accesstoken");
        component.set('v.parentId',selectedFileFolder.path_lower);
        console.log('selectedFileFolder.path_lower>>>>>>>>>>>>', selectedFileFolder.path_lower);
        var action = component.get("c.openFolders");
        console.log("befor set perams");
        action.setParams({ 
            'Path' : selectedFileFolder.path_lower,
            'accesstoken':accesstoken
        });
        action.setCallback(this,function(response){
            console.log('response.getState()' + response.getState());
            if(response.getState() === 'SUCCESS'){
                console.log('result>> ', response.getReturnValue());
                component.set('v.FileAndFolder',response.getReturnValue());
                FolderList.length = index+1;
                console.log('FolderList>>>>',FolderList);
                component.set('v.breadcrumbCollection',FolderList);
                this.hideSpinner(component);
            }
        });
        $A.enqueueAction(action);  
        
    },
    
    downloadFile : function(component, event, helper){
        console.log('helper GoogledownloadFile function called ');
        
        var accesstoken = component.get("v.accesstoken");
        var index = event.currentTarget.getAttribute('data-index');
        console.log('bindex',index);
        var fileFolderList = component.get( "v.FileAndFolder" );
        var selectedFileFolder = fileFolderList[ index ];
        console.log( '@@@@@ index>>>>> : ', index );
        console.log( '@@@@@ fileFolderList>>>>> : ', fileFolderList );
        console.log( '@@@@@ selectedFileFolder>>>> : ', selectedFileFolder.path_lower );
        var action = component.get("c.downloadFiles");
        action.setParams({ 
            'Path' : selectedFileFolder.path_lower,
            'accesstoken' : accesstoken
        });
        action.setCallback(this,function(response){
            console.log('response.getState()' , response.getState());
            if(response.getState() === 'SUCCESS'){
                console.log('result>> ', response.getReturnValue());
                if(response.getReturnValue() != null ){
                    window.open(response.getReturnValue(),'_top');
                    
                }else{
                    alert('do not have download access');
                }
                this.hideSpinner(component);  
            }
        });
        $A.enqueueAction(action);   
    },
    
    deleteFileAndFolders : function(component, event, helper){
        console.log('helper deleteFileAndFolders function called ');
        var accesstoken = component.get("v.accesstoken");
        var index = event.currentTarget.getAttribute('data-index');
        var fileFolderList = component.get( "v.FileAndFolder" );
        var selectedFileFolder = fileFolderList[ index ];
        console.log('file for delete ' ,selectedFileFolder);
        var action = component.get("c.deletefileFolder");
        var parentpath = component.get("v.parentId");
        console.log('parentpath ' ,parentpath);
        if(parentpath == 0){
            parentpath=''; 
        }
        action.setParams({
            'parentPath':parentpath,
            'accesstoken' : accesstoken,
            'Path': selectedFileFolder.path_lower
        });
        action.setCallback(this,function(response){
            console.log('response.getState()' , response.getState());
            if(response.getState() === 'SUCCESS'){
                console.log('result>> ', response.getReturnValue());
                component.set('v.FileAndFolder',response.getReturnValue());
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);   
        
    },
    
    folderCreate : function(component, event, helper){
        console.log('helper folderCreate function called ');
        var accesstoken = component.get("v.accesstoken");
        var parentId = component.get("v.parentId");
        var newfoldername = component.get( "v.newFolderName" );
        var action = component.get("c.createNewFolder");
        console.log('accesstoken ',accesstoken);
        console.log('parentId ',parentId);
        console.log('newfoldername ',newfoldername);
        if(parentId == 0){
            parentId ='';
        }
        action.setParams({ 
            'newFolderName' : newfoldername,
            'access_Token' : accesstoken,
            'ParentPath' : parentId
        });
        action.setCallback(this,function(response){
            console.log('response.getState()' , response.getState());
            if(response.getState() === 'SUCCESS'){
                console.log('result>> ', response.getReturnValue());
                if(response.getReturnValue().length == 0){
                    this.hideSpinner(component);
                    alert('Names cannot contain non-printable ASCII, \/ or \\, leading or trailing whitespace. The special names \".\" or \"..\" are also unsupported');
                }else{ 
                    component.set('v.FileAndFolder',response.getReturnValue());
                    
                    this.hideSpinner(component);
                }
                component.set('v.newFolderName',null);
            }
        });
        $A.enqueueAction(action);   
    },
    
    MAX_FILE_SIZE: 157286300, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb 
    uploadHelper: function(component, event) { 
        console.log(' uploadHelper function called ');
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var filetype = file.type;
        console.log('filetype >>> ',filetype);
        var self = this; 
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            this.hideSpinner(component);
            return;
        }
        console.log(' After file size check ');
        var objFileReader = new FileReader();  
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            console.log('fileContents ' + fileContents);
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            console.log('inside  onload  >>>>>>' , fileContents);
            fileContents = fileContents.substring(dataStart);
            var filename = component.get("v.fileName");
            var folderid = component.get("v.parentId");
            var accesstoken = component.get("v.accesstoken");
            var action = component.get("c.upload");
            if(folderid == '0'){
                folderid = '' ;
            }
            //String filebody,String filename,String folderid, String accesstoken,String filetype
            console.log(' fileContents :::::: -- '+fileContents);
            action.setParams({'filebody' : fileContents,
                              'filename' : component.get("v.fileName"),
                              'ParentPath' : folderid,  
                              'accesstoken' : accesstoken
                             });
            action.setCallback(this,function(response){
                console.log('response.getState()' + response.getState());
                if(response.getState() === 'SUCCESS'){
                    console.log('result<<<<g>> ', response.getReturnValue());
                    component.set('v.FileAndFolder',response.getReturnValue());
                    //this.hideSpinner(component);
                    component.set("v.fileName",null);
                }
        		$A.util.addClass( component.find( 'spinner1' ), 'slds-hide' );
            });
            $A.enqueueAction(action);   
        });
        
        //objFileReader.readAsText(file); 
        objFileReader.readAsDataURL(file);
        //objFileReader.readAsBinaryString();
    },
    
})


//https://www.dropbox.com/home/test%201/test%201.1?preview=ProjectPlanning.txt
//https://www.dropbox.com/home/test%201?preview=Profile.jpg