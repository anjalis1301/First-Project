import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class PrintValues extends NavigationMixin(LightningElement) {
    @api record;
    @api field;
    @api index;
    @api objName;
    data;
    show;
    connectedCallback() {
        if(this.index == 0) {
            this.show=true;
        }
        this.data = this.record[this.field];
    }

    editRecord(event) {
        var recId = event.target.getAttribute('data-id');
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recId,
                objectApiName: this.objName,
                actionName: 'view'
            }
        });
    }
}