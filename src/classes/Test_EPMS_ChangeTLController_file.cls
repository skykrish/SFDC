/**********************************************************************************
*   Class               :       Test_EPMS_ChangeTLController_file                 *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_ChangeTLController            *
**********************************************************************************/

@isTest
public class Test_EPMS_ChangeTLController_file {
    
    static testmethod void test_EPMS_ChangeTLController_file_SYSAdmin1() {
        
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
        insert user;
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        Location__c location = new Location__c();
        location.Name ='Media BackOffice Test';
        location.Location_Country__c='India';
        location.Location_Status__c='Active';
        location.Group_Name__c='Media BackOffice Test';
        insert location;
        
        Shift__c shift = new Shift__c();
        shift.Status__c='Active';
        shift.Name = 'testing Shift';
        shift.Shift_Location__c = location.Id;
        shift.Implements_From__c = system.now().addDays(3);
        shift.Shift_Start_Time__c = system.now();
        shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
        insert shift; 
        
        Team__c team = new Team__c();
        team.Name='Testing Name';
        team.Location__c=location.id;             
        insert team;
        
        Member__c Member = new Member__c();
        Member.User_Id__c=user.id;     
        Member.Name='testnamfffe';
        Member.Location_id__c=location.id;            
        Member.Designation__c='Team Leader';
        member.Email__c='testTLf@gmail.com';
        member.country__C='India';
        member.Team_id__C=team.id;
        member.First_Name__c='NewTest';
        member.Last_Name__c='TL TEST';
        insert Member;
        
        Member__c MemberQC = new Member__c();
        MemberQC.User_Id__c=user.id;     
        MemberQC.Name='testname_QC';
        MemberQC.Location_id__c=location.id;            
        MemberQC.Designation__c='Quality Control';
        MemberQC.Email__c='testQC@gmail.com';
        MemberQC.country__C='India';
        MemberQC.Team_id__C=team.id;
        MemberQC.First_Name__c='Vijay';
        MemberQC.Last_Name__c='QC TEST';
        insert MemberQC;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testsubra@mbo.in';
        insert usermail;
        
        Employee_Country_Code__c tRecord= new Employee_Country_Code__c();
        tRecord.Name='India';
        tRecord.Country_Initial_Letter__c='M';
        insert tRecord;
        
        Shift_Assignments__c shiftass=new Shift_Assignments__c();
        shiftass.Shift_Code__c=shift.id;
        shiftass.Member__c=Member.id;
        shiftass.Location__c=location.id;
        shiftass.FromTime__c=system.today();
        shiftass.Shift_Assigned__c=true;
        insert shiftass;
        
        production_order__c po = new production_order__C();
        po.Name='test order1';
        po.Mbo_Location__c =location.id;
        po.Production_Order_Status__c = 'New';
        po.TLQCusers__c = Member.User_Id__c;
        po.qcId__c = MemberQC.User_Id__c;
        insert po;
        
        Files__c file = new Files__c();
        file.Production_Order__c=po.id;
        file.Name='TestFA';
        file.Status__c='TBI';
        file.Member__c=member.Id;            
        file.Current_Extension__c='.jpg';
        file.File_Type__c = 'Image';
        insert file;
        
        
        Apexpages.StandardController sctr = new Apexpages.standardController(file); 
        
        string poid1=file.id;
        ApexPages.currentPage().getParameters().put('ids',poid1); 
        EPMS_ChangeTLController_file TLCont = new EPMS_ChangeTLController_file(sctr);
        system.debug('TLCont.Orderid'+TLCont.Orderid);
        TLCont.selShift=shiftass.id;
        TLCont.selTeam= team.id;
        TLCont.selTL=Member.id;
        TLCont.changeTeam();

        system.runAs(user){ 
            
            Apexpages.StandardController sc = new Apexpages.standardController(file); 
            string poid=file.id;
            ApexPages.currentPage().getParameters().put('ids',poid); 
            EPMS_ChangeTLController_file TLC = new EPMS_ChangeTLController_file(sc);
            system.debug('TLC.Orderid'+TLC.Orderid);
            TLC.selShift=shiftass.id;
            TLC.selTeam= team.id;
            TLC.selTL=Member.id;
            TLC.changeTeam();
            
            set<id> tt = TLC.MemteamIds;
            set<id> teamids = TLC.teamIds;
            
            
            list<selectoption> ls=  TLC.shiftNames;
            list<selectoption> ls1= TLC.teamNames;
            list<selectoption> ls2= TLC.TLNames;
            
            PageReference pg = TLC.saveChanges();
            PageReference pg1 = TLC.changeShift();
            
            TLC.selTeam= team.id;
            TLC.selTL=Member.id;
            TLC.saveChanges();
            
        }
    }
    

