/**********************************************************************************
*   Class               :       clsTest_EPMS_Trg_DeleteLocation                   *
*   Created Date        :       25/03/2016                                        *
*   Description         :       Test Class for EPMS_Trg_DeleteLocation            *
**********************************************************************************/

@isTest
private class clsTest_EPMS_Trg_DeleteLocation{ 

   static testMethod void DeleteLocation()
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
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PVT LTD -Phase2';
            insert location;
            
            
            Team__c team=new Team__c();
            team.Name='Team A';
            team.Location__c=location.id;
            insert team;

            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='I';
            insert testRecord;
            
            UserEmail__c usermail1=new UserEmail__c();
            usermail1.Name='New User Email';
            usermail1.Email__c='testsubra@mbo.in';
            insert usermail1;  
            
            Member__c member = new Member__c(); 
            member.Name='test';     
            member.Location_id__c=location.id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsalesforce123@gmail.com';
            member.Country__c='India';
            member.Designation__c='Production Administrator';
            member.Status__c='Active';
            insert member;                        
            
            Location__c location1 = new Location__c();
            location1.Name = 'INDIA PRIVATE LIMITED - Phase3';
            location1 .Location_Country__c='India';
            location1 .Location_Status__c ='Active';
            location1 .Group_Name__c='INDIA PVT LTD -Phase3';
            insert location1 ;

            Employee_Country_Code__c testRecord1= new Employee_Country_Code__c();
            testRecord1.Name='India';
            testRecord1.Country_Initial_Letter__c='I';
            insert testRecord1;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testsubra@mbo.in';
            insert usermail;            
            
            Member__c member1 = new Member__c(); 
            member1 .Name='test';     
            member1 .Location_id__c=location1.id;
            member1 .First_Name__c='testFirst';
            member1 .Last_Name__c='testlast';
            member1 .Email__c='testsalesforce1234@gmail.com';
            member1 .Country__c='India';
            member1 .Designation__c='Shift Administrator';
            member1 .Status__c='Active';
            insert member1 ;           
            
            Test.StartTest();
            location.Location_Status__c ='Inactive';
            
            Exception e;
            try{
                update location;
               } catch(Exception ex){
                e = ex;
            } 
            
            list<Location__c> oldlist=[select Name,Location_Status__c from Location__c where id=:location1.id];
            
            try{
                delete oldlist;
               } catch(Exception ex){
                e = ex;
            } 
            
            system.assertNotEquals(null, e);
            system.assert(e instanceOf system.Dmlexception);
            system.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            Test.StopTest();
    }
    
}
    
}