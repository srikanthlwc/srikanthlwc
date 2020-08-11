import { LightningElement } from 'lwc';
 
export default class Parent extends LightningElement {
 /* property in js */
mycontent;
  handleChangeContent(){
    this.template.querySelector('c-child').changeContent();
  }
 
}