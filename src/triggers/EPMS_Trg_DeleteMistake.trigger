/***********************************************************************************************************************
   Class               :    EPMS_Trg_DeleteMistake    
   Created Date        :    13/04/2016                                             
   Description         :    This trigger checks if any reference records are available when a mistake is deleted
                            Upon Insert/Update, If Mistake Category & Mistake are same for two mistake records with the 
                            same location, the trigger shows validation error. 
                                                                                 
**************************************************************************************************************************/


trigger EPMS_Trg_DeleteMistake  on Mistakes__c  (before insert,before update,before delete) {

    List<Mistakes__c> MistakeHolder =null;
    List<id> mistakeids = new List<id>();
        
       // Getting mistake records 
        if(Trigger.isDelete){
             MistakeHolder = Trigger.old;
    
        
        if(Trigger.isUpdate){
            MistakeHolder = Trigger.new;

        }
        for(Mistakes__c Mistakeid : MistakeHolder ){
            mistakeids.add(Mistakeid.id);
        }
        
        //Querying mistake reference records in penalty assignement
        List<Penalty_Assignment__c> penalty = [select Mistake_Id__c from Penalty_Assignment__c where Mistake_Id__c=:mistakeids]; 
        
        //deleting mistakes 
             
        for(Mistakes__c Mistake : MistakeHolder){
                      
            if(penalty.size() > 0){            
                 Mistake.addError(label.EPMS_MBO_MISTAKE_DELETE);                
            } 
               
        }
    }   

// checking mistakes already available in the same location
    if( Trigger.isupdate ){
            
            for(Mistakes__c newMistake :  Trigger.new){        
            
                Mistakes__c mistakeold = Trigger.oldMap.get(newMistake.Id);
                
                if((mistakeold.Mistake_Category__c!=newMistake.Mistake_Category__c) &&(mistakeold.Mistake__c!=newMistake.Mistake__c) ){

                    List<Mistakes__c> mistakerec= [select id,Mistake_Category__c,Mistake__c from Mistakes__c where Mistake_Category__c =: newMistake.MIstake_Category__c AND Mistake__c=:newMistake.Mistake__c AND Location__c=:newMistake.Location__c ];
                
                    if(mistakerec.size() > 0){
                        newMistake.addError(label.EPMS_MBO_MISTAKE_DELETE);                
                    } 
               }  
           }
    }

}