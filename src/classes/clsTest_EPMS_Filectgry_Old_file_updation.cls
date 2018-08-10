/********************************************************************************
*   Trigger             :       Filecategory_Old_file_updation             *
*   Created Date        :       06/07/2017                                 *
*   Description         :       Test Class for File Category updation      *
**********************************************************************************/

@isTest
public class clsTest_EPMS_Filectgry_Old_file_updation {
    
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
        
        Team__c team3 = new Team__c();
        team3.Name='Team C';
        team3.Location__c=location.id;             
        //insert team3;
        teamlist.add(team3);
        
        Team__c team4 = new Team__c();
        team4.Name='Team D';
        team4.Location__c=location.id;             
        //insert team4;
        teamlist.add(team4);
        
        if(teamlist.size() > 0){
            insert teamlist;
        }
        
        
        List<Member__c> memberList = new List<Member__c>();
        Member__c member =new Member__c();
        member.Name='testQC';     
        member.Location_id__c=location.id;
        member.Last_Name__c='testlastQC';
        member.Email__c='testFirsttestlastQC@gmail.com';
        member.Country__c='India';
        member.Designation__c='Production Administrator';
        member.Status__c='Active';
        memberList.add(member);
        
        Member__c member2 =new Member__c();
        member2.Name='Stephen';     
        member2.Location_id__c=location.id;
        member2.Last_Name__c='Scott';
        member2.Email__c='testFirsttestlastOP@gmail.com';
        member2.Country__c='India';
        member2.Designation__c='Photo Artists';
        member2.Status__c='Active';
        member2.Performance_Rating__c = newPerGroup.Id;
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
        member13.Designation__c='Shift Administrator';
        member13.Status__c='Active';
        member13.Team_Id__c = team4.Id;
        //insert member5; 
        memberlist.add(member13);
        
        if(memberList.size() > 0){
            insert memberList;
        }
        
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
        
        
        // Create the Directory 
        List<Files__c> fileListDirectory = new List<Files__c>();
        Files__c folderfile= new Files__c();
        folderfile.Name ='testFolder';
        folderfile.Production_Order__c =po.id;
        folderfile.File_Category_Code__c =fc.id;
        folderfile.Status__c ='New';
        folderfile.File_Location__c=location.id;
        folderfile.Current_Extension__c ='.jpg';
        folderfile.File_Type__c = 'Directory';
        insert folderfile;
        
        for(Integer i=1;i<=2;i++){
            Files__c file= new Files__c();
            file.Name ='testChildFile'+i;
            file.Production_Order__c =po.id;
            file.File_Category_Code__c =fc.id;
            file.Status__c ='New';
            file.File_Location__c=location.id;
            file.Current_Extension__c ='.jpg';
            file.File_Type__c = 'Image';
            file.Parent_Id__c = folderfile.Id;
            fileListDirectory.add(file);
        }
        
        insert fileListDirectory;
        
        List<Files__c> copyfileList = new List<Files__c>();
        for(Integer i=1;i<=2;i++){
            Files__c copyfile= new Files__c();
            copyfile.Name ='testCOPPPFile'+i;
            copyfile.Production_Order__c =po.id;
            copyfile.File_Category_Code__c =fc.id;
            copyfile.Status__c ='Assigned';
            copyfile.File_Location__c=location.id;
            copyfile.Current_Extension__c ='.jpg';
            copyfile.File_Type__c = 'Image';
            copyfileList.add(copyfile);
        }
        
        Files__c copyfile2= new Files__c();
        copyfile2.Name ='copyDetailFiles';
        copyfile2.Production_Order__c =po.id;
        copyfile2.File_Category_Code__c =fc.id;
        copyfile2.Status__c ='Assigned';
        copyfile2.File_Location__c=location.id;
        copyfile2.Current_Extension__c ='.jpg';
        copyfile2.File_Type__c = 'Image';
        copyfile2.Member__c=member3.id;
        copyfileList.add(copyfile2);
        
        insert copyfileList;
        
        List<Files__c> individualFileList = new List<Files__c>();
        
        Files__c redofile= new Files__c();
        redofile.Name ='testREDOFile';
        redofile.Production_Order__c =po.id;
        redofile.File_Category_Code__c =fc.id;
        redofile.Status__c ='Redo';
        redofile.Member__c = member2.Id;
        redofile.File_Location__c=location.id;
        redofile.Current_Extension__c ='.jpg';
        redofile.File_Type__c = 'Image';
        individualFileList.add(redofile);
        
