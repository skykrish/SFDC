/**********************************************************************************
*   Class               :       EPMS_DelSettings_Trigger                           *
*   Created Date        :       13/04/2016                                         *           
*   Description         :       Trigger will throw error message while deleting 
                                the setting                                        *
**********************************************************************************/
trigger EPMS_DelSettings_Trigger on Settings__c (before delete) {
    if(trigger.isBefore){
        if(trigger.isDelete){
            for(Settings__c oldSetting : trigger.old){
            //deleting setting records 
                if(oldSetting.Name!=null && oldSetting.Location__c!=null ){
                    oldSetting.addError(Label.EPMS_MBO_You_Don_t_Have_Permission_to_delete_setting_records);
                }
            }
        }
        
    }
}