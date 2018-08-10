/**********************************************************************************
*   Class               :       clsTest_EPMS_Mem_TeamAssignment                   *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_Mem_TeamAssignment            *
**********************************************************************************/

@isTest
public class clsTest_EPMS_Mem_TeamAssignment{ 
  
    static testMethod void Test_EPMS_Mem_TeamAssignment() {
    
        Profile p1 = [select id from profile where name=:EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME];
        
        User u1= new User(alias = 'user1', email='u1222@test.com',
        emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p1.Id,  country='United States', CommunityNickname = 'user1',
        timezonesidkey='America/Los_Angeles', username='u1222@test.com');                
        
        Profile p2 = [select id from profile where name=:EPMS_UTIL.EPMS_PROD_ADMIN_PROFILE_NAME];
        
        User u2= new User(alias = 'user2', email='u27@test.com',
        emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p2.Id,  country='United States', CommunityNickname = 'user2',
        timezonesidkey='America/Los_Angeles', username='u27@test.com');      
                 
        System.runAs(u1) 
        {
            Test.startTest();
            
            EPMS_Mem_TeamAssignment TeamAssignment= new EPMS_Mem_TeamAssignment(); 
            TeamAssignment.saveMemberstoTeam();

            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phase2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PRIVATE LIMITED - Phase2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testingconsultant6@mbo.in';
            insert usermail;
            
            Team__c team=new Team__c(Name='Test Team',Location__c=location.Id);
            insert team;
            
            Team__c team2=new Team__c(Name='Test Team1',Location__c=location.Id);
            insert team2;
            
            Member__c member = new Member__c(); 
            member.Name='test';     
            member.Emp_ID__c='A1212';
            member.Location_id__c=location.id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsalesforce123@gmail.com';
            member.Country__c='India';
            member.Designation__c='Photo Artists';
            member.Status__c='Active';
            member.Team_Id__c=team.id;
            insert member;     
 
            Member__c member2 = new Member__c(); 
            member2.Name='test2'; 
            member2.Emp_ID__c='A1213';          
            member2.Location_id__c=location.id;
            member2.First_Name__c='testFirst2';
            member2.Last_Name__c='testlast2';
            member2.Email__c='testsalesforce1232@gmail.com';
            member2.Country__c='India';
            member2.Designation__c='Photo Artists';
            member2.Status__c='Active';
            member2.Team_Id__c=team.id;
            insert member2;
            
            Member__c member3 = new Member__c(); 
            member3.Name='test3'; 
            member3.Emp_ID__c='A1214';
            member3.Location_id__c=location.id;
            member3.First_Name__c='testFirst3';
            member3.Last_Name__c='testlast3';
            member3.Email__c='testsalesforce1233@gmail.com';
            member3.Country__c='India';
            member3.Designation__c='Photo Artists';
            member3.Status__c='Active';
            member3.Team_Id__c=team.id;
            insert member3;
            
            Member__c member4 = new Member__c(); 
            member4.Name='test3'; 
            member4.Emp_ID__c='A1216';
            member4.Location_id__c=location.id;
            member4.First_Name__c='testFirst4';
            member4.Last_Name__c='testlast4';
            member4.Email__c='testsalesforce1234@gmail.com';
            member4.Country__c='India';
            member4.Designation__c='Photo Artists';
            member4.Status__c='Active';
            member4.Team_Id__c=team2.id;
            insert member4;                                    
            
            TeamAssignment.getCurrentTeams();
            TeamAssignment.setCurrentTeams(team.id);
            
            List<Member__c> memberListValue =[select Name, Id, Emp_ID__c,Designation__c from Member__c];
            TeamAssignment.memberList = memberListValue;
            
            TeamAssignment.membersTypeOption = 'Available';
            TeamAssignment.CurrentTeams = member.Team_Id__c;
            TeamAssignment.selectvalue = member.Location_id__c; 
                        
            TeamAssignment.getallContacts();
            try{
                TeamAssignment.saveMemberstoTeam();
            }catch(Exception e){
                System.debug('----Available locaton--'+e);
            }            
          

            TeamAssignment.getAllLocations();
            TeamAssignment.getMembersType();
            TeamAssignment.getLocationTeams();
            TeamAssignment.ShowPanel();
            
            TeamAssignment.Cancel();
            Test.stopTest();
            
            }
        }  

