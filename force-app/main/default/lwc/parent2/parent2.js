import { LightningElement  } from 'lwc';
 
export default class app extends LightningElement {
    greeting;
   constructor(){
       super();
        this.template.addEventListener('myfirstcustomevent', this.handleCustomEvent);
   }
 
    handleCustomEvent = () => {
        this.greeting = event.detail;
 
    }
}