/**********************************************************************************
*   Class               :       clsTest_EPMS_ShowPerformance                      *
*   Created Date        :       11/04/2016                                        *
*   Description         :       Test Class for EPMS_ShowPerformance               *
**********************************************************************************/
@isTest(seeAllData=true)
    public class clsTest_EPMS_ShowPerformance  {
    
           static testMethod void testperformance(){

            PageReference pageRef = Page.EPMS_ShowPerformance;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            
            User u = new User(Alias = 'standt', Email='sysadminexample@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='sysadminexample@mbo.in');
            
            insert u;
            
            system.runas(u){
            
                Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Shift_Location__r.Name = 'MBOI Phase-1' AND Name = '1st Shift - Phase 1'];
                //Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Name = '1st Shift - Phase-1' LIMIT 1];
                List<Member__c> memberlist =[SELECT Id, Name,Location_id__c, Team_Id__c FROM Member__c WHERE Location_id__r.Name ='MBOI Phase-1' AND Status__c ='Active'];
                
                Test.StartTest();                 
                
                Test.setCurrentPage(pageRef);                
                
                EPMS_ShowPerformance  performance=new EPMS_ShowPerformance ();
                //List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftList[0].Shift_Code__c AND ID=:shiftList[1].Shift_Code__c];
                //List<Team__c>Teams=[select Id,Name from Team__c where id=:shiftList[0].Team_Assignment_Id__c AND ID=:shiftList[1].Team_Assignment_Id__c];
                List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftInfo.Id];
                List<Team__c>Teams=[select Id,Name from Team__c where Location__r.Name ='MBOI Phase-1' ];
                performance.getListOfLocations();
                performance.selectedLocId=memberlist[0].Location_id__c;
                performance.teamNames=Teams;
                performance.shifts=shifts;
                performance.memberList=memberlist;
                performance.selectedShiftName=ShiftInfo.Id;
                performance.selectedTeamName=memberlist[0].Team_Id__c;
                performance.shiftCode=ShiftInfo.Id;
                performance.teamId=memberlist[0].Team_Id__c;
                performance.ListOfShifts();
                performance.ListOfTeams();
                performance.teamListOfMembers();
                performance.getPieData();
                Test.StopTest();
            }
                
    }
              
}