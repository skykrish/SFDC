/***********************************************************************************
*   Class               :       Test_EPMS_FileManager_CheckPoOrders                *
*   Created Date        :       13/04/2016                                         *           
*   Description         :       Test class for EPMS_FileManager_CheckPoOrders      *
************************************************************************************/


@isTest
public class Test_EPMS_FileManager_CheckPoOrders {
    
    static testMethod void  testPostiveDownloadRestService(){
        
        Location__c location = new Location__c();
        location.Name = 'mbo test-xxxx';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='mbo test-xxxx';
        insert location;
        
        List<Production_Order__c> prodOrderList = new List<Production_Order__c>();
        for(Integer i=1;i<=10;i++) {
            Production_Order__c prodOrder = new Production_Order__c();
            prodOrder.Name = 'PO'+i;
            prodOrder.Production_Order_Status__c = 'New';
            prodOrder.FTP_Upload_Status__c=FALSE;
            prodOrder.MBO_Location__c=location.Id;
            prodOrder.Location_For_Sharing__c=location.Name;            
            prodOrderList.add(prodOrder);
        }
        Production_Order__c prodOrderReupoad = new Production_Order__c();
        prodOrderReupoad.Name = 'PO ReUpload';
        prodOrderReupoad.Production_Order_Status__c = 'New';
        prodOrderReupoad.FTP_Upload_Status__c=FALSE;
        prodOrderReupoad.MBO_Location__c=location.Id;
        prodOrderReupoad.Location_For_Sharing__c=location.Name;
        prodOrderReupoad.ReUpload__c=true;  
        prodOrderList.add(prodOrderReupoad);

        Production_Order__c prodOrderCancelled = new Production_Order__c();
        prodOrderCancelled.Name = 'PO88';
        prodOrderCancelled.Production_Order_Status__c = 'Cancelled';
        prodOrderCancelled.FTP_Upload_Status__c=FALSE;
        prodOrderCancelled.MBO_Location__c=location.Id;
        prodOrderCancelled.Location_For_Sharing__c=location.Name;
        prodOrderCancelled.ReUpload__c=true;  
        prodOrderList.add(prodOrderCancelled);
          
        Production_Order__c prodOrderUpload = new Production_Order__c();
        prodOrderUpload.Name = 'PO82';
        prodOrderUpload.Production_Order_Status__c = 'Uploaded';
        prodOrderUpload.FTP_Upload_Status__c=true;
        prodOrderUpload.MBO_Location__c=location.Id;
        prodOrderUpload.Location_For_Sharing__c=location.Name;
        prodOrderUpload.ReUpload__c=true;             
        prodOrderList.add(prodOrderUpload);
        insert prodOrderList;
        
        Production_Order__c potest = new Production_Order__c();
        potest.Name = 'P188';
        potest.Production_Order_Status__c = 'New';
        potest.FTP_Upload_Status__c=FALSE;
        potest.MBO_Location__c=location.Id;
        potest.Location_For_Sharing__c=location.Name;
        potest.ReUpload__c=false;  
        insert potest;
        
        Files__c newFile = new Files__c();
        newFile.Name ='Handover_FILE_Test';
        newFile.Production_Order__c =potest.id;
        newFile.Status__c ='Assigned';
        newFile.File_Location__c=location.id;
        newFile.Current_Extension__c ='.jpg';
        newFile.File_Type__c = 'Image';   
        newFile.ReUpload__c=true;             
        insert newFile;         
        
        List<String> poName = new List<String>();
        for(Production_Order__c po:prodOrderList)
            poName.add(po.Name);
       
        List<Production_Order__c>  productionOrderList = [Select id,Name,CreatedDate FROM Production_Order__c where Name = : poName AND Production_Order_Status__c='TBI' AND FTP_Upload_Status__c=FALSE AND Production_Order_Status__c!='Cancelled' and Production_Order_Status__c!='Completed' and Production_Order_Status__c!='Uploaded' ];
      
        String data = '[{"download":{"poNumber":"PO1,PO2,PO3,PO4,PO5,PO6,PO7,PO8,PO9,PO10,PO82,PO88"},"requestFor":"statuscheck"}]';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();      
        req.requestURI = '/services/apexrest/FileManager/CheckPO';
        req.httpMethod = 'POST';

        req.addParameter('data',data);
        RestContext.request = req;
        RestContext.response = res;
        
        
        try{
            EPMS_FileManager_CheckPoOrders.getProductionOrders();
        }catch(Exception e){
            System.debug('-------Inside catch');
        }
        
        String data1 = '[{"download":{"poNumber":"PO1"},"requestFor":"statuscheck"}]';
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();
        
        req1.requestURI = '/services/apexrest/FileManager/CheckPO';
        req1.httpMethod = 'POST';

        req1.addParameter('data',data1);
        RestContext.request = req1;
        RestContext.response = res1;
        
        try{
            EPMS_FileManager_CheckPoOrders.getProductionOrders();
        }catch(Exception e){
            System.debug('-------Inside catch');
        }
    }
    
