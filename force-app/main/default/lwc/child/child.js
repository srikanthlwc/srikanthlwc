import { LightningElement, api } from 'lwc';

export default class Child extends LightningElement {
	
   @api content;
/* Created a method and used api decorator before it so as to expose
 it in parent component */
    @api
    changeContent(){
        this.template.querySelector('div').innerHTML="Hello Lightning Web Component!";
    }
}