/**********************************************************************************
*   Class               :       Test_EPMS_UpdateMemTeam                           *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_UpdateMemTeam                          *
**********************************************************************************/

@isTest
public class Test_EPMS_UpdateMemTeam {

    static testMethod void testUpdateMemTeam()
    { 
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='M';
        insert testRecord;
        
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testsubra@mbo.in';
        insert usermail;   
        
             
        Location__c location = new Location__c();
        location.Name='Asia-Japan';
        location.Location_Country__c = 'India';
        location.Group_Name__c ='INDIA PVT LTD -Phase2';
        insert location;
        
        Location__c location1 = new Location__c();
        location1.Name='Japan';
        location1.Location_Country__c = 'India';
        location1.Group_Name__c ='LTD -Phase2';
        insert location1;
        
        Team__c team = new Team__c();
        team.Name='testname';
        team.Location__c=location.id;        
        insert team; 
        
        Team__c team1 = new Team__c();
        team1.Name='testname1';
        team1.Location__c=location.id;        
        insert team1; 
    
        
        Team__c team2 = new Team__c();
        team2.Name='testname2';
        team2.Location__c=location.id;        
        insert team2; 
        
        test.startTest();
        
 
        Member__c Member = new Member__c();
        Member.First_Name__c='Test1';
        Member.Last_Name__c='testlast';       
        Member.Name='testname';
        Member.Status__c= 'Active';
        Member.Team_Id__c =team.id;
        Member.Country__c='India';
        Member.Location_id__c=location.id;         
        Member.Designation__c='Team Leader';
        Member.Email__c='test0987@gmail.com';
        insert Member;
        
        Member__c teamember = new Member__c();
        teamember.Location_id__c=location.id;
        teamember.First_Name__c='Test2';
        teamember.Name='testname2';
        teamember.Last_Name__c='testlast2'; 
        teamember.Country__c='India'; 
        teamember.Team_Id__c =team1.id;       
        teamember.Designation__c='Quality Control';
        teamember.Email__c='test1555@gmail.com';
        teamember.Status__c= 'Active';
        insert teamember;
        
         Member__c teamember1 = new Member__c();
        teamember1.Location_id__c=location.id;
        teamember1.First_Name__c='Test23';
        teamember1.Name='testname23';
        teamember1.Last_Name__c='testlast23'; 
        teamember1.Country__c='India'; 
        teamember1.Designation__c='Photo Artists';
        teamember1.Email__c='test15553@gmail.com';
        teamember1.Status__c= 'Active';
        insert teamember1;
        test.stopTest();
        
        Shift__c shift = new Shift__c();
        shift.Status__c='Active';
        shift.Name = 'Night Shift';
        shift.Shift_Location__c = location.Id;
        shift.Implements_From__c = system.now().addDays(3);
        shift.Shift_Start_Time__c = system.now();
        shift.Shift_End_Time__c = system.now().addHours(4);
        insert shift;            
        
        Shift__c shift1 = new Shift__c();
        shift1.Status__c='Active';
        shift1.Name = 'day Shift';
        shift1.Shift_Location__c = location.Id;
        shift1.Implements_From__c = system.now().addDays(5);
        shift1.Shift_Start_Time__c = system.now().addHours(4);
        shift1.Shift_End_Time__c = system.now().addHours(9);
        insert shift1;

     
        Shift_Assignments__c record = new Shift_Assignments__c();
        record.Shift_Code__c = shift.Id;
        record.Location__c = location.Id;
        record.Shift_Assigned__c = true;
        record.FromTime__c = system.today();
        record.Member__c = member.Id;
        insert record;
        
        Shift_Assignments__c record1 = new Shift_Assignments__c();
        record1.Shift_Code__c = shift1.Id;
        record1.Location__c = location.Id;
        record1.Shift_Assigned__c = true;
        record1.FromTime__c = system.today();
        record1.Member__c = teamember.Id;
        insert record1;
        
        Shift_Assignments__c record2 = new Shift_Assignments__c();
        record2.Shift_Code__c = shift.Id;
        record2.Location__c = location.Id;
        record2.Shift_Assigned__c = true;
        record2.FromTime__c = system.today();
        record2.Member__c = teamember1.Id;
        insert record2;
        
       
        Member__c changeteam=[Select Id,name,Location_id__c,Team_Id__c,Status__c from Member__c where id=:Member.id];
        changeteam.Team_Id__c=team1.id;
        update changeteam;
        
        
        Member__c changeteam1=[Select Id,name,Location_id__c,Team_Id__c,Status__c from Member__c where id=:teamember.id];
        changeteam1.Team_Id__c=null;
        update changeteam1;
        
          
        Member__c changeteam3=[Select Id,name,Location_id__c,Team_Id__c,Status__c from Member__c where id=:Member.id];
        changeteam3.Team_Id__c=team2.id;
        update changeteam3;
        
        Member__c changeteam2=[Select Id,name,Location_id__c,Team_Id__c,Status__c from Member__c where id=:teamember1.id];
        changeteam2.Team_Id__c=team1.id;
        update changeteam2;
        
    }
    
