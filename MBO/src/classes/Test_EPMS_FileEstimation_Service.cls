/**********************************************************************************
*   Class               :       Test_EPMS_FileEstimation_Service                   *
*   Created Date        :       11/01/2018                                           *
*   Description         :       Test Class for EPMS_FileEstimation_Service          *
**********************************************************************************/
@isTest
private class Test_EPMS_FileEstimation_Service {
    
    @testSetup static void setupTestData(){
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phase2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2';
        insert location;
        
        Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
        testRecord.Name='India';
        testRecord.Country_Initial_Letter__c='I';
        insert testRecord;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='New User Email';
        usermail.Email__c='testphotoartist1222222@mbo.in';
        insert usermail;
        
        Account acc=new Account(Name='TEST ACC');
        insert acc;
        
        Anken__c anken=new Anken__c(KokyakuName__c=acc.Id,Status__c='Open',Sagyoshiji_Renrakujiko__c='please refer PDF for instructions',
                                    Nouki_Date__c=System.Today());
        insert anken;
        
        System.debug('--Before PO insert--');
        Production_Order__c prodOrder = new Production_Order__c();
        prodOrder.Anken_Order__c = anken.id;
        prodOrder.Name = 'TestPO';
        ProdOrder.Mbo_Location__c=location.id;
        ProdOrder.FTP_Download_Status__c=true;
        ProdOrder.Production_Order_Status__c='Awaiting Approval';
        insert prodOrder;
        
        System.debug('--Before FC insert--');
        File_Categories__c fileCategory = new File_Categories__c();
        fileCategory.Name = 'Test123';
        fileCategory.Standard_Time_per_File_Min__c=11;
        fileCategory.Standard_Time_per_File_Max__c=20;
        fileCategory.Standard_Regular_Cost_per_File__c=3;
        fileCategory.Standard_OptionalCost_Per_file__c=1;
        insert fileCategory;
        
        Files__c parentfile = new Files__c();
        parentfile.Production_Order__c=prodOrder.id;
        parentfile.Name='parentFile';
        parentfile.File_Category_Code__c=fileCategory.id;
        parentfile.Status__c='TBI';
        parentfile.File_Type__c = 'Directory';
        parentfile.Current_Extension__c='.jpg';
        insert parentfile;
        
        Files__c file = new Files__c();
        file.Production_Order__c=prodOrder.id;
        file.Name='TestFA';
        file.File_Category_Code__c=fileCategory.id;
        file.Status__c='TBI';          
        file.Current_Extension__c='.jpg';
        file.Parent_Id__c=parentfile.id;
        file.File_Type__c = 'Image';
        file.Original_File_Id__c=parentfile.id;  
        file.File_Job_Titles__c='Alpha,Cripping';           
        
        insert file;
    }
    static testMethod void testDoPost1() {
        
        Files__c fileObj1 = new Files__c();
        String fileid  = null ;        
        System.debug('--Initialization starts---');
        
        Production_Order__c prodOrder = [SELECT Id, Name FROM Production_Order__c WHERE Name='TestPO'];
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phase2'];
        Files__c file = [SELECT Id, Name, File_Job_Titles__c FROM Files__c WHERE Name = 'TestFA'];
        File_Categories__c fileCategory = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'Test123'];
        fileObj1  =  [Select id, Parent_Id__c,No_of_the_file__c,File_Job_Titles__c,TLInCharge__c,File_Category_Code__c,Status__c,File_Proccessing_Status__c,
                      File_Thumbnail_URL__c,File_Preview_URL__c,Instruction__c,File_HandOver_Instructions__c,
                      QC_Comments__c,File_Copy_number__c,Original_File_Id__c ,Order_Instructions__c,Image_Definition__c,File_Type__c,File_old_Status__c,Current_Extension__c, Production_Order__c,Name,File_Auto_Number__c,  Work_Start_Time__c,Work_End_Time__c,Total_Work_Time__c, Total_Break_Time__c, member__c, QCIncharge__c,Files_To_open__c
                      From Files__c where id =:file.id Limit 1];
        System.debug('--SA-File before Initialization details:'+fileObj1);
        Test.startTest();
        
        fileid=fileObj1.File_Auto_Number__c;
        String fileStatus='Estimated'; 
        String orderInstructions= fileObj1.Order_Instructions__c;
        String fileInstructions='theway';
        String filejobtitle=fileObj1.File_Job_Titles__c;
        String fileURL ='20151124/O000039/JAPAN/20151030/subFolder/heart_wings_t.jpg';
        String imageDefinition = fileObj1.Image_Definition__c;
        String fileCategoryCode = fileCategory.name;
            
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
        req2.requestURI = '/services/apexrest/FileEstimation_Service';
        req2.httpMethod = 'POST';
        
        RestContext.request = req2;
        RestContext.response = res2;
        
        EPMS_FileEstimation_Service.doPost(fileid,fileStatus,orderInstructions,fileInstructions,filejobtitle,fileURL,imageDefinition,fileCategoryCode);
        Test.stopTest(); 
    }
}