/**********************************************************************************
*   Class               :       Test_EPMS_FileEstimator_Assignment_Ctrl                     *
*   Created Date        :       12/01/2018                                                  *           
*   Description         :       Test class for EPMS_FileEstimator_Assignment_Controller     *
**********************************************************************************/
@istest
public class Test_EPMS_FileEstimator_Assignment_Ctrl {
    
    @testSetup static void setupTestData(){ 
        
        Account acc=new Account(Name='TEST ACC');
        insert acc;
        
        Anken__c ank=new Anken__c(KokyakuName__c=acc.Id,Status__c='Open',Sagyoshiji_Renrakujiko__c='please refer PDF for instructions',
                                  Nouki_Date__c=System.Today());
        insert ank;
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;
        
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testphotoartist123@mbo.in';
        insert usermail;
        
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        system.debug('Email ::' + usermail);
        Member__c qcmember =new Member__c();
        qcmember.Name='TONY';     
        qcmember.Location_id__c=location.id;
        qcmember.Last_Name__c='ABBOTT';
        qcmember.Email__c='tonyabboott@gmail.com';
        qcmember.Country__c='India';
        qcmember.Designation__c='Quality Control';
        qcmember.Status__c='Active';
        insert qcmember; 
        
        
        List<Job_Titles__c> jobList = new List<Job_Titles__c>();
        
        Job_Titles__c newJob1 = new Job_Titles__c();
        newJob1.Name = 'Cropping';
        jobList.add(newJob1);
        
        Job_Titles__c newJob2 = new Job_Titles__c();
        newJob2.Name = 'Clipping';
        jobList.add(newJob2);
        
        Job_Titles__c newJob3 = new Job_Titles__c();
        newJob3.Name = 'Soft Mask';
        jobList.add(newJob3);
        
        Job_Titles__c newJob4 = new Job_Titles__c();
        newJob4.Name = 'Alpha Masking';
        jobList.add(newJob4);
        
        if(jobList.size() > 0){
            insert jobList;
        }
        
        Member__c member =new Member__c();
        member.Name='MARK';     
        member.Location_id__c=location.id;
        member.Last_Name__c='PHILIPS';
        member.Email__c='testphotoartists@gmail.com';
        member.Country__c='India';
        member.Designation__c='Quality Control';
        member.Status__c='Active';
        member.Is_Estimator__c = true;
        insert member; 
        system.debug('MEMBER 1 ::' + member);
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='O0002530';
        po.Production_Order_Status__c ='Estimation Request';
        po.Anken_Order__c=ank.id;
        po.MBO_Location__c=location.Id;
        po.QC_InCharge__c = member.Id;
        insert po;
        
        Job_Titles__c jobNames = new Job_Titles__c();
        jobNames.Name = 'Cropping';
        insert jobNames;
        
        Job_Titles__c jobNames2 = new Job_Titles__c();
        jobNames2.Name = 'Clipping';
        insert jobNames2;
        
        
        system.debug('PRODUCTION ORDER 2 ::' + po);
        
        List<Files__c> fileList = new List<Files__c>();
        
        File_Categories__c fc= new File_Categories__c();
        fc.Name ='AB';
        fc.Standard_Time_per_File_Min__c =11;
        fc.Standard_Time_per_File_Max__c =20;
        fc.Standard_Regular_Cost_per_File__c =934;
        fc.Standard_OptionalCost_Per_file__c =5;
        
        insert fc;
        
        File_Categories__c fc1= new File_Categories__c();
        fc1.Name ='AM';
        fc1.Standard_Time_per_File_Min__c =5;
        fc1.Standard_Time_per_File_Max__c =10;
        fc1.Standard_Regular_Cost_per_File__c =1000;
        fc1.Standard_OptionalCost_Per_file__c =9;
        insert fc1;
        
        File_Categories__c fc2= new File_Categories__c();
        fc2.Name ='AX';
        fc2.Standard_Time_per_File_Min__c =25;
        fc2.Standard_Time_per_File_Max__c =40;
        fc2.Standard_Regular_Cost_per_File__c =582;
        fc2.Standard_OptionalCost_Per_file__c =18;
        insert fc2;
        
        Files__c folderfile = new Files__c();
        folderfile.Name ='Ordinary_Folder_Test_1';
        folderfile.Production_Order__c =po.id;
        folderfile.File_Category_Code__c =fc.id;
        folderfile.Status__c ='Estimation Request';
        folderfile.File_Location__c=location.id;
        folderfile.Current_Extension__c ='.jpg';
        folderfile.File_Type__c = 'Image';
        folderfile.Estimator__c =member.id;
        folderfile.InstructionNames__c = 'THIS IS SAMPLE FOLDER INSTRUCTION';
        insert folderfile;  
        
        for(Integer i=1;i<=6;i++){
            Files__c file= new Files__c();
            file.Name ='Handover_FILE_Test_'+i;
            file.Production_Order__c =po.id;
            //file.File_Category_Code__c =fc.id;
            file.InstructionNames__c = 'THIS IS TEST SAMPLE FILE INSTRUCTION';
            file.File_Job_Titles__c = 'Clipping, Cropping';
            if(i == 2){
                file.Status__c='Estimation Request';
                file.File_Category_Code__c =fc.id;
            } 
            if(i ==3){
                file.FTP_Upload_Status__c=true;
                file.Files_To_open__c = 1; 
                file.File_PS_Version__c = 'CS6';
                file.File_Category_Code__c =fc2.id;
            }
            if(i == 5){
                file.Status__c ='Approved';
            } else {
                file.Status__c ='Assigned';
                file.File_Category_Code__c =fc1.id;
            }    
            file.File_Location__c=location.id;
            file.Current_Extension__c ='.jpg';
            if(i ==2){
                file.File_Type__c = 'Instruction';            
            } else {
                file.File_Type__c = 'Image';
            } 
            
            file.Parent_Id__c = folderfile.Id;
            fileList.add(file);
        }
        insert fileList;
        
        List<Files__c> newUpdtListFiles = new List<Files__c>();
        List<Files__c> fileResList = [SELECT Id, Name, Status__c, File_Type__c, InstructionNames__c FROM Files__c WHERE Production_Order__c =: po.id];
        String InstFileDesc = '';
        if(fileResList != null && fileResList.size() > 0){
            
            for(Files__c newFilesFromOrder : fileResList){
                if(InstFileDesc == ''){
                    InstFileDesc = newFilesFromOrder.Id;
                } else {
                    InstFileDesc += ','+newFilesFromOrder.Id;
                }
            }
            
            if(InstFileDesc  != null){
                for(Files__c newFilesFromOrder : fileResList){
                    if(newFilesFromOrder.File_Type__c == 'Image'){
                        newFilesFromOrder.InstructionNames__c = InstFileDesc;
                        newUpdtListFiles.add(newFilesFromOrder);              
                    }
                }
            }
            if(newUpdtListFiles.size() > 0){
                update newUpdtListFiles;
            }
            
        }
    }
    
