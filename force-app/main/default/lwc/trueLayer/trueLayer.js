import { LightningElement, track } from 'lwc';
import authCode from '@salesforce/apex/TrueLayer.authorization';
import gotToken from '@salesforce/apex/BoxIntegration.fetchAccessToken';
export default class trueLayer extends LightningElement {

//method to set values when component is loaded in DOM
connectedCallback(){
    this.loadData();    
}

//method to load data initially
loadData(){
    var currentPageUrl = new URL(window.location.href);
    var code = currentPageUrl.searchParams.get("code");
    alert(code);
    if(code == null) { 
        alert(code);
        authCode().then(response => {
            var auth = response;
            if(auth.Flag == false) {
                alert(code+'false');
                window.open(auth.authCodeUrl,'_top');                    
            } /*else {
                
            }*/
        });
    } else {
        var actionForAccessTkn = gotToken;
        gotToken({
            "authCode" : code
        }).then(() => {
            var redirect = 'https://briskmindssoftwaresolutions-dev-ed.lightning.force.com/lightning/n/Try';
            window.open(redirect,'_top');
        });
    }
}
}