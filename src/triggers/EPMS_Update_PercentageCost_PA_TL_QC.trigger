trigger EPMS_Update_PercentageCost_PA_TL_QC on Settings__c (after update) {

    List<Location__c> updateLocationList = new List<Location__c>();

        try{

            List<Settings__c> settingList = [select Id, Name,Percentage_SRC_PA__c, Percentage_SRC_TL__c, Percentage_SRC_QC__c, Location__c from Settings__c where id =: trigger.new];
            system.debug('settingList *************** : ' + settingList);
        
            for (Settings__c setting : settingList) {
                if (setting.Location__c != null) {                    
                    Location__c location = [select Id, Name, Standard_Regular_Cost__c, Photo_Artist_Standard_Regular_Cost__c, TL_Standard_Regular_Cost__c, QA_Standard_Regular_Cost__c from Location__c where Id=: setting.Location__c Limit 1];
                    
                    if (location != null && location.Standard_Regular_Cost__c != null) {
                        if (setting.Percentage_SRC_PA__c != null) {
                            location.Photo_Artist_Standard_Regular_Cost__c = location.Standard_Regular_Cost__c*setting.Percentage_SRC_PA__c/100;
                            system.debug('location.Photo_Artist_Standard_Regular_Cost__c *************** : ' + location.Photo_Artist_Standard_Regular_Cost__c);    
                        } 
                        
                        if (setting.Percentage_SRC_TL__c != null) {
                            location.TL_Standard_Regular_Cost__c = location.Standard_Regular_Cost__c*setting.Percentage_SRC_TL__c/100;
                            system.debug('location.TL_Standard_Regular_Cost__c *************** : ' + location.TL_Standard_Regular_Cost__c);    
                        } 

                        if (setting.Percentage_SRC_QC__c != null) {
                            location.QA_Standard_Regular_Cost__c = location.Standard_Regular_Cost__c*setting.Percentage_SRC_QC__c/100;
                            system.debug('location.QA_Standard_Regular_Cost__c *************** : ' + location.QA_Standard_Regular_Cost__c);    
                        } 
                    
                        updateLocationList.add(location);
                    }
                }
            
            }
            
            if (updateLocationList != null && updateLocationList.size() > 0) {
                system.debug('updateLocationList *********** : ' + updateLocationList);
                UPDATE updateLocationList;
            }
        } catch (Exception ex) {
            System.debug('Exception in updating Percentage Cost : ' + ex);
        }
   
 
 
    
}