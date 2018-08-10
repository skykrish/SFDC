/**********************************************************************************
*   Class               :       Test_EPMS_ViewClassification                      *
*   Created Date        :       10/08/2016                                        *           
*   Description         :       Test class for EPMS_ViewClassification            *
**********************************************************************************/
@istest
public class Test_EPMS_ViewClassification{

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

        File_Categories__c fc= new File_Categories__c();
        fc.Name ='AB';
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
        
        
        
        Member__c qcmember =new Member__c();
        qcmember.Name='TONY';     
        qcmember.Location_id__c=location.id;
        qcmember.Last_Name__c='ABBOTT';
        qcmember.Email__c='tonyabboott1145@gmail.com';
        qcmember.Country__c='India';
        qcmember.Designation__c='Quality Control';
        qcmember.Status__c='Active';
        qcmember.Performance_Rating__c = newPerGroup.Id;
        insert qcmember; 

        Member__c qcmember2 =new Member__c();
        qcmember2.Name='BENZ';     
        qcmember2.Location_id__c=location.id;
        qcmember2.Last_Name__c='PARK';
        qcmember2.Email__c='tonyabboott1222@gmail.com';
        qcmember2.Country__c='India';
        qcmember2.Designation__c='Quality Control';
        qcmember2.Status__c='Active';
        qcmember2.Performance_Rating__c = newPerGroup.Id;
        insert qcmember2; 
        
        Member__c member =new Member__c();
        member.Name='MARK';     
        member.Location_id__c=location.id;
        member.Last_Name__c='PHILIPS';
        member.Email__c='testphotoartists1212@gmail.com';
        member.Country__c='India';
        member.Designation__c='Photo Artists';
        member.Status__c='Active';
        member.Performance_Rating__c = newPerGroup.Id;
        insert member; 

        Production_Order__c po=new Production_Order__c();
        po.Name ='O0002530';
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        po.QC_InCharge__c = qcmember2.Id;
        insert po;
        
        Job_Titles__c jobNames = new Job_Titles__c();
        jobNames.Name = 'Cropping';
        insert jobNames;

        Job_Titles__c jobNames2 = new Job_Titles__c();
        jobNames2.Name = 'Clipping';
        insert jobNames2;



        List<Files__c> fileList = new List<Files__c>();

        

        Files__c folderfile = new Files__c();
        folderfile.Name ='Ordinary_Folder_Test_1';
        folderfile.Production_Order__c =po.id;
        folderfile.File_Category_Code__c =fc.id;
        folderfile.Status__c ='Approved';
        folderfile.File_Location__c=location.id;
        folderfile.Current_Extension__c ='.jpg';
        folderfile.File_Type__c = 'Image';
        folderfile.Member__c = member.Id;
        insert folderfile;  
            
