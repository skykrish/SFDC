/****************************************************************************
*   Class               :       EPMS_ChangeTLController                     *
*   Created Date        :       31/07/2016                                  *           
*   Description         :       Controller for change TL for Order          *
/***************************************************************************/ 
public with sharing class EPMS_ChangeTLController {

        public ApexPages.StandardController c;
        public SelectOption[] shiftNames{get;set;}
        public SelectOption[] teamNames{get;set;} 
        public SelectOption[] TLNames{get;set;}
        public  list<Member__c> qc = new list<member__c>();
        public list<Production_order__c> ploccheck = new list<Production_order__c>();
        public List<Team__c> teamNameList {get;set;}
        public List<Shift_Assignments__c> teamIdList= null;
        public List<Shift__c> shiftList = new List<Shift__c>();
        public EPMS_ProductionOrder_Query_Locator queryloc = new EPMS_ProductionOrder_Query_Locator();
       
        public  List<string> reqids = new List<string>();
        public Set<Id> teamIds = new Set<Id>();
        public Set<Id> MemteamIds = new Set<Id>();
        public String selShift{get;set;}
        public String selTeam{get;set;}
        public list<member__c> memlist = new  list<member__c>();
        public String selTL{get;set;} 
        public string basepath {get;set;}       
        public String userCurrentShift {get;set;}       
        public String userCurrentTeam {get;set;}        
        public List<Profile> profilelist {get;set;}     
        public string userProfileName {get;set;}    
        public Id batchProcessId {get;set;}    
        public String batchStatus {get;set;}
        public boolean isBulkUpdate {get;set;}
        public boolean isSubmitted {get;set;}
        // Shift Assignment service      
        EPMS_Shift_Assignment_Service_New shiftService = new EPMS_Shift_Assignment_Service_New();       
        // File Operator Assignment service (For Getting Current Shift and Current Team)        
        EPMS_FileOperatorAssignmentService fileService = new EPMS_FileOperatorAssignmentService();      

    //constructor    
    public EPMS_ChangeTLController(ApexPages.StandardController stdController){
    
        basepath = ApexPages.currentPage().getParameters().get('base');             
        teamNameList = new List<Team__c>();     
        teamNames = new SelectOption[]{};       
        teamIdList = new List<Shift_Assignments__c>();
        EPMS_CheckRecursive.FileStatusTrigger = false;
        EPMS_CheckRecursive.fileBasedFolderTrigger = false;
        isBulkUpdate = false;    
        isSubmitted = true;    
        string ids = ApexPages.currentPage().getParameters().get('ids');
        if(ids != null){
            for(String key:ids.split(',')){
                reqids.add(key);
            }
        }
                   
        ploccheck = queryloc.getPOCheck(reqids);     
        system.debug('Production Order Info : ' + ploccheck);
        if(reqids!= null){
            shiftNames= new SelectOption[0];
            if(ploccheck != null && ploccheck.size() > 0){
                shiftList = queryloc.getShift(ploccheck[0].Mbo_location__c);
            }
            shiftNames.add(new SelectOption('', 'Select Shift')); 
            if(shiftList != null && shiftList.size() > 0){
                for(Shift__c shiftObj : shiftList) {
                    shiftNames.add(new SelectOption(shiftObj.Id, shiftObj.Name));
                }
            }
                
        }
        
 
        profilelist  = shiftService.getProfiles();      
        if(profilelist != null && profilelist.size() > 0){     
            userProfileName = profilelist[0].Name;      
        }       
        system.debug('Logged User => Profile Name : ' + userProfileName);
        Shift_Assignments__c shiftInfo = null;
        if(userProfileName != 'System Administrator' && userProfileName != 'Production Administrator' && userProfileName != 'Country Administrator'){
            try{
                Member__c userMemberInfo = fileService.getLoggedMemberInformation();        
                if(userMemberInfo != null){     
                    shiftInfo = fileService.getLoggedMemberShiftAssignmentInformation(userMemberInfo.Id);      
                    if(shiftInfo != null){      
                        userCurrentShift = shiftInfo.Shift_Code__c;     
                        userCurrentTeam = userMemberInfo.Team_Id__c;        
                    }       
                }
            } catch(Exception e){
                system.debug('[ERROR] Exception throws during retrieve the User Shift Information : ' + e.getMessage());
            }

        }       
                    
            if(userCurrentShift != null){       
                selShift = userCurrentShift;        
            }       
            changeShift();      
            if(userCurrentTeam != null){        
                selTeam = userCurrentTeam;      
            }       
            changeTeam(); 
            if(shiftInfo != null){
                selTL = shiftInfo.Member__c;       
            }  
        
    }
    
    //getting current shift members based on production order location
           
    public PageReference changeShift(){
        
        if(teamNameList != null && teamNameList.size() > 0){        
            teamNameList = new List<Team__c>();     
            teamNames = new SelectOption[]{};       
            TLNames =  new SelectOption[]{};        
            teamIdList = new List<Shift_Assignments__c>();      
            teamIds = new Set<Id>();        
            MemteamIds = new Set<Id>();     
        }
    
        teamNames= new SelectOption[0];
        teamNames.add(new SelectOption('', 'Select Team'));
        if(selShift != null){
            teamIdList = queryloc.getShiftMemberlist(selShift);        }
        
        
        if(teamIdList != null && teamIdList.size() > 0){                
        for(Shift_Assignments__c memberObj : teamIdList){       
               teamIds.add(memberObj.Member__C);        
            }       
        }
        
        
        list<member__c> memTeam = new list<Member__c>();
        memTeam = queryloc.getteammembers(teamIds,ploccheck[0].Mbo_location__c);
        
        
        if(memTeam != null && memTeam.size() > 0){              
            for(Member__c teams:memTeam)                   
            {                   
                if(teams.Team_id__c != null){       
                    MemteamIds.add(teams.Team_id__c);       
                }       
                        
            }       
        }       
                
       
        teamNameList  = queryloc.getTeam(MemteamIds,ploccheck[0].Mbo_location__c);
        if(teamNameList != null && teamNameList.size() > 0){
        for(Team__c teamObj : teamNameList){
           teamNames.add(new SelectOption(teamObj.id, teamObj.Name));        
        }
          
    }
     return null; 
    }
    
    
    //getting TL for the current team
    public void changeTeam(){
    
        TLNames= new SelectOption[0];
        TLNames.add(new SelectOption('', 'Select TL'));        
        if(selTeam != null){
            memlist = queryloc.getmembersTL(selTeam,ploccheck[0].Mbo_location__c); 
        }
        
        for(member__c qcObj : memlist ){
        if(qcObj.Performance_Rating__r.Name==null){
         TLNames.add(new SelectOption(qcObj.id, qcObj.Name));
        
        }
        else{
            TLNames.add(new SelectOption(qcObj.id, qcObj.Name+'-'+qcObj.Performance_Rating__r.Name));        
        }
        }
    }
    
      
    //update/Save TL 
    public PageReference saveChanges(){
       List<Production_order__c> OrderList = new List<Production_order__c>();
       List<Production_order__c> UpdateOList = new List<Production_order__c>();
       List<Files__c> OrderFilesList = new List<Files__c>();
       List<Files__c> UpdateFilesList = new List<Files__c>();
       isBulkUpdate = false;
       isSubmitted = false;
       Batch_Track__c trackBatch = null;
        if(selTL!= null){          
           OrderList  =  queryloc.getOrderList(reqids);  
           qc = queryloc.getmembers(selTeam,ploccheck[0].Mbo_location__c);
        }else {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.EPMS_MBO_CHANGE_QC_CNTRL_SELECT_ANY_MEMBER));
        }
        if(qc.isEmpty()){            
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.Team_Does_Not_Have_QC));            
        }

        if(!OrderList.isEmpty() && selTL != null && !qc.isEmpty()){
        
            for(Production_order__c PObj : OrderList){           
                system.debug('Previous Order Info : ' + PObj);
                PObj.TL_InCharge__c = selTL;
                PObj.QC_Incharge__c = qc[0].id;
                if(PObj.Production_Order_Status__c == 'New'){
                    PObj.Production_Order_Status__c ='Assigned';
                }
                UpdateOList.add(PObj);
            }
            OrderFilesList = queryloc.getFilesDetailsList(reqids);
            
            if(OrderFilesList != null && OrderFilesList.size() > 500){
                system.debug('More than 500 Files scenarios : ');
                isBulkUpdate = true;
                String queryString = 'Change_TL';
                EPMS_Change_TL_Batch batch = new EPMS_Change_TL_Batch(reqids[0],selTL,qc[0].id,queryString);
                batchProcessId = Database.executeBatch(batch);
                batchStatus = 'Started';
                system.debug(' Batch Process Id : ' + batchProcessId);
                
                // Create the custom setting record for tracking batch
                trackBatch = new Batch_Track__c();
                trackBatch.Name = String.valueOf(batchProcessId);
                trackBatch.Batch_Name__c = String.valueOf(batchProcessId);
                trackBatch.Order_Name__c = OrderList[0].Name;
                trackBatch.Name__c = 'Change TL';
                system.debug('### Custom Setting : ### ' + trackBatch);
                
            } else {
            
                for(Files__c PObj1 : OrderFilesList){
                    if(PObj1.Status__c != 'QC' && PObj1.Status__c != 'QCIP' && PObj1.Status__c != 'Approved' && PObj1.Status__c != 'On-Hold'){
                        system.debug('Status : ' + PObj1.Status__c + 'Current TL : ' + PObj1.TLInCharge__c);
                        PObj1.TLInCharge__c = selTL;
                        PObj1.QCIncharge__c = qc[0].id;
                        system.debug(' New TL :  ' + selTL);
                        UpdateFilesList.add(PObj1);
                    } else if(PObj1.Status__c != 'QCIP' && PObj1.Status__c != 'Approved' && PObj1.Status__c != 'On-Hold'){
                        system.debug('QC Update Status : ' + PObj1.Status__c + 'Current TL : ' + PObj1.TLInCharge__c);
                        //PObj1.TLInCharge__c = selTL;
                        PObj1.QCIncharge__c = qc[0].id;
                        system.debug(' New QC :  ' + PObj1.QCIncharge__c);
                        UpdateFilesList.add(PObj1);
                    }
                   
                }
           
            }
            
            try{
                if(UpdateOList.size()>0 && UpdateOList !=null){                
                    update UpdateOList; 
                }
                if(UpdateFilesList.size()>0 && UpdateFilesList !=null){                
                    update UpdateFilesList; 
                }    
                if(trackBatch != null){
                    insert trackBatch;
                }
            } catch(DmlException de){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,de.getMessage()));    
                return null;
            }    
            if(isBulkUpdate){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'Change TL is in-progress. Order contains more files. The process will take few minutes to complete.')); 
            } else {        
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Confirm,Label.EPMS_MBO_CHANGE_QC_CNTRL_TL_IS_ASSIGNED));    
            }    
        } 
        system.debug('Is Batch Process : ' + isBulkUpdate);
        return null; 
    }
    
    public PageReference checkJobStatus() {
    
        if(batchProcessId != null){
            AsyncApexJob result = [SELECT Id, NumberOfErrors, JobItemsProcessed, Status, TotalJobItems FROM AsyncApexJob WHERE Id =: batchProcessId];
            system.debug('$$ Result : ' + result);
            if(result != null){
                batchStatus = result.Status;
                if(batchStatus == 'Completed'){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Confirm,Label.EPMS_MBO_CHANGE_QC_CNTRL_TL_IS_ASSIGNED));
                }
            } else {
                batchStatus = ''; 
            }
            
        }
        return null;
    }

    
    
    
}