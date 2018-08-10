@isTest(SeeAlldata=true)
public class Test_EPMS_FileManager_CheckPoOrdersFiles {
    
    static testMethod void  testPostiveDownloadRestService(){
        
         
         //  Profile p2 = [select id from profile where name='Sales Region'];
           
   // User u2= new User(alias = 'user1', email='u2@test.com',
   // emailencodingkey='UTF-8', lastname='Testing78', languagelocalekey='en_US',
   // localesidkey='en_US', profileid = p2.Id,  country='India',Country__c='India', CommunityNickname = 'user2',
   // timezonesidkey='America/Los_Angeles', username='u2123@test.com');           
    
   //insert u2;         
        

        String data = '[{"download":{"poNumber":"00557771"},"requestFor":"statuscheck"}]';
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
    
    static testMethod void  testPostiveUploadRestService(){ 
    
        //   Profile p2 = [select id from profile where name='Sales Region'];
           
   // User u2= new User(alias = 'user1', email='u23456@test.com',
   // emailencodingkey='UTF-8', lastname='Testing78', languagelocalekey='en_US',
   // localesidkey='en_US', profileid = p2.Id,  country='India',Country__c='India', CommunityNickname = 'user2',
   // timezonesidkey='America/Los_Angeles', username='u23456@test.com');           
    
   // insert u2;          
        
      Group ExistedGroup = new Group();
        ExistedGroup = [select id,Name from Group where Name ='Sales Region Japan'];        
                    
  
          List<Settings__c> settingList= new List<Settings__c>();
       settingList = [Select id ,Name,Group_Name__c from Settings__c where Name = 'MBOI-Phase 1']; 
         
        
       
        
        
        String data = '[{"upload":{"poNumber":"00557598","Name":"MBOI-Phase 1"},"requestFor":"statuscheck"}]';
        
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
         
        String data1 = '[{"upload":{"poNumber":"00557598","Name":"MBOI-Phase 1"},"requestFor":"statuscheck"}]';
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
    
    
    static testMethod void  testNegativeUploadRestService(){
   
   
   
     // Profile p2 = [select id from profile where name='Sales Region'];
           
   // User u2= new User(alias = 'user1', email='u298765@test.com',
   // emailencodingkey='UTF-8', lastname='Testing78', languagelocalekey='en_US',
   // localesidkey='en_US', profileid = p2.Id,  country='India',Country__c='India', CommunityNickname = 'user2',
   // timezonesidkey='America/Los_Angeles', username='u289765@test.com');           
   // 
  //  insert u2;     
  
   
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