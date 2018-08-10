/****************************************************************************
*   Class               :       EPMS_ChangeQCController                     *
*   Created Date        :       13/04/2016                                  *           
*   Description         :       Controller for change QC incharge for order *
/***************************************************************************/ 


public class EPMS_ChangeQCController {

    public ApexPages.StandardController c;
    public SelectOption[] shiftNames{get;set;}
    public SelectOption[] teamNames{get;set;} 
    public SelectOption[] qcNames{get;set;}     
    public  List<string> reqids = new List<string>(); 
    public List<Shift_Assignments__c> teamIdList= null;
    public List<Shift__c> shiftList = new List<Shift__c>();
    public List<Team__c> teamNameList = new List<Team__c>();
    public list<member__c> memlist = new  list<member__c>();
    public list<Production_order__c> ploccheck = new list<Production_order__c>();
    public EPMS_ProductionOrder_Query_Locator queryloc = new EPMS_ProductionOrder_Query_Locator();
    public Set<Id> teamIds = new Set<Id>();
    public list<member__c> memTeam = new list<Member__c>();
    public Set<Id> MemteamIds = new Set<Id>();
    public String selShift{get;set;}
    public String selTeam{get;set;}
    public String selQc{get;set;}
    public String userCurrentShift {get;set;}       
    public String userCurrentTeam {get;set;}        
    public List<Profile> profilelist {get;set;}     
    public string userProfileName {get;set;}        
    public boolean isSubmitted {get;set;}
    
    public Id batchProcessId {get;set;}    
    public String batchStatus {get;set;}
    public boolean isBulkUpdate {get;set;}        
    
    // Shift Assignment service     
    EPMS_Shift_Assignment_Service_New shiftService = new EPMS_Shift_Assignment_Service_New();       
    // File Operator Assignment service (For Getting Current Shift and Current Team)        
    EPMS_FileOperatorAssignmentService fileService = new EPMS_FileOperatorAssignmentService();

