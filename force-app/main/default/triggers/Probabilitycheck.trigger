trigger Probabilitycheck on Opportunity (before update,before delete) {
    //List<user> u=[select id from user where id=:userinfo.getUserId()];
    Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
//trigger.oldmap.get(o.Id).Probability!=o.Probability
    if(trigger.isupdate||trigger.isbefore){
        for(opportunity o:trigger.new){
            if(ProfileName.Name=='system administrator'&&o.Probability>50){
                o.name='opp3';
                
            }
            else{
                o.adderror('user not matched');
            }
            
        }
    }
        if(trigger.isdelete||trigger.isbefore){
            for(opportunity o:trigger.old){
                system.debug('jjjjjjjjjjj'+trigger.oldmap.get(o.Id).Probability);
           if(ProfileName.Name=='system administrator'&&trigger.oldmap.get(o.Id).Probability>75){
 
                    o.addError('You cannot delete This opp.');

              
        }
   
}
}
}