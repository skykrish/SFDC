/**********************************************************************************
*   Class               :       Test_EPMS_AnkenEstimation                         *
*   Created Date        :       06/03/2018                                        *           
*   Description         :       Test class for EPMS_AnkenEstimation               *
**********************************************************************************/
@Istest
public class Test_EPMS_AnkenEstimation {
    
    static testmethod void test_EPMS_AnkenClassifications() {
        
        Profile profile = [select id from Profile where Name ='System Administrator']; 
        User user = new User();
        user.FirstName ='test';
        user.LastName ='data';
        user.Alias ='cust'; 
        user.Username ='testuser@mbo.com';
        user.Email='test@gmail.com';
        user.ProfileId  = profile.id;
        user.TimeZoneSidKey='America/Los_Angeles';
        user.LocaleSidKey='en_US';
        user.EmailEncodingKey='UTF-8';
        user.LanguageLocaleKey='en_US';
        insert user;
        
        system.runAs(user){ 
            
            UserEmail__c usermail=new UserEmail__c();
            usermail.Name='New Email';
            usermail.Email__c='teSRMBO@mbo.in';
            insert usermail;
            
            Employee_Country_Code__c tRecord= new Employee_Country_Code__c();
            tRecord.Name='India784';
            tRecord.Country_Initial_Letter__c='M';
            insert tRecord;
            
            Location__c location = new Location__c();
            location.Name ='Media BackOffice Test';
            location.Location_Country__c='india';
            location.Location_Status__c='Active';
            location.Group_Name__c='Media Backoffice Test';
            insert location;
            
            Account testAcc = new Account();
            testAcc.Name='Test';
            insert testAcc;      
            
            anken__c ank = new anken__c();
            ank.KokyakuName__c = testAcc.id;
            insert ank;
            
            anken__c result = [SELECT Id, Name FROM anken__c WHERE Id = : ank.Id];
            production_order__c po = new production_order__C();
            po.Name=result.Name;
            po.Mbo_Location__c =location.id;
            po.Anken_Order__c=ank.Id;
            po.Production_Order_Status__c ='New';
            insert po;
            
            production_order__c po1 = new production_order__C();
            po1.Name=result.Name+'-1';
            po1.Mbo_Location__c =location.id;
            po1.Anken_Order__c=ank.Id;
            po1.Production_Order_Status__c ='Assigned';
            insert po1;
            
            Job_Titles__c jobs1 = new Job_Titles__c();
            jobs1.Name='Gray Masking';
            jobs1.Disabled__c = false;
            insert jobs1;            
            
            Job_Titles__c jobs2 = new Job_Titles__c();
            jobs2.Name='Testing';
            jobs2.Disabled__c = false;
            insert jobs2;            
            
            File_Categories__c fileCategory = new File_Categories__c();
            fileCategory.Name = 'Test';
            fileCategory.Standard_Time_per_File_Min__c=11;
            fileCategory.Standard_Time_per_File_Max__c=20;
            fileCategory.Standard_Regular_Cost_per_File__c=3;
            fileCategory.Standard_OptionalCost_Per_file__c=1;
            insert fileCategory;
            
            Files__c file = new Files__c();
            file.Production_Order__c=po.id;
            file.Name='TestFA';
            file.Estimated_File_Category__c=fileCategory.id;
            file.Status__c='Awaiting Approval';
            file.File_Location__c=location.Id;
            file.Current_Extension__c='.jpg';
            file.Files_To_open__c = 1;
            file.File_type__c='image';
            file.File_Job_Titles__c = 'Gray Masking,Testing';
            file.Dir_File_name__c='/share/JavaDev/Input3/20160617/00514440/TestFA.jpg';
            insert file; 
            
            Files__c file1 = new Files__c();
            file1.Production_Order__c=po.id;
            file1.Name='TestFA';
            file1.Estimated_File_Category__c=fileCategory.id;
            file1.Status__c='Awaiting Approval';
            file1.File_Location__c=location.Id;
            file1.Current_Extension__c='.jpg';
            file1.Files_To_open__c = 1;
            file1.File_type__c='image';
            file1.File_Job_Titles__c = 'Gray Masking,Testing';
            file1.Dir_File_name__c='/share/JavaDev/Input3/20160617/00514440/TestFA.jpg';
            
            insert file1;   
            
            
            Files__c Directory= new Files__c();
            Directory.Production_Order__c=po.id;
            Directory.Name='TestFA';
            Directory.Estimated_File_Category__c=fileCategory.id;
            Directory.Status__c='Awaiting Approval';
            Directory.File_Location__c=location.Id;
            Directory.Current_Extension__c='.jpg';
            Directory.Files_To_open__c = 1;
            Directory.File_type__c='Directory';
            Directory.File_Job_Titles__c = 'Gray Masking,Testing';
            Directory.Dir_File_name__c='/share/JavaDev/Input3/20160617/00514440/TestFA.jpg';            
            insert Directory;          
            
            ApexPages.currentPage().getParameters().put('ids',ank.Id);
            ApexPages.currentPage().getParameters().put('id',po.Name);
            ApexPages.currentPage().getParameters().put('Name','Gray Masking');
            
            try{
                 test.startTest();
                
                EPMS_AnkenEstimation clas = new EPMS_AnkenEstimation();
                EPMS_AnkenEstimation.WrapperFiles clas1 = new EPMS_AnkenEstimation.WrapperFiles('Estimation',5,5);
                
                clas.ProductionOrderName= po.id;
                clas.selectedCategory = 'Approved';
                clas.filterByStatus();
                clas.selectedCategory = 'All';
                clas.filterByStatus();
                clas.refreshRedoRecords();
                // clas.ExportToExcelForOptionalJobs();
                List<selectoption> options = clas.getAllTypeCategory();
                PageReference p1 = clas.ExportToExcel();
                
                PageReference p2 = clas.ExportToExcelEstimation();
                
                EPMS_AnkenService_Querylocator queryloc= new EPMS_AnkenService_Querylocator();
                queryloc.getdirFiles(Directory.Name,po.Id);  
                queryloc.getCatFiles(fileCategory.Name,po.Id);
                queryloc.getallFilesEXCEL(po.Id);
                queryloc.getProductionOrderrecord(po.Id);
                test.stopTest();     
                
            }catch(Exception e){
                
            }           
        }
    }
}