    // constructor  
    public EPMS_ChangeQCController(ApexPages.StandardController stdController)
    {
        string ids = ApexPages.currentPage().getParameters().get('ids');   
        isBulkUpdate = false; 
        isSubmitted = true;    
        for(String key:ids.split(',')){
            reqids.add(key);
        }   
        ploccheck = queryloc.getPOCheck(reqids);
        if(reqids!= null){
            shiftNames= new SelectOption[0];
            shiftList = queryloc.getShift(ploccheck[0].Mbo_location__c);
            shiftNames.add(new SelectOption('----', 'Select Shift')); 
                for(Shift__c shiftObj : shiftList) {
                    shiftNames.add(new SelectOption(shiftObj.Id, shiftObj.Name));
                }
        }
        
        
           profilelist  = shiftService.getProfiles();       
        if(profilelist.size() > 0){     
            userProfileName = profilelist[0].Name;      
        }       
                 Shift_Assignments__c shiftInfo = null;
        if(userProfileName != 'System Administrator' && userProfileName != 'Production Administrator' && userProfileName != 'Country Administrator'){     
                Member__c userMemberInfo = fileService.getLoggedMemberInformation();        
                if(userMemberInfo != null){     
                    shiftInfo = fileService.getLoggedMemberShiftAssignmentInformation(userMemberInfo.Id);      
                    if(shiftInfo != null){      
                        userCurrentShift = shiftInfo.Shift_Code__c;     
                        userCurrentTeam = userMemberInfo.Team_Id__c; 
                        
                    }       
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
                selQc = shiftInfo.Member__c;       
            }
        
    }
        
    //getting team members from the selected shift      
    public PageReference changeShift(){
        
        if(teamNameList != null && teamNameList.size() > 0){        
            system.debug('Inside the test : ' + teamNameList);      
            teamNameList = new List<Team__c>();     
            teamNames = new SelectOption[]{};       
            qcNames =  new SelectOption[]{};        
            teamIdList = new List<Shift_Assignments__c>();      
            teamIds = new Set<Id>();        
            MemteamIds = new Set<Id>();     
        }
    
    
        teamNames= new SelectOption[0];
        teamNames.add(new SelectOption('Select Team', 'Select Team'));
        if(selShift != null){
            teamIdList =queryloc.getShiftMemberlist(selShift);
                     
         }       
       
        if(teamIdList != null && teamIdList.size() > 0){                    
            for(Shift_Assignments__c memberObj : teamIdList){                 
               teamIds.add(memberObj.Member__C);        
            }       
        }  


       
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
    
    //getting Currentteam QC based on current production order location
    public void changeTeam(){
        qcNames = new SelectOption[0];
        qcNames.add(new SelectOption('', 'Select QC'));
        if(selTeam != null){      
            memlist = queryloc.getmembers(selTeam,ploccheck[0].Mbo_location__c);
        }       
        for(member__c qcObj : memlist ){
        if(qcObj.Performance_Rating__r.Name==null){
         qcNames.add(new SelectOption(qcObj.id, qcObj.Name));
         }
        else{
        
            qcNames.add(new SelectOption(qcObj.id, qcObj.Name +'-'+qcObj.Performance_Rating__r.Name));
            }
        }
    }

    
    // Assign Qc 
    public PageReference saveChanges(){
        List<Production_order__c> OrderList = new List<Production_order__c>();
        List<Production_order__c> UpdateOList = new List<Production_order__c>();
        List<Files__c> UpdateFilesList = new List<Files__c>();
        List<Files__c> OrderFilesList = new List<Files__c>();        
        isBulkUpdate = false;
        isSubmitted = false;  
        Batch_Track__c trackBatch = null;
        if(selQc!= null){          
           OrderList  =  queryloc.getOrderList(reqids);          
        }else 
        {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.EPMS_MBO_CHANGE_QC_CNTRL_SELECT_ANY_MEMBER));
        }
        
        /*
        Integer fileCountLimit = 0;
        if(Test.isRunningtest()){
            fileCountLimit = 100;
        } else {
            fileCountLimit = 500;
        }
        system.debug('Apex Class / Apex Test Class : size' +fileCountLimit);
        */
        
        if(!OrderList.isEmpty() && selQc != null){
            for(Production_order__c PObj : OrderList){         
                PObj.QC_InCharge__c = selQc;
                UpdateOList.add(PObj);               
            }
                       
            OrderFilesList = queryloc.getFilesDetailsList(reqids);
            // Handle more files in Batch Process
            
            if(OrderFilesList != null && OrderFilesList.size() > 500){
                system.debug('More than 500 Files scenarios : Change QC ');
                isBulkUpdate = true;
                String queryString = 'Change_QC';
                EPMS_Change_TL_Batch batch = new EPMS_Change_TL_Batch(reqids[0],null,selQc,queryString);
                batchProcessId = Database.executeBatch(batch);
                batchStatus = 'Started';
                system.debug(' [CHANGE QC] Batch Process Id : ' + batchProcessId);
                
                // Create the custom setting record for tracking batch
                trackBatch = new Batch_Track__c();
                trackBatch.Name = String.valueOf(batchProcessId);
                trackBatch.Batch_Name__c = String.valueOf(batchProcessId);
                trackBatch.Order_Name__c = OrderList[0].Name;
                trackBatch.Name__c = 'Change QC';
                system.debug('### Custom Setting : ### [CHANGE QC] ' + trackBatch);
            } else {
            
            for(Files__c PObj1 : OrderFilesList){
                if((PObj1.Status__c != 'QCIP' || PObj1.Status__c != 'Approved' || PObj1.Status__c != 'On-Hold') && ( (PObj1.Status__c == 'QC' && PObj1.Files_To_Open__c != 1  ) || ( PObj1.Status__c == 'WIP'  || 
                 PObj1.Status__c == 'HandOver'  || PObj1.Status__c == 'Assigned' || PObj1.Status__c == 'Redo' || PObj1.Status__c == 'New')
                  )) {
                    
                    system.debug('PObj1 values'+PObj1);
                    PObj1.QCIncharge__c = selQc;
                    UpdateFilesList.add(PObj1);
                }
            }
            
            }
            try{
                update UpdateOList;
                if(UpdateFilesList != null && UpdateFilesList.size() > 0){
                    update UpdateFilesList;           
                }
                if(trackBatch != null){
                    insert trackBatch;
                }
            } catch (DmlException de){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,de.getMessage())); 
                return null;
            }
            
            if(isBulkUpdate){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'Change QC is in-progress. Order contains more files. The process will take few minutes to complete.')); 
            } else { 
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Confirm,Label.EPMS_MBO_CHANGE_QC_CNTRL_QC_IS_ASSIGNED));          
            }    
        }      
        return null;           
    }             
    
    public PageReference checkJobStatus() {
    
        if(batchProcessId != null){
            AsyncApexJob result = [SELECT Id, NumberOfErrors, JobItemsProcessed, Status, TotalJobItems FROM AsyncApexJob WHERE Id =: batchProcessId];
            system.debug('$$ Result : ' + result);
            if(result != null){
                batchStatus = result.Status;
                if(batchStatus == 'Completed'){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Confirm,Label.EPMS_MBO_CHANGE_QC_CNTRL_QC_IS_ASSIGNED));
                }
            } else {
                batchStatus = ''; 
            }
            
        }
        return null;
    }
    
    
    
    
}