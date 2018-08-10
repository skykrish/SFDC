/**********************************************************************************
*   Class               :       Test_EPMS_NewFileCopyDetails                      *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_NewFileCopyDetails            *
**********************************************************************************/

@isTest
private class Test_EPMS_NewFileCopyDetails {
    
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
        
        
        Member__c memberQC =new Member__c();
        memberQC.Name='testQC';     
        memberQC.Location_id__c=location.id;
        memberQC.First_Name__c='testFirstQC';
        memberQC.Last_Name__c='testlastQC';
        memberQC.Email__c='testFirsttestlastQC@gmail.com';
        memberQC.Country__c='India';
        memberQC.Designation__c='Quality Control';
        memberQC.Status__c='Active';
        //memberQC.User_id__c =userQC.id;
        insert memberQC; 
        
        
        Member__c memberTL =new Member__c();
        memberTL.Name='testTL';     
        memberTL.Location_id__c=location.id;
        memberTL.First_Name__c='testFirstTL';
        memberTL.Last_Name__c='testlastTL';
        memberTL.Email__c='testFirsttestlastTL@gmail.com';
        memberTL.Country__c='India';
        // memberTL.User_id__c =userTL.id;
        memberTL.Designation__c='Team Leader';
        memberTL.Status__c='Active';
        insert memberTL; 
        
        
        Member__c member =new Member__c();
        member.Name='test';     
        member.Location_id__c=location.id;
        member.First_Name__c='testFirst';
        member.Last_Name__c='testlast';
        member.Email__c='testFirsttestlast@gmail.com';
        member.Country__c='India';
        member.Designation__c='Photo Artists';
        // member.User_id__c =userPA.id;
        member.Status__c='Active';
        insert member;          
        System.debug('--After member creation---');
        
        System.debug('--Before PO insert--');
        Production_Order__c prodOrder = new Production_Order__c();
        prodOrder.Name = 'TestPO';
        ProdOrder.Mbo_Location__c=location.id;
        ProdOrder.FTP_Download_Status__c=true;
        ProdOrder.Production_Order_Status__c = 'New';
        insert prodOrder;
        
        System.debug('--Before FC insert--');
        File_Categories__c fileCategory = new File_Categories__c();
        fileCategory.Name = 'Test';
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
        parentfile.Member__c=member.Id;
        parentfile.QCIncharge__c ='a0w5F00000C9DVX';
        parentfile.File_Type__c = 'Directory';
        parentfile.Current_Extension__c='.jpg';
        insert parentfile;
        
        Files__c file = new Files__c();
        file.Production_Order__c=prodOrder.id;
        file.Name='TestFA';
        file.File_Category_Code__c=fileCategory.id;
        file.Status__c='TBI';
        file.Member__c=member.Id;            
        file.Current_Extension__c='.jpg';
        file.QCIncharge__c ='a0w5F00000C9DVX';
        file.Parent_Id__c=parentfile.id;
        file.File_Type__c = 'Image';
        file.Original_File_Id__c=parentfile.id;  
        file.File_Job_Titles__c='Alpha,Cripping';           
        
