/**********************************************************************************
*   Class               :       Test_EPMS_ChangeFileQCController                  *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_ChangeFileQCController        *
**********************************************************************************/


@isTest
public class Test_EPMS_ChangeFileQCController {

    @testSetup static void setupTestData(){
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PRIVATE LIMITED - Phaseex2';
        insert location;            
       
        
        Location__c location2 = new Location__c();
        location2.Name = 'INDIA PRIVATE LIMITED - Phaseex3';
        location2.Location_Country__c='India';
        location2.Location_Status__c ='active';
        location2.Group_Name__c='INDIA PRIVATE LIMITED - Phaseex3';
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
            
            if(memberlist.size() > 0){
                insert memberlist;
            }
            
           
            Shift__c shift2 = new Shift__c();
            shift2.Status__c='Active';
            shift2.Name = 'testing Shift2';
            shift2.Shift_Location__c = location2.Id;
            shift2.Implements_From__c = system.now().addDays(5);
            shift2.Shift_Start_Time__c = system.now();
            shift2.Shift_End_Time__c = shift2.Shift_Start_Time__c.addHours(5);
            insert shift2;
            

  }

    static testmethod void test_EPMS_ChangeFileQCController()
    {
        Profile profile = [select id from Profile where Name ='system administrator']; 
        User user = new User();
        user.FirstName ='test';
        user.LastName ='data';
        user.Alias ='cust'; 
        user.Username ='testuser@mbo.com';
        user.Email='test@gmail.com';
        user.ProfileId  = profile.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        insert user;
        
        system.runAs(user){ 

            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='I';
            insert testRecord;
            
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='davidMoore@mbo.in';
            insert usermail;
             
            Location__c location = new Location__c();
            location.Name ='Media BackOffice Test';
            location.Location_Country__c='india';
            location.Location_Status__c='Active';
            location.Group_Name__c='Media Backoffice Test';
            insert location;
            
            Shift__c shift = new Shift__c();
            shift.Status__c='Active';
            shift.Name = 'testing Shift';
            shift.Shift_Location__c = location.Id;
            shift.Implements_From__c = system.now().addDays(3);
            shift.Shift_Start_Time__c = system.now();
            shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
            insert shift; 
                
            Team__c team = new Team__c();
            team.Name='Testing Name';
            team.Location__c=location.id;             
            insert team;
            
            Test.StartTest();
                
            Member__c Member = new Member__c();
            Member.Name='testname';
            Member.Location_id__c=location.id;            
            Member.Designation__c='Quality Control';
            member.Email__c='testQC@gmail.com';
            member.country__C='India';
            member.Team_id__C=team.id;
            member.First_Name__c='Subbu';
            member.Last_Name__c='QC TEST';
            insert Member;
            
           
                
            Shift_Assignments__c shiftass=new Shift_Assignments__c();
            shiftass.Shift_Code__c=shift.id;
            shiftass.Member__c=Member.id;
            shiftass.Location__c=location.id;
            shiftass.FromTime__c=system.today();
            shiftass.Shift_Assigned__c=true;
            insert shiftass;
               
            production_order__c po = new production_order__C();
            po.Name='test order1';
            po.Production_Order_Status__c='New';
            po.Mbo_Location__c =location.id;
            po.QC_Incharge__c=member.Id;
            insert po;
            
            String poids=po.id;
           
            Files__c file = new Files__c();
            file.Production_Order__c=po.id;
            file.Name='TestFA';
            file.Status__c='New';
            file.Member__c=member.Id; 
            file.File_Type__c='Image'; 
            file.File_Location__c= po.Mbo_Location__c;         
            file.Current_Extension__c='.jpg';
            insert file;
            
            Apexpages.StandardController sc = new Apexpages.standardController(file); 
            string poid=file.id;
            ApexPages.currentPage().getParameters().put('ids',poid); 
            EPMS_ChangeFileQCController QCC = new  EPMS_ChangeFileQCController(sc);
            
            QCC.getPOIdsSize(poids);
            
            QCC.selTeam= team.id;
            QCC.selShift=shiftass.id;
            QCC.selQC=Member.id;
            QCC.changeTeam();
            QCC.changeShift();
            set<id> tt = QCC.MemteamIds;
            set<id> teamids = QCC.teamIds;
            list<selectoption> ls=QCC.shiftNames;
            list<selectoption> ls1= QCC.teamNames;
            list<selectoption> ls2= QCC.qcNames;
            
            PageReference pg = QCC.saveChanges();
            Test.StopTest();

        
        }
    }
    
    
    static testmethod void testMemberFileAssignment12(){
            
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
            List<String> memberIds = new List<String>();
            Set<Id> teamIds = new Set<Id>();
            if(team !=null){
                teamIds.add(team.Id);
            }
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
            Test.startTest();
            EPMS_Files_Query_Locator queryLocatorDet = new EPMS_Files_Query_Locator();
            queryLocatorDet.getTeamLeadersShiftAssignmentInfo(shift.Id);
            queryLocatorDet.getTeamLeadersTeamAssignmentInfo(location.Id);
            queryLocatorDet.getQcTeamAssignmentInfo(team.Id);
            queryLocatorDet.getAvailableTeamLeaderToday(team.Id);
            queryLocatorDet.getTeamDetails(teamIds);
            queryLocatorDet.getlocationsquery();
            queryLocatorDet.getFileCheck(memberIds);
            queryLocatorDet.getmembersTL(team.Id,location.Id);
            
            Test.stopTest();
        }
    
    
    
    
}