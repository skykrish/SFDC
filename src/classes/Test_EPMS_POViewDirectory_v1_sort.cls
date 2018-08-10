/**********************************************************************************
*   Class               :       Test_EPMS_POViewDirectory_v1_sort                 *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_POViewDirectory_v1_sort       *
**********************************************************************************/
@istest
public class Test_EPMS_POViewDirectory_v1_sort{

    @testSetup static void setupTestData(){ 
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;

        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='rvikram07@gmail.com';
        insert usermail;
        
        Member__c qcmember =new Member__c();
        qcmember.Name='TONY';     
        qcmember.Location_id__c=location.id;
        qcmember.Last_Name__c='ABBOTT';
        qcmember.Email__c='tonyabboott1145@gmail.com';
        qcmember.Country__c='India';
        qcmember.Designation__c='Quality Control';
        qcmember.Status__c='Active';
        insert qcmember; 
        
        Member__c qcmember2 =new Member__c();
        qcmember2.Name='BENZ';     
        qcmember2.Location_id__c=location.id;
        qcmember2.Last_Name__c='PARK';
        qcmember2.Email__c='tonyabboott1222@gmail.com';
        qcmember2.Country__c='India';
        qcmember2.Designation__c='Quality Control';
        qcmember2.Status__c='Active';
        insert qcmember2; 
        
        Member__c member =new Member__c();
        member.Name='MARK';     
        member.Location_id__c=location.id;
        member.Last_Name__c='PHILIPS';
        member.Email__c='testphotoartists1212@gmail.com';
        member.Country__c='India';
        member.Designation__c='Operator PS';
        member.Status__c='Active';
        insert member; 
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='O0002530';
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        po.Job_List__c = 'Cropping,Clipping';
        po.QC_InCharge__c = qcmember2.Id;
        insert po;

        List<Files__c> fileList = new List<Files__c>();
        
        File_Categories__c fc= new File_Categories__c();
        fc.Name ='AB';
        fc.Standard_Time_per_File_Min__c =11;
        fc.Standard_Time_per_File_Max__c =20;
        fc.Standard_Regular_Cost_per_File__c =934;
        fc.Standard_OptionalCost_Per_file__c =5;
        
        insert fc;
 
        Files__c folderfile = new Files__c();
        folderfile.Name ='Ordinary_Folder_Test_1';
        folderfile.Production_Order__c =po.id;
        folderfile.File_Category_Code__c =fc.id;
        folderfile.Status__c ='Assigned';
        folderfile.File_Location__c=location.id;
        folderfile.Current_Extension__c ='.jpg';
        folderfile.File_Type__c = 'Directory';
        folderfile.Member__c = member.Id;
        insert folderfile;  
        
        for(Integer i=1;i<=6;i++){
            Files__c file= new Files__c();
            file.Name ='Handover_FILE_Test_tes'+i;
            file.Production_Order__c =po.id;
            file.File_Job_Titles__c = 'Cropping';
            file.File_Category_Code__c =fc.id;
            if(i == 2){
                file.Status__c='Cancelled';
            } 
            if(i ==3){
                file.FTP_Upload_Status__c=true;
                file.Files_To_open__c = 1; 
                file.File_PS_Version__c = 'CS6';
                file.InstructionNames__c = 'another instruction 3';
                file.File_Type__c = 'Instruction';
            }
            if(i == 5){
                file.InstructionNames__c = 'another instruction 2';
                file.File_Type__c = 'Instruction';
                file.Status__c ='Approved';
            } else {
                file.Status__c ='Assigned';
            }    
            file.File_Location__c=location.id;
            file.Current_Extension__c ='.jpg';
            if(i ==2){
                file.InstructionNames__c = 'next instructuin';
                file.File_Type__c = 'Instruction';            
            } else {
                file.InstructionNames__c = 'next instructuin';
                file.File_Type__c = 'image';
            } 
            
            file.Member__c = member.Id;
            file.Parent_Id__c = folderfile.Id;
            fileList.add(file);
        }
        
        insert fileList;
        
        List<files__c> testList2 = new List<files__c>();
        LIst<files__c> updateList = new List<files__c>();
        for(Integer i=1;i<=6;i++){
            Files__c file= new Files__c();
            file.Name ='Handover_FILE_Test_'+i;
            file.Production_Order__c =po.id;
            file.File_Job_Titles__c = 'Correction Mask Without Clipping Path';
            file.InstructionNames__c = 'This is instruciton';
            file.File_Type__c = 'File Instruction';
            file.File_Category_Code__c =fc.id;
            file.File_Location__c=location.id;
            file.Current_Extension__c ='.pdf';
            file.Member__c = member.Id;
            file.Parent_Id__c = folderfile.Id;
            testList2.add(file);
        }
        insert testList2;
        
        for(files__c file:testList2){
            file.InstructionNames__c =file.id+',this is instruction';
            file.File_Type__c = 'Image';
            updateList.add(file);
        }
        update updateList;
        List<files__c> testList3 = new List<files__c>();
        
        for(Integer i=1;i<=6;i++){
            Files__c file= new Files__c();
            file.Name ='Handover_FILE_Test_'+i;
            file.Production_Order__c =po.id;
            file.File_Job_Titles__c = 'Correction Mask Without Clipping Path';
            file.InstructionNames__c = 'This is instruciton';
            file.File_Type__c = 'File Instruction';
            file.File_Category_Code__c =fc.id;
            file.File_Location__c=location.id;
            file.Current_Extension__c ='.pdf';            
            file.Member__c = member.Id;
            file.Parent_Id__c = folderfile.Id;
            testList3.add(file);
        }
        insert testList3;
        
        Team__c Team=new Team__c();
        Team.Name='Test Team';
        Team.Location__c=location.id;
        insert Team;
        
        Shift__c Shifts=new Shift__c();
        Shifts.Shift_Location__c=location.id;
        Shifts.Name='1st Shift - Phase 1';
        insert Shifts; 
    }   
    
