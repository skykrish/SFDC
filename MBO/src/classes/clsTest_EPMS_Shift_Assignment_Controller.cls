/**********************************************************************************
*   Class               :       clsTest_EPMS_Shift_Assignment_Controller          *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_Shift_Assignment_Controller   *
**********************************************************************************/
@isTest
public class clsTest_EPMS_Shift_Assignment_Controller {
    
        @testSetup static void setupTestData(){

            PageReference pageRef = Page.EPMS_Shift_Assignment;
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Production Administrator'];
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');

            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
            location.Location_Country__c='India';
            location.Location_Status__c ='active';
            location.Group_Name__c='INDIA PVT LTD -Phase2x2';
            insert location;            
           
            
            Location__c location2 = new Location__c();
            location2.Name = 'INDIA PRIVATE LIMITED - Phaseex3';
            location2.Location_Country__c='India';
            location2.Location_Status__c ='active';
            location2.Group_Name__c='INDIA PVT LTD -Phase2x3';
            insert location2;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='I';
            insert testRecord;
    
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='davidMoore@mbo.in';
            insert usermail;
            
            List<Team__c> teamlist = new List<Team__c>();
            Team__c team = new Team__c();
            team.Name='Team B';
            team.Location__c=location.id;             
            //insert team;
            teamlist.add(team);
            
            Team__c team2 = new Team__c();
            team2.Name='Team A';
            team2.Location__c=location.id;             
            //insert team2;
            teamlist.add(team2);
            
            Team__c team3 = new Team__c();
            team3.Name='Team C';
            team3.Location__c=location.id;             
            //insert team3;
            teamlist.add(team3);
            
            Team__c team4 = new Team__c();
            team4.Name='Team D';
            team4.Location__c=location.id;             
            //insert team4;
            teamlist.add(team4);
            
            if(teamlist.size() > 0){
                insert teamlist;
            }
            
            List<Member__c> memberlist = new List<Member__c>();
            
            Member__c member =new Member__c();
            member.Name='Vijayakumar';     
            member.Location_id__c=location.id;
            member.Last_Name__c='Vijayakumar';
            member.Email__c='vijayakumarp@gmail.com';
            member.Country__c='India';
            member.Designation__c='Team Leader';
            member.Status__c='Active';
            member.Team_Id__c = team.Id;
            //insert member; 
            memberlist.add(member);
            
            Member__c member2 =new Member__c();
            member2.Name='Ajith';     
            member2.Location_id__c=location.id;
            member2.Last_Name__c='Gopal';
            member2.Email__c='gopalajith@gmail.com';
            member2.Country__c='India';
            member2.Designation__c='Photo Artists';
            member2.Status__c='Active';
            member2.Team_Id__c = team.Id;
            //insert member2; 
            memberlist.add(member2);
            
            Member__c member3 =new Member__c();
            member3.Name='Dinesh';     
            member3.Location_id__c=location.id;
            member3.Last_Name__c='M';
            member3.Email__c='mdinesh@gmail.com';
            member3.Country__c='India';
            member3.Designation__c='Quality Control';
            member3.Status__c='Active';
            //insert member3; 
            memberlist.add(member3);
            
            Member__c member4 =new Member__c();
            member4.Name='Scott';     
            member4.Location_id__c=location.id;
            member4.Last_Name__c='Tiger';
            member4.Email__c='scotttiger@gmail.com';
            member4.Country__c='India';
            member4.Designation__c='Shift Administrator';
            member4.Status__c='Active';
            //insert member4; 
            memberlist.add(member4);
            
            Member__c member5 =new Member__c();
            member5.Name='Parker';     
            member5.Location_id__c=location.id;
            member5.Last_Name__c='Peter';
            member5.Email__c='peterparker@gmail.com';
            member5.Country__c='India';
            member5.Designation__c='Shift Administrator';
            member5.Status__c='Active';
            //insert member5; 
            memberlist.add(member5);
            
            
            
            Member__c member6 =new Member__c();
            member6.Name='Karan';     
            member6.Location_id__c=location.id;
            member6.Last_Name__c='Arjun';
            member6.Email__c='karanarjun@gmail.com';
            member6.Country__c='India';
            member6.Designation__c='Photo Artists';
            member6.Status__c='Active';
            member6.Team_Id__c = team2.Id;
            memberlist.add(member6);
            
            Member__c member7 =new Member__c();
            member7.Name='Marimuthu';     
            member7.Location_id__c=location.id;
            member7.Last_Name__c='K';
            member7.Email__c='kmarimuthu@gmail.com';
            member7.Country__c='India';
            member7.Designation__c='Quality Control';
            member7.Status__c='Active';
            //insert member7; 
            memberlist.add(member7);
            
            Member__c member8 =new Member__c();
            member8.Name='Anbarasan';     
            member8.Location_id__c=location.id;
            member8.Last_Name__c='Aravindhan';
            member8.Email__c='aanbu234@gmail.com';
            member8.Country__c='India';
            member8.Designation__c='Photo Artists';
            member8.Status__c='Active';
            member8.Team_Id__c = team3.Id;
            memberlist.add(member8);
            
            Member__c member9 =new Member__c();
            member9.Name='Gowtham';     
            member9.Location_id__c=location.id;
            member9.Last_Name__c='Jayachandran';
            member9.Email__c='gowthamJeyachandran@gmail.com';
            member9.Country__c='India';
            member9.Designation__c='Quality Control';
            member9.Status__c='Active';
            member9.Team_Id__c = team3.Id;
            //insert member7; 
            memberlist.add(member9);
            
            Member__c member10 =new Member__c();
            member10.Name='Butler';     
            member10.Location_id__c=location.id;
            member10.Last_Name__c='Jose';
            member10.Email__c='josebutler@gmail.com';
            member10.Country__c='India';
            member10.Designation__c='Team Leader';
            member10.Status__c='Active';
            member10.Team_Id__c = team3.Id;
            memberlist.add(member10);
            
            Member__c member11 =new Member__c();
            member11.Name='John';     
            member11.Location_id__c=location.id;
            member11.Last_Name__c='Harry';
            member11.Email__c='johnbutler@gmail.com';
            member11.Country__c='India';
            member11.Designation__c='Team Leader';
            member11.Status__c='Active';
            member11.Team_Id__c = team4.Id;
            memberlist.add(member11);
            
            Member__c member12 =new Member__c();
            member12.Name='Jenson';     
            member12.Location_id__c=location.id;
            member12.Last_Name__c='Button';
            member12.Email__c='jensonbutton@gmail.com';
            member12.Country__c='India';
            member12.Designation__c='Quality Control';
            member12.Status__c='Active';
            member12.Team_Id__c = team4.Id;
            memberlist.add(member12);
            
            Member__c member13 =new Member__c();
            member13.Name='Dwayne';     
            member13.Location_id__c=location.id;
            member13.Last_Name__c='Hills';
            member13.Email__c='dwaynehills@gmail.com';
            member13.Country__c='India';
            member13.Designation__c='Shift Administrator';
            member13.Status__c='Active';
            member13.Team_Id__c = team4.Id;
            //insert member5; 
            memberlist.add(member13);
            
            
            if(memberlist.size() > 0){
                insert memberlist;
            }
            
            Shift__c shift = new Shift__c();
            shift.Status__c='Active';
            shift.Name = 'testing Shift';
            shift.Shift_Location__c = location.Id;
            shift.Implements_From__c = system.now().addDays(3);
            shift.Shift_Start_Time__c = system.now();
            shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
            insert shift;
            
            
            Shift__c shiftA = new Shift__c();
            shiftA.Status__c='Active';
            shiftA.Name = 'testing Shift A';
            shiftA.Shift_Location__c = location.Id;
            shiftA.Implements_From__c = system.now().addDays(3);
            shiftA.Shift_Start_Time__c = system.now().addHours(10);
            shiftA.Shift_End_Time__c = shiftA.Shift_Start_Time__c.addHours(5);
            insert shiftA;
            
            
            Shift__c shift2 = new Shift__c();
            shift2.Status__c='Active';
            shift2.Name = 'testing Shift2';
            shift2.Shift_Location__c = location2.Id;
            shift2.Implements_From__c = system.now().addDays(5);
            shift2.Shift_Start_Time__c = system.now();
            shift2.Shift_End_Time__c = shift2.Shift_Start_Time__c.addHours(5);
            insert shift2;
            
            List<Shift_Assignments__c> shiftList = new List<Shift_Assignments__c>();
            
            Shift_Assignments__c shiftass1=new Shift_Assignments__c();
            shiftass1.Shift_Code__c=shiftA.id;
            shiftass1.Member__c=member11.id;
            shiftass1.Location__c=location.id;
            shiftass1.FromTime__c=system.today();
            shiftass1.Shift_Assigned__c=true;
            shiftass1.Team_Assignment_Id__c = team4.Name;
            //insert shiftass1;
            shiftList.add(shiftass1);
            
            Shift_Assignments__c shiftass2=new Shift_Assignments__c();
            shiftass2.Shift_Code__c=shiftA.id;
            shiftass2.Member__c=member12.id;
            shiftass2.Location__c=location.id;
            shiftass2.FromTime__c=system.today();
            shiftass2.Shift_Assigned__c=true;
            shiftass2.Team_Assignment_Id__c = team4.Name;
            //insert shiftass1;
            shiftList.add(shiftass2);

            Shift_Assignments__c shiftass3=new Shift_Assignments__c();
            shiftass3.Shift_Code__c=shiftA.id;
            shiftass3.Member__c=member13.id;
            shiftass3.Location__c=location.id;
            shiftass3.FromTime__c=system.today();
            shiftass3.Shift_Assigned__c=true;
            shiftass3.Team_Assignment_Id__c = team4.Name;
            //insert shiftass1;
            shiftList.add(shiftass3);
            
            if(shiftList.size() > 0){
                insert shiftList;
            }
            
        }
        
        
        static testMethod void testMemberShiftAssignment() {
            
            PageReference pageRef = Page.EPMS_Shift_Assignment;
            Test.setCurrentPage(pageRef);
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Member__c member4 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger']; 
            Test.StartTest();     

            // CASE 1 - Add team member to shift using shift Assignment
            EPMS_Shift_Assignment_Controller newShiftAssignObj = new EPMS_Shift_Assignment_Controller();
            newShiftAssignObj.getLocations();
            newShiftAssignObj.getShifts();
            newShiftAssignObj.getTeams();
            newShiftAssignObj.getAssignmentType();
            newShiftAssignObj.getMemberNotInTeam();
            newShiftAssignObj.getMemberNotInTeamHaveAssignments();
            newShiftAssignObj.selectValue = location.Id;
            newShiftAssignObj.CurrentShifts = shift.Id;
            newShiftAssignObj.getAllShiftAdministrators();
            newShiftAssignObj.shiftAdministrator = member4.Id;
            newShiftAssignObj.assignType = 'Available';
            newShiftAssignObj.getallContacts();
            newShiftAssignObj.selectedContacts = newShiftAssignObj.allContacts;
            newShiftAssignObj.save();
            Test.stopTest();
        }
        
