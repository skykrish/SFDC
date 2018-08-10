/**********************************************************************************
*   Class               :       Test_EPMS_CreationOfTask                              *
*   Created Date        :       17/04/2018                                           *           
*   Description         :       Test class for EPMS_CreationOfTask                  *
**********************************************************************************/
@isTest
public class Test_EPMS_CreationOfTask {
      
   
    static testMethod void EPMS_CreationOfTask1() {
        
        List <Contact> contacts = new List <Contact>();
        List <Task> tasks = new List <Task>();
        List<String> RoleNames=new List<String>();
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        UserRole r1 = new UserRole(DeveloperName = 'MyCustomRoles', Name = 'Role');
        insert r1;
        
        RoleNames.add(r.Name);
        RoleNames.add(r1.Name);
        
        List<User> userList = new List<User>();
        Profile profile = [select id from Profile where Name ='system administrator']; 
        User user = new User();
        user.FirstName ='test';
        user.LastName ='data';
        user.Alias ='cust'; 
        user.Username ='testuser@mbo.com';
        user.Email='test@gmail.com';
        user.ProfileId  = profile.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        user.UserRoleId = r.Id;
        userList.add(user);
        
        try {
            if(userList != null && userList.size()>0) {
                insert userList;  
            }
            
        }catch(exception e) {
            
        }
        Test.StartTest();
        Try {
            EPMS_CreationOfTask BatchCreate = new EPMS_CreationOfTask(RoleNames,RoleNames,RoleNames,'Test','New','Ex','Text new value','Text','Po1',True,system.now());
            BatchCreate.start(null);
            BatchCreate.execute(null, userList);
            BatchCreate.finish(null);            
            
        }catch(Exception e) {
            
        }
        
        Test.StopTest();
        
        List<Task> taskResult = [SELECT ID From TASK limit 200];
    }
}