    public static testMethod void POViewDirectory_v1_test() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order2.id];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        Member__c qcmember = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Name='TONY'];     
        
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
        EPMSVD.selQcForQC = qcmember.Id;
        EPMSVD.sortingChoice = 'Status';
        EPMSVD.sortType = 'DESC';
        EPMSVD.getdisplayOrderFiles2();
        Test.stopTest();
        
    }
    
    
    public static testMethod void POViewDirectory_v1_case_3() {
        
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
        EPMSVD2.refreshRedoRecordsForOrderFiles();
        
        EPMSVD2.wrapperList[0].isSelected = true;
        EPMSVD2.wrapperList[1].isSelected = true;
        EPMSVD2.wrapperList[2].isSelected = true;
        EPMSVD2.updateObject();
        string t1=EPMSVD2.getAllDetails();
        EPMSVD2.parentChildNodes();
        EPMSVD2.ViewClassification();
        EPMSVD2.orderInformation();
        EPMSVD2.viewDirectory();
        //EPMSVD2.ExportToExcel();
        EPMSVD2.wrapperList[0].isSelected = true;
        EPMSVD2.wrapperList[1].isSelected = true;
        EPMSVD2.wrapperList[2].isSelected = true;
        EPMSVD2.savePSCS6();
        
        Test.stopTest();
        
    }   
    public static testMethod void POViewDirectory_v1_case_4() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        Production_Order__c order1 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order1.id];
        
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
        
        Production_Order__c order2 = [SELECT Id, Name,Mbo_Location__c FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order2.id];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        
        
        String fileIds = '';
        for(integer i=0;i<fileList.size()-1; i++){
            if(fileIds == ''){
                fileIds = fileList[i+1].id ;
            } else {
                fileIds += ',' +  fileList[i+1].id;
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
        EPMS_POViewDirectory_v1_sort EPMSVD5 = new  EPMS_POViewDirectory_v1_sort();
        
        EPMSVD5.getItems();
        EPMSVD5.DisplayGrid();      
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
        EPMSVD5.refresh();
        
        Test.stopTest();   
    }   

    public static testMethod void POViewDirectory_v1_case_6() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order2.id];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        Member__c qcmember = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Name='TONY'];    
        
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
        EPMSVD6.selQcForQC = qcmember.Id;
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
        EPMSVD6.getdisplayOrderFiles2();
        EPMSVD6.wrapperList[4].isSelected = true;
        EPMSVD6.savePSCC();
        
        EPMS_POViewDirectory_QueryLocator queryloc=new EPMS_POViewDirectory_QueryLocator();
        
        queryloc.getFilesRelatedToProductionOrderWithoutPage(order2.Id);
        queryloc.getFilesCategoryCount(order2.Id);
        queryloc.getFilesRelatedToProductionOrder(order2.Id);
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','Clipping','Status','ASC');
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','Clipping','Status','DESC');
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','Clipping','Operator','ASC');
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','Clipping','Operator','DESC');
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','Clipping','Category','ASC');
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','Clipping','Category','DESC');
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','Clipping','Name','ASC');
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','Clipping','Name','DESC');
        
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','None','Status','ASC');
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','None','Status','DESC');
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','None','Operator','ASC');
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','None','Operator','DESC');
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','None','Category','ASC');
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','None','Category','DESC');
        queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','None','Name','ASC');
        //queryloc.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','None','None','Name','DESC');
    
        Test.stopTest();
 
    }   
    
    public static testMethod void POViewDirectory_v1_case_7() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        Production_Order__c order2 = [SELECT Id, Name,Jobs_List__c,Job_List__c,Production_Order_Status__c FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name,	File_Job_Titles__c FROM Files__c WHERE Production_Order__c =: order2.id];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        integer l = 0;
        for(files__c f:fileList){
            l++;
            if(l == 3){
                f.File_Type__c = 'image';
                f.InstructionNames__c = f.id+'this is second ins';
            }else{
                f.File_Type__c = 'image';
                f.InstructionNames__c = f.id;
            }
            
        }
        update fileList;
        
        
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
        if(order2.Production_Order_Status__c=='Pending'){
             pagereference pg12 = EPMSVD7.savePOStatus();
        }
       
        EPMSVD7.sortingChoice = 'Operator';
        EPMSVD7.sortType = 'ASC';

        Shift__c ShiftID=[select id,Name from Shift__c where Name='1st Shift - Phase 1'];
        Team__c TeamID=[select id,Name from Team__c where Name='Test Team'];

        EPMSVD7.selShiftForQC = ShiftID.id;
        EPMSVD7.selTeamForQC =  TeamID.id;
        EPMSVD7.selShift = ShiftID.id;
        EPMSVD7.selTeam = TeamID.id;
        
        EPMSVD7.DisplayList();
        EPMSVD7.changeShiftForQC();
        EPMSVD7.changeTeamforQC();
        list<Files__C> FT = EPMSVD7.repostFiles(fileIds);
        list<Files__C> FT2 =EPMSVD7.repostDeleteFiles(fileIds);
        EPMSVD7.ConvertToorder();
        EPMSVD7.ConvertToInstruction();
        EPMSVD7.getAllTypeCategory();
        EPMSVD7.refreshPageRecordsList();
        EPMSVD7.newFileForPageCount = 20;
        EPMSVD7.refreshPageRecords();
        EPMSVD7.refreshRedoRecords();
        EPMSVD7.filterByStatus();
        EPMSVD7.changeShift();
        EPMSVD7.changeTeam();
        EPMSVD7.saveChanges();
        EPMSVD7.closeChangeTLPopup();
        pagereference pg = EPMSVD7.closepage();
        EPMSVD7.refreshOrderFilesPage();
        pagereference pg1 = EPMSVD7.Previous();
        
        Test.stopTest();
    } 
    
    public static testMethod void POViewDirectory_v1_case_8() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order2.id];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        Member__c qcmember = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Name='TONY'];    
        
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
        
        
        EPMS_POViewDirectory_QueryLocator querylocator=new EPMS_POViewDirectory_QueryLocator();
        
        
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','Clipping','Status','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','Clipping','Status','DESC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','Clipping','Operator','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','Clipping','Operator','DESC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','Clipping','Category','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','Clipping','Category','DESC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','Clipping','Name','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','Clipping','Name','DESC');
        
        
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','Clipping','Status','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','Clipping','Status','DESC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','Clipping','Operator','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','Clipping','Operator','DESC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','Clipping','Category','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','Clipping','Category','DESC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','Clipping','Name','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','Clipping','Name','DESC');
        
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','Clipping','Name','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','Clipping','Name','DESC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','Clipping','Status','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','Clipping','Status','DESC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','Clipping','Operator','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','Clipping','Operator','DESC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','Clipping','Category','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','Clipping','Category','DESC');
        
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','None','Name','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','None','Name','DESC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','None','Status','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','None','Status','DESC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','None','Operator','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','None','Operator','DESC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','None','Category','ASC');
        querylocator.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','AB','None','Category','DESC');
        Test.stopTest();
    }   
    
    
    public static testMethod void POViewDirectory_v1_case_9() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order2.id];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        Member__c qcmember = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Name='TONY'];    
        
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

        EPMS_POViewDirectory_Service POService=new EPMS_POViewDirectory_Service();
        EPMS_POViewDirectory_QueryLocator querylocator2=new EPMS_POViewDirectory_QueryLocator();

        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','None','Status','ASC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','None','Status','DESC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','None','Operator','ASC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','None','Operator','DESC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','None','Category','ASC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','None','Category','DESC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','None','Name','ASC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Assigned','None','None','Name','DESC');
        
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','None','Status','ASC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','None','Status','DESC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','None','Operator','ASC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','None','Operator','DESC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','None','Category','ASC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','None','Category','DESC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','None','Name','ASC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'None','AB','None','Name','DESC');
        
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Name','ASC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Name','DESC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Operator','ASC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Operator','DESC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Category','ASC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Category','DESC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Status','ASC');
        querylocator2.getFilesRelatedToProductionOrder(order2.Id,10,10,'Status','DESC');
        
        POService.getFilesRelatedToProductionOrder(order2.Id,10,10,'Status','ASC');
        POService.getFilesRelatedToProductionOrder(order2.Id,10,10,'Status');
        POService.getFilesCategoryCount(order2.Id);
        POService.getProductionOrderTLInchargeDetails(order2.Id);
        POService.getFilesRelatedToProductionOrderCount(order2.Id);
        POService.getFilesRelatedToProductionOrderWithoutPage(order2.Id);
        POService.getFilesRelatedToProductionOrder(order2.Id);
        POService.getMemberDesignation(qcmember.User_Id__c);

        Test.stopTest();
    }

    public static testMethod void POViewDirectory_v1_case_10() {
        
        PageReference pageRef = Page.EPMS_PO_ViewDirectory;
        
        Production_Order__c order2 = [SELECT Id, Name,Mbo_Location__c FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order2.id];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        
        
        String fileIds = '';
        for(integer i=0;i<fileList.size()-1; i++){
            if(fileIds == ''){
                fileIds = fileList[i+1].id ;
            } else {
                fileIds += ',' +  fileList[i+1].id;
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
        
        EPMS_POViewDirectory_v1_sort EPMSVD5 = new  EPMS_POViewDirectory_v1_sort();
        EPMS_POViewDirectory_v1_sort.cNodes EPMSVD56 = new  EPMS_POViewDirectory_v1_sort.cNodes(folderfile,fileList);
        EPMS_POViewDirectory_v1_sort.WrapperFiles EPMSVD57 = new  EPMS_POViewDirectory_v1_sort.WrapperFiles('',10,10,5);
        
        EPMSVD5.setFileListInsruction('File.jpg');
        string xlsHeader ='Application Header';
        pagereference pg = EPMSVD5.savePOStatus();
        //pagereference pg1 = EPMSVD5.ExportToExcel();
         //pagereference pg2 = EPMSVD5.redirectVDPopup();
        EPMSVD5.getItems();
        EPMSVD5.DisplayGrid();      
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
        EPMSVD5.refresh();
        
        Test.stopTest();   
    }       

}