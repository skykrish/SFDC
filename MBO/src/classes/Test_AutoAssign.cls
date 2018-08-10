/**********************************************************************************
*   Class               :       Test_AutoAssign                                       *
*   Created Date        :       23/01/2018                                           *           
*   Description         :       Test class for AutoAssign                           *
**********************************************************************************/
@istest
public class Test_AutoAssign {
    
    static testMethod void TestAutoAssign() {
        
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
        
        system.runAs(user){ 
            
            Location__c location = new Location__c();
            location.Name ='Media BackOffice Test2';
            location.Location_Country__c='india';
            location.Location_Status__c='Active';
            location.Group_Name__c='Media Backoffice Test2';
            insert location;
            
            Shift__c shift = new Shift__c();
            shift.Status__c='Active';
            shift.Name = '1st Shift - Phase 2';
            shift.Shift_Location__c = location.Id;
            shift.Implements_From__c = system.now().addDays(3);
            shift.Shift_Start_Time__c = system.now();
            shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
            insert shift;
            
            Team__c team = new Team__c();
            team.Name='testname';
            team.Location__c=location.id;             
            insert team;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='I';
            insert testRecord;
            
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='davidMoore@mbo.in';
            insert usermail;
            
            Member__c Member1 = new Member__c();
            Member1.Name='testname';
            Member1.Location_id__c=location.id;            
            Member1.Designation__c='Team Leader';
            member1.Email__c='testQC@gmail.com';
            member1.country__C='India';
            member1.Team_id__C=team.id;
            Member1.User_Id__c=user.id;
            Member1.Current_Shift__c='1st Shift - Phase 2';
            member1.First_Name__c='Subbu';
            member1.Last_Name__c='QC TEST';
            Member1.Team_Id__c=Team.id;
            Member1.Status__c='Active';
            Member1.Current_Shift__c=Shift.Name;
            Member1.Designation__c=Label.EPMS_MEMBER_DESIG_OPERATOR_PS;
            insert Member1;
            
            Member__c Member = new Member__c();
            Member.Name='testname';
            Member.Location_id__c=location.id;            
            Member.Designation__c='Team Leader';
            member.Email__c='testQC@gmail.com';
            member.country__C='India';
            member.Team_id__C=Member1.Team_Id__c;
            Member.User_Id__c=user.id;
            Member.Current_Shift__c='1st Shift - Phase 2';
            member.First_Name__c='Subbu';
            member.Last_Name__c='QC TEST';
            Member.Team_Id__c=Team.id;
            Member.Status__c='Active';
            Member.Current_Shift__c=Shift.Name;
            Member.Designation__c=Label.EPMS_MEMBER_DESIG_OPERATOR_PS;
            insert Member;
            
            Member__c Membertest = new Member__c();
            Membertest.Name='testname11';
            Membertest.Location_id__c=location.id;            
          //  Membertest.Designation__c='Quality Control';
            Membertest.Email__c='testQC12@gmail.com';
            Membertest.country__C='India';
            Membertest.Team_Id__c=Team.id;
            
            Membertest.Current_Shift__c='1st Shift - Phase 2';
           
            Membertest.First_Name__c='Subbu';
            Membertest.Last_Name__c='QC TEST112';
            Membertest.Team_Id__c=Member1.Team_Id__c;
            Membertest.Status__c='Active';
            Membertest.Current_Shift__c=Shift.Name;
            Membertest.Designation__c='Team Leader';
            insert Membertest;
            
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
            po.Production_Order_Status__c='New';
            po.QC_Incharge__c    =Membertest.Id;
            po.TL_Incharge__c=member.Id;
            insert po;
            
            production_order__c po1 = new production_order__C();
            po1.Name='test order2';
            po1.Mbo_Location__c =location.id;
            po1.Production_Order_Status__c='New';
            po1.QC_Incharge__c    =Membertest.Id;
            po1.TL_Incharge__c=member.Id;
           po1.TLuseridR1__c=member.Id;
            insert po1;
            
            List<Files__c> newFilesList = new List<Files__c>();
            for(Integer i=0;i<5;i++){
                Files__c file = new Files__c();
                file.Name = 'Files_No_'+i+'.jpg';
                if(i < 3){
                    file.Status__c = 'New';
                } else {
                    file.Status__c = 'WIP';
                }
                file.Current_Extension__c = '.jpg';
                file.File_Location__c = location.id;
                file.Production_Order__c = po.Id;
                file.File_Type__c='Image';
                file.Member__c=member.id;
                
                newFilesList.add(file);
            }
            insert newFilesList;
            
            List<Files__c> newFilesList2 = new List<Files__c>();
            for(Integer i=0;i<191;i++){
                Files__c file = new Files__c();
                file.Name = 'Files_No_'+i+'.jpg';
                if(i < 3){
                    file.Status__c = 'Assigned';
                } else {
                    file.Status__c = 'WIP';
                }
                file.Current_Extension__c = '.jpg';
                file.File_Location__c = location.id;
                file.File_Type__c='Image';
                file.Production_Order__c = po1.Id;
                file.Member__c=member.id;
                
                newFilesList2.add(file);
            }
            insert newFilesList2;
            
            Apexpages.StandardController sc = new Apexpages.standardController(po); 
            string poid=po.id+','+po1.id;
            ApexPages.currentPage().getParameters().put('ids',poid); 
            
            AutoAssign Assign1 = new AutoAssign(sc);
                       
            Assign1.ListofMembers();
            Assign1.nextPage();
            Assign1.prevPage();
            Assign1.getTotalPages();
            Assign1.getDisabledPrevious();
            Assign1.getDisabledNext();
            Assign1.getFiles();
            Assign1.processSelectedFiles();
            Assign1.getMembers();
            Assign1.getEqualFileShare(10,10);
            Assign1.ShiftAssign();
            Assign1.RefreshingPageNumbers();
            Assign1.selShift='1st Shift - Phase 2';
            Assign1.Ascending();
            Assign1.Descending();
            Assign1.userCurrentTeam=Membertest.Team_Id__c;
            integer assignedFileCount=newFilesList2.size();
            
            List<selectoption> options = Assign1.getListOfTeams();
            
            PageReference pageRef1 = Page.AutoAssign;
            Test.setCurrentPage(pageRef1); 
            integer totalFiles =0;
            string fileMessage='';
            
        }  
    }
    @isTest static void TestAutoAssign1() {
        
        Profile profile = [select id from Profile where Name ='Full-time Employees (Japan)']; 
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
            
            Location__c location = new Location__c();
            location.Name ='Media BackOffice Test2';
            location.Location_Country__c='india';
            location.Location_Status__c='Active';
            location.Group_Name__c='Media Backoffice Test2';
            insert location;
            
            Shift__c shift = new Shift__c();
            shift.Status__c='Active';
            shift.Name = '1st Shift - Phase 2';
            shift.Shift_Location__c = location.Id;
            shift.Implements_From__c = system.now().addDays(3);
            shift.Shift_Start_Time__c = system.now();
            shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
            insert shift;
            
            List<Team__c> teamlist = new List<Team__c>();
            Team__c team = new Team__c();
            team.Name='testname';
            team.Location__c=location.id;   
            teamlist.add(team);
            insert teamlist;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='I';
            insert testRecord;

            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='davidMoore@mbo.in';
            insert usermail;
            
            List<Member__c> MemberList = new List<Member__c>();           
            Member__c Member = new Member__c();
            Member.Name='testname';
            Member.Location_id__c=location.id;            
            Member.Designation__c='Team Leader';
            member.Email__c='testQC@gmail.com';
            member.country__C='India';
            member.Team_id__C=team.id;
            Member.User_Id__c=user.id;
            Member.Current_Shift__c='1st Shift - Phase 2';
            member.First_Name__c='Subbu';
            member.Last_Name__c='QC TEST';
            Member.Team_Id__c=Team.id;
            Member.Designation__c='Team Leader';
            Member.Designation__c='Quality Control';
            Member.Status__c='Active';
            Member.Current_Shift__c=Shift.Name;
            Member.Designation__c='Quality Control';
            MemberList.add(Member);
            insert MemberList;
            
            Member__c Membertest = new Member__c();
            Membertest.Name='testname11';
            Membertest.Location_id__c=location.id;            
            Membertest.Designation__c='Quality Control';
            Membertest.Email__c='testQC12@gmail.com';
            Membertest.country__C='India';
           
            Membertest.Team_Id__c=Team.id;
             Member.Current_Shift__c=Shift.Name;
            Membertest.Team_id__C=team.id;
            Membertest.First_Name__c='Subbu';
            Membertest.Designation__c='Team Leader';
            Membertest.Designation__c='Quality Control';
            Membertest.Last_Name__c='QC TEST112';
            Membertest.Team_Id__c=Team.id;
            Membertest.Status__c='Active';
            Membertest.Current_Shift__c=Shift.Name;
            Membertest.Designation__c='Team Leader';
            insert Membertest;
            
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
            po.Production_Order_Status__c='New';
            po.QC_Incharge__c    =Membertest.Id;
            po.TL_Incharge__c=member.Id;
            insert po;
            
            production_order__c po1 = new production_order__C();
            po1.Name='test order2';
            po1.Mbo_Location__c =location.id;
            po1.Production_Order_Status__c='New';
            po1.QC_Incharge__c    =Membertest.Id;
            po1.TL_Incharge__c=member.Id;
            insert po1;
            
            List<Files__c> newFilesList = new List<Files__c>();
            for(Integer i=0;i<5;i++){
                Files__c file = new Files__c();
                file.Name = 'Files_No_'+i+'.jpg';
                if(i < 3){
                    file.Status__c = 'WIP';
                } else {
                    file.Status__c = 'WIP';
                }
                file.Current_Extension__c = '.jpg';
                file.File_Location__c = location.id;
                file.Production_Order__c = po.Id;
                file.File_Type__c='Image';
                file.Member__c=member.id;
                
                newFilesList.add(file);
            }
            insert newFilesList;
            Files__c file;
            List<Files__c> newFilesList2 = new List<Files__c>();
            
            for(Integer i=0;i<191;i++){
                file = new Files__c();
                file.Name = 'Files_No_'+i+'.jpg';
                if(i < 3){
                    file.Status__c = 'Assigned';
                } else {
                    file.Status__c = 'Assigned';
                }
                file.Current_Extension__c = '.jpg';
                file.File_Location__c = location.id;
                file.File_Type__c='Image';
                file.Production_Order__c = po1.Id;
                file.Member__c=Membertest.id;
                
                newFilesList2.add(file);
            }
            insert newFilesList2;
            try{
                Apexpages.StandardController sc = new Apexpages.standardController(po); 
                string poid=po.id+','+po1.id;
                ApexPages.currentPage().getParameters().put('ids',poid); 
                
                AutoAssign Assign1 = new AutoAssign(sc);
            //    AutoAssign.cMember Awrap = new AutoAssign.cMember(Member,10,20);
              
              //  if(MemberList.size()>0){
                Member__c MemTeamIds=[select id,name,Team_Id__c from Member__c where id=:MemberList[0].id limit 1];
                   
                //Awrap.mem=Member;
                Assign1.ListofMembers();
                
                Assign1.nextPage();
                Assign1.prevPage();
                Assign1.getTotalPages();
                Assign1.getDisabledPrevious();
                Assign1.getDisabledNext();
                Assign1.getFiles();
                Assign1.processSelectedFiles();
                Assign1.getMembers();
                Assign1.getEqualFileShare(10,10);
                Assign1.ShiftAssign();
                Assign1.RefreshingPageNumbers();
                Assign1.selShift='1st Shift - Phase 2';
                Assign1.Ascending();
                Assign1.Descending();
                Assign1.updatePOorder();
                test.startTest();
                Assign1.getMembers();
                Assign1.selectedTeamId=new String[] {team.id};
                Assign1.getMembers();
                Assign1.dispList[0].selected=true;
               
                
                 Assign1.processSelectedFiles();
                Assign1.TLInclude=True;
                 Assign1.QCInclude=True;
                Assign1.getMembers();
                Assign1.TLInclude=False;
                 Assign1.QCInclude=False;
                Assign1.getMembers();
                Assign1.TLInclude=True;
                 Assign1.QCInclude=False;
                Assign1.TLInclude();
                Assign1.QCInclude();
                Assign1.getMembers();
                Assign1.TLInclude=False;
                 Assign1.QCInclude=True;
                Assign1.selectedMemSize=15;
                Assign1.TLInclude();
                Assign1.QCInclude();
                Assign1.AscendingRating();
                Assign1.DescendingRating();
                Assign1.getMembers();
                Assign1.selectedMemSize=15;

               
                test.stopTest();
                
                //List<selectoption> options = Assign1.getListOfTeams();
                
                PageReference pageRef1 = Page.AutoAssign;
                Test.setCurrentPage(pageRef1); 
            }catch (DMLException e){
                
            }
        } 
    }
}