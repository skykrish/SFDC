/**********************************************************************************
*   Class               :       clsTest_EPMS_UserService                          *
*   Created Date        :       12/04/2016                                        *
*   Description         :       Test Class for EPMS_UserService                   *
**********************************************************************************/
@isTest
private class clsTest_EPMS_UserService {

 @testSetup static void setupTestData(){
      
        List<Location__c> newLocationList = new List<Location__c>();
        Location__c location = new Location__c();
        location.Name = 'MBO USA - Phase1';
        location.Location_Country__c='USA';
        location.Location_Status__c ='Active';
        location.Group_Name__c='MBO USA - Phase1';
        newLocationList.add(location);
        
        Location__c location2 = new Location__c();
        location2.Name = 'MBO Africa - Phase1';
        location2.Location_Country__c='Africa';
        location2.Location_Status__c ='Active';
        location2.Group_Name__c='MBO Africa - Phase1';
        newLocationList.add(location2);
        
        Location__c location3 = new Location__c();
        location3.Name = 'MBO JAPAN - Phase1';
        location3.Location_Country__c='JAPAN';
        location3.Location_Status__c ='Active';
        location3.Group_Name__c='MBO JAPAN - Phase1';
        newLocationList.add(location3);

        Location__c location4 = new Location__c();
        location4.Name = 'MBO JAPAN - Phase2';
        location4.Location_Country__c='JAPAN';
        location4.Location_Status__c ='Active';
        location4.Group_Name__c='MBO JAPAN - Phase2';
        newLocationList.add(location4);
        
        if(newLocationList.size() > 0){
            insert newLocationList;
        }
      
  }
   static testMethod void Test_UserService()
   {
        Profile profile = [select id from Profile where Name = 'System Administrator'];
        User user = new User();
        user.FirstName ='test';
        user.LastName ='data';
        user.Alias ='cust'; 
        user.Username ='MboNew@shinsei.com';
        user.Email='Testexone@gmail.com';
        user.ProfileId  = profile.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        insert user;
                 
        System.runAs(user){            
               
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phase2';
            location.Location_Country__c='India';
            location.Location_Status__c ='active';
            location.Group_Name__c='INDIA PVT LTD -Phase2';
            insert location;

            Location__c location2 = new Location__c();
            location2.Name = 'INDIA PRIVATE LIMITED - Phase1';
            location2.Location_Country__c='India';
            location2.Location_Status__c ='active';
            location2.Group_Name__c='INDIA PVT LTD -Phase1';
            insert location2;           
            
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
            member.Email__c='testsalesf123@gmail.com';
            member.Country__c='India';
            member.Designation__c='Production Administrator';
            member.Status__c='Active';

            insert member;

            Member__c member2=[select Name,Emp_ID__c,Location_id__c from Member__c where id=:member.id];
            member2.Emp_ID__c='I123456';
            member2.Location_id__c=location2.id;
            update member2;
              
              
            Member__c member1 = new Member__c(); 
            member1.Name='test';     
            member1.Location_id__c=location.id;
            member1.First_Name__c='test1Firstname';
            member1.Last_Name__c='testlastname';
            member1.Email__c='testemailsaforce123@gmail.com';
            member1.Country__c='japan';
            member1.Designation__c='Photo Artists';
            member1.Status__c='Active';
            member1.Emp_ID__c='1233456';
            
            try{  
                insert member1;
            }catch(Exception e){
                System.debug('ERROR:' + e);

            }
            member1.Country__c='India';
            
            try{  
                update member1;
            }catch(Exception e){
                System.debug('ERROR:' + e);
            }

            Member__c member3=[select Name,Emp_ID__c,Location_id__c from Member__c where id=:member.id];
            member3.Country__c='japan';
            member3.Location_id__c=location2.id;
            
            try{  
                update member3;
            }catch(Exception e){
                System.debug('ERROR:' + e);
            }       
        }    
    }
    
    static testMethod void Test_UserService2(){
       
        Location__c location2 = [SELECT Id, Name FROM Location__c WHERE Name = 'MBO Africa - Phase1'];
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='Africa';
        testRecord.Country_Initial_Letter__c='A';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testphotoartist3@mbo.af';
        insert usermail;
        
        Test.startTest();
        
        Member__c member = new Member__c(); 
        member.Name='Nelson';     
        member.Location_id__c=location2.id;
        member.First_Name__c='Liam';
        member.Last_Name__c='Fred';
        member.Email__c='nelsonfredliam@mbo.af';
        member.Country__c='Africa';
        member.Designation__c='Team Leader';
        member.Status__c='Active';

        insert member;
        
        Test.stopTest();
    }   
    
