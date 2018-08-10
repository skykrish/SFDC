/************************************************************************************
*   Class               :       Test_EPMS_AssignJobTitle                            *
*   Created Date        :       2/12/2017                                           *           
*   Description         :       Test class for EPMS_ChangeJobTitle                  *
************************************************************************************/
@istest
public class Test_EPMS_AssignJobTitle {

    public static testMethod void AssignJobTitle_test() {

        Account acc=new Account(Name='TEST ACC');
        insert acc;
        
        Anken__c ank=new Anken__c();
        ank.KokyakuName__c=acc.Id;
        ank.Status__c='Open';
        ank.Sagyoshiji_Renrakujiko__c='please refer PDF for instructions';
        //ank.Job_Titles__c = 'Cropping,Cliping';
        ank.Nouki_Date__c=System.Today();
        insert ank;
   
        PageReference pageRef = Page.EPMS_AssignJobTitle;
   
        List<Anken__c> ankenList = [select id,Name,Job_Titles__c from Anken__c where Id =:ank.Id];
       
        String ankenId = '';
        for(Anken__c newAnken : ankenList){
            if(ankenId == ''){
                ankenId = newAnken.Id; 
            } else {
                ankenId += ',' + newAnken.Id;
            }
        }
        Test.StartTest();
        
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',ankenId);
         
        EPMS_AssignJobTitle assignJobTitle = new  EPMS_AssignJobTitle();   
        Test.stopTest();
   }
   
   
    public static testMethod void AssignJobTitle_Update_test() {
   
        Account acc = new Account(Name='TEST ACC');
        insert acc;
        
        Anken__c anken = new Anken__c();
        anken.KokyakuName__c=acc.Id;
        anken.Status__c='Open';
        anken.Sagyoshiji_Renrakujiko__c='please refer PDF for instructions';
        anken.Job_Titles__c = 'Cropping,Clipping'; 
        anken.Nouki_Date__c=System.Today();
        insert anken;
        
        Job_Titles__c jobNames = new Job_Titles__c();
        jobNames.Name = 'Cropping,Clipping,Soft Mask';
        insert jobNames;

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
        insert po;
        
        Files__c file = new Files__c();
        file.Name ='Testfile_1001';
        file.Production_Order__c =po.id;
        file.Status__c ='New';
        file.File_Location__c=location.id;
        file.Current_Extension__c ='.jpg';
        file.File_Type__c = 'Image';
        file.File_Job_Titles__c = 'Clipping,Cropping';
        insert file;         
   
        PageReference pageRef = Page.EPMS_AssignJobTitle;
   
        List<Anken__c> ankenList = [select id,Name,Job_Titles__c from Anken__c where Id =:anken.Id];
       
        String ankenId = '';
        for(Anken__c newAnken : ankenList){
            if(ankenId == ''){
                ankenId = newAnken.Id; 
            } else {
                ankenId += ',' + newAnken.Id;
            }
        }
           
        Test.StartTest();
        
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',ankenId);
         
        EPMS_AssignJobTitle assignJobTitle = new  EPMS_AssignJobTitle();   
        assignJobTitle.jobTitleListWrapper[0].isSelected = true;
        //assignJobTitle.jobTitleListWrapper[0].isSelected = true;
        assignJobTitle.saveObject();

        Test.stopTest();

   }   
}