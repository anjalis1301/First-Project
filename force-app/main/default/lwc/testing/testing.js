import { LightningElement } from 'lwc';

export default class Testing extends LightningElement {
    storeData = new Map();
    connectedCallback(){
        console.log('areeeeeeeeeeeeeeeeeeeeeee&&&&&'); 
       let  l1 = [];
        l1.push('Hello1');        
        l1.push('Helloooooo1');
        l1.push('Hello****1');
        l1.push('Hello####1');
       let  l2 = [];
        l2.push('Hello2');        
        l2.push('Helloooooo2');
        l2.push('Hello****2');
        l2.push('Hello####2');
        let l3 = [];
        l3.push('Hello3');        
        l3.push('Hellooooo3');
        l3.push('Hello****3');
        l3.push('Hello####3');
        let map1 = new Map([[1 , l1], [2 , l2] ,[3, l3]]);
        console.log(map1.get(1)); 
        this.storeData = map1;
        console.log('*&*&*&',this.storeData);
        
        console.log('*&*&********&',this.storeData.get(1));
    }

    handleChange(event){
        console.log('parent');
        console.log(event.detail);
    }
}