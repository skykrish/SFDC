/***********************************************************************************************************************
   Trigger             :    EPMS_Trg_DeleteLocation    
   Created Date        :    13/04/2016                                             
   Description         :    If any reference record exists when we try to delete the location record this trigger will 
                            shows Validation error.                                                                              
**************************************************************************************************************************/
trigger  EPMS_Trg_DeleteLocation on  Location__c(before update,before delete){
    
    List<Location__c> LocationHolder =null;
    list<string> LocationName = new list<string>();
    
   /* if(Trigger.isDelete){
         LocationHolder = Trigger.old;

    }
    
    if(Trigger.isUpdate){
        LocationHolder = Trigger.new;
    }
     
    for(Location__c locationid: LocationHolder)
    {
        LocationName.add(locationid.Name);  
    }
       
       // query location record
       List<Location__c> LocationID = Database.query('select Id from Location__c where Name = :LocationName');
       if(LocationID.size() > 0){
            List<String> locationIds = new List<String>();
            String LocationRecordId= LocationID[0].Id; 
            locationIds.add(LocationRecordId);      
            
            // query location related Production order,Files,Member,Mistake,Shift,shift assignments,settings records    
               
            List<Production_Order__c> productionOrder = Database.query('select Mbo_Location__c from Production_Order__c where Mbo_Location__c IN: locationIds');  
            
            List<Files__c> Files = Database.query('select File_Location__c from Files__c where File_Location__c=:LocationRecordId' );             
               
            List<Member__c> Member = Database.query('select Location_id__c from Member__c where Location_id__c=:LocationRecordId');                        
               
            List<Mistakes__c> Mistake = Database.query('select Location__c from Mistakes__c where Location__c=:LocationRecordId'); 

            List<Shift__c> shift = Database.query('select Shift_Location__c from Shift__c where Shift_Location__c=:LocationRecordId');    
            
            List<Team__c> teams = Database.query('select Location__c from Team__c where Location__c=:LocationRecordId');    

            List<Shift_Assignments__c> shiftAssignments = Database.query('select Location__c from Shift_Assignments__c where Location__c=:LocationRecordId');  
               
            List<Settings__c> Settings = Database.query('select id from Settings__c where Location__c=:LocationRecordId');              
        
            // deleting/deactivating location records
            for(Location__c  location:LocationHolder){           
               
           
               if((productionOrder.size() > 0) || (Files.size() > 0) || (Member.size() > 0) || (Mistake.size() > 0) || (shift.size() > 0) || (shiftAssignments.size() > 0) || (Settings.size() > 0) || (teams.size() > 0) ){
                   
                   Location__c actualRecord = Trigger.oldMap.get(location.Id);
                        
                   if(location.Location_Status__c==EPMS_UTIL.EPMS_INACTIVE_STATUS){
                       location.addError(Label.EPMS_MBO_Reference_Records_DeActive);                
                   }
                   
                   if(Trigger.isDelete){
                        
                        if(location.Location_Status__c==EPMS_UTIL.EPMS_ACTIVE_STATUS){
                            location.addError(label.EPMS_MBO_Reference_Records_DeActive);                
                        }
                   }  
               
               }
               

            }               
       }*/
          
    
}