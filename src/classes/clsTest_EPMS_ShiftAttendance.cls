/**********************************************************************************
*   Class               :       clsTest_EPMS_ShiftAttendance                      *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_ShiftAttendance               *
**********************************************************************************/
@isTest

public class clsTest_EPMS_ShiftAttendance{    
  
    static testMethod void TestEPMS_ShiftAttendance() {

     Profile p1 = [select id from profile where name=:EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME];
        
        User u1= new User(alias = 'user1', email='test1u1@test.com',
        emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p1.Id,  country='United States', CommunityNickname = 'user1',
        timezonesidkey='America/Los_Angeles', username='test1u1u1@test.com'); 
        
        INSERT u1;     
        
        Profile p2 = [select id from profile where name=:EPMS_UTIL.EPMS_PROD_ADMIN_PROFILE_NAME];
        
        User u2= new User(alias = 'user2', email='u2member@test.com',
        emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p2.Id,  country='United States', CommunityNickname = 'user2',
        timezonesidkey='America/Los_Angeles', username='u2member@test.com'); 
        
        insert u2;     
        Test.StartTest();
        System.runAs(u1) 
        {       
                   
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phase2test';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PVT LTD -Phase2test';
            insert location;

            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testsubra@mbo.in';
            insert usermail;
            
            Team__c team=new Team__c(Name='Test Team',Location__c=location.Id);
            insert team;
            
            Member__c member = new Member__c(); 
            member.Name='test';     
            member.Location_id__c=location.id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsalesforce123@gmail.com';
            member.Country__c='India';
            member.Designation__c='Photo Artists';
            member.Status__c='Active';
            member.Team_Id__c=team.id;
            insert member; 
            
            
            
            Shift__c shift=new Shift__c();
            shift.Name='1st shift';
            Shift.Implements_From__c=System.Today(); 
            Shift.Shift_Start_Time__c=System.now();
            Shift.Shift_End_Time__c=System.now().addDays(2);
            Shift.Status__c='Active';
            Shift.Shift_Location__c=location.id;
            insert shift;
            
            
            Shift_Assignments__c shift1=new Shift_Assignments__c();
            shift1.Member__c=member.Id;
            shift1.Shift_Assigned__c=true;
            shift1.FromTime__c=system.Today();
            shift1.Shift_Code__c=shift.Id;
            shift1.Location__c=location.id;
            insert shift1;
            
            
            
            Shift_Attendance__c sa=new Shift_Attendance__c();
            sa.Attendance_Date__c=System.Today();
            sa.Attendance_Status__c='P';
            sa.Employee_Name__c=member.id;
            sa.Start_Date__c=System.Today();
            sa.End_Date__c=System.Today();
            sa.Shift_Code__c=shift.id;
            insert sa;
            
           
         
            //userDays=7;
            integer TotalPresnt=7;
            integer TotalAbsent=7;
            integer TotalLeave=7;
            integer TotalNoAttendance=7;
            integer TotalDeputed=7; 
            boolean DisableNext=false;
            boolean DisablePrevious=false;
            integer QueryLimit=10;
            Integer OffsetSize =10;
           
            
            EPMS_ShiftAttendance_QueryLocator shiftqueryObj=new EPMS_ShiftAttendance_QueryLocator();
            shiftqueryObj.getMemberDetails(QueryLimit,OffsetSize);
            shiftqueryObj.getMemberCount();
            shiftqueryObj.getMemberDetails(member.location_Id__c,QueryLimit,OffsetSize);
            shiftqueryObj.getMemberCount(member.location_Id__c);
            shiftqueryObj.getAttendanceDetails(member.Id,sa.Start_Date__c,sa.End_Date__c);
            shiftqueryObj.getAttendanceDetails(sa.Start_Date__c,sa.End_Date__c);

            
            EPMS_ShiftAttendance_Service attendanceService = new EPMS_ShiftAttendance_Service();
            attendanceService.getMemberDetails(QueryLimit,OffsetSize);
            attendanceService.getMemberCount();
            attendanceService.getMemberDetails(member.location_Id__c,QueryLimit,OffsetSize);
            attendanceService.getMemberCount(member.location_Id__c);
            attendanceService.getAttendanceDetails(member.Id,sa.Start_Date__c,sa.End_Date__c);
            attendanceService.getAttendanceDetails(sa.Start_Date__c,sa.End_Date__c);
            //shiftAtt.WrapperMember memWrap = new shiftAtt.WrapperMember(member,6,6,6,6,6,6);
           
            EPMS_QueryLocator queryObj = new EPMS_QueryLocator();
            EPMS_ShiftAttendance shiftAtt= new EPMS_ShiftAttendance();
            shiftAtt.member=queryObj.getMember();
            shiftAtt.startDT = System.today().addDays(-2);
            shiftAtt.endDT = System.today().addDays(2);
            shiftAtt.search(); 
            shiftAtt.getDisableNext();
            shiftAtt.getDisablePrevious();
            shiftAtt.getLocations();
            shiftAtt.Next();
            shiftAtt.Previous();          
         
        }  
        
        
        
        System.runAs(u1) 
        {       
                   
            Location__c location = new Location__c();
            location.Name = 'mbo INDIA PRIVATE LIMITED - Phase444test';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='mbo INDIA PVT LTD -Phasetest';
            insert location;

            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testsubra@mbo.in';
            insert usermail;

            
            Team__c team=new Team__c(Name='Test Team',Location__c=location.Id);
            insert team;
            
            Member__c member = new Member__c(); 
            member.Name='test';     
            member.Location_id__c=location.id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsalesforce1234555@gmail.com';
            member.Country__c='India';
            member.Designation__c='Photo Artists';
            member.Status__c='Active';
            member.Team_Id__c=team.id;
            insert member; 
            
            
            
            Shift__c shift=new Shift__c();
            shift.Name='2ND shift';
            Shift.Implements_From__c=System.Today(); 
            Shift.Shift_Start_Time__c=System.now();
            Shift.Shift_End_Time__c=System.now().addDays(12);
            Shift.Status__c='Active';
            Shift.Shift_Location__c=location.id;
            insert shift;
            
            
            Shift_Assignments__c shift1=new Shift_Assignments__c();
            shift1.Member__c=member.Id;
            shift1.Shift_Assigned__c=true;
            shift1.FromTime__c=system.Today();
            shift1.Shift_Code__c=shift.Id;
            shift1.Location__c=location.id;
            insert shift1;
            
            
            
            Shift_Attendance__c sa=new Shift_Attendance__c();
            sa.Attendance_Date__c=System.Today().addDays(-25);
            sa.Attendance_Status__c='A';
            sa.Employee_Name__c=member.id;
            sa.Start_Date__c=System.Today().addDays(-25);
            sa.End_Date__c=NULL;
            sa.Shift_Code__c=shift.id;
            insert sa;
            
         
            integer TotalPresnt=7;
            integer TotalAbsent=7;
            integer TotalLeave=7;
            integer TotalNoAttendance=7;
            integer TotalDeputed=7; 
            boolean DisableNext=false;
            boolean DisablePrevious=false;
            integer QueryLimit=10;
            Integer OffsetSize =10;
            
            
            EPMS_ShiftAttendance_QueryLocator shiftqueryObj=new EPMS_ShiftAttendance_QueryLocator();
            shiftqueryObj.getMemberDetails(QueryLimit,OffsetSize);
            shiftqueryObj.getMemberCount();
            shiftqueryObj.getMemberDetails(member.location_Id__c,QueryLimit,OffsetSize);
            shiftqueryObj.getMemberCount(member.location_Id__c);
            shiftqueryObj.getAttendanceDetails(member.Id,sa.Start_Date__c,sa.End_Date__c);
            shiftqueryObj.getAttendanceDetails(sa.Start_Date__c,sa.End_Date__c);

            
            EPMS_ShiftAttendance_Service attendanceService = new EPMS_ShiftAttendance_Service();
            attendanceService.getMemberDetails(QueryLimit,OffsetSize);
            attendanceService.getMemberCount();
            attendanceService.getMemberDetails(member.location_Id__c,QueryLimit,OffsetSize);
            attendanceService.getMemberCount(member.location_Id__c);
            attendanceService.getAttendanceDetails(member.Id,sa.Start_Date__c,sa.End_Date__c);
            attendanceService.getAttendanceDetails(sa.Start_Date__c,sa.End_Date__c);
           
            EPMS_QueryLocator queryObj = new EPMS_QueryLocator();
            EPMS_ShiftAttendance shiftAtt= new EPMS_ShiftAttendance();
            shiftAtt.member=queryObj.getMember();
            shiftAtt.startDT = System.today().addDays(-2);
            shiftAtt.endDT = System.today().addDays(2);
            Date firstDayOfMonth=System.today().addDays(-90);
            Date lastDayOfMonth= System.today();          
            shiftAtt.tableFlag =true;
            shiftAtt.search(); 
            shiftAtt.getDisableNext();
            shiftAtt.getDisablePrevious();
            shiftAtt.getLocations();
            shiftAtt.Next();
            shiftAtt.Previous();
            }  
        
          
        Test.StopTest();
       
              
        }  
        
