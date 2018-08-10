/**********************************************************************************
*   Class               :       Test_EPMS_ChangeTLController                      *
*   Created Date        :       31/07/2016                                        *           
*   Description         :       Test class for EPMS_ChangeTLController            *
**********************************************************************************/

@isTest
public class Test_EPMS_ChangeTLController {
    static testmethod void test_EPMS_ChangeTLController()
    {
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
            location.Name ='Media BackOffice Test';
            location.Location_Country__c='india';
            location.Location_Status__c='Active';
            location.Group_Name__c='Media Backoffice Test';
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


            Member__c Member = new Member__c();
            Member.Name='testname';
            Member.Location_id__c=location.id;            
            Member.Designation__c='Team Leader';
            member.Email__c='testQC@gmail.com';
            member.country__C='India';
            member.Team_id__C=team.id;
            member.First_Name__c='Subbu';
            member.Last_Name__c='QC TEST';
            insert Member;


            Member__c Membertest = new Member__c();
            Membertest.Name='testname11';
            Membertest.Location_id__c=location.id;            
            Membertest.Designation__c='Quality Control';
            Membertest.Email__c='testQC12@gmail.com';
            Membertest.country__C='India';
            Membertest.Team_id__C=team.id;
            Membertest.First_Name__c='Subbu';
            Membertest.Last_Name__c='QC TEST112';
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
                    file.Status__c = 'New';
                } else {
                    file.Status__c = 'QCIP';
                }
                file.Current_Extension__c = '.jpg';
                file.File_Location__c = location.id;
                file.Production_Order__c = po.Id;
                newFilesList.add(file);
            }
            insert newFilesList;
            
            List<Files__c> newFilesList2 = new List<Files__c>();
            for(Integer i=0;i<191;i++){
                Files__c file = new Files__c();
                file.Name = 'Files_No_'+i+'.jpg';
                if(i < 3){
                    file.Status__c = 'New';
                } else {
                    file.Status__c = 'QCIP';
                }
                file.Current_Extension__c = '.jpg';
                file.File_Location__c = location.id;
                file.Production_Order__c = po1.Id;
                newFilesList2.add(file);
            }
            insert newFilesList2;
            
            list<selectoption> shiftNames=new List<selectoption>();


            Shift__c[] shiftList=[select Name,Id from Shift__c where Location__c=:po.Mbo_Location__c];
            for(Shift__c shiftObj : shiftList) {
                shiftNames.add(new SelectOption(shiftObj .Id, shiftObj.Name));
            }


            list<selectoption> teamNames=new List<selectoption>();
            Team__c[] teamList=[select Name,Id from Team__c where Location__c=:po.Mbo_Location__c];
            
            for(Team__c teamObj : teamList) {
                teamNames.add(new SelectOption(teamObj .Id, teamObj.Name));
            }       

            Apexpages.StandardController sc = new Apexpages.standardController(po); 
            string poid=po.id+','+po1.id;
            ApexPages.currentPage().getParameters().put('ids',poid); 
            EPMS_ChangeTLController TLC = new EPMS_ChangeTLController(sc); 
            
            TLC.teamNameList=teamList;
            TLC.selTeam= team.id;
            TLC.selShift=shiftass.Shift_Code__c;
            TLC.selTL=Member.id;
            TLC.changeTeam();
            TLC.checkJobStatus();
            
            list<selectoption> ls=TLC.shiftNames;
            list<selectoption> lsrt= TLC.TLNames;
            list<member__c> qc = TLC.qc;

            PageReference pg = TLC.changeShift();
            //PageReference pg1=TLC.savechanges();

            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            //  Check that the error message you are expecting is in pageMessages
            Boolean messageFound = false;
           
            // Case 2            
            Apexpages.StandardController sc2 = new Apexpages.standardController(po1); 
            string poid2=po1.id+','+po.id;
            ApexPages.currentPage().getParameters().put('ids',poid2); 
            EPMS_ChangeTLController TLC2 = new EPMS_ChangeTLController(sc2);          
            TLC2.teamNameList=teamList;
            TLC2.selTeam= team.id;
            TLC2.selShift=shiftass.Shift_Code__c;
            TLC2.selTL=Member.id;
            TLC2.changeTeam();
            TLC2.checkJobStatus();
            
            list<selectoption> ls1=TLC.shiftNames;
            list<selectoption> lsrt1= TLC.TLNames;
            list<member__c> qc2 = TLC2.qc;

            PageReference pg2 = TLC2.changeShift();
            PageReference pg21=TLC2.savechanges();
            
            
            for(ApexPages.Message message : pageMessages) {
                if(message.getSummary() == 'Selected Qulatity (s) are Assigned for Selected Order(s)'        
                && message.getSeverity() == ApexPages.Severity.CONFIRM) {
                    messageFound = true;        
                }
            }
        }
    }
}