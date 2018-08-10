/********************************************************************************************************
   Trigger              : EPMS_UpdateCostPerday                                                         *  
   Created Date         : 16/01/2018                                                                    *
   Description          : Update PA Cost, TL Cost & QC Cost per month and calling                       *
                            Batch to update Cost Per Day in Member Object                               *                               
   Version              : 1.0                                                                           *
   Created By           : Krishna                                                                       *
   Last Modified By     : Krishna                                                                       *
   Last Modified Date   : 02/02/2018                                                                    *
*********************************************************************************************************/


trigger EPMS_Update_CostPerday_Location on Location__c (after update) {

    Set<Id> locIds = trigger.newMap.keySet();
    
    system.debug('-----locIds----'+locIds);
    
    if(EPMS_CheckRecursive_Location_Update.runOnce()){
         system.debug('-----locIds run once ----'+locIds);
        try{
            for(id ids:locIds){
                Location__c location = [select id, Name, Standard_Regular_Cost__c, Photo_Artist_Standard_Regular_Cost__c, TL_Standard_Regular_Cost__c, QA_Standard_Regular_Cost__c from Location__c where id =: ids];
                Settings__c setting = [select Id, Name,Percentage_SRC_PA__c, Percentage_SRC_TL__c, Percentage_SRC_QC__c, Location__c from Settings__c where Location__c =: ids];
                system.debug('-----location before ----'+location);
                system.debug('-----setting----'+setting);
                if (setting != null) {
                    location.Photo_Artist_Standard_Regular_Cost__c = location.Standard_Regular_Cost__c*setting.Percentage_SRC_PA__c/100;
                    location.TL_Standard_Regular_Cost__c = location.Standard_Regular_Cost__c*setting.Percentage_SRC_TL__c/100;
                    location.QA_Standard_Regular_Cost__c = location.Standard_Regular_Cost__c*setting.Percentage_SRC_QC__c/100;
                    
                    system.debug('-----location before update ----'+location);
                    UPDATE location;
                }   
            }   
        } catch (Exception ex) {
            system.debug('Error in updating Reqular Cost for Photo Artist, QC and TL' + ex);
        }

        //send all the newly created or updated records ids one by one to the batch class
        system.debug('Before Batch Execute');
        for(id ids:locIds){   
            Database.executeBatch(new EPMS_batchToUpdateCostPerDayInMember (ids),100);
        }
        system.debug('After Batch Execute');
    }
}