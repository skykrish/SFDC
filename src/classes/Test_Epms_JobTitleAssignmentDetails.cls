/**********************************************************************************
*   Class               :       clsTest_EPMS_JobTitleAssignmentDetails            *
*   Created Date        :       15/01/2018                                        *           
*   Description         :       EPMSMS-521 Changes                                * 
*                               Test Class for Web service which is used to send 
JobTitle from Salesforce to Tracker               *
**********************************************************************************/

@isTest
public class Test_Epms_JobTitleAssignmentDetails 
{
    static testMethod void testDoGet(){
        
        Test.startTest();
        Job_Titles__c jobTitle=new Job_Titles__c();
        jobTitle.Name='Clipping';
        insert jobTitle;
        Test.stopTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/JobTitle_Assignments';
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        EPMS_JobTitleAssignmentDetails.doGet();
        list<EPMS_JobTitleAssignmentDetails.bean>  bean = new list<EPMS_JobTitleAssignmentDetails.bean>();
        EPMS_JobTitleAssignmentDetails.JobTitleWrapper  wrapper = new EPMS_JobTitleAssignmentDetails.JobTitleWrapper();  
    }
}