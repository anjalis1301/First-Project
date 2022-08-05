import { LightningElement, api } from "lwc";
import cardPay from "@salesforce/apex/PaymentGatewayIntegration.cardPayment";
import AuthorizeLogo from '@salesforce/resourceUrl/AuthorizeNetLogo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class PaymentGateway extends LightningElement {

    logo = AuthorizeLogo;
    CardNum;
    ExpireMon;
    ExpireYear;
    Amnt;
    CVV;
    Msg;

    visible(event){
        this.dispatchEvent(new CustomEvent('switch', {
            
        }));
    }

    handleFilesChange(event) {
        this.Msg = '';
    }

    handleCardNum(event){
        this.CardNum = event.target.value;
    }

    handleExpireMon(event){
        this.Msg = '';
        this.ExpireMon = event.target.value;
    }

    handleExpireYear(event){
        this.Msg = '';
        this.ExpireYear = event.target.value;
    }

    handleCVV(event){
        this.CVV = event.target.value;
    }

    handleAmnt(event){
        this.Amnt = event.target.value;
    }

    payByCard(event) {
        var CardNum = this.CardNum;
        var ExpireMon = this.ExpireMon;
        var ExpireYear = this.ExpireYear;
        var CVV = this.CVV;
        var Amnt = this.Amnt;
        
        if(CardNum != null && ExpireMon != null && ExpireYear != null && CVV != null){
            var flag = true;
            if(ExpireMon > 12 || ExpireMon < 1 ){
                this.Msg = 'Expire month should be < 1 and < 12';
                flag = false;
            }
            var today = new Date();
            var yyyy = today.getFullYear();
            if(ExpireYear < yyyy ){
                this.Msg = 'Year should be greater than current year and should be a valid year';
                flag = false;
            }
        }else{
            this.Msg = 'All fields are manditory';
        }
        if(flag == true){
            this.template.querySelector('[data-id="spin"]').classList.remove('slds-hide');
            cardPay({ 'CardNum' : CardNum,
            'ExpireMon' : ExpireMon,
            'ExpireYear' : ExpireYear,
            'CVV' : CVV,
            'Amnt' : Amnt
            }).then(response => {
                var pars = JSON.parse(response.slice(1));
                var mode ;
                var mess = pars.messages.message[0].text;
                if(pars.messages.message[0].text === ('Successful.')){
                    mode = 'success';
                    this.CardNum = '';
                    this.ExpireMon = '';
                    this.ExpireYear = '';
                    this.CVV = '';
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
        }
    }
}