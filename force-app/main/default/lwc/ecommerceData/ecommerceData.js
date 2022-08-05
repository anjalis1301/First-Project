import { LightningElement,track } from 'lwc';
import fetchData from '@salesforce/apex/EcommerceData.getData';
export default class EcommerceData extends LightningElement {
    temp = [];
    parentProductNm;
    @track result;
    @track selectedAttribute = [];
    @track selectedValues = [];
    @track displayListPage =[];
    selectFlag;
    selectedChildProduct = '';
    selectedValuesMap = new Map();
    combinationNameMap = new Map();

    connectedCallback() {
        fetchData({
            parentProduct: window.location.hash.substr(1)
        }).then(response => {
            this.result = response;
            console.log(JSON.stringify(response));
            let responseJSON = response.displayList;
            this.parentProductNm = response.parentProductName;
            let holderList = [];
            Object.keys(responseJSON).forEach(element => {
                var option = {};
                var optionList = [];
                Object.keys(responseJSON[element]).forEach(elem => {
                    var subOption = {};
                    subOption['value'] = elem;
                    subOption['valueParam'] = responseJSON[element][elem];
                    optionList.push(subOption);
                })
                option['attribute'] = element;
                option['attributeValues'] = optionList;
                holderList.push(option);
            });
            this.displayListPage = holderList;
            console.log(JSON.stringify(holderList));
        });
    }

    enableDisableData(event) {
        let attribute = event.currentTarget.dataset.type;
        let attributeValue = event.currentTarget.label;
        let childProductIds = event.currentTarget.dataset.cinfo;
        let attributeIndex = event.currentTarget.dataset.attributeindex;
        let valueIndex = event.currentTarget.dataset.valueindex;
        this.selectFlag = true;

        if( this.displayListPage[attributeIndex].attributeValues[valueIndex].valueParam.variant == 'brand' ) {
            this.displayListPage[attributeIndex].attributeValues[valueIndex].valueParam.variant = 'brand-outline';
        } else {
            this.displayListPage[attributeIndex].attributeValues[valueIndex].valueParam.variant = 'brand';
        }
        
        for( let index in this.displayListPage[attributeIndex].attributeValues ) {
            if( valueIndex != index ) {
                this.displayListPage[attributeIndex].attributeValues[index].valueParam.variant = 'brand-outline';
            }
        }
        
        if( this.selectedValuesMap.has(attributeIndex) && this.selectedValuesMap.get(attributeIndex) == valueIndex ) {
            this.selectedValuesMap.delete(attributeIndex);
            this.combinationNameMap.delete(attributeIndex);
        }else {
            this.selectedValuesMap.set(attributeIndex, valueIndex);
            this.combinationNameMap.set(attributeIndex, childProductIds);
        }

        console.log(this.selectedValuesMap);
        console.log(this.combinationNameMap);
        if( this.selectedValuesMap.size == 0 ) {
            for(let i=0 ; i < this.displayListPage.length ; i++) {
                for(let j=0 ; j < this.displayListPage[i].attributeValues.length ; j++) {
                    this.displayListPage[i].attributeValues[j].valueParam.variant = 'brand-outline';
                    this.displayListPage[i].attributeValues[j].valueParam.disable = false;
                }
            }
        } else {
            for(let i=0 ; i < this.displayListPage.length ; i++) {
                var lastMapKey = Array.from(this.selectedValuesMap.keys()).pop();
                if( lastMapKey == i.toString() ) {
                    continue;
                } else {
                    for(let j=0 ; j < this.displayListPage[i].attributeValues.length ; j++) {
                        this.displayListPage[i].attributeValues[j].valueParam.disable = true;
                    }
                    var lastMapList = this.combinationNameMap.get(lastMapKey).split(',');
                    for(var k=0; k < lastMapList.length ; k++) {
                        for(let j=0 ; j < this.displayListPage[i].attributeValues.length ; j++) {
                            if(this.displayListPage[i].attributeValues[j].valueParam.combinationName.includes(lastMapList[k])) {
                                this.displayListPage[i].attributeValues[j].valueParam.disable = false;
                            }
                        }
                    }
                }
            }
        }
        /*if(this.selectedAttribute.includes(attr) && this.selectedValues.includes(attributeValue)) {
            this.selectedAttribute.splice(this.selectedAttribute.indexOf(attr),1);
            this.selectedValues.splice(this.selectedValues.indexOf(attributeValue),1);

                this.selectFlag = false;
                this.displayListPage[attributeIndex].attributeValues[valueIndex].valueParam.variant = 'brand-outline';
                this.enableData(attr,attributeValue);
        } else if(this.selectedAttribute.includes(attr) && this.selectedValues.includes(attributeValue) === false) {
            this.selectedValues.push(attributeValue);
            for(let index in this.displayListPage[attributeIndex].attributeValues) {               
                if(this.displayListPage[attributeIndex].attributeValues[index].value == this.displayListPage[attributeIndex].attributeValues[valueIndex].value) {
                    this.displayListPage[attributeIndex].attributeValues[index].valueParam.variant = 'brand';
                } else {
                    if(this.displayListPage[attributeIndex].attributeValues[index].valueParam.variant == 'brand') {
                        this.selectedValues.splice(this.selectedValues.indexOf(this.displayListPage[attributeIndex].attributeValues[index].value),1);
                    }
                    this.displayListPage[attributeIndex].attributeValues[index].valueParam.variant = 'brand-outline';
                }
            }
        } else {
            this.selectedAttribute.push(attr);
            this.selectedValues.push(attributeValue);
            this.displayListPage[attributeIndex].attributeValues[valueIndex].valueParam.variant = 'brand';
        }
        
        if(this.selectFlag) {            
            this.processData(attr,attributeValue,childProductIds,attributeIndex,valueIndex);
        }*/
        
    }

