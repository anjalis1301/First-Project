import { LightningElement } from 'lwc';
import sendData from '@salesforce/apex/InsertStaging.uploadCSVFile';
import checkData from '@salesforce/apex/InsertStaging.checkStageRecords';
//import executeCodeBatch from '@salesforce/apex/UpsertDiagnosisCodeBatch.executeBatchThroughButton';

export default class UploadDiagnosisStageCSV extends LightningElement {
    recordsResult = [];
    enableExecute = false;
    showMessage = false;
    selectedLabel = '';
    selectedObjectValue = '';
    options = [];
    connectedCallback(){
        let choices = {};
        choices.label = 'Diagnosis Code Stage';
        choices.value = 'Diagnosis_Code_Stage__c';
        this.options.push(choices);
        choices = {};                
        choices.label = 'Formulary Item Staging';
        choices.value = 'Formulary_Item_Staging__c';
        this.options.push(choices);
        
        //this.checkQueuedData();
    }
    //check if any records are already queued to process them 
    checkQueuedData(){
        checkData({
            objName : this.selectedObjectValue
        }).then(response => {
            if(response != null){
                this.enableExecute = true;
            }
        });
    }
    storeChoice(event){
        this.enableExecute = false;
        let value = event.detail.value;
        let name = event.detail.name;
        console.log('value ',value);
        this.selectedObjectValue = value;
        this.selectedLabel = 'Upload '+event.target.options.find(opt => opt.value === event.detail.value).label+ ' CSV !!!';
        console.log('value ', this.selectedLabel);
        this.checkQueuedData();
    }
    //method that insert the staging records
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files[0];
        this.showMessage = false;
        sendData({
            contentDocumentId:uploadedFiles.documentId,
            objectName : this.selectedObjectValue
        }).then(response => {
            this.recordsResult = response;
            console.log(this.recordsResult.errorDetails);
            if(this.recordsResult.errorDetails.length == 0) {
                this.recordsResult.errorDetails = null;
            }
            this.checkQueuedData();
        });
    } 

    //method that execute the upsert diagnosis code batch
    executeClicked(event) {
        // executeCodeBatch().then(response => {
        //     this.enableExecute = false;
        //     this.showMessage = true;
        //     if(response === 'SUCCESS') {
        //        this.message = 'Records has been processed successfully!';
        //     } else{
        //         this.message = 'An error occured while processing the records.....';
        //     }
        // });
    }
}