    static testmethod void test_EPMS_ChangeTLController_file_SYSAdmin1_NoSelShift() {
        
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
        insert user;
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        Location__c location = new Location__c();
        location.Name ='Media BackOffice Test';
        location.Location_Country__c='India';
        location.Location_Status__c='Active';
        location.Group_Name__c='Media BackOffice Test';
        insert location;
        
        Shift__c shift = new Shift__c();
        shift.Status__c='Active';
        shift.Name = 'testing Shift';
        shift.Shift_Location__c = location.Id;
        shift.Implements_From__c = system.now().addDays(3);
        shift.Shift_Start_Time__c = system.now();
        shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
        insert shift; 
        
        Team__c team = new Team__c();
        team.Name='Testing Name';
        team.Location__c=location.id;             
        insert team;
        
        Member__c Member = new Member__c();
        Member.User_Id__c=user.id;     
        Member.Name='testnamfffe';
        Member.Location_id__c=location.id;            
        Member.Designation__c='Team Leader';
        member.Email__c='testTLf@gmail.com';
        member.country__C='India';
        member.Team_id__C=team.id;
        member.First_Name__c='NewTest';
        member.Last_Name__c='TL TEST';
        insert Member;
        
        Member__c MemberQC = new Member__c();
        MemberQC.User_Id__c=user.id;     
        MemberQC.Name='testname_QC';
        MemberQC.Location_id__c=location.id;            
        MemberQC.Designation__c='Quality Control';
        MemberQC.Email__c='testQC@gmail.com';
        MemberQC.country__C='India';
        MemberQC.Team_id__C=team.id;
        MemberQC.First_Name__c='Vijay';
        MemberQC.Last_Name__c='QC TEST';
        insert MemberQC;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testsubra@mbo.in';
        insert usermail;
        
        Employee_Country_Code__c tRecord= new Employee_Country_Code__c();
        tRecord.Name='India';
        tRecord.Country_Initial_Letter__c='M';
        insert tRecord;
        
        Shift_Assignments__c shiftass=new Shift_Assignments__c();
        shiftass.Shift_Code__c=shift.id;
        shiftass.Member__c=Member.id;
        shiftass.Location__c=location.id;
        shiftass.FromTime__c=system.today();
        shiftass.Shift_Assigned__c=true;
        insert shiftass;
        
        production_order__c po = new production_order__C();
        po.Name='test order1';
        po.Mbo_Location__c =location.id;
        po.Production_Order_Status__c = 'New';
        po.TLQCusers__c = Member.User_Id__c;
        po.qcId__c = MemberQC.User_Id__c;
        insert po;
        
        Files__c file = new Files__c();
        file.Production_Order__c=po.id;
        file.Name='TestFA';
        file.Status__c='TBI';
        file.Member__c=member.Id;            
        file.Current_Extension__c='.jpg';
        file.File_Type__c = 'Image';
        insert file;
        
        
        Apexpages.StandardController sctr = new Apexpages.standardController(file); 
        
        string poid1=file.id;
        ApexPages.currentPage().getParameters().put('ids',poid1); 
        EPMS_ChangeTLController_file TLCont = new EPMS_ChangeTLController_file(sctr);
        system.debug('TLCont.Orderid'+TLCont.Orderid);
        TLCont.selShift=shiftass.id;
        TLCont.selTeam= team.id;
        TLCont.selTL=Member.id;
        TLCont.changeTeam();

        system.runAs(user){ 
            
            Apexpages.StandardController sc = new Apexpages.standardController(file); 
            string poid=file.id;
            ApexPages.currentPage().getParameters().put('ids',poid); 
            EPMS_ChangeTLController_file TLC = new EPMS_ChangeTLController_file(sc);
            system.debug('TLC.Orderid'+TLC.Orderid);
            TLC.selShift=shiftass.id;
            TLC.selTeam= team.id;
            TLC.selTL=Member.id;
            TLC.changeTeam();
            
            set<id> tt = TLC.MemteamIds;
            set<id> teamids = TLC.teamIds;
            
            
            list<selectoption> ls=  TLC.shiftNames;
            list<selectoption> ls1= TLC.teamNames;
            list<selectoption> ls2= TLC.TLNames;
            
            PageReference pg = TLC.saveChanges();
            PageReference pg1 = TLC.changeShift();
            
            TLC.selTeam= team.id;
            TLC.selTL=Member.id;
            TLC.saveChanges();
            
        }
    }

