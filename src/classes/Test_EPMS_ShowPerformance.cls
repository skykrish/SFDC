/**********************************************************************************
*   Class               :       clsTest_EPMS_ShowPerformance                      *
*   Created Date        :       11/04/2016                                        *
*   Description         :       Test Class for EPMS_ShowPerformance               *
**********************************************************************************/
@isTest
    public class Test_EPMS_ShowPerformance  {
    
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
            fc.Name ='A';
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;
            
            insert fc;
            
            File_Categories__c fc2= new File_Categories__c();
            fc2.Name ='B';
            fc2.Standard_Time_per_File_Min__c =40;
            fc2.Standard_Time_per_File_Max__c =110;
            fc2.Standard_Regular_Cost_per_File__c =934;
            fc2.Standard_OptionalCost_Per_file__c =5;
            
            insert fc2;
            
            File_Categories__c fc3= new File_Categories__c();
            fc3.Name ='C';
            fc3.Standard_Time_per_File_Min__c =140;
            fc3.Standard_Time_per_File_Max__c =210;
            fc3.Standard_Regular_Cost_per_File__c =934;
            fc3.Standard_OptionalCost_Per_file__c =5;
            
            insert fc3;
            
                        
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
            
            Team__c team21 = new Team__c();
            team21.Name='Testing Name';
            team21.Location__c=location.id;             
            insert team21;
            
            Shift__c shift = new Shift__c();
            shift.Status__c='Active';
            shift.Name = 'testing Shift';
            shift.Shift_Location__c = location.Id;
            shift.Implements_From__c = system.now().addDays(3);
            shift.Shift_Start_Time__c = system.now();
            shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
            insert shift;
            
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
            member2.Current_Shift__c = 'testing Shift';
            member2.Team_Id__c = team21.Id;
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
            member3.Current_Shift__c =  'testing Shift';
            member3.Team_Id__c = team21.Id;
            memberList.add(member3);
            
            Member__c member12 =new Member__c();
            member12.Name='Ajith';     
            member12.Location_id__c=location.id;
            member12.Last_Name__c='Gopal';
            member12.Email__c='gopalajith@gmail.com';
            member12.Country__c='India';
            member12.Designation__c='Photo Artists';
            member12.Status__c='Active';
            member12.Current_Shift__c = 'testing Shift';
            member12.Team_Id__c = team21.Id;
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
            member13.Current_Shift__c =  'testing Shift';
            member13.Team_Id__c = team21.Id;
            //insert member5; 
            memberlist.add(member13);
            
            if(memberList.size() > 0){
                insert memberList;
            }
            
       
            Production_Order__c po2=new Production_Order__c();
            po2.Name ='00514448';
            po2.Production_Order_Status__c ='New';
            po2.MBO_Location__c=location.Id;
            po2.Job_List__c = 'Mask';
            insert po2;
            

            List<Shift_Assignments__c> shiftList = new List<Shift_Assignments__c>();
            Shift_Assignments__c shiftass=new Shift_Assignments__c();
            shiftass.Shift_Code__c=shift.id;
            shiftass.Member__c=member2.id;
            shiftass.Location__c=location.id;
            shiftass.FromTime__c=system.today();
            shiftass.Team_Assignment_Id__c = 'Testing Name';
            shiftass.Shift_Assigned__c=true;
            shiftList.add(shiftass);
            
            Shift_Assignments__c shiftass1=new Shift_Assignments__c();
            shiftass1.Shift_Code__c=shift.id;
            shiftass1.Member__c=member3.id;
            shiftass1.Location__c=location.id;
            shiftass1.FromTime__c=system.today();
            shiftass1.Team_Assignment_Id__c = 'Testing Name';
            shiftass1.Shift_Assigned__c=true;
            shiftList.add(shiftass1);
            
            Shift_Assignments__c shiftass2=new Shift_Assignments__c();
            shiftass2.Shift_Code__c=shift.id;
            shiftass2.Member__c=member13.id;
            shiftass2.Location__c=location.id;
            shiftass2.FromTime__c=system.today();
            shiftass2.Team_Assignment_Id__c = 'Testing Name';
            shiftass2.Shift_Assigned__c=true;
            shiftList.add(shiftass2);
            
            Shift_Assignments__c shiftass3=new Shift_Assignments__c();
            shiftass3.Shift_Code__c=shift.id;
            shiftass3.Member__c=member12.id;
            shiftass3.Location__c=location.id;
            shiftass3.FromTime__c=system.today();
            shiftass3.Team_Assignment_Id__c = 'Testing Name';
            shiftass3.Shift_Assigned__c=true;
            shiftList.add(shiftass3);
            
            if(shiftList.size() > 0){
                insert shiftList;
            }
            
            Production_Order__c po=new Production_Order__c();
            po.Name ='00514362';
            po.Production_Order_Status__c ='New';
            po.MBO_Location__c=location.Id;
            po.Job_List__c = 'Clipping';
            insert po;
            
            List<Files__c> fileList = new List<Files__c>();
            List<Files__c> fileList2 = new List<Files__c>();
            for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='testFile'+i;
                file.Production_Order__c =po.id;
                file.File_Category_Code__c =fc.id;
                file.Status__c ='Approved';
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
                file.File_Job_Titles__c = 'Clipping';
                //file.Work_Start_Time__c = system.now().addMinutes(3);
                file.Work_Start_Time__c = system.now();
                file.Work_End_Time__c = system.now();
                if(i == 0){
                    file.Member__c = member.Id;
                    
                } else if(i == 1){
                    file.Member__c = member2.Id;
                    
                }else if(i == 2){
                    file.Member__c = member3.Id;
                    file.File_Category_Code__c =fc2.id;
                    
                }else if(i == 3){
                    file.Member__c = member13.Id;
                    
                }else if(i == 4){
                    file.Member__c = member12.Id;
                    file.File_Category_Code__c =fc2.id;
                }else {
                    file.Member__c = member.Id;
                    
                }
                fileList.add(file);
            }
            insert fileList; 
            
             for(Integer i=1;i<=5;i++){
                Files__c file2= new Files__c();
                file2.Name ='Sample'+i;
                file2.Production_Order__c =po2.id;
                file2.File_Category_Code__c =fc2.id;
                file2.Status__c ='Approved';
                file2.File_Location__c=location.id;
                file2.Current_Extension__c ='.jpg';
                file2.File_Type__c = 'Image';
                //file2.Work_Start_Time__c = system.now().addMinutes(-4);
                file2.Work_Start_Time__c = system.now();
                file2.Work_End_Time__c = system.now();
                file2.File_Job_Titles__c = 'Mask';
                if(i == 0){
                    file2.Member__c = member.Id;
                    
                } else if(i == 1){
                    file2.Member__c = member2.Id;
                    file2.File_Category_Code__c =fc.id;
                }else if(i == 2){
                    file2.Member__c = member3.Id;
                    file2.File_Category_Code__c =fc.id;
                    
                }else if(i == 3){
                    file2.Member__c = member12.Id;
                    file2.File_Category_Code__c =fc.id;
                }else if(i == 4){
                    file2.Member__c = member13.Id;
                    //file2.File_Category_Code__c =fc.id;
                }else {
                    file2.Member__c = member.Id;
                    
                }
                fileList2.add(file2);
            }
            insert fileList2;
            
        }
        
        static testMethod void testshowPerformance() {
            
            PageReference pageRef = Page.EPMS_ShowPerformance;
            // Folder Assignment - Assignment Test
            Test.startTest();
            
            Test.setCurrentPage(pageRef);
            
            Location__c location2 = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            system.debug(' Test Location : ' + location2 );
            Production_Order__c proOrderInfo = [SELECT Id, Name FROM Production_Order__c WHERE Name = '00514362'];
            system.debug('Order Id : ' + proOrderInfo);
            List<Shift__c> shifts = [SELECT Id, Name FROM Shift__c WHERE Shift_Location__r.Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            system.debug(' Test shifts : ' + shifts );
            Shift__c ShiftInfo = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift' AND Shift_Location__r.Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
                                    system.debug(' Test Current Shift : ' + ShiftInfo );
            Team__c team2 = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
                                                system.debug(' Test Current Team: ' + team2 );
            List<Member__c> memberlist =[SELECT Id, Name,Location_id__c, Team_Id__c FROM Member__c WHERE Location_id__r.Name ='INDIA PRIVATE LIMITED - Phaseex2' AND Status__c ='Active'];
            system.debug(' Test Current memberlist : ' + memberlist );
            EPMS_ShowPerformance  performance = new EPMS_ShowPerformance();
            
            List<Team__c> Teams=[select Id,Name from Team__c where Location__r.Name = 'INDIA PRIVATE LIMITED - Phaseex2' ];
            performance.getListOfLocations();
            performance.selectedLocId=memberlist[0].Location_id__c;
            performance.ListOfShifts();
            
            performance.teamNames=Teams;
            performance.shifts=shifts;
            performance.memberList=memberlist;
            performance.selectedShiftName=ShiftInfo.Id;
            
            performance.selectedTeamName=memberlist[0].Team_Id__c;
            performance.shiftCode=ShiftInfo.Id;
            performance.ListOfTeams();
            //performance.teamId=memberlist[0].Team_Id__c;
            performance.teamId=team2.Id;
            performance.teamListOfMembers();
            performance.selectedShiftName=ShiftInfo.Id;
            performance.shiftListOfMembers();
            performance.teamId=team2.Id;
            performance.teamListOfMembers();
            performance.getPieData();
            performance.selectedOrderIDId = proOrderInfo.Id;
            performance.getListOfLocations();
            performance.search();
            performance.teamId=null;
            performance.shiftCode=null;
             performance.search();
            Test.stopTest();
        }
        
        static testMethod void testperformance2(){     
            
            PageReference pageRef = Page.EPMS_ShowPerformance;
            Production_Order__c proOrderInfo2 = [SELECT Id, Name FROM Production_Order__c WHERE Name = '00514448'];
            Location__c location2 = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            List<Shift__c> shifts = [SELECT Id, Name FROM Shift__c WHERE Shift_Location__r.Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            Shift__c ShiftInfo = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
            Team__c team2 = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
            List<Member__c> memberlist =[SELECT Id, Name,Location_id__c, Team_Id__c FROM Member__c WHERE Location_id__r.Name ='INDIA PRIVATE LIMITED - Phaseex2' AND Status__c ='Active'];
            //Team__c team2 = [SELECT Id, Name FROM Team__c WHERE Name='Testing Name'];
                
            Test.StartTest();                 
            
            Test.setCurrentPage(pageRef); 
            EPMS_ShowPerformance  performance2=new EPMS_ShowPerformance();
            performance2.selectedLocId=memberlist[0].Location_id__c;
            performance2.fromDate = Datetime.newInstance(2016, 09, 14, 14, 23, 00);
            performance2.ToDate = Datetime.newInstance(2016, 09, 15, 02, 14, 10);
            performance2.shiftCode= ShiftInfo.Id; // null;
            performance2.teamId=null; // memberlist[0].Team_Id__c;
            performance2.search();
            performance2.orderName='00514362';
            performance2.getOrderDetails();
            performance2.orderName='';
            performance2.getListOfOrders();
            performance2.orderName='10514362';
            performance2.getListOfOrders();
            performance2.teamId=null;
            performance2.shiftCode=null;
            performance2.search();
            performance2.shiftCode= ShiftInfo.Id;
            //performance2.ListOfTeams();
            performance2.teamId=team2.Id;
            performance2.search();
            performance2.orderName='00514362';
            performance2.selectedOrderIDId = proOrderInfo2.Id;
            performance2.search();
            performance2.getOrderDetails();
            performance2.selectedLocId = location2.Id;
            performance2.getListOfOrders();
            EPMS_ShowPerformance  performance3=new EPMS_ShowPerformance();
            performance3.fromDate = null;
            performance3.ToDate = null;
            performance3.selectedLocId=memberlist[0].Location_id__c;
            performance3.shiftCode= ShiftInfo.Id;
            //performance2.getListOfTeams();
            performance3.teamId=null;
            performance3.search();
            performance3.fromDate = null;
            performance3.ToDate = null;
            performance3.selectedLocId=memberlist[0].Location_id__c;
            performance3.shiftCode= ShiftInfo.Id;
            performance3.ListOfTeams();
            
            performance3.teamId=team2.Id;
            performance3.search();
            EPMS_ShowPerformance  performance4=new EPMS_ShowPerformance();
            performance4.fromDate = Datetime.newInstance(2016, 09, 14, 14, 23, 00);
            performance4.ToDate = Datetime.newInstance(2016, 09, 15, 02, 14, 10);
            performance4.selectedLocId=memberlist[0].Location_id__c;
            performance4.ListOfShifts();
            performance4.shiftCode= ShiftInfo.Id;
            performance4.ListOfTeams();
            performance4.teamId=team2.Id;
            performance4.search();
            Test.StopTest();
        }
        
        
        
    }