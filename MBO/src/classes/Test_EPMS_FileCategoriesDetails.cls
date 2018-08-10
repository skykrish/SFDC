/**********************************************************************************
*   Class               :       Test_EPMS_FileCategoriesDetails                   *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_FileCategoriesDetails         *
**********************************************************************************/
@isTest(SeeAllData=true)
private class Test_EPMS_FileCategoriesDetails {
    
    static testMethod void testPositive() {
      
        Profile profileQC = [select id from Profile where Name = 'Quality Control' limit 1];
        List<Member__c> memberQC =[select id,User_Id__c,Performance_Rating__c,Performance_Rating__r.Name from Member__c where Designation__c='Quality Control' and Status__c='Active' and User_Id__c!=null And Performance_Rating__c!=null limit 1];

        User userQC = [select id,email from user where isActive=true and  ProfileId=:profileQC.Id and id=:memberQC[0].User_Id__c limit 1 ];  

        List<File_Categories__c> fileCategoryList= new List<File_Categories__c>();
        for(Integer i=0; i<10;i++){
            File_Categories__c filecategory = new File_Categories__c(Name='Test'+i,Standard_Time_per_File_Min__c=i,Standard_Time_per_File_Max__c=i+1);
            fileCategoryList.add(filecategory);
        }

        Test.startTest();
        insert fileCategoryList;
        Test.stopTest(); 
        if(userQC!=null){
            system.runas(userQC){
                RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();

                req.requestURI = 'https://ap3.salesforce.com/services/apexrest/File_Categories';  
                req.httpMethod = 'GET';
                RestContext.request = req;
                RestContext.response = res;
                EPMS_FileCategoriesDetails ps = new EPMS_FileCategoriesDetails();

                List<EPMS_FileCategoriesDetails.bean> results = EPMS_FileCategoriesDetails.doGet();
               // System.assert(results!=null);
            }
        }
  }
  
    static testMethod void testNegative() {
        Profile profileQC = [select id from Profile where Name = 'Quality Control' limit 1];
        List<Member__c> memberQC1 =[select id,User_Id__c,Performance_Rating__c,Performance_Rating__r.Name from Member__c where Designation__c='Quality Control' and Status__c='Active' and User_Id__c!=null And Performance_Rating__c!=null  limit 1];
        User userQC1 = [select id,email from user where isActive=true and  ProfileId=:profileQC.Id and id=:memberQC1[0].User_Id__c limit 1 ];  

        system.runas(userQC1){
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();

            req.requestURI = 'https://ap3.salesforce.com/services/apexrest/File_Categories'; 
            req.httpMethod = 'GET';
            RestContext.request = req;
            RestContext.response = res;
            EPMS_FileCategoriesDetails Nt = new EPMS_FileCategoriesDetails();
            EPMS_FileCategoriesDetails.doGet();
            
             
            
            //System.assert(results==null);

       }
    } 
    
    
    
    
    
    
    
    
}