        for(Integer i=1;i<=26;i++){
            Files__c file= new Files__c();
            file.Name ='Handover_FILE_Test_'+i;
            file.Production_Order__c =po.id;
            file.File_Category_Code__c =fc.id;
            if(i == 2){
                file.Status__c='Cancelled';
            } 
            if(i ==3){
                file.FTP_Upload_Status__c=true;
                file.Files_To_open__c = 1; 
                file.File_PS_Version__c = 'CS6';
            }
            if(i == 5){
                file.Status__c ='New';
            } else {
                file.Status__c ='Approved';
            }    
            file.File_Location__c=location.id;
            file.Current_Extension__c ='.jpg';
            if(i ==2){
                file.File_Type__c = 'Instruction';            
            } else {
                file.File_Type__c = 'Image';
            } 
            
            file.Member__c = member.Id;
            file.Parent_Id__c = folderfile.Id;
            fileList.add(file);
        }
        insert fileList;
        
    }   

    public static testMethod void POViewDirectory_v1_test() {
   
        PageReference pageRef = Page.EPMS_View_Classifications;
   
        Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name ='O0002530'];
        List<Files__c> fileList = [SELECT Id, Name,File_Category_Code__r.Name FROM Files__c WHERE Production_Order__r.Name =: order2.Name];
        Files__c folderfile = [SELECT Id, Name FROM Files__c WHERE Name ='Ordinary_Folder_Test_1'];
        Member__c qcmember = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Name='TONY'];     
        List<Files__c> fileList1 = [SELECT Id, File_Category_Code__c,File_Type__c,Status__c,FTP_Upload_Status__c FROM Files__c WHERE Production_Order__r.Name =: order2.NAME];       
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
        pageRef.getParameters().put('ids',order2.Name+','+fileList[0].File_Category_Code__r.Name);  
        pageRef.getParameters().put('status','All');  

   
        EPMS_ViewClassification EPMSVD = new  EPMS_ViewClassification();   
        system.debug(' ORDER ID SET IS : ' + EPMSVD.orderID);
        system.debug(' ORDER ID SET IS WRAPPER : ' + EPMSVD.wrapperList);
        EPMSVD.getItems();
        EPMSVD.selectvalueCategory = fileList[0].File_Category_Code__c;
        EPMSVD.changeCategory();
        EPMSVD.updateCategory();
        EPMSVD.saveChangeCategory();
        EPMSVD.displayOrderFiles();
        EPMSVD.getdisplayOrderFiles2();
        EPMSVD.Next();
        EPMSVD.Previous();
        EPMSVD.getAllFileCategory();
        EPMSVD.sortingChoice = 'Status';
        EPMSVD.sortType = 'DESC';
        EPMSVD.getdisplayOrderFiles2();
        EPMSVD.getDisableNext();
        EPMSVD.getDisablePrevious();
        EPMSVD.refreshPageRecords();
        EPMSVD.refreshPageRecordsList();
        EPMSVD.refresh();
        EPMSVD.DisplayGrid();
        EPMSVD.DisplayList();
        EPMSVD.newFileForPageCount = 0;
        EPMSVD.refreshPageRecords();
        EPMSVD.newFileForPageCount = 10;
        EPMSVD.refreshPageRecords();
       
        EPMS_ViewClassification_Service queryloc=new EPMS_ViewClassification_Service ();
        List<Id> catIds = new List<Id>();
        List<Id> Ids = new List<Id>();
        for(Files__c fc:fileList1){
        if(fc.Id!=null){
        Ids.add(fc.Id);
        catIds.add(fc.File_Category_Code__c);
        }
        }

        queryloc.getChildFilesRecordsInfo(Ids);  
        queryloc.getFilesRelatedToProductionOrder(order2.Name,10,2000,'Name','ASC',FileList[0].File_Category_code__r.Name,'All');
        queryloc.getFilesRelatedToProductionOrder(order2.Name,10,2000,'Status','ASC',FileList[0].File_Category_code__r.Name,'All');
        queryloc.getFilesRelatedToProductionOrder(order2.Name,10,2000,'Operator','ASC',FileList[0].File_Category_code__r.Name,'All');
        queryloc.getFilesRelatedToProductionOrder(order2.Name,10,2000,'Name','DESC',FileList[0].File_Category_code__r.Name,'All');
        queryloc.getFilesRelatedToProductionOrder(order2.Name,10,2000,'Status','DESC',FileList[0].File_Category_code__r.Name,'All');
        queryloc.getFilesRelatedToProductionOrder(order2.Name,10,2000,'Operator','DESC',FileList[0].File_Category_code__r.Name,'All');
        
       queryloc.getFilesRelatedToProductionOrder(order2.Name,10,2000,'Status','ASC');
         queryloc.getFilesRelatedToProductionOrder(order2.Name,10,2000,'Operator','ASC');
         queryloc.getFilesRelatedToProductionOrder(order2.Name,10,2000,'Name','ASC');
        queryloc.getFilesRelatedToProductionOrder(order2.Name,10,2000,'Status','DESC');
         queryloc.getFilesRelatedToProductionOrder(order2.Name,10,2000,'Operator','DESC');
         queryloc.getFilesRelatedToProductionOrder(order2.Name,10,2000,'Name','DESC');

          queryloc.getFilesRelatedToProductionOrderCount(order2.Name,FileList[0].File_Category_code__r.Name,'All');        

        queryloc.getFilesCategoryCount(order2.Name);
        queryloc.getProdOrderDetails(order2.Name);
        queryloc.getFilesRelatedToProductionOrder(order2.Name,10,2000,'Name',FileList[0].File_Category_code__r.Name);
        queryloc.getFilesListRelatedToProductionOrder(order2.Name,FileList[0].File_Category_code__r.Name);
        queryloc.getFilesStatusList(fileList1);
        queryloc.getFilesCategoryInfo(catIds);
        queryloc.getFilesRelatedToProductionOrder(order2.Name,FileList[0].File_Category_code__r.Name,'All');
        queryloc.getFilesRecordsInfo(fileList);
        queryloc.getFilesRecords(Ids);
        
        Test.stopTest();

   }
}