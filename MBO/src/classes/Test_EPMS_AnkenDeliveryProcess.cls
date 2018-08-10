/****************************************************************************************
*   Class Name             :       Test_EPMS_AnkenDeliveryProcess                       *
*   Created Date           :       08/05/2018                                           *
*   Description            :       Test Class for EPMS_AnkenDeliveryProcess             *
****************************************************************************************/
@isTest(seealldata=True)
public class Test_EPMS_AnkenDeliveryProcess {
    
      static testMethod void testDoGet(){
        
        Test.startTest();
          Account acc = new Account();
          acc.name = 'Test';
          insert acc;
          
        Anken__c Anken=new Anken__c();
        Anken.KokyakuName__c = acc.id;
        //Anken.Status__c='New';
        insert Anken;
        Test.stopTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/DeliveryProcess';
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        EPMS_AnkenDeliveryProcess.DeliveryProcessWrapper.getAnkenList();
        list<EPMS_AnkenDeliveryProcess.bean>  bean = new list<EPMS_AnkenDeliveryProcess.bean>();
       //EPMS_AnkenDeliveryProcess.DeliveryProcessWrapper  wrapper = new EPMS_AnkenDeliveryProcess.DeliveryProcessWrapper();  
    }
}