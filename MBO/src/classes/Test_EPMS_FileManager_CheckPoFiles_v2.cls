@isTest(SeeAlldata=true)
public class Test_EPMS_FileManager_CheckPoFiles_v2 {
    
    static testMethod void  testPostiveDownloadRestService(){
        
         
        String newOrderName = '';

        List<Member__c> memberList = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Designation__c = 'File Managers' AND Location_id__r.Name = 'MBOI Phase-1'];
        List<Production_Order__c> newOrderList = [SELECT Id, Name, Production_Order_Status__c FROM Production_Order__c WHERE Production_Order_Status__c = 'New' AND Mbo_Location__r.Name = 'MBOI Phase-1'];
        if(newOrderList != null && newOrderList.size() > 0){
            
            for(Production_Order__c order : newOrderList){
                if(order.Production_Order_Status__c == 'New'){
                    newOrderName = order.Name;
                    break;
                }
            }
            
            system.debug('[New]       Order Name : ' +newOrderName);
            
        }
        
        User user;
        if(memberList != null && memberList.size() > 0){
            user = [SELECT Id, Name FROM User WHERE Id =: memberList[0].User_Id__c];
        }
        system.debug('User Details : ' + user);
        System.runAs(user){
            //String data = '[{"download":{"poNumber":"00557771"},"requestFor":"statuscheck"}]';
            String data = '[{"download":{"poNumber":"'+newOrderName+'"},"requestFor":"statuscheck"}]';
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();      
            req.requestURI = '/services/apexrest/FileManager/CheckPOFiles';
            req.httpMethod = 'POST';

            req.addParameter('data',data);
            RestContext.request = req;
            RestContext.response = res;
            
            
            try{
                EPMS_FileManager_CheckPoFiles.getProductionOrders();
            }catch(Exception e){
                System.debug('-------Inside catch');
            }
        }
        
        
        
        
  
    }
    
    static testMethod void  testPostiveUploadRestService(){ 
    
        List<Member__c> memberList = [SELECT Id, Name, User_Id__c FROM Member__c WHERE Designation__c = 'File Managers' AND Location_id__r.Name = 'MBOI Phase-1'];
        Group ExistedGroup = new Group();
        ExistedGroup = [select id,Name from Group where Name ='Sales Region Japan'];        

        List<Settings__c> settingList= new List<Settings__c>();
        settingList = [Select id ,Name,Group_Name__c from Settings__c where Name = 'MBOI-Phase 1']; 
        
        String completedOrderName = '';
        String wipOrderName = '';
        List<Production_Order__c> newOrderList = [SELECT Id, Name, Production_Order_Status__c FROM Production_Order__c WHERE Production_Order_Status__c = 'Completed' AND Mbo_Location__r.Name = 'MBOI Phase-1'];
        if(newOrderList != null && newOrderList.size() > 0){
            
            for(Production_Order__c order : newOrderList){
                if(order.Production_Order_Status__c == 'Completed'){
                    completedOrderName = order.Name;
                    break;
                }
            }
            system.debug('[Completed] Order Name : ' +completedOrderName);
            
        } 
        
        List<Production_Order__c> newOrderList2 = [SELECT Id, Name, Production_Order_Status__c FROM Production_Order__c WHERE (Production_Order_Status__c = 'WIP' OR Production_Order_Status__c = 'QCIP') AND Mbo_Location__r.Name = 'MBOI Phase-1'];
        if(newOrderList2 != null && newOrderList2.size() > 0){
            
            for(Production_Order__c order : newOrderList2){
                    wipOrderName = order.Name;
                    break;
            }
            system.debug('[WIP] Order Name : ' +wipOrderName);
            
        } 
        
        User user;
        if(memberList != null && memberList.size() > 0){
            user = [SELECT Id, Name FROM User WHERE Id =: memberList[0].User_Id__c];
        }
        system.debug('User Details : 2' + user);
        System.runAs(user){
            //String data = '[{"upload":{"poNumber":"00557598","Name":"MBOI-Phase 1"},"requestFor":"statuscheck"}]';
            //Live:MBOI-Phase 1
            //String data = '[{"upload":{"poNumber":"'+completedOrderName+'","Name":"MBOI-Phase 1"},"requestFor":"statuscheck"}]';
            //Full : MBOI-PH1-SRMTEST
            String data = '[{"upload":{"poNumber":"'+completedOrderName+'","Name":"MBOI-Phase 1"},"requestFor":"statuscheck"}]';
           
            RestRequest req = new RestRequest(); 
            RestResponse res = new RestResponse();
            
            req.requestURI = '/services/apexrest/FileManager/CheckPOFiles';
            req.httpMethod = 'POST';

            req.addParameter('data',data);
            RestContext.request = req;
            RestContext.response = res;
            
          //  List<Production_Order__c>  productionOrderList = [Select id,Name FROM Production_Order__c where Name IN : poName AND FTP_Upload_Status__c = false AND  Production_Order_Status__c='Completed'];
           // System.debug('-----POList'+productionOrderList);
            
            try{
                EPMS_FileManager_CheckPoFiles.getProductionOrders();
            }catch(Exception e){
                System.debug('-------Inside catch');
            }
             
            //String data1 = '[{"upload":{"poNumber":"00557598","Name":"MBOI-Phase 1"},"requestFor":"statuscheck"}]';
            //Live:MBOI-Phase 1
            //String data = '[{"upload":{"poNumber":"'+completedOrderName+'","Name":"MBOI-Phase 1"},"requestFor":"statuscheck"}]';
            //Full : MBOI-PH1-SRMTEST
            String data1 = '[{"upload":{"poNumber":"'+wipOrderName+'","Name":"MBOI-Phase 1"},"requestFor":"statuscheck"}]';
            RestRequest req1 = new RestRequest(); 
            RestResponse res1 = new RestResponse();
            
            req1.requestURI = '/services/apexrest/FileManager/CheckPOFiles';
            req1.httpMethod = 'POST';

            req1.addParameter('data',data1);
            RestContext.request = req1;
            RestContext.response = res1;
            
            try{
                EPMS_FileManager_CheckPoFiles.getProductionOrders();
            }catch(Exception e){
                System.debug('-------Inside catch');
            }
        
        }
    }
    
    
    static testMethod void  testNegativeUploadRestService(){
   
   
   
        String data ='[[{"updateFile":{"fileId":"F0000014188,F0000014189"},"requestFor":"statusupdate"}]]';
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/FileManager/CheckPOFiles';
        req.httpMethod = 'POST';

        req.addParameter('data',data);
        RestContext.request = req;
        RestContext.response = res;
        try{
            EPMS_FileManager_CheckPoFiles.getProductionOrders();
        }catch(Exception e){
            System.debug('-------Inside catch');
        }
    }
    
}