        static testMethod void Test_EPMS_Mem_TeamAssignment1() { 
        
            EPMS_Mem_TeamAssignment TeamAssignment= new EPMS_Mem_TeamAssignment(); 
           // TeamAssignment.saveMemberstoTeam();
           
            try{
                TeamAssignment.getallContacts();               
                TeamAssignment.saveMemberstoTeam();
            }catch(Exception e){
                System.debug('----All locaton--'+e);
            }

            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phase2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PRIVATE LIMITED - Phase2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testingconsultant5@mbo.in';
            insert usermail;
            
            Team__c team=new Team__c(Name='Test Team',Location__c=location.Id);
            insert team;
            
            Member__c member = new Member__c(); 
            member.Name='test';     
            member.Emp_ID__c='A1212';
            member.Location_id__c=location.id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsalesforce123@gmail.com';
            member.Country__c='India';
            member.Designation__c='Photo Artists';
            member.Status__c='Active';            
            insert member;      
 
            Member__c member2 = new Member__c(); 
            member2.Name='test2'; 
            member2.Emp_ID__c='A1213';          
            member2.Location_id__c=location.id;
            member2.First_Name__c='testFirst2';
            member2.Last_Name__c='testlast2';
            member2.Email__c='testsalesforce1232@gmail.com';
            member2.Country__c='India';
            member2.Designation__c='Photo Artists';
            member2.Status__c='Active';
            member2.Team_Id__c=team.id;
            insert member2;
            
            Member__c member3 = new Member__c(); 
            member3.Name='test3'; 
            member3.Emp_ID__c='A1214';
            member3.Location_id__c=location.id;
            member3.First_Name__c='testFirst3';
            member3.Last_Name__c='testlast3';
            member3.Email__c='testsalesforce1233@gmail.com';
            member3.Country__c='India';
            member3.Designation__c='Team Leader';
            member3.Status__c='Active';
            member3.Team_Id__c=team.id;
            insert member3;
            
            TeamAssignment.getCurrentTeams();
            TeamAssignment.setCurrentTeams(team.id);
            
            List<Member__c> memberListValue =[select Name, Id, Emp_ID__c,Designation__c from Member__c];
            TeamAssignment.memberList = memberListValue;
            
            TeamAssignment.membersTypeOption = 'All';
            TeamAssignment.CurrentTeams = team.id;
            //TeamAssignment.selectvalue = member.Location_id__c;             
            TeamAssignment.selectvalue = location.id;
            TeamAssignment.getallContacts();
            TeamAssignment.selectedContacts.add(new SelectOption(member.Id,member.Emp_ID__c +' - ' + member.Name  ));
            try{
                TeamAssignment.saveMemberstoTeam();
            }catch(Exception e){
                System.debug('----All locaton--'+e);
            }
            
            TeamAssignment.getAllLocations();
            TeamAssignment.getMembersType();
            TeamAssignment.getLocationTeams();
            TeamAssignment.ShowPanel();
            TeamAssignment.cancel();            
            
            EPMS_Mem_TeamAssignment TeamAssignment1= new EPMS_Mem_TeamAssignment(); 
            TeamAssignment1.CurrentTeams=null;
            TeamAssignment1.selectvalue=null;
            TeamAssignment1.selectedContacts=null;
            
            try{
                TeamAssignment1.getallContacts();               
                TeamAssignment1.saveMemberstoTeam();
            }catch(Exception e){
                System.debug('----All locaton--'+e);
            }
        }
        