        Files__c redofile1= new Files__c();
        redofile1.Name ='testREDOFile';
        redofile1.Production_Order__c =po.id;
        redofile1.File_Category_Code__c =fc.id;
        redofile1.Status__c ='Redo Re-Assigned';
        redofile1.Member__c = member2.Id;
        redofile1.File_Location__c=location.id;
        redofile1.Current_Extension__c ='.jpg';
        redofile1.File_Type__c = 'Image';
        individualFileList.add(redofile1);
        
        Files__c unassignfile= new Files__c();
        unassignfile.Name ='testunassignFile';
        unassignfile.Production_Order__c =po.id;
        unassignfile.File_Category_Code__c =fc.id;
        unassignfile.Status__c ='Assigned';
        unassignfile.Member__c = member2.Id;
        unassignfile.File_Location__c=location.id;
        unassignfile.Current_Extension__c ='.jpg';
        unassignfile.File_Type__c = 'Image';
        individualFileList.add(unassignfile);
        
        Files__c unassignfileInv = new Files__c();
        unassignfileInv.Name ='testunassignFileInv';
        unassignfileInv.Production_Order__c =po.id;
        unassignfileInv.File_Category_Code__c =fc.id;
        unassignfileInv.Status__c ='Redo Re-Assigned';
        unassignfileInv.Member__c = null;
        unassignfileInv.File_Location__c=location.id;
        unassignfileInv.Current_Extension__c ='.jpg';
        unassignfileInv.File_Type__c = 'Image';
        individualFileList.add(unassignfileInv);
        
        Files__c assignfileProper = new Files__c();
        assignfileProper.Name ='testunassignFileProper';
        assignfileProper.Production_Order__c =po.id;
        assignfileProper.File_Category_Code__c =fc.id;
        assignfileProper.Status__c ='Assigned';
        assignfileProper.Member__c = member2.Id;
        assignfileProper.File_Location__c=location.id;
        assignfileProper.Current_Extension__c ='.jpg';
        assignfileProper.File_Type__c = 'Image';
        //insert assignfileProper;
        individualFileList.add(assignfileProper);
        
        
        Files__c copyFinalfile= new Files__c();
        copyFinalfile.Name ='testFinal';
        copyFinalfile.Production_Order__c =po.id;
        copyFinalfile.File_Category_Code__c =fc.id;
        copyFinalfile.Status__c ='New';
        copyFinalfile.File_Location__c=location.id;
        copyFinalfile.Current_Extension__c ='.jpg';
        copyFinalfile.File_Type__c = 'Image';
        //insert copyFinalfile;
        individualFileList.add(copyFinalfile);
        
        Files__c copyFinalfileNew = new Files__c();
        copyFinalfileNew.Name ='testFinal';
        copyFinalfileNew.Production_Order__c =po.id;
        copyFinalfileNew.File_Category_Code__c =fc.id;
        copyFinalfileNew.Status__c ='QC';
        copyFinalfileNew.Redo_Checked_Same_Member__c=false;
        copyFinalfileNew.File_Location__c=location.id;
        copyFinalfileNew.Current_Extension__c ='.jpg';
        copyFinalfileNew.File_Type__c = 'Image';
        //insert copyFinalfile;
        individualFileList.add(copyFinalfileNew);
        
        if(individualFileList.size() > 0){
            insert individualFileList;
        }
        
        copyFinalfileNew.Status__c ='QC';
        copyFinalfileNew.Redo_Checked_Same_Member__c=false;
        copyFinalfileNew.Name ='testFinal';
        
        update copyFinalfileNew;
        
        
    }       
    static testMethod void testOperatorAssignment6(){
        
        //Test.startTest();
        PageReference pageRef = Page.EPMS_Operator_File_Assignment;
        // Re-assign member from Files
        String type6 = 'unassign';
        Test.setCurrentPage(pageRef);
        // un-assign member from Files
        Files__c unassignfile = [SELECT Id, Name,File_Category_Code__c FROM Files__c WHERE Name = 'testunassignFile' ];
        pageRef.getParameters().put('ids',unassignfile.id);
        pageRef.getParameters().put('type',type6);
        Test.startTest();
        Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
        EPMS_Operator_Assignment_Controller assignment6 = new EPMS_Operator_Assignment_Controller();
        
        // File Assignment - Assignment Test
        string selectvalue6=location.Id;
        
        assignment6.getShifts();
        assignment6.getTeams();
        assignment6.getAvailableTeamLeaders();
        assignment6.getAssignmentDetails();
        
        assignment6.selectvalue=location.Id;           
        assignment6.CurrentTeams = team.Id;
        assignment6.setUnAssignMember = true; 
        assignment6.assign_save();
        Test.stopTest();
        
    }
    
}