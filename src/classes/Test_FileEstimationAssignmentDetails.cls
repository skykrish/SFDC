/**********************************************************************************
*   Class               :       Test_FileEstimationAssignmentDetails                   *
*   Created Date        :       11/01/2018                                               *
*   Description         :       Test Class for EPMS_FileEstimationAssignmentDetails     *
**********************************************************************************/
@isTest(SeeAllData=true)
private class Test_FileEstimationAssignmentDetails {
    
    static testMethod void testDoGet1() {
        Profile profileQA = [select id from Profile where Name = 'Quality Control' limit 1];
        List<Member__c> memberQA =[select id,User_Id__c from Member__c where Designation__c='Quality Control' and Status__c='Active' and Is_Estimator__c = true and User_Id__c!=null limit 1];
       
        User userQA = [select id from user where isActive=true and  ProfileId=:profileQA.Id and id=:memberQA[0].User_Id__c limit 1 ];
        
        List<Files__c> fileQAList = new List<Files__c>();
        Test.startTest();
        
        Account acc=new Account(Name='TEST ACC');
        insert acc;

        Anken__c anken=new Anken__c();
        anken.KokyakuName__c=acc.Id;
        anken.Status__c='Open';
        anken.Sagyoshiji_Renrakujiko__c='please refer PDF for instructions';
        anken.Nouki_Date__c=System.Today();
        insert anken;
        
        
        Location__c location = new Location__c();
        location.Name = 'mbo test-xxxx';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='mbo test-xxxx';
        insert location;
        
        Member__c member =new Member__c();
        member.Name='MARK';     
        member.Location_id__c=location.id;
        member.Last_Name__c='PHILIPS';
        member.Email__c='testphotoartists121200@gmail.com';
        member.Country__c='India';
        member.Designation__c='Quality Control';
        member.Is_Estimator__c = true;
        member.Status__c='Active';
        insert member;         
        
        Production_Order__c po=new Production_Order__c();
        po.Name ='testPO';
        po.Anken_Order__c = anken.Id;
        po.Production_Order_Status__c ='Estimation Request';
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
        
        if(memberQA.size()>0){
            for(integer i=0;i<10;i++){
                Files__c file = new Files__c();
                file.Production_Order__c=po.id;
                file.Name='TestFA'+i;
                file.File_Category_Code__c=fileCategory.id;
                file.Status__c='Estimator Assigned';
                file.File_Location__c=location.Id;
                //file.Member__c=memberQA[0].Id;
                //file.QCIncharge__c=memberQA[0].Id;
                file.Current_Extension__c='.jpg';
                file.Files_To_open__c = 1;
                file.File_type__c='image';
                file.Estimator__c = memberQA[0].id;
                fileQAList.add(file);
            }
            insert fileQAList;
        }
        
        Test.stopTest();
        if(userQA!=null)
            System.runAs(userQA){
                RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();
                req.requestURI = '/services/apexrest/File_AssignmentsEstimation';
                req.httpMethod = 'GET';
                
                RestContext.request = req;
                RestContext.response = res;
                EPMS_FileEstimationAssignmentDetails.doGet();
                list<EPMS_FileEstimationAssignmentDetails.bean>  yt = new list<EPMS_FileEstimationAssignmentDetails.bean>();
                EPMS_FileEstimationAssignmentDetails.CategoryWrapper  tr = new EPMS_FileEstimationAssignmentDetails.CategoryWrapper();            
            }
        
    }
}