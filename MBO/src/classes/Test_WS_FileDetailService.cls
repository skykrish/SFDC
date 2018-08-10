/**********************************************************************************
*   Class               :       Test_WS_FileDetailService                         *
*   Created Date        :       06/03/2018                                        *           
*   Description         :       Test class for WS_FileDetailService               *
**********************************************************************************/
@istest
public class Test_WS_FileDetailService {
    
    @testSetup static void setupTestData(){
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        location.Standard_Regular_Cost__c = 6100;
        location.QA_Standard_Regular_Cost__c = 3000;
        insert location;
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='E';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testmbomql@mbo.in';
        insert usermail;
        
        Production_Order__c po1 = new Production_Order__c();
        po1.Name ='Test_PO1';
        po1.Production_Order_Status__c = 'New';
        po1.MBO_Location__c = location.Id;
        po1.FTP_Upload_Status__c = false;
        po1.FTP_Download_Status__c = false;
        insert po1;
        
        List<Member__c> memberListTL= new List<Member__c>();
        List<Member__c> memberListQC= new List<Member__c>();
        List<Member__c> memberListPA= new List<Member__c>();
        
        List<File_Categories__c> filecat = new List<File_Categories__c>();        
        File_Categories__c fileCategory = new File_Categories__c();
        fileCategory.Name = 'Test';
        fileCategory.Standard_Time_per_File_Min__c=11;
        fileCategory.Standard_Time_per_File_Max__c=20;
        fileCategory.Standard_Regular_Cost_per_File__c=3;
        fileCategory.Standard_OptionalCost_Per_file__c=1;
        filecat.add(fileCategory);
        insert filecat;
        
        Performance_Rating__c pr = new Performance_Rating__c();
        pr.name='New';
        pr.File_Category__c=fileCategory.id;
        insert pr;
        
        Member__c MemberTest =new Member__c();
        MemberTest.Name='Alexandar';     
        MemberTest.Location_id__c=location.Id;
        MemberTest.Last_Name__c='Fleming';
        MemberTest.Email__c='alexflemtl@mbo.in';
        MemberTest.Country__c='India';
        MemberTest.Designation__c='Team Leader';
        MemberTest.Status__c='Active';
        MemberTest.Performance_Rating__c=pr.id;
        MemberTest.Today_Attendance__c = 'NW';
        insert MemberTest;
        
        Member__c tlMemberTest =new Member__c();
        tlMemberTest.Name='Aandar';     
        tlMemberTest.Location_id__c=location.Id;
        tlMemberTest.Last_Name__c='Fleming';
        tlMemberTest.Email__c='alemtl@mbo.in';
        tlMemberTest.Country__c='India';
        tlMemberTest.Designation__c='Team Leader';
        tlMemberTest.Status__c='Active';
        tlMemberTest.Today_Attendance__c = 'NW';
        memberListTL.add(tlMemberTest);
        insert memberListTL;
        
        Member__c PAMemberTest =new Member__c();
        PAMemberTest.Name='Aandar';     
        PAMemberTest.Location_id__c=location.Id;
        PAMemberTest.Last_Name__c='Fleming';
        PAMemberTest.Email__c='alelemtl@mbo.in';
        PAMemberTest.Country__c='India';
        PAMemberTest.Designation__c='Photo Artists';
        PAMemberTest.Status__c='Active';
        PAMemberTest.Today_Attendance__c = 'NW';
        memberListPA.add(PAMemberTest);
        insert memberListPA;
        
        Member__c qcMemberTest =new Member__c();
        qcMemberTest.Name='Ramkumar S';     
        qcMemberTest.Location_id__c=location.Id;
        qcMemberTest.Last_Name__c='Sundaresan';
        qcMemberTest.Email__c='ramkumarmql@mbo.in';
        qcMemberTest.Country__c='India';
        qcMemberTest.Designation__c='Quality Control';
        qcMemberTest.Status__c='Active';
        qcMemberTest.Today_Attendance__c = 'A';
        memberListQC.add(qcMemberTest);
        insert memberListQC;
        
        Job_Titles__c jobNames = new Job_Titles__c();
        jobNames.Name = 'Cropping,Clipping,Soft Mask';
        insert jobNames;
        
        List<Files__c> fileQAList = new List<Files__c>();
        List<Files__c> filePAList = new List<Files__c>();
        
        
        if(memberListQC.size()>0){
            for(integer i=0;i<10;i++){
                Files__c file = new Files__c();
                file.Production_Order__c=po1.id;
                file.Name='TestFA'+i;
                file.File_Category_Code__c=fileCategory.id;
                file.Status__c='QC';
                file.File_Location__c=location.Id;
                file.Member__c=PAMemberTest.Id;
                file.QCIncharge__c=qcMemberTest.Id;
                file.TLInCharge__c=tlMemberTest.id;
                file.Current_Extension__c='.jpg';
                file.Files_To_open__c = 1;
                file.File_type__c='image';
                fileQAList.add(file);
            }
            insert fileQAList;
        }
        if(memberListPA.size()>0){
            for(integer i=0;i<15;i++){
                Files__c file = new Files__c();
                file.Production_Order__c=po1.id;
                file.Name='TestFA'+i;
                file.File_Category_Code__c=fileCategory.id;
                file.File_Location__c=location.Id;
                file.Status__c='QC';
                file.Member__c=PAMemberTest.Id;
                file.QCIncharge__c=qcMemberTest.Id;
                file.TLInCharge__c=tlMemberTest.id;
                file.Current_Extension__c='.jpg';
                file.Files_To_open__c = 1;
                file.File_type__c='image';
                filePAList.add(file);
            }
            insert filePAList;
        }
        Mistakes__c mistake = new Mistakes__c();
        mistake.Penalty_for_Artist__c = 50;
        mistake.Penalty_for_QC__c = 25;
        mistake.Mistake_Description__c = 'Test Creation of mistake :::';
        mistake.MIstake_Category__c = 'COMMON MISTAKES';
        mistake.Mistake__c = 'HOLES REMAINING';
        mistake.Location__c = location.Id;
        insert mistake;   
    }  
    static testMethod void Test_FileDetailservice() {
        List<Member__c> mem= new List<Member__c>();
        mem =  [SELECT Id,Name,Location_id__c,Designation__c,User_Id__c FROM Member__c WHERE status__c='Active' limit 1];
        // Member__c member =[select id,Name,User_Id__c,Performance_Rating__c,Performance_Rating__r.Name from Member__c where User_Id__c =:userinfo.getuserid()];      
        Test.StartTest();
        WS_FileDetailService FileService = new WS_FileDetailService();
        FileService.getQCFile(mem[0].User_Id__c);
        FileService.getFile(mem[0].User_Id__c);
        FileService.getFilesforEstimation(mem[0].User_Id__c);
        FileService.getJobTitles();
        FileService.getMistakes(mem[0].User_Id__c);
          Try{
            List<File_Categories__c> fc= FileService.getCategories();
        }catch(Exception e){
            
        }
        Test.stopTest(); 
    }   
}