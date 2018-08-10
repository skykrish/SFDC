/**********************************************************************************
*   Class               :       Test_EPMS_FileAssignmentDetails                   *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_FileAssignmentDetails         *
**********************************************************************************/
@isTest(SeeAllData=true)
public class Test_EPMS_FileAssignmentDetails {
    
    static testMethod void testDoGetPostive() {
        Profile profileQA = [select id from Profile where Name = 'Quality Control' limit 1];
        Profile profileTL = [select id from Profile where Name = 'Team Leader' limit 1];
        //Profile profilePA = [select id from Profile where Name = 'Production Administrator' limit 1];
        List<Member__c> memberQA =[select id,User_Id__c from Member__c where Designation__c='Quality Control' and Status__c='Active' and User_Id__c!=null limit 1];
        //List<Member__c> memberPA =[select id,User_Id__c from Member__c where Designation__c='Production Administrator' and Status__c='Active' and User_Id__c!=null limit 1];
        List<Member__c> memberTL =[select id,User_Id__c from Member__c where Designation__c='Team Leader' and Status__c='Active' and User_Id__c!=null limit 1];
        
        User userQA = [select id from user where isActive=true and  ProfileId=:profileQA.Id and id=:memberQA[0].User_Id__c limit 1 ];
        User userTL = [select id from user where isActive=true and  ProfileId=:profileTL.Id and id=:memberTL[0].User_Id__c limit 1 ];
        //User userPA = [select id from user where isActive=true and  ProfileId=:profilePA.Id and id=:memberPA[0].User_Id__c limit 1 ];
        List<Files__c> fileQAList = new List<Files__c>();
        List<Files__c> filePAList = new List<Files__c>();
        
        Test.startTest();
        
        Location__c location = new Location__c();
        location.Name = 'mbo test-xxxx';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='mbo test-xxxx';
        insert location;
        
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='testPO';
        po.Production_Order_Status__c ='New';
        po.MBO_Location__c=location.Id;
        po.Location_For_Sharing__c=location.Name;
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
        System.debug('--After FC insert--');
        if(memberQA.size()>0){
        System.debug('--Before file Insert--');
        for(integer i=0;i<10;i++){
            Files__c file = new Files__c();
            file.Production_Order__c=po.id;
            file.Name='TestFA'+i;
            file.File_Category_Code__c=fileCategory.id;
            file.Status__c='Assigned';
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
        
        /*if(memberPA.size()>0){
        for(integer i=0;i<15;i++){
            Files__c file = new Files__c();
            file.Production_Order__c=po.id;
            file.Name='TestFA'+i;
            file.File_Category_Code__c=fileCategory.id;
            file.File_Location__c=location.Id;
            file.Status__c='Assigned';
            file.Member__c=memberPA[0].Id;
            file.QCIncharge__c=memberQA[0].Id;
            file.TLInCharge__c=memberTL[0].id;
            file.Current_Extension__c='.jpg';
            file.Files_To_open__c = 1;
            file.File_type__c='image';
            filePAList.add(file);
        }
        insert filePAList;
        }*/       
        
        Test.stopTest();
        if(userQA!=null)
            System.runAs(userQA){
                RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();
                req.requestURI = '/services/apexrest/File_Assignments';
                req.httpMethod = 'GET';
                
                RestContext.request = req;
                RestContext.response = res;
                EPMS_FileAssignMentDetails.doGet();
                list<EPMS_FileAssignMentDetails.bean>  yt = new list<EPMS_FileAssignMentDetails.bean>();
                EPMS_FileAssignMentDetails.CategoryWrapper  tr = new EPMS_FileAssignMentDetails.CategoryWrapper();        
            }   
    }  
}