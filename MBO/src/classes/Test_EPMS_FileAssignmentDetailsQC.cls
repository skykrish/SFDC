/**********************************************************************************
*   Class               :       Test_EPMS_FileAssignmentDetailsQC                 *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_FileAssignmentDetailsQC       *
**********************************************************************************/
@isTest(SeeAllData=true)
public class Test_EPMS_FileAssignmentDetailsQC {
    
    static testMethod void testDoGetPostive() {
        Profile profileQA = [select id from Profile where Name = 'Quality Control' limit 1];
        Profile profileTL = [select id from Profile where Name = 'Team Leader' limit 1];
        Profile profilePA = [select id from Profile where Name = 'Production Administrator' limit 1];
        List<Member__c> memberQA =[select id,User_Id__c from Member__c where Designation__c='Quality Control' and Status__c='Active' and User_Id__c!=null limit 1];
        //List<Member__c> memberPA =[select id,User_Id__c from Member__c where Designation__c='Production Administrator' and Status__c='Active' and User_Id__c!=null limit 1];
        List<Member__c> memberTL =[select id,User_Id__c from Member__c where Designation__c='Team Leader' and Status__c='Active' and User_Id__c!=null limit 1];
        
        User userQA = [select id from user where isActive=true and  ProfileId=:profileQA.Id and id=:memberQA[0].User_Id__c limit 1 ];
        User userTL = [select id from user where isActive=true and  ProfileId=:profileTL.Id and id=:memberTL[0].User_Id__c limit 1 ];
        //User userPA = [select id from user where isActive=true and  ProfileId=:profilePA.Id and id=:memberPA[0].User_Id__c limit 1 ];
        List<Files__c> fileQAList = new List<Files__c>();
        List<Files__c> filePAList = new List<Files__c>();
        
        Test.startTest();
        
        Account acc=new Account(Name='TEST ACC');
        insert acc;
        
        Anken__c ank=new Anken__c(KokyakuName__c=acc.Id,Status__c='Open',Sagyoshiji_Renrakujiko__c='please refer PDF for instructions',
                                  Nouki_Date__c=System.Today());
        insert ank;        
        
        Location__c location = new Location__c();
        location.Name = 'mbo test-xxxx';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='mbo test-xxxx';
        insert location;
        
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='testPO';
        po.Anken_Order__c=ank.id;
        po.Production_Order_Status__c ='TBI';
        po.MBO_Location__c=location.Id;
        po.Production_Order_Status__c = 'QC';	
        po.Location_For_Sharing__c=location.Name;
        po.Production_Order_Status__c='Assigned';
        insert po;
        
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='NewEmail';
        usermail.Email__c='testsubbarao@mbo.in';
        insert usermail;        
        
        
        File_Categories__c fileCategory = new File_Categories__c();
        fileCategory.Name = 'Test';
        fileCategory.Standard_Time_per_File_Min__c=11;
        fileCategory.Standard_Time_per_File_Max__c=20;
        fileCategory.Standard_Regular_Cost_per_File__c=3;
        fileCategory.Standard_OptionalCost_Per_file__c=1;
        insert fileCategory;
        
        if(memberQA.size()>0){
            for(integer i=0;i<10;i++){
                Files__c file = new Files__c();
                file.Production_Order__c=po.id;
                file.Name='TestFA'+i;
                file.File_Category_Code__c=fileCategory.id;
                file.Status__c='QC';
                file.File_Location__c=location.Id;
                file.Member__c=memberQA[0].Id;
                file.QCIncharge__c=memberQA[0].Id;
                file.TLInCharge__c=memberTL[0].id;
                file.Current_Extension__c='.jpg';
                file.Files_To_open__c = 1;
                file.File_type__c='image';
                fileQAList.add(file);
            }
            insert fileQAList;
        }
      
        
        Test.stopTest();
        if(userQA!=null)
        System.runAs(userQA){
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            req.requestURI = '/services/apexrest/File_AssignmentsQC';
            req.httpMethod = 'GET';
            
            RestContext.request = req;
            RestContext.response = res;
            EPMS_FileAssignmentQCDetails.doGet();
            list<EPMS_FileAssignmentQCDetails.bean>  yt = new list<EPMS_FileAssignmentQCDetails.bean>();
            EPMS_FileAssignmentQCDetails.CategoryWrapper  tr = new EPMS_FileAssignmentQCDetails.CategoryWrapper();            
        }
       
    }  
}