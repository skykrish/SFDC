/**********************************************************************************
*   Class               :       clsTest_EPMS_ShowPerformance                      *
*   Created Date        :       11/04/2016                                        *
*   Description         :       Test Class for EPMS_ShowPerformance               *
**********************************************************************************/
@isTest(seeAllData=true)
    public class clsTest_EPMS_ShowPerformance_v2  {
    
           static testMethod void testperformance(){

            PageReference pageRef = Page.EPMS_ShowPerformance;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            
            User u = new User(Alias = 'standt', Email='sysadminexample@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='sysadminexample@mbo.in');
            
            insert u;
            Map<Integer,String> teamIds = new Map<Integer,String>();
            system.runas(u){
                // Name of the Production Location - Shift
                Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Shift_Location__r.Name = 'MBOI Phase-1' AND Name = '1st Shift - Phase 1'];
                // Name of the Sandbox Full Location - Shift
                //Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Name = '1st Shift - Phase-1' LIMIT 1];
                List<Member__c> memberlist =[SELECT Id, Name,Location_id__c, Team_Id__c,Team_Id__r.Name FROM Member__c WHERE Location_id__r.Name ='MBOI Phase-1' AND Status__c ='Active'];
                String selectedTeamId = null;
                if(memberlist != null && memberlist.size() > 0){
                    integer i = 0;
                    integer j = 0;
                    for(Member__c memberDisp : memberlist){
                        system.debug('Count : ' + i + 'Member Info Details : ' + memberDisp.Name + ' Team Id : ' + memberDisp.Team_Id__c);
                        i++;
                        if(memberDisp.Team_Id__c != null){

                            selectedTeamId = memberDisp.Team_Id__c;
                            //break;
                            teamIds.put(j,memberDisp.Team_Id__c);
                            j++;
                        }
                    }
                }
                

                //List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftList[0].Shift_Code__c AND ID=:shiftList[1].Shift_Code__c];
                //List<Team__c>Teams=[select Id,Name from Team__c where id=:shiftList[0].Team_Assignment_Id__c AND ID=:shiftList[1].Team_Assignment_Id__c];
                List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftInfo.Id];
                List<Team__c>Teams=[select Id,Name from Team__c where Location__r.Name ='MBOI Phase-1' ];
                Test.StartTest();                 
                
                Test.setCurrentPage(pageRef);                
                
                //EPMS_ShowPerformance_v2  performance=new EPMS_ShowPerformance_v2();
                EPMS_ShowPerformance  performance=new EPMS_ShowPerformance();
                performance.getListOfLocations();
                performance.selectedLocId=memberlist[0].Location_id__c;
                performance.teamNames=Teams;
                performance.shifts=shifts;
                performance.memberList=memberlist;
                performance.selectedShiftName=ShiftInfo.Id;
                performance.selectedTeamName=memberlist[0].Team_Id__c;
                performance.shiftCode=ShiftInfo.Id;
                performance.teamId=selectedTeamId; //memberlist[0].Team_Id__c
                performance.ListOfShifts();
                performance.ListOfTeams();
                performance.teamListOfMembers();
                performance.getPieData();
                performance.search();
               
                // Setting time frame for all the class;
                String dt = '06/05/2016 11:23 AM';
                Datetime newDt = Datetime.parse(dt);
                //performance.fromDate = Datetime.newInstance(2016, 06, 05, 14, 23, 00);
               
                performance.fromDate = Datetime.newInstance(2016, 06, 05, 14, 23, 00);
                performance.ToDate = null;
                performance.shiftCode=null; // ShiftInfo.Id;
                performance.teamId=null; // memberlist[0].Team_Id__c;
                performance.search();
                Test.StopTest();
                
                }
              }
                
   static testMethod void testperformance2(){     
                PageReference pageRef = Page.EPMS_ShowPerformance;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            
            User u = new User(Alias = 'standt', Email='sysadminexample@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='sysadminexample@mbo.in');
            
            insert u;
            Map<Integer,String> teamIds = new Map<Integer,String>();
            
                // Case 2 : Display shift member will call by from date and to date
                system.runas(u){
                // Name of the Production Location - Shift
                Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Shift_Location__r.Name = 'MBOI Phase-1' AND Name = '1st Shift - Phase 1'];
                // Name of the Sandbox Full Location - Shift
                //Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Name = '1st Shift - Phase-1' LIMIT 1];
                List<Member__c> memberlist =[SELECT Id, Name,Location_id__c, Team_Id__c,Team_Id__r.Name FROM Member__c WHERE Location_id__r.Name ='MBOI Phase-1' AND Status__c ='Active'];
                String selectedTeamId = null;
                if(memberlist != null && memberlist.size() > 0){
                    integer i = 0;
                    integer j = 0;
                    for(Member__c memberDisp : memberlist){
                        system.debug('Count : ' + i + 'Member Info Details : ' + memberDisp.Name + ' Team Id : ' + memberDisp.Team_Id__c);
                        i++;
                        if(memberDisp.Team_Id__c != null){

                            selectedTeamId = memberDisp.Team_Id__c;
                            //break;
                            teamIds.put(j,memberDisp.Team_Id__c);
                            j++;
                        }
                    }
                }
                

                //List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftList[0].Shift_Code__c AND ID=:shiftList[1].Shift_Code__c];
                //List<Team__c>Teams=[select Id,Name from Team__c where id=:shiftList[0].Team_Assignment_Id__c AND ID=:shiftList[1].Team_Assignment_Id__c];
                List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftInfo.Id];
                List<Team__c>Teams=[select Id,Name from Team__c where Location__r.Name ='MBOI Phase-1' ];
                
                Test.StartTest();                 
                
                Test.setCurrentPage(pageRef); 
                EPMS_ShowPerformance  performance2=new EPMS_ShowPerformance();
                performance2.selectedLocId=memberlist[0].Location_id__c;
                performance2.fromDate = Datetime.newInstance(2016, 06, 05, 14, 23, 00);
                performance2.ToDate = Datetime.newInstance(2016, 07, 10, 02, 14, 10);
                performance2.shiftCode= ShiftInfo.Id; // null;
                performance2.teamId=null; // memberlist[0].Team_Id__c;
                performance2.search();
                Test.StopTest();
                 }
              }
                // Case 3 : Display team member will call by from date and to date
      static testMethod void testperformance3(){  
      
           PageReference pageRef = Page.EPMS_ShowPerformance;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            
            User u = new User(Alias = 'standt', Email='sysadminexample@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='sysadminexample@mbo.in');
            
            insert u;
            Map<Integer,String> teamIds = new Map<Integer,String>();
            
              system.runas(u){
                // Name of the Production Location - Shift
                Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Shift_Location__r.Name = 'MBOI Phase-1' AND Name = '1st Shift - Phase 1'];
                // Name of the Sandbox Full Location - Shift
                //Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Name = '1st Shift - Phase-1' LIMIT 1];
                List<Member__c> memberlist =[SELECT Id, Name,Location_id__c, Team_Id__c,Team_Id__r.Name FROM Member__c WHERE Location_id__r.Name ='MBOI Phase-1' AND Status__c ='Active'];
                String selectedTeamId = null;
                if(memberlist != null && memberlist.size() > 0){
                    integer i = 0;
                    integer j = 0;
                    for(Member__c memberDisp : memberlist){
                        system.debug('Count : ' + i + 'Member Info Details : ' + memberDisp.Name + ' Team Id : ' + memberDisp.Team_Id__c);
                        i++;
                        if(memberDisp.Team_Id__c != null){

                            selectedTeamId = memberDisp.Team_Id__c;
                            //break;
                            teamIds.put(j,memberDisp.Team_Id__c);
                            j++;
                        }
                    }
                }
                

                //List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftList[0].Shift_Code__c AND ID=:shiftList[1].Shift_Code__c];
                //List<Team__c>Teams=[select Id,Name from Team__c where id=:shiftList[0].Team_Assignment_Id__c AND ID=:shiftList[1].Team_Assignment_Id__c];
                List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftInfo.Id];
                List<Team__c>Teams=[select Id,Name from Team__c where Location__r.Name ='MBOI Phase-1' ]; 
                Test.StartTest();                 
                
                Test.setCurrentPage(pageRef); 
                EPMS_ShowPerformance  performance3=new EPMS_ShowPerformance();
                performance3.selectedLocId=memberlist[0].Location_id__c;
                performance3.fromDate = Datetime.newInstance(2016, 06, 05, 14, 23, 00);
                performance3.ToDate = Datetime.newInstance(2016, 07, 10, 02, 14, 10);
                performance3.shiftCode= ShiftInfo.Id; // null;
                performance3.teamId=selectedTeamId; // null ; memberlist[1].Team_Id__c
                performance3.search();
                Test.StopTest();
                }
              }
              
          static testMethod void testperformance4(){   
          
               PageReference pageRef = Page.EPMS_ShowPerformance;
            
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
                
                User u = new User(Alias = 'standt', Email='sysadminexample@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='sysadminexample@mbo.in');
                
                insert u;
                Map<Integer,String> teamIds = new Map<Integer,String>();
            
          
              system.runas(u){
                // Name of the Production Location - Shift
                Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Shift_Location__r.Name = 'MBOI Phase-1' AND Name = '1st Shift - Phase 1'];
                // Name of the Sandbox Full Location - Shift
                //Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Name = '1st Shift - Phase-1' LIMIT 1];
                List<Member__c> memberlist =[SELECT Id, Name,Location_id__c, Team_Id__c,Team_Id__r.Name FROM Member__c WHERE Location_id__r.Name ='MBOI Phase-1' AND Status__c ='Active'];
                String selectedTeamId = null;
                if(memberlist != null && memberlist.size() > 0){
                    integer i = 0;
                    integer j = 0;
                    for(Member__c memberDisp : memberlist){
                        system.debug('Count : ' + i + 'Member Info Details : ' + memberDisp.Name + ' Team Id : ' + memberDisp.Team_Id__c);
                        i++;
                        if(memberDisp.Team_Id__c != null){

                            selectedTeamId = memberDisp.Team_Id__c;
                            //break;
                            teamIds.put(j,memberDisp.Team_Id__c);
                            j++;
                        }
                    }
                }
                

                //List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftList[0].Shift_Code__c AND ID=:shiftList[1].Shift_Code__c];
                //List<Team__c>Teams=[select Id,Name from Team__c where id=:shiftList[0].Team_Assignment_Id__c AND ID=:shiftList[1].Team_Assignment_Id__c];
                List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftInfo.Id];
                List<Team__c>Teams=[select Id,Name from Team__c where Location__r.Name ='MBOI Phase-1' ];
                
                // Case 4 : Display team member will call by from date is greater than to date
                Test.StartTest();                 
                
                Test.setCurrentPage(pageRef); 
                
                EPMS_ShowPerformance  performance4=new EPMS_ShowPerformance();
                performance4.selectedLocId=memberlist[0].Location_id__c;
                performance4.fromDate = Datetime.newInstance(2016, 07, 10, 02, 14, 10);
                performance4.ToDate = Datetime.newInstance(2016, 06, 05, 14, 23, 00);
                performance4.shiftCode= ShiftInfo.Id; // null;
                performance4.teamId=selectedTeamId; // null ; memberlist[1].Team_Id__c
                performance4.search();
                Test.StopTest();
                
                }
            }
            
             static testMethod void testperformance5(){
             
                PageReference pageRef = Page.EPMS_ShowPerformance;
            
                Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
                
                User u = new User(Alias = 'standt', Email='sysadminexample@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='sysadminexample@mbo.in');
                
                insert u;
                Map<Integer,String> teamIds = new Map<Integer,String>();
                
                 
                 system.runas(u){
                // Name of the Production Location - Shift
                Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Shift_Location__r.Name = 'MBOI Phase-1' AND Name = '1st Shift - Phase 1'];
                // Name of the Sandbox Full Location - Shift
                //Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Name = '1st Shift - Phase-1' LIMIT 1];
                List<Member__c> memberlist =[SELECT Id, Name,Location_id__c, Team_Id__c,Team_Id__r.Name FROM Member__c WHERE Location_id__r.Name ='MBOI Phase-1' AND Status__c ='Active'];
                String selectedTeamId = null;
                if(memberlist != null && memberlist.size() > 0){
                    integer i = 0;
                    integer j = 0;
                    for(Member__c memberDisp : memberlist){
                        system.debug('Count : ' + i + 'Member Info Details : ' + memberDisp.Name + ' Team Id : ' + memberDisp.Team_Id__c);
                        i++;
                        if(memberDisp.Team_Id__c != null){

                            selectedTeamId = memberDisp.Team_Id__c;
                            //break;
                            teamIds.put(j,memberDisp.Team_Id__c);
                            j++;
                        }
                    }
                }
                

                //List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftList[0].Shift_Code__c AND ID=:shiftList[1].Shift_Code__c];
                //List<Team__c>Teams=[select Id,Name from Team__c where id=:shiftList[0].Team_Assignment_Id__c AND ID=:shiftList[1].Team_Assignment_Id__c];
                List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftInfo.Id];
                List<Team__c>Teams=[select Id,Name from Team__c where Location__r.Name ='MBOI Phase-1' ];
             
                
                // Case 5 : Display team member will call by from date is greater than today date and to date is null
                Test.StartTest();                 
                
                Test.setCurrentPage(pageRef); 
                
                EPMS_ShowPerformance  performance5=new EPMS_ShowPerformance();
                performance5.selectedLocId=memberlist[0].Location_id__c;
                performance5.fromDate = Datetime.newInstance(2016, 09, 10, 02, 14, 10);
                performance5.ToDate = null;
                performance5.shiftCode= ShiftInfo.Id; // null;
                performance5.teamId=selectedTeamId; // null ; memberlist[1].Team_Id__c
                performance5.search();
                Test.StopTest();
                
                }
                
             }
             
                             // Case 6 : Display team member will call by from date and to date
     static testMethod void testperformance6(){   
            
            
             PageReference pageRef = Page.EPMS_ShowPerformance;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            
            User u = new User(Alias = 'standt', Email='sysadminexample@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='sysadminexample@mbo.in');
            
            insert u;
            Map<Integer,String> teamIds = new Map<Integer,String>();
                           
                system.runas(u){
                // Name of the Production Location - Shift
                Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Shift_Location__r.Name = 'MBOI Phase-1' AND Name = '1st Shift - Phase 1'];
                // Name of the Sandbox Full Location - Shift
                //Shift__c shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Name = '1st Shift - Phase-1' LIMIT 1];
                List<Member__c> memberlist =[SELECT Id, Name,Location_id__c, Team_Id__c,Team_Id__r.Name FROM Member__c WHERE Location_id__r.Name ='MBOI Phase-1' AND Status__c ='Active'];
                String selectedTeamId = null;
                if(memberlist != null && memberlist.size() > 0){
                    integer i = 0;
                    integer j = 0;
                    for(Member__c memberDisp : memberlist){
                        system.debug('Count : ' + i + 'Member Info Details : ' + memberDisp.Name + ' Team Id : ' + memberDisp.Team_Id__c);
                        i++;
                        if(memberDisp.Team_Id__c != null){

                            selectedTeamId = memberDisp.Team_Id__c;
                            //break;
                            teamIds.put(j,memberDisp.Team_Id__c);
                            j++;
                        }
                    }
                }
                

                //List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftList[0].Shift_Code__c AND ID=:shiftList[1].Shift_Code__c];
                //List<Team__c>Teams=[select Id,Name from Team__c where id=:shiftList[0].Team_Assignment_Id__c AND ID=:shiftList[1].Team_Assignment_Id__c];
                List<Shift__c>shifts=[select Id,Name from Shift__c where id=:shiftInfo.Id];
                List<Team__c>Teams=[select Id,Name from Team__c where Location__r.Name ='MBOI Phase-1' ];
                
                Test.StartTest();                 
                
                Test.setCurrentPage(pageRef); 
                EPMS_ShowPerformance  performance6=new EPMS_ShowPerformance();
                performance6.selectedLocId=memberlist[0].Location_id__c;
                performance6.fromDate = Datetime.newInstance(2016, 06, 05, 14, 23, 00);
                performance6.ToDate = Datetime.newInstance(2016, 07, 10, 02, 14, 10);
                performance6.shiftCode= ShiftInfo.Id; // null;
                for(integer k = 0; k < teamIds.size(); k++){
                    performance6.teamId=teamIds.get(k); // null ; memberlist[1].Team_Id__c
                    performance6.search();
                }
                
                
                performance6.getListOfOrders();
                performance6.getOrderDetails();
                performance6.orderName = '00572564';
                performance6.getOrderDetails();
                //performance.displayMemberBylocation();
                //performance.displayMemberByshift();
                //performance.displayMemberByTeam();
                Test.StopTest();
            }
            
    }
    
              
}