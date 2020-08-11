import { LightningElement  } from 'lwc';
 
export default class app extends LightningElement {
    greeting;
 
    handleCustomEvent(event) {
        this.greeting = event.detail;
 
    }
}