/**********************************************************************************
*   Class               :       clsTest_EPMS_MemberPublicGroupService                 *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Query locator for location service class          *
**********************************************************************************/
@isTest
private class clsTest_EPMS_MemberPublicGroupService{

    @testSetup static void setupTestData(){
            
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PRIVATE LIMITED - Phaseex2';
            insert location;
            
            
            Location__c location2 = new Location__c();
            location2.Name = 'INDIA PRIVATE LIMITED - Phaseex45';
            location2.Location_Country__c='India';
            location2.Location_Status__c ='Active';
            location2.Group_Name__c='INDIA PRIVATE LIMITED - Phaseex45';
            insert location2;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='E';
            insert testRecord;
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testmbomql@mbo.in';
            insert usermail;
            List<Group> groupList = new List<Group>();
            
            Group newgroup = new Group();
            newgroup.Name = 'INDIA PRIVATE LIMITED - Phaseex45';
            groupList.add(newgroup);
            
            Group newgroup2 = new Group();
            newgroup2.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
            groupList.add(newgroup2);
            
            insert groupList;
            
            Profile profile = [SELECT Id FROM Profile WHERE Name = 'Quality Control'];

            User user = new User();
            user.FirstName ='Peter';
            user.LastName ='James';
            user.Alias ='Jammy'; 
            user.Username ='testusermql@mbo.in';
            user.Email='test3mql@mbo.in';
            user.ProfileId  = profile.id;
            user.TimeZoneSidKey='America/Los_Angeles';
            user.LocaleSidKey='en_US';
            user.EmailEncodingKey='UTF-8';
            user.LanguageLocaleKey='en_US';
            insert user;

            User user2 = new User();
            user2.FirstName ='Peter';
            user2.LastName ='Parker';
            user2.Alias ='Jammy'; 
            user2.Username ='testusermql23@mbo.in';
            user2.Email='test3mql@mbo.in';
            user2.ProfileId  = profile.id;
            user2.TimeZoneSidKey='America/Los_Angeles';
            user2.LocaleSidKey='en_US';
            user2.EmailEncodingKey='UTF-8';
            user2.LanguageLocaleKey='en_US';
            insert user2;


            
            List<Member__c> memberList= new List<Member__c>();
            
            Member__c tlMemberTest =new Member__c();
            tlMemberTest.Name='Alexandar';     
            tlMemberTest.Location_id__c=location.id;
            tlMemberTest.Last_Name__c='Fleming';
            tlMemberTest.Email__c='alexfleming@gmail.com';
            tlMemberTest.Country__c='India';
            tlMemberTest.Designation__c='Team Leader';
            tlMemberTest.Status__c='Active';
            memberList.add(tlMemberTest);
            
            Member__c qcMemberTest =new Member__c();
            qcMemberTest.Name='Ramkumar S';     
            qcMemberTest.Location_id__c=location.id;
            qcMemberTest.Last_Name__c='Sundaresan';
            qcMemberTest.Email__c='ramkumars@gmail.com';
            qcMemberTest.Country__c='India';
            qcMemberTest.Designation__c='Quality Control';
            qcMemberTest.Status__c='Active';
            memberList.add(qcMemberTest);
            
            if(memberList.size() > 0){
                insert memberList;
            }
            
           
            
        }
        
        static testmethod void locationTestCoverage(){

            List<Id> userIdsets = new List<Id>();
            List<Id> userIdsets3 = new List<Id>();
            Group groupis = [SELECT Id, Name FROM Group WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2' LIMIT 1];
            List<User> userIds = [SELECT Id, Name FROM User WHERE FirstName ='James'];
            if(userIds !=null && userIds.size() > 0){
                for(User u : userIds){
                    userIdsets.add(u.Id);                
                }
            }
            
            Group groupis3 = [SELECT Id, Name FROM Group WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex45' LIMIT 1];
            List<User> userIds3 = [SELECT Id, Name FROM User WHERE FirstName ='Peter'];
            if(userIds3 !=null && userIds3.size() > 0){
                for(User u : userIds3){
                    userIdsets3.add(u.Id);                
                }
            }
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2' LIMIT 1];
            Location__c location2 = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex45' LIMIT 1];
            Member__c tlMemberTest2 = [SELECT Id, Name, Location_id__c FROM Member__c WHERE Name ='Ramkumar S' AND Location_id__c =: location.id];
            tlMemberTest2.Location_id__c = location2.Id;
            update tlMemberTest2;
            Test.startTest();
            
            EPMS_MemberPublicGroupService.addUsersToGroup(String.valueOf(groupis.Id), userIdsets);
            EPMS_MemberPublicGroupService.UpdateUsersToGroup(String.valueOf(groupis3.Id), userIdsets3);  
            
            EPMS_MemberPublicGroupService.addUsersToGroup(String.valueOf(groupis3.Id), userIdsets3);
            EPMS_MemberPublicGroupService.UpdateUsersToGroup(String.valueOf(groupis.Id), userIdsets);     
            Test.stopTest();
        
        }
        
        
        
        
        
}