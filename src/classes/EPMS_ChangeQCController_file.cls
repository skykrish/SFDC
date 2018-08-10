/****************************************************************************
*   Class               :       EPMS_ChangeQCController_file                *
*   Created Date        :       20/03/2018                                  *           
*   Description         :       Controller for change QC for files          *
/***************************************************************************/  
public class EPMS_ChangeQCController_file {

  public ApexPages.StandardController c;
        public list<SelectOption> shiftNames{get;set;}
        public string fileRecord {get; set;}
        public list<SelectOption> teamNames{get;set;} 
        public list<SelectOption> QCNames{get;set;}
        public String Orderid {get;set;}
        public  list<Member__c> qc = new list<member__c>();
        public list<Files__c> flocheck = new list<Files__c>();
        public List<Shift_Assignments__c> teamIdList= null;
        public List<Shift__c> shiftList = new List<Shift__c>();
        public EPMS_ProductionOrder_Query_Locator queryloc = new EPMS_ProductionOrder_Query_Locator();
        public List<Team__c> teamNameList = null;
        public  List<string> reqids = new List<string>();
        public Set<Id> teamIds {get;set;}
        public Set<Id> MemteamIds = new Set<Id>();
        public String selShift{get;set;}
        public String selTeam{get;set;}
        Public list<member__c> memlist = new  list<member__c>();
        public String selQC{get;set;}
        public string basepath {get;set;}
        public String userCurrentShift {get;set;}       
        public String userCurrentTeam {get;set;}        
        public List<Profile> profilelist {get;set;}     
        public string userProfileName {get;set;}      
        public set<string> poIds{get;set;}
        public list<Production_Order__c> POList=new list<Production_Order__c>();    
        public Member__c memQCUserid=new Member__c();       
        public Boolean exceedLimit{get;set;}
        public String QCUserId{get;set;}
        public list<Production_Order__c> prodList=new list<Production_Order__c>();
        public Boolean isHandover{get;set;}
        public Boolean isRedo{get;set;}
        public set<production_Order__c> setpolist=new set<production_Order__c>(); 
         public list<Production_Order__c> POListwithQCids=new list<production_Order__c>();
         public string qcstring {get;set;}
          public set<String> posetuserids=new set<string>();
          public set<String> posetids=new set<string>();
                