        insert file;
    }
    
    static testMethod void testDoPostPostive() {
        
        
        /*  UserEmail__c emailuser= UserEmail__c.getInstance('New User Email');
String userEmail= emailuser.Email__c;  */
        
        Profile profile = [select id from Profile where Name = 'System Administrator'];
        User user = new User();
        user.FirstName ='test';
        user.LastName ='data';
        user.Alias ='cust'; 
        user.Username ='testuserTEST@mboi.com';
        user.Email='test@gmail.com';
        user.ProfileId  = profile.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        insert user;
        
        
        String fileid  = null ;
        String parentId  = null ; 
        String NoOfFile= null ; 
        String locationName  = null ;       
        String fileCategoryCode  = null ; 
        String fileStatus  = null ; 
        String fileProcessingStatus  = null ; 
        String fileName  = null ; 
        String fileURL =null;
        String fileThumbURL  = null ; 
        String filePreviewURL  = null ; 
        String fileInstructions  = null ; 
        String fileHandOverInstructions  = null ; 
        String fileQCComments  = null ; 
        String fileCopyNumber  = null ; 
        String originalFile  = null ; 
        String fileType  = null ;
        String fileOldStatus  = null ;
        String currentextension  = null ; 
        String orderId  = null ; 
        String name  = null ; 
        String workStartTime  = null ;
        String workEndTime  = null ; 
        String totalWorktime  = null ; 
        String totalBreaktime  = null ; 
        string totalBreaks  = null ;
        string Filestoopen = null;
        string deliveryextension= null;
        String operatorid = null;
        string qcinchargeid= null;
        string tlinchargeid=null;
        string filejobtitle=null;       
        
        System.debug('--After PO insert--');
        Map<String, Object> params = new Map<String, Object>();
        Production_Order__c prodOrder = [SELECT Id, Name FROM Production_Order__c WHERE Name='TestPO'];
        params.put('prodOrderName',prodOrder.Name);
        Test.startTest();
        Flow.Interview.Production_Order_FTP_Dowload_Flow chatterFlow = new Flow.Interview.Production_Order_FTP_Dowload_Flow (params);
        
        try{
            chatterFlow.start();
            
        } catch (FlowException e){                   
            system.debug('System Throws Error -------------->' + e.getMessage());
        }
        Test.stopTest();
    }
    
    static testMethod void testDoPostPostive2() {
        
        Files__c fileObj1 = new Files__c();
        String fileid  = null ;
        Member__c memberQC = [SELECT Id, Name FROM Member__c WHERE Name='testQC'];  
        Member__c memberTL = [SELECT Id, Name FROM Member__c WHERE Name='testTL'];
        Member__c member = [SELECT Id, Name FROM Member__c WHERE Name='test'];
        System.debug('--Initialization starts---');
        Files__c file = [SELECT Id, Name, File_Job_Titles__c FROM Files__c WHERE Name = 'TestFA'];
        Production_Order__c prodOrder = [SELECT Id, Name FROM Production_Order__c WHERE Name='TestPO'];
        File_Categories__c fileCategory = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'Test'];
        
        fileObj1  =  [Select id, Parent_Id__c,No_of_the_file__c,File_Job_Titles__c,TLInCharge__c,File_Category_Code__c,Status__c,File_Proccessing_Status__c,
                      File_Thumbnail_URL__c,File_Preview_URL__c,Instruction__c,File_HandOver_Instructions__c,
                      QC_Comments__c,File_Copy_number__c,Original_File_Id__c ,File_Type__c,File_old_Status__c,Current_Extension__c, Production_Order__c,Name,File_Auto_Number__c,  Work_Start_Time__c,Work_End_Time__c,Total_Work_Time__c, Total_Break_Time__c, member__c, QCIncharge__c,Files_To_open__c
                      From Files__c where id =:file.id Limit 1];
        System.debug('--SA-File before Initialization details:'+fileObj1);
        Test.startTest();
        fileid= fileObj1.File_Auto_Number__c;
        String parentId=fileObj1.Parent_Id__c;
        String NoOfFile='45'; 
        String locationName='';           
        String fileCategoryCode=fileCategory.id; 
        String fileStatus='QC'; 
        String fileProcessingStatus='QC'; 
        String fileName='test_wings.jpg'; 
        String fileURL ='20151124/O000039/JAPAN/20151030/subFolder/heart_wings_t.jpg';
        String fileThumbURL='/share/JavaDev/Input/20151124/O000039/JAPAN/20151030/subFolder/heart_wings_t.jpg'; 
        String filePreviewURL='cifs://121.240.144.237/share/JavaDev/Input/20151124/O000039/JAPAN/20151030/subFolder/heart_wings.eps'; 
        String fileInstructions='ther'; 
        String fileHandOverInstructions='ttt'; 
        String fileQCComments='nothing'; 
        String fileCopyNumber='0'; 
        String originalFile=fileObj1.Original_File_Id__c;
        String fileType='Image';
        String fileOldStatus='';
        String currentextension='.jpg'; 
        String orderId=prodOrder.Name; 
        String name='test_wings.jpg'; 
        String workStartTime='2015-12-14 10:21:09Z'; 
        String workEndTime='2015-12-14 19:21:09Z'; 
        String totalWorktime='0'; 
        String totalBreaktime='0';         
        String totalBreaks='0';
        String Filestoopen='0';            
        String deliveryextension='';
        String operatorid = member.id;
        String qcinchargeid= 'a0w5F00000C9DVX';
        String tlinchargeid=memberTL.id;
        String filejobtitle=file.File_Job_Titles__c;
        
        System.debug('--webservice starts---');
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/NewFileCopyDetails';
        req.httpMethod = 'POST';
        
        RestContext.request = req;
        RestContext.response = res;
        
        
        EPMS_NewFileCopyDetails.doPost(fileid,parentId,NoOfFile,locationName,fileCategoryCode,fileStatus,fileProcessingStatus,fileName,fileURL,fileThumbURL,filePreviewURL,fileInstructions,fileHandOverInstructions,fileQCComments,fileCopyNumber,originalFile,fileType,fileOldStatus,currentextension,orderId,name,workStartTime,workEndTime,totalWorktime,totalBreaktime,totalBreaks,Filestoopen,deliveryextension,operatorid,qcinchargeid,tlinchargeid,filejobtitle);
        Test.stopTest();
    }
    
    
    static testMethod void testDoPostPostive3() {
        
        Files__c fileObj1 = new Files__c();
        String fileid  = null ;
        System.debug('--Initialization starts---');
        Member__c memberQC = [SELECT Id, Name FROM Member__c WHERE Name='testQC'];  
        Member__c memberTL = [SELECT Id, Name FROM Member__c WHERE Name='testTL'];
        Member__c member = [SELECT Id, Name FROM Member__c WHERE Name='test'];
        Production_Order__c prodOrder = [SELECT Id, Name FROM Production_Order__c WHERE Name='TestPO'];
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phase2'];
        Files__c file = [SELECT Id, Name, File_Job_Titles__c FROM Files__c WHERE Name = 'TestFA'];
        File_Categories__c fileCategory = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'Test'];
        
        fileObj1  =  [Select id, Parent_Id__c,No_of_the_file__c,File_Job_Titles__c,TLInCharge__c,File_Category_Code__c,Status__c,File_Proccessing_Status__c,
                      File_Thumbnail_URL__c,File_Preview_URL__c,Instruction__c,File_HandOver_Instructions__c,
                      QC_Comments__c,File_Copy_number__c,Original_File_Id__c ,File_Type__c,File_old_Status__c,Current_Extension__c, Production_Order__c,Name,File_Auto_Number__c,  Work_Start_Time__c,Work_End_Time__c,Total_Work_Time__c, Total_Break_Time__c, member__c, QCIncharge__c,Files_To_open__c
                      From Files__c where id =:file.id Limit 1];
        System.debug('--SA-File before Initialization details:'+fileObj1);
        Test.startTest();
        fileid=fileObj1.File_Auto_Number__c;
        String parentId=fileObj1.Parent_Id__c;
        String NoOfFile='45'; 
        String locationName=location.id;           
        String fileCategoryCode=fileCategory.id; 
        String fileStatus='QC'; 
        String fileProcessingStatus='QC'; 
        String fileName='test_wings.jpg'; 
        String fileURL ='20151124/O000039/JAPAN/20151030/subFolder/heart_wings_t.jpg';
        String fileThumbURL='/share/JavaDev/Input/20151124/O000039/JAPAN/20151030/subFolder/heart_wings_t.jpg'; 
        String filePreviewURL='cifs://121.240.144.237/share/JavaDev/Input/20151124/O000039/JAPAN/20151030/subFolder/heart_wings.eps'; 
        String fileInstructions='theway'; 
        String fileHandOverInstructions='theehtehteh'; 
        String fileQCComments=''; 
        String fileCopyNumber='0'; 
        String originalFile=fileObj1.Original_File_Id__c;
        String fileType='Image';
        String fileOldStatus='';
        String currentextension='.jpg'; 
        String orderId=prodOrder.Name; 
        String name='test_wings.jpg'; 
        String workStartTime='2015-12-14 10:21:09Z'; 
        String workEndTime='2015-12-14 19:21:09Z'; 
        String totalWorktime='0'; 
        String totalBreaktime='0';         
        String totalBreaks='0';
        String Filestoopen='0';            
        String deliveryextension='';
        String operatorid = member.id;
        String qcinchargeid= memberQC.id;
        String tlinchargeid=memberTL.id;
        String filejobtitle=file.File_Job_Titles__c;
        
        System.debug('--webservice starts---');
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
        req2.requestURI = '/services/apexrest/NewFileCopyDetails';
        req2.httpMethod = 'POST';
        
        RestContext.request = req2;
        RestContext.response = res2;
        
        EPMS_NewFileCopyDetails.doPost(fileid,parentId,NoOfFile,locationName,fileCategoryCode,fileStatus,fileProcessingStatus,fileName,fileURL,fileThumbURL,filePreviewURL,fileInstructions,fileHandOverInstructions,fileQCComments,fileCopyNumber,originalFile,fileType,fileOldStatus,currentextension,orderId,name,workStartTime,workEndTime,totalWorktime,totalBreaktime,totalBreaks,Filestoopen,deliveryextension,operatorid,qcinchargeid,tlinchargeid,filejobtitle);
        Test.stopTest();
        
    }  
    
    
    static testMethod void testDoPostPostive4() {
        
        Files__c parentfile = [SELECT Id, Name,File_Auto_Number__c FROM Files__c WHERE Name='parentFile'];
        Files__c file2 = [SELECT Id, Name,File_Auto_Number__c FROM Files__c WHERE Name='TestFA'];
        Files__c fileObj1 = new Files__c();
        Member__c memberQC = [SELECT Id, Name FROM Member__c WHERE Name='testQC'];  
        Member__c memberTL = [SELECT Id, Name FROM Member__c WHERE Name='testTL'];
        Member__c member = [SELECT Id, Name FROM Member__c WHERE Name='test'];
        Production_Order__c prodOrder = [SELECT Id, Name FROM Production_Order__c WHERE Name='TestPO'];
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phase2'];
        Files__c file = [SELECT Id, Name, File_Job_Titles__c FROM Files__c WHERE Name = 'TestFA'];
        File_Categories__c fileCategory = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'Test'];
        
        fileObj1  =  [Select id, Parent_Id__c,No_of_the_file__c,File_Job_Titles__c,TLInCharge__c,File_Category_Code__c,Status__c,File_Proccessing_Status__c,
                      File_Thumbnail_URL__c,File_Preview_URL__c,Instruction__c,File_HandOver_Instructions__c,
                      QC_Comments__c,File_Copy_number__c,Original_File_Id__c ,File_Type__c,File_old_Status__c,Current_Extension__c, Production_Order__c,Name,File_Auto_Number__c,  Work_Start_Time__c,Work_End_Time__c,Total_Work_Time__c, Total_Break_Time__c, member__c, QCIncharge__c,Files_To_open__c
                      From Files__c where id =:file.id Limit 1];
        System.debug('--SA-File before Initialization details:'+fileObj1);
        Test.startTest();
        
        String fileid = fileObj1.File_Auto_Number__c;
        String parentId = fileObj1.Parent_Id__c;
        String NoOfFile = '45'; 
        String locationName=location.id;           
        String fileCategoryCode=fileCategory.id; 
         
        String fileStatus='Handover'; 
        String fileProcessingStatus='Handover'; 
        String fileName='test_wings.jpg'; 
        String fileURL ='20151124/O000039/JAPAN/20151030/subFolder/heart_wings_t.jpg';
        String fileThumbURL='/share/JavaDev/Input/20151124/O000039/JAPAN/20151030/subFolder/heart_wings_t.jpg'; 
        String filePreviewURL='cifs://121.240.144.237/share/JavaDev/Input/20151124/O000039/JAPAN/20151030/subFolder/heart_wings.eps'; 
        String fileInstructions='way'; 
        String fileHandOverInstructions='please Handover'; 
        String fileQCComments='Hellom'; 
        String fileCopyNumber='0'; 
        String originalFile=fileObj1.Original_File_Id__c;
        String fileType='Image';
        String fileOldStatus='';
        String currentextension='.jpg'; 
        String orderId=prodOrder.Name; 
        String name='test_wings.jpg'; 
        String workStartTime='2015-12-14 10:21:09Z'; 
        String workEndTime='2015-12-14 19:21:09Z'; 
        String totalWorktime='0'; 
        String totalBreaktime='0';         
        String totalBreaks='0';
        String Filestoopen='0';            
        String deliveryextension='';
        String operatorid = member.id;
        String qcinchargeid= memberQC.id;
        String tlinchargeid=memberTL.id;
        String filejobtitle=file.File_Job_Titles__c;
        
        System.debug('--webservice starts---');
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();
        req1.requestURI = '/services/apexrest/NewFileCopyDetails';
        req1.httpMethod = 'POST';
        
        RestContext.request = req1;
        RestContext.response = res1;
        
        
        EPMS_NewFileCopyDetails.doPost(fileid,parentId,NoOfFile,locationName,fileCategoryCode,fileStatus,fileProcessingStatus,fileName,fileURL,fileThumbURL,filePreviewURL,fileInstructions,fileHandOverInstructions,fileQCComments,fileCopyNumber,originalFile,fileType,fileOldStatus,currentextension,orderId,name,workStartTime,workEndTime,totalWorktime,totalBreaktime,totalBreaks,Filestoopen,deliveryextension,operatorid,qcinchargeid,tlinchargeid,filejobtitle);
        
        Test.stopTest();
        
    }
    
    static testMethod void testDoPostPostive5() { 
        
        Files__c parentfile = [SELECT Id, Name,File_Auto_Number__c FROM Files__c WHERE Name='parentFile'];
        Files__c file2 = [SELECT Id, Name,File_Auto_Number__c FROM Files__c WHERE Name='TestFA'];
        Files__c fileObj1 = new Files__c();
        Member__c memberQC = [SELECT Id, Name FROM Member__c WHERE Name='testQC'];  
        Member__c memberTL = [SELECT Id, Name FROM Member__c WHERE Name='testTL'];
        Member__c member = [SELECT Id, Name FROM Member__c WHERE Name='test'];
        Production_Order__c prodOrder = [SELECT Id, Name FROM Production_Order__c WHERE Name='TestPO'];
        Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phase2'];
        Files__c file = [SELECT Id, Name, File_Job_Titles__c FROM Files__c WHERE Name = 'TestFA'];
        File_Categories__c fileCategory = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'Test'];
        
        fileObj1  =  [Select id, Parent_Id__c,No_of_the_file__c,File_Job_Titles__c,TLInCharge__c,File_Category_Code__c,Status__c,File_Proccessing_Status__c,
                      File_Thumbnail_URL__c,File_Preview_URL__c,Instruction__c,File_HandOver_Instructions__c,
                      QC_Comments__c,File_Copy_number__c,Original_File_Id__c ,File_Type__c,File_old_Status__c,Current_Extension__c, Production_Order__c,Name,File_Auto_Number__c,  Work_Start_Time__c,Work_End_Time__c,Total_Work_Time__c, Total_Break_Time__c, member__c, QCIncharge__c,Files_To_open__c
                      From Files__c where id =:file.id Limit 1];
        System.debug('--SA-File before Initialization details:'+fileObj1);
        Test.startTest();
        
        String fileid = null;
        String parentId = parentfile.File_Auto_Number__c;
        String NoOfFile = '45'; 
        String locationName=location.id;           
        String fileCategoryCode=fileCategory.id; 
         String fileStatus='Redo'; 
        String fileProcessingStatus='Handover'; 
        String fileName='test_wings.jpg'; 
        String fileURL ='20151124/O000039/JAPAN/20151030/subFolder/heart_wings_t.jpg';
        String fileThumbURL='/share/JavaDev/Input/20151124/O000039/JAPAN/20151030/subFolder/heart_wings_t.jpg'; 
        String filePreviewURL='cifs://121.240.144.237/share/JavaDev/Input/20151124/O000039/JAPAN/20151030/subFolder/heart_wings.eps'; 
        String fileInstructions='way'; 
        String fileHandOverInstructions='please Handover'; 
        
        String fileQCComments1 = 'COMMON MISTAKES|HOLES REMAINING|Test Comments';
        String fileQCComments2 = 'COMMON MISTAKES|HOLES REMAINING|';
        
        String fileCopyNumber='0'; 
        String originalFile=fileObj1.Original_File_Id__c;
        String fileType='Image';
        String fileOldStatus='';
        String currentextension='.jpg'; 
        String orderId=prodOrder.Name; 
        String name='test_wings.jpg'; 
        String workStartTime='2015-12-14 10:21:09Z'; 
        String workEndTime='2015-12-14 19:21:09Z'; 
        String totalWorktime='0'; 
        String totalBreaktime='0';         
        String totalBreaks='0';
        String Filestoopen='0';            
        String deliveryextension='';
        String operatorid = member.id;
        String qcinchargeid= 'a0w5F00000C9DVX';
        String tlinchargeid=memberTL.id;
        String filejobtitle=file.File_Job_Titles__c;
        
        System.debug('--webservice starts---');
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();
        req1.requestURI = '/services/apexrest/NewFileCopyDetails';
        req1.httpMethod = 'POST';
        
        RestContext.request = req1;
        RestContext.response = res1;
        
        EPMS_NewFileCopyDetails.doPost(fileid,parentId,NoOfFile,locationName,fileCategoryCode,fileStatus,fileProcessingStatus,fileName,fileURL,fileThumbURL,filePreviewURL,fileInstructions,fileHandOverInstructions,fileQCComments1,fileCopyNumber,originalFile,fileType,fileOldStatus,currentextension,orderId,name,workStartTime,workEndTime,totalWorktime,totalBreaktime,totalBreaks,Filestoopen,deliveryextension,operatorid,qcinchargeid,tlinchargeid,filejobtitle);
        EPMS_NewFileCopyDetails.doPost(fileid,parentId,NoOfFile,locationName,fileCategoryCode,fileStatus,fileProcessingStatus,fileName,fileURL,fileThumbURL,filePreviewURL,fileInstructions,fileHandOverInstructions,fileQCComments2,fileCopyNumber,originalFile,fileType,fileOldStatus,currentextension,orderId,name,workStartTime,workEndTime,totalWorktime,totalBreaktime,totalBreaks,Filestoopen,deliveryextension,operatorid,qcinchargeid,tlinchargeid,filejobtitle);
        
        Test.stopTest();
        
    }
    
}