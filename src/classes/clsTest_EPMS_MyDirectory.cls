/**********************************************************************************
*   Class               :       clsTest_EPMS_MyDirectory                          *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_MyDirectory                   *
**********************************************************************************/
@isTest
    public class clsTest_EPMS_MyDirectory {
        
        @testSetup static void setupTestData(){
            
            //Location__c newLocation = [SELECT Id, Name FROM Location__c WHERE Name ='MEDIA BACKOFFICE INDIA PRIVATE LIMITED - Phase1'];
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIA PVT LTD -Phase2x2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='I';
            insert testRecord;
            
            Profile profile = [SELECT Id FROM Profile WHERE Name = 'Quality Control'];

            User user = new User();
            user.FirstName ='Peter';
            user.LastName ='James';
            user.Alias ='Jammy'; 
            user.Username ='testuser3@mbo.com';
            user.Email='test3@gmail.com';
            user.ProfileId  = profile.id;
            user.TimeZoneSidKey='America/Los_Angeles';
            user.LocaleSidKey='en_US';
            user.EmailEncodingKey='UTF-8';
            user.LanguageLocaleKey='en_US';
            insert user;
              
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testmbotestt@mbo.in';
            insert usermail;
            
            Team__c team3 = new Team__c();
            team3.Name='Team C';
            team3.Location__c=location.id;             
            insert team3;
            
            List<Member__c> memberList= new List<Member__c>();
            
            Member__c tlMemberTest =new Member__c();
            tlMemberTest.Name='Alexandar';     
            tlMemberTest.Location_id__c=location.id;
            tlMemberTest.Last_Name__c='Fleming';
            tlMemberTest.Email__c='alexfleming@gmail.com';
            tlMemberTest.Country__c='India';
            tlMemberTest.Designation__c='Team Leader';
            tlMemberTest.Status__c='Active';
            memberList.add(tlMemberTest);
            
            Member__c qcMemberTest =new Member__c();
            qcMemberTest.Name='Ramkumar S';     
            qcMemberTest.Location_id__c=location.id;
            qcMemberTest.Last_Name__c='Sundaresan';
            qcMemberTest.Email__c='ramkumars@gmail.com';
            qcMemberTest.Country__c='India';
            qcMemberTest.Designation__c='Quality Control';
            qcMemberTest.Status__c='Active';
            memberList.add(qcMemberTest);
            
            Member__c member =new Member__c();
            member.Name='Dhayanchand S';     
            member.Location_id__c=location.id;
            member.Last_Name__c='testlastQC3';
            member.Email__c='dhayanchand3@gmail.com';
            member.Country__c='India';
            member.Designation__c='Quality Control';
            member.Status__c='Active';
            memberList.add(member);
            
            Member__c member2 =new Member__c();
            member2.Name='Premchand S';     
            member2.Location_id__c=location.id;
            member2.Last_Name__c='testlastQCS';
            member2.Email__c='premchand5@gmail.com';
            member2.Country__c='India';
            member2.Designation__c='Quality Control';
            member2.Status__c='Active';
            memberList.add(member2);
            
            Member__c member3 =new Member__c();
            member3.Name='KapilDev3';     
            member3.Location_id__c=location.id;
            member3.Last_Name__c='Singh5';
            member3.Email__c='kapildev4@gmail.com';
            member3.Country__c='India';
            member3.Designation__c='Team Leader';
            member3.Status__c='Active';
            memberList.add(member3);
            
            Member__c member4 =new Member__c();
            member4.Name='Gavaskar';     
            member4.Location_id__c=location.id;
            member4.Last_Name__c='Sunil';
            member4.Email__c='gavaskar@gmail.com';
            member4.Country__c='India';
            member4.Designation__c='Team Leader';
            member4.Status__c='Active';
            memberList.add(member4);
            
            if(memberList.size() > 0){
                //insert memberList;
            }
            
            Production_Order__c productionTest = new Production_Order__c();
            productionTest.Name ='OrderProduction_1';
            productionTest.Production_Order_Status__c ='New';
            productionTest.MBO_Location__c= location.Id;
            productionTest.TL_Incharge__c = tlMemberTest.Id;
            productionTest.QC_Incharge__c = qcMemberTest.Id;
            insert productionTest;
            
            File_Categories__c fcTest= new File_Categories__c();
            fcTest.Name ='testEB';
            fcTest.Standard_Time_per_File_Min__c =11;
            fcTest.Standard_Time_per_File_Max__c =20;
            fcTest.Standard_Regular_Cost_per_File__c =1000;
            fcTest.Standard_OptionalCost_Per_file__c =6;
            insert fcTest;
            
            // Files for Order_1
            Files__c parentfileTest= new Files__c();
            parentfileTest.Name ='Order_1_File_Directory';
            parentfileTest.Production_Order__c =productionTest.id;
            parentfileTest.File_Category_Code__c =fcTest.id;
            parentfileTest.Status__c ='QCIP';
            parentfileTest.File_Location__c=location.id;
            parentfileTest.Current_Extension__c ='.jpg';
            parentfileTest.File_Type__c = 'Directory';
            //parentfileTest.TLInCharge__c = tlMemberTest.Id;
            //parentfileTest.QCIncharge__c = qcMemberTest.Id;
            insert parentfileTest;
            
            
            
            List<Files__c> fileListTest = new List<Files__c>();
            for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='OrderTest_File_'+i;
                file.Production_Order__c =productionTest.id;
                file.File_Category_Code__c =fcTest.id;
                if(i==1){
                    file.Name ='Test.db';
                    file.Status__c ='QCIP';
                    //file.TLInCharge__c = tlMemberTest.Id;
                    //file.QCIncharge__c = qcMemberTest.Id;
                } else if(i==2){
                    file.Status__c ='QC';
                    //file.TLInCharge__c = tlMemberTest.Id;
                    //file.QCIncharge__c = qcMemberTest.Id;
                } else if(i==3){
                    file.Status__c ='WIP';
                    //file.TLInCharge__c = tlMemberTest.Id;
                    //file.QCIncharge__c = qcMemberTest.Id;
                } else {
                    file.Status__c ='New';
                    //file.TLInCharge__c = tlMemberTest.Id;
                    //file.QCIncharge__c = qcMemberTest.Id;
                }
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
               
                file.instruction__c = 'Test File Instructions ::';
                file.parent_Id__c = parentfileTest.Id;
                fileListTest.add(file);
            }
            insert fileListTest; 
            
            List<Production_Order__c> orderList = new List<Production_Order__c>();
            Production_Order__c po=new Production_Order__c();
            po.Name ='Order_1';
            po.Production_Order_Status__c ='New';
            po.MBO_Location__c=location.Id;
            //po.TL_Incharge__c = member3.Id;
            //po.QC_Incharge__c = member2.Id;
            orderList.add(po);
            
            Production_Order__c po2=new Production_Order__c();
            po2.Name ='Order_2';
            po2.Production_Order_Status__c ='New';
            po2.MBO_Location__c=location.Id;
            //po2.TL_Incharge__c = member3.Id;
            //po2.QC_Incharge__c = member2.Id;
            orderList.add(po2);
            
        
            
            Production_Order__c po3=new Production_Order__c();
            po3.Name ='Order_3';
            po3.Production_Order_Status__c ='New';
            po3.MBO_Location__c=location.Id;
            //po3.TL_Incharge__c = member4.Id;
            //po3.QC_Incharge__c = member.Id;
            orderList.add(po3);
            
            Production_Order__c po4=new Production_Order__c();
            po4.Name ='Order_4';
            po4.Production_Order_Status__c ='New';
            po4.MBO_Location__c=location.Id;
            //po4.TL_Incharge__c = member4.Id;
            //po4.QC_Incharge__c = member.Id;
            orderList.add(po4);
                
                
            if(orderList.size() > 0){
                insert orderList;
            }    
            
            List<Files__c> fileList = new List<Files__c>();
            
            File_Categories__c fc1= new File_Categories__c();
            fc1.Name ='testB';
            fc1.Standard_Time_per_File_Min__c =11;
            fc1.Standard_Time_per_File_Max__c =20;
            fc1.Standard_Regular_Cost_per_File__c =1000;
            fc1.Standard_OptionalCost_Per_file__c =6;
            
            insert fc1;
            // Files for Order_1
            Files__c parentfile= new Files__c();
            parentfile.Name ='Order_1_File_Directory';
            parentfile.Production_Order__c =po.id;
            parentfile.File_Category_Code__c =fc1.id;
            parentfile.Status__c ='QCIP';
            parentfile.File_Location__c=location.id;
            parentfile.Current_Extension__c ='.jpg';
            parentfile.File_Type__c = 'Directory';
            //parentfile.TLInCharge__c = member3.Id;
            //parentfile.QCIncharge__c = member2.Id;
            insert parentfile;
            
            for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='Order_1_File_'+i;
                file.Production_Order__c =po.id;
                file.File_Category_Code__c =fc1.id;
                if(i==1){
                    file.Status__c ='QCIP';
                } else if(i==2){
                    file.Status__c ='QC';
                } else if(i==3){
                    file.Status__c ='WIP';
                } else {
                    file.Status__c ='New';
                }
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
                //file.TLInCharge__c = member3.Id;
                //file.QCIncharge__c = member2.Id;
                file.instruction__c = 'Test File Instructions ::';
                file.parent_Id__c = parentfile.Id;
                fileList.add(file);
            }
            insert fileList; 
            
            List<Files__c> fileList2 = new List<Files__c>();
            
            // Files for Order_2
            for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='Order_2_File_'+i;
                file.Production_Order__c =po2.id;
                file.File_Category_Code__c =fc1.id;
                if(i==1){
                    file.Status__c ='QCIP';
                } else if(i==2){
                    file.Status__c ='QC';
                } else if(i==3){
                    file.Status__c ='WIP';
                } else {
                    file.Status__c ='New';
                }
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
                //file.TLInCharge__c = qcMemberTest.Id;
                //file.QCIncharge__c = qcMemberTest.Id;
                fileList2.add(file);
            }
            
            insert fileList2; 
            
            List<Files__c> fileList3 = new List<Files__c>();
            
            // Files for Order_3
            for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='Order_3_File_'+i;
                file.Production_Order__c =po2.id;
                file.File_Category_Code__c =fc1.id;
                if(i==1){
                    file.Status__c ='QCIP';
                } else if(i==2){
                    file.Status__c ='QC';
                } else if(i==3){
                    file.Status__c ='WIP';
                } else {
                    file.Status__c ='New';
                }
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
                if(i > 3){
                    //file.TLInCharge__c = member3.Id;
                    //file.QCIncharge__c = member2.Id;
                } else {
                    //file.TLInCharge__c = member4.Id;
                    //file.QCIncharge__c = member.Id;
                }    
                fileList3.add(file);
            }
            
            insert fileList3; 
            
            List<Files__c> fileList4 = new List<Files__c>();
            
            // Files for Order_4
            for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='Order_4_File_'+i;
                file.Production_Order__c =po2.id;
                file.File_Category_Code__c =fc1.id;
                if(i==1){
                    file.Status__c ='QCIP';
                } else if(i==2){
                    file.Status__c ='QC';
                } else if(i==3){
                    file.Status__c ='WIP';
                } else {
                    file.Status__c ='New';
                }
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
                //file.TLInCharge__c = member4.Id;
                //file.QCIncharge__c = member.Id;
                fileList4.add(file);
            }
            
            insert fileList4; 
            
            
        }
        
        static testMethod void test_MyDirectory_Class() {
            
            PageReference pageRef = Page.EPMS_MyDirectory;
            
            Production_Order__c order1 = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'Order_1'];
              
    
            string basepath='Order';
            string type = 'assign';
            Test.setCurrentPage(pageRef);
            
            pageRef.getParameters().put('id',order1.Id);
            Test.StartTest();     
            EPMS_MyDirectory myDirectoryObj = new EPMS_MyDirectory();
            myDirectoryObj.getproductionOrderDetails();
            myDirectoryObj.getAllDetails();
            myDirectoryObj.parentChildNodes();
           
            Test.StopTest();
        }
        
        static testMethod void test_MyDirectory_Class_case_1() {
            
            PageReference pageRef = Page.EPMS_MyDirectory;
            
            Production_Order__c order1 = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'Order_1'];
        
            
            // Change the Extension Check
           
            EPMS_MyDirectory myDirectoryObj1 = new EPMS_MyDirectory();
            List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order1.id];
            Files__c parentfile = [SELECT Id, Name FROM Files__c WHERE Name ='Order_1_File_Directory' AND Production_Order__c =: order1.id];
            Test.setCurrentPage(pageRef);
            Test.StartTest();
            String fileIds = '';
            for(Files__c newFile : fileList){
                if(fileIds == ''){
                    fileIds = newFile.Id; 
                } else {
                    fileIds += ',' + newFile.Id;
                }
            }
            
            pageRef.getParameters().put('fileExt',fileIds);
            myDirectoryObj1.parentChildNodesNew();
            myDirectoryObj1.getAllFileExtension();
            myDirectoryObj1.changeExtention();
            myDirectoryObj1.extentionTxt = 'psd';
            
            myDirectoryObj1.saveChangeExtention();
            
            // Change the folder instruction 
            
            pageRef.getParameters().put('openInstrFiles',parentfile.Id);
            myDirectoryObj1.showVDFolPopup();
            myDirectoryObj1.VDFolInstrucEntered = 'Immediate Priority - Do it soon';
            myDirectoryObj1.redirectVDFolPopup();
            myDirectoryObj1.cancelVDFolPop();
            myDirectoryObj1.getAssignedFileListWithoutProductionOrders();                      
            Test.StopTest();
        }   
            
        
        static testMethod void test_MyDirectory_Class_case_2() {
        
            PageReference pageRef = Page.EPMS_MyDirectory;
            Production_Order__c order1 = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'Order_1'];
            List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: order1.id];
            Files__c parentfile = [SELECT Id, Name FROM Files__c WHERE Name ='Order_1_File_Directory' AND Production_Order__c =: order1.id];
            Test.setCurrentPage(pageRef);
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
            pageRef.getParameters().put('openFiles',fileIds);
            EPMS_MyDirectory myDirectoryObj2 = new EPMS_MyDirectory();
            myDirectoryObj2.openDirectory();
            myDirectoryObj2.orderID = order1.Id;
            myDirectoryObj2.parentChildNodesNew();
            myDirectoryObj2.getAllDetailsNew();
            myDirectoryObj2.getDisablePreviousNew();
            myDirectoryObj2.getDisableNextNew();
            myDirectoryObj2.NextNew();
            myDirectoryObj2.PreviousNew();
            myDirectoryObj2.getDisablePrevious();
            myDirectoryObj2.getDisableNext();
            myDirectoryObj2.Next();
            myDirectoryObj2.Previous();
            myDirectoryObj2.closeChangeTLPopup();
            myDirectoryObj2.closeChangeQCPopup();
            myDirectoryObj2.cancel();
            myDirectoryObj2.closeJobTitlePopup();
            myDirectoryObj2.closePopup();
            myDirectoryObj2.ExportToExcel();           
            Test.StopTest();
            
        }   
            
            
        
        static testMethod void test_MyDirectory_Class_case_3() {
            
            PageReference pageRef = Page.EPMS_MyDirectory;
            
            
            Test.setCurrentPage(pageRef);

            Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'Order_2'];
            Test.StartTest();
            pageRef.getParameters().put('id',order2.Id);
            
            EPMS_MyDirectory myDirectoryObj3 = new EPMS_MyDirectory();
            myDirectoryObj3.orderID = order2.Name;
            myDirectoryObj3.getproductionOrderDetails();
            myDirectoryObj3.getAssignedFileListWithoutProductionOrders();
            myDirectoryObj3.parentChildNodesNew();
            myDirectoryObj3.getAllDetailsNew();
            
            Test.StopTest();
            
        }   
        
        static testMethod void test_MyDirectory_Class_case_4() {
            
            PageReference pageRef = Page.EPMS_MyDirectory;
            
            Production_Order__c order1 = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'Order_1'];
            
            Files__c parentfile = [SELECT Id, Name FROM Files__c WHERE Name ='Order_1_File_Directory' AND Production_Order__c =: order1.id];
            
            
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',order1.Id);
            
            
            pageRef.getParameters().put('openInstrFiles',parentfile.Id);
            Test.StartTest();
            EPMS_MyDirectory myDirectoryObj4 = new EPMS_MyDirectory();            
            myDirectoryObj4.showVDFolPopup();
            myDirectoryObj4.VDFolInstrucEntered = 'Not an Immediate Priority - Do it Later';
            myDirectoryObj4.redirectVDFolPopup();
            myDirectoryObj4.cancelVDFolPop();
            myDirectoryObj4.setFileListInsruction('Test String');
            myDirectoryObj4.getAssignedFileListWithoutProductionOrders();
            
            
            Test.StopTest();
        }
        
        static testMethod void test_MyDirectory_Class_case_5() {
            
            PageReference pageRef = Page.EPMS_MyDirectory;
            Production_Order__c productionTest = [SELECT Id, Name FROM Production_Order__c WHERE Name ='OrderProduction_1'];
            
            Test.setCurrentPage(pageRef);
            Test.StartTest();
            EPMS_MyDirectory myDirectoryObj5 = new EPMS_MyDirectory();
            //Member__c qcMemberTest = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Email__c='ramkumars@gmail.com' AND Last_Name__c='Sundaresan'];
           
            pageRef.getParameters().put('id',productionTest.Id);
           
            myDirectoryObj5.orderID = productionTest.Id;
            myDirectoryObj5.proflieName = 'Quality Control';
            myDirectoryObj5.getproductionOrderDetails();
            myDirectoryObj5.getAllDetailsNew();
            myDirectoryObj5.getAssignedFileListWithoutProductionOrders();
            myDirectoryObj5.parentChildNodesNew();

            Test.StopTest();
            
        }   
        
        
        static testMethod void test_MyDirectory_Class_case_6() {
            
            PageReference pageRef = Page.EPMS_MyDirectory;
            Production_Order__c productionTest = [SELECT Id, Name FROM Production_Order__c WHERE Name ='OrderProduction_1'];
            
            
            
            Test.setCurrentPage(pageRef);
            Test.StartTest();
            productionTest.FTP_Download_Status__c = true;
            update productionTest;
            //Member__c qcMemberTest = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Name = 'Ramkumar S'];
            User qcMemberUserTest = [SELECT Id, Name FROM User WHERE FirstName = 'Peter'];
            System.runAs(qcMemberUserTest){
                EPMS_MyDirectory myDirectoryObj5 = new EPMS_MyDirectory();
                myDirectoryObj5.orderID = productionTest.Name;
            }
            
            Test.StopTest();
        
        }
        
        static testMethod void test_MyDirectory_Class_case_7() {
            PageReference pageRef = Page.EPMS_MyDirectory;
            Production_Order__c productionTest = [SELECT Id, Name FROM Production_Order__c WHERE Name ='OrderProduction_1'];
            List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: productionTest.id];
            List<Id> newFileIdsList = new List<Id>();
            Set<Id> newFileIdsset = new Set<Id>();
            String fileIds = '';
            for(Files__c newFile : fileList){
                if(fileIds == ''){
                    fileIds = newFile.Id; 
                } else {
                    fileIds += ',' + newFile.Id;
                }
                newFileIdsList.add(newFile.Id);
                newFileIdsset.add(newFile.Id);
            }

            EPMS_MyDirectory_Service myservice = new EPMS_MyDirectory_Service();
            //Member__c qcMemberTest = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Name = 'Ramkumar S'];
            User qcMemberUserTest = [SELECT Id, Name FROM User WHERE FirstName = 'Peter'];
            
            Test.setCurrentPage(pageRef);
            Test.StartTest();
            myservice.getAssignedFileListWithoutProductionOrders(0,10);
            myservice.getQCFilesRelatedToProductionOrder(productionTest.Id);
            myservice.getMemberDesignation(qcMemberUserTest.Id);
            //myservice.getActiveMemberInfo(qcMemberUserTest.Id);
            myservice.getProductionOrderForSaleRegion(qcMemberUserTest.Id, 0,10);
            myservice.getProductionOrderCountByQC_Or_TL(null);
            myservice.getFileDetailInformation(newFileIdsList);
            myservice.getQCChildFileDetailsForUpdate(newFileIdsset);
            myservice.getOrderCountFromFilesList(null);
            Test.StopTest();
        }
        
        static testMethod void test_MyDirectory_Class_case_8() {
            PageReference pageRef = Page.EPMS_MyDirectory;
            Production_Order__c productionTest = [SELECT Id, Name FROM Production_Order__c WHERE Name ='OrderProduction_1'];
            Team__c team = [SELECT Id, Name FROM Team__c WHERE Name='Team C'];
            List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Production_Order__c =: productionTest.id];
            List<Id> newFileIdsList = new List<Id>();
            Set<Id> newFileIdsset = new Set<Id>();
            String fileIds = '';
            for(Files__c newFile : fileList){
                if(fileIds == ''){
                    fileIds = newFile.Id; 
                } else {
                    fileIds += ',' + newFile.Id;
                }
                newFileIdsList.add(newFile.Id);
                newFileIdsset.add(newFile.Id);
            }

            EPMS_MyDirectory_Service myservice1 = new EPMS_MyDirectory_Service();
            //Member__c qcMemberTest = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Name = 'Ramkumar S'];
            User qcMemberUserTest = [SELECT Id, Name FROM User WHERE FirstName = 'Peter'];
            Set<Id> teamIds = new Set<Id>();
            if(team !=null){
                teamIds.add(team.Id);
            }
            Test.setCurrentPage(pageRef);
            Test.StartTest();
            String sortChoice = 'Status';
            String sortType = 'ASC';
            boolean isExcludeOnHoldFiles = true;
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            myservice1.getQCFilesCountRelatedToProductionOrder(productionTest.Id);
            myservice1.getProductionOrderAssigedTO_QC_OR_TL(qcMemberUserTest.Id,0,10);
            myservice1.getFileCategoryList();
            myservice1.getFileInstructionDetails(newFileIdsset);
            myservice1.getQCFileDetailsForUpdate(newFileIdsset);
            sortChoice = 'Name';
            sortType = 'ASC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Category';
            sortType = 'ASC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Operator';
            sortType = 'ASC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Name';
            sortType = 'DESC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Name';
            sortType = 'ASC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Category';
            sortType = 'DESC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Category';
            sortType = 'ASC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Operator';
            sortType = 'DESC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Status';
            sortType = 'DESC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Status';
            sortType = 'ASC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Extension';
            sortType = 'ASC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Extension';
            sortType = 'DESC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            isExcludeOnHoldFiles = false;
            sortChoice = 'Name';
            sortType = 'ASC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Category';
            sortType = 'ASC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Operator';
            sortType = 'ASC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Name';
            sortType = 'DESC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Category';
            sortType = 'DESC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Operator';
            sortType = 'DESC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Status';
            sortType = 'DESC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Status';
            sortType = 'ASC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Extension';
            sortType = 'DESC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            sortChoice = 'Extension';
            sortType = 'ASC';
            myservice1.getQCFilesRelatedToProductionOrder(productionTest.Id,0,10,sortChoice,sortType,isExcludeOnHoldFiles);
            myservice1.getMemberTeamInformation(teamIds);
            myservice1.getActiveMemberInfo(null);

                       
            Test.StopTest();
        }
        
    }