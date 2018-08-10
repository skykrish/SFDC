/**********************************************************************************
*   Class               :       Test_EPMS_FileManager_SettingsTracker             *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_FileManager_SettingsTracker   *
**********************************************************************************/

@isTest(SeeAllData=true)
private class Test_EPMS_FileManager_SettingsTracker {
    static testMethod void fileSettingFM(){
        
        Test.startTest();
       
        Location__c[] location=[select id,Name from Location__c where Name='MBOI Phase-1' limit 1];
       // Settings__c setting=[select id,Name from Settings__c where Location__c=:location[0].Id limit 1];
        
        
        Member__c[] memberFM=[Select Location_Id__c,User_Id__c from Member__c where Designation__c='File Managers' and Location_Id__c=:location[0].Id];
        user userFM=[Select id from User where ID=:memberFM[0].User_Id__c limit 1];

        Member__c[] memberQA=[Select Location_Id__c,User_Id__c from Member__c where Designation__c='Quality Control' and Location_Id__c=:location[0].Id limit 1];
        user userQA=[Select id from User where ID=:memberQA[0].User_Id__c limit 1];
        
        System.runAs(userQA){
           
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/FileManager/settingTracker';
            req.addParameter('type','Tracker');
            req.addHeader('Content-Type', 'application/json');
            req.httpMethod = 'post';
            res.addHeader('Content-Type', 'application/json');
            RestContext.request = req;
            RestContext.response = res;
          
            try{
                 List<Settings__c> settingList = new list<settings__c>();
            settingList = EPMS_FileManager_SettingsTracker.getFileManagerDetails();
                 EPMS_FileManager_SettingsTracker.updateFiles(memberQA[0].id);
            }
            catch(Exception e){
                System.debug('----Inside catch---');
            }
        }
        System.runAs(userFM){
            
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/FileManager/settingTracker';
            req.addParameter('type','');
            req.addHeader('Content-Type', 'application/json');
            req.httpMethod = 'post';
            res.addHeader('Content-Type', 'application/json');
            RestContext.request = req;
            RestContext.response = res;
            
            try{
                 List<Settings__c> settingList = new list<settings__c>();
            settingList = EPMS_FileManager_SettingsTracker.getFileManagerDetails();
                 EPMS_FileManager_SettingsTracker.updateFiles(memberFM[0].id);
               
            }
            catch(Exception e){
                System.debug('----Inside catch---');
            }
        }     
        Test.stopTest();
    }
    static testMethod void fileSettingPA(){
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/FileManager/settingTracker';
        req.addParameter('type','Tracker');
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'post';
        res.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;
            
        try{
            List<Settings__c> settingList = new list<settings__c>();
            settingList = EPMS_FileManager_SettingsTracker.getFileManagerDetails();
        }
        catch(Exception e){
            System.debug('----Inside catch---');
        }
    }
}