        // Shift Assignment service     
        EPMS_Shift_Assignment_Service_New shiftService = new EPMS_Shift_Assignment_Service_New();       
        // File Operator Assignment service (For Getting Current Shift and Current Team)        
        EPMS_FileOperatorAssignmentService fileService = new EPMS_FileOperatorAssignmentService();

        
        public EPMS_ChangeQCController_file(ApexPages.StandardController stdController)
        {
        string ids = ApexPages.currentPage().getParameters().get('ids'); 
        basepath = ApexPages.currentPage().getParameters().get('base');
        for(String key:ids.split(',')){
        reqids.add(key);
         } 
         isHandover=False; 
         isRedo=False;       
       
       
       poIds=new set<String>();
       flocheck = queryloc.getfileCheck(reqids);
       for(Files__c file:flocheck){
       poIds.add(file.Production_Order__c);
       }
       
       POList=queryloc.getpoList(poIds);
       
       

        if(reqids!= null){
            shiftNames= new list<SelectOption>();
            shiftList = queryloc.getShift(flocheck[0].Production_Order__r.Mbo_Location__c);
            shiftNames.add(new SelectOption('', 'Select Shift')); 
                for(Shift__c shiftObj : shiftList) {
                    shiftNames.add(new SelectOption(shiftObj .Id, shiftObj.Name));
                }
            }
           if(reqids != null && reqids.size() > 0){
               fileRecord = reqids[0];
           }
           
             profilelist  = shiftService.getProfiles();     
        if(profilelist.size() > 0){     
            userProfileName = profilelist[0].Name;      
        }       
                
        if(userProfileName != 'System Administrator' && userProfileName != 'Production Administrator' && userProfileName != 'Country Administrator'){     
                Member__c userMemberInfo = fileService.getLoggedMemberInformation();        
                if(userMemberInfo != null){     
                    Shift_Assignments__c shiftInfo = fileService.getLoggedMemberShiftAssignmentInformation(userMemberInfo.Id);      
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
            
           
           
        }
           
    public PageReference changeShift(){
    
            
    
    
        selTeam=null;
        teamIds =new Set<Id>();
        teamNameList = new List<Team__c>();
        MemteamIds = new Set<Id>();
        teamIdList = new List<Shift_Assignments__c>();
        teamNames= new list<SelectOption>();
        
        teamNames.add(new SelectOption('', 'Select Team'));
        if(selShift != null){
            teamIdList = queryloc.getShiftMemberlist(selShift);
        }
        if(teamIdList != null &&teamIdList.size()>0){
        
            for(Shift_Assignments__c memberObj : teamIdList){
               teamIds.add(memberObj.Member__C);
            }
        }

        list<member__c> memTeam = new list<Member__c>();
        memTeam = queryloc.getteammembers(teamIds,flocheck[0].Production_Order__r.Mbo_Location__c);
        if(memTeam != null &&memTeam.size()>0){
            for(Member__c teams:memTeam) 
            {
                MemteamIds.add(teams.Team_id__c);
                }
        }
        teamNameList  = queryloc.getTeam(MemteamIds,flocheck[0].Production_Order__r.Mbo_Location__c);
        
        if(teamNameList != null &&teamNameList.size()>0){
            if(teamNameList.size()>0){
                for(Team__c teamObj : teamNameList){
                   teamNames.add(new SelectOption(teamObj.id, teamObj.Name));        
                }
            }
        }
        return null;    
    }
    
    public void changeTeam(){
    
        selQC=null;
        QCNames= new list<SelectOption>();
        QCNames.add(new SelectOption('', 'Select QC'));
        if(selTeam != null){
        
            memlist = queryloc.getmembersQC(selTeam,flocheck[0].Production_Order__r.Mbo_Location__c);
        }
        for(member__c qcObj : memlist ){
        
        if(qcObj.Performance_Rating__r.Name==null){
        
        QCNames.add(new SelectOption(qcObj.id, qcObj.Name)); 
        }else{
        
            QCNames.add(new SelectOption(qcObj.id, qcObj.Name + '-'+ qcObj.Performance_Rating__r.Name));        
        }
        }
        
    }  
    public PageReference saveChanges(){
    
        List<Files__c> OrderList = new List<Files__c>();
        List<Files__c> UpdateOList = new List<Files__c>();
        List<Files__c> UnUpdatedList = new List<Files__c>();
        
        
        if(selQC!=null){
        memQCUserid=[select id,User_Id__c from Member__c where id=:selQC limit 1];      
        }
        
        QCUserId=memQCUserid.User_Id__c;
        
        if(selShift==null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.Please_Select_a_Shift_for_Assigning_QC));
        
        }else if(selTeam == null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.Please_Select_a_Team_for_Assigning_QC));
            
        } else if(selQC == null){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.Please_Select_a_QC_for_Assigning_to_File));
            
        }else{
        
            OrderList  =  queryloc.getFilesList(reqids);  
            qc = queryloc.getmembers(selTeam,flocheck[0].Production_Order__r.Mbo_Location__c);
        
            if(!OrderList.isEmpty() && selQC != null && !qc.isEmpty()){
                for(Files__c fileObj : OrderList){
                    if(fileObj.Status__c=='Assigned' || fileObj.Status__c=='Handover' || fileObj.Status__c=='WIP' || fileObj.Status__c!='Redo' || fileObj.File_Type__c!='Instruction' || fileObj.Status__c!='QC'){
                       
                        fileObj.QCIncharge__c = selQC;
                        UpdateOList.add(fileObj);
                        
                        if(fileObj.Status__c=='Handover'){
                        isHandover=True;
                        }
                    if(fileObj.Status__c=='Redo'){
                        isRedo=True;
                        }
                        
                        
                        
                    }
                    else if(fileObj.Status__c!='New' || fileObj.Status__c!='Handover' || fileObj.File_Type__c=='Instruction'){
                        UnUpdatedList.add(fileObj);                    
                    }
                }
                if(UpdateOList.size()>0){
                    update UpdateOList;
                    updateTLandQC();
                    
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Confirm,Label.Assigned_QC_for_Selected_File)); 
                    
                    if(isHandover){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Confirm,Label.EPMS_Handover_Change_QC_Message)); 
                    }
                    
                    if(isRedo){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Confirm,Label.EPMS_Redo_Change_QC_Message)); 
                    }
                    
                    if(isHandover == True && isRedo == True ){
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Confirm,Label.EPMS_Handover_Or_Redo_Change_QC_Message)); 
                    }
                    
                    
                    selShift=null;
                    selTeam=null;
                    selQC=null;
                }
                if(UnUpdatedList.size()>0){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,Label.EPMS_MBO_CHANGE_FILE_QC_CANNOT_HANDOVER_NEW_STATUS_FILES+UnUpdatedList));                
                }
            } 
        }
         return null;
    }
    
    public void updateTLandQC(){
     
     if(QCUserId!=null){
    for(Production_Order__c poRecord:poList){
    if(poRecord.qcId__c!=null) {
                
                if (!getPOIdsSize(poRecord.qcid__c)) {        
                    if(!(poRecord.qcid__c.contains(QCUserId))) {
                        poRecord.qcid__c +=','+QCUserId;
                    }
                } else {                
                    if(poRecord.qcId1__c!=null && (!getPOIdsSize(poRecord.qcid__c)) && (!getPOIdsSize(poRecord.qcid1__c))) {               
                        if (!getPOIdsSize(poRecord.qcId1__c)) {
                            poRecord.qcId1__c +=','+QCUserId;                          
                        }
                    }
                    else if(!getPOIdsSize(poRecord.qcid__c))
                    {
                    
                     poRecord.qcId1__c=QCUserId;
                    
                    }
                }   
}               
                else {
                        poRecord.qcId__c=QCUserId;
                    }
              if(posetuserids.add(poRecord.id)){  
        prodList.add(poRecord);  
}       
       }  
       }   
    update prodList;
    
    //modified by udayasri
        
        POListwithQCids=([select Name,id,QCidr1__c,QCidr2__c,(select id,QCInCharge__r.User_Id__c from files__r where Status__c!='On-Hold' AND Status__c!='Approved') from production_Order__c where id=:poIds]);
        system.debug('----POListwithQCids----'+POListwithQCids);
 

        for(production_Order__c po:POListwithQCids){
        
         
        po.QCidr1__c='';
        po.QCidr2__c='';
       
        
        for(Files__c file:po.files__r){
        
         if(file.QCInCharge__r.User_Id__c !=null){
        if(po.QCidr1__c==null || po.QCidr1__c==''){
        po.QCidr1__c=file.QCInCharge__r.User_Id__c;
        }
        else{
                                     qcstring=po.QCidr1__c;
                                     
                                     if(qcstring.length()<236){
                                     if(!(qcstring.contains(file.QCInCharge__r.User_Id__c))) {
                                     po.QCidr1__c += ','+file.QCInCharge__r.User_Id__c;
                                     }
                                     }
                                     
                                     
                                      else if(po.QCidr2__c == null){
                                       if(!(qcstring.contains(file.QCInCharge__r.User_Id__c))) {
                                po.QCidr2__c = file.QCInCharge__r.User_Id__c;
                                }
                                     }else{
                                     qcstring +=','+po.QCidr2__c;
                                     if(qcstring.length()>236){
                                     if(!(qcstring.contains(file.QCInCharge__r.User_Id__c))) {
                                     po.QCidr2__c += ','+file.QCInCharge__r.User_Id__c;
                                     }
                                     
                                     
                            }
                            }
                         
                         }
        
        
        
        }
        
        }
        if(posetids.add(po.id)){
        setpolist.add(po);
        }
        }
        
        if(!setpolist.isEmpty()){

        List<production_Order__c> prodOrderList = new List<production_Order__c>(setpolist);
        update prodOrderList;
        }
    }
     
            
    
    // return true when no of PO ids reached 13 else return false
    public boolean getPOIdsSize(String poids) {
        boolean exceedLimit = false;
        String[] arrPOIds = poids.split(',');
        
        if (arrPOIds.size() > 12) {
            exceedLimit = true;
        }
    
        return exceedLimit; 
    }
    
    
    
           
}