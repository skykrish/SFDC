@isTest
public class Test_EPMS_Batch_Sidebar{

    @testSetup static void setupTestData() {

        Location__c location =new Location__c ();
        location.Name='MBO Test Phase 1';
        location.Location_Country__c='India';
        location.Location_Status__c ='Active';
        location.Group_Name__c='Media Backoffice Test';
        insert location;
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
            
        Team__c team = new Team__c();
        team.Name='Current Team';
        team.Location__c=location.id;             
        insert team;

        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='davidMoore@mbo.in';
        insert usermail;

        Member__c Member = new Member__c();
        Member.Name='TESTER1';
        Member.Location_id__c=location.id;            
        Member.Designation__c='Team Leader';
        member.Email__c='teamleader43@gmail.com';
        member.country__C='India';
        member.Team_id__C=team.id;
        member.First_Name__c='ABCD';
        member.Last_Name__c='XYZ';
        insert Member;


        Member__c Membertest = new Member__c();
        Membertest.Name='TESTER2';
        Membertest.Location_id__c=location.id;            
        Membertest.Designation__c='Quality Control';
        Membertest.Email__c='testQC15@gmail.com';
        Membertest.country__C='India';
        Membertest.Team_id__C=team.id;
        Membertest.First_Name__c='EFGH';
        Membertest.Last_Name__c='IJK';
        insert Membertest;


        production_order__c po = new production_order__C();
        po.Name='00514888';
        po.Mbo_Location__c =location.id;
        po.Production_Order_Status__c='New';
        insert po;
        
        production_order__c po1 = new production_order__C();
        po1.Name='00514889';
        po1.Mbo_Location__c =location.id;
        po1.Production_Order_Status__c='New';
        insert po1;
        
        List<Files__c> filelist=new List<Files__c>();

        for(integer i=0;i<150;i++)
        {
        Files__c file=new Files__c();
        file.Name = 'Files_No_'+i+'.jpg';
        if(i < 150){
                file.Status__c = 'New';
                }
        file.Current_Extension__c = '.jpg';
        file.File_Location__c = location.id;
        file.Production_Order__c = po.Id;
        filelist.add(file);
        }
        insert filelist;
        
        List<Files__c> filelist1=new List<Files__c>();

        for(integer i=0;i<190;i++)
        {
        Files__c file1=new Files__c();
        file1.Name = 'Files_No_'+i+'.jpg';
        if(i < 150){
                file1.Status__c = 'New';
                }
        file1.Current_Extension__c = '.jpg';
        file1.File_Location__c = location.id;
        file1.Production_Order__c = po1.Id;
        filelist1.add(file1);
        }
        insert filelist1;
          Member__c qcMember = [SELECT id, Name, User_Id__c FROM Member__c WHERE Name = 'TESTER1'];
          system.debug('[SETUP DATA] MEMBER ###### :'+ qcMember);
          User user = [SELECT Id, Name FROM User WHERE Id =: qcMember.User_Id__c];
          system.debug('[SETUP DATA]  USER ###### :'+ user);
    }
    
    static testMethod void test_method_1(){
    
        Production_Order__c order = [SELECT Id, Name FROM Production_Order__c WHERE Name ='00514888'];
        Member__c memberQC = [SELECT Id, Name FROM Member__c WHERE Name = 'TESTER2'];
        Member__c memberTL = [SELECT Id, Name FROM Member__c WHERE Name = 'TESTER1'];
        
        Test.startTest();
        
        // Call the Change TL Batch
        EPMS_Change_TL_Batch newBatchInst = new EPMS_Change_TL_Batch(order.Id,memberTL.Id,memberQC.Id,'Change_TL');
        Id BatchId = Database.executeBatch(newBatchInst);
        
        // Create the batch Id and Order Info in Custom Setting
        Batch_Track__c newBatchTrack = new Batch_Track__c();
        newBatchTrack.Name = String.valueOf(BatchId);
        newBatchTrack.Batch_Name__c = BatchId;
        newBatchTrack.Order_Name__c = order.Name;
        insert newBatchTrack;
        
        PageReference pageRef = Page.EPMS_Batch_Sidebar;
         Test.setCurrentPage(pageRef);        
        // Call the Side Bar Constructor
        EPMS_Batch_Sidebar newSidebar = new EPMS_Batch_Sidebar();
        newSidebar.getCurrentJob();
         newSidebar.getCurrentJob();
          newSidebar.getCurrentJob();
          
        Test.stopTest();
        
    }
    
    
    static testMethod void test_method_2(){
    
        Production_Order__c order1 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='00514889'];
        Member__c memberQC1 = [SELECT Id, Name FROM Member__c WHERE Name = 'TESTER2'];
        Member__c memberTL1 = [SELECT Id, Name FROM Member__c WHERE Name = 'TESTER1'];
        
        Test.startTest();
        
        // Call the Change TL Batch
        EPMS_Change_TL_Batch newBatchInst1 = new EPMS_Change_TL_Batch(order1.Id,null,memberQC1.Id,'Change_QC');
        Id BatchId1 = Database.executeBatch(newBatchInst1);
        Test.stopTest();
        // Create the batch Id and Order Info in Custom Setting
        Batch_Track__c newBatchTrack1 = new Batch_Track__c();
        newBatchTrack1.Name = String.valueOf(BatchId1);
        newBatchTrack1.Batch_Name__c = BatchId1;
        newBatchTrack1.Order_Name__c = order1.Name;
        insert newBatchTrack1;
        
        PageReference pageRef = Page.EPMS_Batch_Sidebar;
        Test.setCurrentPage(pageRef);        
        
        // Call the Side Bar Constructor
        EPMS_Batch_Sidebar newSidebar1 = new EPMS_Batch_Sidebar();
        newSidebar1.getCurrentJob();
        newSidebar1.getCurrentJob();
        newSidebar1.getCurrentJob();
          
        
        
    }
    
      static testMethod void test_method_3(){
      
         PageReference pageRef = Page.EPMS_Batch_Sidebar;
         Test.setCurrentPage(pageRef);        
          Member__c qcMember = [SELECT id, Name, User_Id__c FROM Member__c WHERE Name = 'TESTER1'];
          system.debug('[M3] MEMBER ###### :'+ qcMember);
          User user = [SELECT Id, Name FROM User WHERE Id =: qcMember.User_Id__c];
          system.debug('USER ###### :'+ user);
      
      }
}