    static testmethod void test_EPMS_ChangeTLController_file_SYSAdmin_NoSelTeam() {
        
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
        insert user;
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        Location__c location = new Location__c();
        location.Name ='Media BackOffice Test';
        location.Location_Country__c='India';
        location.Location_Status__c='Active';
        location.Group_Name__c='Media BackOffice Test';
        insert location;
        
        Shift__c shift = new Shift__c();
        shift.Status__c='Active';
        shift.Name = 'testing Shift';
        shift.Shift_Location__c = location.Id;
        shift.Implements_From__c = system.now().addDays(3);
        shift.Shift_Start_Time__c = system.now();
        shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
        insert shift; 
        
        Team__c team = new Team__c();
        team.Name='Testing Name';
        team.Location__c=location.id;             
        insert team;
        
        Member__c Member = new Member__c();
        Member.User_Id__c=user.id;     
        Member.Name='testnamfffe';
        Member.Location_id__c=location.id;            
        Member.Designation__c='Team Leader';
        member.Email__c='testTLf@gmail.com';
        member.country__C='India';
        member.Team_id__C=team.id;
        member.First_Name__c='NewTest';
        member.Last_Name__c='TL TEST';
        insert Member;
        
        Member__c MemberQC = new Member__c();
        MemberQC.User_Id__c=user.id;     
        MemberQC.Name='testname_QC';
        MemberQC.Location_id__c=location.id;            
        MemberQC.Designation__c='Quality Control';
        MemberQC.Email__c='testQC@gmail.com';
        MemberQC.country__C='India';
        MemberQC.Team_id__C=team.id;
        MemberQC.First_Name__c='Vijay';
        MemberQC.Last_Name__c='QC TEST';
        insert MemberQC;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testsubra@mbo.in';
        insert usermail;
        
        Employee_Country_Code__c tRecord= new Employee_Country_Code__c();
        tRecord.Name='India';
        tRecord.Country_Initial_Letter__c='M';
        insert tRecord;
        
        Shift_Assignments__c shiftass=new Shift_Assignments__c();
        shiftass.Shift_Code__c=shift.id;
        shiftass.Member__c=Member.id;
        shiftass.Location__c=location.id;
        shiftass.FromTime__c=system.today();
        shiftass.Shift_Assigned__c=true;
        insert shiftass;
        
        production_order__c po = new production_order__C();
        po.Name='test order1';
        po.Mbo_Location__c =location.id;
        po.Production_Order_Status__c = 'New';
        po.TLQCusers__c = Member.User_Id__c;
        po.qcId__c = MemberQC.User_Id__c;
        insert po;
        
        Files__c file = new Files__c();
        file.Production_Order__c=po.id;
        file.Name='TestFA';
        file.Status__c='TBI';
        file.Member__c=member.Id;            
        file.Current_Extension__c='.jpg';
        file.File_Type__c = 'Image';
        insert file;
        
        
        Apexpages.StandardController sctr = new Apexpages.standardController(file); 
        
        string poid1=file.id;
        ApexPages.currentPage().getParameters().put('ids',poid1); 
        EPMS_ChangeTLController_file TLCont = new EPMS_ChangeTLController_file(sctr);
        system.debug('TLCont.Orderid'+TLCont.Orderid);
        TLCont.selShift=shiftass.id;
        TLCont.selTeam= team.id;
        TLCont.selTL=Member.id;
        TLCont.changeTeam();

        system.runAs(user){ 
            
            Apexpages.StandardController sc = new Apexpages.standardController(file); 
            string poid=file.id;
            ApexPages.currentPage().getParameters().put('ids',poid); 
            EPMS_ChangeTLController_file TLC = new EPMS_ChangeTLController_file(sc);
            system.debug('TLC.Orderid'+TLC.Orderid);
            TLC.selShift=shiftass.id;
            TLC.selTeam= team.id;
            TLC.selTL=Member.id;
            TLC.changeTeam();
            
            set<id> tt = TLC.MemteamIds;
            set<id> teamids = TLC.teamIds;
            
            
            list<selectoption> ls=  TLC.shiftNames;
            list<selectoption> ls1= TLC.teamNames;
            list<selectoption> ls2= TLC.TLNames;
            
            PageReference pg = TLC.saveChanges();
            PageReference pg1 = TLC.changeShift();
            
            //TLC.selTeam= team.id;
            TLC.selTL=Member.id;
            TLC.saveChanges();
            
        }
    }
}