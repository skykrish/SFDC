/****************************************************************************
*   Class               :       EPMS_ChangeFileQCController                 *
*   Created Date        :       13/04/2016                                  *           
*   Description         :       Controller for change QC incharge for files *
/***************************************************************************/  

public class EPMS_ChangeFileQCController {

    public ApexPages.StandardController c;
        public SelectOption[] shiftNames{get;set;}
        public SelectOption[] teamNames{get;set;} 
        public SelectOption[] qcNames{get;set;}     
        public  List<string> reqids = new List<string>(); 
        public List<Shift_Assignments__c> teamIdList= null;
        public List<Shift__c> shiftList = new List<Shift__c>();
        public List<Team__c> teamNameList = new List<Team__c>();
        public list<member__c> memlist = new  list<member__c>();
        public list<Files__c> floccheck{get;set;}
        public EPMS_Files_Query_Locator queryloc = new EPMS_Files_Query_Locator();
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
        public Boolean isHandover {get;set;}
        public Boolean isRedo {get;set;}
        public set<string> poIds{get;set;}
        public list<Production_Order__c> POList=new list<Production_Order__c>(); 
        public Boolean exceedLimit{get;set;}
        public String QCUserId{get;set;}
        public Member__c memQCUserid=new Member__c();  
        public list<Production_Order__c> prodList=new list<Production_Order__c>();
        public list<Production_Order__c> POListwithQCids=new list<production_Order__c>();
        public string qcstring {get;set;}
        public set<production_Order__c> setpolist=new set<production_Order__c>(); 
        public set<String> posetids =new set<String>();
        public set<String> posetuserids=new set<string>();
                
        // Shift Assignment service     
        EPMS_Shift_Assignment_Service_New shiftService = new EPMS_Shift_Assignment_Service_New();       
        // File Operator Assignment service (For Getting Current Shift and Current Team)        
        EPMS_FileOperatorAssignmentService fileService = new EPMS_FileOperatorAssignmentService();
         public EPMS_ProductionOrder_Query_Locator querylocator = new EPMS_ProductionOrder_Query_Locator();
        
        
        
        public EPMS_ChangeFileQCController(ApexPages.StandardController stdController)
        {
            string ids = ApexPages.currentPage().getParameters().get('ids');       
            for(String key:ids.split(',')){
                reqids.add(key);
            }      
            
            isHandover=False; 
            isRedo=False;  
            
            poIds=new set<String>();
       floccheck = queryloc.getfileCheck(reqids);
       for(Files__c file:floccheck){
       poIds.add(file.Production_Order__c);
       }
       
       POList=querylocator.getpoList(poIds);
            
            if(reqids!= null){
                floccheck=[Select Name,File_Location__c,id,Production_Order__c,Production_Order__r.Mbo_Location__c from Files__c 
                           where id IN:reqids AND File_Type__c!=:label.EPMS_File_Type_Instruction]; 
                shiftNames= new SelectOption[0];
                shiftList = queryloc.getShift(floccheck[0].Production_Order__r.Mbo_Location__c);
                shiftNames.add(new SelectOption('', 'Select Shift')); 
                for(Shift__c shiftObj : shiftList) {
                    shiftNames.add(new SelectOption(shiftObj .Id, shiftObj.Name));
                }
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
           
    public void changeShift(){
    
    
    
    
    
    
        teamNames= new SelectOption[0];
        if(teamIds != null && teamIds.size() > 0){
            teamIds = new Set<Id>();
        }
      
        teamNames.add(new SelectOption('', 'Select Team'));
        MemteamIds = new Set<Id>();
        if(selShift != null){
            teamIdList =queryloc.getShiftMemberlist(selShift);
         } 

     if(teamIdList != null && teamIdList.size() > 0){     
            for(Shift_Assignments__c memberObj : teamIdList){
               teamIds.add(memberObj.Member__C);
            }  
        }
        memTeam = queryloc.getteammembers(teamIds,floccheck[0].Production_Order__r.Mbo_Location__c);
        
         if(memTeam != null && memTeam.size() > 0){ 
            for(Member__c teams:memTeam) 
            {
            MemteamIds.add(teams.Team_id__c);
            }
        }
        teamNameList  = queryloc.getTeam(MemteamIds,floccheck[0].Production_Order__r.Mbo_Location__c);
        if(teamNameList != null && teamNameList.size() > 0){
            for(Team__c teamObj : teamNameList){
               teamNames.add(new SelectOption(teamObj.id, teamObj.Name));
            }
        } 
        
                
        if(selShift==null || teamNameList.size() == 0){
            teamNames= new SelectOption[0];
            teamNames.add(new SelectOption('', 'Select Team'));
            qcNames = new SelectOption[0];
            qcNames.add(new SelectOption('', 'Select QC'));          
        }
            
    }
    
    public void changeTeam(){
        qcNames = new SelectOption[0];
        qcNames.add(new SelectOption('', 'Select QC'));
        if(selTeam != null){      
         memlist = queryloc.getmembers(selTeam,floccheck[0].Production_Order__r.Mbo_Location__c);
        }       
            for(member__c qcObj : memlist ){
            if(qcObj.Performance_Rating__r.Name==null){
            qcNames.add(new SelectOption(qcObj.id, qcObj.Name));
            }
            
            else{
            qcNames.add(new SelectOption(qcObj.id, qcObj.Name+'-'+qcObj.Performance_Rating__r.Name));
        }
        }
        
        }  
    public PageReference saveChanges(){
      List<Files__c> Fileslist = new List<Files__c>();
      List<Files__c> UpdateOList = new List<Files__c>();
      
      if(selQC!=null){
        memQCUserid=[select id,User_Id__c from Member__c where id=:selQC limit 1];      
        }
        
        QCUserId=memQCUserid.User_Id__c;
        
        if(selQc!= null && selTeam!=null && selShift!=null){          
           Fileslist =  queryloc.getFileslist(reqids);  
        
        } else 
        {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,label.EPMS_MBO_SELECT_QC));
        }
        
        if(!Fileslist.isEmpty() && selQc != null && selShift!=null){
            for(Files__c PObj : Fileslist ){
                if(PObj.File_Type__c!=label.EPMS_File_Type_Instruction){
                    PObj.QCIncharge__c = selQc;
                    PObj.Qc_Assigment_Time__c = System.Today();
                    UpdateOList.add(PObj);
                    
                    //modified by udayasri based on CR-501
                    
                     if(PObj.Status__c=='Handover'){
                        isHandover=True;
                        }
                    if(PObj.Status__c=='Redo'){
                        isRedo=True;
                        }
                }
               
            }
            
          update UpdateOList;
          updateTLandQC();
          ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Confirm,Label.EPMS_MBO_ASSIGN_QC));
          
          //modified by udayasri based on CR-501
          
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
          selQc=null;
          selTeam=null;
          MemteamIds = new Set<Id>();
          teamIds = new Set<Id>();
          qcNames = new SelectOption[0];
          teamNames= new SelectOption[0];
        }          
          return null;     
    } 

    //modified by udayasri based on CR-501
    
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