    static testMethod void testUpdateMemTeam1()
    {
   
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='M';
        insert testRecord;
        
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testsubra@mbo.in';
        insert usermail;
        
        Location__c location = new Location__c();
        location.Name='Asia-Japan';
        location.Location_Country__c = 'India';
        location.Group_Name__c ='INDIA PVT LTD -Phase2';
        insert location;
  
        Team__c team = new Team__c();
        team.Name='testname';
        team.Location__c=location.id;        
        insert team; 
        
          
        Team__c team1 = new Team__c();
        team1.Name='testname1';
        team1.Location__c=location.id;        
        insert team1;
        
        test.startTest();
 
        Member__c Member = new Member__c();
        Member.First_Name__c='Test1';
        Member.Last_Name__c='testlast';       
        Member.Name='testname';
        Member.Status__c= 'Active';
        Member.Country__c='India';
        Member.Location_id__c=location.id;         
        Member.Designation__c='Production Administrator';
        Member.Email__c='test0987@gmail.com';
        insert Member;
        
        Member__c teamember = new Member__c();
        teamember.Location_id__c=location.id;
        teamember.First_Name__c='Test2';
        teamember.Name='testname2';
        teamember.Last_Name__c='testlast2'; 
        teamember.Country__c='India'; 
        teamember.Team_Id__c =team.id;       
        teamember.Designation__c='Quality Control';
        teamember.Email__c='test1555@gmail.com';
        teamember.Status__c= 'Active';
        insert teamember;
        
        Member__c teamember1 = new Member__c();
        teamember1.Location_id__c=location.id;
        teamember1.First_Name__c='Test23';
        teamember1.Name='testname23';
        teamember1.Last_Name__c='testlast23'; 
        teamember1.Country__c='India'; 
        teamember1.Team_Id__c =team.id;
        teamember1.Designation__c='Team Leader';
        teamember1.Email__c='test15553@gmail.com';
        teamember1.Status__c= 'Active';
        insert teamember1;
        
        test.stopTest();
     
        Shift__c shift = new Shift__c();
        shift.Status__c='Active';
        shift.Name = 'Night Shift';
        shift.Shift_Location__c = location.Id;
        shift.Implements_From__c = system.now().addDays(3);
        shift.Shift_Start_Time__c = system.now();
        shift.Shift_End_Time__c = system.now().addHours(4);
        insert shift;
        

        Shift_Assignments__c record = new Shift_Assignments__c();
        record.Shift_Code__c = shift.Id;
        record.Location__c = location.Id;
        record.Shift_Assigned__c = true;
        record.FromTime__c = system.today();
        record.Member__c = member.Id;
        insert record;

        Member__c changeteam=[Select Id,name,Location_id__c,Team_Id__c,Status__c from Member__c where id=:Member.id];
        changeteam.Team_Id__c=team1.id;
        
        try{
            update changeteam;
        }catch(exception ex){        
            system.debug('ERROR'+ex);        
        }
        
        Member__c changeteam1=[Select Id,name,Location_id__c,Team_Id__c,Status__c,Designation__c from Member__c where id=:teamember.id];
        changeteam1.Designation__c ='Team Leader';
        
        try{
            update changeteam1;
        }catch(exception ex){        
            system.debug('ERROR'+ex);        
        }
        
        Member__c changeteam2=[Select Id,name,Location_id__c,Team_Id__c,Status__c,Designation__c from Member__c where id=:teamember.id];
        changeteam2.Designation__c ='Quality Control';
        
        try{
            update changeteam2;
        }catch(exception ex){        
            system.debug('ERROR'+ex);        
        }
    }
}