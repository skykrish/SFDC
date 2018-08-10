/**********************************************************************************
*   Class               :       clsTest_EPMS_BatchUpdateMemAttendance             *
*   Created Date        :       02/04/2016                                        *
*   Description         :       Test Class for EPMS_BatchUpdateMemAttendance      *
**********************************************************************************/
@isTest
private class clsTest_EPMS_BatchUpdateMemAttendance{ 

    @testSetup static void setupTestData(){
            
            //Location__c newLocation = [SELECT Id, Name FROM Location__c WHERE Name ='MEDIA BACKOFFICE INDIA PRIVATE LIMITED - Phase1'];
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PRIVATE LIMITED - Phaseex2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='I';
            insert testRecord;
            
            Profile profile = [SELECT Id FROM Profile WHERE Name = 'Quality Control'];

            User user = new User();
            user.FirstName ='Peter';
            user.LastName ='James';
            user.Alias ='Jammy'; 
            user.Username ='testuser336@mbo.com';
            user.Email='test3@gmail.com';
            user.ProfileId  = profile.id;
            user.TimeZoneSidKey='America/Los_Angeles';
            user.LocaleSidKey='en_US';
            user.EmailEncodingKey='UTF-8';
            user.LanguageLocaleKey='en_US';
            insert user;
              
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testmboupdtbtch@mbo.in';
            insert usermail;
            
            
            List<Member__c> memberList= new List<Member__c>();
            
            Member__c tlMemberTest =new Member__c();
            tlMemberTest.Name='Alexandar';     
            tlMemberTest.Location_id__c=location.id;
            tlMemberTest.Last_Name__c='Fleming';
            tlMemberTest.Email__c='alexflemingldn@gmail.com';
            tlMemberTest.Country__c='India';
            tlMemberTest.Designation__c='Team Leader';
            tlMemberTest.Status__c='Active';
            tlMemberTest.Today_Attendance__c = 'NW';
            memberList.add(tlMemberTest);
            
            Member__c qcMemberTest =new Member__c();
            qcMemberTest.Name='Ramkumar S';     
            qcMemberTest.Location_id__c=location.id;
            qcMemberTest.Last_Name__c='Sundaresan';
            qcMemberTest.Email__c='ramkumarsrl05@gmail.com';
            qcMemberTest.Country__c='India';
            qcMemberTest.Designation__c='Quality Control';
            qcMemberTest.Status__c='Active';
            qcMemberTest.Today_Attendance__c = 'A';
            memberList.add(qcMemberTest);
            
            Member__c tl2MemberTest =new Member__c();
            tl2MemberTest.Name='Babu';     
            tl2MemberTest.Location_id__c=location.id;
            tl2MemberTest.Last_Name__c='Chandran';
            tl2MemberTest.Email__c='aptrstc2016@gmail.com';
            tl2MemberTest.Country__c='India';
            tl2MemberTest.Designation__c='Team Leader';
            tl2MemberTest.Status__c='Active';
            tl2MemberTest.Today_Attendance__c = 'P';
            memberList.add(tl2MemberTest);
            
            if(memberList.size() > 0){
                insert memberList;
            }
            
            
            
    }       

   static testMethod void EPMS_BatchUpdateMemAttendance()
   {
   
        Location__c loc=[select id,Name from Location__c where Name='INDIA PRIVATE LIMITED - Phaseex2'];
                
        Member__c member=[SELECT id, Status__c,Name,Designation__c,Location_Id__r.Name,Today_Attendance__c FROM Member__c 
                        WHERE Today_Attendance__c in('A','NW') AND (Id!=NULL AND Location_Id__c=:loc.Id) limit 1];
                        
        Test.startTest();
                   
        EPMS_BatchUpdateMemAttendance Attendance=new EPMS_BatchUpdateMemAttendance();
        Database.executeBatch(Attendance);
        Attendance.executeUpdateAttendance();
        Test.stopTest();
                                   
   }
}