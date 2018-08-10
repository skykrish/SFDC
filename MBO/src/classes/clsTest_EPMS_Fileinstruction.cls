/**********************************************************************************
*   Class               :       clsTest_EPMS_Fileinstruction                      *
*   Created Date        :       18/04/2016                                        *
*   Description         :       Test Class for EPMS_Fileinstruction               *
**********************************************************************************/

@isTest
    public class clsTest_EPMS_Fileinstruction {
    
        static testMethod void test_EPMS_Fileinstruction() {
        
            PageReference pageRef = Page.Epms_FileInstructions;
            
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
            
                     
            Production_Order__c po=new Production_Order__c();
            po.Name ='testPO_22';
            po.Production_Order_Status__c ='New';
            po.MBO_Location__c=location.Id;
            po.Production_Order_Instruction__c ='please refer PDF for instructions';
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
         
            File_Categories__c fc= new File_Categories__c();
            fc.Name ='testFC';
            fc.Standard_Time_per_File_Min__c =11;
            fc.Standard_Time_per_File_Max__c =20;
            fc.Standard_Regular_Cost_per_File__c =934;
            fc.Standard_OptionalCost_Per_file__c =5;            
            insert fc; 
            
            Files__c filedir= new Files__c();
            filedir.Name ='Wild';
            filedir.Production_Order__c =po.id;
            filedir.File_Category_Code__c =fc.id;
            filedir.File_Preview_URL__c='http://117.239.57.206:8003/po.Name/anken.Name/Wild';
            filedir.Status__c ='New';
            filedir.File_Location__c=location.id;
            filedir.Current_Extension__c ='.jpg';
            filedir.File_Type__c = 'Directory';
            
            Files__c file= new Files__c();
            file.Name ='wallpaper-hd-1080p_gdzCfcM.jpg';
            file.Production_Order__c =po.id;
            file.File_Category_Code__c =fc.id;
            file.File_Preview_URL__c='http://117.239.57.206:8003/po.Name/anken.Name/Wild/wallpaper-hd-1080p_gdzCfcM.jpg';
            file.Status__c ='New';
            file.Instructionnames__c='Test Data';
            file.File_Location__c=location.id;
            file.Current_Extension__c ='.jpg';
            file.File_Type__c = 'File instruction';
            file.Parent_Id__c=filedir.Id;
                
            list<files__c> FileList=new list<Files__c>();
            FileList.add(filedir);     
            
            FileList.add(file); 
            insert FileList;  
           
            po.Production_Order_Instruction__c ='please do not refer PDF for instructions';
            update po;
            
            FileList[0].Order_Instructions__c='Test ins';
            update FileList;
            
            
            Test.StartTest(); 
            
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id',FileList[1].Id);
            EPMS_Fileinstruction fileIns=new EPMS_Fileinstruction();
            EPMS_Fileinstruction.WrapperFiles Wrapper = new EPMS_Fileinstruction.WrapperFiles ('File Instructions','insnames');  //Covering inner/wrapper class
            fileIns.ids=FileList[1].Id;
            pageRef.getParameters().put('myUrl',FileList[1].File_Preview_URL__c);
            fileIns.myUrl='http://117.239.57.206:8003/po.Name/anken.Name/Wild/wallpaper-hd-1080p_gdzCfcM.jpg';
            fileIns.gotoURL();
            
            
            Test.StopTest();
 
          
        }
    }