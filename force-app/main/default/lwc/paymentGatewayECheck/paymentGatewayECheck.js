import { LightningElement, api } from "lwc";
import eCheckPay from "@salesforce/apex/PaymentGatewayIntegration.eCheckPayment";
import AuthorizeLogo from '@salesforce/resourceUrl/AuthorizeNetLogo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Name from "@salesforce/schema/Account.Name";
export default class paymentGatewayECheck extends LightningElement {

    logo = AuthorizeLogo;
    RoutingNumber;
    Amnt;
    AccNum;
    AccName;
    Msg;


    visible(event){
        this.dispatchEvent(new CustomEvent('switch', {
            
        }));
    }

    storeRoutingNumber(event) {
        this.RoutingNumber = event.target.value;
    }

    storeAccNumber(event) {
        this.Msg = '';
        this.AccNum = event.target.value;
    }

    storeAccName(event){
        this.Msg = '';
        this.AccName = event.target.value;
    }

    storeAmount(event){
        this.Msg = '';
        this.Amnt = event.target.value;
    }

    payByECheck(event) {
        
        var RoutingNumber = this.RoutingNumber;
        var AccName = this.AccName;
        var AccNum = this.AccNum;
        var Amount = this.Amnt;
        if(RoutingNumber != null && AccNum != null && AccName != null && Amount != null){
            console.log('*************'+/^[a-zA-Z ]*$/.test(AccName));

            if(/^[a-zA-Z ]*$/.test(AccName)){
                this.template.querySelector('[data-id="spin"]').classList.remove('slds-hide');
                    eCheckPay({ 'RoutingNumber' : RoutingNumber,
                        'AccNum' : AccNum,
                        'AccName' : AccName,
                        'Amnt' : Amount
                    }).then(response => {
                        var pars = JSON.parse(response.slice(1));
                        var mode ;
                        var mess = pars.messages.message[0].text;
                        if(pars.messages.message[0].text === ('Successful.')){
                            mode = 'success';
                            this.RoutingNumber = '';
                            this.AccNum = '';
                            this.AccName = '';
                            this.Amnt = '';
                        }else if((pars.messages.message[0].text.includes('unsuccessful'))){
                            mode = 'error';
                            mess += pars.transactionResponse.errors[0].errorText;                        
                        } else {
                            mode = 'warning';
                        }
                        this.template.querySelector('[data-id="spin"]').classList.add('slds-hide');
                        const toastEvent = new ShowToastEvent({
                        title: 'Transaction Status',
                        message: mess,
                        variant : mode,
                        });
                        this.dispatchEvent(toastEvent);
                        
                    }).catch(err => {
                        this.template.querySelector('[data-id="spin"]').classList.add('slds-hide');
                        const toastEvent = new ShowToastEvent({
                            title: 'Transaction Status',
                            message: err.body.message,
                            variant : 'error',
                            });
                        this.dispatchEvent(toastEvent);
                    });
                } else {
                    const toastEvent = new ShowToastEvent({
                        title: 'Transaction Status',
                        message: 'Please Enter a valid Name',
                        variant : 'error',
                        });
                    this.dispatchEvent(toastEvent);
                    
                }
        }else{
            this.Msg = 'All fields are required';
        }
    }
}