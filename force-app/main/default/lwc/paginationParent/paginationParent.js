import { LightningElement, track, api, wire } from 'lwc';  
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';





 const PAGE_SIZE = 5;  
 export default class PaginationParent extends LightningElement { 
   
  


  @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    accountMetadata;

    @wire(getPicklistValues, { recordTypeId: '$accountMetadata.data.defaultRecordTypeId', 
                               fieldApiName: INDUSTRY_FIELD })
    fetchValues({error,data}) {
      INDUSTRY_FIELD().then(response => {
        console.log('respose/*/*/*/*',response);
      });
        console.log('inside'+data+'/*//* '+error);
        if(data){
            this.shippingOptions  = data.values.map(item => item.value);
        }
    }

    handleShippingMethod(event) {
      this.selectedShippingMethod = event.detail.value;
  }




















   @api page = 1;  
   @api totalrecords;  
   @api _pagesize = PAGE_SIZE;  
   get pagesize() {  
     return this._pagesize;  
   }  
   set pagesize(value) {  
     this._pagesize = value;  
   }  
   handlePrevious() {  
     if (this.page > 1) {  
       this.page = this.page - 1;  
     }  
   }  
   handleNext() {  
     if (this.page < this.totalPages)  
       this.page = this.page + 1;  
   }  
   handleFirst() {  
     this.page = 1;  
   }  
   handleLast() {  
     this.page = this.totalPages;  
   }  
   handleRecordsLoad(event) {  
     this.totalrecords = event.detail;  
     this.totalPages = Math.ceil(this.totalrecords / this.pagesize);  
   }  
   handlePageChange(event) {  
     this.page = event.detail;  
   }  
 }