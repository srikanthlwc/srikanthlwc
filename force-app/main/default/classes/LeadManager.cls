global class LeadManager {
    webservice static string createNewLead(string leadFirstName,string leadLastName,string LeadCompanyName,string leadEmail,string leadphone){
        try{
            Lead ld = new lead();
            ld.FirstName = leadFirstName;
            ld.LastName = leadLastName;
            ld.Company  = LeadCompanyName;
            ld.Email    = leadEmail;
            ld.Phone    = leadphone;
            insert ld;
            return ld.id;
        }
        catch(exception ex){
            return 'Error during processing';
        }
    }
}
/*
 server salesforce->srikanthlwc546@gmail.com
 client salesforce->srikanthpalla546@gmail.com
download wsdl from leadmanager class and create apex class in Client side
and setup->develop->api->download partner api and create apex class in clinet side

run code from anonymous window
================================
string username = 'srikanthlwc546@gmail.com';

string password = 'Palla546@7EK4M5ynv397eyyGcRCSki7r';

partnerSoapSforceCom.soap soapObj = new partnerSoapSforceCom.soap();

partnerSoapSforceCom.LoginResult logRes =soapObj.login(username,password);

system.debug('logRes'+logRes);

//step 2 - sessionHeader objec to pass session id

SoapLeadManager.SessionHeader_element sessionObj = new SoapLeadManager.SessionHeader_element();

sessionObj.sessionId = logRes.sessionId;

//step 3- session obj with soap call

SoapLeadManager.LeadManager leadserveice = new SoapLeadManager.LeadManager();

leadserveice.SessionHeader = sessionObj;

string response = leadserveice.createNewLead('arya','pala','ctlf11','ha111@gmail.com','+9715628363');

system.debug('response'+response);


 */