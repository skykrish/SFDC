@isTest
public class Test_Epms_Remove_Order {

   @testSetup static void Test_Epms_Remove_Order(){
    
        
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
        
         Profile profileQC = [select id from Profile where Name ='Quality Control'];         
        User userqc = new User();
        userqc.FirstName ='test';
        userqc.LastName ='data';
        userqc.Alias ='cust'; 
        userqc.Username ='testuserQC@mbo.com';
        userqc.Email='test@gmail.com';
        userqc.ProfileId  = profileQC.id;
        userqc.TimeZoneSidKey='America/Los_Angeles';
        userqc.LocaleSidKey='en_US';
        userqc.EmailEncodingKey='UTF-8';
        userqc.LanguageLocaleKey='en_US';
        insert userqc;
        
         Profile profileTL = [select id from Profile where Name ='Team Leader'];         
        User userTL = new User();
        userTL.FirstName ='test';
        userTL.LastName ='data';
        userTL.Alias ='cust'; 
        userTL.Username ='testuserTL@mbo.com';
        userTL.Email='test@gmail.com';
        userTL.ProfileId  = profileTL.id;
        userTL.TimeZoneSidKey='America/Los_Angeles';
        userTL.LocaleSidKey='en_US';
        userTL.EmailEncodingKey='UTF-8';
        userTL.LanguageLocaleKey='en_US';
        insert userTL;
        
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
        Member.User_Id__c=userTL.id;     
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
        MemberQC.User_Id__c=userqc.id;     
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
        po.TLuseridR1__c=userTL.id;
        po.QCidr1__c=userqc.id;
        po.TLuseridR2__c=userTL.id;
        po.QCidr2__c=userqc.id;
        insert po;
        
        Files__c file2 = new Files__c();
        file2.Production_Order__c=po.id;
        file2.Name='Test';
        file2.Status__c='Assigned';
        file2.Member__c=member.Id;            
        file2.Current_Extension__c='.jpg';
        file2.File_Type__c = 'Image';
        file2.TLInCharge__c=member.id;
        file2.QCInCharge__c=MemberQC.id;
        insert file2;
        
        Files__c file = new Files__c();
        file.Production_Order__c=po.id;
        file.Name='TestFA123';
        file.Status__c='TBI';
        file.Member__c=member.Id;            
        file.Current_Extension__c='.jpg';
        file.File_Type__c = 'Image';
        file.TLInCharge__c=member.id;
        file.QCInCharge__c=MemberQC.id;
        insert file;
        
         Files__c filesApproved = new Files__c();
        filesApproved.Production_Order__c=po.id;
        filesApproved.Status__c='Approved';
        filesApproved.Member__c=member.Id;    
        filesApproved.id=file.id;
        filesApproved.Current_Extension__c='.jpg';
        filesApproved.File_Type__c = 'Image';
        update filesApproved;
        
        
        
        }
		
		    static testmethod void test_EPMS_RemoveOrder2(){
			Production_Order__c polist= [select id,name from production_order__c where name='test order1' limit 1];
			Files__c files=[select id,name,Status__c from Files__c where name='Test' limit 1];
			
			
			
		Files__c file3 = new Files__c();
        file3.Production_Order__c=polist.id;
        file3.Status__c='Approved';
        file3.id=files.id;
        Update file3;
			
			
			}

		
		
		
		
		
        }