/**********************************************************************************
*   Class               :       EPMS_HandOverDirectoriesTL                        *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Controller to handover Files by TL/QC             *
**********************************************************************************/
public with sharing class EPMS_HandOverDirectoriesTL {

        public ApexPages.StandardController c;
        public SelectOption[] shiftNames{get;set;}
        public SelectOption[] teamNames{get;set;} 
        public SelectOption[] TLNames{get;set;}
        public String Orderid {get;set;}
        public  list<Member__c> qc = new list<member__c>();
        public list<Files__c> ploccheck = new list<Files__c>();
        public List<Shift_Assignments__c> teamIdList= null;
        public List<Shift__c> shiftList = new List<Shift__c>();
       
        public List<Team__c> teamNameList = new List<Team__c>();
        public  List<string> reqids = new List<string>();
        public Set<Id> teamIds = new Set<Id>();
        public Set<Id> MemteamIds = new Set<Id>();
        public String selShift{get;set;}
        public String selTeam{get;set;}
        public list<member__c> memlistTL = new  list<member__c>();
         public list<member__c> memlistQC = new  list<member__c>();
        public String selTL{get;set;} 
        public  String MyprofileName {get;set;}
        public id userid {get;set;}
    
    //constructor    
    public EPMS_HandOverDirectoriesTL(){
    
        Id profileId=userinfo.getProfileId();
        userid = userinfo.getuserId();   
        MyprofileName=[Select Id,Name from Profile where Id=:profileId].Name;
        string ids = ApexPages.currentPage().getParameters().get('ids');        
        for(String key:ids.split(',')){
            reqids.add(key);
        }   
        ploccheck = [Select Production_Order__r.Mbo_Location__c,id from Files__c where id IN:reqids And (File_Type__c=:Label.EPMS_File_Type_Directory OR File_Type__c=:label.EPMS_File_Type_Image) ];
        if(reqids!= null && ploccheck.size()>0){
            shiftNames= new SelectOption[0];
            shiftList =  [select Id, Name from Shift__c where Shift_Location__c=:ploccheck[0].Production_Order__r.Mbo_Location__c AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS and Implements_From__c <=TODAY ];
            shiftNames.add(new SelectOption('', 'Select Shift')); 
            for(Shift__c shiftObj : shiftList) {
                shiftNames.add(new SelectOption(shiftObj .Id, shiftObj.Name));
            }
        } else {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.EPMS_MBO_HANDOVER_TL_NO_LOCATION_SPECIFIED_IN_DIRECTORY));
        }
    }
    
    //getting current shift members based on production order location
           
    public PageReference changeShift(){
        teamNames= new SelectOption[0];
        teamNames.add(new SelectOption('', 'Select Team'));
        if(selShift != null){
            teamIdList = [select Name,Member__c from Shift_Assignments__c where Shift_Code__c =:selShift]; 
        }
        for(Shift_Assignments__c memberObj : teamIdList){
           teamIds.add(memberObj.Member__C);
        }
        list<member__c> memTeam = new list<Member__c>();
        memTeam =  [select Team_id__c from Member__c where id IN:teamids and location_id__c=:ploccheck[0].Production_Order__r.Mbo_Location__c];
        for(Member__c teams:memTeam) 
        {
            MemteamIds.add(teams.Team_id__c);
        }        
        teamNameList  =  [Select id, Name from Team__c where id IN:MemteamIds and Location__c=:ploccheck[0].Production_Order__r.Mbo_Location__c];   
        
        for(Team__c teamObj : teamNameList){
           teamNames.add(new SelectOption(teamObj.id, teamObj.Name));        
        }
        return null;    
    }
    
    
    //getting TL for the current team
    public void changeTeam(){
        if((MyprofileName == 'Country Administrator')|| (MyprofileName == EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME)||(MyprofileName == EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME)){
            TLNames= new SelectOption[0];
            TLNames.add(new SelectOption('', 'Select TL'));        
            if(selTeam != null){
                memlistTL =  [Select Name,id,Location_id__c from Member__c where Team_id__c =:Selteam and location_id__c=:ploccheck[0].Production_Order__r.Mbo_Location__c and Designation__c=:EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME and status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS and Member__c.User_Id__c!=:userid];
            }
            
            for(member__c qcObj : memlistTL ){
                TLNames.add(new SelectOption(qcObj.id, qcObj.Name));        
            }
            }else if((MyprofileName == 'Country Administrator')||(MyprofileName == EPMS_UTIL.EPMS_QC_PROFILE_NAME)||(MyprofileName == EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME))
            {
             TLNames= new SelectOption[0];
            TLNames.add(new SelectOption('', 'Select QC'));        
            if(selTeam != null){
                memlistQC =  [Select Name,id,Location_id__c from Member__c where Team_id__c =:Selteam and location_id__c=:ploccheck[0].Production_Order__r.Mbo_Location__c and (Designation__c=:EPMS_UTIL.EPMS_QC_PROFILE_NAME and status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS) and Member__c.User_Id__c!=:userid ];
                
            }
            
            for(member__c qcObj : memlistQC ){
                TLNames.add(new SelectOption(qcObj.id, qcObj.Name));        
            }
            }
    }
    
      
    //update/Save TL 
    public PageReference saveChanges(){
       List<Files__c> OrderFList = new List<Files__c>();
       List<Files__c> UpdateOList = new List<Files__c>();
       List<Files__c> OrderFilesList = new List<Files__c>();
       List<Files__c> UpdateFilesList = new List<Files__c>();
       Boolean ErrorMsg = true;
       String filesNames = '';
       Id orderlocation = null;
       boolean fileOpenInTracker = false;
       Boolean exceptionThrows = false;
        if(selTL!= null){          
           OrderFList  =   [Select id,Name,File_Location__c,TLInCharge__c,QCIncharge__c,Files_To_open__c,Status__c from Files__c where id IN:reqids];
           
           qc =  [Select Name,id,Location_id__c from Member__c where Team_id__c =:Selteam and location_id__c=:ploccheck[0].Production_Order__r.Mbo_Location__c and Designation__c=:EPMS_UTIL.EPMS_QC_PROFILE_NAME and status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS];
           
             }else {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.EPMS_MBO_HANDOVER_TL_PLEASE_SELECT_TEAM_OR_MEMBER));
            ErrorMsg= false;
        }
        if(qc.isEmpty() && ErrorMsg==true ){            
             ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.Team_Does_Not_Have_QC));            
        }
        if(!OrderFList.isEmpty() && selTL != null && !qc.isEmpty()){          
          if((MyprofileName == 'Country Administrator')|| (MyprofileName == EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME)||(MyprofileName == EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME)){
            for(Files__c PObj1 : OrderFList){
                PObj1.TLInCharge__c = selTL;
                PObj1.QCIncharge__c = qc[0].id;
                UpdateFilesList.add(PObj1);
                // Add the file name to single string and order location
                if(filesNames == ''){
                    filesNames = PObj1.Name;
                    orderlocation = PObj1.File_Location__c;
                } else {
                    filesNames = filesNames + ' , ' + PObj1.Name;
                }
                
            }
            }else if((MyprofileName == 'Country Administrator')|| (MyprofileName == EPMS_UTIL.EPMS_QC_PROFILE_NAME)||(MyprofileName == EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME))
            {
            for(Files__c Obj1 : OrderFList){
                if(Obj1.Files_To_open__c == 1 && Obj1.Status__c == 'QC'){
                    fileOpenInTracker = true;
                    break;
                } else {
                    Obj1.QCIncharge__c = selTL;
                    UpdateFilesList.add(Obj1);
                    // Add the file name to single string and order location
                    if(filesNames == ''){
                        filesNames = Obj1.Name;
                        orderlocation = Obj1.File_Location__c;
                    } else {
                        filesNames = filesNames + ' , ' + Obj1.Name;
                    }
                }
            }
            if(fileOpenInTracker){
                 ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,'Files are already opened in Tracker. Please Close the file and Try again ')); 
                 return null;
            }
            }           
            if(UpdateFilesList.size()>0 && UpdateFilesList !=null){     
                try{
                    update UpdateFilesList;
                } catch (DmlException e){
                    exceptionThrows = true;
                }
                
                
            }    
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Confirm,Label.EPMS_MBO_HANDOVER_TL_MEMBER_IS_ASSIGNED_TO_DIRECTORIES));    
        }

        // After Update the member in File 
        
        if(!exceptionThrows){
            Map<String, Object> params = new Map<String, Object>();
    
            if(selTL != null){
                params.put('TL_Incharge_Id', selTL);
            }
            
            // Adding Order Names into flow parameters
            params.put('PrdOrderName', filesNames);
            
            // Adding Location into flow parameters
            params.put('ProdOrdLocation', orderlocation);
            
            // Adding Chatter Notification into flow parameters
            params.put('displayChatterMessage', 'Following Files are handover to you. Kindly find file(s) name :  ');
            
            
            // Call the Flow - Sends the chatter Notification to Team Leader
            
            Flow.Interview.Operator_File_Assignment_Notification chatterFlow = new Flow.Interview.Operator_File_Assignment_Notification(params);
            chatterFlow.start();
        }
        
        
        return null; 
    }
}