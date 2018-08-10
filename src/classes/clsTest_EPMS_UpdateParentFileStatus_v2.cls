/**********************************************************************************
*   Class               :       clsTest_EPMS_UpdateParentFileStatus_v2            *
*   Created Date        :       04/04/2016                                        *
*   Description         :       Test Class for EPMS_updateFolderStatusBasedOnFile *
**********************************************************************************/
@isTest
    public class clsTest_EPMS_UpdateParentFileStatus_v2{
    
        @testSetup static void setupTestData(){
            
            Location__c location = new Location__c();
            location.Name = 'INDIA PRIVATE LIMITED - Phaseex47';
            location.Location_Country__c='India';
            location.Location_Status__c ='active';
            location.Group_Name__c='INDIA PRIVATE LIMITED - Phaseex47';
            insert location;
            
            Employee_Country_Code__c testRecord= new Employee_Country_Code__c();
            testRecord.Name='India';
            testRecord.Country_Initial_Letter__c='V';
            insert testRecord;
            
              
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New User Email';
            usermail.Email__c='metroadmin@mbo.in';
            insert usermail;
            
            Member__c member =new Member__c();
            member.Name='Stephen';     
            member.Location_id__c=location.id;
            member.Last_Name__c='Johnson';
            member.Email__c='metromember@mbo.in';
            member.Country__c='India';
            member.Designation__c='Quality Control';
            member.Status__c='Active';
            //insert member; 
            
            List<Files__c> fileList = new List<Files__c>();

            File_Categories__c fc= new File_Categories__c();
            fc.Name ='BM';
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;
            
            insert fc;
            
            Production_Order__c po=new Production_Order__c();
            po.Name ='O23001233';
            po.Production_Order_Status__c ='New';
            po.MBO_Location__c=location.Id;
            insert po;
            
            Files__c mainfolder = new Files__c();
            mainfolder.Name ='MainrootfolderFile';
            mainfolder.Production_Order__c =po.id;
            mainfolder.File_Category_Code__c =fc.id;
            mainfolder.Status__c ='New';
            mainfolder.File_Location__c=location.id;
            mainfolder.Current_Extension__c ='.jpg';
            mainfolder.File_Type__c = 'Directory';
            insert mainfolder;
            
            Files__c rootfolder = new Files__c();
            rootfolder.Name ='rootfolderFile1';
            rootfolder.Production_Order__c =po.id;
            rootfolder.File_Category_Code__c =fc.id;
            rootfolder.Status__c ='New';
            rootfolder.File_Location__c=location.id;
            rootfolder.Current_Extension__c ='.jpg';
            rootfolder.File_Type__c = 'Directory';
            rootfolder.Parent_Id__c = mainfolder.Id;
            insert rootfolder;
            
            Files__c folder = new Files__c();
            folder.Name ='folder1';
            folder.Production_Order__c =po.id;
            folder.File_Category_Code__c =fc.id;
            folder.Status__c ='New';
            folder.File_Location__c=location.id;
            folder.Current_Extension__c ='.jpg';
            folder.File_Type__c = 'Directory';
            folder.Parent_Id__c = rootfolder.Id;
            insert folder;
            
            Files__c folderFile = new Files__c();
            folderFile.Name ='folderFile1';
            folderFile.Production_Order__c =po.id;
            folderFile.File_Category_Code__c =fc.id;
            folderFile.Status__c ='New';
            folderFile.File_Location__c=location.id;
            folderFile.Current_Extension__c ='.jpg';
            folderFile.File_Type__c = 'Image';
            //folderFile.Member__c = member.Id;
            folderFile.Parent_Id__c = folder.Id;
            insert folderFile;
            
            Files__c rootfolder1 = new Files__c();
            rootfolder1.Name ='rootfolderFile2';
            rootfolder1.Production_Order__c =po.id;
            rootfolder1.File_Category_Code__c =fc.id;
            rootfolder1.Status__c ='New';
            rootfolder1.File_Location__c=location.id;
            rootfolder1.Current_Extension__c ='.jpg';
            rootfolder1.File_Type__c = 'Directory';
            rootfolder1.Parent_Id__c = mainfolder.Id;
            insert rootfolder1;
            
            Files__c folder1 = new Files__c();
            folder1.Name ='folder2';
            folder1.Production_Order__c =po.id;
            folder1.File_Category_Code__c =fc.id;
            folder1.Status__c ='New';
            folder1.File_Location__c=location.id;
            folder1.Current_Extension__c ='.jpg';
            folder1.File_Type__c = 'Directory';
            folder1.Parent_Id__c = rootfolder.Id;
            insert folder1;
            
            Files__c folderFile1 = new Files__c();
            folderFile1.Name ='folderFile2';
            folderFile1.Production_Order__c =po.id;
            folderFile1.File_Category_Code__c =fc.id;
            folderFile1.Status__c ='New';
            folderFile1.File_Location__c=location.id;
            folderFile1.Current_Extension__c ='.jpg';
            folderFile1.File_Type__c = 'Image';
            //folderFile1.Member__c = member.Id;
            folderFile1.Parent_Id__c = folder1.Id;
            insert folderFile1;
            
        }


        static testMethod void EPMS_UpdateParentFileStatus() {
            
            List<Files__c> updateFiles = new List<Files__c>();
            Files__c files1 = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'folderFile1' AND Parent_Id__r.Name = 'folder1'];
            Files__c files2 = [SELECT Id, Name, Status__c FROM Files__c WHERE Name = 'folderFile2' AND Parent_Id__r.Name = 'folder2'];
            Test.startTest();
            files1.Status__c = 'QCIP';
            updateFiles.add(files1);
            files2.Status__c = 'QCIP';
            updateFiles.add(files2);
            update updateFiles;
            Test.stopTest();

        }
    }