         static testMethod void testMemberShiftAssignment2() {
            
            PageReference pageRef = Page.EPMS_Shift_Assignment;
            Test.setCurrentPage(pageRef);
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Member__c member4 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger'];  
            Test.startTest();
            // CASE 2 - Change the same to other shift
            EPMS_Shift_Assignment_Controller newShiftAssignObj2 = new EPMS_Shift_Assignment_Controller();
            newShiftAssignObj2.getLocations();
            newShiftAssignObj2.getShifts();
            newShiftAssignObj2.getTeams();
            newShiftAssignObj2.getAssignmentType();
            newShiftAssignObj2.getMemberNotInTeam();
            newShiftAssignObj2.getMemberNotInTeamHaveAssignments();
            newShiftAssignObj2.selectValue = location.Id;
            newShiftAssignObj2.CurrentShifts = shift.Id;
            newShiftAssignObj2.getAllShiftAdministrators();
            newShiftAssignObj2.shiftAdministrator = member4.Id;
            newShiftAssignObj2.assignType = 'Available';
            newShiftAssignObj2.getallContacts();
            newShiftAssignObj2.selectedContacts = newShiftAssignObj2.allContacts;
          
            newShiftAssignObj2.ShowPanel();
            newShiftAssignObj2.getlocation();
            newShiftAssignObj2.Cancel();
            Test.stopTest();
        }
        
