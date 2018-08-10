/**********************************************************************************
*   Class               :       Test_EPMS_TaskDistributionCaseLogs                       *
*   Created Date        :       17/04/2018                                              *           
*   Description         :       Test class for EPMS_TaskDistributionCaseLogsController *
**********************************************************************************/
@istest
public class Test_EPMS_TaskDistributionCaseLogs {
    
    static testMethod void TaskDistribute() {  
        
        test.startTest();
        Account account1 = new Account();
        account1.Name = 'Test_Account_01';
        insert account1;
        
        Account account2 = new Account();
        account2.Name = 'Test_Account_02';
        insert account2;        
        
        
        Contact contact1 = new Contact();
        contact1.LastName = 'Test_Contact_01';
        insert contact1;
        
        Contact contact2 = new Contact();
        contact2.LastName = 'Test_Contact_01';
        insert contact2;
        
        Case_Logs__c CLog = new Case_Logs__c();
        CLog.Title__c = 'New Ex';
        CLog.Disclosure_destination__c = 'India';
        insert CLog;
        
        Profile profile = [select Id from Profile limit 1];
        
        User user = new User();
        user.Username = 'Test_user_name@test.com';
        user.LastName = 'Test_last_name';
        user.ProfileId = profile.Id;
        user.Alias = 'tst';
        user.Email = 'Test_email@email.com';
        user.CommunityNickname = 'Test_nick_name';
        user.TimeZoneSidKey = 'GMT';
        user.LocaleSidKey = 'en_US';
        user.LanguageLocaleKey = 'en_US';
        user.EmailEncodingKey = 'ISO-8859-1';
        
        PageReference pPageReference = Page.EPMS_TaskDistributionCaseLogs;
        pPageReference.getParameters().put('objIds',account1.Id+','+account2.Id);
        pPageReference.getParameters().put('retUrl','');
        Test.setCurrentPage(pPageReference);
        
        PageReference pPageReference1 = Page.EPMS_AssignedTaskGroups;
        Test.setCurrentPage(pPageReference1);
        
        EPMS_TaskDistributionCaseLogsController controler = new EPMS_TaskDistributionCaseLogsController();
        //controler.save();
        controler.saveNew();
        controler.getGMTTime();
        controler.getReminderTimeOptions();
        controler.getTime('8:00 PM');
        controler.getValues();
        controler.getListValues();
        controler.selectclick();
        controler.unselectclick();
        controler.getunSelectedValues();
        controler.getSelectedValues();
        controler.refreshPage();
        controler.AssignedSave();
        controler.calculateUsers();
        controler.splitUsers();  
        controler.strlist='Group :Country Admin India,Group :Full-time Employees (Japan)';
        
        Pagereference pageRef = controler.saveNew();
        System.assertEquals(pageRef, null);
        
        Pagereference pageRef1 = controler.selectclick();
        System.assertEquals(pageRef1, null);
        
        Pagereference pageRef2 = controler.AssignedSave();
        System.assertEquals(pageRef2, null);
        
        Task tasks = new Task();
        controler.tasks.subject ='Test';
        controler.tasks.ownerid= user.id;
        controler.tasks.whatid= contact1.id;        
        controler.tasks.Description = 'Test value new';
        controler.tasks.status = 'new';
        controler.tasks.Priority = 'Test EX';
        controler.tasks.IsReminderSet = false;  
        controler.tasks.reminderdatetime = Date.today();
        
        pageRef = controler.saveNew();
        
        string subjects = controler.tasks.subject;
        string assignedTo = controler.tasks.ownerid;
        string relatedTo = controler.tasks.whatid;
        string comments = controler.tasks.Description;
        string status =controler.tasks.status;
        string Priority  =  controler.tasks.Priority;
        boolean isReminderSet  =  controler.tasks.IsReminderSet;
        DateTime ReminderDateTime = controler.tasks.reminderdatetime;
        upsert tasks;
        test.stopTest(); 
    }
}