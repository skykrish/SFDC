/**********************************************************************************
*   Class               :       Test_EPMS_ChangeQCController                      *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_ChangeQCController            *
**********************************************************************************/


@isTest
public class Test_EPMS_ChangeQCController {

    @testSetup static void setupTestData(){
    
    
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;

        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='davidMoore@mbo.in';
        insert usermail;

        Location__c location = new Location__c();
        location.Name ='Media BackOffice Test2';
        location.Location_Country__c='india';
        location.Location_Status__c='Active';
        location.Group_Name__c='Media Backoffice Test2';
        insert location;
        
        
        production_order__c po1 = new production_order__C();
        po1.Name='00201001';
        po1.Production_Order_Status__c='New';
        po1.Mbo_Location__c =location.id;
        insert po1;
         
        List<Files__c> newFilesList = new List<Files__c>();
        for(Integer i=0;i<104;i++){
            Files__c file = new Files__c();
            file.Name = 'Files_No_'+i+'.jpg';
            if(i < 20){
                file.Status__c = 'New';
            } else if (i > 25 && i < 50){
                file.Status__c = 'QC';
            } else if(i > 50 && i < 75){
                file.Status__c = 'QCIP';
            } else {
                file.Status__c = 'New';
            }
            
            file.Current_Extension__c = '.jpg';
            file.File_Location__c = location.id;
            file.Production_Order__c = po1.Id;
            newFilesList.add(file);
        }
        insert newFilesList;
        
        
        Team__c team = new Team__c();
        team.Name='Testing';
        team.Location__c=location.id;             
        insert team;

        Member__c Member = new Member__c();

        Member.Name='SRM DEMO USER 1';
        Member.Location_id__c=location.id;            
        Member.Designation__c='Quality Control';
        member.Email__c='srmdemouser1@gmail.com';
        member.country__C='India';
        member.Team_id__C=team.id;
        member.First_Name__c='SRM';
        member.Last_Name__c='10001';
        insert Member;

        Shift__c shift = new Shift__c();
        shift.Status__c='Active';
        shift.Name = '1st Shift Phase-1';
        shift.Shift_Location__c = location.Id;
        shift.Implements_From__c = system.now().addDays(3);
        shift.Shift_Start_Time__c = system.now();
        shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
        insert shift; 

        Shift_Assignments__c shiftass=new Shift_Assignments__c();
        shiftass.Shift_Code__c=shift.id;
        shiftass.Member__c=Member.id;
        shiftass.Location__c=location.id;
        shiftass.FromTime__c=system.today();
        shiftass.Shift_Assigned__c=true;
        insert shiftass;   
           
           
           
           
    
    }
    
