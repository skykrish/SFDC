/**********************************************************************************
*   Class               :       EPMS_CreateProductionOrder                        *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Controller to create PO from Anken                *
**********************************************************************************/ 

public class EPMS_CreateProductionOrder {
    
    public List<Production_Order__c> prodOrder {get;set;}
    EPMS_ProductionOrderService POService = new EPMS_ProductionOrderService();
    public List<Anken__c>  ank {public get; set;}
    public string fileRecord {get; set;}
    public Production_Order__c po;   
    public Production_Order__c  pord;
    public String selectedLocId {set;get;}
    public List<Production_Order__c> JobList {get;set;}
    public List<String> selectedJobId {public set;public get;}
    public String selectedStatusId{public set;get;}
    public List<SelectOption> LocOptionList;
    public List<SelectOption> jobOptionList;
    public List<Production_Order__c> productionOrderDupli = new List<Production_Order__c>();
    public List<Files__C> FileList = new List<Files__C>();
    public Id userLoggedId {get; set;}
    public List<Files__C> FinalFileList = new List<Files__C>();
    public map<string,Production_Order__c> existingMap = new map<string,Production_Order__c>();
    public map<string,Production_Order__c> statusMap = new map<string,Production_Order__c>();
    public map<string,Production_Order__c> newMap = new map<string,Production_Order__c>();
    public List<string> timeValues = new List<string>();
    public set<Production_Order__c> prodSet {get;set;}
    public Set<String> orderNameSet = new Set<String>();
    public List<id> FileIds = new List<id>();
    public list<Production_Order__c> updateList {get;set;}
    public list<Production_Order__c> finalUpdateList {get;set;}  
    public String[] orderTime;
    public List<string> ProdList = new List<string>();
    public boolean diableButton{public get;set;}
    public list<string> jobnames =new List<string>();
    public boolean errorFlag {get;set;}
    public boolean ErrorflagLocCheck {get;set;}
    public boolean ErrorflagstatusCheck {get;set;}
    public boolean updateButton{get;set;}
    public boolean ErrorflagstatusCheckPEND {get;set;}  
    public integer pOrderSize;
    public List<Production_Order__c> existPOList {get;set;}
    public List<User> currentuser;
    public Job_Titles__c firstJob;
    public string basepath {get;set;}
    public decimal Filecount {get;set;}
    public List<string> reqids = new List<string>();
    
    
    //constructor
    public EPMS_CreateProductionOrder() {
        List<string> jobId = new List<string>();
        updateButton = false;
        ErrorflagLocCheck=true;
        ErrorflagstatusCheck=false;
        ErrorflagstatusCheckPEND=true;
        errorFlag =false;
        existPOList = new List<Production_Order__c>();
        prodSet = new set<Production_Order__c>();
        updateList = new list<Production_Order__c>();
        finalUpdateList = new list<Production_Order__c>();
        prodOrder = new List<Production_Order__c>();
        currentuser=[Select Id,Name,Country__c from User where Id=:userinfo.getuserId()];
        userLoggedId = UserInfo.getUserId();
        string ids = ApexPages.currentPage().getParameters().get('ids');
        basepath = ApexPages.currentPage().getParameters().get('type');
        //List<string> reqids = new List<string>();
        List<string> reqStatus = new  List<string>();
        reqStatus.add('Deleted');
        reqStatus.add('WIP');
        reqStatus.add('Handover');
        reqStatus.add('QCIP');
        reqStatus.add('Completed');
        reqStatus.add('QC');
        reqStatus.add('Redo');
        reqStatus.add('Assigned');
        selectedStatusId=label.EPMS_NewStatus_Order; 
        diableButton = false;
        //Query Job titles to set Clipping is the default job for new production order
        firstJob= [select id,name from Job_Titles__c  where name =:EPMS_UTIL.EPMS_Job_Clipping];
        
        selectedJobId = new List<string>();
        selectedJobId.add(firstJob.id); 
        
        
        for(String key:ids.split(',')){
            reqids.add(key);
        } 
        if(reqids!=null){      
            fileRecord=reqids[0];
        }
        //ank = POService.getAnken(reqids);
        ank = [SELECT id,Name,Status__c,Nouki__c,ItemCnt__c,DateofDelivery_GMT__c ,Nouki_Date__c,Nouki_Time__c, JuchuDateTime__c,NohinDateTime__c,Sagyoshiji_Renrakujiko__c,SagyoNaiyo_1__c,KokyakuName__c, Job_Titles__c FROM Anken__c  WHERE Id = :reqids];
        system.debug('********* reqids : ' + reqids);
        system.debug('********* ank : ' + ank);
        for(Anken__c  an:ank){
            orderNameSet.add(String.valueOf(an.Name));
            timeValues.add(string.valueof(an.Nouki_Time__c));
            Filecount=an.ItemCnt__c;
        }
        system.debug('********* orderNameSet : ' + orderNameSet);
        //Query existing production order      
        existPOList =[select id,Name,Mbo_Location__c,Production_Order_Status__c,Mbo_Location__r.Name from Production_Order__c where Name IN:orderNameSet  Limit 100 ];
        JobList = [select id,name,Job_List__c from Production_Order__c where Name IN:orderNameSet Limit 100];
        
        for(Production_Order__c org123 : existPOList)
        {
            statusMap.put(org123.Production_Order_Status__c, org123);
            for(Production_Order__c org1 : existPOList)
            {
                if(org123.Mbo_Location__c!=org1.Mbo_Location__c)
                {
                    ErrorflagLocCheck=false;   
                }
            }
        }
        for(string stnm : reqStatus){
            if(statusMap.containsKey(stnm)){
                ErrorflagstatusCheck = true;
            }
        }
        
        if(ErrorflagstatusCheck){     
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,Label.EPMS_MBO_CREATE_PO_RECORDS_STATUS_WITH_NEW_PENDING_OR_CANCEL));
        }
        
        if(JobList.size()>0){
            for(Production_Order__c jobs:JobList){      
                if (jobs.Job_List__c != null) {
                    jobnames = jobs.Job_List__c.split(',');
                }          
            }
            
            
            List<Job_Titles__c> jobListId = [select id from Job_Titles__c where Name IN:jobnames];
            for(Job_Titles__c j:jobListId){
                jobId.add(j.Id);
            }
        }
        
        
        if(!existPOList.isEmpty()){
            updateButton = true;
            selectedJobId = new List<string>();
            selectedJobId.addAll(jobId);
            selectedLocId = existPOList[0].Mbo_Location__c;
            if(existPOList.size() > 0 && (existPOList[0].Production_Order_Status__c ==label.EPMS_NewStatus_Order 
                                          || existPOList[0].Production_Order_Status__c ==label.EPMS_PendingStatus_Order|| existPOList[0].Production_Order_Status__c ==label.EPMS_CancelledStatus_Order)){
                                              selectedStatusId = existPOList[0].Production_Order_Status__c;
                                          }  
        }
        
        
    }
    
    //Get locations
    public List<SelectOption> getListOfLocations(){
        List<Location__c> locations = POService.getLocation();
        LocOptionList = new List<SelectOption>();
        LocOptionList.add(new SelectOption('' ,'---Select---'));
        for(Location__c L : locations){
            LocOptionList.add(new SelectOption(L.Id , L.Name));
        }
        return LocOptionList;
    }
    
    //custom picklist for status
    public List<SelectOption> getListOfStatus(){
        List<SelectOption> StatusList = new List<SelectOption>();
        StatusList.add(new SelectOption('New','New'));
        StatusList.add(new SelectOption('Pending','Pending'));    
        StatusList.add(new SelectOption('Estimation Request','Estimation Request')); 
        return StatusList;
    }
    
    //get list of job titles
    public List<SelectOption> getListOfJobs(){
        
        List<Job_Titles__c> jobTitles = [select id,name from Job_Titles__c where id!=:firstJob.id order by name asc];
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new selectOption(firstJob.id,firstJob.name));
        for(Job_Titles__c j:jobTitles){
            options.add(new selectOption(j.id,j.name));
        }
        
        return options;
    }
    
    // insert new production order
    public void saveList(){
        string jobname;
        
        //Anken__c ankenObj = [SELECT id,Name, Job_Titles__c FROM Anken__c  WHERE Id = :reqids];
        //if (ankenObj != null) {
        //    jobname = ankenObj.Job_Titles__c;
        //}
        
        location__c loc=[select id,Name from Location__c where Id=:selectedLocId limit 1];
        //productionOrderDupli = POService.getproductiondub(loc.Id);
        productionOrderDupli = [select id,Name,Mbo_Location__c from Production_Order__c where Name IN:orderNameSet  Limit 50];
        system.debug('--------------poduplicate------------------'+productionOrderDupli);
        /*List<Job_Titles__c> JobM = [select name from Job_Titles__c where id=:selectedJobId];

if(JobM.size()>0){
jobname = JobM[0].name;
}
for(integer i=1;i<JobM.size();i++){
if(JobM.size()>1){
jobname =  JobM[i].name+','+jobname;
}
}*/
        
        for(Anken__c  an:ank){
            if(an.Nouki_Time__c != null){
                orderTime=an.Nouki_Time__c.split(':');
            }
            po = new Production_Order__c();
            po.Name= an.Name; 
            po.Total_Files_Count__c=Filecount;           
            if(selectedStatusId != null){
                po.Production_Order_Status__c  = selectedStatusId;   
            }
            else{
                po.Production_Order_Status__c  = label.EPMS_NewStatus_Order ;
            }
            if(an.Nouki_Time__c != null){
                po.Production_Order_TAT__c = DateTime.newInstance(an.Nouki_Date__c.Year(),an.Nouki_Date__c.Month(),an.Nouki_Date__c.day(), integer.valueof(orderTime[0]),integer.valueof(orderTime[1]), 0);
            }
            po.Anken_Order__c=an.id;
            po.Client_Name__c  = an.KokyakuName__c;
            po.User__c  = currentuser[0].Id;
            //po.Job_List__c = jobname;
            po.Job_List__c = an.Job_Titles__c;
            po.Sales_Region_Country__c=currentuser[0].Country__c;
            if(ErrorflagLocCheck==true){
                po.Mbo_Location__c = selectedLocId;
                po.Location_For_Sharing__c=loc.Name;
                
            }
            if(an.Sagyoshiji_Renrakujiko__c != null){
                po.production_order_instruction__c = an.Sagyoshiji_Renrakujiko__c;
            } else
            {            
                po.production_order_instruction__c ='';
            }            
            prodOrder.add(po);
            
        }
        if(productionOrderDupli.size()>0){
            
            
            for(Production_Order__c po:productionOrderDupli){
                existingMap.put(po.Name, po);
            }
            pOrderSize =prodOrder.size()-1; 
            
            for(integer i=pOrderSize;i>=0;i--){
                if(existingMap.containsKey(prodOrder[i].Name)){
                    updateList.add(existingMap.get(prodOrder[i].Name));
                    prodOrder.remove(i);
                }
            }
            
            
            for(Production_Order__c p:updateList){
                FileIds.add(p.id);
                p.Production_Order_Status__c  = selectedStatusId;
                if(ErrorflagLocCheck==true){
                    p.Mbo_Location__c = selectedLocId;           
                    p.Location_For_Sharing__c=loc.Name;
                    p.Job_List__c = jobname;
                } 
            }
            
            prodSet.addAll(updateList);
            FileList = [select id,name,Status__c from files__c where production_order__c =:FileIds];
            FinalFileList.clear();
            for(Files__C f:FileList){
                if(selectedStatusId == 'Pending' || selectedStatusId == 'New' ) {
                    f.Status__c = selectedStatusId;
                    FinalFileList.add(f); 
                }
                
            }
            
            updateList.clear();
        }
        if(prodOrder.size()>0 && prodOrder!=null){
            if(selectedJobId.isEmpty()){
                errorFlag =true;
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.EPMS_SELECT_JOB_TITLE));  
            }else{
                insert prodOrder;              
                
            }                 
        }
        if(prodSet.size()>0 && prodSet != null){
            finalUpdateList.addAll(prodSet);
            prodSet.clear();           
            update finalUpdateList;
        }
        if(FinalFileList.size()>0 && FinalFileList!= null){
            try{
                
                update FinalFileList;
                // Database.executeBatch(new Epms_Batch_UpdateFileStatusAs_EstReq(FileIds),50);
                FinalFileList.clear();    
            }catch(System.DMLException e){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.EPMS_PO_CREATE_PO_FILES_RELATED_TO_THIS_ORDER_NOT_UPDATED));
                system.debug('File Update exception-------------'+e);
            }
            
        }
        
        prodSet.clear();
        updateList.clear();
        finalUpdateList.clear();
        prodOrder.clear();
        
    }
    
    //insert/update existing production order
    public PageReference save() {
        
        boolean isPOCheck =true;
        Set<String> fields= new Set<String>();
        List<String> locationName= new List<String>();
        errorFlag =false;
        try {
            if(selectedLocId == null ){
                errorFlag =true;
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.EPMS_SELECT_LOCATION));  
                return null;
            }          
            
            else if(existPOList.size()>0){
                for(Production_Order__c existPO: existPOList){
                    fields.add(existPO.Mbo_Location__r.Name);
                }
                locationName.addAll(fields);
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,Label.EPMS_MBO_CREATE_PO_DUPLICATE_ERROR_MSG_1 +String.join(locationName, ', ')+ '.\r\n' +'' +'\r\n '+ Label.EPMS_MBO_CREATE_PO_DUPLICATE_ERROR_MSG_2));   
                existPOList.clear();
            }
            else{
                updateList.clear();
                finalUpdateList.clear();                
                saveList();                
                if(!errorFlag){                    
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.EPMS_POrder_Created));
                    diableButton = true;
                }
            }
            
        } catch(System.DMLException e) {            
            ApexPages.addMessages(e);
            return null;
        }      
        return null;        
    }
}