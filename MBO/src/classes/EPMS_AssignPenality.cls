/********************************************************************************************
*   Class               :       EPMS_AssignPenality                                         *
*   Created Date        :       13/04/2016                                                  *           
*   Description         :       Used for creating penalty records for files                 *
*   Modified            :       EPMSSF-519 Changes : When Penalty is given by Sales Reagon  *
*                               guys then Penalty will be added to Artist also along with QC* 
********************************************************************************************/

public with sharing class EPMS_AssignPenality{    
    
    public List<Files__c> files{get;set;}
    public string fileRecord {get; set;}
    public Member__c member;
    public List<SelectOption> penalityList;
    public Mistakes__c Mistake{get;set;}
    public boolean diableButton{public get;set;}
    public boolean RecordExist{public get;set;}
    public boolean errorFlag {get;set;}
    public boolean errorNoMistakeFlag {get;set;}
    public Set<Id> fileIdSet {get;set;}
    public string penaltycomments {get;set;}
    public string basepath {get;set;}
    public string MyProflieName {get;set;}
    public boolean isSkipPenalty {get;set;}
    public list<Penalty_Assignment__c> penalities = new list<Penalty_Assignment__c>();
    
    // Call the Penalty Service 
    EPMS_File_Assign_Penalty_Service service = new EPMS_File_Assign_Penalty_Service();
    
    //constructor
    public EPMS_AssignPenality(ApexPages.StandardController controller){
        errorFlag = false;
        errorNoMistakeFlag = false;
        diableButton = false;
        RecordExist=false;
        fileIdSet = new Set<Id>();
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        MyProflieName = PROFILE[0].Name;
        system.debug('************ MyProflieName :: ' + MyProflieName);
                
        string ids = ApexPages.currentPage().getParameters().get('ids');
          basepath = ApexPages.currentPage().getParameters().get('type'); 
                 List<string> reqids = new List<string>();
        for(String key:ids.split(',')){
            reqids.add(key);
        }
        
        files = service.getFileInformation(reqids);
        for(Files__c f:files){
            fileIdSet.add(f.Id);
        }
        this.Mistake = (Mistakes__c)controller.getRecord();
         if(reqids != null && reqids.size() > 0){
               fileRecord = reqids[0];
           }
           
    }
    // getting penalties
    public List<SelectOption> getListOfPenalities()
    {
        penalities=[select id,name,Penalty_Level__c,Member__c,Member__r.User_id__c from Penalty_Assignment__c];
        penalityList = new List<SelectOption>();
        penalityList.add(new SelectOption( ' ' ,'---Select---'));
        for(Penalty_Assignment__c P : penalities)
        {
            if(P.Penalty_Level__c!=null)
            penalityList.add(new SelectOption(P.Id , P.Penalty_Level__c));
        }
        return penalityList;
    }
    
    
    // save penalty
    public void saveList(List<Files__c> Fiels,Mistakes__c Mistake){
        List<Mistakes__c> mist = new List<Mistakes__c>();
        Set<Id> FileCheck =new Set<Id>();
        Set<Id> MemberCheck =new Set<Id>();
        errorFlag=false;
        
            if(Mistake.MIstake_Category__c == null ){
                errorFlag=true;
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.EPMS_MBO_PENALTY_SELECT_MISTAKE_TYPE));
                return;
            }
            if(Mistake.MIstake_Category__c != null && Mistake.Mistake__c == null){
                errorFlag=true;
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.EPMS_MBO_PENALTY_SELECT_MISTAKE));
                return;
            }else{                
                mist = service.getMistakeInformation(Mistake.MIstake_Category__c, Mistake.Mistake__c, files[0].File_Location__c);
            }           
            
            if(!mist.isEmpty() && mist != null){
                
                List<Penalty_Assignment__c> existPenaltyList = [select id,Name,File_Name__c,Member__c,Member__r.User_id__c,Mistake_Id__c,Penalty_Assignment_Time__c,Member_Location__c from Penalty_Assignment__c where File_Name__c IN:fileIDSet and Mistake_Id__c=:mist[0].id ];               
                for(Files__c  fle:files){                    
                    Penalty_Assignment__c penality = new Penalty_Assignment__c();
                    penality.File_Name__c = fle.id;                                 
                    penality.Mistake_Id__c =mist[0].id;
                    penality.Penalty_Assignment_Time__c = system.now();
                    penality.Member_Location__c = fle.File_Location__c;
                    penality.Comments__c=penaltycomments;
                    penality.Is_Skipped_File__c = isSkipPenalty;
                    
                    
                    if(MyProflieName=='Quality Control') {
                        penality.Member__c = fle.Member__c;
                        MemberCheck.add(fle.Member__c);
                    //} else if (MyProflieName=='Full-time Employees (Japan)') {
                    } else {                      
                        penality.Member__c = fle.QCIncharge__c;
                        MemberCheck.add(fle.QCIncharge__c);

                        // EPMSSF-519 Changes : When Penalty is given by System Admin/Prod Admin/Shift Admin/Country Admin/Sales Reagon/Permanent Emp(Japan)/Contract Emp(Japan) profile users then Penalty will be created to QC as well as Artist
                        Penalty_Assignment__c penalityArtist = new Penalty_Assignment__c();
                        penalityArtist.File_Name__c = fle.id;                                 
                        penalityArtist.Mistake_Id__c =mist[0].id;
                        penalityArtist.Penalty_Assignment_Time__c = system.now();
                        penalityArtist.Member_Location__c = fle.File_Location__c;
                        penalityArtist.Comments__c=penaltycomments;
                        penalityArtist.Is_Skipped_File__c = isSkipPenalty;                      
                        penalityArtist.Member__c = fle.Member__c;
                        MemberCheck.add(fle.Member__c);
                        penalities.add(penalityArtist);

                    } //else {
                      //  penality.Member__c = fle.QCIncharge__c;
                      //  MemberCheck.add(fle.QCIncharge__c);
                    //}
                                               
                    penalities.add(penality);
                    FileCheck.add(fle.id);
                }
                
                //Remove the duplicate 
                List<Penalty_Assignment__c> CheckExs_penalty =[select id,Name,File_Name__c,Member__c,Member__r.User_id__c From Penalty_Assignment__c where Mistake_Id__c=:mist[0].id and File_Name__c IN :fileIdSet AND  Member__c IN :MemberCheck AND CreatedDate = TODAY ];                   
                if(penalities != null && penalities.size() > 0){
                    system.debug('*********** penalities :: ' + penalities);
                    upsert penalities;
                }                
                    
                
            } else {
                // No Points assigned for selected mistake category
                errorFlag=true;
                errorNoMistakeFlag = true;
            }
        
        
    }
    
    public PageReference Save() {        
        try{
            saveList(files,Mistake);
        }catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        //  After successful Save, navigate to the default view page        
        if(errorFlag==false){
            if(isSkipPenalty){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.EPMS_MBO_PENALITY_SKIP));
            } else { 
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.EPMS_MBO_PENALITY_ASSIGN));
            }    
            diableButton = true;
        }else if(errorNoMistakeFlag) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.EPMS_MBO_PENALITY_ASSIGN_NO_POINTS));
            diableButton = false; 
        }
        
        return null;
    }
    
    public void addPenaltyforArtist(){
        
    
    
    }
    
}