        static testMethod void testMemberShiftAssignment3() {
            Integer MAX_QUERY = Limits.getLimitQueries(); 
            Integer NUM_QUERY = MAX_QUERY - 1; 
            
            PageReference pageRef = Page.EPMS_Shift_Assignment;
            Test.setCurrentPage(pageRef);
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Test.startTest();
             // CASE 3 - Change the same to other shift (Negative Scenario)
            EPMS_Shift_Assignment_Controller newShiftAssignObj3 = new EPMS_Shift_Assignment_Controller();
            newShiftAssignObj3.selectValue = location.Id;
            newShiftAssignObj3.CurrentShifts = null;
            newShiftAssignObj3.save();
            //Test.stopTest();
            
            //Test.startTest();
           
            // CASE 4 - Change the same to other shift
            EPMS_Shift_Assignment_Controller newShiftAssignObj4 = new EPMS_Shift_Assignment_Controller();
            newShiftAssignObj4.selectValue = null;
            newShiftAssignObj4.CurrentShifts = null;
            newShiftAssignObj4.save();
            Test.stopTest();
        }     
        
        static testMethod void testMemberShiftAssignment4() {
            
            PageReference pageRef = Page.EPMS_Shift_Assignment;
            Test.setCurrentPage(pageRef);
          
            String type = 'order';
            pageRef.getParameters().put('type',type);
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Member__c member5 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Peter'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Team B'];
            Test.startTest();
            EPMS_Shift_Assignment_Controller newShiftAssignObj5 = new EPMS_Shift_Assignment_Controller();         
            newShiftAssignObj5.getAssignmentType();
            newShiftAssignObj5.selectValue = location.Id;
            newShiftAssignObj5.CurrentShifts = shift.Id;
            newShiftAssignObj5.getMemberNotInTeam();
            newShiftAssignObj5.getMemberNotInTeamHaveAssignments();
            newShiftAssignObj5.shiftAdministrator = member5.Id;
            newShiftAssignObj5.assignType = 'All';
            newShiftAssignObj5.getallContacts();
            newShiftAssignObj5.selectedContacts = newShiftAssignObj5.allContacts;
            newShiftAssignObj5.setCurrentTeams(team.Id);
            newShiftAssignObj5.setCurrentShifts(shift.Id);
            newShiftAssignObj5.setAssignType('All');
            newShiftAssignObj5.setAlertMessage('Testing');
            newShiftAssignObj5.settemploca(location.Id);
            newShiftAssignObj5.getCurrentTeams();
            newShiftAssignObj5.getCurrentShifts();
            newShiftAssignObj5.getAssignType();
            newShiftAssignObj5.getAlertMessage();
            Test.stopTest();
        } 
        
        static testMethod void testMemberShiftAssignment5() {
            
            PageReference pageRef = Page.EPMS_Shift_Assignment;
            Test.setCurrentPage(pageRef);
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
           
            Test.startTest();
            EPMS_Shift_Assignment_Controller pronewShiftAssignObj = new EPMS_Shift_Assignment_Controller();
          
            pronewShiftAssignObj.selectValue = location.Id;
            pronewShiftAssignObj.CurrentShifts = shift.Id;
            pronewShiftAssignObj.getMemberNotInTeam();
            
            pronewShiftAssignObj.selectedTeamMembers = pronewShiftAssignObj.availableTeamMembers;
            pronewShiftAssignObj.save_new();
            Test.stopTest();
        }
           
        static testMethod void testMemberShiftAssignment6() {   
           
            PageReference pageRef = Page.EPMS_Shift_Assignment;
            Test.setCurrentPage(pageRef);
           Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
           Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
          
           Test.startTest();
           EPMS_Shift_Assignment_Controller newShiftAssignObj6 = new EPMS_Shift_Assignment_Controller();
           newShiftAssignObj6.selectValue = location.Id;
           newShiftAssignObj6.CurrentShifts = shift.Id;
           newShiftAssignObj6.save();
             
          
           Test.stopTest();
        }
        
        static testMethod void testMemberShiftAssignment7(){

           PageReference pageRef = Page.EPMS_Shift_Assignment;
           Test.setCurrentPage(pageRef);
           Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
           Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift A'];
           Member__c member5 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Peter'];  
           Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Team B'];
           Test.startTest();
           EPMS_Shift_Assignment_Controller newShiftAssignObj7 = new EPMS_Shift_Assignment_Controller();
           newShiftAssignObj7.selectValue = location.Id;
           newShiftAssignObj7.CurrentShifts = shift.Id;
           newShiftAssignObj7.assignType = 'All';
           newShiftAssignObj7.getallContacts();
           newShiftAssignObj7.shiftAdministrator = member5.Id;
           newShiftAssignObj7.selectedContacts = newShiftAssignObj7.allContacts;
           newShiftAssignObj7.save();
            
            
        }
        
        static testmethod void testMemberShiftAssignment8(){
            
            PageReference pageref = page.EPMS_Shift_Assignment;
            Test.setCurrentPage(pageref);
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift2'];
            Member__c member5 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Peter'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Team C'];
            Test.startTest();
            EPMS_Shift_Assignment_Controller newShiftAssignObj8 = new EPMS_Shift_Assignment_Controller();
            newShiftAssignObj8.selectValue = location.Id;
            newShiftAssignObj8.CurrentShifts = shift.Id;
            newShiftAssignObj8.assignType = 'All';
            newShiftAssignObj8.getallContacts();
            newShiftAssignObj8.shiftAdministrator = member5.Id;
            newShiftAssignObj8.selectedContacts = newShiftAssignObj8.allContacts;
            newShiftAssignObj8.save();
            EPMS_Shift_Assignment_Controller newShiftAssignObj8_v1 = new EPMS_Shift_Assignment_Controller();
            newShiftAssignObj8_v1.save_new();
            EPMS_Shift_Assignment_Controller newShiftAssignObj8_v2 = new EPMS_Shift_Assignment_Controller();
            newShiftAssignObj8_v2.selectValue = location.Id;
            newShiftAssignObj8_v2.save_new();
            EPMS_Shift_Assignment_Controller newShiftAssignObj8_v3 = new EPMS_Shift_Assignment_Controller();
            newShiftAssignObj8_v2.selectValue = location.Id;
            newShiftAssignObj8_v2.CurrentShifts = shift.Id;
            newShiftAssignObj8_v2.save_new();
            
            EPMS_Shift_Assignment_Controller newShiftAssignObj8_v4 = new EPMS_Shift_Assignment_Controller();
            /*newShiftAssignObj8_v4.selectValue = location.Id;
            newShiftAssignObj8_v4.CurrentShifts = shift.Id;
            newShiftAssignObj8_v4.shiftAdministrator = member5.Id;
            newShiftAssignObj8_v4.assignType = 'Available';
            newShiftAssignObj8_v4.getallContacts();
            newShiftAssignObj8_v4.selectedContacts = newShiftAssignObj8.allContacts;
            newShiftAssignObj8_v4.save();*/
            
            newShiftAssignObj8.selectValue = location.Id;
            newShiftAssignObj8.CurrentShifts = shift.Id;
            newShiftAssignObj8.shiftAdministrator = member5.Id;
            newShiftAssignObj8.assignType = 'Available';
            newShiftAssignObj8.getallContacts();
            system.debug('NNNNN EEEEEEE WWWWWWW TEAMS ARE ::: ' + newShiftAssignObj8.allContacts);
            newShiftAssignObj8.selectedContacts = newShiftAssignObj8.allContacts;
            newShiftAssignObj8.save();
            
            Test.stopTest();
            
            
        }
        
        
        static testmethod void testMemberShiftAssignment9(){
            
            PageReference pageref = page.EPMS_Shift_Assignment;
            Test.setCurrentPage(pageref);
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift2'];
            Member__c member4 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger']; 
            
            Test.startTest();
            // CASE 1 - Add team member to shift using shift Assignment
            EPMS_Shift_Assignment_Controller newShiftAssignObj = new EPMS_Shift_Assignment_Controller();
            newShiftAssignObj.getLocations();
            newShiftAssignObj.getShifts();
            newShiftAssignObj.getTeams();
            newShiftAssignObj.getAssignmentType();
            newShiftAssignObj.getMemberNotInTeam();
            newShiftAssignObj.getMemberNotInTeamHaveAssignments();
            newShiftAssignObj.selectValue = location.Id;
            newShiftAssignObj.CurrentShifts = shift.Id;
            newShiftAssignObj.getAllShiftAdministrators();
            newShiftAssignObj.shiftAdministrator = member4.Id;
            newShiftAssignObj.assignType = 'Available';
            newShiftAssignObj.getallContacts();
            newShiftAssignObj.selectedContacts = newShiftAssignObj.allContacts;
            newShiftAssignObj.save();
            EPMS_Shift_Assignment_Service_New shiftService = new EPMS_Shift_Assignment_Service_New();
            shiftService.getAvailableTeamsInLocation(location.Id);
            shiftService.getAssignedTeamForOtherShift(location.Id);
            shiftService.getAllShiftAdministrator(location.Id);
            shiftService.getAllTeamList(location.Id);
            shiftService.getMemberNotInTeam(location.Id);
            
            shiftService.getAssignedShiftAdminForShift(shift.Id);
            shiftService.getAssignedTeamForSelectedShift(location.Id, shift.Id);
            shiftService.getMemberNotInTeamHaveShiftAssignments(location.Id, shift.Id);
            shiftService.getAssignedShiftAdministratorInSelectedShift(location.Id, shift.Id);
            shiftService.getAllTeamsInLocation(location.Id, shift.Id);
            shiftService.getMember();
            shiftService.getAllMemberInLocation();
            
            Test.stopTest();
            
            
        }
        
        static testmethod void testMemberShiftAssignment10(){
            
            PageReference pageref = page.EPMS_Shift_Assignment;
            Test.setCurrentPage(pageref);   
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Member__c member5 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Peter'];  
            Member__c member4 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger'];
            Member__c member3 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='M'];
            Member__c member2 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Gopal'];
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Team C'];
            Team__c teamb = [SELECT Id, Name FROM Team__c WHERE Name='Team B'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift2'];
            Set<Id> memberIds = new Set<Id>();
            Set<Id> teamIds = new Set<Id>();
            
            if(member5 !=null){
                memberIds.add(member5.Id);
            }
            if(member4 !=null){
                memberIds.add(member4.Id);
            }
            if(member3 !=null){
                memberIds.add(member3.Id);
            }
            if(member2 !=null){
                memberIds.add(member2.Id);
            }
            
            if(team !=null){
                teamIds.add(team.Id);
            }
            if(teamb !=null){
                teamIds.add(teamb.Id);
            }
            
            Test.startTest();
            // CASE 1 - Add team member to shift using shift Assignment
            EPMS_Shift_Assignment_Controller newShiftAssignObj = new EPMS_Shift_Assignment_Controller();
            newShiftAssignObj.getLocations();
            newShiftAssignObj.getShifts();
            newShiftAssignObj.getTeams();
            newShiftAssignObj.getAssignmentType();
            newShiftAssignObj.getMemberNotInTeam();
            newShiftAssignObj.getMemberNotInTeamHaveAssignments();
            newShiftAssignObj.selectValue = location.Id;
            newShiftAssignObj.CurrentShifts = shift.Id;
            newShiftAssignObj.getAllShiftAdministrators();
            newShiftAssignObj.shiftAdministrator = member4.Id;
            newShiftAssignObj.assignType = 'Available';
            newShiftAssignObj.getallContacts();
            newShiftAssignObj.selectedContacts = newShiftAssignObj.allContacts;
            newShiftAssignObj.save();
            EPMS_Shift_Assignment_Service_New shiftService2 = new EPMS_Shift_Assignment_Service_New();
            
            shiftService2.getShiftAdminMemberInfo(member5.Id);
            shiftService2.getTeamAssignmentForAssignedTeam(member5.Id);
            shiftService2.getShiftOnlyAssignmentForAssignedTeam(member5.Id);
            shiftService2.getOtherShiftAdminAssignmentForSelectedShift(member5.Id);

            shiftService2.getShiftAssignmentforTeamMember(location.Id, memberIds);
            shiftService2.getShiftOnlyAssignmentForAssignedTeamMembers(memberIds);
            shiftService2.getUnAssignedTeamMembersInfo(memberIds);

            shiftService2.getAssignedMemberForTeam(location.Id, teamIds);
            shiftService2.getOtherTeamShiftAdminAssignmentForSelectedShift(team.Id);
            shiftService2.getAssignedMemberForTeamMemberCount(location.Id, teamIds);
            shiftService2.getMemberInLocation();
            shiftService2.getAllLocations();
            shiftService2.getLocations();
            
            EPMS_Shift_Assignment_Query_Locator queryLocator = new EPMS_Shift_Assignment_Query_Locator();
            String fromDate = String.valueOf(system.today());
            String toTime = String.valueOf(system.today()+3);
            queryLocator.getUnAssignedMemberForTeam(location.Id, fromDate, toTime);
            queryLocator.getAllMemberForTeam(location.Id);
            queryLocator.getUnAssignedShiftAdministrator(location.Id);
            queryLocator.getShiftAssignmentforShift(location.Id, memberIds, shift.Id);
            queryLocator.getAssignedTeamForSelectedShift(location.Id, shift.Id);
            queryLocator.getTeamAssignedForSelectShiftAdmin(location.Id, member5.Id);
            queryLocator.getTeamAssignmentForSelectShiftAdmin(location.Id, member5.Id);
            queryLocator.getAssignedMemberForTeam2(location.Id, teamIds);

            Test.stopTest();
            
            
        }
        
        
        
        
        
        
    }