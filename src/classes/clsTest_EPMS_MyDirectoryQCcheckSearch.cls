/**********************************************************************************
*   Class               :       clsTest_EPMS_MyDirectoryQCcheckSearch             *
*   Created Date        :       04/04/2016                                        *
*   Description         :       Test Class for EPMS_MyDirectoryQCcheckSearch      *
**********************************************************************************/
@isTest
    public class clsTest_EPMS_MyDirectoryQCcheckSearch{
    
        @testSetup static void setupTestData(){
        
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
            location.Location_Country__c='India';
            location.Location_Status__c ='active';
            location.Group_Name__c='INDIA PVT LTD -Phase2x2';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='M';
            insert testRecord;
            
              
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='testsubra@mbo.in';
            insert usermail;
            
            Mistakes__c mistake = new Mistakes__c();
            mistake.Penalty_for_Artist__c = 50;
            mistake.Penalty_for_QC__c = 25;
            mistake.Mistake_Description__c = 'Test Creation of mistake :::';
            mistake.MIstake_Category__c = 'COMMON MISTAKES';
            mistake.Mistake__c = 'HOLES REMAINING';
            mistake.Location__c = location.Id;
            insert mistake; 
            
            Production_Order__c po=new Production_Order__c();
            po.Name ='testPO_22';
            po.Production_Order_Status__c ='QCIP';
            po.MBO_Location__c=location.Id;
            insert po;
            
            Production_Order__c po6=new Production_Order__c();
            po6.Name ='testPO_2252';
            po6.Production_Order_Status__c ='New';
            po6.MBO_Location__c=location.Id;
            insert po6;
            
            Production_Order__c po7=new Production_Order__c();
            po7.Name ='testPO_2289';
            po7.Production_Order_Status__c ='New';
            po7.MBO_Location__c=location.Id;
            insert po7;
            
            Production_Order__c po8 = new Production_Order__c();
            po8.Name ='MD-0091201';
            po8.Production_Order_Status__c ='New';
            po8.MBO_Location__c=location.Id;
            insert po8;
            
            List<Files__c> fileList = new List<Files__c>();

            File_Categories__c fc= new File_Categories__c();
            fc.Name ='testFC';
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
            
            Member__c member =new Member__c();
            member.Name='testQCMember';     
            member.Location_id__c=location.id;
            member.Last_Name__c='testlastQC';
            member.Email__c='testFirsttestlastQC@gmail.com';
            member.Country__c='India';
            member.Designation__c='Quality Control';
            member.Status__c='Active';
            member.Performance_Rating__c = newPerGroup.Id;
            insert member;
            
            Member__c member1 =new Member__c();
            member1.Name='testTLMember';     
            member1.Location_id__c=location.id;
            member1.Last_Name__c='testlastTL';
            member1.Email__c='testFirsttestlastTL@gmail.com';
            member1.Country__c='India';
            member1.Designation__c='Team Leader';
            member1.Status__c='Active';
            member1.Performance_Rating__c = newPerGroup.Id;
            insert member1;
            
            File_Categories__c fc1= new File_Categories__c();
            fc1.Name ='testB';
            fc1.Standard_Time_per_File_Min__c =11;
            fc1.Standard_Time_per_File_Max__c =20;
            fc1.Standard_Regular_Cost_per_File__c =1000;
            fc1.Standard_OptionalCost_Per_file__c =6;
            
            insert fc1;
            
            for(Integer i=1;i<=6;i++){
                Files__c file= new Files__c();
                file.Name ='testFile'+i;
                file.Production_Order__c =po.id;
                file.File_Category_Code__c =fc.id;
                if(i==1){
                    file.Status__c ='QCIP';
                } else if(i==2){
                    file.Status__c ='On-Hold';
                } else if(i==3){
                    file.Status__c ='Redo Re-Assigned';
                } else {
                    file.Status__c ='QCIP';
                }
                
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
                file.Member__c = member.Id;
				file.Tracker_Handover__c=false;
                fileList.add(file);
            }
            insert fileList; 
            
            Files__c splitParentfile= new Files__c();
            splitParentfile.Name ='A_splitParent_file';
            splitParentfile.Production_Order__c =po6.id;
            splitParentfile.File_Category_Code__c =fc.id;
            splitParentfile.Status__c ='QCIP';
            splitParentfile.File_Location__c=location.id;
            splitParentfile.Current_Extension__c ='.jpg';
            splitParentfile.File_Type__c = 'Image';
            splitParentfile.Member__c = member.Id;
            splitParentfile.IsSplitedFile__c = true;
            splitParentfile.Total_Work_time__c = 220;
            insert splitParentfile;


            Files__c splitChildfile= new Files__c();
            splitChildfile.Name ='Z_splitChild_file';
            splitChildfile.Production_Order__c =po6.id;
            splitChildfile.File_Category_Code__c =fc.id;
            splitChildfile.Status__c ='QCIP';
            splitChildfile.File_Location__c=location.id;
            splitChildfile.Current_Extension__c ='.jpg';
            splitChildfile.File_Type__c = 'Image';
            splitChildfile.Member__c = member.Id;
            splitChildfile.Splitted_Parent_id__c = splitParentfile.Id;
            splitChildfile.Total_Work_time__c = 250;
            insert splitChildfile;
            
            Files__c splitParentfile1= new Files__c();
            splitParentfile1.Name ='A_splitParent_file';
            splitParentfile1.Production_Order__c =po7.id;
            splitParentfile1.File_Category_Code__c =fc.id;
            splitParentfile1.Status__c ='QCIP';
            splitParentfile1.File_Location__c=location.id;
            splitParentfile1.Current_Extension__c ='.jpg';
            splitParentfile1.File_Type__c = 'Image';
            splitParentfile1.Member__c = member.Id;
            splitParentfile1.IsSplitedFile__c = true;
            splitParentfile1.Total_Work_time__c = 220;
            insert splitParentfile1;

            Files__c splitChildfile1= new Files__c();
            splitChildfile1.Name ='Z_splitChild_file';
            splitChildfile1.Production_Order__c =po7.id;
            splitChildfile1.File_Category_Code__c =fc.id;
            splitChildfile1.Status__c ='QCIP';
            splitChildfile1.File_Location__c=location.id;
            splitChildfile1.Current_Extension__c ='.jpg';
            splitChildfile1.File_Type__c = 'Image';
            splitChildfile1.Member__c = member.Id;
            splitChildfile1.Splitted_Parent_id__c = splitParentfile1.Id;
            splitChildfile1.Total_Work_time__c = 250;
            insert splitChildfile1;
            
            Files__c copyParentFile = new Files__c();
            copyParentFile.Name ='1_Parent_file';
            copyParentFile.Production_Order__c =po8.id;
            copyParentFile.File_Category_Code__c =fc.id;
            copyParentFile.Status__c ='QCIP';
            copyParentFile.File_Location__c=location.id;
            copyParentFile.Current_Extension__c ='.jpg';
            copyParentFile.File_Type__c = 'Image';
            copyParentFile.Member__c = member.Id;
            copyParentFile.IsSplitedFile__c = false;
            copyParentFile.Total_Work_time__c = 0;
            insert copyParentFile;
            
            Files__c copyChildFile1 = new Files__c();
            copyChildFile1.Name ='1_Parent_file_copy1';
            copyChildFile1.Production_Order__c =po8.id;
            copyChildFile1.File_Category_Code__c =fc.id;
            copyChildFile1.Status__c ='QCIP';
            copyChildFile1.File_Location__c=location.id;
            copyChildFile1.Current_Extension__c ='.jpg';
            copyChildFile1.File_Type__c = 'Image';
            copyChildFile1.Member__c = member.Id;
            copyChildFile1.Parent_Id__c = copyParentFile.Id;
            copyChildFile1.Total_Work_time__c = 150;
            copyChildFile1.Total_Break_Time__c = 0;
            copyChildFile1.No_of_Breaks__c = 0;
            insert copyChildFile1;
            
            Files__c copyChildFile2 = new Files__c();
            copyChildFile2.Name ='1_Parent_file_copy2';
            copyChildFile2.Production_Order__c =po8.id;
            copyChildFile2.File_Category_Code__c =fc.id;
            copyChildFile2.Status__c ='QCIP';
            copyChildFile2.File_Location__c=location.id;
            copyChildFile2.Current_Extension__c ='.jpg';
            copyChildFile2.File_Type__c = 'Image';
            copyChildFile2.Member__c = member1.Id;
            copyChildFile2.Parent_Id__c = copyParentFile.Id;
            copyChildFile2.Total_Work_time__c = 120;
            copyChildFile2.Total_Break_Time__c = 0;
            copyChildFile2.No_of_Breaks__c = 0;
            insert copyChildFile2;

            
            
            string basepath='Order';
            string type = 'assign';
        
            // Order 2 - Test Data Creation 
            
            Production_Order__c po2 = new Production_Order__c();
            po2.Name ='testPO_DIRECTORY2';
            po2.Production_Order_Status__c ='New';
            po2.MBO_Location__c=location.Id;
            insert po2;
            
            Files__c folderfile= new Files__c();
            folderfile.Name ='testFolder';
            folderfile.Production_Order__c =po2.id;
            folderfile.File_Category_Code__c =fc.id;
            folderfile.Status__c ='QCIP';
            folderfile.File_Location__c=location.id;
            folderfile.Current_Extension__c ='.jpg';
            folderfile.File_Type__c = 'Directory';
            insert folderfile;
            
            List<Files__c> testFileData = new List<Files__c>();
            Files__c childfile= new Files__c();
            childfile.Name ='testFolder';
            childfile.Production_Order__c =po2.id;
            childfile.File_Category_Code__c =fc.id;
            childfile.Status__c ='QCIP';
            childfile.File_Location__c=location.id;
            childfile.Current_Extension__c ='.jpg';
            childfile.File_Type__c = 'Image';
            childfile.Parent_Id__c = folderfile.Id;
            childfile.Member__c = member1.Id;
            testFileData.add(childfile);
            
            Files__c ChFile= new Files__c();
            ChFile.Name ='Check_Test_File';
            ChFile.Production_Order__c =po2.id;
            ChFile.File_Category_Code__c =fc.id;
            ChFile.Status__c ='On-Hold';
            ChFile.File_Location__c=location.id;
            ChFile.Current_Extension__c ='.jpg';
            ChFile.File_Type__c = 'Image';
            ChFile.Member__c = member1.Id;
            testFileData.add(ChFile);
            
            Files__c RedoFile= new Files__c();
            RedoFile.Name ='Redo_Test_File';
            RedoFile.Production_Order__c =po2.id;
            RedoFile.File_Category_Code__c =fc.id;
            RedoFile.Status__c ='Redo Re-Assigned';
            RedoFile.File_Location__c=location.id;
            RedoFile.Current_Extension__c ='.jpg';
            RedoFile.File_Type__c = 'Image';
            RedoFile.Member__c = member1.Id;
            testFileData.add(RedoFile);
            
            Files__c QCIPFile= new Files__c();
            QCIPFile.Name ='ZZZ FILE';
            QCIPFile.Production_Order__c =po2.id;
            QCIPFile.File_Category_Code__c =fc.id;
            QCIPFile.Status__c ='QCIP';
            QCIPFile.File_Location__c=location.id;
            QCIPFile.Current_Extension__c ='.jpg';
            QCIPFile.File_Type__c = 'Image';
            QCIPFile.Member__c = member1.Id;
            testFileData.add(QCIPFile);
            
            
            Files__c QCPFile= new Files__c();
            QCPFile.Name ='ZERedo_Test_File';
            QCPFile.Production_Order__c =po2.id;
            QCPFile.File_Category_Code__c =fc.id;
            QCPFile.Status__c ='QCIP';
            QCPFile.File_Location__c=location.id;
            QCPFile.Current_Extension__c ='.jpg';
            QCPFile.File_Type__c = 'Image';
            QCPFile.Member__c = member1.Id;
            testFileData.add(QCPFile);
            
            Files__c QCPFile2= new Files__c();
            QCPFile2.Name ='ZERedo_Test_File';
            QCPFile2.Production_Order__c =po2.id;
            QCPFile2.File_Category_Code__c =fc.id;
            QCPFile2.Status__c ='QCIP';
            QCPFile2.File_Location__c=location.id;
            QCPFile2.Current_Extension__c ='.jpg';
            QCPFile2.File_Type__c = 'Image';
            QCPFile2.Member__c = member1.Id;
            testFileData.add(QCPFile2);
            
            if(testFileData.size() > 0){
                insert testFileData;
            }
        
        }
        
        static testMethod void test_QCCheck_Screen() {
        
            PageReference pageRef = Page.EPMS_MyDirectoryQCcheckSearch_IT;
            Integer MAX_QUERY = Limits.getLimitQueries(); 
            Integer NUM_QUERY = MAX_QUERY - 1; 

            Test.setCurrentPage(pageRef);
            Production_Order__c order1 = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_22'];
            Production_Order__c order6 = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_2252'];
            Production_Order__c order2 = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_DIRECTORY2'];
            File_Categories__c fileCateg = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testB'];
            File_Categories__c fileCateg2 = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testFC'];
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];

            Test.StartTest();       
            pageRef.getParameters().put('id',order1.Name);
            //pageRef.getParameters().put('id',po.Id);
            
            //EPMS_MyDirectoryQCcheck_clone2 qcCheck1 = new EPMS_MyDirectoryQCcheck_clone2();
            EPMS_MyDirectoryQCcheckSearch qcCheck1 = new EPMS_MyDirectoryQCcheckSearch();
            //List<FileWrapper>  wrapperList = pageRef.getParameters().put(wrapperList[0].isSelected, true);
            // Test File QC Check - Scenario 1
            qcCheck1.qcCommentsForFilesRedo = 'Test Comments for QC Comments REDO';
            qcCheck1.qcCommentsForFilesForApprove = 'Test Comments for QC Comments APPROVE';
            qcCheck1.qcCommentsForFiles = 'Test Comments for QC Comments CHECKED';
            qcCheck1.parentIdValue=order1.id;
            
            qcCheck1.updateQCFileStatusToChecked(); 
            qcCheck1.updateQCFileStatusCheck();
            qcCheck1.updateQCFileStatusToRedo();
            qcCheck1.changeCategory();
            qcCheck1.totalworktime = '';
            qcCheck1.saveChangeCategory();
            qcCheck1.getAllFileCategory();
            qcCheck1.getAllMistakeCategory();
            
            qcCheck1.getAllMistake();
            qcCheck1.getAllFileStatus();
            qcCheck1.changeStatus();
            qcCheck1.saveChangeStatus();
            qcCheck1.getItems();
            
            Test.stopTest();
        
        }
        
        
        static testMethod void test_QCCheck_Screen2() {
            
            PageReference pageRef = Page.EPMS_MyDirectoryQCcheckSearch_IT;
            Integer MAX_QUERY = Limits.getLimitQueries(); 
            Integer NUM_QUERY = MAX_QUERY - 1; 
            Test.setCurrentPage(pageRef);
            Production_Order__c orderA = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_22'];
            Production_Order__c orderB = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_DIRECTORY2'];
            File_Categories__c fileCateg = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testB'];
            File_Categories__c fileCateg2 = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testFC'];
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];

            Test.StartTest();       
            pageRef.getParameters().put('id',orderA.Name);
            EPMS_MyDirectoryQCcheckSearch qcCheckA = new EPMS_MyDirectoryQCcheckSearch();
            
            qcCheckA.wrapperList[4].isSelected = false;
            qcCheckA.wrapperList[3].isSelected = true;
            //qcCheckA.selectvalueCategory = fileCateg.Id;
            qcCheckA.totalworktime = '234';
            qcCheckA.saveChangeCategory();

            qcCheckA.wrapperList[3].isSelected = false;
            qcCheckA.wrapperList[4].isSelected = true;

            qcCheckA.selectMistakeCategory = 'COMMON MISTAKES';
            qcCheckA.selectMistake = 'HOLES REMAINING';
            qcCheckA.penaltycomments = 'File is not statisfied with specs';
            qcCheckA.isSkipPenalty = true;
            qcCheckA.Save();

            qcCheckA.wrapperList[4].isSelected = false;
            qcCheckA.wrapperList[3].isSelected = true;
            qcCheckA.updateQCFileStatusToChecked(); 
            qcCheckA.wrapperList[3].isSelected = false;
            qcCheckA.wrapperList[4].isSelected = true;
            qcCheckA.updateQCFileStatusToRedo(); 
            Test.stopTest();
            
        }   
        
        static testMethod void test_QCCheck_Screen3() {
            
            PageReference pageRef = Page.EPMS_MyDirectoryQCcheckSearch_IT;
            Integer MAX_QUERY = Limits.getLimitQueries(); 
            Integer NUM_QUERY = MAX_QUERY - 1; 

            Test.setCurrentPage(pageRef);
            
            Production_Order__c orderP = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_22'];
            Production_Order__c orderQ = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_DIRECTORY2'];
            File_Categories__c fileCateg = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testB'];
            File_Categories__c fileCateg2 = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testFC'];
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];

            Test.StartTest();       

            pageRef.getParameters().put('id',orderP.Id);
            EPMS_MyDirectoryQCcheckSearch qcCheckB = new EPMS_MyDirectoryQCcheckSearch();            
            qcCheckB.wrapperList[0].isSelected = true;
            qcCheckB.updateQCFileStatusToChecked(); 
            qcCheckB.wrapperList[1].isSelected = true;
            qcCheckB.updateQCFileStatusToRedo(); 

            qcCheckB.wrapperList[2].isSelected = true;
            qcCheckB.updateQCFileStatusCheck(); 
          
            qcCheckB.wrapperList[3].isSelected = true;
            qcCheckB.selectvalue = 'New';
            qcCheckB.saveChangeStatus(); 
            // Assign Penalty
            qcCheckB.wrapperList[0].isSelected = false;
            qcCheckB.wrapperList[1].isSelected = false;
            qcCheckB.wrapperList[2].isSelected = false;
            qcCheckB.wrapperList[3].isSelected = false;
            qcCheckB.wrapperList[4].isSelected = true;
            qcCheckB.selectMistakeCategory = 'COMMON MISTAKES';
            qcCheckB.selectMistake = 'HOLES REMAINING';
            qcCheckB.penaltycomments = 'File is not statisfied with specs';
            qcCheckB.isSkipPenalty = false;
            qcCheckB.Save();
            Test.stopTest();
            
        }   
        
        
        static testMethod void test_QCCheck_Screen4() {
            
            PageReference pageRef = Page.EPMS_MyDirectoryQCcheckSearch_IT;
            Integer MAX_QUERY = Limits.getLimitQueries(); 
            Integer NUM_QUERY = MAX_QUERY - 1; 

            Test.setCurrentPage(pageRef);
            
            
            Production_Order__c orderP = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_22'];
            Production_Order__c orderQ = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_DIRECTORY2'];
            File_Categories__c fileCateg = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testB'];
            File_Categories__c fileCateg2 = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testFC'];
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];

            Test.StartTest();      
           
            pageRef.getParameters().put('id',orderP.Name);
            EPMS_MyDirectoryQCcheckSearch qcCheckF = new EPMS_MyDirectoryQCcheckSearch();
            qcCheckF.getDisableNext();
            qcCheckF.Next();
            qcCheckF.Previous();
            qcCheckF.refreshPageRecords();
            qcCheckF.refresh();
            qcCheckF.getdisplayQCCheckFiles2();
            qcCheckF.searchValue = 'testFile';
            qcCheckF.runSearch();
            qcCheckF.searchValue = 'MM';
            qcCheckF.runSearch();
            qcCheckF.newFileForPageCount = 0;
            qcCheckF.refreshPageRecords();
            qcCheckF.newFileForPageCount = 5;
            qcCheckF.oldPageNumber = 1;
            qcCheckF.refreshPageRecords();
            qcCheckF.newFileForPageCount = 0;
            qcCheckF.oldPageNumber = 1;
            qcCheckF.refreshPageRecords();

            Test.stopTest();
            
        }
        
        static testMethod void test_QCCheck_Screen5() {
            
            PageReference pageRef = Page.EPMS_MyDirectoryQCcheckSearch_IT;
            Integer MAX_QUERY = Limits.getLimitQueries(); 
            Integer NUM_QUERY = MAX_QUERY - 1; 
            Test.setCurrentPage(pageRef);
            
            Production_Order__c orderQ = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_DIRECTORY2'];
            File_Categories__c fileCateg = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testB'];
            File_Categories__c fileCateg2 = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testFC'];
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            
            Test.StartTest();   
            pageRef.getParameters().put('id',orderQ.Name);

            EPMS_MyDirectoryQCcheckSearch qcCheckG = new EPMS_MyDirectoryQCcheckSearch();
            qcCheckG.qcCommentsForFilesRedo = 'Test Comments for QC Comments REDO ###';
            qcCheckG.qcCommentsForFilesForApprove = 'Test Comments for QC Comments APPROVE ###';
            qcCheckG.qcCommentsForFiles = 'Test Comments for QC Comments CHECKED ###';
            qcCheckG.wrapperList[0].isSelected = true;
            qcCheckG.selectMistakeCategory = 'COMMON MISTAKES';
            qcCheckG.selectMistake = 'HOLES REMAINING';
            qcCheckG.penaltycomments = 'File is not statisfied with specs';
            qcCheckG.isSkipPenalty = true;
            qcCheckG.Save();
            qcCheckG.updateQCFileStatusToChecked(); 
            qcCheckG.isImmediateUpload = true;
            qcCheckG.updateQCFileStatusCheck(); 
            Test.stopTest();
            
        }
            
            
        static testMethod void test_QCCheck_Screen6() {
            
            PageReference pageRef = Page.EPMS_MyDirectoryQCcheckSearch_IT;
            Integer MAX_QUERY = Limits.getLimitQueries(); 
            Integer NUM_QUERY = MAX_QUERY - 1; 
            Test.setCurrentPage(pageRef);
            
            //Production_Order__c orderP = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_22'];
            Production_Order__c orderQ = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_DIRECTORY2'];
            File_Categories__c fileCateg = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testB'];
            File_Categories__c fileCateg2 = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testFC'];
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            
            Test.StartTest();   
            pageRef.getParameters().put('id',orderQ.Name);  
            EPMS_MyDirectoryQCcheckSearch qcCheckH = new EPMS_MyDirectoryQCcheckSearch();
            qcCheckH.wrapperList[2].isSelected = false;
            qcCheckH.wrapperList[3].isSelected = true;
            qcCheckH.selectMistakeCategory = 'COMMON MISTAKES';
            qcCheckH.selectMistake = 'HOLES REMAINING';
            qcCheckH.penaltycomments = 'File is not statisfied with specs';
            qcCheckH.isSkipPenalty = true;
            //qcCheck2.Save();
            
            qcCheckH.selectMistakeCategory = 'COMMON MISTAKES';
            qcCheckH.selectMistake = null;
            qcCheckH.penaltycomments = 'File is not statisfied with specs';
            qcCheckH.isSkipPenalty = true;
            qcCheckH.Save();
            
            qcCheckH.selectMistakeCategory = null;
            qcCheckH.selectMistake = null;
            qcCheckH.penaltycomments = 'File is not statisfied with specs';
            qcCheckH.isSkipPenalty = true;
            qcCheckH.Save();
            qcCheckH.wrapperList[3].isSelected = false;
            qcCheckH.selectvalue = 'New';
            qcCheckH.saveChangeStatus(); 
            qcCheckH.wrapperList[3].isSelected = false;
            qcCheckH.selectvalueCategory = 'A';
            qcCheckH.totalworktime = '289';
            qcCheckH.UpdateCategory();
            qcCheckH.getCategoryForInputTime();
            qcCheckH.saveChangeCategory();
            
            qcCheckH.wrapperList[4].isSelected = true;
            qcCheckH.isImmediateUpload = true;
            qcCheckH.updateQCFileStatusCheck(); 
        
            qcCheckH.wrapperList[1].isSelected = true;
            qcCheckH.selectvalueCategory = fileCateg.Id;
            qcCheckH.newCategoryGet = fileCateg.Id;
            qcCheckH.getAllFileCategory();
            qcCheckH.totalworktime = '289';
            qcCheckH.UpdateCategory();
            qcCheckH.wrapperList[1].isSelected = false;
            qcCheckH.wrapperList[4].isSelected = true;
            qcCheckH.UpdateCategory();
            qcCheckH.getCategoryForInputTime();
            qcCheckH.saveChangeCategory();
            
            Test.stopTest();
        }
        
        
         static testMethod void test_QCCheck_Screen7() {
            
            PageReference pageRef = Page.EPMS_MyDirectoryQCcheckSearch_IT;
            Integer MAX_QUERY = Limits.getLimitQueries(); 
            Integer NUM_QUERY = MAX_QUERY - 1; 
            Test.setCurrentPage(pageRef);
            
            Production_Order__c orderQ = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_DIRECTORY2'];
            File_Categories__c fileCateg = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testB'];
            File_Categories__c fileCateg2 = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testFC'];
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            
            Test.StartTest();   
            pageRef.getParameters().put('id',orderQ.Name);
            EPMS_MyDirectoryQCcheckSearch qcCheckM = new EPMS_MyDirectoryQCcheckSearch();
        
            qcCheckM.wrapperList[0].isSelected = false;
            qcCheckM.wrapperList[1].isSelected = true;
            
            qcCheckM.updateQCFileStatusToRedo();
            qcCheckM.isImmediateUpload = true;
            qcCheckM.updateQCFileStatusCheck();
            
            qcCheckM.wrapperList[1].isSelected = false;
            qcCheckM.wrapperList[2].isSelected = true;
            qcCheckM.updateQCFileStatusToRedo();
            qcCheckM.isImmediateUpload = false;
            qcCheckM.updateQCFileStatusCheck();
            
            Test.stopTest();
            
        }
            
        static testMethod void test_QCCheck_Screen8() {
            
            PageReference pageRef = Page.EPMS_MyDirectoryQCcheckSearch_IT;
            Integer MAX_QUERY = Limits.getLimitQueries(); 
            Integer NUM_QUERY = MAX_QUERY - 1; 
            Test.setCurrentPage(pageRef);
            
            Production_Order__c orderQ = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_DIRECTORY2'];
            File_Categories__c fileCateg = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testB'];
            File_Categories__c fileCateg2 = [SELECT Id, Name FROM File_Categories__c WHERE Name = 'testFC'];
            Location__c location = [SELECT Id, Name FROM Location__c WHERE Name = 'INDIA PRIVATE LIMITED - Phaseex2'];
            
            Test.StartTest();   
            pageRef.getParameters().put('id',orderQ.Name);

            EPMS_MyDirectoryQCcheckSearch qcCheckG = new EPMS_MyDirectoryQCcheckSearch();
            
            qcCheckG.updateQCFileStatusToChecked(); 
            qcCheckG.isImmediateUpload = true;
            qcCheckG.updateQCFileStatusCheck(); 
            //qcCheckG.updateQCFileStatusToRedo();
            
            qcCheckG.wrapperList[0].isSelected = false;
            qcCheckG.wrapperList[1].isSelected = true;
            
            qcCheckG.updateQCFileStatusToRedo();
            qcCheckG.isImmediateUpload = true;
            qcCheckG.updateQCFileStatusCheck();
            
            qcCheckG.wrapperList[1].isSelected = false;
            qcCheckG.wrapperList[2].isSelected = true;
            qcCheckG.updateQCFileStatusToRedo();
            qcCheckG.isImmediateUpload = false;
            qcCheckG.updateQCFileStatusCheck();
            
            qcCheckG.getDisablePreviousNew();
            qcCheckG.getDisableNextNew();
            qcCheckG.NextNew();
            qcCheckG.PreviousNew();
            qcCheckG.getAllFileCategory();
            qcCheckG.selectMistakeCategory = 'COMMON MISTAKES';
            qcCheckG.selectMistake = 'HOLES REMAINING';
            //qcCheckG.selectMistakeCategory  = qcCheckG.getAllFileCategory()[1].getValue();
            qcCheckG.getAllMistakeCategory();
            qcCheckG.getAllMistake();
             qcCheckG.selectMistakeCategory = 'SERIOUS MISTAKES';
            qcCheckG.selectMistake = 'Path Incompleted';
            //qcCheckG.selectMistakeCategory  = qcCheckG.getAllFileCategory()[1].getValue();
            qcCheckG.getAllMistakeCategory();
            qcCheckG.getAllMistake();
            qcCheckG.selectMistakeCategory = 'VERY SERIOUS MISTAKE';
            qcCheckG.selectMistake = 'Instruction Not Followed';
            //qcCheckG.selectMistakeCategory  = qcCheckG.getAllFileCategory()[1].getValue();
            qcCheckG.getAllMistakeCategory();
            qcCheckG.getAllMistake();
            qcCheckG.searchValue = '';
            qcCheckG.runSearch();
            qcCheckG.getDisablePrevious();
            
            
            
            Test.stopTest();
            
        }
        
        
        static testMethod void test_QCCheck_Screen9() {
            
            PageReference pageRef = Page.EPMS_MyDirectoryQCcheckSearch_IT;
            Integer MAX_QUERY = Limits.getLimitQueries(); 
            Integer NUM_QUERY = MAX_QUERY - 1; 
            Test.setCurrentPage(pageRef);
            Test.StartTest();   
            Production_Order__c orderQ = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_2252'];
            
            
            pageRef.getParameters().put('id',orderQ.Name);
            EPMS_MyDirectoryQCcheckSearch qcCheckba = new EPMS_MyDirectoryQCcheckSearch();
            qcCheckba.wrapperList[0].isSelected = true;
            qcCheckba.wrapperList[1].isSelected = true;
            qcCheckba.isImmediateUpload = false;
            qcCheckba.qcCommentsForFilesForApprove = 'Testing333';
            qcCheckba.updateQCFileStatusCheck();
             qcCheckba.wrapperList[0].isSelected = true;
             qcCheckba.updateQCFileStatusToChecked();
            qcCheckba.closePopup();
            qcCheckba.closeJobTitlePopup();
            qcCheckba.cancel();
        
            Test.stopTest();
            
       }     
        
       static testMethod void test_QCCheck_Screen10() {
            
            PageReference pageRef = Page.EPMS_MyDirectoryQCcheckSearch_IT;
            Integer MAX_QUERY = Limits.getLimitQueries(); 
            Integer NUM_QUERY = MAX_QUERY - 1; 
            Test.setCurrentPage(pageRef);
            Test.StartTest();   
            Production_Order__c orderQ = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_2289'];
                       
            pageRef.getParameters().put('id',orderQ.Name);
            EPMS_MyDirectoryQCcheckSearch qcCheckbc = new EPMS_MyDirectoryQCcheckSearch();
            system.debug('--- Wrapper List -- QC CHECK 10 -- ' + qcCheckbc.WrapperList);
            qcCheckbc.wrapperList[0].isSelected = true;
            qcCheckbc.updateQCFileStatusToChecked();
            qcCheckbc.closePopup();
            qcCheckbc.closeJobTitlePopup();
            qcCheckbc.cancel();
        
            Test.stopTest();
            
       }      
       
       static testMethod void test_QCCheck_Screen11() {
            
            PageReference pageRef = Page.EPMS_MyDirectoryQCcheckSearch_IT;
            Integer MAX_QUERY = Limits.getLimitQueries(); 
            Integer NUM_QUERY = MAX_QUERY - 1; 
            Test.setCurrentPage(pageRef);
            Test.StartTest();   
            Production_Order__c orderZ = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'MD-0091201'];
            
            
            pageRef.getParameters().put('id',orderZ.Name);
            EPMS_MyDirectoryQCcheckSearch qcCheckbe = new EPMS_MyDirectoryQCcheckSearch();
            //qcCheckba.qcCommentsForFilesRedo = 'Test Comments for QC Comments REDO';
            //qcCheckba.qcCommentsForFilesForApprove = 'Test Comments for QC Comments APPROVE';
            //qcCheckba.qcCommentsForFiles = 'Test Comments for QC Comments CHECKED';
            system.debug('--- Wrapper List -- QC CHECK 11 -- ' + qcCheckbe.WrapperList);
            
            qcCheckbe.wrapperList[1].isSelected = true;
            qcCheckbe.wrapperList[2].isSelected = true;
            qcCheckbe.updateQCFileStatusToChecked();
            qcCheckbe.OnHoldCheck = true;
            qcCheckbe.wrapperList[0].isSelected = true;
            qcCheckbe.isImmediateUpload = false;
            qcCheckbe.qcCommentsForFilesForApprove = 'Testing44';
            qcCheckbe.updateQCFileStatusCheck();
            
            
            //qcCheck1.Save();
            qcCheckbe.closePopup();
            qcCheckbe.closeJobTitlePopup();
            qcCheckbe.cancel();
        
            Test.stopTest();
            
       }   
       
       static testMethod void test_QCCheck_Screen12() {
            
            PageReference pageRef = Page.EPMS_MyDirectoryQCcheckSearch_IT;
            Integer MAX_QUERY = Limits.getLimitQueries(); 
            Integer NUM_QUERY = MAX_QUERY - 1; 
            Test.setCurrentPage(pageRef);
            Test.StartTest();   
            Production_Order__c orderQ = [SELECT Id, Name FROM Production_Order__c WHERE Name = 'testPO_2289'];
            List<Files__c> filesInSplitScenario = null;
            List<Files__c>  updateSplitFileToQCIP = new List<Files__c>();
            if(orderQ != null){
                filesInSplitScenario = [SELECT Id, Name, Status__c FROM Files__c WHERE Production_Order__c =: orderQ.Id];
            }
            if(filesInSplitScenario != null && filesInSplitScenario.size() > 0){
                for(Files__c splitFiles : filesInSplitScenario){
                    splitFiles.Status__c = 'QCIP';
                    updateSplitFileToQCIP.add(splitFiles);
                }
            }
            
            pageRef.getParameters().put('id',orderQ.Name);
            if(updateSplitFileToQCIP != null && updateSplitFileToQCIP.size() > 0){
               // update updateSplitFileToQCIP;
            }
            
            pageRef.getParameters().put('id',orderQ.Name);
            EPMS_MyDirectoryQCcheckSearch qcCheckbc1 = new EPMS_MyDirectoryQCcheckSearch();
            system.debug('--- Wrapper List -- QC CHECK 12 -- Next ' + qcCheckbc1.WrapperList);
            qcCheckbc1.wrapperList[0].isSelected = true;
            qcCheckbc1.isImmediateUpload = false;
            qcCheckbc1.qcCommentsForFilesForApprove = 'Testing';
            qcCheckbc1.updateQCFileStatusCheck();
            qcCheckbc1.wrapperList[0].isSelected = true;
            qcCheckbc1.qcCommentsForFiles = 'Test Comments for QC Comments CHECKED';
            qcCheckbc1.updateQCFileStatusToChecked();
            qcCheckbc1.wrapperList[0].isSelected = true;
            qcCheckbc1.qcCommentsForFilesRedo = 'Test Comments for QC Comments REDO';
            qcCheckbc1.updateQCFileStatusToRedo();
            qcCheckbc1.closePopup();
            qcCheckbc1.closeJobTitlePopup();
            qcCheckbc1.cancel();
        
            Test.stopTest();
            
       }      
        
}