import { LightningElement, api } from 'lwc';

export default class InvokeTest extends LightningElement {
    @api cvRefer = [];
    connectedCallback(){
        this.cvRefer.push('hello','hey');
        // let pos =[];
        // let temp = {};
        // temp.one = 'hello';
        // temp.two = 'hey';
        // pos.push(temp);
        // this.cvRefer.push(pos);
        // console.log(this.cvRefer);
        JSON.stringify(this.cvRefer);
    }
}