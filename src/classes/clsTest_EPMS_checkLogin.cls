/**********************************************************************************
*   Class               :       clsTest_EPMS_checkLogin                           *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_checkLogin                    *
**********************************************************************************/
@istest
Public class clsTest_EPMS_checkLogin{
   public static testMethod void EPMS_checkLogin() {
   
       Profile profile = [select id from Profile where Name ='System Administrator']; 
            
            
            User user = new User();
            user.FirstName ='test';
            user.LastName ='data';
            user.Alias ='cust'; 
            user.Username ='testuser34555@mbo.com';
            user.Email='test@gmail.com';
            user.ProfileId  = profile.id;
            user.TimeZoneSidKey=EPMS_UTIL.EPMS_INDIA_TimeZoneSidKey;
            user.LocaleSidKey='en_US';
            user.EmailEncodingKey='UTF-8';
            user.LanguageLocaleKey='en_US';
            insert user;
            
                   
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
            location.Location_Country__c='India';
            location.Location_Status__c ='active';
            location.Group_Name__c='INDIA PVT LTD -Phase2x2';
            insert location;
            
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
              
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testphotoartist@mbo.in';
            insert usermail;
            
            Member__c member =new Member__c();
            member.Name='MARK';     
            member.Location_id__c=location.id;
            member.Last_Name__c='PHILIPS1233';
            member.Email__c='testphotoartists121212@gmail.com';
            member.Country__c='India';
            member.Enable_Login__c=true;
            member.Designation__c='Production Administrator';
            member.Status__c='Active';            
            insert member;
            
            Member__c memberHK =new Member__c();
            memberHK.Name='House Keeper';     
            memberHK.Location_id__c=location.id;
            memberHK.Last_Name__c='keeper';
            memberHK.Email__c='housekeeeper@mbotest.in';
            memberHK.Designation__c='House Keeper';
            memberHK.Status__c='Active'; 
            memberHK.Enable_Login__c=true;
            
             Exception e;
             
            test.starttest();
 
            
            
            system.runas(user){
                EPMS_checkLogin chkLogin=new EPMS_checkLogin();
                try{
                insert memberHK; 
            
            } catch(Exception ex){
                  e = ex;
            }
           // system.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
 
            }
            
            
            
          
            
            test.stoptest();
            
      }
}