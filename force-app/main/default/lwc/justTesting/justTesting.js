import { LightningElement,track } from 'lwc';
export default class LwcModalPopup extends LightningElement {

    @track openModal = false;
    
    selected;
    connectedCallback(){
        console.log('childddddddddddddddddddddddddddddddd');
    }
    get language() {
        return [
            { label: 'French', value: 'lang1' },
            { label: 'Spanish', value: 'lang2' },
            { label: 'Both', value: 'lang3' },
        ];
    }

    handleLanguageChange(event) {
        console.log('trget',event.target.value);
        this.selected = event.target.value;
        const custEvnt = new CustomEvent("changed",{detail:this.selected});
        this.dispatchEvent(custEvnt);
    }
    showModal() {
        this.openModal = true;
    }
    closeModal() {
        this.openModal = false;
    }
}



// import {LightningElement, api} from 'lwc';
// import fetchData from '@salesforce/apex/MapIntegration.getData';
// import { loadScript } from 'lightning/platformResourceLoader';
// import mapApi from '@salesforce/resourceUrl/GoogleMapApiJs';
// import pollyFill from '@salesforce/resourceUrl/GoogleMapPollyFill';

// export default class JustTesting extends LightningElement {
//    @api recordId ; 
//     HTMLAtt = {};
//    connectedCallback(){
//        //this.HTMLAtt['src'] = 'https://maps.googleapis.com/maps/api/js?key=AIzaSyBTOHLm2G8vgQYxz_wkiBagXQi8jY1v7dE&callback=initMap&libraries=&v=weekly'
//        var recId = this.recordId;
//        console.log('heyy');
//        console.log(typeof this.recordId+recId);
//         fetchData({
//             currentRecordId : this.recordId
//         }).then(response =>{
//             console.log(response);
//             console.log('hey');
//             //this.initMap();
//         });
//         Promise.all([
//             loadScript(this, mapApi+'?key=AIzaSyBTOHLm2G8vgQYxz_wkiBagXQi8jY1v7dE&callback=initMap&libraries=&v=weekly')
//       ]).then((response) => { console.log('loaded') });
//    }

//    initMap() {
//       var mapDiv =  this.template.querySelector('[data-id="map"]');
//     // Create the map.
//     const map = new google.maps.Map( this.template.querySelector('[data-id="map"]'), {
//       zoom: 7,
//       center: { lat: 37.09, lng: -95.712 },
//       mapTypeId: "terrain",
//     });
    
       
//     // Construct the circle for each value in citymap.
//     // Note: We scale the area of the circle based on the population.
    
//       // Add the circle for this city to the map.
//       const cityCircle = new google.maps.Circle({
//         strokeColor: "#FF0000",
//         strokeOpacity: 0.8,
//         strokeWeight: 2,
//         fillColor: "#FF0000",
//         fillOpacity: 0.35,
//         map,
//         center: {lat: 41.878, lng: -87.629 },
//         radius: 30,
//       });
    
//   }
// }

// import { LightningElement, api, wire, track } from 'lwc';
// import { getObjectInfo,getPicklistValues } from 'lightning/uiObjectInfoApi';
// import { getListUi } from 'lightning/uiListApi';
// import ACCOUNT_OBJECT from '@salesforce/schema/Account';
// //import { getPicklistValues } from 'lightning/uiObjectInfoApi';
// import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';

// export default class RecordFormWithRecordType extends LightningElement {
//     // Flexipage provides recordId and objectApiName
//     @api recordId;
//     @api objectApiName;
//     dataList;
//     recordsList = [];
//     objName = "Account"
//     //val;
//     recTypeId;
//     picklistValues;
//     flds = [
//             'Account.Name',
//             'Account.Website',
//             'Account.Phone'
//         ];
//    // @track objectInfo;
//     pickListField = this.objName +".Industry";
//     @wire(getObjectInfo, { objectApiName: '$objName' })
//     objectInfo;
//     /*fetchObjectInfo({data,error}) {
        
