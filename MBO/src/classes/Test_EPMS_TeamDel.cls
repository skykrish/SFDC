/**********************************************************************************
*   Class               :       Test_EPMS_TeamDel                                 *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_TeamDel Trigger               *
**********************************************************************************/

@isTest
private class Test_EPMS_TeamDel {
    static testMethod void testDelete() {

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

            Location__c loc = new Location__c();
            loc.Name = 'MEDIA BACKOFFICE INDIA PRIVATE LIMITED - Phase2';
            loc.Location_Country__c = 'India';
            loc.Group_Name__c ='INDIA PVT LTD -Phase2';
            insert loc;

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
            member.Location_id__c=loc.Id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsalesforce123@gmail.com';
            member.Country__c='India';
            member.Designation__c='Production Administrator';
            member.Status__c='Active';
            insert member;

            Team__c tea = new Team__c();
            tea.Name = 'Production Team';
            tea.Location__c = loc.Id;
            insert tea;

            // Create the shift assignment records
            Shift_Assignments__c record = new Shift_Assignments__c();
            record.Location__c = loc.Id;
            record.Shift_Assigned__c = true;
            record.FromTime__c = system.today();
            record.Member__c = member.Id;
            insert record;

            Team__c team=[Select id from Team__c where id=:tea.id];

            try{
                update team;
            }catch(Exception ex){
                system.debug('Error'+ex);
            }  

            Exception e;
            try{
                delete tea;
            }catch(Exception ex){
                e = ex;
            }           
        }
   
   }
}