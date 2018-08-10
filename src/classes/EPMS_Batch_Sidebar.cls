public class EPMS_Batch_Sidebar {

    string currentJobid{get; set;}
    string currentOrderid{get;set;}
    string currentJobStatus{get;set;}
    string isJobCompleted{get;set;}

    public Map<id,List<string>> batchInfoMap {get;set;}
    public List<AsyncApexJob> a {get;set;}
    public Batch_Track__c batchDetails {get;set;}
    public List<BatchTrackWrapper> wrapperList {get;set;}
    public EPMS_Batch_Sidebar(){
        
        a = null;
        wrapperList = new List<BatchTrackWrapper>();
        try{
                
            batchInfoMap = new Map<Id, List<String>>();
            a = [Select Id, Status, CreatedDate,CompletedDate, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email, ExtendedStatus
            from AsyncApexJob where (Status = 'Processing' OR Status = 'Completed') AND CreatedDate = TODAY ORDER BY CreatedDate DESC ]; 
            //AND CreatedBy.id =: UserInfo.getUserId()
            //OR CreatedDate =: system.today().addDays(-1))
            if(a!= null && a.size() > 0){
                for(AsyncApexJob currentJob : a){
                    batchDetails = Batch_Track__c.getValues(currentJob.id);
                    system.debug('----------------batchDetails-----------'+batchDetails);
            
                    system.debug('batchInfoMap Values :' + batchInfoMap.values());
                    if(batchDetails != null){
                        BatchTrackWrapper newRecord = new BatchTrackWrapper(batchDetails.Order_Name__c,currentJob.Status,currentJob.TotalJobItems,currentJob.JobItemsProcessed,currentJob.CreatedDate,currentJob.CompletedDate,batchDetails.Name__c);
                        wrapperList.add(newRecord);
                    }
                }

            }
            
            system.debug('----------------batchDetails-----------'+batchDetails);
            system.debug('----------------wrapperList-----------'+wrapperList);


        }catch(exception e){
            system.debug('---------No OrdersFound--------------');
        }
             
        if(a != null){
          system.debug('---------A--------------'+a);
            
        }

    }
    
     public void getCurrentJob(){
        system.debug('---------Poller Method called-------');
        wrapperList = new List<BatchTrackWrapper>();
        a = null;
        try{
            a = [Select Id, Status, NumberOfErrors,CompletedDate, CreatedDate, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email, ExtendedStatus
            from AsyncApexJob where (Status = 'Processing' OR Status = 'Completed') AND CreatedDate = TODAY ORDER BY CreatedDate DESC]; 
            // AND CreatedBy.id =: UserInfo.getUserId()
            //OR CreatedDate =: system.today().addDays(-1)
            // CreatedDate = LAST_N_DAYS:1
            if(a != null){
                for(AsyncApexJob currentJob : a){
                    batchDetails = Batch_Track__c.getValues(currentJob.id);
                    system.debug('----------------batchDetails-----------'+batchDetails);
                    List<String> batchInfo = new List<String>();
                    String orderName = '';
                    if(batchDetails != null){
                        orderName = batchDetails.Order_Name__c;
                    }
                    system.debug('batchInfoMap Values :' + batchInfoMap.values());
                    if(orderName != ''){
                        BatchTrackWrapper newRecord = new BatchTrackWrapper(orderName,currentJob.Status,currentJob.TotalJobItems,currentJob.JobItemsProcessed,currentJob.CreatedDate,currentJob.CompletedDate,batchDetails.Name__c);
                        wrapperList.add(newRecord);
                    }
                }
            }   
        }catch(exception e){
          system.debug('---------No OrdersFound--------------'+e);
        }
        system.debug('----------------wrapperList-------ACTION POLLER----'+wrapperList);     
        system.debug('---------A--------------'+a);
            
        

    }

    public class BatchTrackWrapper{
        
        public string orderName {get;set;}
        public string batchStatus {get;set;}
        public Integer totalJobItems {get;set;}
        public Integer jobItemsProcessed {get;set;}
        public Datetime createdDate {get;set;}
        public Datetime completionDate {get;set;}
        public String jobType {get;set;}
        
        public BatchTrackWrapper(String oName, String status, Integer totalJob, Integer compeletedJob,Datetime cdate, Datetime ccdate, String typeOfJob){
            orderName = oName;
            batchStatus = status;
            totalJobItems = totalJob;
            jobItemsProcessed = compeletedJob;
            createdDate = cdate;
            completionDate = ccdate;
            jobType = typeOfJob;
        }
        
    }
}