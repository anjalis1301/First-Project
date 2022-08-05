import { LightningElement, track } from 'lwc';
import authCode from '@salesforce/apex/BoxIntegration.boxAuthorization';
import allFiles from '@salesforce/apex/BoxIntegration.getBoxFiles';
import viewFile from '@salesforce/apex/BoxIntegration.displayFile';
import deleteSel from '@salesforce/apex/BoxIntegration.deleteSelected';
import downloadSel from '@salesforce/apex/BoxIntegration.downloadSelected';
import createFolder from '@salesforce/apex/BoxIntegration.createNewFolder';
import uploadSelected from '@salesforce/apex/BoxIntegration.uploadSelectedData';
import gotToken from '@salesforce/apex/BoxIntegration.fetchAccessToken';
import icons from '@salesforce/resourceUrl/BoxIcons';
export default class BoxIntegration extends LightningElement {
@track allFileAndFolder = []; //list that store all the data of current folder
breadCrumb = []; // breadCrumb list
currentFolderId ;        //var that store current folder id
newFolNm;                // var that store the name of the new folder to be created 
showData ;               // var to set if there is data to display or not
showModal ;              // var to open and close the create modal
del = icons+ '/boxIcons/boxDelete.png';              // var that contains the delete icon image 
download = icons+ '/boxIcons/boxDownload.png';       // var that contains the download icon image
fileImg = icons+ '/boxIcons/boxFile.png';            // var that contains the file icon image
folderImg = icons+ '/boxIcons/boxFolder.png';       // var that contains the folder icon image
logo = icons+ '/boxIcons/boxLogo.png';             // var that contains the box logo image

    //method to set values when component is loaded in DOM
    connectedCallback(){
        this.loadData();    
    }

    //method to load data initially
    loadData(){
        var currentPageUrl = new URL(window.location.href);
        var code = currentPageUrl.searchParams.get("code");
        if(code == null) { 
            authCode().then(response => {
                var auth = response;
                if(auth.Flag == false) {
                    window.open(auth.authCodeUrl,'_top');                    
                } else {
                    var actionToGetData = allFiles;
                    actionToGetData({
                        "folderPath" : '0'
                    }).then(response => {
                        if(response === null){
                            this.loadData();
                        } else{
                            this.allFileAndFolder = JSON.parse(JSON.stringify(response));
                            this.currentFolderId = '0';
                            this.folderCheck();
                            if(this.allFileAndFolder.length === 0){
                                this.showData = false;
                            } else {
                                this.showData = true;
                            }
                        }
                    });
                }
            });
        } else {
            var actionForAccessTkn = gotToken;
            gotToken({
                "authCode" : code
            }).then(() => {
                var redirect = 'https://myintegrationcommunity-developer-edition.ap18.force.com/s/box';
                window.open(redirect,'_top');
            });
        }
    }

    //run when any folder is clicked to get the contents of that folder Or to View File
    openFolderOrFile(event) {
        this.template.querySelector('[data-id="spin"]').classList.remove('slds-hide');
        var selectedType = event.currentTarget.dataset.type;
        var indx = event.currentTarget.dataset.index;
        var allData = this.allFileAndFolder;
        var crumb = this.breadCrumb;        
        if(selectedType === 'folder'){
            crumb.push(allData[indx]);
            this.breadCrumb = crumb;
            var actionToGetData = allFiles;
            allFiles({
                            "folderPath" : allData[indx].id
                        }).then(response => {
                            this.template.querySelector('[data-id="spin"]').classList.add('slds-hide');
                            if(response === null){
                                this.loadData();
                            } else{
                                this.allFileAndFolder = JSON.parse(JSON.stringify(response));
                                this.currentFolderId = allData[indx].id;
                                this.folderCheck();
                                if(this.allFileAndFolder.length === 0){
                                    this.showData = false;
                                } else {
                                    this.showData = true;
                                }
                            }
                        });
        } else {
            viewFile({
                "filePathId" : allData[indx].id
            }).then(response => {
                this.template.querySelector('[data-id="spin"]').classList.add('slds-hide');
                if(response === null){
                    this.loadData();
                } else{
                    window.open(response);
                }
            });
        }
    }
    
    //method to update the breadCrumb list and to display the content of the folder being clicked through breadCrumb 
    breadCrumbUpdate(event) {      
        this.template.querySelector('[data-id="spin"]').classList.remove('slds-hide');
        var indx = event.currentTarget.getAttribute('data-index');
        var temp = [];
        for(var i = 0;i <= indx;i++){
            temp.push(this.breadCrumb[i]);
        }
        this.breadCrumb = temp;
        this.currentFolderId = this.breadCrumb[indx].id;
        allFiles({
            "folderPath" : this.breadCrumb[indx].id
        }).then(response => {            
            this.template.querySelector('[data-id="spin"]').classList.add('slds-hide');
            if(response === null){
                this.loadData();
            } else{
                this.allFileAndFolder = JSON.parse(JSON.stringify(response));
                this.folderCheck();
                this.showData = true;
            }
        });
    }

