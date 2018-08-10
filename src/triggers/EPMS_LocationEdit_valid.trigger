/**************************************************************************************
*   Trigger             :       EPMS_LocationEdit_valid                               *
*   Created Date        :       13/04/2016                                            *           
*   Description         :       This trigger will throw error message 
                                when trying to change location name                   *     
                                                                                       
****************************************************************************************/

trigger EPMS_LocationEdit_valid on Location__c (before update) {
   
   if(trigger.isbefore && trigger.isUpdate){
   
       List<Location__c> old_LocationData = trigger.old;
       List<Location__c> new_LocationData =trigger.new;
       Integer inc=0;
       
       for(Location__c locations:new_LocationData){
        // changing location name  
           if(locations.Name!=old_LocationData[inc].Name){
               locations.addError(label.EPMS_MBO_Changing_Location_Name); 
           }
            inc++;
       }
   }
   
   
}