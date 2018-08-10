/**********************************************************************************
*   Class               :       clsTest_EPMS_Settings_Trigger                     *
*   Created Date        :       25/03/2016                                        *
*   Description         :       Test Class for EPMS_Settings_Trigger              *
**********************************************************************************/

@isTest
private class clsTest_EPMS_Settings_Trigger {
    static testMethod void testSetting() {
        
        Location__c loc= new Location__c();
        loc.Name='Test Location';
        loc.Location_Status__c='Active';
        loc.Location_Country__c='India';
        loc.Group_Name__c='TestgroupName';
        test.starttest();
        try{
            insert loc;
        }catch(Exception e){
            System.debug(e);
        }
        
        List<Settings__c> settingList= new List<Settings__c>();
        for(Integer i=0;i<10;i++){
            Settings__c setting = new Settings__c();
            setting.Name ='Test setting name'+i;
            setting.Location__c = loc.Id;
            settingList.add(setting);
        }
        
        try{
            insert settingList;
        }catch(Exception e){
            System.debug(e);
        }
        
        List<Settings__c> oldSetting = [select id from Settings__c where id!=null];
        try{
            delete oldSetting;
        }catch(Exception e){
            System.debug(e);
        }
        test.stoptest();
    }
}