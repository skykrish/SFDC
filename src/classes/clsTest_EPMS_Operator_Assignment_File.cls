/**********************************************************************************
*   Class               :       clsTest_EPMS_Operator_Assignment_File             *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_FileOperatorAssignmentService *
**********************************************************************************/

@isTest
    public class clsTest_EPMS_Operator_Assignment_File {
        
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
            unassignfileInv.Status__c ='Assigned';
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
            
            if(individualFileList.size() > 0){
                insert individualFileList;
            }
            
        }       
        
        
        static testMethod void testOperatorAssignment() {
                PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            
            Test.StartTest();       
    
            string basepath='Order';
            string type = 'assign';
            Test.setCurrentPage(pageRef);
            
            Files__c fileList = [SELECT Id, Name FROM Files__c WHERE Name = 'testFile1'];
            
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Member__c member2 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Scott' AND Email__c='testFirsttestlastOP@gmail.com'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            Production_Order__c poList=[select id,name from Production_Order__c where Name='testPO_22'];
			
			String poids=poList.id;
			
            pageRef.getParameters().put('ids',fileList.id);
            pageRef.getParameters().put('type',type);
           
                
            EPMS_Operator_Assignment_Controller assignment = new EPMS_Operator_Assignment_Controller();
                       
            // File Assignment - Assignment Test
            string selectvalue=location.Id;
            assignment.selectvalue=selectvalue;
            assignment.selectedShift = shift.Id;
            assignment.selectedTeamlead = member2.Id;
            assignment.CurrentTeams = team.Id;            
            assignment.assign_save(); 
            assignment.getFilesInfoForDisplay();
			assignment.getPOIdsSize(poids);
                   
            Test.stopTest(); 

        }

        static testMethod void testOperatorAssignment2(){
            
             PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            // Folder Assignment - Assignment Test
            Test.startTest();
            string type = 'assign';
            Test.setCurrentPage(pageRef);
            Files__c folderfile2 = [SELECT Id, Name FROM Files__c WHERE Name ='testFolder'];
            Location__c location2 = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift2 = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            //Member__c member2 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Scott' AND Email__c='testFirsttestlastOP@gmail.com'];  
            Member__c member2 = [SELECT Id, Name FROM Member__c WHERE Name = 'Stephen'];
            Team__c team2 = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            
            pageRef.getParameters().put('ids',folderfile2.id);
            pageRef.getParameters().put('type',type);
            //Test.startTest();
            EPMS_Operator_Assignment_Controller assignment2 = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            string selectvalue2=location2.Id;
            assignment2.selectvalue=selectvalue2;
            //assignment.basepath=basepath;
            assignment2.selectedShift = shift2.Id;
            assignment2.selectedTeamlead = member2.Id;
            assignment2.CurrentTeams = team2.Id;
            assignment2.assign_save(); 
            Test.stopTest();
        }
        
        static testMethod void testOperatorAssignment3(){
            
             PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            // Copy File scenario 
            //Test.startTest();
            string type = 'assign';
            Test.setCurrentPage(pageRef);
            Files__c copyfileList = [SELECT Id, Name FROM Files__c WHERE Name = 'testCOPPPFile1'];
            Files__c copyfileList2 = [SELECT Id, Name FROM Files__c WHERE Name = 'testunassignFileProper'];
            pageRef.getParameters().put('ids',copyfileList.id);
            pageRef.getParameters().put('type',type);
            
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Member__c member3 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            Test.startTest();
            EPMS_Operator_Assignment_Controller assignment3 = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            string selectvalue3=location.Id;
            assignment3.selectvalue=selectvalue3;
            assignment3.selectedShift = shift.Id;
            assignment3.selectedTeamlead = member3.Id;
            assignment3.CurrentTeams = team.Id;            
            assignment3.assign_save();
            Test.stopTest();
        }
        
        
        static testMethod void testOperatorAssignment4(){
        
            PageReference pageRef = Page.EPMS_Operator_File_Assignment;
             // Copy File scenario - 2
            string type = 'assign';
            Test.setCurrentPage(pageRef);
            Files__c copyfileList = [SELECT Id, Name FROM Files__c WHERE Name = 'testCOPPPFile1'];
            pageRef.getParameters().put('ids',copyfileList.id);
            pageRef.getParameters().put('type',type);

            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Member__c member3 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            Test.startTest();
            EPMS_Operator_Assignment_Controller assignment4 = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            string selectvalue4=location.Id;
            assignment4.selectvalue=selectvalue4;
            assignment4.selectedShift = shift.Id;
            assignment4.selectedTeamlead = member3.Id;
            assignment4.CurrentTeams = team.Id;
            assignment4.assign_save();
            Test.stopTest();
        }
        
        
        static testMethod void testOperatorAssignment5(){
            
             PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            // Re-Assigned File scenario - 2
            //Test.startTest();
            String type5 = 'reassign';
            Test.setCurrentPage(pageRef);
            Files__c redofile = [SELECT Id, Name FROM Files__c WHERE Name ='testREDOFile'];
            pageRef.getParameters().put('ids',redofile.id);
            pageRef.getParameters().put('type',type5);
            
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Member__c member3 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            Test.startTest();
            EPMS_Operator_Assignment_Controller assignment5 = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            string selectvalue5=location.Id;
            assignment5.selectvalue=selectvalue5;
            assignment5.selectedShift = shift.Id;
            assignment5.selectedTeamlead = member3.Id;
            assignment5.CurrentTeams = team.Id;
            assignment5.assign_save();
            Test.stopTest();
            
        }
        
        static testMethod void testOperatorAssignment6(){
            
            //Test.startTest();
            PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            // Re-assign member from Files
            String type6 = 'unassign';
            Test.setCurrentPage(pageRef);
            // un-assign member from Files
            Files__c unassignfile = [SELECT Id, Name FROM Files__c WHERE Name = 'testunassignFile'];
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
        
        
        static testMethod void testOperatorAssignment7(){
            
             PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            // Re-assign member from Files
            String type6 = 'unassign';
            Test.setCurrentPage(pageRef);
            Files__c unassignfile = [SELECT Id, Name FROM Files__c WHERE Name = 'testunassignFile'];
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Member__c member3 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            
            pageRef.getParameters().put('ids',unassignfile.id);
            pageRef.getParameters().put('type',type6);
            Test.startTest();
            EPMS_Operator_Assignment_Controller assignment7 = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            string selectvalue7=location.Id;       
            
            assignment7.selectvalue=selectvalue7;            
            assignment7.selectedTeamlead = member3.Id;
            assignment7.CurrentTeams = team.Id;
            assignment7.setUnAssignMember = false;
            
            //po.MBO_Location__c=selectvalue;
            assignment7.assign_save();
            Test.stopTest();
        }
        
        static testMethod void testOperatorAssignment8() {
            
            PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            //Test.startTest();
            String type6 = 'unassign';
            Test.setCurrentPage(pageRef);
            Files__c unassignfile = [SELECT Id, Name FROM Files__c WHERE Name = 'testunassignFile'];
            pageRef.getParameters().put('ids',unassignfile.id);
            pageRef.getParameters().put('type',type6);
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Test.startTest();
            EPMS_Operator_Assignment_Controller assignment8 = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            
            string selectvalue8=location.Id;          
            assignment8.selectvalue=selectvalue8;
           
            assignment8.selectedTeamlead = null;
            assignment8.CurrentTeams = team.Id;
            assignment8.setUnAssignMember = false;
            assignment8.assign_save();
            Test.stopTest();
        }
            
        
        static testMethod void testOperatorAssignment9() {
                
            //Test.startTest();   
            PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            String type6 = 'unassign';
            Test.setCurrentPage(pageRef);
            Files__c unassignfile = [SELECT Id, Name FROM Files__c WHERE Name = 'testunassignFile'];
            pageRef.getParameters().put('ids',unassignfile.id);
            pageRef.getParameters().put('type',type6);
            EPMS_Operator_Assignment_Controller assignment9 = new EPMS_Operator_Assignment_Controller();
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Member__c member3 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            // File Assignment - Assignment Test
            Test.startTest();
            string selectvalue9=location.Id;
            assignment9.selectvalue=selectvalue9;
        
            assignment9.selectedTeamlead = member3.Id;
            assignment9.CurrentTeams = team.Id;
            assignment9.setUnAssignMember = false;
            assignment9.assign_save();
            Test.stopTest();
        }   
        
        
        static testMethod void testOperatorAssignment10() {
            
            PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            Test.startTest();
            String type10 = 'assign';
            String type6 = 'unassign';
            Test.setCurrentPage(pageRef);
            Files__c unassignfile = [SELECT Id, Name FROM Files__c WHERE Name = 'testunassignFile' ];
            pageRef.getParameters().put('ids',unassignfile.id);
            pageRef.getParameters().put('type',type6);
            
            EPMS_Operator_Assignment_Controller assignment10 = new EPMS_Operator_Assignment_Controller();
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Member__c member2 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Scott'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            string selectvalue10=location.Id;
            
            
            assignment10.selectvalue=selectvalue10;
          
            assignment10.selectedTeamlead = member2.Id;
            assignment10.CurrentTeams = team.Id;
            assignment10.setUnAssignMember = false;
            assignment10.assign_save();
            Test.stopTest();
        }   
            
        
        static testMethod void testOperatorAssignment11() {
            
            PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            Test.startTest();
            String type11 = 'assign';
            Test.setCurrentPage(pageRef);
            Files__c copyFinalfile = [SELECT Id, Name FROM Files__c WHERE Name = 'testFinal'];
            pageRef.getParameters().put('ids',copyFinalfile.id);
            pageRef.getParameters().put('type',type11);
            
            EPMS_Operator_Assignment_Controller assignment11 = new EPMS_Operator_Assignment_Controller();
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            
            // File Assignment - Assignment Test
            string selectvalue11=location.Id;         
            
            assignment11.selectvalue=selectvalue11;
           
            assignment11.selectedTeamlead = null;
            assignment11.CurrentTeams = team.Id;
            assignment11.setUnAssignMember = false;
            assignment11.assign_save();
            Test.stopTest();
        }   
        
        static testMethod void testOperatorAssignment12() {
            
            PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            // Copy File scenario - 2 - Again
            String type11 = 'assign';
            Test.setCurrentPage(pageRef);
            Test.startTest();
            Files__c copyfileList = [SELECT Id, Name FROM Files__c WHERE Name = 'testCOPPPFile1'];
            pageRef.getParameters().put('ids',copyfileList.id);
            pageRef.getParameters().put('type',type11);
            
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Member__c member3 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger']; 
            Member__c member2 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Scott']; 
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            EPMS_Operator_Assignment_Controller assignment12 = new EPMS_Operator_Assignment_Controller();
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            // File Assignment - Assignment Test
            string selectvalue12=location.Id;
            assignment12.selectvalue=selectvalue12;
            assignment12.selectedShift = shift.Id;
            assignment12.selectedTeamlead = member3.Id;
            assignment12.CurrentTeams = team.Id;
            assignment12.assign_save();
             /** Test the More than two copy files */
            pageRef.getParameters().put('ids',copyfileList.id);
            pageRef.getParameters().put('type',type11);
            assignment12.selectvalue=selectvalue12;
            //assignment.basepath=basepath;
            assignment12.selectedShift = shift.Id;
            assignment12.selectedTeamlead = member2.Id;
            assignment12.CurrentTeams = team.Id;
            assignment12.assign_save();
            
            Test.stopTest();
        }
        
        static testMethod void testOperatorAssignment13() {
        
            PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            // Re-assign  Files 
            Test.startTest();
            Test.setCurrentPage(pageRef);
            Files__c assignfileProper = [SELECT Id, Name FROM Files__c WHERE Name = 'testunassignFileProper'];
            String type_a = 'unassign';
            pageRef.getParameters().put('ids',assignfileProper.id);
            pageRef.getParameters().put('type',type_a);
            
            EPMS_Operator_Assignment_Controller assignment13 = new EPMS_Operator_Assignment_Controller();
            Member__c member2 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Scott'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            // File Assignment - Assignment Test
            string selectvalue13=location.Id;          
            
            assignment13.selectvalue=selectvalue13;
           
            assignment13.selectedTeamlead = member2.Id;
            assignment13.CurrentTeams = team.Id;
            assignment13.setUnAssignMember = false;
            assignment13.assign_save();
            Test.stopTest();
        }
        
        static testMethod void testOperatorAssignment14() {
            
            PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            Test.startTest();
            Test.setCurrentPage(pageRef);
            Files__c assignfileProper = [SELECT Id, Name FROM Files__c WHERE Name = 'testunassignFileProper'];
            // Re-assign  Files 
            String source = 'file';
            String type_b = 'unassign';
            pageRef.getParameters().put('ids',assignfileProper.id);
            pageRef.getParameters().put('type',type_b);
            pageRef.getParameters().put('basepath',source);
            
            EPMS_Operator_Assignment_Controller assignment14 = new EPMS_Operator_Assignment_Controller();
            
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Member__c member3 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            // File Assignment - Assignment Test
            string selectvalue14=location.Id;
           
            assignment14.selectvalue=selectvalue14;
          
            assignment14.selectedTeamlead = member3.Id;
            assignment14.CurrentTeams = team.Id;
            assignment14.setUnAssignMember = true;
            assignment14.assign_save();
            Test.stopTest();
        }
        
        static testMethod void testOperatorAssignment15() {

            PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            Test.setCurrentPage(pageRef);
            Test.startTest();
            Files__c assignfileProper = [SELECT Id, Name FROM Files__c WHERE Name = 'testunassignFileProper'];
            String sourcew = 'file';
            String type_c = 'unassign';
            pageRef.getParameters().put('ids',assignfileProper.id);
            pageRef.getParameters().put('type',type_c);
            pageRef.getParameters().put('source',sourcew);
            //Test.startTest();
            EPMS_Operator_Assignment_Controller assignment15 = new EPMS_Operator_Assignment_Controller();
            
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            // File Assignment - Assignment Test
            string selectvalue15=location.Id;
            
                     
            assignment15.selectvalue=selectvalue15;
            assignment15.selectedTeamlead = null;
            assignment15.CurrentTeams = team.Id;
            assignment15.setUnAssignMember = false;            
            assignment15.assign_save();
            
            assignment15.Cancel();
            assignment15.ShowPanel();
            string basepath='Order';
            assignment15.selectvalue=selectvalue15;
            assignment15.basepath=basepath;
            assignment15.selectedShift = shift.Id;
            assignment15.getAssignmentDetails();
            Test.stopTest();
        }
        
        static testMethod void testOperatorAssignment16() {
            
            Test.startTest();
            PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            string basepath='Order';
            Test.setCurrentPage(pageRef);
            Files__c assignfileProper = [SELECT Id, Name FROM Files__c WHERE Name = 'testunassignFileProper'];
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Member__c member3 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            String sources = 'file';
            String type_s = 'unassign';
            
            pageRef.getParameters().put('ids',assignfileProper.id);
            pageRef.getParameters().put('type',type_s);
            pageRef.getParameters().put('source',sources);
            pageRef.getParameters().put('clearVal','shift');
            EPMS_Operator_Assignment_Controller assignment16 = new EPMS_Operator_Assignment_Controller();
            string selectvalue16=location.Id;
            assignment16.selectvalue=selectvalue16;
            assignment16.basepath=basepath;
            assignment16.selectedShift = shift.Id;
            assignment16.selectedTeamlead = null;
            assignment16.CurrentTeams = team.Id;
            assignment16.setUnAssignMember = false;
            assignment16.ShowPanel();
            Test.stopTest();
        }
        
        static testMethod void testOperatorAssignment17(){
            
             PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            // Copy File scenario 
            string type = 'assign';
            string basepath='source';
            Test.setCurrentPage(pageRef);
            Files__c copyfileList2 = [SELECT Id, Name FROM Files__c WHERE Name = 'testunassignFileProper'];
            pageRef.getParameters().put('ids',copyfileList2.id);
            pageRef.getParameters().put('type',type);
            pageRef.getParameters().put('basepath','file');

            
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Member__c member3 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            Test.startTest();
            
            EPMS_Operator_Assignment_Controller assignmentK = new EPMS_Operator_Assignment_Controller();
            // File Assignment - Assignment Test
            string selectvalue32=location.Id;
             assignmentK.setUnAssignMember = false;
            assignmentK.selectvalue=selectvalue32;
            assignmentK.selectedShift = shift.Id;
            //assignmentK.getSelectedShift();            
            //assignmentK.SetSelectedShift(shift.Name);            

            assignmentK.selectedTeamlead = member3.Id;
            assignmentK.CurrentTeams = team.Id;            
          
            assignmentK.assign_save();
            Test.stopTest();
        }
        
         static testMethod void testOperatorAssignment18(){
            
             PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            // Re-Assigned File scenario - 2
            //Test.startTest();
            String type5 = 'reassign';
            Test.setCurrentPage(pageRef);
            Files__c redofile = [SELECT Id, Name FROM Files__c WHERE Name ='testREDOFile'];
            pageRef.getParameters().put('ids',redofile.id);
            pageRef.getParameters().put('type',type5);
            
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Member__c member = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='testlastQC']; 
            Member__c member2 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Scott'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            Test.startTest();
            EPMS_Operator_Assignment_Controller assignment18 = new EPMS_Operator_Assignment_Controller();
            
            // File Assignment - Assignment Test
            string selectvalue5=location.Id;
            assignment18.selectvalue=selectvalue5;
            //assignment.basepath=basepath;
            assignment18.setUnAssignMember = false;
            assignment18.selectedShift = shift.Id;
            assignment18.selectedTeamlead = member2.Id;
            //assignment18.CurrentTeams = team.Id;
            system.debug('REDO SCENARIO REASSIGN TEST IS STARTING' + assignment18);
            assignment18.assign_save();
            
            EPMS_Operator_Assignment_Controller assignment18_v1 = new EPMS_Operator_Assignment_Controller();
            // File Assignment - Assignment Test
            //string selectvalue5=location.Id;
            assignment18_v1.selectvalue=selectvalue5;
            //assignment.basepath=basepath;
            assignment18_v1.selectedShift = shift.Id;
            assignment18_v1.selectedTeamlead = member.Id;
            //assignment18.CurrentTeams = team.Id;
            system.debug('REDO SCENARIO REASSIGN TEST IS STARTING' + assignment18);
            assignment18_v1.assign_save();
            
            
            Test.stopTest();
            
        }
        
         static testMethod void testOperatorAssignment19(){
            
             PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            // Re-Assigned File scenario - 2
            //Test.startTest();
            String type5 = 'assign';
            Test.setCurrentPage(pageRef);
            Files__c copyfileDetails = [SELECT Id, Name FROM Files__c WHERE Name ='copyDetailFiles'];           
            pageRef.getParameters().put('ids',copyfileDetails.Id);
            pageRef.getParameters().put('type',type5);

            
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Member__c member3 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger'];  
            Member__c member = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='testlastQC'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            Test.startTest();
            EPMS_Operator_Assignment_Controller assignment19 = new EPMS_Operator_Assignment_Controller();
            
            assignment19.selectvalue=location.Id;
            //assignment.basepath=basepath;
            assignment19.selectedShift = shift.Id;
            assignment19.selectedTeamlead = member3.Id;
            //assignment12.CurrentTeams = team.Id;
            system.debug('AGAIN CHILD REASSIGN TEST IS STARTING 2 ' + assignment19);
            assignment19.assign_save();
              assignment19.setSelectedShift(shift.id);
             assignment19.getSelectedShift();
           
            Test.stopTest();
            
        }
        
        static testMethod void testOperatorAssignment20(){
            PageReference pageRef = Page.EPMS_Operator_File_Assignment;
            // Re-Assigned File scenario - 2
            //Test.startTest();
            String type5 = 'assign';
            Test.setCurrentPage(pageRef);
            Files__c copyfileDetails = [SELECT Id, Name FROM Files__c WHERE Name ='copyDetailFiles'];           
            pageRef.getParameters().put('ids',copyfileDetails.Id);
            pageRef.getParameters().put('type',type5);

            
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Member__c member3 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger'];  
            Member__c member = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='testlastQC'];  
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            Test.startTest();
            Set<Id> teamIds = new Set<Id>();
            if(team != null){
                teamIds.add(team.Id);
            }
            //EPMS_Operator_Assignment_Controller assignment19 = new EPMS_Operator_Assignment_Controller();
            EPMS_ProductionOrderAssignmentService proService = new EPMS_ProductionOrderAssignmentService();
            proService.getAllTeamList(location.Id);
            proService.getTeamLeadersShiftAssignmentInfo(shift.Id);
            proService.getTeamLeadersTeamAssignmentInfo(location.Id);
            proService.getAvailableTeamLeaderToday(team.Id);
            proService.getQcTeamAssignmentInfo(team.Id);
            proService.getTeamDetails(teamIds);
            Test.stopTest();
        }   
        
        
        
        static testmethod void testOperatorAssignment21(){
            
            PageReference pageref = page.EPMS_Operator_File_Assignment;
            Test.setCurrentPage(pageref);   
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Member__c member5 = [SELECT Id, Name FROM Member__c WHERE Name ='Dwayne'];  
            Member__c member4 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Tiger'];
            Member__c member3 = [SELECT Id, Name FROM Member__c WHERE Name ='test-Artist'];
            Member__c member2 = [SELECT Id, Name FROM Member__c WHERE Last_Name__c='Gopal'];
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Team C'];
            Team__c teamb = [SELECT Id, Name FROM Team__c WHERE Name='Team B'];
            Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            List<String> memberIds = new List<String>();
            Set<Id> teamIds = new Set<Id>();
            if(team !=null){
                teamIds.add(team.Id);
            }
            if(member5 !=null){
                memberIds.add(member5.Id);
            }
            if(member4 !=null){
                memberIds.add(member4.Id);
            }
            if(member3 !=null){
                memberIds.add(member3.Id);
            }
            if(member2 !=null){
                memberIds.add(member2.Id);
            }
            Test.startTest();
            
            EPMS_FileOperatorAssignmentService newFileAssgnService = new EPMS_FileOperatorAssignmentService();
            newFileAssgnService.getLoggedMemberShiftAssignmentInformation(member4.Id);
            newFileAssgnService.getTeamDetails(teamIds);
            newFileAssgnService.getAvailableOperatorToday(team.Id,shift.Id);
            newFileAssgnService.getFileLocationName(location.Id);
            
            
            Test.stopTest();
        }
        
        
        static testmethod void testOperatorAssignment22(){
            
	        Account acc = new Account(Name='TEST ACC');        
	        insert acc;       
        
			Anken__c anken = new Anken__c();
			anken.KokyakuName__c=acc.Id;
			anken.Status__c='アップロード完了';
			anken.Sagyoshiji_Renrakujiko__c='please refer PDF for instructions';
			anken.Nouki_Date__c=System.Today();
        	Insert anken;
            
	        Location__c location = new Location__c();
	        location.Name = 'INDIAN MBO';
	        location.Location_Country__c='India';
	        location.Location_Status__c ='Active';
	        location.Group_Name__c='INDIAN MBO';
	        insert location;    
	        
            Shift__c shift = new Shift__c();
            shift.Status__c='Active';
            shift.Name = 'testing Shift';
            shift.Shift_Location__c = location.Id;
            shift.Implements_From__c = system.now().addDays(3);
            shift.Shift_Start_Time__c = system.now();
            shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
            insert shift;
            
            Member__c member =new Member__c();
            member.Name='testQC123';     
            member.Location_id__c=location.id;
            member.Last_Name__c='testlastQC123';
            member.Email__c='testFirsttestlastQC123@gmail.com';
            member.Country__c='India';
            member.Designation__c='Production Administrator';
            member.Status__c='Active';
            insert member;	             
            
            Shift_Assignments__c shiftass=new Shift_Assignments__c();
            shiftass.Shift_Code__c=shift.id;
            shiftass.Member__c=member.id;
            shiftass.Location__c=location.id;
            shiftass.FromTime__c=system.today();
            shiftass.Shift_Assigned__c=true;
            insert shiftass;            
            
            Team__c team = new Team__c();
            team.Name='Testing Name';
            team.Location__c=location.id;             
            insert team;	                  
            
	        Production_Order__c po=new Production_Order__c();
	        po.Anken_Order__c = anken.id;
	        po.Name ='testPO-1';
	        po.Production_Order_Status__c ='New';
	        Po.Production_Order_Instruction__c = 'Test data for PO instruction';
	        po.MBO_Location__c=location.Id;
	        po.Redo__c = True;
	        insert po;
	        
            Files__c file= new Files__c();
            file.Name ='testFile10';
            file.Production_Order__c =po.id;
            file.Status__c ='New';
            file.File_Location__c=location.id;
            file.Current_Extension__c ='.jpg';
            file.File_Type__c = 'Image';
            insert file;       
            
            List<string> ankenlst = new List<String>();
            ankenlst.add(anken.Id);

            List<string> polst = new List<String>();
            polst.add(po.Id);
            
            List<string> filelst = new List<String>();
            filelst.add(file.Id);

            Set<Id> teamSet = new Set<Id>();
            teamSet.add(team.Id);
 
            Set<Id> memSet = new Set<Id>();
            memSet.add(member.Id);           
            
            Set<String> poSet = new Set<String>();
            poSet.add(po.Id);            
            
            Test.startTest();
            
            EPMS_ProductionOrder_Query_Locator poQueryLocator = new EPMS_ProductionOrder_Query_Locator();
            poQueryLocator.getAkenObject(ankenlst);
            poQueryLocator.getPOCheck(polst);
            poQueryLocator.getlocationsquery();
            poQueryLocator.getProductiondublicates();
            poQueryLocator.getShift(location.id);
            
            poQueryLocator.getShiftMemberlist(shift.id);
            poQueryLocator.getteammembers(memSet, 'MBO');
            poQueryLocator.getTeam(teamSet, 'MBO');
            poQueryLocator.getmembers(team.id, location.id);
            poQueryLocator.getOrderList(polst);
            poQueryLocator.getmembersTL(team.id, 'MBO');
            poQueryLocator.getFileCheck(filelst);
            poQueryLocator.getFilesList(filelst);	
            poQueryLocator.getFilesDetailsList(polst);
            poQueryLocator.getPOList(poSet);
            
            Test.stopTest();
        } 
    }