global class Epms_Batch_UpdateFileStatusAs_EstReq implements Database.Batchable<SObject>{ 
 
    
    global List<Id> POList=new List<Id>(); 
    global String query;
    global list<Production_Order__c> poestRecords=new list<Production_Order__c>();
   
   
    global Epms_Batch_UpdateFileStatusAs_EstReq(list<Id> PORecords) {  
    
    
    system.debug('-----------Constructor----');
     system.debug('-----------PORecords----'+PORecords);
     
     POList.addAll(PORecords);
    
 /*   poestRecords.addAll(PORecords);
    
    
  
    for(Production_Order__c po:poestRecords){
    system.debug('------poid----'+po.id);
    POList.add(po.id);
      system.debug('------POList----'+POList);
    } */
    
  
    
    
    
    
        
        system.debug('------poid-----'+POList);
        query='Select id,Name,Status__c,Production_Order__c from Files__c where Production_Order__c =:POList';
    }  
    global Database.queryLocator start(Database.BatchableContext BC){
         system.debug('-----startbatch----');
          return Database.getQueryLocator(query); 
    }
    
    global void execute(Database.BatchableContext info, List<Files__c> FilesList){
    
     system.debug('-----executebatch-----');
        
        List<Files__c> UpdatedFilelist = new List<Files__c>(); 
        for(Files__c f: FilesList)  
        {  
            f.status__c =  Label.EPMS_FileStatus_Estimation_Request;
          //  f.status__c =  'Estimator Assigned';
                    
                    UpdatedFilelist.add(f);
        }  
        
        system.debug('-------UpdatedFilelist-----'+UpdatedFilelist.size());
        
        update UpdatedFilelist;
        
    }
    global void finish(Database.BatchableContext ctx){
    
    }
    }