@istest
public class Test_EPMS_POViewDirectory_sort{
    
    @testSetup static void setupTestData(){ 
        
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
        
        Team__c team3 = new Team__c();
        team3.Name='Team C';
        team3.Location__c=location.id;             
        insert team3;
        system.debug('TEAM 3 ::' + team3);
        
        Team__c team4 = new Team__c();
        team4.Name='Team D';
        team4.Location__c=location.id;             
        insert team4;
        
        Shift__c shift = new Shift__c();
        shift.Status__c='Active';
        shift.Name = 'testing Shift';
        shift.Shift_Location__c = location.Id;
        shift.Implements_From__c = system.now().addDays(3);
        shift.Shift_Start_Time__c = system.now();
        shift.Shift_End_Time__c = shift.Shift_Start_Time__c.addHours(9);
        insert shift;

        system.debug('Email ::' + usermail);
        Member__c qcmember =new Member__c();
        qcmember.Name='TONY';     
        qcmember.Location_id__c=location.id;
        qcmember.Last_Name__c='ABBOTT';
        qcmember.Email__c='tonyabboott@gmail.com';
        qcmember.Country__c='India';
        qcmember.Designation__c='Quality Control';
        qcmember.Status__c='Active';
        //insert qcmember; 

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
        
        system.debug('Email ::' + usermail);
        Member__c qcmember2 =new Member__c();
        qcmember2.Name='BENZ';     
        qcmember2.Location_id__c=location.id;
        qcmember2.Last_Name__c='PARK';
        qcmember2.Email__c='testmbotestuser@mbo.in';
        qcmember2.Country__c='India';
        qcmember2.Designation__c='Quality Control';
        qcmember2.Status__c='Active';
        qcmember2.Team_Id__c = team3.Id;
        //insert qcmember2; 
        
        Member__c tlmember =new Member__c();
        tlmember.Name='HENRY';     
        tlmember.Location_id__c=location.id;
        tlmember.Last_Name__c='FORD';
        tlmember.Email__c='heryfordjohnson@gmail.com';
        tlmember.Country__c='India';
        tlmember.Designation__c='Team Leader';
        tlmember.Status__c='Active';
        tlmember.Team_Id__c = team3.Id;
        //insert tlmember; 
        
        Member__c member =new Member__c();
        member.Name='MARK';     
        member.Location_id__c=location.id;
        member.Last_Name__c='PHILIPS';
        member.Email__c='testphotoartists@gmail.com';
        member.Country__c='India';
        member.Designation__c='Photo Artists';
        member.Team_Id__c = team3.Id;
        member.Status__c='Active';
        //insert member; 
        system.debug('MEMBER 1 ::' + member);
        
        List<Shift_Assignments__c> shiftList = new List<Shift_Assignments__c>();
        
        Shift_Assignments__c shiftass=new Shift_Assignments__c();
        shiftass.Shift_Code__c=shift.id;
        //shiftass.Member__c=member.id;
        shiftass.Location__c=location.id;
        shiftass.FromTime__c=system.today();
        shiftass.Shift_Assigned__c=true;
        shiftList.add(shiftass);        
        
        Shift_Assignments__c shiftass1=new Shift_Assignments__c();
        shiftass1.Shift_Code__c=shift.id;
        //shiftass1.Member__c= qcmember2.id;
        shiftass1.Location__c=location.id;
        shiftass1.FromTime__c=system.today();
        shiftass1.Shift_Assigned__c=true;
        shiftList.add(shiftass1);  
        
        Shift_Assignments__c shiftass2=new Shift_Assignments__c();
        shiftass2.Shift_Code__c=shift.id;
        //shiftass2.Member__c= tlmember.id;
        shiftass2.Location__c=location.id;
        shiftass2.FromTime__c=system.today();
        shiftass2.Shift_Assigned__c=true;
        shiftList.add(shiftass2);  
        
        if(shiftList.size() > 0){
            insert shiftList;
        }         
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='O0002530';
        po.Production_Order_Status__c ='';
        po.MBO_Location__c=location.Id;
        po.QC_InCharge__c = qcmember2.Id;
        po.Production_Order_Status__c = 'Assigned';
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
        folderfile.Status__c ='Assigned';
        folderfile.File_Location__c=location.id;
        folderfile.Current_Extension__c ='.jpg';
        folderfile.File_Type__c = 'Directory';
        folderfile.InstructionNames__c = 'THIS IS SAMPLE FOLDER INSTRUCTION';
        //folderfile.Member__c = member.Id;
        insert folderfile;  
        
        for(Integer i=1;i<=6;i++){
            Files__c file= new Files__c();
            file.Name ='Handover_FILE_Test_'+i;
            file.Production_Order__c =po.id;
            //file.File_Category_Code__c =fc.id;
            file.InstructionNames__c = 'THIS IS TEST SAMPLE FILE INSTRUCTION';
            file.File_Job_Titles__c = 'Clipping, Cropping';
            if(i == 2){
                file.Status__c='Cancelled';
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
                //file.File_Type__c = 'image';
            } 
            
            //file.Member__c = member.Id;
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
    
    
    public static testMethod void POViewDirectory_v1() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        
        Production_Order__c order1 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order1.id];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        
        String fileIds = '';
        for(Files__c newFile : fileList){
            if(fileIds == ''){
                fileIds = newFile.Id; 
            } else {
                fileIds += ',' + newFile.Id;
            }
        }
        
        Test.StartTest(); 
        
        Test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('id',order1.Id);  
        pageRef.getParameters().put('openJobFiles',fileIds);
        pageRef.getParameters().put('openInstrFiles',folderfile.Id);
        pageRef.getParameters().put('convertToOrder',fileIds);
        pageRef.getParameters().put('convertToInstrMem',fileIds);
        pageRef.getParameters().put('convertToInstr',fileIds);
        pageRef.getParameters().put('deleteFilesID',fileIds);
        pageRef.getParameters().put('openFiles',fileIds);
        
        EPMS_POViewDirectory_v1_sort EPMSVD2 = new  EPMS_POViewDirectory_v1_sort();
        EPMSVD2.showJobTitlePopUp();
        EPMSVD2.showVDjobPopup();
        EPMSVD2.wrapperList[0].isSelected = true;
        EPMSVD2.wrapperList[1].isSelected = true;
        EPMSVD2.wrapperList[2].isSelected = true;
        EPMSVD2.showPopup();
        EPMSVD2.showJobTitlePopUp();
        EPMSVD2.showVDjobPopup();
        list<string> str = EPMSVD2.getVDEPMSJobList();
        EPMSVD2.updateVDJobPopup();
        EPMSVD2.closeVDJobPopup();
        list<string> str1 = EPMSVD2.getEPMSJobList();
        EPMSVD2.newFileForPageCount = 0;
        EPMSVD2.refreshPageRecords();
        //System.assertNotEquals(null,EPMSVD2.refreshPageRecordsList());
        EPMSVD2.refreshPageRecordsList();
        //EPMSVD2.savePOStatus();
        EPMSVD2.refreshRedoRecords();
        EPMSVD2.refreshRedoRecordsForOrderFiles();
        List<SelectOption> options = EPMSVD2.getAllTypeCategory();
        EPMSVD2.setFileListInsruction('TestData');
        
        EPMSVD2.wrapperList[0].isSelected = true;
        EPMSVD2.wrapperList[1].isSelected = true;
        EPMSVD2.wrapperList[2].isSelected = true;
        EPMSVD2.updateObject();
        string t1=EPMSVD2.getAllDetails();
        EPMSVD2.parentChildNodes();
        EPMSVD2.ViewClassification();
        EPMSVD2.orderInformation();
        EPMSVD2.selectedCategory = 'All';
        EPMSVD2.viewDirectory();
        EPMSVD2.refreshOrderFilesPage();
        EPMSVD2.closepage();
        EPMSVD2.Excel();
        //EPMSVD2.filterByStatus();
        System.assertNotEquals(null,EPMSVD2.ExportToExcel());
        EPMSVD2.wrapperList[0].isSelected = true;
        EPMSVD2.wrapperList[1].isSelected = true;
        EPMSVD2.wrapperList[2].isSelected = true;
        EPMSVD2.savePSCS6();
        
        
        
        Test.stopTest();
        
    } 
    
