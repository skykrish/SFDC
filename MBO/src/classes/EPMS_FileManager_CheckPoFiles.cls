/**********************************************************************************
*   Class               :       EPMS_FileManager_CheckPoFiles                     *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Webservice for file manager to get all files for 
                                the particular location                           *
**********************************************************************************/
@RestResource(urlMapping='/FileManager/CheckPOFiles/*')
global with sharing class EPMS_FileManager_CheckPoFiles{
    
   // public String returnType {get;set;}  
    
    @HttpPost
    global static void getProductionOrders() {
        JSONGenerator gen = JSON.createGenerator(false);        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String requestType = RestContext.request.params.get('data');
         List<Bean> Files = new List<Bean>();
         List<Bean> Files2 = new List<Bean>();
          List<Bean> Files3 = new List<Bean>();
        CategoryWrapper response = new CategoryWrapper();
        CategoryWrapper response2 = new CategoryWrapper();
         CategoryWrapper response3 = new CategoryWrapper();
        list<Files__c> Filelist = new list<Files__c>();
        list<Files__c> FileImmediate = new list<Files__c>();
        Map<String, CategoryWrapper> ApproveMap = new  Map<String, CategoryWrapper>(); 
        Map<String, CategoryWrapper> ApproveImdMap = new  Map<String, CategoryWrapper>(); 
        Map<String, CategoryWrapper> FinalMap = new  Map<String, CategoryWrapper>(); 
        Map<String,Map<String, CategoryWrapper>> FinalMapwithPOH = new Map<String,Map<String, CategoryWrapper>>();
        String POdownload;
        list<String> POUpload;
        Boolean errorstaus = true;
        Set<String> ProductionID = new Set<String>() ;
        Set<String> FileDetails = new Set<String>() ;
        String PoNoumber;
        string settingsname;
        String returnData;
        string fileId;
        boolean errorstatus;
        EPMS_RestAPIService servObj = new EPMS_RestAPIService(); 
        PoNoumber=servObj.ProductionOrderParser(requestType);
        settingsname = servObj.getsettingsname(requestType);
        fileId=servObj.FileidsParser(requestType);
        
        List<Production_Order__c> Productionrecords = new List<Production_Order__c>();
        String[] OrderNO=null;
         String[] FileNO=null;
        if(requestType.contains('download')){
        
            if(PoNoumber.contains(',') &&  PoNoumber!=NULL){
                OrderNO = PoNoumber.split(',');              
                
            }else{
                OrderNO = PoNoumber.split(',');
            }
        
            if(OrderNO!=null){
                    for(String ResponseID :OrderNO){
                        ProductionID.add(ResponseID);
                    }
                    Productionrecords = servObj.getProductionOrder_ForDownload(ProductionID);
        
                    if(Productionrecords.size() >0){
                        for(Production_Order__c orders:Productionrecords){
                           if(POdownload==NULL){
                               POdownload=orders.Name+',';
                            }else{
                               POdownload=POdownload+orders.Name+',';
                           }                       
                       }
                        POdownload=POdownload.substring(0,POdownload.length()-1);   
                   }
            }
            
            returnData='{"download":{"poNumber":"'+POdownload+'"}}'; 
         RestContext.response.addHeader('Content-Type', 'application/json');
         RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(returnData));  
               
        }else if(requestType.contains('upload')){
            
            if(PoNoumber.contains(',') &&  PoNoumber!=NULL){
                OrderNO = PoNoumber.split(',');
                
            }else{
                OrderNO = PoNoumber.split(',');
            }
             
            if(OrderNO!=null){
                for(String ResponseID :OrderNO){
                   ProductionID.add(ResponseID);
                }
               
                
               Productionrecords= [Select id,Name FROM Production_Order__c where Name IN : ProductionID ];
               POUpload = new list<String>();
                 
               if(Productionrecords.size()>0 ){
                    for(Production_Order__c orders:Productionrecords){
                        
                        POUpload.add(orders.Name);             
                            
                    }            
                  
               }
               }

              list<Production_Order__c> prodstatus = new list<Production_Order__c>();
              prodstatus = [Select id, Name,User__c, Production_Order_Status__c from Production_Order__c where Name IN:POUpload ];
           
              list<Settings__c> settingsusers = new list<Settings__c>();
              settingsusers = [select id,Name,Group_Name__c from Settings__c where Name=:settingsname ];
             
              list<string> finalProductionids = new list<string>();            
              Group Names = new Group();
              Names = [Select id,Name From Group Where Name=:settingsusers[0].Group_Name__c];
            
              list<GroupMember> AllSalesRegion = new list<GroupMember>();
              AllSalesRegion= [Select Id, UserOrGroupId,Group.Name From GroupMember Where GroupId =:Names.id ];
            
              for(Production_Order__c POList : prodstatus)
              {
                  for(GroupMember GM : AllSalesRegion){
                      if(POList.User__c==GM.UserOrGroupId){
                        finalProductionids.add(POList.Name);          
                      }
                  }
              }
          
              list<string> noncompletedOrdes = new list<String>();
               list<string> completedOrdes = new list<String>();
              for(Production_Order__c PS : prodstatus)
              {
                  if(PS.Production_Order_Status__c!='Completed')
                  {               
                  errorstatus= false;
                  noncompletedOrdes.add(PS.Name);
                  }else
                  {
                  errorstatus = true;
                  completedOrdes.add(PS.Name);
                  }
              }
            
              list<String> finalComplete = new list<string>();
              list<Production_order__c> CheckUpload = new list<Production_order__c>();
              list<Files__c> FinalFiles = new list<Files__c>();
              CheckUpload = [Select id,Name From Production_order__c where Name IN :completedOrdes and Production_Order_Status__c='Completed'];
              if(CheckUpload.size()>0)
              for(Production_order__c PH : CheckUpload)
              {
              finalComplete.add(PH.Name);
              }
             
              if(finalComplete.size()>0){

               Filelist = [Select id,Name,File_URL__c,File_Auto_Number__c,Production_order__r.Name,Production_Order_Name__c,filerenamed__c   from Files__c where Production_order__r.Name IN: finalComplete AND Status__c='Approved' AND File_type__c='image' AND FTP_Upload_Status__c=false ORDER BY FileTAT__c ASC   ];
                }        
                
                
            if(noncompletedOrdes.size()>0){  
             FileImmediate = [Select id,Name,File_Auto_Number__c,File_URL__c,Production_order__r.Name,Production_Order_Name__c,filerenamed__c from Files__c where Production_order__r.Name IN: noncompletedOrdes  AND Status__c='Approved' AND  Immediate_File__c=true AND File_type__c='image' AND FTP_Upload_Status__c=false ORDER BY FileTAT__c ASC  ];
                } 
                   
            
            FinalFiles.addall(Filelist);
            FinalFiles.addall(FileImmediate);
            
            
         if(FinalFiles.size()>0)
         {         
          for(Files__c fZ: FinalFiles){
              Files3.add(new Bean(fZ)); 
              response3.FileVar = Files3;   
            }
         }
          
          String POH1 = 'POHierarchy';
          FinalMap.put(POH1,response3);          
                
       
            
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(FinalMap)); 
        
        } else if(requestType.contains('updateFile'))
        {

         if(fileId.contains(',') &&  fileId!=NULL){
                FileNO = fileId.split(',');
                
            }else{
                FileNO = fileId.split(',');
            }
            

            if(FileNO!=null){
                for(String ResponseID :FileNO){
                   FileDetails.add(ResponseID);
                } 
        }               

        List<Files__c> FileUpdate = new List<Files__c>();
        List<Files__c> ExistFiles = new List<Files__c>();
        Set<Id> productionOrderIdSets = new Set<Id>();
        list<string> uploadePO = new list<String>();
        list<Production_order__c> POStatus = new list<Production_order__c>();
        ExistFiles = [Select id,Name,FTP_Upload_Status__c,FTP_Upload_Time__c,Production_Order__c From Files__c where File_Auto_Number__c IN:FileDetails];

        if(ExistFiles.size()>0)
        {
        for(Files__c F : ExistFiles)
        {
        Files__c FS = new Files__C();
        FS.id= F.id;
        FS.FTP_Upload_Status__c=true;
        FS.FTP_Upload_Time__c=System.today();
        FileUpdate.add(FS);
        }
        }
        
         if(ExistFiles.size()>0)
       {
        for(Files__c F : ExistFiles)
            {      
            productionOrderIdSets.add(F.Production_Order__c);       
            }
        }
        
        
        

        string status;
        if(FileUpdate.size()>0)
        {
        Update FileUpdate;
         status = 'Status : Success';
        }else{
         status = 'Status : Failed';
       
        }     
             
        
        if(productionOrderIdSets.size()>0){
        POStatus = [select id,Name,Production_Order_Status__c from Production_order__c where id=:productionOrderIdSets ];
            }
             
               
        if(POStatus.size()>0){          
                for(Production_order__c PO:POStatus){
                        if(PO.Production_Order_Status__c=='Uploaded')
                        {
                         uploadePO.add(PO.Name);                          
                        }               
                }           
            }
            
           string uploadPos = null;
           for(String S : uploadePO)
               {
               if(uploadPos==null){
                   uploadPos=S;
                   }else{                   
                   uploadPos= uploadPos+','+S;
                   }               
               }
            
       
        
        
      RestContext.response.addHeader('Content-Type', 'application/json');
      RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(uploadPos)); 
        
        
     
      
        
      } 
 }
    global class CategoryWrapper {
        public list<Bean> FileVar;
       
        public CategoryWrapper(){
           
        }
    }
   
    global class Bean{
        public  string  fileid = '';
        public  string  OrderId = '';
        public  string  FileURL='';         
        public  string  fileRenamed = '';
        
        Bean(SObject sob){
        this.fileid                 =    (string) sob.get('File_Auto_Number__c');// sending Name as string
        this.OrderId                =    (string) sob.get('Production_Order_Name__c'); // sending Production order as String
        this.FileURL                =    (string) sob.get('File_URL__c');       
        this.fileRenamed            =    (string) sob.get('filerenamed__c');
      }                                                                            
   }
    
}