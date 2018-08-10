/**********************************************************************************
*   Class               :       Test_MistakeAssignment_Details                    *
*   Created Date        :       17/01/2018                                        *           
*   Description         :       EPMSMS-522 Changes                                * 
*                               Test Class for Web service which is used to send 
								Mistake Details from Salesforce to Tracker        *
**********************************************************************************/
@isTest (seeAllData=true)
public with sharing class Test_MistakeAssignment_Details {
    static testMethod void testDoGetPostive() {
        Profile profileQA = [select id from Profile where Name = 'Quality Control' limit 1];
        
        List<Member__c> memberQA =[select id,User_Id__c from Member__c where Designation__c='Quality Control' and Status__c='Active' and User_Id__c!=null limit 1];
        
        User userQA = [select id from user where isActive=true and  ProfileId=:profileQA.Id and id=:memberQA[0].User_Id__c limit 1 ];
        
        Test.startTest();
        
        Location__c location = new Location__c();
        location.Name = 'mbo test-xxxx';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='mbo test-xxxx';
        insert location;
        
        UserEmail__c usermail=new UserEmail__c();
        usermail.Name='NewEmail';
        usermail.Email__c='testsubbarao@mbo.in';
        insert usermail; 
        
        Mistakes__c mistake=new Mistakes__c();
        mistake.Location__c=location.Id;
        mistake.Mistake__c='HOLES REMAINING';
        mistake.MIstake_Category__c='COMMON MISTAKES';
        mistake.Penalty_for_Artist__c=25;
        mistake.Penalty_for_QC__c=35;
        mistake.Skip_Penalty_Flag__c =True;
        insert mistake;		
        
        Test.stopTest();
        
        if(userQA!=null)
            System.runAs(userQA){        
                RestRequest req = new RestRequest(); 
                RestResponse res = new RestResponse();
                req.requestURI = '/services/apexrest/MistakeAssignment_Details';
                req.httpMethod = 'GET';
                
                RestContext.request = req;
                RestContext.response = res;
                MistakeAssignment_Details.doGet();
                
                list<MistakeAssignment_Details.bean>  bean = new list<MistakeAssignment_Details.bean>();
                MistakeAssignment_Details.CategoryWrapper  wrapper = new MistakeAssignment_Details.CategoryWrapper();
                
            }        
    }
}