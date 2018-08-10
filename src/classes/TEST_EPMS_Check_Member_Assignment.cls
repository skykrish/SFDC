/**********************************************************************************
*   Class               :       TEST_EPMS_Check_Member_Assignment                 *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_Check_Member_Assignment       *
**********************************************************************************/
@isTest
private class TEST_EPMS_Check_Member_Assignment{ 

    static testMethod void addMember()
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
               
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phase2';
            location.Location_Country__c='India';
            location.Location_Status__c ='active';
            location.Group_Name__c='INDIA PRIVATE LIMITED - Phase2';
            insert location;

            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='I';
            insert testRecord;

            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testphotoartist@mbo.in';
            insert usermail;

            Member__c member = new Member__c(); 
            member.Name='test';     
            member.Location_id__c=location.id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsalesforce123@gmail.com';
            member.Country__c='India';
            member.Designation__c='Production Administrator';
            member.Status__c='Active';

            Test.startTest();
            insert member;

            Shift__c shift = new Shift__c();
            shift.Shift_Location__c=location.id;
            shift.Implements_From__c=system.now();
            shift.Implements_To__c=system.now().addDays(2);
            shift.Shift_Start_Time__c=system.now();
            shift.Shift_End_Time__c=system.now().addHours(8);
            shift.Status__c='Active';
            insert shift;

            Shift_Assignments__c Shift_Assignments= new Shift_Assignments__c();
            Shift_Assignments.Shift_Assigned__c=true;
            Shift_Assignments.Location__c=location.id;
            Shift_Assignments.Shift_Code__c=shift.id;
            Shift_Assignments.Member__c=member.id;
            insert Shift_Assignments;


            Member__c member2=[select Name,Emp_ID__c,Location_id__c from Member__c where id=:member.id];
            try{  
                delete member2;
            }catch(Exception e){
                System.debug('ERROR:' + e);
            }
        }
            Test.stopTest();    
    }
}