    static testmethod void test_EPMS_ChangeQCController()
    {
        Profile profile = [select id from Profile where Name ='System Administrator']; 
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
        insert user;

        system.runAs(user){ 

        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;

        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='davidMoore@mbo.in';
        insert usermail;

        Location__c location = new Location__c();
        location.Name ='Media BackOffice Test';
        location.Location_Country__c='india';
        location.Location_Status__c='Active';
        location.Group_Name__c='Media Backoffice Test';
        insert location;


        Team__c team = new Team__c();
        team.Name='Testing Name';
        team.Location__c=location.id;             
        insert team;

        Member__c Member = new Member__c();

        Member.User_Id__c=user.id;     
        Member.Name='testname';
        Member.Location_id__c=location.id;            
        Member.Designation__c='Quality Control';
        member.Email__c='testQC@gmail.com';
        member.country__C='India';
        member.Team_id__C=team.id;
        member.First_Name__c='Subbu';
        member.Last_Name__c='QC TEST';
        insert Member;

        Shift__c shift = new Shift__c();
        shift.Status__c='Active';
        shift.Name = 'testing Shift';
        shift.Shift_Location__c = location.Id;
        shift.Implements_From__c = system.now().addDays(3);
        shift.Shift_Start_Time__c = system.now();
        shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
        insert shift; 

        Shift_Assignments__c shiftass=new Shift_Assignments__c();
        shiftass.Shift_Code__c=shift.id;
        shiftass.Member__c=Member.id;
        shiftass.Location__c=location.id;
        shiftass.FromTime__c=system.today();
        shiftass.Shift_Assigned__c=true;
        insert shiftass;

        production_order__c po = new production_order__C();
        po.Name='test order1';
        po.Production_Order_Status__c='New';    
        po.Mbo_Location__c =location.id;
        insert po;

        production_order__c po1 = new production_order__C();
        po1.Name='test order2';
        po1.Production_Order_Status__c='New';    
        po1.Mbo_Location__c =location.id;
        insert po1;
         
         List<Files__c> newFilesList = new List<Files__c>();
         for(Integer i=0;i<104;i++){
            Files__c file = new Files__c();
            file.Name = 'Files_No_'+i+'.jpg';
            if(i < 20){
                file.Status__c = 'New';
            } else if (i > 25 && i < 50){
                file.Status__c = 'QC';
            } else if(i > 50 && i < 75){
                file.Status__c = 'QCIP';
            } else {
                file.Status__c = 'New';
            }
            
            file.Current_Extension__c = '.jpg';
            file.File_Location__c = location.id;
            file.Production_Order__c = po.Id;
            newFilesList.add(file);
        }
        insert newFilesList;
        
        List<Files__c> newFilesList2 = new List<Files__c>();
        
         for(Integer i=0;i<10;i++){
            Files__c file = new Files__c();
            file.Name = 'Files_No_'+i+'.jpg';
            if(i < 2){
                file.Status__c = 'New';
            } else if (i > 2 && i < 5){
                file.Status__c = 'QC';
            } else if(i > 5 && i < 8){
                file.Status__c = 'QCIP';
            } else {
                file.Status__c = 'New';
            }
            
            file.Current_Extension__c = '.jpg';
            file.File_Location__c = location.id;
            file.Production_Order__c = po1.Id;
            newFilesList2.add(file);
        }
        insert newFilesList2;

        Apexpages.StandardController sc = new Apexpages.standardController(po); 
        string poid=po.id+','+po1.id;
        ApexPages.currentPage().getParameters().put('ids',poid); 
        EPMS_ChangeQCController TLC = new EPMS_ChangeQCController(sc);
        TLC.selTeam= team.id;
        TLC.selShift=shiftass.Shift_Code__c;
        TLC.selQC=Member.id;
        TLC.userCurrentTeam=Member.Team_Id__c;
        TLC.userCurrentShift=shiftass.id;
        TLC.changeTeam();
        
        list<selectoption> ls=TLC.shiftNames;
        list<selectoption> ls1= TLC.qcNames;
        set<id> tt = TLC.MemteamIds;
        set<id> teamids = TLC.teamIds;
        TLC.changeShift();
        PageReference pg = TLC.changeShift();
        PageReference pg1=TLC.savechanges();

        Apexpages.StandardController sc2 = new Apexpages.standardController(po1); 
        string poid2=po1.id+','+po.id;
        ApexPages.currentPage().getParameters().put('ids',poid2); 
        EPMS_ChangeQCController TLC1 = new EPMS_ChangeQCController(sc2);
        TLC1.selTeam= team.id;
        TLC1.selShift=shiftass.Shift_Code__c;
        TLC1.selQC=Member.id;
        TLC1.userCurrentTeam=Member.Team_Id__c;
        TLC1.userCurrentShift=shiftass.id;
        TLC1.changeTeam();
        
        list<selectoption> ls2=TLC1.shiftNames;
        list<selectoption> ls3= TLC1.qcNames;
        set<id> tt1 = TLC1.MemteamIds;
        set<id> teamids1 = TLC1.teamIds;
        TLC1.changeShift();
        PageReference pg0 = TLC1.changeShift();
        PageReference pg2=TLC1.savechanges();
        
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());

        //  Check that the error message you are expecting is in pageMessages
        Boolean messageFound = false;

        for(ApexPages.Message message : pageMessages) {
            if(message.getSummary() == 'Selected Team Leader(s) are Assigned for Selected Order(s)'        
            && message.getSeverity() == ApexPages.Severity.CONFIRM) {
                messageFound = true;        
            }       
        }
        }
    }
    
    static testMethod void testMethod_2(){
    
        Production_Order__c order = [SELECT Id, Name FROM Production_Order__c WHERE Name ='00201001'];
        Team__c team = [SELECT id, Name FROM Team__c WHERE Name = 'Testing'];
        Shift__c shift = [SELECT Id FROM Shift__c WHERE Name = '1st Shift Phase-1'];
        Member__c Member = [SELECT Id,Team_Id__c FROM Member__c WHERE Name='SRM DEMO USER 1'];
        Shift_Assignments__c shiftass=[SELECT Id, Name,Shift_Code__c,Member__c FROM Shift_Assignments__c WHERE Shift_Code__c =: shift.id];

        
        Test.startTest();
        Apexpages.StandardController sc2 = new Apexpages.standardController(order); 
        string poid2=order.id;
        ApexPages.currentPage().getParameters().put('ids',poid2); 
        EPMS_ChangeQCController TLC1 = new EPMS_ChangeQCController(sc2);
        TLC1.selTeam= team.id;
        TLC1.selShift=shiftass.Shift_Code__c;
        TLC1.selQC=Member.id;
        TLC1.userCurrentTeam=Member.Team_Id__c;
        TLC1.userCurrentShift=shiftass.id;
        TLC1.changeTeam();
        
        list<selectoption> ls2=TLC1.shiftNames;
        list<selectoption> ls3= TLC1.qcNames;
        set<id> tt1 = TLC1.MemteamIds;
        set<id> teamids1 = TLC1.teamIds;
        TLC1.changeShift();
        TLC1.checkJobStatus();
        PageReference pg0 = TLC1.changeShift();
        PageReference pg2=TLC1.savechanges();
        Test.stopTest();    
    }
}