    //Method to Delete the Selected File or Folder
    deleteSelected(event){
        this.template.querySelector('[data-id="spin"]').classList.remove('slds-hide');
        var selectedType = event.currentTarget.dataset.type;
        var indx = event.currentTarget.dataset.index;
        var allData = this.allFileAndFolder;
        var parentFolId = this.currentFolderId;
        deleteSel({
            "parentUrl" : parentFolId,
            "type" : selectedType,
            "selectedId" : allData[indx].id
        }).then(response =>{
            this.template.querySelector('[data-id="spin"]').classList.add('slds-hide');
            if(response === null){
                this.loadData();
            } else{
                this.allFileAndFolder = response;
                if(this.allFileAndFolder.length == 0){
                    this.showData = false;
                } else{
                    this.showData = true;
                    this.folderCheck();
                }
                
            }
        });
    }

    //Method to get the Download Link Of the Selected File
    downloadSelectedFile(event) {
        this.template.querySelector('[data-id="spin"]').classList.remove('slds-hide');
        var dtId = event.currentTarget.dataset.id;
        downloadSel({
            "selectedId" : dtId
        }).then(response => {
            this.template.querySelector('[data-id="spin"]').classList.add('slds-hide');
            if(response === null){
                this.loadData();
            } else{
                window.open(response,'_top'); 
            }
        });
    }

    //Method to set the folderCheck Property of allFileAndFolder List elements
    folderCheck(){
        var data = this.allFileAndFolder;
        for(var i = 0; i<data.length; i++){
            if(data[i].type === 'folder')
                data[i].folderCheck = true;
            else 
                data[i].folderCheck = false;
        }
    }

    //method to get the name of the folder to be created
    newName(event){
        this.newFolNm = event.currentTarget.value;
    }

    //method to set the property to open the create modal
    openCreateModal(){
        this.showModal = true;
    }

    ////method to set the property to close the create modal
    hideModel(){
        this.showModal = false;
    }

    //method to create a new folder in the sepicific parent folder
    createNewFol(){
        var name = this.newFolNm;
        var this1 = this;
        if(name == '' || name == null || name.trim().length === 0){
            alert('Folder Name Cannot Be Empty');
            return;
          } else if((name.includes('/')) || (name.includes('\\')) ){
            alert('Folder Name Cannot Be contain charactes like /,'+'\\'+',etc...');
            return;
          }
            this.showModal = false;
            this.template.querySelector('[data-id="spin"]').classList.remove('slds-hide');
            createFolder({
                "parentFolId" : this.currentFolderId,
                "newFolName" : this.newFolNm
            }).then(response => {
                this.template.querySelector('[data-id="spin"]').classList.add('slds-hide');
                if(response === null){
                    this.loadData();
                } else{
                        this1.allFileAndFolder = JSON.parse(JSON.stringify(response));
                        this.showData = true;
                        this1.folderCheck();    
                }
            }).catch(err => {
                alert('Folder Name Conflict !!!!!!!!  This Name Already Exist..');
                this.template.querySelector('[data-id="spin"]').classList.add('slds-hide');
            });
         
    }

    //method to validate if file size is less than 4.3 or not and if it is then process the upload
    uploadFile(event){       
        var input = document.createElement('input');
        input.type='file';
        input.style.display = 'none';
        input.click();        
        input.onchange = () => {
            var selectedFile = input.files[0];
            if(selectedFile.size < 4350000) {
                this.template.querySelector('[data-id="spin"]').classList.remove('slds-hide');
                this.processUpload(selectedFile);
        	} else {
            	alert('File Size Too Big. It Should be less than 4.35Mb');
        	}
        }
        
    }

    //method to upload a file in sepicified folder
    processUpload(selectFile){
        var filename = selectFile.name;
        var this1 = this;
        var reader = new FileReader();
        var parentId = this.currentFolderId;
        reader.onload = function() {
            var content = reader.result;
            var base = 'base64,'; 
            var start = content.indexOf('base64,') + base.length;
            content = content.substring(start);
            uploadSelected({
                'parentUrl' : parentId,
                'fileName' : selectFile.name,
                'fileBody' : content
            }).then(response => {
                this1.template.querySelector('[data-id="spin"]').classList.add('slds-hide');
                if(response === null){
                    this1.loadData();
                } else{
                    this1.allFileAndFolder = JSON.parse(JSON.stringify(response));
                    this1.showData = true;
                    this1.folderCheck();
                }
            });  
        };
        reader.readAsDataURL(selectFile);
    }
}