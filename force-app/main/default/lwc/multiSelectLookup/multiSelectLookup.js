import { LightningElement, track, api } from 'lwc';
import getData from '@salesforce/apex/MultiSelectLookup.retrieveRecords';
export default class MultiSelectCombobox extends LightningElement {
    @api objNm;
    @api fldList;
    @api filterFld;
    @api options ;
    @api selectedValue;
    @api selectedValues = [];
    @api label ;
    @api minChar = 2;
    @api disabled = false;
    @api multiSelect = false;
    @track value;
    @track values = [];
    @track optionData;
    @api searchString;
    @track message;
    @track showDropdown = false;

    //sets the variables with values when component is load on DOM
    connectedCallback() {
        this.showDropdown = false;
        var optionData = this.options ? (JSON.parse(JSON.stringify(this.options))) : null;
        var value = this.selectedValue ? (JSON.parse(JSON.stringify(this.selectedValue))) : null;
        var values = this.selectedValues ? (JSON.parse(JSON.stringify(this.selectedValues))) : null;
        if(value || values) {
            alert('value',value,'******************',values);
            var searchString;
            var count = 0;
           /* for(var i = 0; i < optionData.length; i++) {
                if(this.multiSelect) {
                    if(values.includes(optionData[i].value)) {
                        optionData[i].selected = true;
                        count++;
                    }
                } else {
                    if(optionData[i].value == value) {
                        searchString = optionData[i].label;
                    }
                }
            }*/
            if(this.multiSelect)
                this.searchString = count + ' Option(s) Selected';
            else
                this.searchString = searchString;
        }
        this.value = value;
        this.values = values;
        this.optionData = optionData;
    }

    //When user enter the characters then filter the options accordingly
    filterOptions(event) {
        this.searchString = event.target.value;
        if( this.searchString && this.searchString.length > 0 ) {
            this.message = '';
            if(this.searchString.length >= this.minChar) {
                getData({
                    "objectName" : this.objNm,
                    "fieldAPINames" : this.fldList,
                    "filterFieldAPIName" : this.filterFld,
                    "strInput" : this.searchString
                }).then(response => {
                    console.log(response);
                    if(response){
                        this.options = JSON.parse(JSON.stringify(response));
                        this.optionData = JSON.parse(JSON.stringify(response));
                        for(var i = 0; i < this.optionData.length; i++) {
                            this.optionData[i].isVisible = true;
                        } 
                    } else {
                        this.message = "No results found for '" + this.searchString + "'";
                    }
                });
                
            }
            this.showDropdown = true;
        } else {
            this.showDropdown = false;
        }
    }

    //when a user click a option to select or deselect it
    selectOrDeselectItem(event) {
        console.log('inside');
        var selectedVal = event.currentTarget.dataset.id;
        console.log('inside'+selectedVal);
        if(selectedVal) {
            var count = 0;
            var options = this.optionData;
            console.log('va;lllllllllll'+this.values);
            for(var i = 0; i < options.length; i++) {
                console.log('iii'+options[i].value);
                if(options[i].recordId === selectedVal) {
                    if(this.multiSelect) {
                        if(this.values.includes(options[i].recordId)) {
                            this.values.splice(this.values.indexOf(options[i].recordId), 1);
                        } else {
                            this.values.push(options[i].recordId);
                        }
                        options[i].selected = options[i].selected ? false : true;
                    } else {
                        this.value = options[i].recordId;
                        this.searchString = options[i].recordName;
                    }
                }
                if(options[i].selected) {
                    count++;
                }
            }
            this.optionData = options;
            if(this.multiSelect) {
                event.preventDefault();
                this.searchString = count + ' Option(s) Selected';
            }
            else
                this.showDropdown = false;
        }
    }

    //Wen a user click the input then the dropdow is opened with all the options
    showOptions() {
        if(this.disabled == false && this.options) {
            this.message = '';
            this.searchString = '';
            var options = this.optionData;            
            if(options.length > 0) {
                this.showDropdown = true;
                for(var i = 0; i < options.length; i++) {
                    options[i].isVisible = true;
                }
            }
            this.optionData = options;
        }
    }

    //method to remove the pill 
    removePill(event) {
        var value = event.currentTarget.name;
        var count = 0;
        var options = this.optionData;
        for(var i = 0; i < options.length; i++) {
            if(options[i].recordId === value) {
                options[i].selected = false;
                this.values.splice(this.values.indexOf(options[i].recordId), 1);
            }
        }
        this.optionData = options;
        this.blurEvent();

    }

    // when the user click outside the input
    blurEvent() {
        var previousLabel;
        var count = 0;
        var value = (this.multiSelect) ? this.values: this.value;
        for(var i = 0; i < this.optionData.length; i++) {
            if(this.optionData[i].recordId === this.value) {
                previousLabel = this.optionData[i].label;
            }
            if(this.optionData[i].selected) {
                count++;
            }
        }
        if(this.multiSelect){
            this.searchString = count + ' Option(s) Selected';}
        else
            this.searchString = previousLabel;
        this.showDropdown = false;
        this.dispatchEvent(new CustomEvent('clicked',{
            detail :{ value }
        }));

    }
}