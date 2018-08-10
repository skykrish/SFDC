/**********************************************************************************
*   Class               :       Test_EPMS_HandoverProductionOrder                 *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_HandoverProductionOrder       *
**********************************************************************************/
@isTest
    public class Test_EPMS_HandoverProductionOrder {
    static testMethod void testProductionhandover() {   
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser121212@testorg.com');
        
        insert u;
        
        System.runas(u){
            PageReference pageRef = Page.EPMS_HandOverProd;         
            
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
            location.Location_Country__c='India';
            location.Location_Status__c ='active';
            location.Group_Name__c='INDIA PVT LTD -Phase2x2';
            insert location;
           
            Location__c location2 = new Location__c();
            location2.Name = 'INDIA PRIVATE LIMITED - Phaseex3';
            location2.Location_Country__c='India';
            location2.Location_Status__c ='active';
            location2.Group_Name__c='INDIA PVT LTD -Phase2x3';
            insert location2;      
        
        
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='I';
            insert testRecord;
            
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='davidMoore@mbo.in';
            insert usermail;
                
            Team__c team = new Team__c();
            team.Name='Team B';
            team.Location__c=location.id;             
            insert team;
            
            Team__c team2 = new Team__c();
            team2.Name='Team A';
            team2.Location__c=location.id;             
            insert team2;
            
            
            Member__c member4 =new Member__c();
            member4.Name='Scott';     
            member4.Location_id__c=location.id;
            member4.Last_Name__c='Tiger';
            member4.Email__c='scotttiger@gmail.com';
            member4.Country__c='India';
            member4.Designation__c='Team Leader';
            member4.Status__c='Active';
            member4.Team_Id__c=team.Id;
            insert member4;
        
            Member__c member5 =new Member__c();
            member5.Name='Parker';     
            member5.Location_id__c=location.id;
            member5.Last_Name__c='Peter';
            member5.Email__c='peterparker@gmail.com';
            member5.Country__c='India';
            member5.Designation__c='Team Leader';
            member5.Status__c='Active';
            member4.Team_Id__c=team2.Id;
            insert member5;
            
            
            Production_Order__c po=new Production_Order__c();
            po.Name ='O0002530';
            po.Production_Order_Status__c ='Assigned';
            po.MBO_Location__c=location.Id;
            po.TL_Incharge__c= member4.Id;
            insert po;
        
        
            List<Files__c> fileList = new List<Files__c>();
            
            File_Categories__c fc= new File_Categories__c();
            fc.Name ='AB';
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;
            
            insert fc;
        
        
        
            for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='Handover_FILE_Test_'+i;
                file.Production_Order__c =po.id;
                file.File_Category_Code__c =fc.id;
                file.Status__c ='Assigned';
                file.Parent_Id__c=file.Id;
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image'; 
                file.TLInCharge__c= member4.Id;
                fileList.add(file);
            }
            insert fileList;       
        
        
            Shift__c shift1 = new Shift__c();
            shift1.Status__c='Active';
            shift1.Name = 'testing Shift';
            shift1.Shift_Location__c = location.Id;
            shift1.Implements_From__c = system.now().addDays(3);
            shift1.Shift_Start_Time__c = system.now();
            shift1.Shift_End_Time__c = system.now().addHours(9);
            insert shift1;
            
            Shift__c shift2 = new Shift__c();
            shift2.Status__c='Active';
            shift2.Name = 'testing Shift A';
            shift2.Shift_Location__c = location.Id;
            shift2.Implements_From__c = system.now().addDays(3);
            shift2.Shift_Start_Time__c = system.now().addHours(10);
            shift2.Shift_End_Time__c = system.now().addHours(20);
            insert shift2;
        
        
        
            
            Shift_Assignments__c sa=new Shift_Assignments__c(Member__c=member4.Id,Shift_Assigned__c=true,Shift_Code__c=shift1.Id);
            insert sa;
            
            Shift_Assignments__c sa1=new Shift_Assignments__c(Member__c=member5.Id,Shift_Assigned__c=true,Shift_Code__c=shift2.Id);
            insert sa1;
            
            Test.StartTest(); 
          
            string basepath='Order';
            
            ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(po);
            
            Test.setCurrentPage(pageRef);  
            pageRef.getParameters().put('ids',po.id);
            pageRef.getParameters().put('type',basepath);
            EPMS_HandoverProductionOrder handover=new EPMS_HandoverProductionOrder(sc);
            handover.selectedShiftId=sa.Shift_Code__c;
            handover.getListOfShifts();
            handover.selectedTeamId=member4.Team_Id__c;
            handover.getListOfTeams();
            handover.updateorder();
            handover.getListOfShifts();
            handover.selectedShiftId='';
            handover.selectedTeamId=member5.Team_Id__c;
            handover.getListOfTeams();
            handover.updateorder();        
        }         
            Test.stopTest();        
    }
    
}