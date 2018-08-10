/**********************************************************************************
*   Class               :       TEST_EPMS_Add_Mem_PG                              *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_Add_Mem_PG                    *
**********************************************************************************/

@isTest(SeeAlldata=true)
private class TEST_EPMS_Add_Mem_PG{ 

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

           Location__c loc = [select id,Name from Location__c where Name='MBOI Phase-1' Limit 1];

                   

            Member__c member = new Member__c(); 
            member.Name='test';     
            member.Location_id__c=loc.id;
            member.First_Name__c='testFirst';
            member.Last_Name__c='testlast';
            member.Email__c='testsales2K18@gmail.com';
            member.Country__c='India';
            member.Designation__c='Team Leader';
            member.Status__c='Active';
            insert member;

           // Member__c member1=[select Name,Location_id__c from Member__c where id=:member.id];
            //member1.Location_id__c=location2.id;
            //update member1;


        }
    
    }
}