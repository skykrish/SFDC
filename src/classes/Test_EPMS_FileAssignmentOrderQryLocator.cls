/****************************************************************************************
*   Class               :       Test_EPMS_FileAssignmentOrderQryLocator             	*
*   Created Date        :       04/04/2018                                        		*
*   Description         :       Test Class for EPMS_File_Assignment_Order_Query_Locator * 
****************************************************************************************/

@isTest
public class Test_EPMS_FileAssignmentOrderQryLocator {
    
    @testSetup static void setupTestData(){
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='Active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='M';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testsubra@mbo.in';
        insert usermail;
        
        File_Categories__c fc= new File_Categories__c();
        fc.Name ='testFC';
        fc.Standard_Time_per_File_Min__c =11;
        fc.Standard_Time_per_File_Max__c =20;
        fc.Standard_Regular_Cost_per_File__c =934;
        fc.Standard_OptionalCost_Per_file__c =5;
        
        insert fc;
        
        Performance_Rating__c newPerGroup = new Performance_Rating__c();
        newPerGroup.File_Category__c = fc.Id;
        newPerGroup.Name = 'Group A';
        newPerGroup.File_Performance_Stf_Max__c = 150;
        newPerGroup.File_Performance_Stf_Max__c = 125;
        insert newPerGroup;
        
        List<Team__c> teamlist = new List<Team__c>();
        Team__c team = new Team__c();
        team.Name='Team B';
        team.Location__c=location.id;             
        //insert team;
        teamlist.add(team);
        
        Team__c team2 = new Team__c();
        team2.Name='Team A';
        team2.Location__c=location.id;             
        //insert team2;
        teamlist.add(team2);
        
        if(teamlist.size() > 0){
            insert teamlist;
        }
        
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
        
        List<Member__c> memberList = new List<Member__c>();
        Member__c member =new Member__c();
        member.Name='testQC';     
        member.Location_id__c=location.id;
        member.Last_Name__c='testlastQC';
        member.Email__c='testFirsttestlastQC@gmail.com';
        member.Country__c='India';
        member.User_Id__c=user.id;
        member.Designation__c='Production Administrator';
        member.Status__c='Active';
        member.Team_Id__c = team.Id;
        memberList.add(member);
        
        Member__c member2 =new Member__c();
        member2.Name='Stephen';     
        member2.Location_id__c=location.id;
        member2.Last_Name__c='Scott';
        member2.Email__c='testFirsttestlastOP@gmail.com';
        member2.Country__c='India';
        member2.Designation__c='Team Leader';
        member2.Status__c='Active';
        member2.Performance_Rating__c = newPerGroup.Id;
        member2.Team_Id__c = team.Id;
        memberList.add(member2);
        
        Member__c member3 =new Member__c();
        member3.Name='test-Artist';     
        member3.Location_id__c=location.id;
        member3.Last_Name__c='Tiger';
        member3.Email__c='testFirsttestlastOP2@gmail.com';
        member3.Country__c='India';
        member3.Designation__c='Photo Artists';
        member3.Status__c='Active';
        member3.Performance_Rating__c = newPerGroup.Id;
        member3.Team_Id__c = team.Id;
        memberList.add(member3);
        
        Member__c member12 =new Member__c();
        member12.Name='Ajith';     
        member12.Location_id__c=location.id;
        member12.Last_Name__c='Gopal';
        member12.Email__c='gopalajith@gmail.com';
        member12.Country__c='India';
        member12.Designation__c='Photo Artists';
        member12.Status__c='Active';
        member12.Team_Id__c = team.Id;
        //insert member2; 
        memberlist.add(member12);
        
        Member__c member13 =new Member__c();
        member13.Name='Dwayne';     
        member13.Location_id__c=location.id;
        member13.Last_Name__c='Hills';
        member13.Email__c='dwaynehills@gmail.com';
        member13.Country__c='India';
        member13.Designation__c='Quality control';
        member13.Status__c='Active';
        member13.Team_Id__c = team.Id;
        //insert member5; 
        memberlist.add(member13);
        
        if(memberList.size() > 0){
            insert memberList;
        }
        
        Member__c member14 =new Member__c();
        member14.Name='Krish';     
        member14.Location_id__c=location.id;
        member14.Last_Name__c='Sam';
        member14.Email__c='Krishhills@gmail.com';
        member14.Country__c='India';
        member14.Designation__c='Estimator';
        member14.Status__c='Active';
        member14.Team_Id__c = team.Id;
        insert member14;         
        
        Shift__c shift = new Shift__c();
        shift.Status__c='Active';
        shift.Name = 'testing Shift';
        shift.Shift_Location__c = location.Id;
        shift.Implements_From__c = system.now().addDays(3);
        shift.Shift_Start_Time__c = system.now();
        shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
        insert shift;
        
        Team__c team21 = new Team__c();
        team21.Name='Testing Name';
        team21.Location__c=location.id;             
        insert team21;
        
        List<Shift_Assignments__c> shiftList = new List<Shift_Assignments__c>();
        Shift_Assignments__c shiftass=new Shift_Assignments__c();
        shiftass.Shift_Code__c=shift.id;
        shiftass.Member__c=member2.id;
        shiftass.Location__c=location.id;
        shiftass.FromTime__c=system.today();
        shiftass.Shift_Assigned__c=true;
        shiftList.add(shiftass);
        
        Shift_Assignments__c shiftass1=new Shift_Assignments__c();
        shiftass1.Shift_Code__c=shift.id;
        shiftass1.Member__c=member3.id;
        shiftass1.Location__c=location.id;
        shiftass1.FromTime__c=system.today();
        shiftass1.Shift_Assigned__c=true;
        shiftList.add(shiftass1);
        
        if(shiftList.size() > 0){
            insert shiftList;
        }
        
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='testPO_22';
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        po.TLQCusers__c=member.User_Id__c;
        insert po;
        
        List<Files__c> fileList = new List<Files__c>();
        
        for(Integer i=1;i<=5;i++){
            Files__c file= new Files__c();
            file.Name ='testFile'+i;
            file.Production_Order__c =po.id;
            file.File_Category_Code__c =fc.id;
            file.Status__c ='New';
            file.File_Location__c=location.id;
            file.Current_Extension__c ='.jpg';
            file.File_Type__c = 'Image';
            fileList.add(file);
        }
        insert fileList; 
        
    }       
    
    
    static testMethod void testOperatorAssignment() {
        
        Test.StartTest();       
        EPMS_File_Assignment_Order_Query_Locator queryLocator = new EPMS_File_Assignment_Order_Query_Locator();
        
        Production_Order__c po = [SELECT Id, Name FROM Production_Order__c WHERE Name ='testPO_22'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Name = 'testFile1'];
        Location__c loc = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
        Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
        Team__c team = [SELECT Id, Name FROM Team__c WHERE Name = 'Testing Name'];
        Shift_Assignments__c sa = [SELECT Shift_Code__c, Member__c FROM Shift_Assignments__c WHERE Shift_Code__c =: shift.id Limit 1];
        Member__c member = [SELECT Id, Name FROM Member__c WHERE Name = 'Ajith'];
        Member__c estimator = [SELECT Id, Name FROM Member__c WHERE Name = 'Krish'];
        
        String shiftId = shift.id;
        
        Set<String> poIdSet = new Set<String>();
        Set<String> poNameSet = new Set<String>();
        //Set<id> poIdSet = new Set<id>();
        Set<id> fileIdSet = new Set<id>();
        Set<id> teamIdSet = new Set<id>();
        
        teamIdSet.add(team.id);
        poIdSet.add(po.id);
        poNameSet.add(po.name);
        
        String[] ids = new String[]{};
            
            for(Files__c file : fileList) {
                ids.add(file.id);
                fileIdSet.add(file.id);
            }
        
        queryLocator.getUpdateFileInformation(ids);
        queryLocator.getFileInformation(ids);
        queryLocator.getFileLocationName(loc.id);
        queryLocator.getOperatorsAssignedInShift(shiftId);
        queryLocator.getOperatorsAssignedInTeam(loc.id, shiftId);
        queryLocator.getAvailableOperatorToday(team.id, shiftId);
        queryLocator.getTeamDetails(teamIdSet);
        queryLocator.getRelatedFilesInsideSelectedDirectory(fileIdSet);
        queryLocator.getDirectoryTypeFiles(fileIdSet);
        queryLocator.getFilesLists(fileIdSet);
        queryLocator.getFilesCopyCountInFileAssignment(fileList[0].id, 'testFile1','File');
        queryLocator.getPerformanceRatingMemberInformation(member.id);			
        queryLocator.getFileList(poIdSet);
        queryLocator.getPOList(poNameSet);
        queryLocator.getpoRecords(poIdSet);
        queryLocator.getAllEstimator(loc.id);
        queryLocator.getMemberQualityControlInSelectedTeam(team.id);
        Try {
            queryLocator.getLoggedMemberInformation();           
        }catch(Exception e) {
            
        }
        Try {            
            queryLocator.getLoggedMemberShiftAssignmentInformation(member.id);
        }catch(Exception e) {
            
        }
        
        Test.stopTest(); 
        
    }
    
}