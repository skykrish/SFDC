/****************************************************************************************
*   Class Name             :       Test_EPMS_RestAPIQueryLocator                        *
*   Created Date           :       24/01/2018                                           *
*   Description            :       Test Class for EPMS_RestAPIQueryLocator              *
****************************************************************************************/
@isTest
private class Test_EPMS_RestAPIQueryLocator {
    
    @testSetup static void setupTestData(){
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        location.Standard_Regular_Cost__c = 6100;
        location.QA_Standard_Regular_Cost__c = 3000;
        insert location;
        
        Settings__c setting = new Settings__c();
        setting.Name = 'Test1';
        setting.Percentage_SRC_PA__c = 100;
        setting.Location__c = location.id;
        insert setting;     
        
        Production_Order__c po1 = new Production_Order__c();
        po1.Name ='Test_PO1';
        po1.Production_Order_Status__c = 'New';
        po1.MBO_Location__c = location.Id;
        po1.FTP_Upload_Status__c = false;
        po1.FTP_Download_Status__c = false;
        insert po1;
        
        Production_Order__c po2 = new Production_Order__c();
        po2.Name ='Test_PO2';
        po2.Production_Order_Status__c = 'Uploaded';
        po2.MBO_Location__c = location.Id;
        po2.FTP_Download_Status__c = true;
        insert po2;
        
        Files__c file= new Files__c();
        file.Name ='Test_File';
        file.Production_Order__c =po1.id;
        file.Status__c ='New';
        file.File_Location__c=location.id;
        file.Current_Extension__c ='.jpg';
        insert file;       
        
    }
    
    static testMethod void Test_Get_Settings() {        
        
        Location__c loc = [SELECT Id,Name FROM Location__c where Location_Country__c = 'India' Limit 1];
        Settings__c setting = [SELECT Id,Name FROM Settings__c where Name = 'Test1' Limit 1];
        EPMS_RestAPIQueryLocator queryLoc = new EPMS_RestAPIQueryLocator();
        
        Test.StartTest();
        queryLoc.getSettings(setting.Id);
        Test.stopTest();
    }
    
    static testMethod void Test_Get_TrackerSettings() {        
        
        Location__c loc = [SELECT Id,Name FROM Location__c where Location_Country__c = 'India' Limit 1];
        Settings__c setting = [SELECT Id,Name FROM Settings__c where Name = 'Test1' Limit 1];
        
        EPMS_RestAPIQueryLocator queryLoc = new EPMS_RestAPIQueryLocator();
        
        Test.StartTest();
        queryLoc.getSettingsTracker(setting.Id);        
        Test.stopTest();
    } 
    static testMethod void Test_getDMSettings() {        
        
        Location__c loc = [SELECT Id,Name FROM Location__c where Location_Country__c = 'India' Limit 1];
        Settings__c setting = [SELECT Id,Name,location__c FROM Settings__c where Name = 'Test1' Limit 1];
        //location__c =:settingsID
        EPMS_RestAPIQueryLocator queryLoc = new EPMS_RestAPIQueryLocator();
        
        Test.StartTest();
        queryLoc.getDMSettings(setting.Id);        
        Test.stopTest();
    } 
    /* static testMethod void Test_getDMSettingsTracker() {        

Location__c loc = [SELECT Id,Name FROM Location__c where Location_Country__c = 'India' Limit 1];
Settings__c setting = [SELECT Id,Name,location__c FROM Settings__c where Name = 'Test1' Limit 1];
EPMS_RestAPIQueryLocator queryLoc = new EPMS_RestAPIQueryLocator();

Test.StartTest();
queryLoc.getDMSettingsTracker(setting.Id);        
Test.stopTest();
} */
    
    static testMethod void Test_Get_ProductionOrder_ForDownload() {        
        Set<String> ponumber = new Set<String>();
        Production_Order__c po = [SELECT Id,Name FROM Production_Order__c where Name = 'Test_PO1' Limit 1];
        EPMS_RestAPIQueryLocator queryLoc = new EPMS_RestAPIQueryLocator();
        
        Test.StartTest();
        ponumber.add(po.Id);
        queryLoc.getProductionOrder_ForDownload(ponumber);        
        Test.stopTest();
    }    
    
    static testMethod void Test_Get_ProductionOrder_Forupload() {
        
        Set<String> ponumber = new Set<String>();
        Production_Order__c po = [SELECT Id, Name FROM Production_Order__c where Name = 'Test_PO2' Limit 1];
        EPMS_RestAPIQueryLocator queryLoc = new EPMS_RestAPIQueryLocator();
        
        Test.StartTest();
        ponumber.add(po.Id);
        queryLoc.getProductionOrder_Forupload(ponumber);        
        Test.stopTest();
    }
    
    static testMethod void Test_fetchFileDetailsForUpdate() {        
        
        Files__c file = [SELECT Id, Name FROM Files__c where Name = 'Test_File' Limit 1];
        EPMS_RestAPIQueryLocator queryLoc = new EPMS_RestAPIQueryLocator();
        
        Test.StartTest();
        queryLoc.fetchFileDetailsForUpdate(file.Id);        
        Test.stopTest();
    }
    
    static testMethod void Test_Get_Settings_Error() {
        
        EPMS_RestAPIQueryLocator queryLoc = new EPMS_RestAPIQueryLocator();
        Files__c file = [SELECT Id, Name FROM Files__c where Name = 'Test_File' Limit 1];       
        Test.StartTest();
        queryLoc.getSettings(file.Id);
        Test.stopTest();
    }
    
    static testMethod void Test_Get_TrackerSettings_Error() {
        
        EPMS_RestAPIQueryLocator queryLoc = new EPMS_RestAPIQueryLocator();
        Files__c file = [SELECT Id, Name FROM Files__c where Name = 'Test_File' Limit 1];       
        Test.StartTest();
        queryLoc.getSettingsTracker(file.Id);
        Test.stopTest();
    }
    
    static testMethod void Test_Get_ProductionOrder_ForDownload_Error() {        
        EPMS_RestAPIQueryLocator queryLoc = new EPMS_RestAPIQueryLocator();
        Set<String> pono = new Set<String>();
        
        Test.StartTest();
        pono.add('123');
        queryLoc.getProductionOrder_ForDownload(pono);        
        Test.stopTest();
    }    
    
    static testMethod void Test_Get_ProductionOrder_Forupload_Error() {
        EPMS_RestAPIQueryLocator queryLoc = new EPMS_RestAPIQueryLocator();
        Set<String> pono = new Set<String>();
        
        Test.StartTest();
        pono.add('123');
        queryLoc.getProductionOrder_Forupload(pono);
        Test.stopTest();
    }
    
    static testMethod void Test_fetchFileDetailsForUpdate_Error() {        
        EPMS_RestAPIQueryLocator queryLoc = new EPMS_RestAPIQueryLocator();
        Test.StartTest();
        queryLoc.fetchFileDetailsForUpdate('123');        
        Test.stopTest();
    }
    
    static testMethod void Test_getOrder_ForTransfer() {        
        EPMS_RestAPIQueryLocator queryLoc = new EPMS_RestAPIQueryLocator();
        Test.StartTest();
        queryLoc.getOrder_ForTransfer();        
        Test.stopTest();
    } 
    
}