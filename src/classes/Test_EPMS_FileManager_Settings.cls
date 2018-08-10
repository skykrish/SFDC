/**********************************************************************************
*   Class               :       Test_EPMS_FileManager_Settings                    *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_FileManager_Settings          *
**********************************************************************************/

@isTest(SeeAllData=true)
private class Test_EPMS_FileManager_Settings {
    static testMethod void fileSettingFM(){
        
        Test.startTest();      
        
         Location__c location=[select id,Name from Location__c where Name='MBOI Phase-1' limit 1];
       // Settings__c setting=[select id,Name from Settings__c where Location__c=:location.Id limit 1];
                
        Production_Order__c po = new Production_order__c();
        po.Name='00452358';
        po.mbo_location__c=location.id;
        po.FTP_Upload_Status__c=false;
        po.Production_Order_Status__c='Assigned';
        insert po;
        
        
        Production_Order__c po1 = new Production_order__c();
        po1.Name='00452359';
        po1.mbo_location__c=location.id;
        po1.FTP_Upload_Status__c=false;
         po1.Production_Order_Status__c='Assigned';
        insert po1;
                
            
        Member__c[] memberFM=[Select Location_Id__c,User_Id__c from Member__c where Designation__c='File Managers' and Location_Id__c=:location.Id];
        user userFM=[Select id from User where ID=:memberFM[0].User_Id__c limit 1];     
        System.runAs(userFM){

            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/FileManager/setting';
            req.addParameter('type','Tracker');
            req.addHeader('Content-Type', 'application/json');
            req.httpMethod = 'post';
            res.addHeader('Content-Type', 'application/json');
            RestContext.request = req;
            RestContext.response = res;

            try{
                list<settings__c> pot = new list<settings__c>();
                string productionordernames;
                List<EPMS_FileManager_Settings.WrapperClass> settingList =EPMS_FileManager_Settings.getFileManagerDetails();
            }
            catch(Exception e){
                System.debug('----Inside catch---');
            }
        }     
        Test.stopTest();
    }
    
      static testMethod void fileSettingFM123(){
        
        Test.startTest();      
        
        Location__c location=[select id,Name from Location__c where Name='MBOI Phase-1' limit 1];
       // Settings__c setting=[select id,Name from Settings__c where Location__c=:location.Id limit 1];
                
        Production_Order__c po = new Production_order__c();
        po.Name='00452358';
        po.mbo_location__c=location.id;
        po.FTP_Upload_Status__c=false;
           po.Production_Order_Status__c='Assigned';
        insert po;
        
        
        Production_Order__c po1 = new Production_order__c();
        po1.Name='00452359';
        po1.mbo_location__c=location.id;
        po1.FTP_Upload_Status__c=false;
           po1.Production_Order_Status__c='Assigned';
        insert po1;
                
            
        Member__c[] memberFM=[Select Location_Id__c,User_Id__c from Member__c where Designation__c='File Managers' and Location_Id__c=:location.Id];
        user userFM=[Select id from User where ID=:memberFM[0].User_Id__c limit 1];     
        System.runAs(userFM){

            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/FileManager/setting';
            req.addParameter('type','');
            req.addHeader('Content-Type', 'application/json');
            req.httpMethod = 'post';
            res.addHeader('Content-Type', 'application/json');
            RestContext.request = req;
            RestContext.response = res;

            try{
                list<settings__c> pot = new list<settings__c>();
                string productionordernames;
                List<EPMS_FileManager_Settings.WrapperClass> settingList =EPMS_FileManager_Settings.getFileManagerDetails();
            }
            catch(Exception e){
                System.debug('----Inside catch---');
            }
        }     
        Test.stopTest();
    }
    
    
   
}