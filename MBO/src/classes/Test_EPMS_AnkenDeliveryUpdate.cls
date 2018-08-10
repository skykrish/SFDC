/****************************************************************************************
*   Class Name             :       Test_EPMS_AnkenDeliveryUpdate                        *
*   Created Date           :       08/05/2018                                           *
*   Description            :       Test Class for EPMS_AnkenDeliveryUpdate              *
****************************************************************************************/
@istest
public class Test_EPMS_AnkenDeliveryUpdate {
    
    static testMethod void testupdateDeliveryStatus(){
        
        Test.startTest();        
        
        Account acc = new Account();
        acc.name = 'Test';
        insert acc;
        
        Anken__c ank=new Anken__c();
        ank.KokyakuName__c = acc.id;
        ank.Delivered_File_Count__c = 75;
        ank.Remaining_Files_Count__c = 0;
        ank.Total_Files_Count__c = 75;
        ank.Delivery_Start_Time__c = '20180510130800';
        ank.Delivery_End_Time__c = '20180510130820';
        ank.Delivery_Time_Difference__c = '00:00:10';        
        ank.Status__c='受注納品';
        
        insert ank;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/DeliveryUpdate';
        req.addParameter('type','');
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'post';
        res.addHeader('Content-Type', 'application/json');
        RestContext.request = req;
        RestContext.response = res;
        
        Anken__c anken = [select Id, Name from Anken__c where KokyakuName__c =: acc.id];
        String ankName = anken.Name;
        
        List<String> FailedFiles=new List<String>();
        FailedFiles.add('File1');
        FailedFiles.add('File2');
        
        EPMS_AnkenDeliveryUpdate.updateAnkenStatus('20180511241','50','10','60','60','20180516254','25', ankName, 'Delivered',FailedFiles,'50','500','100');
        
        Test.stopTest();
    }
}