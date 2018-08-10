/**********************************************************************************
*   Class               :       clsTest_EPMS_CreateProductionOrder                *
*   Created Date        :       02/04/2016                                        *
*   Description         :       Test Class for EPMS_CreateProductionOrder        *
**********************************************************************************/
@isTest
    public class clsTest_EPMS_CreateProductionOrder  {
    
        static testMethod void test_CreatePO() {
        
            PageReference pageRef = Page.EPMS_CreateProdOrder;
            
            Account acc=new Account(Name='TEST ACC');
            insert acc;
            
            Anken__c anken=new Anken__c(KokyakuName__c=acc.Id,Status__c='Open',Sagyoshiji_Renrakujiko__c='please refer PDF for instructions',
                            Nouki_Date__c=System.Today());
            insert anken;
            
            Location__c location = new Location__c();
            location.Name = 'INDIAN MBO';
            location.Location_Country__c='India';
            location.Location_Status__c ='Active';
            location.Group_Name__c='INDIAN MBO';
            insert location;
            

            Location__c location2 = new Location__c();
            location2.Name = 'INDIAN MBO1';
            location2.Location_Country__c='India';
            location2.Location_Status__c ='Active';
            location2.Group_Name__c='INDIAN MBO1';
            insert location2;   
            
                     
            Production_Order__c po=new Production_Order__c();
            po.Name ='testPO_22';
            po.Production_Order_Status__c ='New';
            po.MBO_Location__c=location.Id;
            insert po;
            
            
            
            List<Production_Order__c> JobList=new List<Production_Order__c>();           
            
            List<String> selectedJobId=new  List<String>();
            
            Job_Titles__c jobs=new Job_Titles__c(Name='Alpha'); 
            insert jobs;
            
            Job_Titles__c jobs1=new Job_Titles__c(Name='Alpha Channel Masking'); 
            insert jobs1;
            
            Job_Titles__c jobs2=new Job_Titles__c(Name='Clipping'); 
            insert jobs2;  
                                 
            selectedJobId.add(jobs2.Name);
            selectedJobId.add(jobs1.Name);
            selectedJobId.add(jobs.Name);
         
            List<Files__c> fileList = new List<Files__c>();
            File_Categories__c fc= new File_Categories__c();
            fc.Name ='testFC';
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;            
            insert fc; 
            
            for(Integer i=1;i<=5;i++){
                Files__c file= new Files__c();
                file.Name ='testFile'+i;
                file.Production_Order__c =po.id;
                file.File_Category_Code__c =fc.id;
                file.Status__c ='New';
                file.File_Location__c=location.id;
                file.Current_Extension__c ='.jpg';
                file.File_Type__c = 'Image';
                fileList.add(file);
            }
            insert fileList; 
            
           Production_Order__c po1=new Production_Order__c();
            po1.Name ='testPO1_22';
            po1.Production_Order_Status__c ='New';
            po1.MBO_Location__c=location.Id;
            po1.Job_List__c=jobs1.Name+''+jobs2.Name;
            insert po1; 
            
           Production_Order__c po2=new Production_Order__c();
            po2.Name ='testPO1_23';
            po2.Production_Order_Status__c ='Uploaded';
            po2.FTP_Upload_Status__c = true;
            po2.MBO_Location__c=location.Id;
            po2.Job_List__c=jobs1.Name+''+jobs2.Name;
            insert po2; 
            
            
            po2.Name ='testPO1_23';
            po2.Production_Order_Status__c ='Uploaded';
            po2.MBO_Location__c=location.Id;
            po2.FTP_Upload_Status__c = false;
            po2.Job_List__c=jobs1.Name+''+jobs2.Name;
            po2.Production_Order_Status__c ='WIP';
            update po2; 
            
            
            JobList.add(po1); 
             JobList.add(po2);
           Test.StartTest(); 
            
           Test.setCurrentPage(pageRef);
           pageRef.getParameters().put('ids',anken.Id);
            
           EPMS_CreateProductionOrder CreatePO=new EPMS_CreateProductionOrder();

           CreatePO.getListOfLocations();
           CreatePO.getListOfStatus();
           CreatePO.getListOfJobs();
           CreatePO.selectedJobId =selectedJobId;
           CreatePO.selectedLocId =location.Id;
           CreatePO.saveList();
           CreatePO.save();
           
           pageRef.getParameters().put('ids',po1.Id);
           EPMS_CreateProductionOrder CreatePO2=new EPMS_CreateProductionOrder();
           CreatePO2.existPOList=JobList;
           CreatePO2.getListOfLocations();
           CreatePO2.JobList=JobList;
           CreatePO2.getListOfStatus();
           CreatePO2.getListOfJobs();
           CreatePO2.selectedJobId =selectedJobId;
           CreatePO2.selectedLocId =po1.Mbo_Location__c;
           CreatePO2.selectedStatusId=po1.Production_Order_Status__c;
           CreatePO2.saveList();
           CreatePO2.save();
 }
 }