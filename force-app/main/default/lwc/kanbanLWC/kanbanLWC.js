import {LightningElement, api, track} from 'lwc';
import fetchData from '@salesforce/apex/KanbanLWC.getData';
import updateData from '@salesforce/apex/KanbanLWC.updatePickVal';

export default class KanbanLWC extends LightningElement {
    @api objNm;
    @api pickListFieldName;
    @api flds = [];
    @track recordList;
    fldList = [];
    previousRecId;
    valIdx;
    data;

    connectedCallback() {
        this.loadData();
    }

    //this method get the data of the object and store it in recordList
    loadData() {
        fetchData({
            objName: this.objNm,
            fields: this.flds,
            pickListName: this.pickListFieldName
        }).then(response => {
            var recList = [];
            for (let res in response) {
                var temp = JSON.stringify(res);
                recList.push({
                    "key": res,
                    "value": response[res]
                });
            }
            this.recordList = recList;
            this.fldList = this.flds.split(',');
        });
    }

    allowDrop(event) {
        event.preventDefault();
    }

    //this method run when the drag start so that it can store the tiles previous location's info
    dragStart(event) {
        var data1 = event.dataTransfer.setData("text", event.currentTarget.getAttribute('data-id'));
        this.template.querySelector('[data-id="' + event.currentTarget.getAttribute('data-id') + '"]').style.border = "2px solid #F80";
        this.valIdx = event.currentTarget.getAttribute('data-index');
        var tar = event.currentTarget;
        while (tar.tagName != 'ul' && tar.tagName != 'UL')
            tar = tar.parentElement;
        this.previousRecId = tar.getAttribute('data-index');
        if (this.data) {
            this.template.querySelector('[data-id="' + this.data + '"]').style.border = "1px solid #d8dde6";
        }
    }

    //this method run when a tile is droped and then it update its values
    dropData(event) {
        event.preventDefault();
        this.data = event.dataTransfer.getData("text");
        var tar = event.currentTarget;
        while (tar.tagName != 'ul' && tar.tagName != 'UL')
            tar = tar.parentElement;
        var ulId = tar.getAttribute('data-index');
        let temp = this.recordList[this.previousRecId].value[this.valIdx];
        temp[this.pickListFieldName] = this.recordList[ulId].key;
        this.recordList[ulId].value.splice(this.recordList[ulId].value.length, 0, this.recordList[this.previousRecId].value[this.valIdx]);
        this.recordList[this.previousRecId].value.splice(this.valIdx, 1);
        updateData({
            selectId: this.data,
            selectPickFld: this.pickListFieldName,
            newVal: event.currentTarget.getAttribute('data-pick-val')
        }).then(response => {
            this.loadData();
            this.template.querySelector('[data-id="' + this.data + '"]').style.border = "2px solid #00A";
        }).catch(err => {
            this.recordList[this.previousRecId].value.splice(this.valIdx, 0, recordList[ulId].value[this.recordList[ulId].value.length]);
            this.recordList[ulId].value.splice(this.recordList[ulId].value.length, 1);
            alert('You have got an error ' + err);
        });

    }
}