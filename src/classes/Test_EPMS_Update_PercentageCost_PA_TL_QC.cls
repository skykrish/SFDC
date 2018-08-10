/****************************************************************************************
*   Class Name             :       Test_EPMS_Update_PercentageCost_PA_TL_QC             *
*   Created Date           :       22/01/2018                                           *
*   Description            :       Test Class for EPMS_Update_PercentageCost_PA_TL_QC   *
****************************************************************************************/
@istest(seeAllData = true)
public class Test_EPMS_Update_PercentageCost_PA_TL_QC {
    
    static testMethod void Test_Percentage_CostPerDay() {
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        location.Standard_Regular_Cost__c = 6100;
        location.QA_Standard_Regular_Cost__c = 3000;
        insert location;
        
        Settings__c setting1 = new Settings__c();
        setting1.Name = 'Test1';
        setting1.Percentage_SRC_PA__c = 100;
        setting1.Location__c = location.id;
        insert setting1;
        
        Settings__c setting2 = new Settings__c();
        setting2.Name = 'Test2';
        setting2.Percentage_SRC_TL__c = 75;
        setting2.Location__c = location.id;
        insert setting2;
        
        Settings__c setting3 = new Settings__c();
        setting3.Name = 'Test3';
        setting3.Percentage_SRC_QC__c = 50;
        setting3.Location__c = location.id;
        insert setting3;                 
                    
        Decimal percentageCost = 0;
        list<Member__c> updateMemberField = new List<Member__c>();
        Location__c loc = [SELECT Id,Name,Standard_Regular_Cost__c, QA_Standard_Regular_Cost__c FROM Location__c where Location_Country__c = 'India' Limit 1];
        List<Settings__c> settingList = [SELECT Id,Name,Percentage_SRC_QC__c FROM Settings__c where Name in ('Test1', 'Test2', 'Test3') Limit 1];
        
        update settingList;
    }
}