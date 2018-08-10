@isTest
public class Test_Change_TL_QC_Batch_Job{

    @testSetup static void setupTestData(){
        
        Location__c location = new Location__c();
        
            location.Name ='MBO Test Phase 1';
            location.Location_Country__c='india';
            location.Location_Status__c='Active';
            location.Group_Name__c='Media Backoffice Test';
            insert location;

            Shift__c shift = new Shift__c();
            shift.Status__c='Active';
            shift.Name = 'Current Shift';
            shift.Shift_Location__c = location.Id;
            shift.Implements_From__c = system.now().addDays(3);
            shift.Shift_Start_Time__c = system.now();
            shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
            insert shift;

            Team__c team = new Team__c();
            team.Name='Current Team';
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
            Member.Name='Member Test';
            Member.Location_id__c=location.id;            
            Member.Designation__c='Team Leader';
            member.Email__c='teammeber_test@gmail.com';
            member.country__C='India';
            member.Team_id__C=team.id;
            member.First_Name__c='ABCD';
            member.Last_Name__c='XYZ';
            insert Member;
            
            Member__c Membertest = new Member__c();
            Membertest.Name='testname11';
            Membertest.Location_id__c=location.id;            
            Membertest.Designation__c='Quality Control';
            Membertest.Email__c='testQC12@gmail.com';
            Membertest.country__C='India';
            Membertest.Team_id__C=team.id;
            Membertest.First_Name__c='AAAS';
            Membertest.Last_Name__c='QCAER';
            insert Membertest;
            
            Member__c Membertest2 = new Member__c();
            Membertest2.Name='testname22';
            Membertest2.Location_id__c=location.id;            
            Membertest2.Designation__c='Quality Control';
            Membertest2.Email__c='testQC12345@gmail.com';
            Membertest2.country__C='India';
            Membertest2.Team_id__C=team.id;
            Membertest2.First_Name__c='POST';
            Membertest2.Last_Name__c='TTETST';
            insert Membertest2;
            
            
            production_order__c po = new production_order__C();
            po.Name='00514524';
            po.Mbo_Location__c =location.id;
            po.Production_Order_Status__c='New';
            //po.QC_Incharge__c = Membertest.Id;
            //po.TL_Incharge__c=member.Id;
            insert po;
            
            List<Files__c> newFilesList = new List<Files__c>();
            
            for(Integer i=0;i<100;i++){
                Files__c file = new Files__c();
                file.Name = 'Files_No_'+i+'.jpg';
                if(i < 20){
                    file.Status__c = 'New';
                } else if (i > 25 && i < 50){
                    file.Status__c = 'QC';
                } else if(i > 50 && i < 75){
                    file.Status__c = 'QCIP';
                } else {
                    file.Status__c = 'New';
                }
                
                file.Current_Extension__c = '.jpg';
                file.File_Location__c = location.id;
                file.Production_Order__c = po.Id;
                newFilesList.add(file);
            }
            insert newFilesList;
    
    }
    
    static testMethod void test_method_1(){
    
        Production_Order__c order = [SELECT Id, Name FROM Production_Order__c WHERE Name ='00514524'];
        Member__c memberQC = [SELECT Id, Name FROM Member__c WHERE Name = 'testname11'];
        Member__c memberTL = [SELECT Id, Name FROM Member__c WHERE Name = 'Member Test'];
        
        Test.startTest();
        EPMS_Change_TL_Batch newBatchInst = new EPMS_Change_TL_Batch(order.Id,memberTL.Id,memberQC.Id,'Change_TL');
        Database.executeBatch(newBatchInst);
        Test.stopTest();

    }

    static testMethod void test_method_2(){
    
        Production_Order__c order = [SELECT Id, Name FROM Production_Order__c WHERE Name ='00514524'];
        Member__c memberQC = [SELECT Id, Name FROM Member__c WHERE Name = 'testname22'];
        
        Test.startTest();
        EPMS_Change_TL_Batch newBatchInst = new EPMS_Change_TL_Batch(order.Id,null,memberQC.Id,'Change_QC');
        Database.executeBatch(newBatchInst);
        Test.stopTest();

    }
}