        // Empty field check 
        static testMethod void Test_EPMS_Mem_TeamAssignment2() {
        
        Profile p1 = [select id from profile where name=:EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME];
        
        User u1= new User(alias = 'user1', email='u156@test.com',
        emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p1.Id,  country='United States', CommunityNickname = 'user1',
        timezonesidkey='America/Los_Angeles', username='u156@test.com');        
                       
        System.runAs(u1) 
        {
            Test.startTest();
            
            EPMS_Mem_TeamAssignment TeamAssignmentDetails= new EPMS_Mem_TeamAssignment(); 
            
            TeamAssignmentDetails.saveMemberstoTeam();

            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE - Phase2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PRIVATE - Phase2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testingconsultant4@mbo.in';
            insert usermail;
            
            Team__c team=new Team__c(Name='Test Team',Location__c=location.Id);
            insert team;            
           
            Member__c member = new Member__c(); 
            member.Name='test';     
            member.Emp_ID__c='A1212';
            member.Location_id__c=location.id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsalesforce123@gmail.com';
            member.Country__c='India';
            member.Designation__c='Team Leader';
            member.Status__c='Active';
           
            insert member;     
 
            Member__c member2 = new Member__c(); 
            member2.Name='test2'; 
            member2.Emp_ID__c='A1213';          
            member2.Location_id__c=location.id;
            member2.First_Name__c='testFirst2';
            member2.Last_Name__c='testlast2';
            member2.Email__c='testsalesforce1232@gmail.com';
            member2.Country__c='India';
            member2.Designation__c='Quality Control';
            member2.Status__c='Active';
            
            insert member2;
            
            Member__c member3 = new Member__c(); 
            member3.Name='test3'; 
            member3.Emp_ID__c='A1214';
            member3.Location_id__c=location.id;
            member3.First_Name__c='testFirst3';
            member3.Last_Name__c='testlast3';
            member3.Email__c='testsalesforce1233@gmail.com';
            member3.Country__c='India';
            member3.Designation__c='Team Leader';
            member3.Status__c='Active';
            
            insert member3;
            
            Member__c member4 = new Member__c(); 
            member4.Name='test3'; 
            member4.Emp_ID__c='A1216';
            member4.Location_id__c=location.id;
            member4.First_Name__c='testFirst4';
            member4.Last_Name__c='testlast4';
            member4.Email__c='testsalesforce1234@gmail.com';
            member4.Country__c='India';
            member4.Designation__c='Quality Control';
            member4.Status__c='Active';
            
            insert member4;     

            
            EPMS_Mem_TeamAssignment TeamAssignmentDetails4 = new EPMS_Mem_TeamAssignment(); 
            TeamAssignmentDetails4.CurrentTeams =team.id;
            TeamAssignmentDetails4.selectvalue = member.Location_id__c;
            TeamAssignmentDetails4.selectedContacts.clear();
            
            try{
                TeamAssignmentDetails4.saveMemberstoTeam();
            }Catch(Exception e){
                system.debug('Exception'+e);
            }   
            
            TeamAssignmentDetails.getCurrentTeams();
            TeamAssignmentDetails.setCurrentTeams(team.id);
            
            List<Member__c> memberListValue =[select Name, Id, Emp_ID__c,Designation__c from Member__c];
            TeamAssignmentDetails.memberList = memberListValue;
            
            TeamAssignmentDetails.membersTypeOption = 'Available';
            TeamAssignmentDetails.CurrentTeams = team.id;
            TeamAssignmentDetails.selectvalue = member.Location_id__c;
            TeamAssignmentDetails.getallContacts();
            
             TeamAssignmentDetails.selectedContacts.add(new SelectOption(member.Id,member.Emp_ID__c +' - ' + member.Name  ));
             
             TeamAssignmentDetails.selectedContacts.add(new SelectOption(member3.Id,member3.Emp_ID__c +' - ' + member3.Name  ));
              
            try{
                TeamAssignmentDetails.saveMemberstoTeam();
            }catch(Exception e){
                System.debug('----Available locaton--'+e);
            }            
          
            TeamAssignmentDetails.getAllLocations();
            TeamAssignmentDetails.getMembersType();
            TeamAssignmentDetails.getLocationTeams();
            TeamAssignmentDetails.ShowPanel();            
            TeamAssignmentDetails.Cancel();
            
            EPMS_Mem_TeamAssignment TeamAssignmentDetails1 = new EPMS_Mem_TeamAssignment(); 
            TeamAssignmentDetails1.CurrentTeams =null;
            TeamAssignmentDetails1.selectvalue = member.Location_id__c; 
            try{
                TeamAssignmentDetails1.saveMemberstoTeam();
            }Catch(Exception e){
                system.debug('Exception'+e);
            }
            
            EPMS_Mem_TeamAssignment TeamAssignmentDetails2 = new EPMS_Mem_TeamAssignment(); 
            TeamAssignmentDetails2.CurrentTeams =team.id;
            TeamAssignmentDetails2.selectvalue = null;
            try{
                TeamAssignmentDetails2.saveMemberstoTeam();
            }Catch(Exception e){
                system.debug('Exception'+e);
            }
                          
            Test.stopTest();
            
            }
        }   