//         alert(data);
//         if(data) {
//             console.log('d**********'+JSON.stringify(data));
//             console.log('dddddddddd'+JSON.stringify(data.defaultRecordTypeId));
//             this.recTypeId = data.defaultRecordTypeId;
//             //this.pickListFld = this.
//         }
        
//     }*/

//     @wire(getListUi, {
//         objectApiName: '$objName',
//     })
//     listViewName({error, data}){
//         if(data) {
//             console.log("ing2222", data);
//             this.recTypeId = data.lists[0].apiName;
//             console.log('************'+this.recTypeId);
//         }
//     }

//     /*@wire(getListUi, {
//         objectApiName: '$objName',
//         listViewApiName: '$listViewName.data.lists[0].apiName',
//         fields: '$flds'
//     })
//     wiredListView({error, data}){
//         if(data) {
//             console.log("ing2222", data);

//             /*console.log("getListUi", data.records.records[0].fields.Website);
//             console.log("getListUi", data.records.records[0].fields.Name);
//             console.log("getListUi", data.records.records[0].fields);*/
//             /*this.records = data.records.records.map(item => {
//                 let field = item.fields
//                 let account = field.Account.value.fields
//                 return { 'Id': field.Id.value, 'Name': field.Name.value, 'AccountId': account.Id.value, 'AccountName': account.Name.value, 'CloseDate': field.CloseDate.value, 'StageName': field.StageName.value, 'Amount': field.Amount.value }

//             })*/
//        /* }
//         if(error){
//             console.error(error)
//         }
//     }
// */
//     @wire(getPicklistValues, {
//         recordTypeId: '$objectInfo.data.defaultRecordTypeId',
//         fieldApiName: '$pickListField'
//     })
//     //picklistValues;
//     fetchPicklist({error,data}){
//         alert('hey');
//         //this.dat =data;
//         console.log('data'+JSON.stringify(data));
//         if(data){
//             alert('inn');
//             console.log('data = ',data.values);
//             data.values.forEach(temp => {
//                 /*this.picklistValues.label = d.label;
//                 this.picklistValues.value = d.valaue;*/
//                 console.log('data.label'+temp.label);
//             });
//             console.log(this.picklistValues);
//             //this.dat = data;
//             //console.log('data.picklistFieldValues = ',data.picklistFieldValues);
//             //this.val = data.picklistFieldValues;
//         } else if(error){
//             console.log(error);
//         }
//     }

//     @wire(getListUi, {
//         objectApiName: '$objName',
//         listViewApiName: '$recTypeId',
//         fields: '$flds'
//     })
//     wiredListView({error, data}){
//         if(data) {
//             console.log("ing2222", data);
//             this.recordsList = data.records.records.fields;
//             /*console.log("getListUi", data.records.records[0].fields.Website);
//             console.log("getListUi", data.records.records[0].fields.Name);
//             console.log("getListUi", data.records.records[0].fields);*/
//             /*this.records = data.records.records.map(item => {
//                 let field = item.fields
//                 let account = field.Account.value.fields
//                 return { 'Id': field.Id.value, 'Name': field.Name.value, 'AccountId': account.Id.value, 'AccountName': account.Name.value, 'CloseDate': field.CloseDate.value, 'StageName': field.StageName.value, 'Amount': field.Amount.value }

//             })*/
//         }
//         if(error){
//             console.error(error)
//         }
//     }
//     get recordTypeId() {
//         // Returns a map of record type Ids 
//         const rtis = this.objectInfo.data.recordTypeInfos;
//         console.log(rtis);
//         return Object.keys(rtis).find(rti => rtis[rti].name === 'Special Account');
//     }

//     handleClick(){
//         console.log(this.objectInfo);
//         //console.log(this.objectInfo.data.defaultRecordTypeId);
//         console.log(this.picklistValues);
//         console.log('dataaaa'+this.recTypeId);
//     }
// }