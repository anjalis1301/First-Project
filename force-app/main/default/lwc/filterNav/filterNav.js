import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class FilterNav extends NavigationMixin(LightningElement) {
@api infoTabb;
    navigateBack(){
        console.log(this.infoTabb);
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                //Name of any CustomTab. Visualforce tabs, web tabs, Lightning Pages, and Lightning Component tabs
                apiName: 'Tab_Container'
            },
            state: {
                c__info : this.infoTabb
            }
        });
    }
}