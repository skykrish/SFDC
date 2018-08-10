/**********************************************************************************
*   Class               :       Test_EPMS_Depute_Member                           *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_Depute_Member                 *
**********************************************************************************/
@isTest
public class Test_EPMS_Depute_Member {

    static testMethod void testDepute_Member()
    {
        Profile profile = [select id from Profile where Name = 'System Administrator']; 
        
        User user = new User();
        user.FirstName ='test';
        user.LastName ='data';
        user.Alias ='cust'; 
        user.Username ='testuser@shinsei.com';
        user.Email='test@gmail.com';
        user.ProfileId  = profile.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        insert user;
        
        User Productionuser = new User();
        
        System.runAs(user){
        
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='I';
            insert testRecord;

            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testphotoartist@mbo.in';
            insert usermail;

            Location__c location = new Location__c();
            location.Name='Asia-Japan';
            location.Location_Country__c = 'India';
            location.Group_Name__c ='INDIA PVT LTD -Phase2';
            insert location;

            Location__c location2 = new Location__c();
            location2.Name=' PRIVATE LIMITED - Phase4';
            location2.Location_Country__c = 'India';
            location2.Group_Name__c =' PRIVATE LIMITED - Phase4';
            insert location2;

            Team__c team = new Team__c();
            team.Name='testname';
            team.Location__c=location.id;        
            insert team; 


            test.startTest();

            Member__c Member = new Member__c();
            Member.User_Id__c=user.id;
            Member.First_Name__c='Test1';
            Member.Last_Name__c='testlast';       
            Member.Name='testname';
            Member.Status__c= 'Active';
            Member.Country__c='India';
            Member.Location_id__c=location.id;         
            Member.Designation__c='QC';
            Member.Email__c='test0987@gmail.com';
            insert Member;


            Shift__c shif = new Shift__c();
            shif.Status__c='Active';
            shif.Name = 'Night Shift';
            shif.Shift_Location__c = location.Id;
            shif.Implements_From__c = system.now().addDays(3);
            shif.Shift_Start_Time__c = system.now();
            shif.Shift_End_Time__c = shif.Shift_Start_Time__c.addHours(9);
            insert shif;

            Shift_Assignments__c record = new Shift_Assignments__c();
            record.Shift_Code__c = shif.Id;
            record.Location__c = location.Id;
            record.Shift_Assigned__c = true;
            record.FromTime__c = system.today();
            record.Member__c = member.Id;
            insert record;

            Member__c teamember = new Member__c();
            teamember.User_Id__c=user.id;
            teamember.Name='testname2';
            teamember.Location_id__c=location.id;
            teamember.First_Name__c='Test2';
            teamember.Last_Name__c='testlast2'; 
            teamember.Country__c='India';         
            teamember.Designation__c='Operator';
            teamember.Email__c='test1234@gmail.com';
            teamember.Status__c= 'Active';
            insert teamember;
            test.stopTest();

            string memberid=teamember.id+','+Member.id;
            ApexPages.currentPage().getParameters().put('ids',memberid);
            EPMS_Depute_Member dep = new EPMS_Depute_Member();

            dep.selectedLocId= location.id;
            dep.getListOfLocations();


            dep.selectedLocId= location2.id;
            dep.getListOfLocations();     
            dep.save();


        }    
    }
    static testMethod void testDepute_Member2()
    {
        Profile profile = [select id from Profile where Name = 'System Administrator']; 
        User user = new User();
        user.FirstName ='test';
        user.LastName ='data';
        user.Alias ='cust'; 
        user.Username ='testuser@shinsei.com';
        user.Email='test@gmail.com';
        user.ProfileId  = profile.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        insert user;
        
        User Productionuser = new User();
        
        System.runAs(user){
        
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='I';
            insert testRecord;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testphotoartist@mbo.in';
            insert usermail;
            
            Location__c location = new Location__c();
            location.Name='Asia-Japan';
            location.Location_Country__c = 'India';
            location.Group_Name__c ='INDIA PVT LTD -Phase2';
            insert location;
            
            Location__c location2 = new Location__c();
            location2.Name=' PRIVATE LIMITED - Phase4';
            location2.Location_Country__c = 'India';
            location2.Group_Name__c =' PRIVATE LIMITED - Phase4';
            insert location2;
        
            Team__c team = new Team__c();
            team.Name='testname';
            team.Location__c=location.id;        
            insert team;
        
            test.startTest();
     
            Member__c Member = new Member__c();
            Member.User_Id__c=user.id;
            Member.First_Name__c='Test1';
            Member.Last_Name__c='testlast';       
            Member.Name='testname';
            Member.Status__c= 'Active';
            Member.Country__c='India';
            Member.Location_id__c=location.id;         
            Member.Designation__c='QC';
            Member.Email__c='test0987@gmail.com';
            insert Member;
            
            
            Shift__c shif = new Shift__c();
            shif.Status__c='Active';
            shif.Name = 'Night Shift';
            shif.Shift_Location__c = location.Id;
            shif.Implements_From__c = system.now().addDays(3);
            shif.Shift_Start_Time__c = system.now();
            shif.Shift_End_Time__c = shif.Shift_Start_Time__c.addHours(9);
            insert shif;

     
            Shift_Assignments__c record = new Shift_Assignments__c();
            record.Shift_Code__c = shif.Id;
            record.Location__c = location.Id;
            record.Shift_Assigned__c = true;
            record.FromTime__c = system.today();
            record.Member__c = member.Id;
            insert record;          
            
                
            Member__c teamember = new Member__c();
            teamember.User_Id__c=user.id;
            teamember.Name='testname2';
            teamember.Location_id__c=location.id;
            teamember.First_Name__c='Test2';
            teamember.Last_Name__c='testlast2'; 
            teamember.Country__c='India';         
            teamember.Designation__c='Operator';
            teamember.Email__c='test1234@gmail.com';
            teamember.Status__c= 'Active';
            insert teamember;
            test.stopTest();
      
            string memberid=teamember.id+','+Member.id;
            ApexPages.currentPage().getParameters().put('ids',memberid);
            EPMS_Depute_Member dep = new EPMS_Depute_Member();
                        
            dep.selectedLocId= location2.id;
            dep.getListOfLocations();     
            dep.save();
       
   
        }    
    } 
}