    static testMethod void  testPostiveUploadRestService(){
        
        Location__c location = new Location__c();
        location.Name = 'mbo test-xxxx';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='mbo test-xxxx';
        insert location;
        
        List<Production_Order__c> prodOrderList = new List<Production_Order__c>();
        for(Integer i=1;i<=10;i++) {
            Production_Order__c prodOrder = new Production_Order__c();
            prodOrder.Name = 'PO'+i;
            prodOrder.Production_Order_Status__c = 'Uploaded';
            prodOrder.FTP_Upload_Status__c = false; 
            prodOrder.FTP_Download_Status__c = true;
            prodOrder.MBO_Location__c=location.Id;
            prodOrder.Location_For_Sharing__c=location.Name;
            
            prodOrderList.add(prodOrder);
        }
        Test.startTest();
        insert prodOrderList;
        Test.stopTest();
        system.debug('Inserted Order No :' + prodOrderList);
        List<String> poName = new List<String>();
        for(Production_Order__c po:prodOrderList)
            poName.add(po.Name);
        
        String data = '[{"upload":{"poNumber":"PO1,PO2,PO3,PO4,PO5,PO6,PO7,PO8,PO9,PO10"},"requestFor":"statuscheck"}]';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/FileManager/CheckPO';
        req.httpMethod = 'POST';

        req.addParameter('data',data);
        RestContext.request = req;
        RestContext.response = res;
        
        List<Production_Order__c>  productionOrderList = [Select id,Name FROM Production_Order__c where Name IN : poName AND FTP_Download_Status__c = false AND  Production_Order_Status__c='Uploaded'];
       
        
        try{
            EPMS_FileManager_CheckPoOrders.getProductionOrders();
        }catch(Exception e){
            System.debug('-------Inside catch');
        }
        
        String data1 = '[{"upload":{"poNumber":"PO1"},"requestFor":"statuscheck"}]';
        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();
        
        req1.requestURI = '/services/apexrest/FileManager/CheckPO';
        req1.httpMethod = 'POST';

        req1.addParameter('data',data1);
        RestContext.request = req1;
        RestContext.response = res1;
        
        try{
            EPMS_FileManager_CheckPoOrders.getProductionOrders();
        }catch(Exception e){
            System.debug('-------Inside catch');
        }
    }
    
    
    static testMethod void  testNegativeUploadRestService(){
   
        String data = '[{"upload":{"poNumber":"PO6,PO6,PO6,PO6,PO6,PO6,PO6"},"requestFor":""}]';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/FileManager/CheckPO';
        req.httpMethod = 'POST';

        req.addParameter('data',data);
        RestContext.request = req;
        RestContext.response = res;
        try{
            EPMS_FileManager_CheckPoOrders.getProductionOrders();
        }catch(Exception e){
           
        }
    }
    static testMethod void  testNegativeDownloadRestService(){
   
        String data = '[{"download":{"poNumber":"PO6,PO6,PO6,PO6,PO6,PO6,PO6"},"requestFor":""}]';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();      
        req.requestURI = '/services/apexrest/FileManager/CheckPO';
        req.httpMethod = 'POST';

        req.addParameter('data',data);
        RestContext.request = req;
        RestContext.response = res;
        try{
            EPMS_FileManager_CheckPoOrders.getProductionOrders();
        }catch(Exception e){
            System.debug('-------Inside catch');
        }
    }
}