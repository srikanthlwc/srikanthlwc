@RestResource(urlMapping='/LeadService/*')

global class LeadRestService {

    @httpget

    global static list<lead> getleadInformation(){

        RestRequest req = RestContext.request;

        RestResponse res = RestContext.response;

        system.debug('req.requestURI'+req.requestURI);

        string requestURI = req.requestURI;       

        string leadName ='%'+requestURI.substring(requestURI.lastIndexOf('=')+1)+'%';

        system.debug('leadName'+leadName);

        list<lead> leadlist = [SELECT Id,Name,Email,Phone,Company,MobilePhone from lead where Name like :leadName];

        return leadlist;

    }

    @httpDelete

    global static string deleteMatchingLead(){

        string responseMessage;

        integer leadCount =0;

        try{

            RestRequest req = RestContext.request;

            RestResponse res = RestContext.response;

            system.debug('req.requestURI'+req.requestURI);

            string requestURI = req.requestURI;       

            string leadName ='%'+requestURI.substring(requestURI.lastIndexOf('=')+1)+'%';

            system.debug('leadName'+leadName);

            list<lead> leadlist = [SELECT Id,Name,Email,Phone,Company,MobilePhone from lead where Name like :leadName];

            if(leadlist!=NULL && leadlist.size()>0){

                leadCount = leadlist.size();

            }

            delete leadlist;

        }

        catch(Exception ex){

            responseMessage =  'Exception occured during delete =>'+ex.getMessage();   

        }

        responseMessage =  'Lead deleted sucesfully => lead deleted count : '+leadCount;

        return responseMessage;

       

    }

    @HttpPost

    global static string createNewLead(string fname,string lname,string cname,string leademail,string leadphoneNumber){

        string respMessage;

        try{

            lead l = new lead();

            l.FirstName = fname;

            l.LastName = lname;

            l.Company = cname;

            l.Email = leademail;

            l.Phone = leadphoneNumber;

            insert l;

            respMessage = 'Lead created succesfully with id as: '+l.id;

        }

        catch(Exception ex){

            respMessage = 'Error occured during new lead creation=>'+ex.getMessage();     

        }

        return respMessage;

    }

    @httpPatch

    global static string updateLeadEmail(string newEmail){

        string respMessage;

        try{

            RestRequest req = RestContext.request;

            string requestURI = req.requestURI;

            string leadid = requestURI.substring(requestURI.lastIndexOf('=')+1);

            lead mylead = [Select id,email from lead where id=:leadid];

            if(mylead!=NULL && mylead.Email !=newEmail){

                string oldemail = mylead.Email;

                mylead.email = newEmail;

                update mylead;

                respMessage = 'Lead updated from old email '+oldemail +' with new email as '+newEmail;

            }

            else{

                respMessage = 'Currently this lead is having same email address '+newEmail;

            }

        }

        catch(Exception ex){

           respMessage ='Exception occured during lead update '+ex.getMessage();

        }

       

        return respMessage;

    }

   

}

 
 /*
create certificate in server
download certificate
export certificate keystore from server
create connected app in server
add certificate in connected app

https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG9n_HvETGhr3Bb_Z_.Ri3bBvQfXrqBwD57Oyll733N.Eqwbi4uBHlXVOXxFqUT4vxNSND8U4gk3e6_SuU7&redirect_uri=https://www.salesforce.com/
 
Sample code - OAuth 2.0 JWT Bearer Flow for Server-to-Server Integration


public class JWTIntegration {

   

    private JWTConfiguration config;

   

    public JWTIntegration(JWTConfiguration config){

    this.config = config;   

    }



    public string requestAccessToken(){

        Map<string,string> reqBodyMap = new Map<string,string>();

        reqBodyMap.put('grant_type','urn:ietf:params:oauth:grant-type:jwt-bearer');

        reqBodyMap.put('assertion',createToken());

    Http h = new Http();

        HttpRequest hreq = new HttpRequest();

        hreq.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        hreq.setEndpoint('https://'+config.JWTHostName+'/services/oauth2/token');

        hreq.setMethod('POST');

        hreq.setTimeout(60*1000);

        hreq.setBody(formEncode(reqBodyMap));

        HttpResponse hres = h.send(hreq);

        if(hres.getStatusCode()>=200 && hres.getStatusCode()<300){

        //parse my response JSON to get access token

        return  extractJSONField(hres.getBody(),'access_token'); 

        }

        else{

            throw new JWTException(hres.getBody());

        }

    }

    private string extractJSONField(string body, string field){

    JSONParser parser = JSON.createParser(body);

        while(parser.nextToken()!=NULL){

            if(parser.getCurrentToken()== JSONTOKEN.FIELD_NAME && parser.getText()==field){

            parser.nextToken();

                return parser.getText();

            }   

        }

        throw new JWTException(field+' not found in repsonse '+body);

    }

    private string formEncode(Map<string,string> reqBodyMap){

        string reqBody='';

        for(string key :reqBodyMap.keySet() ){

            if(reqBody.length()>0){

            reqBody = reqBody+'&';   

            }

            reqBody = reqBody+ key+'='+EncodingUtil.urlEncode(reqBodyMap.get(key), 'UTF-8');

            //&grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=tokejfkasfaag

        }

        return reqBody;

    }

    public string createToken(){

        string alg ='RS256';

        string iss = config.JWTConnectedAppConsumerKey;

        string prn = config.jwtUserName;

        string aud = 'https://'+config.JWTHostName;

        string exp = string.valueOf((system.currentTimeMillis()+60*60*1000));

        //step 1- create token

        header jwtHeader = new Header(alg);

        string headerJSON = JSON.serialize(jwtHeader);//{"alg":"RS256"}

        system.debug('***headerJSON=>'+headerJSON);

        //step2- create JSON Claim set

        Body jsonClaim = new Body(iss,prn,aud,exp);

        string bodyJSON = JSON.serialize(jsonClaim);

        system.debug('***bodyJSON=>'+bodyJSON);

        //step 3- Base64 URL encode JWTHeader

        string encodedJWTHeader = base64URlSafe(blob.valueOf(headerJSON));

         system.debug('***encodedJWTHeader=>'+encodedJWTHeader);

        //step4- base64 URL encode for bodyJSON

        string encodedJWTBody =  base64URlSafe(blob.valueOf(bodyJSON));

        system.debug('***encodedJWTBody=>'+encodedJWTBody);

        //step5 - create a string of JWTHeader . Body

        string token = encodedJWTHeader+'.'+encodedJWTBody;

         system.debug('***token=>'+token);

        //step 6 - sign with certificate - RSA-SHA256

        string signature = base64URlSafe(Crypto.signWithCertificate('RSA-SHA256', blob.valueOf(token),config.JWTSignedCertificateName ));

        //step 7 - final token - token+'.'+ tokensignature

        token = token+'.'+signature;

         return token;

    }

    public string base64URlSafe(blob b){

    return EncodingUtil.base64Encode(b).replace('+','-').replace('/','_');   

    }

    public class JWTConfiguration{

        public string jwtUserName{get;set;}

        public string JWTConnectedAppConsumerKey{get;set;}

        public string JWTSignedCertificateName {get;set;}

        public string JWTHostName {get;set;}

    }

    public class Header{

        string alg;

        Header(string alg){

            this.alg = alg;

        }

    }

    public class Body{

        string iss;

        string prn;

        string aud;

        string exp;

        Body(string iss,string prn,string aud,string exp){

        this.iss = iss;

            this.prn = prn;

            this.aud = aud;

            this.exp = exp;

        }       

    }

    public class JWTException extends Exception{

       

    }

    public class leadResponse{

        public string id{get;set;}

        public string Name{get;set;}

        public string Email{get;set;}

        public string Phone{get;set;}

        public string Company{get;set;}

        public string MobilePhone{get;set;}

    }

}



===============Developer console==============





JWTIntegration.JWTConfiguration config = new JWTIntegration.JWTConfiguration();

config.jwtUserName ='srikanthlwc546@gmail.com';

config.JWTConnectedAppConsumerKey = '3MVG9n_HvETGhr3Bb_Z_.Ri3bBvQfXrqBwD57Oyll733N.Eqwbi4uBHlXVOXxFqUT4vxNSND8U4gk3e6_SuU7';

config.JWTSignedCertificateName = 'ctrlfserver';

config.JWTHostName='login.salesforce.com';

JWTIntegration jtwObj = new JWTIntegration(config);

string accesstoken = jtwObj.requestAccessToken();

system.debug('**accesstoken==>'+accesstoken);

//use this JWT acces token in my sibsequent calls to access protected data

HTTP h = new HTTP();

HTTpRequest req = new HttpRequest();

req.setmethod('GET');

req.setEndpoint('https://srikanthlwc-dev-ed.lightning.force.com/services/apexrest/LeadService/name=arya');

req.setHeader('Authorization','Bearer '+accesstoken);

req.setHeader('Content-Type', 'application/json');

HttpResponse res  = h.send(req);

system.debug('Lead==>'+res.getBody());



================Pre approve user URl==============

https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=3MVG95jctIhbyCpqKBhfhUgQITAwt8LvcQHXWJa6p6uzASMC68PPd1zOYJ8oE4eGNlXHbR.0gGRCE6zFTfETS&redirect_uri=https://www.salesforce.com/&response_type=code



*/