/**********************************************************************************
*   Class               :       Test_EPMS_AddUsersToChatterGroup                  *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_AddUsersToChatterGroup        *
**********************************************************************************/

@isTest(seeAllData=true)
public class Test_EPMS_AddUsersToChatterGroup{

    static testMethod void createChatterFromUser(){
        
        
        Profile profile = [select id from Profile where Name = 'System Administrator'];
        Profile profile2 = [select id from Profile where Name = 'Team Leader'];
        UserRole r = [SELECT Id, Name FROM UserRole WHERE Name = 'Full-time Employee'];


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
        user.UserRoleId = r.Id;
        user.Country__c = 'USA';
        insert user;
        
        
        User user2 = new User();
        user2.FirstName ='test';
        user2.LastName ='data';
        user2.Alias ='cust'; 
        user2.Username ='testusa@shinsei.com';
        user2.Email='testusa@gmail.com';
        user2.ProfileId  = profile.id;
        user2.TimeZoneSidKey='America/Los_Angeles';
        user2.LocaleSidKey='en_US';
        user2.EmailEncodingKey='UTF-8';
        user2.LanguageLocaleKey='en_US';
        user2.UserRoleId = r.Id;
        user2.Country__c = 'USA';
        insert user2;
        
        User user3 = new User();
        user3.FirstName ='test';
        user3.LastName ='data';
        user3.Alias ='cust'; 
        user3.Username ='testuserafrica@shinsei.com';
        user3.Email='testuserafrica@gmail.com';
        user3.ProfileId  = profile.id;
        user3.TimeZoneSidKey='America/Los_Angeles';
        user3.LocaleSidKey='en_US';
        user3.EmailEncodingKey='UTF-8';
        user3.LanguageLocaleKey='en_US';
        user3.UserRoleId = r.Id;
        user3.Country__c = 'USA';
        insert user3;
        
        // Call the user Group class
        System.runAs(user){
            
            // Create Photo Artist 
        
            User artistUser = new User();
            artistUser.FirstName ='test';
            artistUser.LastName ='data';
            artistUser.Alias ='cust'; 
            artistUser.Username ='testuserphotArtist@shinsei.com';
            artistUser.Email='testPA@gmail.com';
            artistUser.ProfileId  = profile2.id;
            artistUser.TimeZoneSidKey='America/Los_Angeles';
            artistUser.LocaleSidKey='en_US';
            artistUser.EmailEncodingKey='UTF-8';
            artistUser.LanguageLocaleKey='en_US';
            //artistUser.UserRoleId = r.Id;
            artistUser.Country__c = 'USA';
            insert artistUser;

           

            
            
            List<CollaborationGroup> newCGList = new List<CollaborationGroup>();
            CollaborationGroup  cGroup = new CollaborationGroup();
            cGroup.Name = 'Sales Region India';
            cGroup.CollaborationType = 'Private';
            cGroup.CanHaveGuests = false;
            cGroup.IsArchived = false;
            cGroup.IsAutoArchiveDisabled = true;
            newCGList.add(cGroup);
            
            CollaborationGroup  cGroup2 = new CollaborationGroup();
            cGroup2.Name = 'Sales Region Japan';
            cGroup2.CollaborationType = 'Private';
            cGroup2.CanHaveGuests = false;
            cGroup2.IsArchived = false;
            cGroup2.IsAutoArchiveDisabled = true;
            newCGList.add(cGroup2);
            
            CollaborationGroup  cGroup3 = new CollaborationGroup();
            cGroup3.Name = 'Sales Region Africa';
            cGroup3.CollaborationType = 'Private';
            cGroup3.CanHaveGuests = false;
            cGroup3.IsArchived = false;
            cGroup3.IsAutoArchiveDisabled = true;
            newCGList.add(cGroup3);
            
            if(newCGList.size() > 0){
                //insert newCGList;
            }

            Set<Id> userSets = new Set<Id>();
            userSets.add(artistUser.Id);
            
            // Call 1
            EPMS_AddUsersToChatterGroup.addToMainGroup(userSets);
            
        }
        
         System.runAs(user2){
             
             User u1=[select id,name from user where FirstName ='test' limit 1];
            
            // Create Photo Artist 
             User artistUser1 = new User();
            artistUser1.FirstName ='test';
            artistUser1.LastName ='data';
            artistUser1.Alias ='cust'; 
            artistUser1.Username ='testuserphotArtist1@shinsei.com';
            artistUser1.Email='testPA1@gmail.com';
            artistUser1.ProfileId  = profile2.id;
            artistUser1.TimeZoneSidKey='America/Los_Angeles';
            artistUser1.LocaleSidKey='en_US';
            artistUser1.EmailEncodingKey='UTF-8';
            artistUser1.LanguageLocaleKey='en_US';
            //artistUser1.UserRoleId = r.Id;
            artistUser1.Country__c = 'USA';
            insert artistUser1;
            
             Set<Id> userSets2 = new Set<Id>();
            userSets2.add(artistUser1.Id);
             userSets2.add(u1.Id);
            
        
            // Call 2
            EPMS_AddUsersToChatterGroup.addToMainGroup(userSets2);
        }
        
        
         System.runAs(user3){
            
            User artistUser2 = new User();
            artistUser2.FirstName ='test1';
            artistUser2.LastName ='data';
            artistUser2.Alias ='cust'; 
            artistUser2.Username ='testuserphotArtist2@shinsei.com';
            artistUser2.Email='testPA2@gmail.com';
            artistUser2.ProfileId  = profile2.id;
            artistUser2.TimeZoneSidKey='America/Los_Angeles';
            artistUser2.LocaleSidKey='en_US';
            artistUser2.EmailEncodingKey='UTF-8';
            artistUser2.LanguageLocaleKey='en_US';
            //artistUser2.UserRoleId = r.Id;
            artistUser2.Country__c = 'USA';
            insert artistUser2;
            
            
            
            Set<Id> userSets3 = new Set<Id>();
            userSets3.add(artistUser2.Id);
            
            // Call 3
            EPMS_AddUsersToChatterGroup.addToMainGroup(userSets3);
            artistUser2.Country__c = 'USA';
            update artistUser2;
            EPMS_AddUsersToChatterGroup.addToMainGroup(userSets3);
            
         }  
    }

}