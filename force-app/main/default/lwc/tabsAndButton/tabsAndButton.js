import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class TabsAndButton extends NavigationMixin(LightningElement) {
    @api info;
    showTab;
    flag;
    connectedCallback(){
        this.showTab = true;
        console.log('&&&&&&&&&&&&&&&&&'+this.info);
        if(this.info != undefined ){
            this.flag = true;
        }
    }

    renderedCallback(){
        console.log('connected');
        if(localStorage.getItem('tabId')) {
        //if(this.flag){
            this.info = localStorage.getItem('tabId');
            var inf = this.info;
            console.log(this.template.querySelector('.slds-is-active').classList);
            var previous = this.template.querySelector('.slds-is-active');
            previous.classList.remove('slds-is-active');
            console.log('dta-id');
            console.log('2222222222 '+this.template.querySelector('[data-id = "'+inf+'"]').classList);
            var current = this.template.querySelector('[data-id = "'+inf+'"]');
            current.classList.add('slds-is-active');
            console.log('************ '+current.id);
            console.log('************ '+this.info);
            var previousData = this.template.querySelector('.slds-show');
            previousData.classList.remove('slds-show');
            previousData.classList.add('slds-hide');
            console.log('************!!!!!!! '+previousData.classList);
            var currentData = this.template.querySelector('[data-id = "'+current.dataset.id+'Content"]');
            console.log('************!!!!!! '+currentData.classList);
            currentData.classList.remove('slds-hide');
            currentData.classList.add('slds-show');
            localStorage.removeItem('tabId');
            //this.flag = false;
        } 
    }
    navigate(){
        console.log('navigate'+this.info);
        localStorage.setItem('tabId',this.info);

        /*this[NavigationMixin.Navigate]({
            type: "standard__component",
            attributes: {
                componentName: "c__FilterContainer"
            },
            state: {
                c__infoTabb: this.info
            }
        });*/
        //this.showTab = false;
        var compDefinition = {
            componentDef: "c:filterNav"           
        };
        var encodedCompDef = btoa(JSON.stringify(compDefinition));
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/one/one.app#' + encodedCompDef
            },
            state: {
                c__tabInfo: 'ioooooooo'
            }
        });
    }

    navigateBack(event){
        this.showTab = true;
        this.changeTab(event);
        
    }


    changeTab(event){
        console.log(this.template.querySelector('.slds-is-active').classList);
        var previous = this.template.querySelector('.slds-is-active');
        previous.classList.remove('slds-is-active');
        console.log('2222222222 '+event.currentTarget.classList);
        var current = event.currentTarget;
        current.classList.add('slds-is-active');
        console.log('************ '+current.dataset.id);
        this.info = current.dataset.id;
        console.log('************ '+this.info);
        var previousData = this.template.querySelector('.slds-show');
        previousData.classList.remove('slds-show');
        previousData.classList.add('slds-hide');
        console.log('************!!!!!!! '+previousData.classList);
        var currentData = this.template.querySelector('[data-id = "'+current.dataset.id+'Content"]');
        console.log('************!!!!!! '+currentData.classList);
        currentData.classList.remove('slds-hide');
        currentData.classList.add('slds-show');
    }
   
}