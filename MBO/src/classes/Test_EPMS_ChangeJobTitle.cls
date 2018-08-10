/************************************************************************************
*   Class               :       Test_EPMS_ChangeJobTitle                            *
*   Created Date        :       28/11/2017                                          *           
*   Description         :       Test class for EPMS_ChangeJobTitle                  *
************************************************************************************/
@istest
public class Test_EPMS_ChangeJobTitle {

    @testSetup static void setupTestData(){
        
        Account acc=new Account(Name='TEST ACC');
        insert acc;

        Anken__c anken=new Anken__c();
        anken.KokyakuName__c=acc.Id;
        anken.Status__c='Open';
        anken.Sagyoshiji_Renrakujiko__c='please refer PDF for instructions';
        anken.Nouki_Date__c=System.Today();
        insert anken;
        
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;

        Production_Order__c po=new Production_Order__c();
        po.Name ='O0002530';
        po.Anken_Order__c = anken.Id;
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        po.Job_List__c = 'Clipping,Cropping';
        insert po;
        
        Job_Titles__c jobNames = new Job_Titles__c();
        jobNames.Name = 'Cropping,Clipping,Soft Mask';
        insert jobNames;

        Files__c file = new Files__c();
        file.Name ='Testfile_1001.jpg';
        file.Production_Order__c =po.id;
        file.Status__c ='Assigned';
        file.File_Location__c=location.id;
        file.Current_Extension__c ='.jpg';
        file.File_Type__c = 'Image';
        file.File_Job_Titles__c = 'Clipping,Cropping';
        insert file;  
        
    }


    public static testMethod void ChangeJobTitle_test() {
   
        PageReference pageRef = Page.EPMS_ChangeJobTitle;
   
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Name ='Testfile_1001.jpg'];
       
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
        pageRef.getParameters().put('ids',fileIds);
         
        EPMS_ChangeJobTitle chgJobTitle = new  EPMS_ChangeJobTitle();   
        Test.stopTest();
   }
   
   
    public static testMethod void ChangeJobTitle_polistpage_Update_test() {
   
        PageReference pageRef = Page.EPMS_ChangeJobTitle;
   
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Name ='Testfile_1001.jpg'];
       
        Test.StartTest();
        
        Test.setCurrentPage(pageRef);
        
        production_Order__c ProdOrder=[select id,name from Production_Order__c where Name='O0002530'];
        
        pageRef.getParameters().put('ids',ProdOrder.id);
         pageRef.getParameters().put('type','polistpage');
         
        EPMS_ChangeJobTitle chgJobTitle = new  EPMS_ChangeJobTitle();
        chgJobTitle.jobTitleListWrapper[0].checkBool = true;
        chgJobTitle.updateObject();
        chgJobTitle.updatePOAnkenFiles('Clipping');
                   
        Test.stopTest();
   }
   
    public static testMethod void ChangeJobTitle_podetailpage_Update_test() {
   
        PageReference pageRef = Page.EPMS_ChangeJobTitle;
   
        Test.StartTest();
        
        Test.setCurrentPage(pageRef);
        
        production_Order__c ProdOrder=[select id,name from Production_Order__c where Name='O0002530'];
        
        pageRef.getParameters().put('ids',ProdOrder.id);
         pageRef.getParameters().put('type','podetailpage');
         
        EPMS_ChangeJobTitle chgJobTitle = new  EPMS_ChangeJobTitle();
        chgJobTitle.jobTitleListWrapper[0].checkBool = true;
        chgJobTitle.updateObject();
        chgJobTitle.updatePOAnkenFiles('Clipping');
                   
        Test.stopTest();
   }
   
    public static testMethod void ChangeJobTitle_file_Update_test() {
   
        PageReference pageRef = Page.EPMS_ChangeJobTitle;
   
        List<Files__c> fileList = [SELECT Id, Name FROM Files__c WHERE Name ='Testfile_1001.jpg'];
       
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
        
        pageRef.getParameters().put('ids',fileIds);
         pageRef.getParameters().put('type','filelist');
        
        EPMS_ChangeJobTitle chgJobTitle = new  EPMS_ChangeJobTitle();
        chgJobTitle.jobTitleListWrapper[0].checkBool = true;
        chgJobTitle.updateObject();
        //chgJobTitle.updatePOAnkenFiles('Clipping');
                   
        Test.stopTest();
   }         
            
}