    enableData(attrName,attrValue) {
        if(this.selectedChildProduct !== ''){
            this.selectedChildProduct = '';
        }
        for(let displayIndex in this.displayListPage) {
            for(let valIndex in this.displayListPage[displayIndex].attributeValues) {
                 if(this.displayListPage[displayIndex].attributeValues[valIndex].valueParam.variant == 'brand' ) {
                    this.processData(this.displayListPage[displayIndex].attribute,this.displayListPage[displayIndex].attributeValues[valIndex].value,this.displayListPage[displayIndex].attributeValues[valIndex].valueParam.combinationName,displayIndex,valIndex);
                } else if(this.selectedAttribute.length === 0) {
                    this.displayListPage[displayIndex].attributeValues[valIndex].valueParam.disable = false;
                }
            }
        }
    }

    processData(attr,attributeValue,childProductIds,attributeIndex,valueIndex) {
        let enableValues = [];
            Object.keys(this.result.cProductList).forEach(childElem =>{
                 if(childProductIds.includes(this.result.cProductList[childElem].Id)) {
                     if(this.displayListPage.length === this.selectedAttribute.length) {
                         this.selectedChildProduct = this.result.cProductList[childElem].Id;
                     }
                    for(let temp in this.result.cProductList[childElem].Product_Attribute_Values__r) {
                        if(this.result.cProductList[childElem].Product_Attribute_Values__r[temp].Product_Attribute__r.Name !== attr) {
                            enableValues.push(this.result.cProductList[childElem].Product_Attribute_Values__r[temp].Attribute_Values__c);
                        }
                    }
                 }
            });            
            Object.keys(this.displayListPage).forEach(element => {
                if(attr.includes(this.displayListPage[element].attribute) === false) {
                    for(let index in this.displayListPage[element].attributeValues) {
                        if(!enableValues.includes(this.displayListPage[element].attributeValues[index].value)) {
                            this.displayListPage[element].attributeValues[index].valueParam.disable = true;
                        } else  {
                            this.displayListPage[element].attributeValues[index].valueParam.disable = false;
                        }
                    }
                } 
            });
        
    }
}