    // For Two QC Condition
    static testMethod void Test_EPMS_Mem_TeamAssignment3() {
        
        Profile p1 = [select id from profile where name=:EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME];
        User u1= new User(alias = 'user1', email='memu12@test.com',
        emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p1.Id,  country='United States', CommunityNickname = 'user1',
        timezonesidkey='America/Los_Angeles', username='memu12@test.com');        
        
        insert u1;
                       
        System.runAs(u1) 
        {
            Test.startTest();
            
            EPMS_Mem_TeamAssignment TeamAssignmentDetails= new EPMS_Mem_TeamAssignment(); 
            

            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE - Phase2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PRIVATE - Phase2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testingconsultant3@mbo.in';
            insert usermail;
            
            Team__c team=new Team__c(Name='Test Team',Location__c=location.Id);
            insert team;
            
            
            Member__c member2 = new Member__c(); 
            member2.Name='test2'; 
            member2.Emp_ID__c='A1213';          
            member2.Location_id__c=location.id;
            member2.First_Name__c='testFirst2';
            member2.Last_Name__c='testlast2';
            member2.Email__c='testsalesforce1232@gmail.com';
            member2.Country__c='India';
            member2.Designation__c='Quality Control';
            member2.Status__c='Active';
            
            insert member2;
            
            
            Member__c member4 = new Member__c(); 
            member4.Name='test3'; 
            member4.Emp_ID__c='A1216';
            member4.Location_id__c=location.id;
            member4.First_Name__c='testFirst4';
            member4.Last_Name__c='testlast4';
            member4.Email__c='testsalesforce1234@gmail.com';
            member4.Country__c='India';
            member4.Designation__c='Quality Control';
            member4.Status__c='Active';
            
            insert member4;     

            TeamAssignmentDetails.getCurrentTeams();
            TeamAssignmentDetails.setCurrentTeams(team.id);            
           
            
            TeamAssignmentDetails.membersTypeOption = 'Available';
            TeamAssignmentDetails.CurrentTeams = team.id;
            TeamAssignmentDetails.selectvalue = member2.Location_id__c;
            TeamAssignmentDetails.getallContacts();
            
             TeamAssignmentDetails.selectedContacts.add(new SelectOption(member2.Id,member2.Emp_ID__c +' - ' + member2.Name  ));
             
             TeamAssignmentDetails.selectedContacts.add(new SelectOption(member4.Id,member4.Emp_ID__c +' - ' + member4.Name  ));
              
            try{
                TeamAssignmentDetails.saveMemberstoTeam();
            }catch(Exception e){
                System.debug('----Available locaton--'+e);
            }
            
                          
            Test.stopTest();
            
            }       
        }
        