        static testMethod void TestEPMS_ShiftAttendance1() {

        Profile p1 = [select id from profile where name=:EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME];
        
        User u1= new User(alias = 'user1', email='testu1sam@test.com',
        emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p1.Id,  country='United States', CommunityNickname = 'user1',
        timezonesidkey='America/Los_Angeles', username='testu1sam@test.com');      
        
        Profile p2 = [select id from profile where name=:EPMS_UTIL.EPMS_PROD_ADMIN_PROFILE_NAME];
        
        User u2= new User(alias = 'user2', email='testu2meber@test.com',
        emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p2.Id,  country='United States', CommunityNickname = 'user2',
        timezonesidkey='America/Los_Angeles', username='testu2member@test.com');     
        insert u1;
        
        Test.StartTest();
        System.runAs(u1) 
        {       
                   
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phase2test';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PVT LTD -Phase2test';
            insert location;

            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testsubra@mbo.in';
            insert usermail;
            
            Team__c team=new Team__c(Name='Test Team',Location__c=location.Id);
            insert team;
            
            Member__c member = new Member__c(); 
            member.Name='test';     
            member.Location_id__c=location.id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsalesforce123@gmail.com';
            member.Country__c='India';
            member.Designation__c='Photo Artists';
            member.Status__c='Active';
            member.Team_Id__c=team.id;
            insert member; 
            
            
            
            Shift__c shift=new Shift__c();
            shift.Name='1st shift';
            Shift.Implements_From__c=System.Today(); 
            Shift.Shift_Start_Time__c=System.now();
            Shift.Shift_End_Time__c=System.now().addDays(2);
            Shift.Status__c='Active';
            Shift.Shift_Location__c=location.id;
            insert shift;
            
            
            Shift_Assignments__c shift1=new Shift_Assignments__c();
            shift1.Member__c=member.Id;
            shift1.Shift_Assigned__c=true;
            shift1.FromTime__c=system.Today();
            shift1.Shift_Code__c=shift.Id;
            shift1.Location__c=location.id;
            insert shift1;
            
            
            
            Shift_Attendance__c sa=new Shift_Attendance__c();
            sa.Attendance_Date__c=System.Today();
            sa.Attendance_Status__c='D';
            sa.Employee_Name__c=member.id;
            sa.Start_Date__c=System.Today();
            sa.End_Date__c=System.Today();
            sa.Shift_Code__c=shift.id;
            insert sa;
            
           
         
            //userDays=7;
            integer TotalPresnt=7;
            integer TotalAbsent=7;
            integer TotalLeave=7;
            integer TotalNoAttendance=7;
            integer TotalDeputed=7; 
            boolean DisableNext=false;
            boolean DisablePrevious=false;
            integer QueryLimit=10;
            Integer OffsetSize =10;
           
            
            EPMS_ShiftAttendance_QueryLocator shiftqueryObj=new EPMS_ShiftAttendance_QueryLocator();
            shiftqueryObj.getMemberDetails(QueryLimit,OffsetSize);
            shiftqueryObj.getMemberCount();
            shiftqueryObj.getMemberDetails(member.location_Id__c,QueryLimit,OffsetSize);
            shiftqueryObj.getMemberCount(member.location_Id__c);
            shiftqueryObj.getAttendanceDetails(member.Id,sa.Start_Date__c,sa.End_Date__c);
            shiftqueryObj.getAttendanceDetails(sa.Start_Date__c,sa.End_Date__c);

            
            EPMS_ShiftAttendance_Service attendanceService = new EPMS_ShiftAttendance_Service();
            attendanceService.getMemberDetails(QueryLimit,OffsetSize);
            attendanceService.getMemberCount();
            attendanceService.getMemberDetails(member.location_Id__c,QueryLimit,OffsetSize);
            attendanceService.getMemberCount(member.location_Id__c);
            attendanceService.getAttendanceDetails(member.Id,sa.Start_Date__c,sa.End_Date__c);
            attendanceService.getAttendanceDetails(sa.Start_Date__c,sa.End_Date__c);
           
            EPMS_QueryLocator queryObj = new EPMS_QueryLocator();
            EPMS_ShiftAttendance shiftAtt= new EPMS_ShiftAttendance();
            shiftAtt.member=queryObj.getMember();
            shiftAtt.startDT = System.today().addDays(-2);
            shiftAtt.endDT = System.today().addDays(2);
            shiftAtt.search(); 
            shiftAtt.getDisableNext();
            shiftAtt.getDisablePrevious();
            shiftAtt.getLocations();
            shiftAtt.Next();
            shiftAtt.Previous();          
         
        } 
        Location__c location = new Location__c();
            location.Name = 'mbo INDIA PRIVATE LIMITED - Phase4445test';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='mbo INDIA PVT LTD -Phase4445test';
            insert location; 
        
        System.runAs(u1) 
        {       
                   
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testsubra@mbo.in';
            insert usermail;
            
            Team__c team=new Team__c(Name='Test Team',Location__c=location.Id);
            insert team;
            
            Member__c member = new Member__c(); 
            member.Name='test';     
            member.Location_id__c=location.id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsalesforce1234555@gmail.com';
            member.Country__c='India';
            member.Designation__c='Photo Artists';
            member.Status__c='Active';
            member.Team_Id__c=team.id;
            insert member; 
            
            
            
            Shift__c shift=new Shift__c();
            shift.Name='2ND shift';
            Shift.Implements_From__c=System.Today(); 
            Shift.Shift_Start_Time__c=System.now();
            Shift.Shift_End_Time__c=System.now().addDays(12);
            Shift.Status__c='Active';
            Shift.Shift_Location__c=location.id;
            insert shift;
            
            
            Shift_Assignments__c shift1=new Shift_Assignments__c();
            shift1.Member__c=member.Id;
            shift1.Shift_Assigned__c=true;
            shift1.FromTime__c=system.Today();
            shift1.Shift_Code__c=shift.Id;
            shift1.Location__c=location.id;
            insert shift1;
            
            
            
            Shift_Attendance__c sa=new Shift_Attendance__c();
            sa.Attendance_Date__c=System.Today().addDays(-25);
            sa.Attendance_Status__c='L';
            sa.Employee_Name__c=member.id;
            sa.Start_Date__c=System.Today().addDays(-25);
            sa.End_Date__c=NULL;
            sa.Shift_Code__c=shift.id;
            insert sa;
            
         
            integer TotalPresnt=7;
            integer TotalAbsent=7;
            integer TotalLeave=7;
            integer TotalNoAttendance=7;
            integer TotalDeputed=7; 
            boolean DisableNext=false;
            boolean DisablePrevious=false;
            integer QueryLimit=10;
            Integer OffsetSize =10;
            
            
            EPMS_ShiftAttendance_QueryLocator shiftqueryObj=new EPMS_ShiftAttendance_QueryLocator();
            shiftqueryObj.getMemberDetails(QueryLimit,OffsetSize);
            shiftqueryObj.getMemberCount();
            shiftqueryObj.getMemberDetails(member.location_Id__c,QueryLimit,OffsetSize);
            shiftqueryObj.getMemberCount(member.location_Id__c);
            shiftqueryObj.getAttendanceDetails(member.Id,sa.Start_Date__c,sa.End_Date__c);
            shiftqueryObj.getAttendanceDetails(sa.Start_Date__c,sa.End_Date__c);

            
            EPMS_ShiftAttendance_Service attendanceService = new EPMS_ShiftAttendance_Service();
            attendanceService.getMemberDetails(QueryLimit,OffsetSize);
            attendanceService.getMemberCount();
            attendanceService.getMemberDetails(member.location_Id__c,QueryLimit,OffsetSize);
            attendanceService.getMemberCount(member.location_Id__c);
            attendanceService.getAttendanceDetails(member.Id,sa.Start_Date__c,sa.End_Date__c);
            attendanceService.getAttendanceDetails(sa.Start_Date__c,sa.End_Date__c);
           
            EPMS_QueryLocator queryObj = new EPMS_QueryLocator();
            EPMS_ShiftAttendance shiftAtt= new EPMS_ShiftAttendance();
            shiftAtt.member=queryObj.getMember();
            shiftAtt.startDT = System.today().addDays(-2);
            shiftAtt.endDT = System.today().addDays(2);
            Date firstDayOfMonth=System.today().addDays(-90);
            Date lastDayOfMonth= System.today();          
            shiftAtt.tableFlag =true;
            shiftAtt.search(); 
            shiftAtt.getDisableNext();
            shiftAtt.getDisablePrevious();
            shiftAtt.getLocations();
            shiftAtt.Next();
            shiftAtt.Previous();
            }  
        
          
        Test.StopTest();
  
        
              
        }     
 }