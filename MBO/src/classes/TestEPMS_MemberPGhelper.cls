/**********************************************************************************
*   Class               :       TestEPMS_MemberPGhelper                           *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_MemberPGhelper                *
**********************************************************************************/
@isTest
private class TestEPMS_MemberPGhelper {

   static testMethod void addMember()
   {
        Profile profile = [select id from Profile where Name = :EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME];
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
    
        System.runAs(user){
            Test.StartTest();

            Profile profileTL = [select id from Profile where Name = :EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME];
            User userTL = new User();
            userTL.FirstName ='test';
            userTL.LastName ='data';
            userTL.Alias ='cust'; 
            userTL.Username ='testuserTL@shinsei.com';
            userTL.Email='test@gmail.com';
            userTL.ProfileId  = profileTL.id;
            userTL.TimeZoneSidKey='America/Los_Angeles';
            userTL.LocaleSidKey='en_US';
            userTL.EmailEncodingKey='UTF-8';
            userTL.LanguageLocaleKey='en_US';
            insert userTL;

            Location__c location2 = new Location__c();
            location2.Name = 'INDIA PRIVATE LIMITED - Phase1';
            location2.Location_Country__c='India';
            location2.Location_Status__c ='Active';
            location2.Group_Name__c='INDIA PRIVATE LIMITED - Phase1';
            insert location2;


            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phase2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
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
            member.User_Id__c=userTL.Id;
            member.Name='test';     
            member.Location_id__c=location2.id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsalesforce123@gmail.com';
            member.Country__c='India';
            member.Designation__c='Team Leader';
            member.Status__c=EPMS_UTIL.EPMS_ACTIVE_STATUS;
            insert member; 

            User u=[select id,Name from user where Id=:member.User_Id__c];

            member.Location_Id__c=location.Id;
            update member;

            list<id>ids= new  list<id>();
            ids.add(u.Id);

            Group newgroup = [SELECT Id FROM Group WHERE NAME =:EPMS_UTIL.EPMS_PHASE1_USERGROUP_NAME limit 1]; 
            EPMS_MemberPGhelper.addUsersToGroup(newgroup.id,ids);

            member.Location_Id__c=location.Id;
            update member;
            Group groupnew = [SELECT Id FROM Group WHERE NAME =:EPMS_UTIL.EPMS_PHASE2_USERGROUP_NAME limit 1]; 

            EPMS_MemberPGhelper.UpdateUsersToGroup(groupnew.id,ids);
            Test.stopTest();

        }
    }
}