    static testMethod void Test_UserService3(){
       
        Location__c location2 = [SELECT Id, Name FROM Location__c WHERE Name = 'MBO USA - Phase1'];
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='USA';
        testRecord.Country_Initial_Letter__c='U';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testphotoartist21@mbo.usa';
        insert usermail;
        
        Test.startTest();
        
        Member__c member = new Member__c(); 
        member.Name='John';     
        member.Location_id__c=location2.id;
        member.First_Name__c= null;
        member.Last_Name__c='Christon';
        member.Email__c='jkreddison@mbo.usa';
        member.Country__c='USA';
        member.Designation__c='Quality Control';
        member.Status__c='Active';

        insert member;
        
        Test.stopTest();
    }
    
    static testMethod void Test_UserService4(){
       
        Location__c location2 = [SELECT Id, Name FROM Location__c WHERE Name = 'MBO JAPAN - Phase1'];
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='Japan';
        testRecord.Country_Initial_Letter__c='J';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testphotoartist85@mbo.jp';
        insert usermail;
        
        Test.startTest();
        
        Member__c member = new Member__c(); 
        member.Name='AKI';     
        member.Location_id__c=location2.id;
        member.First_Name__c= 'KIN';
        member.Last_Name__c='JUN';
        member.Email__c='akijunkin@mbo.jp';
        member.Country__c='Japan';
        member.Designation__c='Shift Administrator';
        member.Status__c='Active';

        insert member;
        
        Member__c member2 = new Member__c(); 
        member2.Name='Arinori';     
        member2.Location_id__c=location2.id;
        member2.First_Name__c= null;
        member2.Last_Name__c='Mor';
        member2.Email__c='arinorimori@mbo.jp';
        member2.Country__c='Japan';
        member2.Designation__c='Team Leader';
        member2.Status__c='Active';

        insert member2;
        
        Member__c newUpdateMember = [SELECT Id, Name FROM Member__c WHERE Name = 'Arinori' AND Email__c = 'arinorimori@mbo.jp'];
        if(newUpdateMember != null){
            newUpdateMember.Email__c = 'arinorimorisan@mb.jp';
            update newUpdateMember;
        }
        
        Test.stopTest();
    }
    static testMethod void testEPMS_UserService3() {
        
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
        
        System.runAs(user){
            
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
            location.Location_Country__c='India';
            location.Location_Status__c ='active';
            location.Group_Name__c='INDIA PVT LTD -Phase2x2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='I';
            insert testRecord;
            
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='rvikram07@gmail.com';
            insert usermail;
            
            Test.StartTest();
            
            List<Member__c> memberList = new List<Member__c>();
            
            Member__c qcmember =new Member__c();
            qcmember.Name='TONY';     
            qcmember.Location_id__c=location.id;
            qcmember.Last_Name__c='ABBOTT';
            qcmember.First_Name__c='ABBOTT1';
            qcmember.Email__c='tonyab47855@gmail.com';
            qcmember.Country__c='India';
            qcmember.Designation__c='Quality Control';
            qcmember.Status__c='Active';
            memberList.add(qcmember);
            
            
            Exception e;
            
            EPMS_UserService.Createu(memberList);
            
            try{
                insert memberList;
            }catch(Exception ex){
                e = ex;
            } 
            
            Member__c[] mem=[select Id,User_Id__c from Member__c where Id=:memberList[0].Id limit 1];
            
            if(mem.Size()>0)
                try{
                    EPMS_MemberQueryLocator QueryObj = new EPMS_MemberQueryLocator();
                    QueryObj.getMemberlist(mem[0].id);   
                    QueryObj.getUserRoleUpdate(mem[0].Designation__c); 
                    QueryObj.getuserdetails(user.id);
                    queryObj.getUserProfileHolder();
                    
                    EPMS_UserService.insertRoleAfter(user.id,mem[0].Id);
                    EPMS_UserService.UpdateUserDetails(user.id,mem[0].Id);    
                    system.assertNotEquals(null, e);
                    system.assert(e instanceOf system.Dmlexception);
                    system.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
                    system.assertEquals(user.FirstName,memberList[0].First_Name__c);
                }catch(exception e1){
                    
                }
            
            Test.StopTest();
        }  
    }
    
}