    public static testMethod void POViewDirectory_v1_test() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order2.id];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        //Member__c qcmember = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Name='TONY'];     
        //string values ='a0fN0000003R6BM';
        
        String fileIds = '';
        for(Files__c newFile : fileList){
            if(fileIds == ''){
                fileIds = newFile.Id; 
            } else {
                fileIds += ',' + newFile.Id;
            }
        }
        Test.StartTest(); 
        
        Test.setCurrentPage(pageRef);             
        pageRef.getParameters().put('id',order2.Id);  
        pageRef.getParameters().put('openJobFiles',fileIds);
        pageRef.getParameters().put('openInstrFiles',folderfile.Id);
        pageRef.getParameters().put('convertToOrder',fileIds);
        pageRef.getParameters().put('convertToInstrMem',fileIds);
        pageRef.getParameters().put('convertToInstr',fileIds);
        pageRef.getParameters().put('deleteFilesID',fileIds);
        pageRef.getParameters().put('openFiles',fileIds);
        
        EPMS_POViewDirectory_v1_sort EPMSVD = new  EPMS_POViewDirectory_v1_sort();   
        EPMSVD.displayOrderFiles();
        //EPMSVD.selQcForQC = qcmember.Id;
        EPMSVD.sortingChoice = 'Status';
        EPMSVD.sortType = 'DESC';
        EPMSVD.getdisplayOrderFiles2();
        
        Test.stopTest();
        
    }
    
    public static testMethod void POViewDirectory_v1_case_4() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        Production_Order__c order1 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order1.id];
        
        //string values ='a0fN0000003R6BM';
        
        String fileIds = '';
        for(Files__c newFile : fileList){
            if(fileIds == ''){
                fileIds = newFile.Id; 
            } else {
                fileIds += ',' + newFile.Id;
            }
        }
        //string values ='a0fN0000003R6BM';
        Test.StartTest(); 
        
        Test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('id',order1.Id);  
        pageRef.getParameters().put('openJobFiles',fileIds);
        pageRef.getParameters().put('openInstrFiles',folderfile.Id);
        pageRef.getParameters().put('convertToOrder',fileIds);
        pageRef.getParameters().put('convertToInstrMem',fileIds);
        pageRef.getParameters().put('convertToInstr',fileIds);
        pageRef.getParameters().put('deleteFilesID',fileIds);
        pageRef.getParameters().put('openFiles',fileIds);
        
        EPMS_POViewDirectory_v1_sort EPMSVD4 = new  EPMS_POViewDirectory_v1_sort();
        EPMSVD4.clearQueue();
        EPMSVD4.wrapperList[4].isSelected = true;
        EPMSVD4.showPopup();
        EPMSVD4.wrapperList[1].isSelected = true;
        EPMSVD4.showPopup();
        EPMSVD4.editFile();
        EPMSVD4.wrapperList[1].isSelected = true;
        EPMSVD4.wrapperList[2].isSelected = true;
        EPMSVD4.clearQueue();
        EPMSVD4.wrapperList[1].isSelected = true;
        EPMSVD4.wrapperList[2].isSelected = true;
        EPMSVD4.redirectPopup();
        EPMSVD4.removeDirectory = true;
        EPMSVD4.wrapperList[1].isSelected = true;
        EPMSVD4.wrapperList[2].isSelected = true;
        EPMSVD4.redirectPopup();
        EPMSVD4.redirectJobPopUp();
        //EPMSVD.openDirectoryForVD();
        //EPMSVD.openDirectoryForVDFiles();
        EPMSVD4.showVDFolPopup();
        EPMSVD4.redirectVDFolPopup();
        
        pageRef.getParameters().put('openInstrFiles',folderfile.Id);
        EPMSVD4.showVDFolPopup();
        EPMSVD4.redirectVDFolPopup();
        EPMSVD4.showVDjobPopup();
        EPMSVD4.changeTLIncharge();
        EPMSVD4.cancelVDFolPop();
        
        Test.stopTest();
    }
    public static testMethod void POViewDirectory_v1_case_5() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order2.id];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        //string values ='a0fN0000003R6BM';
        
        String fileIds = '';
        for(Files__c newFile : fileList){
            if(fileIds == ''){
                fileIds = newFile.Id; 
            } else {
                fileIds += ',' + newFile.Id;
            }
        }
        
        //string values ='a0fN0000003R6BM';
        Test.StartTest(); 
        
        Test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('id',order2.Id);  
        pageRef.getParameters().put('openJobFiles',fileIds);
        pageRef.getParameters().put('openInstrFiles',folderfile.Id);
        pageRef.getParameters().put('convertToOrder',fileIds);
        pageRef.getParameters().put('convertToInstrMem',fileIds);
        pageRef.getParameters().put('convertToInstr',fileIds);
        pageRef.getParameters().put('deleteFilesID',fileIds);
        pageRef.getParameters().put('openFiles',fileIds);
        EPMS_POViewDirectory_v1_sort EPMSVD5 = new  EPMS_POViewDirectory_v1_sort();
        
        EPMSVD5.getItems();
        EPMSVD5.DisplayGrid();
        //EPMSVD5.DisplayList();
        //EPMSVD5.changeShift();
        //EPMSVD5.changeTeam();
        //EPMSVD5.saveChanges();
        //EPMSVD5.changeShiftForQC();
        //EPMSVD5.changeTeamforQC();
        //EPMSVD5.saveQcChanges();
        list<Files__C> FT = EPMSVD5.repostFiles(fileIds);
        list<Files__C> FT2 =EPMSVD5.repostDeleteFiles(fileIds);
        EPMSVD5.ConvertToorder();
        EPMSVD5.convertToInstrFile();
        EPMSVD5.convertToInstructMember();
        EPMSVD5.ConvertToInstruction();
        EPMSVD5.deleteFiles();
        string valuedir = EPMSVD5.openDirectory();
        Boolean result = EPMSVD5.getDisablePrevious();
        Boolean result1 =EPMSVD5.getDisableNext();
        EPMSVD5.Next();
        EPMSVD5.Previous();
        EPMSVD5.refresh();
        
        Test.stopTest();
        
    }   
    
    
    public static testMethod void POViewDirectory_v1_case_6() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        //string values ='a0fN0000003R6BM';
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order2.id];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        //string values ='a0fN0000003R6BM';
        //Member__c qcmember = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Name='TONY'];    
        
        String fileIds = '';
        for(Files__c newFile : fileList){
            if(fileIds == ''){
                fileIds = newFile.Id; 
            } else {
                fileIds += ',' + newFile.Id;
            }
        }
        Test.StartTest(); 
        
        Test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('id',order2.Id); 
        pageRef.getParameters().put('openJobFiles',fileIds);
        pageRef.getParameters().put('openInstrFiles',folderfile.Id);
        pageRef.getParameters().put('convertToOrder',fileIds);
        pageRef.getParameters().put('convertToInstrMem',fileIds);
        pageRef.getParameters().put('convertToInstr',fileIds);
        pageRef.getParameters().put('deleteFilesID',fileIds);
        pageRef.getParameters().put('openFiles',fileIds);
        EPMS_POViewDirectory_v1_sort EPMSVD6 = new  EPMS_POViewDirectory_v1_sort();
        EPMSVD6.closeChangeQCPopup();
        EPMSVD6.changeQCIncharge();
        //EPMSVD.changeShiftForQC();
        //EPMSVD.changeTeamforQC();
        //EPMSVD6.selQcForQC = qcmember.Id;
        EPMSVD6.saveQcChanges();
        EPMSVD6.changeFileInstruion();
        EPMSVD6.closePopup();
        EPMSVD6.closeJobTitlePopup();
        EPMSVD6.cancel();
        EPMSVD6.showPopupVDFiles();
        EPMSVD6.wrapperList[0].isSelected = true;
        EPMSVD6.wrapperList[1].isSelected = true;
        EPMSVD6.wrapperList[2].isSelected = true;
        EPMSVD6.savePSCC();
        EPMSVD6.getJobList();
        EPMSVD6.getVDJobList();
        //EPMSVD6.updateJobTileChanges();
        EPMSVD6.getdisplayOrderFiles2();
        EPMSVD6.wrapperList[4].isSelected = true;
        EPMSVD6.savePSCC();
        Test.stopTest();
    }   
    
    
    public static testMethod void POViewDirectory_v1_case_7() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        //string values ='a0fN0000003R6BM';
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order2.id];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        //string values ='a0fN0000003R6BM';
        
        String fileIds = '';
        for(Files__c newFile : fileList){
            if(fileIds == ''){
                fileIds = newFile.Id; 
            } else {
                fileIds += ',' + newFile.Id;
            }
        }
        Test.StartTest(); 
        
        Test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('id',order2.Id); 
        pageRef.getParameters().put('openJobFiles',fileIds);
        pageRef.getParameters().put('openInstrFiles',folderfile.Id);
        pageRef.getParameters().put('convertToOrder',fileIds);
        pageRef.getParameters().put('convertToInstrMem',fileIds);
        pageRef.getParameters().put('convertToInstr',fileIds);
        pageRef.getParameters().put('deleteFilesID',fileIds);
        pageRef.getParameters().put('openFiles',fileIds);
        EPMS_POViewDirectory_v1_sort EPMSVD7 = new  EPMS_POViewDirectory_v1_sort();
        
        
        EPMSVD7.sortingChoice = 'Operator';
        EPMSVD7.sortType = 'ASC';
        EPMSVD7.DisplayList();
        EPMSVD7.newFileForPageCount = 20;
        EPMSVD7.refreshPageRecords();
        
        Test.stopTest();
    }        
    
    public static testMethod void POViewDirectory_v1_case_8() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        //string values ='a0fN0000003R6BM';
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order2.id];
        //Member__c tlmember = [SELECT Id, Name FROM Member__c WHERE Name = 'HENRY'];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        Team__c team = [SELECT id, Name FROM Team__c WHERE Name = 'Team C'];
        Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
        //string values ='a0fN0000003R6BM';
        
        String fileIds = '';
        for(Files__c newFile : fileList){
            if(fileIds == ''){
                fileIds = newFile.Id; 
            } else {
                fileIds += ',' + newFile.Id;
            }
        }
        Test.StartTest(); 
        
        Test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('id',order2.Id); 
        pageRef.getParameters().put('openJobFiles',fileIds);
        pageRef.getParameters().put('openInstrFiles',folderfile.Id);
        pageRef.getParameters().put('convertToOrder',fileIds);
        pageRef.getParameters().put('convertToInstrMem',fileIds);
        pageRef.getParameters().put('convertToInstr',fileIds);
        pageRef.getParameters().put('deleteFilesID',fileIds);
        pageRef.getParameters().put('openFiles',fileIds);
        EPMS_POViewDirectory_v1_sort EPMSVD8 = new  EPMS_POViewDirectory_v1_sort();
        EPMSVD8.showVDjobPopup();
        EPMSVD8.wrapperList[0].isSelected = true;
        //EPMSVD8.wrapperList[1].isSelected = true;
        //EPMSVD8.wrapperList[2].isSelected = true;
        String[] str = EPMSVD8.getVDEPMSJobList();
        EPMSVD8.setVDEPMSJobList(str);
        EPMSVD8.updateVDJobPopup();
        EPMSVD8.showPopup();
        EPMSVD8.showJobTitlePopUp();
        EPMSVD8.updateVDJobPopup();
        String[] str1 = EPMSVD8.getEPMSJobList();
        EPMSVD8.setEPMSJobList(str1);
        EPMSVD8.updateObject();
        EPMSVD8.selShift = shift.Id;
        //EPMSVD8.selTL = tlmember.Id;
        EPMSVD8.selTeam = team.Id;
        EPMSVD8.changeShift();
        EPMSVD8.closeChangeTLPopup();
        EPMSVD8.selShiftForQC = shift.Id;
        EPMSVD8.selTeamForQC = team.Id;
        EPMSVD8.changeShiftForQC();
        EPMSVD8.changeTeamforQC();
        EPMSVD8.changeTeam();
        EPMSVD8.saveChanges();
        EPMSVD8.sortingChoice = 'Status';
        EPMSVD8.sortType = 'ASC';
        EPMSVD8.viewDirectory = true;
        EPMSVD8.DisplayList();
        EPMSVD8.oldPageNumber = 1;
        EPMSVD8.newFileForPageCount = 5;
        EPMSVD8.refreshPageRecords();
        
        
        Test.stopTest();
    } 
    
    
    public static testMethod void POViewDirectory_v1_case_9() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        //string values ='a0fN0000003R6BM';
        List<Files__c> fileList = [SELECT Id, Name, Status__c, File_Type__c FROM Files__c WHERE Production_Order__c =: order2.id];
        //Member__c tlmember = [SELECT Id, Name FROM Member__c WHERE Name = 'HENRY'];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        Team__c team = [SELECT id, Name FROM Team__c WHERE Name = 'Team C'];
        Shift__c shift = [SELECT Id, Name FROM Shift__c WHERE Name = 'testing Shift'];
        //string values ='a0fN0000003R6BM';
        
        String fileIds = '';
        String insfileIds = '';
        for(Files__c newFile : fileList){
            if(newFile.File_Type__c != 'Instruction'){
                if(fileIds == ''){
                    fileIds = newFile.Id; 
                } else {
                    fileIds += ',' + newFile.Id;
                }
            } else if(newFile.File_Type__c == 'Instruction'){
                if(insfileIds == ''){
                    insfileIds = newFile.Id; 
                } else {
                    insfileIds += ',' + newFile.Id;
                }
            }
            
        }
        Test.StartTest(); 
        
        Test.setCurrentPage(pageRef); 
        pageRef.getParameters().put('id',order2.Id); 
        //pageRef.getParameters().put('openJobFiles',fileIds);
        pageRef.getParameters().put('openInstrFiles',folderfile.Id);
        pageRef.getParameters().put('convertToOrder',insfileIds);
        pageRef.getParameters().put('convertToInstrMem',fileIds);
        pageRef.getParameters().put('convertToInstr',fileIds);
        //pageRef.getParameters().put('deleteFilesID',fileIds);
        pageRef.getParameters().put('openFiles',fileIds);
        EPMS_POViewDirectory_v1_sort EPMSVD9 = new  EPMS_POViewDirectory_v1_sort();
        
        EPMSVD9.showPopup();
        EPMSVD9.showPopupVDFiles();
        EPMSVD9.showVDFolPopup();
        EPMSVD9.redirectVDPopup();
        EPMSVD9.ConvertToorder();
        EPMSVD9.sortingChoice = 'Name';
        EPMSVD9.sortType = 'DESC';
        EPMSVD9.DisplayList();
        EPMSVD9.sortingChoice = 'Operator';
        EPMSVD9.sortType = 'DESC';
        EPMSVD9.DisplayList();
        EPMSVD9.sortingChoice = 'Category';
        EPMSVD9.sortType = 'ASC';
        EPMSVD9.DisplayList();
        EPMSVD9.sortingChoice = 'Category';
        EPMSVD9.sortType = 'DESC';
        EPMSVD9.DisplayList();
        EPMSVD9.savePSCS6();
        EPMSVD9.savePSCC();
        EPMSVD9.wrapperList[0].isSelected = true;
        EPMSVD9.wrapperList[1].isSelected = true;
        EPMSVD9.wrapperList[2].isSelected = true;
        EPMSVD9.wrapperList[3].isSelected = true;
        EPMSVD9.wrapperList[4].isSelected = true;
        EPMSVD9.showPopup();
        EPMSVD9.ConvertToorder();
        EPMSVD9.ConvertToInstruction();
        EPMSVD9.convertToInstructMember();
        pageRef.getParameters().put('convertToInstr',insfileIds);
        EPMSVD9.ConvertToInstruction();
        EPMSVD9.openDirectory();
        EPMSVD9.oldPageNumber = 0;
        EPMSVD9.newFileForPageCount = 2;
        EPMSVD9.refreshPageRecords();
        EPMSVD9.orderInformation();
        Test.stopTest();
    } 
}