        // for unAssign members
        static testMethod void Test_EPMS_Mem_TeamAssignment4() {
        
        Profile p1 = [select id from profile where name=:EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME];
        
        User u1= new User(alias = 'user1', email='memu15@test.com',
        emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p1.Id,  country='United States', CommunityNickname = 'user1',
        timezonesidkey='America/Los_Angeles', username='memu15@test.com');        
        
        insert u1;
                       
        System.runAs(u1) 
        {
            Test.startTest();
            
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE - Phase2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PRIVATE - Phase2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testingconsultant2@mbo.in';
            insert usermail;    
            
            Team__c team=new Team__c(Name='Test Team',Location__c=location.Id);
            insert team;
            
            Member__c member = new Member__c(); 
            member.Name='test';     
            member.Emp_ID__c='A1212';
            member.Location_id__c=location.id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsalesforce123@gmail.com';
            member.Country__c='India';
            member.Designation__c='Photo Artists';
            member.Status__c='Active';
            member.Team_Id__c=team.id;
            insert member;     
 
            Member__c member2 = new Member__c(); 
            member2.Name='test2'; 
            member2.Emp_ID__c='A1213';          
            member2.Location_id__c=location.id;
            member2.First_Name__c='testFirst2';
            member2.Last_Name__c='testlast2';
            member2.Email__c='testsalesforce1232@gmail.com';
            member2.Country__c='India';
            member2.Designation__c='Photo Artists';
            member2.Status__c='Active';
            member2.Team_Id__c=team.id;
            insert member2;
          
         
                EPMS_Mem_TeamAssignment TeamAssignmentDetails= new EPMS_Mem_TeamAssignment(); 
                TeamAssignmentDetails.membersTypeOption = 'All';
                TeamAssignmentDetails.CurrentTeams = team.id;
                TeamAssignmentDetails.selectvalue = member.Location_id__c;             
                
                TeamAssignmentDetails.getallContacts();             
                
                if(TeamAssignmentDetails.selectedContacts.size()>0 ){
                    for(Integer i=0;i<TeamAssignmentDetails.selectedContacts.size();i++){
                        if(i!=0){
                            TeamAssignmentDetails.allContacts.add(new SelectOption(TeamAssignmentDetails.selectedContacts[i].getValue(),TeamAssignmentDetails.selectedContacts[i].getLabel()));
                            TeamAssignmentDetails.selectedContacts.remove(i);
                        }                       
                    }
                }               
                 
                try{
                
                    TeamAssignmentDetails.saveMemberstoTeam();
                    
                }Catch(Exception e){
                    system.debug('Exception'+e);
                }
                                
                Test.stopTest();
            }
        }       
        
        // for Prod Admin
        static testMethod void Test_EPMS_Mem_TeamAssignment5() {
        
        Profile p1 = [select id from profile where name='System Administrator'];
        User u1= new User(alias = 'user1', email='memu19@test.com',
        emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p1.Id,  country='United States', CommunityNickname = 'user1',
        timezonesidkey='America/Los_Angeles', username='memu19@test.com');        
        
        insert u1;
                  
        System.runAs(u1) 
        {
            Test.startTest();       
            
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE - Phase2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PRIVATE - Phase2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testingconsultant1@mbo.in';
            insert usermail;
            
            Team__c team=new Team__c(Name='Test Team',Location__c=location.Id);
            insert team;            
            
            Member__c member = new Member__c(); 
            member.Name='test';     
            member.Emp_ID__c='A1212';
            member.Location_id__c=location.id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsalesforce123@gmail.com';
            member.Country__c='India';
            member.Designation__c='Production Administrator';
            member.Status__c='Active';
            member.Enable_Login__c=true;
            
            insert member;     
 
            List<User> userDetails = [Select id , Name from User where email =:member.Email__c];
           
            EPMS_Mem_TeamAssignment TeamAssignmentDetails= new EPMS_Mem_TeamAssignment();
            TeamAssignmentDetails.membersTypeOption = 'All';
            TeamAssignmentDetails.CurrentTeams = team.id;
            TeamAssignmentDetails.selectvalue = member.Location_id__c;    
            TeamAssignmentDetails.getLocationTeams();
            TeamAssignmentDetails.getallContacts(); 
            
            try{
            
                TeamAssignmentDetails.saveMemberstoTeam();
                
            }Catch(Exception e){
                system.debug('Exception'+e);
            }
            
            Test.stopTest();
        }
    }
 }