    public static testMethod void TestFileAssignment1() {
        
        PageReference pageRef = Page.EPMS_FileEstimator_Assignment;
        Test.setCurrentPage(pageRef);
        
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name,File_Location__c,Production_Order_Name__c FROM Files__c WHERE Production_Order__c =: order2.id];
        Files__c folderfile = [SELECT Id, Name,Estimator__c FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        
        Test.startTest();
        
        pageRef.getParameters().put('ids', String.valueOf(folderfile.Id));
        EPMS_FileEstimator_Assignment_Controller fileEstimator = new EPMS_FileEstimator_Assignment_Controller();
        fileEstimator.getEstimators();        
        fileEstimator.setSelectedEstimator(folderfile.Estimator__c);
        fileEstimator.getSelectedEstimator();
        fileEstimator.assignEstimator();
        fileEstimator.Cancel();
        test.stopTest();   
    }
    @isTest static void TestFileAssignment2() {
        
        string s1='TestNew';
        PageReference pageRef = Page.EPMS_FileEstimator_Assignment;
        Test.setCurrentPage(pageRef);
        
        String basepath = ApexPages.currentPage().getParameters().get('source');
        String type = ApexPages.currentPage().getParameters().get('type');
        boolean diableButton;
        test.startTest();
        EPMS_FileEstimator_Assignment_Controller fileEstimator = new EPMS_FileEstimator_Assignment_Controller();
        fileEstimator.Cancel();
        fileEstimator.getSelectedEstimator();
        fileEstimator.assignEstimator();
        fileEstimator.setSelectedEstimator(s1);  
        test.stopTest();
    }
    @isTest static void TestFileAssignment57() {
        boolean updatefile = false;
        PageReference pageRef = Page.EPMS_FileEstimator_Assignment;
        Test.setCurrentPage(pageRef);
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name,File_Location__c,Production_Order_Name__c,Estimator__c,Status__c FROM Files__c WHERE Production_Order__c =: order2.id];
        
        test.startTest();
        EPMS_FileEstimator_Assignment_Controller fileEstimator = new EPMS_FileEstimator_Assignment_Controller();
        if(fileList.size()>0){
            updatefile = True;
        }
        if(updatefile){
            UPDATE fileList;
        }
        fileEstimator.assignEstimator();
        test.stopTest();
    }
}