/**********************************************************************************
*   Class               :       EPMS_MyDirectoryQCcheckSearch_IT                  *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Controller to diaplay files related to QC         *
*   Modification        :       Job Title change option provided in QCCheck screen*
**********************************************************************************/ 
public without sharing class EPMS_MyDirectoryQCcheckSearch_IT{
    
    public String sortingChoice {get; set;}
    public String sortType {get;set;}
    public List<SelectOption> sortingoptions {get;set;}
    public List<SelectOption> sortingTypeoptions {get;set;}
    public string totalworktime{get;set;} 
    public string totalworktimeOld{get;set;}
    public string newcatcode{get;set;}
    public string newUpdatecatcode{get;set;}
    public string totalworktimeformat {get;set;}
    public string penaltycomments {get;set;}
    public boolean isSkipPenalty {get;set;}
    public boolean displaySearchWindow {get;set;}
    public Mistakes__c Mistake{get;set;}
    public boolean errorFlag {get;set;}
    public boolean displayErrorMes { get;set; }
    public boolean errorNoMistakeFlag {get;set;}
    public string qcCommentsForFilesForApprove {get; set;}
    public string qcCommentsForFilesRedo {get; set;}
    //public List<Bean> Files {get;set;}
    public List<id> FileIDsList         {get;set;}
    public boolean submitButton {get;set;}
    public String selectvalueCategory   {get;set;}
    public boolean submitButtonCat {get;set;}
    public Set<id> FileIDSetForInst     {get;set;}
    public Set<id> changeFileIDSet      {get;set;}
    public List<FileWrapper>  wrapperList {public get; public set;}
    public Boolean displayJobPopUp { get; set; }
    public String selectvalue           {get;set;}
    public String selectMistakeCategory {get;set;}
    public String selectMistake {get;set;}
    public String completeMsg           {get;set;}
    public Boolean displayPopup {get;set;}
    public boolean statusC  {get;set;}
    public boolean multiSelectError {get;set;}
    public boolean statusD  {get;set;}
    public String qcCommentsForFiles {get; set;}
    public boolean isImmediateUpload {get; set;}
    public boolean orderFiles {get;set;}
    public string parentId {get; set;}
    public Id ankenId {get;set;}
    public Id parentIdValue{get; set;}
    public Production_Order__c poObj = new Production_Order__c(); 
    List<Files__c> fileList = new List<Files__c>();
    public List<Files__c> filePopList;
    List<Id> Ids;
    public boolean diableButton{public get;set;}
    public boolean OnHoldCheck{public get;set;}
    public String searchvalue  {get;set;}
    public integer newFileForPageCount  {get; set;}
    public Id filememberId {get;set;}
    public String newCategoryGet {get;set;}
    public list<Penalty_Assignment__c> penalities = new list<Penalty_Assignment__c>();
    EPMS_ViewDirectoryService serviceObj = new EPMS_ViewDirectoryService();
    // Call the service : Production Order - View Directory
    EPMS_POViewDirectory_Service service = new EPMS_POViewDirectory_Service();
    EPMS_MyDirectory_Service Dirservice = new EPMS_MyDirectory_Service();
    EPMS_File_Assign_Penalty_Service penalityservice = new EPMS_File_Assign_Penalty_Service();
    
    public boolean displayChangeExt     {get;set;}
    
    private Integer OffsetSize = 0;
    private Integer QueryLimit = 50;
    private Integer OffsetSizeNew = 0;
    private Integer QueryLimitNew = 50;
    private Integer CountTotalRecords = 0;
    private Integer CountTotalRecordsNew = 0;
    public Long noOfPages {get; set;}
    public Integer oldPageNumber {get ; set ;}
    public Long currentPage {get; set;}
    public Integer setUserChoice { get; set; }
    public String orderID {
        get{
            String orderID = ApexPages.currentPage().getParameters().get('id');
            return orderID;
        }
        private set;
    }
    
    //public String Orderid{get;set;}
    public string ProductionOrderName{get;set;}
    public anken__c ankenquery{get;set;}
    public Production_Order__c POquery{get;set;}
    public list<WrapperFiles> FilesClassification{get;set;}
    public integer SumOfTotal{get;set;}
    public integer CompSumOfTotal{get;set;}
    public EPMS_AnkenService_Class ankenservice = new EPMS_AnkenService_Class();
    public map<string,list<Files__c> > catMap = new map<string,list<Files__c>>();
    transient public list<Files__c> catquery = new list<Files__c>();
    public set<String> filecat = new set<String>();
    public list<Files__c> filequery = new list<Files__c>();
    public list<String> listcat = new list<String>();
    //CR EPMSSF-520
    public boolean isCategoryModified {get;set;}    
    
    //EPMSSF-519
    public string MyProflieName {get;set;}
    
    //EPMSSF-513 Used in showJobTitlePopUp()
    List<Files__c> selList;    
    public List<String> selectedstringlistjoblisting;
    public string SelectedStringjoblisting;
    public boolean errorTypeFlag {get;set;}
    public list<Files__c> getFilesCheckedJobs;
    public List<Files__c> fileStatusList;
    public String[] EPMSJobList = new string[]{};
    // Used in UpdateObject
    String[] stringArray = new String[]{};
    public String jobListNames;
    
    public  list<string> voided;
    public set<String> avoiddup;
    public  list<String> Afteraplit;    
    
                    

    /*public void setselectvalueCategory(){
selectvalueCategory = this.selectvalueCategory;
}

public String getselectvalueCategory(){
return selectvalueCategory;
}*/
    
    //public EPMS_MyDirectoryQCcheck_clone1(ApexPages.StandardController controller)
    public EPMS_MyDirectoryQCcheckSearch_IT() {

        setUserChoice = 50;
        noOfPages = 1;
        currentPage = 1;
        oldPageNumber = 1;
        newFileForPageCount = 1;
        searchvalue='';
        //runSearch();
        errorFlag = false;
        errorNoMistakeFlag = false;
        diableButton = false;
        displaySearchWindow = false;
        displayErrorMes = false;
        orderFiles = true;
        statusC = false;
        statusD= false;
        submitButton = true;
        submitButtonCat = true;
        changeFileIDSet     = new Set<Id>();
        
        poObj = [SELECT Id,Name, Production_Order_TAT__c,Anken_Order__c  FROM Production_Order__c where Name = : orderID limit 1];
        parentId = poObj.Name;
        ankenId = poObj.Anken_Order__c;
        system.debug('Anken Id for selected production id is : ' + ankenId);
        parentIdValue = poObj.id;   
        
        OnHoldCheck=false;
        totalworktime = '';
        totalworktimeOld = '';
        newcatcode='';
        multiSelectError = false;
        totalworktimeformat = '';
        newUpdatecatcode = '';
        getFilesCheckedJobs = new list<Files__c>();
        if(orderID != null){
            // Files_To_open__c
            // File_PS_Version__c
            
            
            CountTotalRecords = Dirservice.getQCFilesCountRelatedToProductionOrder(parentIdValue);
            fileList = Dirservice.getQCFilesRelatedToProductionOrder(parentIdValue,QueryLimit,OffsetSize,sortingChoice,sortType,false);
        }  
        
        wrapperList = new List<FileWrapper>();
        
        String titleValues;
        for(Integer i =0; i<fileList.size(); i++ ){
            FileWrapper filewrpObj  = new FileWrapper();
            titleValues = '';           
            
            filewrpObj.fileWrap = fileList[i];
            filewrpObj.proOrderWrap = fileList[i].Production_Order__r;
            filewrpObj.catWrap = fileList[i].File_Category_Code__r;
            filewrpObj.jobTitles = fileList[i].File_Job_Titles__c;           
            filewrpObj.memWrap = fileList[i].Member__r;
            filewrpObj.memQCWrap = fileList[i].QCIncharge__r;
            String fileNameCopy = fileList[i].Name;
            filewrpObj.isCopyFile = fileNameCopy.contains('_copy');
            wrapperList.add(filewrpObj);
        }
        sortingoptions = new List<SelectOption>();
        sortingoptions.add(new SelectOption('Name','Name'));
        sortingoptions.add(new SelectOption('Status','Status')); 
        sortingoptions.add(new SelectOption('Operator','Operator')); 
        sortingoptions.add(new SelectOption('Category','Category')); 
        sortingoptions.add(new SelectOption('Extension','Extension'));       
        
        if(sortingoptions.size() > 0){
            sortingChoice = 'Name';
        }        
        sortingTypeoptions = new List<SelectOption>();
        sortingTypeoptions.add(new SelectOption('ASC','ASC'));
        sortingTypeoptions.add(new SelectOption('DESC','DESC'));       
        if(sortingTypeoptions.size() > 0){
            sortType = 'ASC';
        }
        
        
        if(wrapperList.size() > 0){
            displaySearchWindow = true;
        }
        
        orderFiles  = true ; 
        if(CountTotalRecords > setUserChoice){              
            Decimal pageCount = (Decimal.valueOf(CountTotalRecords) / Decimal.valueOf(setUserChoice));
            noOfPages = pageCount.round(System.RoundingMode.UP); 
        }else {
            noOfPages = 1;
        }       
        
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        MyProflieName = PROFILE[0].Name;
        system.debug('************ MyProflieName :: ' + MyProflieName);      
        
    }
    
    //View Directory(Menu) - Change Job Title(Button)
    List<Files__c> fileVDJobPopList;
    
    Set<String> setValForVD = new Set<String>();
    
    public STring testJobPopVar {get;set;}
    
    public void closePopup() {
        displayPopup = false;
    }
    
    public void closeJobTitlePopup() {
        displayJobPopUp = false;
    }
    
    public void cancel(){
        displayPopup = false;
    }
    
    
    List<Files__c> saveIntrodoeFileWithourtDirList;
    List<Files__c> tobeSavedIntroFileWithoutList;
    
    //ViewDirectory(Menu) - Open Directories(button) 
    List<Files__c> fileVDTLPopList;
    List<Files__c> fileVDTLPopListToUpdate;
    //ViewDirectory(Menu) - Open Files(button)
    List<Files__c> fileVDTLPopFilesList;
    List<Files__c> fileVDTLPopFilesListToUpdate;
    
    // View Directory(Menu) - Change Folder Instructions(Button)
    List<Files__c> fileVDPopList;
    List<Files__c> fileVDPopList1;
    List<Files__c> updateFileswithourDirList;
    
    //View Directory(Menu) - Change Folder Instructions(Button) - Submit(button in popup)
    
    //List<Files__c> saveVDPopList;
    //List<Files__c> saveVDDirFilesPopList;
    //List<Files__c> tobeUpdatedList;
    //List<Files__c> UpdateFileInsreuction;
    //List<Files__c> tobeUpdatedListForDirFiles;
    //List<Files__c> saveVDFileWithourDirPopList;
    //List<Files__c> ToBeUpdatedVDFileWithourDirPopList;
    
    
    public List<Shift_Assignments__c> teamIdListForQC= null;
    public List<Shift__c> shiftListForQC = new List<Shift__c>();
    public List<Team__c> teamNameListForQC= new List<Team__c>();
    public list<member__c> memlistForQC = new  list<member__c>();
    Set<Id> teamIdsForQC = new Set<Id>();
    Set<Id> MemteamIdsForQC = new Set<Id>();
    
    
    public with sharing class FileWrapper   {
        
        public Files__c fileWrap{ public get; public set; }
        public Production_Order__c proOrderWrap{public get; public set;}
        public File_Categories__c  catWrap{public get; public set;}
        public Member__c   memWrap{public get; public set;}
        public Member__c   memQCWrap{public get; public set;}
        public Boolean isSelected{get; set;}
        public String jobTitles{get;set;}
        public boolean isCopyFile {get;set;}
        
        public FileWrapper() {
            
            fileWrap = new Files__c();          
            proOrderWrap = new Production_Order__c();
            catWrap = new File_Categories__c ();
            memWrap = new Member__c();
            memQCWrap = new Member__c();
            isSelected = false;
            isCopyFile = false;
            
            
        }
    }
    
    
    
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('50','50'));
        options.add(new SelectOption('100','100'));
        options.add(new SelectOption('125','125')); 
        
        
        return options;
    }
    
    public Boolean getDisablePrevious(){
        if(OffsetSize>0){
            return false;
        }
        else return true;
    }
    
    public Boolean getDisableNext() {
        if (OffsetSize + QueryLimit < countTotalRecords){
            return false;
        }
        else return true;
    }
    
    
    
    public PageReference Next() {
        
        OffsetSize += QueryLimit;
        currentPage += 1;        
        newFileForPageCount+=1;
        getdisplayQCCheckFiles2();
        return null;
    }
    
    public PageReference Previous() {       
        OffsetSize -= QueryLimit;
        currentPage -= 1;
        newFileForPageCount -=1;
        getdisplayQCCheckFiles2();
        return null;
    }
    
    
    // Update the status 
    
    public void updateQCFileStatusCheck(){  
        List<Files__c> UpFileList = new List<Files__c> ();
        Set<Id> FileIDsList = new Set<Id>();
        Set<Id> directoryFileIdsList = new Set<Id>();
        List<Files__c> DirectoryFileList = new List<Files__c> ();
        List<Files__c> selectedFileList = new List<Files__c> ();
        List<Files__c> FileResultList = new List<Files__c> ();
        boolean errorStatus = false;
        boolean errorStatusDuplicate = false;
        boolean redoErrorStatus = false;
        boolean splitParentFileErrorStatus = false;
        if(wrapperList != null && wrapperList.size() > 0){
            if(!wrapperList.isEmpty()){
                
                for (Integer idx = 0; idx < wrapperList.size(); idx++) {
                    if (wrapperList[idx].isSelected) {
                        
                        selectedFileList.add(wrapperList[idx].fileWrap);
                    }
                }
            }
        }
        Set<Id> parentFileIdsSet = new Set<Id>();
        Set<Id> SplittedparentFileIdsSet = new Set<Id>();
        Map<Id, Decimal> totalParentsplitWorkTimeMap = new Map<Id, Decimal>();
        Map<Id, Decimal> finalSplittedChildMap = new Map<Id, Decimal>();
        Map<Id, Id> finalSplittedChildParentMap = new Map<Id, Id>();
        Set<Id> splitedmemberIds = new Set<Id>();
        Set<Id> splittedParentFile = new Set<Id>();
        Set<Id> finalSplittedChilds = new Set<Id>();
        if(selectedFileList!=null && selectedFileList.size() > 0){
            for(Files__c File :selectedFileList){
                
                if(File.Status__c == 'Approved' &&  isImmediateUpload){
                    errorStatus = true;
                    break;
                }
                
                if(File.Status__c == 'Redo Re-Assigned'){
                    redoErrorStatus = true;
                    break;
                }
                
                if(File.File_Type__c != 'Instruction'){
                    FileIDsList.add(File.Id);
                } 
                if(File.File_Type__c == 'Directory'){
                    directoryFileIdsList.add(File.Id);
                }
                
                /*if(File.IsSplitedFile__c==true && File.Status__c== 'On-Hold'){
splitParentFileErrorStatus = true;
break;
}*/
                
                if(File.File_Type__c == 'Image' && File.Splitted_Parent_id__c == null && File.IsSplitedFile__c==false && (File.File_Copy_Number__c == 0 || File.File_Copy_Number__c == null || String.isBlank(String.valueOf(File.File_Copy_Number__c)))){
                    parentFileIdsSet.add(File.Id);
                }
                
                if(File.IsSplitedFile__c==true)
                {
                    SplittedparentFileIdsSet.add(File.Id);
                    totalParentsplitWorkTimeMap.put(File.id,File.Total_work_time__c);
                    splitedmemberIds.add(File.Member__c);
                } 
                if(File.IsSplitedFile__c==false && File.Splitted_Parent_id__c != null)
                {
                    finalSplittedChilds.add(File.Splitted_Parent_id__c);
                    finalSplittedChildMap.put(File.Id, File.Total_Work_Time__c);
                    finalSplittedChildParentMap.put(File.Id, File.Splitted_Parent_id__c);
                } 
                /*else if(File.Splitted_Parent_id__c != null){
SplittedparentFileIdsSet.add(File.Splitted_Parent_id__c);
splitedmemberIds.add(File.Member__c);
}*/
            }
            
            if(redoErrorStatus){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_ASSIGN_OR_SKIP_REDO_REASSIGNED_FILES)); 
                return;
            }
            
            if(errorStatus){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_FILES_ALREADY_APPROVED_OR_UPLOADED)); 
                return;
            }
            
            if(errorStatusDuplicate){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_FILES_ALREADY_APPROVED)); 
                return;
            }
            
            
        }
        system.debug('INITIAL SET final : ' + finalSplittedChilds);
        system.debug('INITIAL MAP are Map: ' + finalSplittedChildMap);
        system.debug('INITIAL CHILD PARENT Files Relation Map: ' + finalSplittedChildParentMap);
        
        
        if(FileIDsList!= null && FileIDsList.size() > 0 ){            
            FileResultList = Dirservice.getQCFileDetailsForUpdate(FileIDsList);
        }
        
        
        if(directoryFileIdsList != null && directoryFileIdsList.size() > 0){   
            DirectoryFileList  = Dirservice.getQCChildFileDetailsForUpdate(directoryFileIdsList);
        } 
        
        List<Files__c> splitedFileUpdateList = new List<Files__c>();
        if(qcCommentsForFilesForApprove !=null)
        {
            if(FileResultList != null && FileResultList.size()>0){
                for(Files__c FileObj : FileResultList){ 
                    
                    if(isImmediateUpload){
                        // Set the File Status is IMMEDIATE UPLOAD
                        FileObj.Status__c = 'Approved';
                        FileObj.Immediate_File__c = isImmediateUpload;
                    } else {
                        // Set the File Status is Approved
                        //FileObj.QC_Comments__c = qcCommentsForFilesForApprove;
                        FileObj.Status__c = 'Approved';
                    }
                    // Update QC Comments for Approved
                    if(qcCommentsForFilesForApprove != null){
                        if(FileObj.QC_Comments__c != null){
                            FileObj.QC_Comments__c += ' ' +qcCommentsForFilesForApprove;
                        } else {
                            FileObj.QC_Comments__c = qcCommentsForFilesForApprove;
                        }    
                    }
                    
                    UpFileList.add(FileObj); 
                }
            }
            
            if(DirectoryFileList != null && DirectoryFileList.size()>0){
                for(Files__c FileObj : DirectoryFileList){ 
                    if(isImmediateUpload){
                        // Set the File Status is IMMEDIATE UPLOAD
                        FileObj.QC_Comments__c = qcCommentsForFilesForApprove;
                        FileObj.Status__c = 'Approved';
                        FileObj.Immediate_File__c=true;
                    } else {
                        // Set the File Status is Approved
                        FileObj.QC_Comments__c = qcCommentsForFilesForApprove;
                        FileObj.Status__c = 'Approved';
                    }
                    
                    UpFileList.add(FileObj); 
                }
            }
            Set<Files__c> newUpdatedSet = new Set<Files__c>();
            List<Files__c> finalUpdatedList = new List<Files__c>();
            
            if(splitedFileUpdateList != null && splitedFileUpdateList.size() > 0){
                try{
                    update splitedFileUpdateList;
                    System.debug(' Split Child Files - Total Work Time Updated Successfully : Approved Scenario ');
                }catch(Exception e){                    
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_STATUS_CHANGE_FAILED));                  
                    System.debug(' Split Child Files - Time Update Failed : ' + e.getMessage());
                }
            }
            
            
            if(UpFileList.size() > 0){
                for(Files__c newFile : UpFileList){
                    newUpdatedSet.add(newFile);
                }
                if(newUpdatedSet.size() > 0){
                    finalUpdatedList.addAll(newUpdatedSet);
                }
            }
            
            
            
            if(finalUpdatedList.size()>0 && finalUpdatedList !=null){
                try{
                    update finalUpdatedList;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_QC_CHECK_APPROVED_SUCCESS));
                    displayChangeExt = false;
                    submitButton = false;
                    
                }catch(Exception e){                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_STATUS_CHANGE_FAILED));                  
                }
            }else{            
                // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select File status'));           
            }
        }else{            
            // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select File status'));   
        }
    }
    
    // FOR CHANGE THE QC STATUS TO REDO
    
    public void updateQCFileStatusToRedo(){
        List<Files__c> UpFileList = new List<Files__c> ();
        Set<Id> FileIDsList = new Set<Id>();
        Set<Id> directoryFileIdsList = new Set<Id>();
        List<Files__c> DirectoryFileList = new List<Files__c> ();
        List<Files__c> selectedFileList = new List<Files__c> ();
        List<Files__c> FileResultList = new List<Files__c> ();
        boolean errorStatus = false;
        boolean errorStatusDuplicate = false;
        
        if(wrapperList != null && wrapperList.size() > 0){
            if(!wrapperList.isEmpty()){
                //filePopList  = new List<Files__c>();
                for (Integer idx = 0; idx < wrapperList.size(); idx++) {
                    if (wrapperList[idx].isSelected) {
                        selectedFileList.add(wrapperList[idx].fileWrap);
                    }
                }
            }
        }
        if(selectedFileList!=null && selectedFileList.size() > 0){
            for(Files__c File :selectedFileList){
                
                if(File.Status__c == 'Redo' ){
                    errorStatusDuplicate = true;
                    break;
                }
                
                if(File.Status__c == 'Approved' ){
                    errorStatus = true;
                    break;
                }
                
                if(File.File_Type__c != 'Instruction'){
                    FileIDsList.add(File.Id);
                } 
                
                if(File.File_Type__c == 'Directory'){
                    directoryFileIdsList.add(File.Id);
                }
                
            }
            
            if(errorStatus){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_ALREADY_APPROVED)); 
                return ;
            }
            
            if(errorStatusDuplicate){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_FILES_ALREADY_REDO_STATUS)); 
                displayPopup= false;
                errorFlag=true;
                return ;
            }
        }
        if(FileIDsList!= null && FileIDsList.size() > 0 ){            
            FileResultList = Dirservice.getQCFileDetailsForUpdate(FileIDsList);
        }
        
        if(directoryFileIdsList != null && directoryFileIdsList.size() > 0){   
            DirectoryFileList  = Dirservice.getQCChildFileDetailsForUpdate(directoryFileIdsList);
        }       
        
        
        if(qcCommentsForFilesRedo!=null)
        {
            if(FileResultList != null && FileResultList.size()>0){
                for(Files__c FileObj : FileResultList){ 
                    // Set the File Status is Redo
                    if(FileObj.QC_Comments__c != null){
                        FileObj.QC_Comments__c += '\n[REDO Comments : ' +qcCommentsForFilesRedo +'] ';
                    } else {
                        FileObj.QC_Comments__c = '\nREDO Comments : ' + qcCommentsForFilesRedo+'] ';
                    } 
                    
                    FileObj.Status__c = 'Redo';
                    UpFileList.add(FileObj); 
                }
            }
            if(DirectoryFileList != null && DirectoryFileList.size()>0){
                for(Files__c FileObj : DirectoryFileList){ 
                    // Set the File Status is Redo
                    if(FileObj.Status__c != 'Approved') {
                        FileObj.QC_Comments__c = qcCommentsForFilesRedo;
                        FileObj.Status__c = 'Redo';
                    }
                    UpFileList.add(FileObj); 
                }
            }
            Set<Files__c> newUpdatedSet = new Set<Files__c>();
            List<Files__c> finalUpdatedList = new List<Files__c>();
            
            if(UpFileList.size() > 0){
                for(Files__c newFile : UpFileList){
                    newUpdatedSet.add(newFile);
                }
                if(newUpdatedSet.size() > 0){
                    finalUpdatedList.addAll(newUpdatedSet);
                }
            }
            if(finalUpdatedList.size()>0){
                try{
                    update finalUpdatedList;
                    displayChangeExt = false;
                    submitButton = false;
                    
                }catch(Exception e){                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_STATUS_CHANGE_FAILED));                  
                }
            }else{            
                //  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select File status'));           
            }
        }else{            
            // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select File status'));   
        }
        //return completeMsg;
    }
    
    public void changeCategory(){
        displayChangeExt = true;
        completeMsg = null;
        
        String files=Apexpages.currentPage().getParameters().get('fileCategoryId');
        List<id> FileIDsList=new List<id>();
        
        Files__c filequery = new files__c();
        
        
        
        
    }
    
    public void getCategoryForInputTime(){
        displayChangeExt = true;
        system.debug('Input Time Entered : Category ' + totalworktime);
        
        Member__c member = null;
        List<Performance_Rating__c> ratingdetails2 = new List<Performance_Rating__c>();
        if(filememberId != null && totalworktime != ''){
            system.debug('File Member Name is : ' + filememberId);
            member = [SELECT Id, Name, Performance_Rating__r.Name FROM Member__c WHERE Id =: filememberId];
            Decimal totalsecs = Decimal.valueOf(totalworktime);
            Decimal mins = 0.0;
            Decimal totalmins = 0.0;
            if(totalsecs != null){
                mins = totalsecs/60;            
                totalmins = mins.setscale(2);
            }
            if(member != null){
                Decimal minval ;
                Decimal maxval ;
                String perfgroup = member.Performance_Rating__r.Name;
                ratingdetails2 = [Select id,Name,File_Category__c,File_Category__r.name,File_Performance_Stf_Min__c,File_Performance_Stf_Max__c,File_Category__r.Standard_Time_per_File_Min__c,File_Category__r.Standard_Time_per_File_Max__c from Performance_Rating__c where Name=: perfgroup];
                
                for(Performance_Rating__c PR :ratingdetails2)
                {
                    if(perfgroup != null && perfgroup == PR.Name){
                        minval = PR.File_Performance_Stf_Min__c;
                        maxval = PR.File_Performance_Stf_Max__c;
                        
                        if(totalmins>=minval){
                            if(totalmins<=maxval){
                                selectvalueCategory = PR.File_Category__r.Name;
                                newCategoryGet =  PR.File_Category__r.Id;
                            }
                        }
                    }
                }
                
            }
        } 
        /*
if(newCategoryGet != null){
selectvalueCategory = newCategoryGet;
}*/
        system.debug(' Category for Input Time Entered : ' + selectvalueCategory);
        system.debug(' Category Id : ' + newCategoryGet);
    }
    
    public void UpdateCategory(){
        displayChangeExt = true;
        
        if(multiSelectError){
            multiSelectError = false;
        }
        
        List<Files__c> selectedFileList = new List<Files__c> ();
        Set<Id> selectedFileIdsForUpdate = new Set<Id>();
        if(wrapperList != null && wrapperList.size() > 0){
            if(!wrapperList.isEmpty()){
                for (Integer idx = 0; idx < wrapperList.size(); idx++) {
                    if (wrapperList[idx].isSelected) {
                        selectedFileList.add(wrapperList[idx].fileWrap);
                    }
                }
            }
        }
        Id fileId = null;
        
        if(selectedFileList != null && selectedFileList.size() > 0){
            if(selectedFileList.size() > 1){
                //multiSelectError = true;
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select One File to update category.'));
                //return;
            } 
            for(Files__c file : selectedFileList){
                selectedFileIdsForUpdate.add(file.Id);
                //fileId = file.Id;
                //break;
            }
            
        }
        
        if(fileId != null){
            Files__c filequery = [select id,name,File_Category_Code__c,Total_WorkTime_for_File__c,File_Category_Code__r.Name,Total_Work_Time__c,Member__c from Files__c where id=:fileId];
            String workTimeStr = string.valueOf(filequery.Total_Work_Time__c);
            if(workTimeStr != null){
                totalworktimeOld=string.valueOf(filequery.Total_Work_Time__c) + ' ( ' + filequery.Total_WorkTime_for_File__c + ' )';
            } else {
                totalworktimeOld= '';
            }
            
            totalworktimeformat = filequery.Total_WorkTime_for_File__c;
            newcatcode=filequery.File_Category_Code__r.Name;
            filememberId = filequery.Member__c;
            system.debug('File Member is :: ' + filememberId);
        }
        
        
    }
    
    public void saveChangeCategory(){
        
        //if(String.isBlank(selectvalueCategory) && String.isBlank(totalworktime)){
        if(String.isBlank(selectvalueCategory) || selectvalueCategory == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the category to update a File.'));
            return;
        }
        system.debug('---- SELECTED CATEGORY -----' + selectvalueCategory);
        /*if(!String.isBlank(selectvalueCategory) && !String.isBlank(totalworktime)){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Either Work Time (or) Category for File.'));
return;
}*/
        
        /*if(String.isBlank(totalworktime)){
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter the Work Time for File.'));
return;
}*/
        
        system.debug(' Selected Category is : ' + selectvalueCategory);  
        List<Files__c> selectedFileList = new List<Files__c> ();
        Set<Id> selectedFileIdsForUpdate = new Set<Id>();
        if(wrapperList != null && wrapperList.size() > 0){
            if(!wrapperList.isEmpty()){
                for (Integer idx = 0; idx < wrapperList.size(); idx++) {
                    if (wrapperList[idx].isSelected) {
                        selectedFileList.add(wrapperList[idx].fileWrap);
                    }
                }
            }
        }
        
        
        Integer newWorkTime = 0;
        Id fileId = null;
        Set<Id> fileMemberIds = new Set<Id>();
        
        if(selectedFileList != null && selectedFileList.size() > 0){
            for(Files__c file : selectedFileList){
                selectedFileIdsForUpdate.add(file.Id);
                fileMemberIds.add(file.Member__c);
                
                fileId = file.Id;
                //break;
            }
            
        }  
        
        List<Performance_Rating__c> ratingdetails = new List<Performance_Rating__c>();
        Files__c fileInfo = null;
        List<Member__c> memberGroupList = null;
        Map<Id, String> memberPerGroupMap = new Map<Id, String>();
        Set<String> catGroupSet = new Set<String>();
        Map<String,Decimal> timingMap = new Map<String,Decimal>();
        if(fileMemberIds != null && fileMemberIds.size() > 0){
            //File_Performance_Stf_Max__c
            memberGroupList = [SELECT Id, Name, Performance_Rating__r.Name FROM Member__c WHERE Id IN: fileMemberIds];
            
            if(memberGroupList != null && memberGroupList.size() > 0){
                for(Member__c member : memberGroupList){
                    system.debug(' Member Group is : ' + member);
                    memberPerGroupMap.put(member.Id, member.Performance_Rating__r.Name);
                    catGroupSet.add(member.Performance_Rating__r.Name);
                }
            }
            if(catGroupSet != null && catGroupSet.size() > 0){
                ratingdetails = [Select id,Name,File_Category__c,File_Category__r.name,File_Performance_Stf_Min__c,File_Performance_Stf_Max__c,File_Category__r.Standard_Time_per_File_Min__c,File_Category__r.Standard_Time_per_File_Max__c from Performance_Rating__c where Name IN: catGroupSet AND File_Category__c =: selectvalueCategory];
                
                if(ratingdetails != null && ratingdetails.size() > 0){
                    for(Performance_Rating__c performanceRate : ratingdetails){
                        system.debug('---- Per Record is : ' + performanceRate);
                        timingMap.put(performanceRate.Name,performanceRate.File_Performance_Stf_Max__c);
                    }
                }
            }
        }
        
        system.debug('---- FINAL Map is : ' + timingMap);
        
        /*
if(fileId != null && selectvalueCategory == null){
fileInfo = [SELECT Id, Name, Member__c, Member__r.Performance_Rating__r.Name FROM Files__c WHERE Id=:fileId];

if(fileInfo != null && totalworktime != null){
String memberPName = fileInfo.Member__r.Performance_Rating__r.Name;
Decimal totalsecs = Decimal.valueOf(totalworktime);
Decimal mins = 0.0;
Decimal totalmins = 0.0;
if(totalsecs != null){
mins = totalsecs/60;            
totalmins = mins.setscale(2);
}

Decimal minval ;
Decimal maxval ;

ratingdetails = [Select id,Name,File_Category__c,File_Category__r.name,File_Performance_Stf_Min__c,File_Performance_Stf_Max__c,File_Category__r.Standard_Time_per_File_Min__c,File_Category__r.Standard_Time_per_File_Max__c from Performance_Rating__c where Name=: memberPName];

for(Performance_Rating__c PR :ratingdetails)
{
if(memberPName != null && memberPName == PR.Name){
minval = PR.File_Performance_Stf_Min__c;
maxval = PR.File_Performance_Stf_Max__c;

if(totalmins>=minval){
if(totalmins<=maxval){
selectvalueCategory = PR.File_Category__c;

}
}
}
}



}
}*/
        
        completeMsg =null;  
        List<Files__c> FileList = new List<Files__c> ();        
        List<Files__c> UpFileList = new List<Files__c> ();
        
        if(selectedFileIdsForUpdate != null && selectedFileIdsForUpdate.size() > 0){            
            FileList  = Dirservice.getFileInstructionDetails(selectedFileIdsForUpdate);
            
        }else{   
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_PLEASE_SELECT_CATEGORY_CODE));           
        }       
        
        if(selectvalueCategory!=null)
        {
            if(FileList != null && FileList.size()>0){
                for(Files__c FileObj : FileList){
                    //FileObj.File_Category_Code__c = selectvalueCategory;
                    /*if(newCategoryGet == selectvalueCategory){
FileObj.File_Category_Code__c = newCategoryGet;
} else {*/
                    FileObj.File_Category_Code__c = selectvalueCategory;
                    /* CR EPMSSF-520 Start */
                    FileObj.Category_Modified__c = true;
                    isCategoryModified = true;
                    /* CR EPMSSF-520 End */
                    
                    //}
                    //if(!String.isBlank(totalworktime)){
                    //    FileObj.Total_Work_Time__c = Decimal.valueOf(totalworktime);
                    //}
                    if(timingMap != null && timingMap.size() > 0){
                        if(memberPerGroupMap != null && memberPerGroupMap.size() > 0){
                            String memberGroupCat = memberPerGroupMap.get(FileObj.Member__c);
                            if(memberGroupCat != null){
                                Decimal highTimeForCategory = timingMap.get(memberGroupCat);
                                if(highTimeForCategory != null){
                                    Decimal totalTimeForFile = highTimeForCategory * 60;
                                    system.debug('[ FINAL TIMING ]File Name :' + FileObj.Name + ' Group : ' + memberGroupCat + ' Time : ' + totalTimeForFile);
                                    FileObj.Total_Work_Time__c = totalTimeForFile;
                                }
                            }
                            
                        }
                        
                    }
                    
                    UpFileList.add(FileObj); 
                    
                }
            }
            
            if(UpFileList.size()>0){
                try{
                    
                    update UpFileList;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_QC_CHECK_CHANGED_CATEGORY_SUCCESS));
                    displayChangeExt = false;
                    submitButtonCat  = false; 
                }catch(Exception e){                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_CATEGORY_CHANGE_FAILED));                  
                }
            }else{            
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_PLEASE_SELECT_CATEGORY_CODE));           
            }
        }else{            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_PLEASE_SELECT_CATEGORY_CODE));   
        }
    }
    
    // Selection option fileCategory list
    public List<SelectOption> getAllFileCategory(){     
        List <SelectOption> options  = new List<SelectOption>();
        
        
        /* if(selectvalueCategory != null)
{
options.add(new SelectOption(newCategoryGet,selectvalueCategory));
for(File_Categories__c fileCat: Dirservice.getFileCategoryList()){
if(selectvalueCategory != fileCat.Name){
options.add(new SelectOption(fileCat.Id,fileCat.Name));
}
}  
}else{*/
        options.add(new SelectOption('','--Select Category--'));
        for(File_Categories__c fileCat: Dirservice.getFileCategoryList()){
            options.add(new SelectOption(fileCat.Id,fileCat.Name));
        }
        // }
        return options;
    }
    
    
    public List<SelectOption> getAllMistakeCategory(){
        
        List <SelectOption> options  = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));         
        Schema.DescribeFieldResult fieldResult = Mistakes__c.MIstake_Category__c.getDescribe();        
        for( Schema.PicklistEntry f : fieldResult.getPicklistValues())
        {
            options.add(new SelectOption(f.getValue(), f.getValue()));
        }
        return options;
    }   
    
    public List<SelectOption> getAllMistake(){
        
        List <SelectOption> options  = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        if(selectMistakeCategory=='COMMON MISTAKES'){
            options.add(new SelectOption('Combine Not Done Properly','Combine Not Done Properly'));
            options.add(new SelectOption('Holes Remaining','Holes Remaining'));
            options.add(new SelectOption('Image Depth Cut','Image Depth Cut'));
            options.add(new SelectOption('Path Is Not Exactly On The Edge','Path Is Not Exactly On The Edge'));
            options.add(new SelectOption('More Anchor Points','More Anchor Points'));
            options.add(new SelectOption('Incorrect Path','Incorrect Path'));
            options.add(new SelectOption('Clipped Unnaturally','Clipped Unnaturally'));
            options.add(new SelectOption('Missing Fundamental','Missing Fundamental'));  
            options.add(new SelectOption('Others','Others'));        
            
        }
        else if(selectMistakeCategory=='SERIOUS MISTAKES'){
            options.add(new SelectOption('No Path','No Path'));
            options.add(new SelectOption('Path Incompleted','Path Incompleted'));
            options.add(new SelectOption('Path Name Displaced','Path Name Displaced'));
            options.add(new SelectOption('Path Duplicated','Path Duplicated'));
            options.add(new SelectOption('Combine Not Done Properly','Combine Not Done Properly'));
            options.add(new SelectOption('Others','Others'));           
        } else if(selectMistakeCategory=='VERY SERIOUS MISTAKE'){
            options.add(new SelectOption('Instruction Not Followed','Instruction Not Followed'));
            options.add(new SelectOption('Procedure Not Followed','Procedure Not Followed'));
            options.add(new SelectOption('Image Colour Changed','Image Colour Changed'));
            options.add(new SelectOption('File Renamed','File Renamed'));
            options.add(new SelectOption('Image or Mask Damaged','Image or Mask Damaged'));
            Options.add(new SelectOption('Path Stroke','Path Stroke'));           
            options.add(new SelectOption('Image Replaced','Image Replaced'));
            options.add(new SelectOption('Others','Others')); 
        }  else if(selectMistakeCategory=='OTHERS'){
            options.add(new SelectOption('Others','Others'));
        }
        
        return options;
    }
    
    public List<SelectOption> getAllFileStatus(){
        
        List <SelectOption> options  = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));         
        Schema.DescribeFieldResult fieldResult = Files__c.Status__c.getDescribe();        
        for( Schema.PicklistEntry f : fieldResult.getPicklistValues())
        {
            if(f.getValue() == 'QC' || f.getValue() == 'Approved' || f.getValue() == 'On-Hold' || f.getValue() == 'Redo'){
                options.add(new SelectOption(f.getValue(), f.getValue()));
            }
        }
        return options;
    }   
    
    public void changeStatus(){
        
        
        displayChangeExt = true;
        completeMsg = null;
        List<id> FileIDsList=new List<id>();
        String files=Apexpages.currentPage().getParameters().get('fileStatusId');
    }
    
    public void saveChangeStatus(){            
        
        List<Files__c> selectedFileList = new List<Files__c> ();
        Set<Id> selectedFileIdsForUpdate = new Set<Id>();
        boolean statusErrorQCIP = false;
        if(wrapperList != null && wrapperList.size() > 0){
            if(!wrapperList.isEmpty()){
                for (Integer idx = 0; idx < wrapperList.size(); idx++) {
                    if (wrapperList[idx].isSelected) {
                        if(wrapperList[idx].fileWrap.Status__c != Label.EPMS_FileStatus_QCIP && wrapperList[idx].fileWrap.Status__c != Label.EPMS_FileStatus_Redo_Re_Assigned){
                            statusErrorQCIP = true;
                            break;
                        }
                        selectedFileList.add(wrapperList[idx].fileWrap);
                    }
                }
                if(statusErrorQCIP){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected File(s) is not in QCIP or Redo Re-Assigned Status')); 
                    return;
                }
                
            }
        }
        
        
        if(selectedFileList != null && selectedFileList.size() > 0){
            for(Files__c file : selectedFileList){
                selectedFileIdsForUpdate.add(file.Id);
            }
            
        }
        
        completeMsg =null;             
        List<Files__c> FileList = new List<Files__c> ();        
        List<Files__c> UpFileList = new List<Files__c> ();
        
        
        if(selectedFileIdsForUpdate != null && selectedFileIdsForUpdate.size() > 0){            
            FileList  = Dirservice.getFileInstructionDetails(selectedFileIdsForUpdate);
        }else{   
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_PLEASE_SELECT_FILE_STATUS));           
        }       
        
        
        
        if(selectvalue!=null)
        {
            if(FileList != null && FileList.size()>0){
                for(Files__c FileObj : FileList){                    
                    FileObj.Status__c = selectvalue;
                    UpFileList.add(FileObj); 
                }
            }
            
            if(UpFileList.size()>0){
                try{
                    update UpFileList;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_QC_CHECK_FILES_STATUS_CHANGED));
                    displayChangeExt = false;
                    submitButton = false;
                    
                }catch(Exception e){                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_STATUS_CHANGE_FAILED));                  
                }
            }else{            
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_PLEASE_SELECT_STATUS));           
            }
        }else{            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_PLEASE_SELECT_STATUS));   
        }
    }   
    
    // To Change the File status to Checked
    public void updateQCFileStatusToChecked(){
        List<Files__c> UpFileList = new List<Files__c> ();
        Set<Id> FileIDsList = new Set<Id>();
        List<Files__c> DirectoryFileList = new List<Files__c> ();
        Set<Id> directoryFileIdsList = new Set<Id>();
        List<Files__c> selectedFileList = new List<Files__c> ();
        List<Files__c> FileResultList = new List<Files__c>();
        boolean errorStatus = false;
        boolean errorStatusDuplicate = false;
        
        if(wrapperList != null && wrapperList.size() > 0){
            if(!wrapperList.isEmpty()){
                for (Integer idx = 0; idx < wrapperList.size(); idx++) {
                    if (wrapperList[idx].isSelected) {
                        selectedFileList.add(wrapperList[idx].fileWrap);
                    }
                }
            }
        }
        
        Set<Id> SplittedparentFileIdsSet = new Set<Id>();
        Map<Id, Decimal> totalParentsplitWorkTimeMap = new Map<Id, Decimal>();
        Set<Id> splitedmemberIds = new Set<Id>();
        Set<Id> splittedParentFile = new Set<Id>();
        
        if(selectedFileList!=null && selectedFileList.size() > 0){
            for(Files__c File :selectedFileList){
                
                if(File.Status__c == 'On-Hold' ){
                    errorStatusDuplicate = true;
                    break;
                }
                
                
                if(File.Status__c == 'Approved' ){
                    errorStatus = true;
                    break;
                }
                
                if(File.File_Type__c != 'Instruction'){
                    FileIDsList.add(File.Id);
                } 
                
                if(File.File_Type__c == 'Directory'){
                    directoryFileIdsList.add(File.Id);
                }
                
                if(File.IsSplitedFile__c==true)
                {
                    SplittedparentFileIdsSet.add(File.Id);
                    totalParentsplitWorkTimeMap.put(File.id,File.Total_work_time__c);
                    splitedmemberIds.add(File.Member__c);
                } 
                /*else if(File.Splitted_Parent_id__c != null){
SplittedparentFileIdsSet.add(File.Splitted_Parent_id__c);
splitedmemberIds.add(File.Member__c);
}*/
                
                
                
            }
            
            if(errorStatusDuplicate){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_ALREADY_ON_HOLD )); 
                displayPopup= false;
                errorFlag=true;
                return ;
            }
            
            if(errorStatus){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_ALREADY_APPROVED)); 
                return ;
            }
        }
        
        if(FileIDsList!= null && FileIDsList.size() > 0 ){            
            FileResultList = Dirservice.getQCFileDetailsForUpdate(FileIDsList);
            
        }
        
        if(directoryFileIdsList != null && directoryFileIdsList.size() > 0){   
            DirectoryFileList  = Dirservice.getQCChildFileDetailsForUpdate(directoryFileIdsList);         
        }       
        
        List<Files__c> splitedFileUpdateList = new List<Files__c>();
        
        if(qcCommentsForFiles!=null)
        {
            if(FileResultList != null && FileResultList.size()>0){
                for(Files__c FileObj : FileResultList){ 
                    // Set the File Status is Checked
                    if(qcCommentsForFiles != null){
                        FileObj.QC_Comments__c = qcCommentsForFiles;                    
                    }
                    FileObj.Status__c = 'On-Hold';
                    UpFileList.add(FileObj); 
                }
            }
            
            
            Set<Files__c> newUpdatedSet = new Set<Files__c>();
            List<Files__c> finalUpdatedList = new List<Files__c>();
            
            if(UpFileList.size() > 0){
                for(Files__c newFile : UpFileList){
                    newUpdatedSet.add(newFile);
                }
                if(newUpdatedSet.size() > 0){
                    finalUpdatedList.addAll(newUpdatedSet);
                }
            }
            
            
            if(finalUpdatedList.size()>0){
                try{
                    update finalUpdatedList;
                    displayChangeExt = false;
                    submitButton = false;
                    
                }catch(Exception e){                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_STATUS_CHANGE_FAILED));                  
                }
            }else{            
                // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select File status'+qcCommentsForFiles));           
            }
        }
        else{            
            //  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select File status 2'+qcCommentsForFiles));   
        }
    }
    
    public Boolean getDisablePreviousNew(){
        if(OffsetSizeNew>0){
            return false;
        }
        else return true;
    }
    
    public Boolean getDisableNextNew() {
        if (OffsetSizeNew + QueryLimitNew < countTotalRecordsNew){
            return false;
        }
        else return true;
    }
    
    public PageReference NextNew() {
        OffsetSizeNew += QueryLimitNew;
        return null;
    }
    
    public PageReference PreviousNew() {
        OffsetSizeNew -= QueryLimitNew;
        return null;
    }
    
    
    public PageReference runSearch() {
        
        List<Files__c> fileListTest = new List<Files__c>();
        
        try{
            
            
            if(!String.isBlank(searchvalue)){
                String  queryString = '%'+ searchvalue +'%';        
                // 
                fileListTest = [Select id, Name, QC_Comments__c, Current_Extension__c, Files_To_open__c, File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c,QCIncharge__c,QCIncharge__r.Name  from Files__c where Production_Order__r.Name =:orderID AND Status__c IN ('QCIP','On-Hold','Redo','Redo Re-Assigned') AND File_Type__c='Image' AND Name LIKE : queryString Order by Name];
                
                wrapperList = new List<FileWrapper>();
                
                String titleValues;
                if(fileListTest != null && fileListTest.size() > 0){
                    countTotalRecords = fileListTest.size();
                    if(countTotalRecords > setUserChoice){
                        //noOfPages = CountTotalRecords / setUserChoice;  
                        Decimal pageCount = (Decimal.valueOf(countTotalRecords) / Decimal.valueOf(setUserChoice));
                        noOfPages = pageCount.round(System.RoundingMode.UP); 
                        
                    } else {
                        noOfPages = 1;
                    }
                    for(Integer i =0; i<fileListTest.size(); i++ ){
                        FileWrapper filewrpObj  = new FileWrapper();
                        titleValues = '';      
                        filewrpObj.fileWrap = fileListTest[i];
                        filewrpObj.proOrderWrap = fileListTest[i].Production_Order__r;
                        filewrpObj.catWrap = fileListTest[i].File_Category_Code__r;
                        filewrpObj.jobTitles = fileListTest[i].File_Job_Titles__c;           
                        filewrpObj.memWrap = fileListTest[i].Member__r;
                        filewrpObj.memQCWrap = fileListTest[i].QCIncharge__r;
                        String fileNameCopy = fileListTest[i].Name;
                        filewrpObj.isCopyFile = fileNameCopy.contains('_copy');
                        wrapperList.add(filewrpObj);
                    }
                    if(wrapperList.size() > 0){
                        displaySearchWindow = true;
                        //getdisplayQCCheckFiles2();
                    }
                } else{
                    
                    displayErrorMes = true; 
                    displaySearchWindow  = true;
                }
                
                
            } else {
                
                CountTotalRecords = Dirservice.getQCFilesCountRelatedToProductionOrder(parentIdValue);
                getdisplayQCCheckFiles2();
            }
        } catch(Exception e){
            
            system.debug('MyDirectory QC Check Screen Exception Throws: '  + e.getMessage());
        }
        return null;   
        
        
    }
    
    
    
    // save penalty
    public void saveList(String selectMistakeCategory,String selectMistake,String penaltycomments,boolean isSkipPenalty){
        List<Mistakes__c> mist = new List<Mistakes__c>();
        Set<Id> FileCheck =new Set<Id>();
        Set<Id> MemberCheck =new Set<Id>();
        
        errorFlag=false;
        
        List<Files__c> selectedFileList = new List<Files__c> ();
        Set<Id> selectedFileIdsForUpdate = new Set<Id>();
        if(wrapperList != null && wrapperList.size() > 0){
            if(!wrapperList.isEmpty()){
                for (Integer idx = 0; idx < wrapperList.size(); idx++) {
                    
                    if (wrapperList[idx].isSelected) {
                        selectedFileList.add(wrapperList[idx].fileWrap);
                    }
                }
            }
        }
        
        
        Id fileLocation = null;
        boolean checkedFile = false;
        boolean qcipFile = false;
        if(selectedFileList != null && selectedFileList.size() > 0){
            fileLocation = selectedFileList[0].File_Location__c;
            for(Files__c file : selectedFileList){
                selectedFileIdsForUpdate.add(file.Id);
                if(file.Status__c == 'On-Hold'){
                    checkedFile = true;
                    break;
                }
                if(file.Status__c == 'QCIP'){
                    qcipFile = true;
                    break;
                }    
            }
            
        }
        
        if(checkedFile){
            errorFlag=true;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.EPMS_MBO_QC_CHECK_ON_HOLD_FILES_NO_PENALITY));
            return;
        }
        
        if(qcipFile){
            errorFlag=true;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,'QCIP Files cannot assign penality'));
            return;
        }
        
        if(selectMistakeCategory == null ){
            errorFlag=true;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.EPMS_MBO_PENALTY_SELECT_MISTAKE_TYPE));
            return;
        }
        if(selectMistakeCategory != null && selectMistake == null){
            errorFlag=true;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.EPMS_MBO_PENALTY_SELECT_MISTAKE));
            return;
        }else{                
            mist = penalityservice.getMistakeInformation(selectMistakeCategory, selectMistake, fileLocation); // files[0].File_Location__c
        }           
        
        
        if(!mist.isEmpty() && mist != null){
            
            List<Penalty_Assignment__c> existPenaltyList = [select id,Name,File_Name__c,Member__c,Mistake_Id__c,Penalty_Assignment_Time__c,Member_Location__c from Penalty_Assignment__c where File_Name__c IN:selectedFileIdsForUpdate and Mistake_Id__c=:mist[0].id ];     
            List<Files__c> updateFileList = new List<Files__c>();       
            List<Files__c> FileList  = Dirservice.getFileInstructionDetails(selectedFileIdsForUpdate);  
            
            if(FileList != null && FileList.size() > 0){
                for(Files__c  fle:FileList){                    
                    Penalty_Assignment__c penality = new Penalty_Assignment__c();
                    penality.File_Name__c = fle.id;
                    penality.Member__c = fle.Member__c;
                    penality.Mistake_Id__c =mist[0].id;
                    penality.Penalty_Assignment_Time__c = system.now();
                    penality.Member_Location__c = fle.File_Location__c;
                    penality.Comments__c=penaltycomments;
                    penality.Is_Skipped_File__c = isSkipPenalty;
                    penalities.add(penality);
                    FileCheck.add(fle.id);
                    fle.Tracker_handover__c = true;
                    fle.Status__c = 'On-Hold';
                    updateFileList.add(fle);
                    MemberCheck.add(fle.Member__c);
                }
            }
            
            //Remove the duplicate 
            List<Penalty_Assignment__c> CheckExs_penalty =[select id,Name,File_Name__c,Member__c From Penalty_Assignment__c where Mistake_Id__c=:mist[0].id and File_Name__c IN :selectedFileIdsForUpdate AND  Member__c IN :MemberCheck AND CreatedDate = TODAY ];                   
            if(penalities != null && penalities.size() > 0){
                insert penalities;
            }                
            
            if(updateFileList != null && updateFileList.size() > 0){
                update updateFileList;
            }   
            
        } else {
            // No Points assigned for selected mistake category
            errorFlag=true;
            errorNoMistakeFlag = true;
        }
        
        
    }
    
    public PageReference Save() {
        
        
        
        try{
            saveList(selectMistakeCategory,selectMistake,penaltycomments,isSkipPenalty);
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
            isSkipPenalty = false;
            penaltycomments = null;
            selectMistake = null;
            selectMistakeCategory =null;
        }else if(errorNoMistakeFlag) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.EPMS_MBO_PENALITY_ASSIGN_NO_POINTS));
            diableButton = false; 
        }
        
        return null;
    }
    
    public void getdisplayQCCheckFiles2(){
        fileList = new List<Files__c>();
        //List<Files__c> newfileList = new List<Files__c>();       
        if(CountTotalRecords > setUserChoice){
            //noOfPages = CountTotalRecords / setUserChoice;  
            Decimal pageCount = (Decimal.valueOf(CountTotalRecords) / Decimal.valueOf(setUserChoice));
            noOfPages = pageCount.round(System.RoundingMode.UP); 
        } else {
            noOfPages = 1;
        }
        
        
        if(orderID != null){
            
            if(setUserChoice == 0 && setUserChoice ==null)
            {
                fileList = Dirservice.getQCFilesRelatedToProductionOrder(parentIdValue,QueryLimit,OffsetSize,sortingChoice,sortType,OnHoldCheck);
                
            }
            else{
                QueryLimit = setUserChoice;
                fileList = Dirservice.getQCFilesRelatedToProductionOrder(parentIdValue,QueryLimit,OffsetSize,sortingChoice,sortType,OnHoldCheck);
            }       
            
        }  
        
        wrapperList = new List<FileWrapper>();
        
        
        String titleValues;
        for(Integer i =0; i<fileList.size(); i++ ){
            FileWrapper filewrpObj  = new FileWrapper();
            titleValues = '';           
            
            filewrpObj.fileWrap = fileList[i];
            filewrpObj.proOrderWrap = fileList[i].Production_Order__r;
            filewrpObj.catWrap = fileList[i].File_Category_Code__r;
            filewrpObj.jobTitles = fileList[i].File_Job_Titles__c;           
            filewrpObj.memWrap = fileList[i].Member__r;
            filewrpObj.memQCWrap = fileList[i].QCIncharge__r;
            String fileNameCopy = fileList[i].Name;
            filewrpObj.isCopyFile = fileNameCopy.contains('_copy');
            wrapperList.add(filewrpObj);
        }
        
    }
    
    public pageReference refresh() {
        
        OffsetSize=0;
        getdisplayQCCheckFiles2();       
        newFileForPageCount = 1;
        return null;
    }
    
    public pageReference refreshPageRecords(){
        
        if(newFileForPageCount == 0){
            
            newFileForPageCount = 1;
            OffsetSize = 0;
            oldPageNumber = 1;
            getdisplayQCCheckFiles2();
            return null;
        }
        
        if(newFileForPageCount > noOfPages){ 
            newFileForPageCount = Integer.valueOf(noOfPages);
            OffsetSize = (Integer.valueOf(noOfPages) * QueryLimit) - QueryLimit;           
            oldPageNumber = Integer.valueOf(newFileForPageCount);
            getdisplayQCCheckFiles2();
            return null;
        }
        
        if(oldPageNumber < Integer.valueOf(newFileForPageCount)){   
            
            Integer diff = Integer.valueOf(newFileForPageCount) - oldPageNumber ;
            OffsetSize += (QueryLimit * diff);
        } else {          
            if(newFileForPageCount == 0){                 
                newFileForPageCount = 1;
                OffsetSize = 0;
                getdisplayQCCheckFiles2();
                return null;
            }           
            Integer diff = oldPageNumber - Integer.valueOf(newFileForPageCount) ;           
            if(diff == 0){
                OffsetSize -= QueryLimit;
            } else {
                OffsetSize -= (QueryLimit * diff) ;
            }           
        }
        oldPageNumber =  Integer.valueOf(newFileForPageCount);        
        if(OffsetSize < 0){            
            offsetSize *= (-1 * Integer.valueOf(newFileForPageCount));          
        }
        getdisplayQCCheckFiles2();       
        return null;
    }
    
    public void test_Merge_Files_Copy_and_Split(){
        
        // Retrieve the all QCIP Files
        List<Files__c> fileresultList = null;
        Set<Id> parentFileIdsSet = new Set<Id>();
        Set<Id> SplittedparentFileIdsSet = new Set<Id>();
        Map<Id, Decimal> totalParentsplitWorkTimeMap = new Map<Id, Decimal>();
        Map<Id, Decimal> finalSplittedChildMap = new Map<Id, Decimal>();
        Map<Id, Id> finalSplittedChildParentMap = new Map<Id, Id>();
        Set<Id> splitedmemberIds = new Set<Id>();
        
        Set<Id> finalSplittedChilds = new Set<Id>();
        List<Files__c> finalUpdateFileList = new List<Files__c>();
        List<Files__c> trackerHandoverList = new List<Files__c>();
        Map<Id, Decimal> normalWorkTimeMap = new Map<Id, Decimal>();
        Map<Id, Decimal> normalBreakTimeMap = new Map<Id, Decimal>();
        Map<Id, Integer> normalNoOfBreakMap = new Map<Id, Integer>();
        string searchChild = '%' + '_copy'+'%';
        // Declaration Starts
        Set<Id> rootParentSplittIDs = new Set<Id>();
        Set<Id> immediateSplittIDs = new Set<Id>();
        Set<Id> childSplittIDs = new Set<Id>();
        Map<Id,Id> splitRelationMap = new Map<Id,Id>();
        Map<Id,Decimal> splitRelationTimeMap = new Map<Id,Decimal>();
        boolean noChildFilesForCopyScenario = false;
        boolean nosplitChildFilesExist = false;
        Map<Id, String> parentDetailMap = new Map<Id, String>();
        Set<String> parentFileNameSet = new Set<String>();
        if(parentIdValue != null){
            // Retrieve all the QCIP files on the order 
            /*Set<Id> setIds = new Set<Id>();
if(wrapperList != null && wrapperList.size() > 0){
if(!wrapperList.isEmpty()){
for (Integer idx = 0; idx < wrapperList.size(); idx++) {
if (wrapperList[idx].isSelected) {
setIds.add(wrapperList[idx].fileWrap.Id);
}
}
}
}*/
            
            
            fileresultList = [select Id,name,File_Category_Code__c, File_Type__c, IsSplitedFile__c, File_Copy_Number__c, Splitted_Parent_id__c, Total_WorkTime_for_File__c,File_Category_Code__r.Name,Total_Work_Time__c,Member__c, Status__c from Files__c where Status__c = 'QCIP' AND Production_Order__c =:parentIdValue ];
            //fileresultList = [select Id,name,File_Category_Code__c, File_Type__c, IsSplitedFile__c, File_Copy_Number__c, Splitted_Parent_id__c, Total_WorkTime_for_File__c,File_Category_Code__r.Name,Total_Work_Time__c,Member__c, Status__c from Files__c where Status__c = 'QCIP' AND Production_Order__c =:parentIdValue ];
            
            
            if(fileresultList != null && fileresultList != null){
                for(Files__c filequeue : fileresultList){
                    system.debug('%%%%%% Files are : '+ filequeue);
                    // Filter the Copy Parent Files
                    if(filequeue.File_Type__c == 'Image' && filequeue.Splitted_Parent_id__c == null && filequeue.IsSplitedFile__c==false && (filequeue.File_Copy_Number__c == 0 || filequeue.File_Copy_Number__c == null || String.isBlank(String.valueOf(filequeue.File_Copy_Number__c)))){
                        parentFileIdsSet.add(filequeue.Id);
                        parentFileNameSet.add(filequeue.Name);
                        parentDetailMap.put(filequeue.Id,filequeue.Name);
                    }
                    
                    // Filter the Splitted Parent Files
                    if(filequeue.IsSplitedFile__c==true){
                        SplittedparentFileIdsSet.add(filequeue.Id);
                        totalParentsplitWorkTimeMap.put(filequeue.id,filequeue.Total_work_time__c);
                        splitedmemberIds.add(filequeue.Member__c);
                        filequeue.Status__c = 'On-Hold';
                        system.debug('[FL] Inside the splitted Parent : ' + filequeue);
                        finalUpdateFileList.add(filequeue);
                    } 
                    if(filequeue.IsSplitedFile__c==false && filequeue.Splitted_Parent_id__c != null) {
                        finalSplittedChilds.add(filequeue.Splitted_Parent_id__c);
                        //splitedmemberIds.add(filequeue.Member__c);
                        finalSplittedChildMap.put(filequeue.Id, filequeue.Total_Work_Time__c);
                        finalSplittedChildParentMap.put(filequeue.Id, filequeue.Splitted_Parent_id__c);
                    } 
                    
                    // Creating Relationship between splitted Files
                    
                    if(filequeue.IsSplitedFile__c && filequeue.Splitted_Parent_id__c == null){
                        // Root Parent File
                        rootParentSplittIDs.add(filequeue.Id);
                        splitRelationMap.put(filequeue.Id, filequeue.Splitted_Parent_id__c);
                        splitRelationTimeMap.put(filequeue.Id, filequeue.Total_Work_Time__c);
                    } else if(filequeue.IsSplitedFile__c && filequeue.Splitted_Parent_id__c != null){
                        // Immediate Parent File
                        immediateSplittIDs.add(filequeue.Id);
                        splitRelationMap.put(filequeue.Id, filequeue.Splitted_Parent_id__c);
                        splitRelationTimeMap.put(filequeue.Id, filequeue.Total_Work_Time__c);
                    } else if(!filequeue.IsSplitedFile__c && filequeue.Splitted_Parent_id__c != null){
                        // Child Files
                        childSplittIDs.add(filequeue.Id);
                        splitRelationMap.put(filequeue.Id, filequeue.Splitted_Parent_id__c);
                        splitRelationTimeMap.put(filequeue.Id, filequeue.Total_Work_Time__c);
                    }
                    
                    
                    system.debug('----------splitedmemberIds-------------' + splitedmemberIds);
                    
                }
                
                Map<String,Decimal> trackerHandoverTimeMap = new Map<String,Decimal>();
                // Add the Tracker Handover Files to parent list 
                trackerHandoverList = [select Id,name,File_Category_Code__c, File_Type__c, IsSplitedFile__c, File_Copy_Number__c, Splitted_Parent_id__c, Total_WorkTime_for_File__c,File_Category_Code__r.Name,Total_Work_Time__c,Member__c, Status__c from Files__c where Tracker_handover__c = true AND Name IN :parentFileNameSet AND Status__c = 'On-Hold' AND Production_Order__c =:parentIdValue ];
                
                if(trackerHandoverList != null && trackerHandoverList.size() > 0){
                    for(Files__c trackerHandFile : trackerHandoverList){
                        if(trackerHandFile.Total_WorkTime_for_File__c != null){
                            trackerHandoverTimeMap.put(trackerHandFile.Name,trackerHandFile.Total_work_time__c);
                        }
                    }
                }
                system.debug('Tracker Handover timing calculate : ' + trackerHandoverTimeMap);
                // STEP 1 : Compute the total work time from all child to parent file
                
                List<Files__c> childFilesListforParent = [SELECT Id, Name, No_of_Breaks__c, Parent_Id__c, Total_Work_time__c, Total_Break_time__c, IsSplitedFile__c, File_Copy_Number__c, Splitted_Parent_id__c,Status__c FROM Files__c WHERE Parent_Id__c IN: parentFileIdsSet AND File_Type__c = 'Image' AND Name LIKE: searchChild AND Status__c = 'QCIP'];
                //(Status__c = 'QC' OR Status__c = 'QCIP' OR Status__c='On-Hold')
                
                Map<Id, Decimal> totalWorkTimeMap = new Map<Id, Decimal>();
                Map<Id, Decimal> totalBreakTimeMap = new Map<Id, Decimal>();
                Map<Id, Integer> totalNoOfBreakMap = new Map<Id, Integer>();
                Decimal totalWorkingTime = 0.0;
                Decimal totalBreakingTime = 0.0;
                Integer totalNoOfBreak = 0;
                Set<Id> onlyParentSets = new Set<Id>();
                if(childFilesListforParent != null && childFilesListforParent.size() > 0){
                    for(Id parentFileId :parentFileIdsSet){
                        totalWorkingTime = 0.0;
                        totalBreakingTime = 0.0;
                        totalNoOfBreak = 0;
                        boolean trackerHandoverFlag = false;
                        for(Files__c childFile : childFilesListforParent){
                            if(childFile.Parent_Id__c == parentFileId){
                                
                                if(childFile.Total_Work_Time__c != null){
                                    totalWorkingTime += childFile.Total_Work_Time__c;
                                }
                                
                                if(childFile.Total_Break_Time__c != null){
                                    totalBreakingTime += childFile.Total_Break_Time__c;
                                }
                                
                                if(childFile.No_of_Breaks__c != null){
                                    totalNoOfBreak += Integer.valueOf(childFile.No_of_Breaks__c);
                                }
                                childFile.Status__c = 'On-Hold';
                                system.debug('[FL] Copy Scenario : Child Files are : ' + childFile);
                                finalUpdateFileList.add(childFile);
                                trackerHandoverFlag = true;
                                onlyParentSets.add(childFile.Parent_Id__c);
                            } else {
                                
                                if(normalWorkTimeMap != null && normalWorkTimeMap.size() > 0){
                                    totalWorkingTime = normalWorkTimeMap.get(parentFileId);
                                }
                                if(normalBreakTimeMap != null && normalBreakTimeMap.size() > 0){
                                    totalBreakingTime = normalBreakTimeMap.get(parentFileId);
                                } 
                                if(normalNoOfBreakMap != null && normalNoOfBreakMap.size() > 0){
                                    if(normalNoOfBreakMap.get(parentFileId) != null){
                                        totalNoOfBreak = normalNoOfBreakMap.get(parentFileId);
                                    }
                                } 
                            }
                            
                        }
                        
                        // Adding Tracker Handover Time same file name to parent file name
                        if(parentDetailMap != null && trackerHandoverFlag){
                            String parentFileNameForTH = parentDetailMap.get(parentFileId);
                            if(parentFileNameForTH != null){
                                if(trackerHandoverTimeMap != null){
                                    //String similarFile = trackerHandoverTimeMap.get(parentFileNameForTH);
                                    Decimal trackerHandoverFileTime = trackerHandoverTimeMap.get(parentFileNameForTH);
                                    if(trackerHandoverFileTime != null){
                                        system.debug('Before Adding Tracker Handover Timing : ' + totalWorkingTime);
                                        system.debug('Tracker Handover Timing               : ' + trackerHandoverFileTime);
                                        totalWorkingTime += trackerHandoverFileTime;
                                        system.debug('After Adding Tracker Handover Timing : ' + totalWorkingTime);
                                    }
                                }
                            }
                        }
                        
                        totalNoOfBreakMap.put(parentFileId,totalNoOfBreak);
                        totalBreakTimeMap.put(parentFileId,totalBreakingTime);
                        totalWorkTimeMap.put(parentFileId,totalWorkingTime);
                        
                        
                    }
                } else {
                    noChildFilesForCopyScenario = true;
                }
                system.debug(' &&&&&&&&&&& OOOPS ......... $$$$$$$$$$$$$$' + noChildFilesForCopyScenario);
                list<Performance_Rating__c> ratingdetails = new list<Performance_Rating__c>();
                ratingdetails = [Select id,Name,File_Category__c,File_Category__r.name,File_Performance_Stf_Min__c,File_Performance_Stf_Max__c,File_Category__r.Standard_Time_per_File_Min__c,File_Category__r.Standard_Time_per_File_Max__c from Performance_Rating__c where Name='Group A'];
                List<Files__c> parentCopyFileResultList = null;
                if(childFilesListforParent != null && childFilesListforParent.size() > 0 && parentFileIdsSet != null && parentFileIdsSet.size() > 0){
                    
                    parentCopyFileResultList = [select Id,name, File_Category_Code__c, IsSplitedFile__c, Splitted_Parent_id__c, No_of_Breaks__c, Total_Break_Time__c, Total_WorkTime_for_File__c,File_Category_Code__r.Name,Total_Work_Time__c,Member__c from Files__c where Id IN : parentFileIdsSet AND Status__c = 'QCIP']; // 
                    if(parentCopyFileResultList != null && parentCopyFileResultList.size() > 0){
                        for(Files__c FileObj : parentCopyFileResultList){
                            
                            Decimal totalsecs = 0.0;
                            if(totalWorkTimeMap.get(FileObj.Id) != null){
                                if(FileObj.Total_Work_Time__c != null){
                                    FileObj.Total_Work_Time__c = FileObj.Total_Work_Time__c + totalWorkTimeMap.get(FileObj.Id);
                                    totalsecs = FileObj.Total_Work_Time__c + totalWorkTimeMap.get(FileObj.Id);
                                } else {
                                    FileObj.Total_Work_Time__c = totalWorkTimeMap.get(FileObj.Id); 
                                }
                                totalsecs = totalWorkTimeMap.get(FileObj.Id);
                            }
                            if(totalBreakTimeMap.get(FileObj.Id) != null){
                                FileObj.Total_Break_Time__c = totalBreakTimeMap.get(FileObj.Id);
                            }
                            if(totalNoOfBreakMap.get(FileObj.Id) != null){
                                FileObj.No_of_Breaks__c = totalNoOfBreakMap.get(FileObj.Id);
                            }
                            system.debug('Test the parent File Scenario :' + onlyParentSets);
                            if(onlyParentSets.contains(FileObj.Id)){
                                
                                system.debug('<Test> File Info Details : ' + FileObj.Name);
                                
                                //Decimal totalsecs = totalWorkTimeMap.get(FileObj.Id);
                                Decimal mins = 0.0;
                                Decimal totalmins = 0.0;
                                if(totalsecs != null){
                                    mins = totalsecs/60;            
                                    totalmins = mins.setscale(2);
                                }
                                
                                Decimal minval ;
                                Decimal maxval ;
                                
                                for(Performance_Rating__c PR :ratingdetails)
                                {
                                    
                                    minval = PR.File_Performance_Stf_Min__c;
                                    maxval = PR.File_Performance_Stf_Max__c;
                                    
                                    if(totalmins>=minval){
                                        if(totalmins<=maxval){
                                            FileObj.File_Category_Code__c = PR.File_Category__c;
                                            system.debug('--- TOTAL FILE TIME CALCULATION CATEGORY IS : --- ' + PR.File_Category__c);
                                        }
                                    }
                                }
                                
                            }
                            system.debug('[FL] File List : ' + FileObj);
                            finalUpdateFileList.add(FileObj);
                        }
                        
                    }
                    
                }
                
                
                system.debug(' $$$$$$$$$$$$$$$ FILES LIST IN COPY PARENT FILES ARE : ' + finalUpdateFileList);
                // STEP 2 : Splitted Files - Case 1
                
                List<Files__c> SplittedChildFiles = [Select id,Name,Member__c, Splitted_Parent_id__c, No_of_Breaks__c, Parent_Id__c, Total_Work_time__c, Total_Break_time__c FROM Files__c WHERE Splitted_Parent_id__c IN: SplittedparentFileIdsSet AND File_Type__c = 'Image' AND IsSplitedFile__c = false AND Status__c = 'QCIP']; // AND IsSplitedFile__c = false
                Map<Id, Decimal> totalChildSplitWorkTimeMap = new Map<Id, Decimal>();
                
                List<Files__c> SplittedParentFiles = [Select id,Name,Splitted_Parent_id__c, No_of_Breaks__c, Parent_Id__c, Total_Work_time__c, Total_Break_time__c FROM Files__c WHERE Id IN: SplittedparentFileIdsSet AND File_Type__c = 'Image'];
                
                Map<Id, Decimal> splitParentWorkTimeMap = new Map<Id, Decimal>();
                if(SplittedParentFiles != null && SplittedParentFiles.size() > 0){
                    for(Files__c newFiles : SplittedParentFiles){
                        splitParentWorkTimeMap.put(newFiles.Id, newFiles.Total_Work_time__c);
                    }
                }         
                
                Map<Id, Integer> splittedParentChildCountMap = new Map<Id, Integer>();
                List<Member__c> Memdetails = [select id,Name,Performance_Rating__c,Performance_Rating__r.Name from Member__c where id IN:splitedmemberIds];
                Set<String> memberRatingNames = new Set<String>();
                Map<Id, String> memberRatingMap = new Map<Id, String>();
                if(Memdetails != null){
                    for(Member__c memberRec : Memdetails){
                        if(memberRec.Performance_Rating__c != null){
                            memberRatingNames.add(memberRec.Performance_Rating__r.Name);
                            memberRatingMap.put(memberRec.Id, memberRec.Performance_Rating__r.Name);
                        }
                    }
                }
                
                list<Performance_Rating__c> ratingdetailSplit = new list<Performance_Rating__c>();
                ratingdetailSplit = [Select id,Name,File_Category__c,File_Category__r.name,File_Performance_Stf_Min__c,File_Performance_Stf_Max__c,File_Category__r.Standard_Time_per_File_Min__c,File_Category__r.Standard_Time_per_File_Max__c from Performance_Rating__c where Name IN : memberRatingNames ];
                
                if(SplittedChildFiles!=null && SplittedChildFiles.size()>0 && SplittedparentFileIdsSet!=null )
                {       
                    for(Id SplitP : SplittedparentFileIdsSet)
                    {
                        Integer count = 0;
                        for(Files__c ChildSplitFile : SplittedChildFiles)
                        {                   
                            if(ChildSplitFile.Splitted_Parent_id__c==SplitP)                    
                            {
                                count++;                
                            }               
                        }
                        splittedParentChildCountMap.put(SplitP,count);
                    }
                    
                } else {
                    nosplitChildFilesExist = true;
                }
                system.debug(' &&&&&&&&&&& OOOPS ......... SPLIT $$$$$$$$$$$$$$' + nosplitChildFilesExist);
                
                if(nosplitChildFilesExist && noChildFilesForCopyScenario){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Child Files for Split and Copy Scenario.')); 
                    return;
                } 
                
                if(SplittedChildFiles!=null && SplittedChildFiles.size()>0 && SplittedparentFileIdsSet!=null )
                {       
                    for(Id SplitP : SplittedparentFileIdsSet)
                    {
                        Integer count = 0;
                        integer loopcount = 0;
                        for(Files__c ChildSplitFile : SplittedChildFiles)
                        {                   
                            
                            
                            
                            if(ChildSplitFile.Splitted_Parent_id__c==SplitP)                    
                            {
                                count = splittedParentChildCountMap.get(ChildSplitFile.Splitted_Parent_id__c);
                                if(count != null && splitParentWorkTimeMap != null){
                                    
                                    Decimal splitFileTime = splitParentWorkTimeMap.get(SplitP);
                                    
                                    Decimal totalworktime = 0.0;
                                    if(splitFileTime != null){
                                        //totalworktime = ChildSplitFile.Total_Work_time__c + (splitFileTime/count);
                                        Integer remindar = math.mod(Integer.valueOf(splitFileTime),count);
                                        Integer value1 = (Integer.valueOf(splitFileTime) - remindar) / count;
                                        Integer childNoWorkTime = 0;
                                        if(loopcount == 0){
                                            
                                            if(ChildSplitFile.Total_Work_time__c != null){
                                                totalworktime = ChildSplitFile.Total_Work_time__c + value1 + remindar;
                                            } else {
                                                totalworktime = childNoWorkTime + value1 + remindar;
                                            }
                                            
                                            
                                        } else {
                                            
                                            if(ChildSplitFile.Total_Work_time__c != null){
                                                totalworktime = ChildSplitFile.Total_Work_time__c + value1;
                                            } else {
                                                totalworktime = childNoWorkTime + value1;
                                            } 
                                            
                                        }
                                        loopcount ++;
                                    } else {
                                        
                                        totalworktime = ChildSplitFile.Total_Work_time__c ;
                                    }
                                    
                                    totalChildSplitWorkTimeMap.put(ChildSplitFile.id,totalworktime);    
                                }
                            }               
                        }
                        
                    }
                    
                }
                
                
                if(SplittedChildFiles != null && SplittedChildFiles.size() > 0){
                    for(Id SplitP : SplittedparentFileIdsSet){
                        
                        for(Files__c ChildSplitFile : SplittedChildFiles){
                            
                            if(SplitP == ChildSplitFile.Splitted_Parent_id__c){
                                
                                
                                if(totalChildSplitWorkTimeMap.get(ChildSplitFile.Id) != null){
                                    ChildSplitFile.Total_Work_Time__c = totalChildSplitWorkTimeMap.get(ChildSplitFile.Id);
                                }
                                
                                Decimal totalsecs = totalChildSplitWorkTimeMap.get(ChildSplitFile.Id);
                                
                                Decimal mins = 0.0;
                                Decimal totalmins = 0.0;
                                if(totalsecs != null){
                                    mins = totalsecs/60;            
                                    totalmins = mins.setscale(2);
                                }
                                
                                Decimal minval ;
                                Decimal maxval ;
                                if(ratingdetailSplit != null && ratingdetailSplit.size() > 0){
                                    String memPerfName = memberRatingMap.get(ChildSplitFile.Member__c);
                                    system.debug('Member : SP CHILD ' + ChildSplitFile.Member__c + ' @@@@@@@ PERFORMANCE GROUP : ' + memPerfName);
                                    for(Performance_Rating__c perRate : ratingdetailSplit){
                                        if(memPerfName != null && memPerfName == perRate.Name){
                                            minval = perRate.File_Performance_Stf_Min__c;
                                            maxval = perRate.File_Performance_Stf_Max__c;
                                            
                                            if(totalmins>=minval){
                                                if(totalmins<=maxval){
                                                    ChildSplitFile.File_Category_Code__c = perRate.File_Category__c;
                                                    system.debug('[FL] ############## File_Category_Code__c ARE : ' + ChildSplitFile.File_Category_Code__c);
                                                }
                                            }
                                        }
                                    }
                                }
                                system.debug('[FL] ############## FILES LIST IN COPY PARENT FILES ARE : ' + ChildSplitFile);
                                
                                finalUpdateFileList.add(ChildSplitFile);
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                // Splitted File Time update for Scenario 2 (psd level)
                
                
                system.debug('Splitted Root Parent - Files List are : ' + rootParentSplittIDs);
                system.debug('Splitted Immediate Parent - Files List are : ' + immediateSplittIDs);
                system.debug('Splitted Child - Files List are : ' + childSplittIDs);
                system.debug('SPLITTED RELATIONSHIP MAP :' + splitRelationMap);
                
                
                Set<Id> ToBeUpdateTimeForChild = new Set<Id>();
                Set<Id> parentFileForImmediate = new Set<Id>();
                Map<Id, Set<Id>> groupImmediateFileMap = new Map<Id, Set<Id>>();
                if(immediateSplittIDs != null && immediateSplittIDs.size() > 0){
                    if(splitRelationMap != null && splitRelationMap.size() > 0){
                        for(Id immediateFiles : immediateSplittIDs){
                            for(Id key :splitRelationMap.keySet()){
                                Id currentId = splitRelationMap.get(key);
                                system.debug('Immediate Current Value is : ' + currentId);
                                if(currentId != null){
                                    if(currentId.equals(immediateFiles)){
                                        ToBeUpdateTimeForChild.add(key);
                                        if(splitRelationMap.get(immediateFiles) != null){
                                            parentFileForImmediate.add(splitRelationMap.get(immediateFiles));
                                        }
                                        
                                    }                                    
                                }
                            }
                        }
                        
                    }
                    system.debug('-- PARENT FILE List : ' + parentFileForImmediate);
                    if(parentFileForImmediate != null && parentFileForImmediate.size() > 0){
                        for(Id allImmediateParent : parentFileForImmediate){
                            Set<Id> finalGroupOfChilds = new Set<Id>();
                            for(Id keyChild :splitRelationMap.keySet()){
                                Id currentChilId = splitRelationMap.get(keyChild);
                                system.debug('Parent Current Value is : ' + currentChilId);
                                if(currentChilId != null){
                                    if(currentChilId.equals(allImmediateParent)){
                                        finalGroupOfChilds.add(keyChild);
                                        //parentFileForImmediate.add(splitRelationMap.get(immediateFiles));
                                    }                                    
                                }
                            }
                            system.debug('######################'+finalGroupOfChilds);
                            groupImmediateFileMap.put(allImmediateParent,finalGroupOfChilds);
                        }
                    }
                    system.debug('-- Immediate Group List : ' + groupImmediateFileMap);
                    system.debug('Splitted Immediate Parent - Files List are : ' + immediateSplittIDs);
                    system.debug('%%%% Splitted Child - Files List are : ' + ToBeUpdateTimeForChild);
                    system.debug('%%%% SPLITTED RELATIONSHIP MAP : FILE IMMEDIATE ' + parentFileForImmediate);
                    //finalGroupOfChilds
                    Map<Id, Decimal> finalCalculatedTimeMap = new Map<Id, Decimal>();
                    Map<Id, Id> finalCalculatedCategory = new Map<Id, Id>();
                    List<Files__c> newUpdatedList = new List<Files__c>();
                    if(ToBeUpdateTimeForChild != null && ToBeUpdateTimeForChild.size() > 0){
                        if(finalUpdateFileList != null && finalUpdateFileList.size() > 0){
                            for(Id baseChild : ToBeUpdateTimeForChild){
                                for(Files__c finalFileForChild : finalUpdateFileList){
                                    if(immediateSplittIDs.contains(finalFileForChild.Id)){
                                        // Ignore the Immediate Files
                                        continue;
                                    }
                                    
                                    if(baseChild == finalFileForChild.Id){
                                        Id fileImmediateParentFile = splitRelationMap.get(baseChild);
                                        Decimal totalTimeForChild = 0.0;
                                        Id rootParent = null;
                                        if(fileImmediateParentFile != null){
                                            rootParent = splitRelationMap.get(fileImmediateParentFile);
                                            if(groupImmediateFileMap != null && rootParent != null){
                                                Set<Id> allImmediateFiles = groupImmediateFileMap.get(rootParent);
                                                if(allImmediateFiles != null && allImmediateFiles.size() > 0){
                                                    for(Id allImmediateIds : allImmediateFiles){
                                                        if(splitRelationTimeMap != null){
                                                            Decimal curvalue = splitRelationTimeMap.get(allImmediateIds);
                                                            system.debug('--- Current Value is : ' + curvalue + 'For File ' +  allImmediateIds );
                                                            if(curvalue != null){
                                                                totalTimeForChild += curvalue;
                                                            }
                                                        }
                                                    }
                                                    system.debug('Total Time for all Immediate Files are : ' + totalTimeForChild);
                                                }
                                            }
                                            if(rootParent != null){
                                                Decimal rootParentFileTime = splitRelationTimeMap.get(rootParent);
                                                system.debug('Total Time for Root Parent Files are : ' + rootParentFileTime);
                                                if(rootParentFileTime != null){
                                                    totalTimeForChild += rootParentFileTime;
                                                }
                                            }
                                        }
                                        Decimal childFileTime = splitRelationTimeMap.get(baseChild);
                                        system.debug('Total Time for final child Files are : ' + childFileTime);
                                        if(childFileTime != null){
                                            totalTimeForChild += childFileTime;
                                        }
                                        finalFileForChild.Total_Work_Time__c = totalTimeForChild;
                                        
                                        // Update Category for new file
                                        
                                        Decimal totalsecs = totalTimeForChild;
                                        
                                        Decimal mins = 0.0;
                                        Decimal totalmins = 0.0;
                                        if(totalsecs != null){
                                            mins = totalsecs/60;            
                                            totalmins = mins.setscale(2);
                                        }
                                        
                                        Decimal minval ;
                                        Decimal maxval ;
                                        Id Catogory = null;
                                        if(ratingdetailSplit != null && ratingdetailSplit.size() > 0){
                                            String memPerfName = memberRatingMap.get(finalFileForChild.Member__c);
                                            system.debug('Member : ' + finalFileForChild.Member__c + ' $$$$$$$ PERFORMANCE GROUP : ' + memPerfName);
                                            for(Performance_Rating__c perRate : ratingdetailSplit){
                                                if(memPerfName != null && memPerfName == perRate.Name){
                                                    minval = perRate.File_Performance_Stf_Min__c;
                                                    maxval = perRate.File_Performance_Stf_Max__c;
                                                    
                                                    if(totalmins>=minval){
                                                        if(totalmins<=maxval){
                                                            finalFileForChild.File_Category_Code__c = perRate.File_Category__c;
                                                            Catogory = perRate.File_Category__c;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        system.debug('~~~~~~~~~~~~~~~ FINAL FILE FOR CHILD ~~~~~~~' + finalFileForChild);
                                        //newUpdatedList.add(finalFileForChild);
                                        finalCalculatedTimeMap.put(finalFileForChild.Id,totalTimeForChild); 
                                        finalCalculatedCategory.put(finalFileForChild.Id,Catogory); 
                                    } 
                                }
                                
                            }
                        }
                    }
                    
                    system.debug('~~~~~~~~~~~~~~~ FINAL FILE FOR TIME MAP ~~~~~~~' + finalCalculatedTimeMap);
                    system.debug('~~~~~~~~~~~~~~~ FINAL FILE FOR CATEGORY MAP ~~~~~~~' + finalCalculatedCategory);
                    
                    if(finalCalculatedTimeMap != null && finalCalculatedCategory != null){
                        if(finalUpdateFileList != null && finalUpdateFileList.size() > 0){
                            system.debug('$$$$$$ FINAL FILES TO BE UPDATED IN IMMEDIATE PARENT SCENARIO');
                            for(Files__c finalFileForChild2 : finalUpdateFileList){
                                Decimal spChildTime = finalCalculatedTimeMap.get(finalFileForChild2.Id);
                                Id spChildCategory = finalCalculatedCategory.get(finalFileForChild2.Id);
                                if(spChildTime != null){
                                    finalFileForChild2.Total_Work_Time__c = spChildTime;
                                }
                                if(spChildCategory != null){
                                    finalFileForChild2.File_Category_Code__c = spChildCategory;
                                }
                                if(finalFileForChild2.IsSplitedFile__c || finalFileForChild2.File_Copy_Number__c > 0){
                                    finalFileForChild2.Status__c = 'On-Hold';
                                }
                                system.debug('$$$$$$ FINAL FILES ARE ' + finalFileForChild2);
                                newUpdatedList.add(finalFileForChild2);
                            }
                            
                            if(newUpdatedList != null && newUpdatedList.size() > 0){
                                try{
                                    update newUpdatedList;
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Timings Updated successfully in immediate scenario')); 
                                    return;
                                } catch (DmlException de){
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error while update files in immediate scenario' + de.getMessage())); 
                                    return;
                                }
                            }
                        }
                    }
                    
                }
                
            }
        }
        
        system.debug(' @@@@@@@@ FILES LIST IN COPY PARENT FILES ARE : ' + finalUpdateFileList);
        if(finalUpdateFileList != null && finalUpdateFileList.size() > 0){
            system.debug(' @@@@@@@@ FILES LIST IN NORMAL FILES SCENARIO ARE : ' + finalUpdateFileList);
            Set<Files__c> finalUpdateFileSet = new Set<Files__c>();
            
            finalUpdateFileSet.addAll(finalUpdateFileList);
            
            List<Files__c> finalFileUpdateListForQCIP = new List<Files__c>();
            finalFileUpdateListForQCIP.addAll(finalUpdateFileSet);
            try{
                //update finalUpdateFileList;
                if(finalFileUpdateListForQCIP != null && finalFileUpdateListForQCIP.size() > 0){
                    update finalFileUpdateListForQCIP;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Timings Updated successfully in copy and split scenario')); 
                    return; 
                }
                
            } catch (DmlException de){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error while update files in normal split scenario' + de.getMessage())); 
                return;
            }
        }
        
    }
    
    
    public void test_Merge_Files_Copy_and_Split_sel(){
        
        // Retrieve the all QCIP Files
        List<Files__c> fileresultList = null;
        Set<Id> parentFileIdsSet = new Set<Id>();
        Set<Id> SplittedparentFileIdsSet = new Set<Id>();
        Map<Id, Decimal> totalParentsplitWorkTimeMap = new Map<Id, Decimal>();
        Map<Id, Decimal> finalSplittedChildMap = new Map<Id, Decimal>();
        Map<Id, Id> finalSplittedChildParentMap = new Map<Id, Id>();
        Set<Id> splitedmemberIds = new Set<Id>();
        
        Set<Id> finalSplittedChilds = new Set<Id>();
        List<Files__c> finalUpdateFileList = new List<Files__c>();
        List<Files__c> trackerHandoverList = new List<Files__c>();
        Map<Id, Decimal> normalWorkTimeMap = new Map<Id, Decimal>();
        Map<Id, Decimal> normalBreakTimeMap = new Map<Id, Decimal>();
        Map<Id, Integer> normalNoOfBreakMap = new Map<Id, Integer>();
        string searchChild = '%' + '_copy'+'%';
        // Declaration Starts
        Set<Id> rootParentSplittIDs = new Set<Id>();
        Set<Id> immediateSplittIDs = new Set<Id>();
        Set<Id> childSplittIDs = new Set<Id>();
        Map<Id,Id> splitRelationMap = new Map<Id,Id>();
        Map<Id,Decimal> splitRelationTimeMap = new Map<Id,Decimal>();
        boolean noChildFilesForCopyScenario = false;
        boolean nosplitChildFilesExist = false;
        Map<Id, String> parentDetailMap = new Map<Id, String>();
        Set<String> parentFileNameSet = new Set<String>();
        if(parentIdValue != null){
            // Retrieve all the QCIP files on the order 
            Set<Id> setIds = new Set<Id>();
            if(wrapperList != null && wrapperList.size() > 0){
                if(!wrapperList.isEmpty()){
                    for (Integer idx = 0; idx < wrapperList.size(); idx++) {
                        if (wrapperList[idx].isSelected) {
                            setIds.add(wrapperList[idx].fileWrap.Id);
                        }
                    }
                }
            }
            
            system.debug('Selected File Ids are : ' + setIds);
            //fileresultList = [select Id,name,File_Category_Code__c, File_Type__c, IsSplitedFile__c, File_Copy_Number__c, Splitted_Parent_id__c, Total_WorkTime_for_File__c,File_Category_Code__r.Name,Total_Work_Time__c,Member__c, Status__c from Files__c where Status__c = 'QCIP' AND Production_Order__c =:parentIdValue ];
            fileresultList = [select Id,name,File_Category_Code__c, File_Type__c, IsSplitedFile__c, File_Copy_Number__c, Splitted_Parent_id__c, Total_WorkTime_for_File__c,File_Category_Code__r.Name,Total_Work_Time__c,Member__c, Status__c from Files__c where Status__c = 'QCIP' AND Production_Order__c =:parentIdValue AND Id IN: setIds];
            
            
            if(fileresultList != null && fileresultList != null){
                for(Files__c filequeue : fileresultList){
                    system.debug('%%%%%% Files are : '+ filequeue);
                    // Filter the Copy Parent Files
                    if(filequeue.File_Type__c == 'Image' && filequeue.Splitted_Parent_id__c == null && filequeue.IsSplitedFile__c==false && (filequeue.File_Copy_Number__c == 0 || filequeue.File_Copy_Number__c == null || String.isBlank(String.valueOf(filequeue.File_Copy_Number__c)))){
                        parentFileIdsSet.add(filequeue.Id);
                        parentFileNameSet.add(filequeue.Name);
                        parentDetailMap.put(filequeue.Id,filequeue.Name);
                    }
                    
                    // Filter the Splitted Parent Files
                    if(filequeue.IsSplitedFile__c==true){
                        SplittedparentFileIdsSet.add(filequeue.Id);
                        totalParentsplitWorkTimeMap.put(filequeue.id,filequeue.Total_work_time__c);
                        splitedmemberIds.add(filequeue.Member__c);
                        filequeue.Status__c = 'On-Hold';
                        system.debug('[FL] Inside the splitted Parent : ' + filequeue);
                        finalUpdateFileList.add(filequeue);
                    } 
                    if(filequeue.IsSplitedFile__c==false && filequeue.Splitted_Parent_id__c != null) {
                        finalSplittedChilds.add(filequeue.Splitted_Parent_id__c);
                        //splitedmemberIds.add(filequeue.Member__c);
                        finalSplittedChildMap.put(filequeue.Id, filequeue.Total_Work_Time__c);
                        finalSplittedChildParentMap.put(filequeue.Id, filequeue.Splitted_Parent_id__c);
                    } 
                    
                    // Creating Relationship between splitted Files
                    
                    if(filequeue.IsSplitedFile__c && filequeue.Splitted_Parent_id__c == null){
                        // Root Parent File
                        rootParentSplittIDs.add(filequeue.Id);
                        splitRelationMap.put(filequeue.Id, filequeue.Splitted_Parent_id__c);
                        splitRelationTimeMap.put(filequeue.Id, filequeue.Total_Work_Time__c);
                    } else if(filequeue.IsSplitedFile__c && filequeue.Splitted_Parent_id__c != null){
                        // Immediate Parent File
                        immediateSplittIDs.add(filequeue.Id);
                        splitRelationMap.put(filequeue.Id, filequeue.Splitted_Parent_id__c);
                        splitRelationTimeMap.put(filequeue.Id, filequeue.Total_Work_Time__c);
                    } else if(!filequeue.IsSplitedFile__c && filequeue.Splitted_Parent_id__c != null){
                        // Child Files
                        childSplittIDs.add(filequeue.Id);
                        splitRelationMap.put(filequeue.Id, filequeue.Splitted_Parent_id__c);
                        splitRelationTimeMap.put(filequeue.Id, filequeue.Total_Work_Time__c);
                    }
                    
                    
                    system.debug('----------splitedmemberIds-------------' + splitedmemberIds);
                    
                }
                
                Map<String,Decimal> trackerHandoverTimeMap = new Map<String,Decimal>();
                // Add the Tracker Handover Files to parent list 
                trackerHandoverList = [select Id,name,File_Category_Code__c, File_Type__c, IsSplitedFile__c, File_Copy_Number__c, Splitted_Parent_id__c, Total_WorkTime_for_File__c,File_Category_Code__r.Name,Total_Work_Time__c,Member__c, Status__c from Files__c where Tracker_handover__c = true AND Name IN :parentFileNameSet AND Status__c = 'On-Hold' AND Production_Order__c =:parentIdValue ];
                
                if(trackerHandoverList != null && trackerHandoverList.size() > 0){
                    for(Files__c trackerHandFile : trackerHandoverList){
                        if(trackerHandFile.Total_WorkTime_for_File__c != null){
                            trackerHandoverTimeMap.put(trackerHandFile.Name,trackerHandFile.Total_work_time__c);
                        }
                    }
                }
                system.debug('Tracker Handover timing calculate : ' + trackerHandoverTimeMap);
                // STEP 1 : Compute the total work time from all child to parent file
                
                List<Files__c> childFilesListforParent = [SELECT Id, Name, No_of_Breaks__c, Parent_Id__c, Total_Work_time__c, Total_Break_time__c, IsSplitedFile__c, File_Copy_Number__c, Splitted_Parent_id__c,Status__c FROM Files__c WHERE Parent_Id__c IN: parentFileIdsSet AND File_Type__c = 'Image' AND Name LIKE: searchChild AND Status__c = 'QCIP'];
                //(Status__c = 'QC' OR Status__c = 'QCIP' OR Status__c='On-Hold')
                
                Map<Id, Decimal> totalWorkTimeMap = new Map<Id, Decimal>();
                Map<Id, Decimal> totalBreakTimeMap = new Map<Id, Decimal>();
                Map<Id, Integer> totalNoOfBreakMap = new Map<Id, Integer>();
                Decimal totalWorkingTime = 0.0;
                Decimal totalBreakingTime = 0.0;
                Integer totalNoOfBreak = 0;
                Set<Id> onlyParentSets = new Set<Id>();
                if(childFilesListforParent != null && childFilesListforParent.size() > 0){
                    for(Id parentFileId :parentFileIdsSet){
                        totalWorkingTime = 0.0;
                        totalBreakingTime = 0.0;
                        totalNoOfBreak = 0;
                        boolean trackerHandoverFlag = false;
                        for(Files__c childFile : childFilesListforParent){
                            if(childFile.Parent_Id__c == parentFileId){
                                
                                if(childFile.Total_Work_Time__c != null){
                                    totalWorkingTime += childFile.Total_Work_Time__c;
                                }
                                
                                if(childFile.Total_Break_Time__c != null){
                                    totalBreakingTime += childFile.Total_Break_Time__c;
                                }
                                
                                if(childFile.No_of_Breaks__c != null){
                                    totalNoOfBreak += Integer.valueOf(childFile.No_of_Breaks__c);
                                }
                                childFile.Status__c = 'On-Hold';
                                system.debug('[FL] Copy Scenario : Child Files are : ' + childFile);
                                finalUpdateFileList.add(childFile);
                                trackerHandoverFlag = true;
                                onlyParentSets.add(childFile.Parent_Id__c);
                            } else {
                                
                                if(normalWorkTimeMap != null && normalWorkTimeMap.size() > 0){
                                    totalWorkingTime = normalWorkTimeMap.get(parentFileId);
                                }
                                if(normalBreakTimeMap != null && normalBreakTimeMap.size() > 0){
                                    totalBreakingTime = normalBreakTimeMap.get(parentFileId);
                                } 
                                if(normalNoOfBreakMap != null && normalNoOfBreakMap.size() > 0){
                                    if(normalNoOfBreakMap.get(parentFileId) != null){
                                        totalNoOfBreak = normalNoOfBreakMap.get(parentFileId);
                                    }
                                } 
                            }
                            
                        }
                        
                        // Adding Tracker Handover Time same file name to parent file name
                        if(parentDetailMap != null && trackerHandoverFlag){
                            String parentFileNameForTH = parentDetailMap.get(parentFileId);
                            if(parentFileNameForTH != null){
                                if(trackerHandoverTimeMap != null){
                                    //String similarFile = trackerHandoverTimeMap.get(parentFileNameForTH);
                                    Decimal trackerHandoverFileTime = trackerHandoverTimeMap.get(parentFileNameForTH);
                                    if(trackerHandoverFileTime != null){
                                        system.debug('Before Adding Tracker Handover Timing : ' + totalWorkingTime);
                                        system.debug('Tracker Handover Timing               : ' + trackerHandoverFileTime);
                                        totalWorkingTime += trackerHandoverFileTime;
                                        system.debug('After Adding Tracker Handover Timing : ' + totalWorkingTime);
                                    }
                                }
                            }
                        }
                        
                        totalNoOfBreakMap.put(parentFileId,totalNoOfBreak);
                        totalBreakTimeMap.put(parentFileId,totalBreakingTime);
                        totalWorkTimeMap.put(parentFileId,totalWorkingTime);
                        
                        
                    }
                } else {
                    noChildFilesForCopyScenario = true;
                }
                system.debug(' &&&&&&&&&&& OOOPS ......... $$$$$$$$$$$$$$' + noChildFilesForCopyScenario);
                list<Performance_Rating__c> ratingdetails = new list<Performance_Rating__c>();
                ratingdetails = [Select id,Name,File_Category__c,File_Category__r.name,File_Performance_Stf_Min__c,File_Performance_Stf_Max__c,File_Category__r.Standard_Time_per_File_Min__c,File_Category__r.Standard_Time_per_File_Max__c from Performance_Rating__c where Name='Group A'];
                List<Files__c> parentCopyFileResultList = null;
                if(childFilesListforParent != null && childFilesListforParent.size() > 0 && parentFileIdsSet != null && parentFileIdsSet.size() > 0){
                    
                    parentCopyFileResultList = [select Id,name, File_Category_Code__c, IsSplitedFile__c, Splitted_Parent_id__c, No_of_Breaks__c, Total_Break_Time__c, Total_WorkTime_for_File__c,File_Category_Code__r.Name,Total_Work_Time__c,Member__c from Files__c where Id IN : parentFileIdsSet AND Status__c = 'QCIP']; // 
                    if(parentCopyFileResultList != null && parentCopyFileResultList.size() > 0){
                        for(Files__c FileObj : parentCopyFileResultList){
                            
                            Decimal totalsecs = 0.0;
                            if(totalWorkTimeMap.get(FileObj.Id) != null){
                                if(FileObj.Total_Work_Time__c != null){
                                    FileObj.Total_Work_Time__c = FileObj.Total_Work_Time__c + totalWorkTimeMap.get(FileObj.Id);
                                    totalsecs = FileObj.Total_Work_Time__c + totalWorkTimeMap.get(FileObj.Id);
                                } else {
                                    FileObj.Total_Work_Time__c = totalWorkTimeMap.get(FileObj.Id); 
                                }
                                totalsecs = totalWorkTimeMap.get(FileObj.Id);
                            }
                            if(totalBreakTimeMap.get(FileObj.Id) != null){
                                FileObj.Total_Break_Time__c = totalBreakTimeMap.get(FileObj.Id);
                            }
                            if(totalNoOfBreakMap.get(FileObj.Id) != null){
                                FileObj.No_of_Breaks__c = totalNoOfBreakMap.get(FileObj.Id);
                            }
                            system.debug('Test the parent File Scenario :' + onlyParentSets);
                            if(onlyParentSets.contains(FileObj.Id)){
                                
                                system.debug('<Test> File Info Details : ' + FileObj.Name);
                                
                                //Decimal totalsecs = totalWorkTimeMap.get(FileObj.Id);
                                Decimal mins = 0.0;
                                Decimal totalmins = 0.0;
                                if(totalsecs != null){
                                    mins = totalsecs/60;            
                                    totalmins = mins.setscale(2);
                                }
                                
                                Decimal minval ;
                                Decimal maxval ;
                                
                                for(Performance_Rating__c PR :ratingdetails)
                                {
                                    
                                    minval = PR.File_Performance_Stf_Min__c;
                                    maxval = PR.File_Performance_Stf_Max__c;
                                    
                                    if(totalmins>=minval){
                                        if(totalmins<=maxval){
                                            FileObj.File_Category_Code__c = PR.File_Category__c;
                                            system.debug('--- TOTAL FILE TIME CALCULATION CATEGORY IS : --- ' + PR.File_Category__c);
                                        }
                                    }
                                }
                                
                            }
                            system.debug('[FL] File List : ' + FileObj);
                            finalUpdateFileList.add(FileObj);
                        }
                        
                    }
                    
                }
                
                
                system.debug(' $$$$$$$$$$$$$$$ FILES LIST IN COPY PARENT FILES ARE : ' + finalUpdateFileList);
                // STEP 2 : Splitted Files - Case 1
                
                List<Files__c> SplittedChildFiles = [Select id,Name,Member__c, Splitted_Parent_id__c, No_of_Breaks__c, Parent_Id__c, Total_Work_time__c, Total_Break_time__c FROM Files__c WHERE Splitted_Parent_id__c IN: SplittedparentFileIdsSet AND File_Type__c = 'Image' AND IsSplitedFile__c = false AND Status__c = 'QCIP']; // AND IsSplitedFile__c = false
                Map<Id, Decimal> totalChildSplitWorkTimeMap = new Map<Id, Decimal>();
                
                List<Files__c> SplittedParentFiles = [Select id,Name,Splitted_Parent_id__c, No_of_Breaks__c, Parent_Id__c, Total_Work_time__c, Total_Break_time__c FROM Files__c WHERE Id IN: SplittedparentFileIdsSet AND File_Type__c = 'Image'];
                
                Map<Id, Decimal> splitParentWorkTimeMap = new Map<Id, Decimal>();
                if(SplittedParentFiles != null && SplittedParentFiles.size() > 0){
                    for(Files__c newFiles : SplittedParentFiles){
                        splitParentWorkTimeMap.put(newFiles.Id, newFiles.Total_Work_time__c);
                    }
                }         
                
                Map<Id, Integer> splittedParentChildCountMap = new Map<Id, Integer>();
                List<Member__c> Memdetails = [select id,Name,Performance_Rating__c,Performance_Rating__r.Name from Member__c where id IN:splitedmemberIds];
                Set<String> memberRatingNames = new Set<String>();
                Map<Id, String> memberRatingMap = new Map<Id, String>();
                if(Memdetails != null){
                    for(Member__c memberRec : Memdetails){
                        if(memberRec.Performance_Rating__c != null){
                            memberRatingNames.add(memberRec.Performance_Rating__r.Name);
                            memberRatingMap.put(memberRec.Id, memberRec.Performance_Rating__r.Name);
                        }
                    }
                }
                
                list<Performance_Rating__c> ratingdetailSplit = new list<Performance_Rating__c>();
                ratingdetailSplit = [Select id,Name,File_Category__c,File_Category__r.name,File_Performance_Stf_Min__c,File_Performance_Stf_Max__c,File_Category__r.Standard_Time_per_File_Min__c,File_Category__r.Standard_Time_per_File_Max__c from Performance_Rating__c where Name IN : memberRatingNames ];
                
                if(SplittedChildFiles!=null && SplittedChildFiles.size()>0 && SplittedparentFileIdsSet!=null )
                {       
                    for(Id SplitP : SplittedparentFileIdsSet)
                    {
                        Integer count = 0;
                        for(Files__c ChildSplitFile : SplittedChildFiles)
                        {                   
                            if(ChildSplitFile.Splitted_Parent_id__c==SplitP)                    
                            {
                                count++;                
                            }               
                        }
                        splittedParentChildCountMap.put(SplitP,count);
                    }
                    
                } else {
                    nosplitChildFilesExist = true;
                }
                system.debug(' &&&&&&&&&&& OOOPS ......... SPLIT $$$$$$$$$$$$$$' + nosplitChildFilesExist);
                
                if(nosplitChildFilesExist && noChildFilesForCopyScenario){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Child Files for Split and Copy Scenario.')); 
                    return;
                } 
                
                if(SplittedChildFiles!=null && SplittedChildFiles.size()>0 && SplittedparentFileIdsSet!=null )
                {       
                    for(Id SplitP : SplittedparentFileIdsSet)
                    {
                        Integer count = 0;
                        integer loopcount = 0;
                        for(Files__c ChildSplitFile : SplittedChildFiles)
                        {                   
                            
                            
                            
                            if(ChildSplitFile.Splitted_Parent_id__c==SplitP)                    
                            {
                                count = splittedParentChildCountMap.get(ChildSplitFile.Splitted_Parent_id__c);
                                if(count != null && splitParentWorkTimeMap != null){
                                    
                                    Decimal splitFileTime = splitParentWorkTimeMap.get(SplitP);
                                    
                                    Decimal totalworktime = 0.0;
                                    if(splitFileTime != null){
                                        //totalworktime = ChildSplitFile.Total_Work_time__c + (splitFileTime/count);
                                        Integer remindar = math.mod(Integer.valueOf(splitFileTime),count);
                                        Integer value1 = (Integer.valueOf(splitFileTime) - remindar) / count;
                                        Integer childNoWorkTime = 0;
                                        if(loopcount == 0){
                                            
                                            if(ChildSplitFile.Total_Work_time__c != null){
                                                totalworktime = ChildSplitFile.Total_Work_time__c + value1 + remindar;
                                            } else {
                                                totalworktime = childNoWorkTime + value1 + remindar;
                                            }
                                            
                                            
                                        } else {
                                            
                                            if(ChildSplitFile.Total_Work_time__c != null){
                                                totalworktime = ChildSplitFile.Total_Work_time__c + value1;
                                            } else {
                                                totalworktime = childNoWorkTime + value1;
                                            } 
                                            
                                        }
                                        loopcount ++;
                                    } else {
                                        
                                        totalworktime = ChildSplitFile.Total_Work_time__c ;
                                    }
                                    
                                    totalChildSplitWorkTimeMap.put(ChildSplitFile.id,totalworktime);    
                                }
                            }               
                        }
                        
                    }
                    
                }
                
                
                if(SplittedChildFiles != null && SplittedChildFiles.size() > 0){
                    for(Id SplitP : SplittedparentFileIdsSet){
                        
                        for(Files__c ChildSplitFile : SplittedChildFiles){
                            
                            if(SplitP == ChildSplitFile.Splitted_Parent_id__c){
                                
                                
                                if(totalChildSplitWorkTimeMap.get(ChildSplitFile.Id) != null){
                                    ChildSplitFile.Total_Work_Time__c = totalChildSplitWorkTimeMap.get(ChildSplitFile.Id);
                                }
                                
                                Decimal totalsecs = totalChildSplitWorkTimeMap.get(ChildSplitFile.Id);
                                
                                Decimal mins = 0.0;
                                Decimal totalmins = 0.0;
                                if(totalsecs != null){
                                    mins = totalsecs/60;            
                                    totalmins = mins.setscale(2);
                                }
                                
                                Decimal minval ;
                                Decimal maxval ;
                                if(ratingdetailSplit != null && ratingdetailSplit.size() > 0){
                                    String memPerfName = memberRatingMap.get(ChildSplitFile.Member__c);
                                    system.debug('Member : SP CHILD ' + ChildSplitFile.Member__c + ' @@@@@@@ PERFORMANCE GROUP : ' + memPerfName);
                                    for(Performance_Rating__c perRate : ratingdetailSplit){
                                        if(memPerfName != null && memPerfName == perRate.Name){
                                            minval = perRate.File_Performance_Stf_Min__c;
                                            maxval = perRate.File_Performance_Stf_Max__c;
                                            
                                            if(totalmins>=minval){
                                                if(totalmins<=maxval){
                                                    ChildSplitFile.File_Category_Code__c = perRate.File_Category__c;
                                                    system.debug('[FL] ############## File_Category_Code__c ARE : ' + ChildSplitFile.File_Category_Code__c);
                                                }
                                            }
                                        }
                                    }
                                }
                                system.debug('[FL] ############## FILES LIST IN COPY PARENT FILES ARE : ' + ChildSplitFile);
                                
                                finalUpdateFileList.add(ChildSplitFile);
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                // Splitted File Time update for Scenario 2 (psd level)
                
                
                system.debug('Splitted Root Parent - Files List are : ' + rootParentSplittIDs);
                system.debug('Splitted Immediate Parent - Files List are : ' + immediateSplittIDs);
                system.debug('Splitted Child - Files List are : ' + childSplittIDs);
                system.debug('SPLITTED RELATIONSHIP MAP :' + splitRelationMap);
                
                
                Set<Id> ToBeUpdateTimeForChild = new Set<Id>();
                Set<Id> parentFileForImmediate = new Set<Id>();
                Map<Id, Set<Id>> groupImmediateFileMap = new Map<Id, Set<Id>>();
                if(immediateSplittIDs != null && immediateSplittIDs.size() > 0){
                    if(splitRelationMap != null && splitRelationMap.size() > 0){
                        for(Id immediateFiles : immediateSplittIDs){
                            for(Id key :splitRelationMap.keySet()){
                                Id currentId = splitRelationMap.get(key);
                                system.debug('Immediate Current Value is : ' + currentId);
                                if(currentId != null){
                                    if(currentId.equals(immediateFiles)){
                                        ToBeUpdateTimeForChild.add(key);
                                        if(splitRelationMap.get(immediateFiles) != null){
                                            parentFileForImmediate.add(splitRelationMap.get(immediateFiles));
                                        }
                                        
                                    }                                    
                                }
                            }
                        }
                        
                    }
                    system.debug('-- PARENT FILE List : ' + parentFileForImmediate);
                    if(parentFileForImmediate != null && parentFileForImmediate.size() > 0){
                        for(Id allImmediateParent : parentFileForImmediate){
                            Set<Id> finalGroupOfChilds = new Set<Id>();
                            for(Id keyChild :splitRelationMap.keySet()){
                                Id currentChilId = splitRelationMap.get(keyChild);
                                system.debug('Parent Current Value is : ' + currentChilId);
                                if(currentChilId != null){
                                    if(currentChilId.equals(allImmediateParent)){
                                        finalGroupOfChilds.add(keyChild);
                                        //parentFileForImmediate.add(splitRelationMap.get(immediateFiles));
                                    }                                    
                                }
                            }
                            system.debug('######################'+finalGroupOfChilds);
                            groupImmediateFileMap.put(allImmediateParent,finalGroupOfChilds);
                        }
                    }
                    system.debug('-- Immediate Group List : ' + groupImmediateFileMap);
                    system.debug('Splitted Immediate Parent - Files List are : ' + immediateSplittIDs);
                    system.debug('%%%% Splitted Child - Files List are : ' + ToBeUpdateTimeForChild);
                    system.debug('%%%% SPLITTED RELATIONSHIP MAP : FILE IMMEDIATE ' + parentFileForImmediate);
                    //finalGroupOfChilds
                    Map<Id, Decimal> finalCalculatedTimeMap = new Map<Id, Decimal>();
                    Map<Id, Id> finalCalculatedCategory = new Map<Id, Id>();
                    List<Files__c> newUpdatedList = new List<Files__c>();
                    if(ToBeUpdateTimeForChild != null && ToBeUpdateTimeForChild.size() > 0){
                        if(finalUpdateFileList != null && finalUpdateFileList.size() > 0){
                            for(Id baseChild : ToBeUpdateTimeForChild){
                                for(Files__c finalFileForChild : finalUpdateFileList){
                                    if(immediateSplittIDs.contains(finalFileForChild.Id)){
                                        // Ignore the Immediate Files
                                        continue;
                                    }
                                    
                                    if(baseChild == finalFileForChild.Id){
                                        Id fileImmediateParentFile = splitRelationMap.get(baseChild);
                                        Decimal totalTimeForChild = 0.0;
                                        Id rootParent = null;
                                        if(fileImmediateParentFile != null){
                                            rootParent = splitRelationMap.get(fileImmediateParentFile);
                                            if(groupImmediateFileMap != null && rootParent != null){
                                                Set<Id> allImmediateFiles = groupImmediateFileMap.get(rootParent);
                                                if(allImmediateFiles != null && allImmediateFiles.size() > 0){
                                                    for(Id allImmediateIds : allImmediateFiles){
                                                        if(splitRelationTimeMap != null){
                                                            Decimal curvalue = splitRelationTimeMap.get(allImmediateIds);
                                                            system.debug('--- Current Value is : ' + curvalue + 'For File ' +  allImmediateIds );
                                                            if(curvalue != null){
                                                                totalTimeForChild += curvalue;
                                                            }
                                                        }
                                                    }
                                                    system.debug('Total Time for all Immediate Files are : ' + totalTimeForChild);
                                                }
                                            }
                                            if(rootParent != null){
                                                Decimal rootParentFileTime = splitRelationTimeMap.get(rootParent);
                                                system.debug('Total Time for Root Parent Files are : ' + rootParentFileTime);
                                                if(rootParentFileTime != null){
                                                    totalTimeForChild += rootParentFileTime;
                                                }
                                            }
                                        }
                                        Decimal childFileTime = splitRelationTimeMap.get(baseChild);
                                        system.debug('Total Time for final child Files are : ' + childFileTime);
                                        if(childFileTime != null){
                                            totalTimeForChild += childFileTime;
                                        }
                                        finalFileForChild.Total_Work_Time__c = totalTimeForChild;
                                        
                                        // Update Category for new file
                                        
                                        Decimal totalsecs = totalTimeForChild;
                                        
                                        Decimal mins = 0.0;
                                        Decimal totalmins = 0.0;
                                        if(totalsecs != null){
                                            mins = totalsecs/60;            
                                            totalmins = mins.setscale(2);
                                        }
                                        
                                        Decimal minval ;
                                        Decimal maxval ;
                                        Id Catogory = null;
                                        if(ratingdetailSplit != null && ratingdetailSplit.size() > 0){
                                            String memPerfName = memberRatingMap.get(finalFileForChild.Member__c);
                                            system.debug('Member : ' + finalFileForChild.Member__c + ' $$$$$$$ PERFORMANCE GROUP : ' + memPerfName);
                                            for(Performance_Rating__c perRate : ratingdetailSplit){
                                                if(memPerfName != null && memPerfName == perRate.Name){
                                                    minval = perRate.File_Performance_Stf_Min__c;
                                                    maxval = perRate.File_Performance_Stf_Max__c;
                                                    
                                                    if(totalmins>=minval){
                                                        if(totalmins<=maxval){
                                                            finalFileForChild.File_Category_Code__c = perRate.File_Category__c;
                                                            Catogory = perRate.File_Category__c;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        system.debug('~~~~~~~~~~~~~~~ FINAL FILE FOR CHILD ~~~~~~~' + finalFileForChild);
                                        //newUpdatedList.add(finalFileForChild);
                                        finalCalculatedTimeMap.put(finalFileForChild.Id,totalTimeForChild); 
                                        finalCalculatedCategory.put(finalFileForChild.Id,Catogory); 
                                    } 
                                }
                                
                            }
                        }
                    }
                    
                    system.debug('~~~~~~~~~~~~~~~ FINAL FILE FOR TIME MAP ~~~~~~~' + finalCalculatedTimeMap);
                    system.debug('~~~~~~~~~~~~~~~ FINAL FILE FOR CATEGORY MAP ~~~~~~~' + finalCalculatedCategory);
                    
                    if(finalCalculatedTimeMap != null && finalCalculatedCategory != null){
                        if(finalUpdateFileList != null && finalUpdateFileList.size() > 0){
                            system.debug('$$$$$$ FINAL FILES TO BE UPDATED IN IMMEDIATE PARENT SCENARIO');
                            for(Files__c finalFileForChild2 : finalUpdateFileList){
                                Decimal spChildTime = finalCalculatedTimeMap.get(finalFileForChild2.Id);
                                Id spChildCategory = finalCalculatedCategory.get(finalFileForChild2.Id);
                                if(spChildTime != null){
                                    finalFileForChild2.Total_Work_Time__c = spChildTime;
                                }
                                if(spChildCategory != null){
                                    finalFileForChild2.File_Category_Code__c = spChildCategory;
                                }
                                if(finalFileForChild2.IsSplitedFile__c || finalFileForChild2.File_Copy_Number__c > 0){
                                    finalFileForChild2.Status__c = 'On-Hold';
                                }
                                system.debug('$$$$$$ FINAL FILES ARE ' + finalFileForChild2);
                                newUpdatedList.add(finalFileForChild2);
                            }
                            
                            if(newUpdatedList != null && newUpdatedList.size() > 0){
                                try{
                                    update newUpdatedList;
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Timings Updated successfully in immediate scenario')); 
                                    return;
                                } catch (DmlException de){
                                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error while update files in immediate scenario' + de.getMessage())); 
                                    return;
                                }
                            }
                        }
                    }
                    
                }
                
            }
        }
        
        system.debug(' @@@@@@@@ FILES LIST IN COPY PARENT FILES ARE : ' + finalUpdateFileList);
        if(finalUpdateFileList != null && finalUpdateFileList.size() > 0){
            system.debug(' @@@@@@@@ FILES LIST IN NORMAL FILES SCENARIO ARE : ' + finalUpdateFileList);
            Set<Files__c> finalUpdateFileSet = new Set<Files__c>();
            
            finalUpdateFileSet.addAll(finalUpdateFileList);
            
            List<Files__c> finalFileUpdateListForQCIP = new List<Files__c>();
            finalFileUpdateListForQCIP.addAll(finalUpdateFileSet);
            try{
                //update finalUpdateFileList;
                if(finalFileUpdateListForQCIP != null && finalFileUpdateListForQCIP.size() > 0){
                    update finalFileUpdateListForQCIP;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Timings Updated successfully in copy and split scenario')); 
                    return; 
                }
                
            } catch (DmlException de){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error while update files in normal split scenario' + de.getMessage())); 
                return;
            }
        }
        
    }
    
    //calling another VF page to download page result
    public PageReference  ExportToExcel(){
        PageReference Exportexcelpage = new Pagereference('/apex/EPMS_AnkenClassificationsExportExcel' + '?id=' + POquery.id);
        Exportexcelpage.setRedirect(false);
        return Exportexcelpage;
    }
    
    public class WrapperFiles implements Comparable {
        
        public String ClassificationName{get;set;}
        public integer TotalFilesCount{get;set;}
        public integer CompletedFilesCount{get;set;}
        
        public WrapperFiles(String Classification,integer TotalFiles, integer CompletedFiles  ) {
            this.ClassificationName =  Classification;
            this.TotalFilesCount = TotalFiles;
            this.CompletedFilesCount =  CompletedFiles ;              
        }
        
        public WrapperFiles(){}
        
        public Integer compareTo(Object ObjToCompare) {
            return ClassificationName.CompareTo(((WrapperFiles)ObjToCompare).ClassificationName);
        }   
    }
    //EPMSSF-513
    // Enabling Job Title for QC to modify the Job Title when status is in QCIP 
    public void showJobTitlePopUp(){
        errorFlag =false;
        displayJobPopUp = false;
        errorTypeFlag=false;
        boolean filestoopen = false;    
        getFilesCheckedJobs = new list<Files__c>();
        selectedstringlistjoblisting = new list<String>();
        filePopList = new List<Files__c>();
        if(!wrapperList.isEmpty()){         
            for (Integer idx = 0; idx < wrapperList.size(); idx++) {
                
                if (wrapperList[idx].isSelected) {
                    
                    filePopList.add(wrapperList[idx].fileWrap);
                }
            }
        }
        
        if(filePopList.isEmpty()){         
            errorFlag = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Record_Select));       
            displayJobPopUp = false;
        }else{
            fileStatusList = new List<Files__c>();       
            fileStatusList = service.getFilesStatusList(filePopList); 
             system.debug('Current Time 28 : ' + system.now());
            if(fileStatusList.size() > 0 ){
                for(Files__c filedata :fileStatusList){
                    if(filedata.File_Type__c =='Order Instruction' || filedata.File_Type__c =='File Instruction'){
                        errorTypeFlag=true;                        
                    }else{ // EPMSSF-513 Changes
                        system.debug('************* filedata.Status__c :: ' + filedata.Status__c);
                        if (filedata.Files_To_open__c == 1) {                       
                            filestoopen = true;
                        } else if(filedata.Status__c=='On-Hold' || filedata.Status__c =='Redo Re-Assigned'){
                            errorFlag = true;
                            system.debug('************* errorFlag :: ' + errorFlag);
                        }else if(filedata.FTP_Upload_Status__c==true){                                        
                            errorFlag = true;                            
                        }
                    }
                    
                }
            }
            if (filestoopen == true) { // EPMSSF-513 Changes
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_FILES_TO_OPEN_NOT_ALLOWED_CHANGE_JOB_TITLE));
                displayJobPopUp = false;                
            } else if(errorTypeFlag==true){ // EPMSSF-513 Changes Modified
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_PO_VIEW_DIR_FILE_TYPE_OTHER_THAN_INSTRUCTION));
                displayJobPopUp = false;
            }else if(errorFlag == true){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_PO_QCCHECK_FILE_STATUS_ARE_NOT_ALLOWED_CHANGE_JOB_TITLE));
                displayJobPopUp = false;    
            }else{                
                getFilesCheckedJobs = [Select id, Name,File_Job_Titles__c from Files__c where id=:filePopList and Production_Order__c = : parentIdValue  ];               
                displayJobPopUp = true; 
            } 
            
        }
        
    }

    //EPMSSF-513    
    public List<SelectOption> getJobList() {       
        Set<String> orderJobSet= new Set<String>();
        list<Job_Titles__c> JobTitles = new list<Job_Titles__c>();
        //JobTitles = [Select id,Name from Job_Titles__c ORDER BY Name];
        JobTitles = [Select id, Name from Job_Titles__c where Disabled__c = false ORDER BY Name ASC];
        system.debug('Current Time 33 : ' + system.now());
        for(Job_Titles__c job:JobTitles){
            orderJobSet.add(job.Name);
        }        
        List <String> testJobList2= new List<String>();
        List<SelectOption> options = new List<SelectOption>();       
        for(Job_Titles__c jobOption:JobTitles){           
            testJobList2.add(jobOption.Name);
            options.add(new SelectOption(jobOption.Name,jobOption.Name));
        }       
        return options;        
    }
    
    
    //EPMSSF-513
    public  void setEPMSJobList  (String[] getEPMSJobList  ) {
        this.EPMSJobList = getEPMSJobList;
    }    
    
    //EPMSSF-513
    public string[] getEPMSJobList() {  
        
        Set<String> orderJobSet1= new Set<String>();       
        list<Job_Titles__c> JobTitles_VD1 = new list<Job_Titles__c>();
        //JobTitles_VD1 = [Select id,Name from Job_Titles__c order by Name];
        JobTitles_VD1 = [Select id, Name from Job_Titles__c where Disabled__c = false ORDER BY Name ASC];
        
        for(Job_Titles__c job_VD1:JobTitles_VD1){
            orderJobSet1.add(job_VD1.Name);
        }
        
        EPMSJobList  = new String[0];       
        Afteraplit = new list<String>();
        if(getFilesCheckedJobs.size()>0){
            for(integer f = 0 ; f<getFilesCheckedJobs.size();f++ ) {        
                if(getFilesCheckedJobs[f].File_Job_Titles__c!=null) {
                    Afteraplit = getFilesCheckedJobs[f].File_Job_Titles__c.split(',');
                }        
            }     
        }   
        avoiddup = new set<String>();
        avoiddup.addall(Afteraplit);
        voided = new list<string>();
        voided.addall(avoiddup);   
        EPMSJobList.addall(voided);          
        return EPMSJobList ;
    }

    /* EPMSSF-513 This method is called when change jobTitle pop up is submitted */
    public void updateObject() {
        
        List<Files__c> updateFilesList = new List<Files__c>();      
        Set<String> setVal = new Set<String>(); 
        
        if(!EPMSJobList.isEmpty()){
            for(Integer i=0;i < EPMSJobList.size();i++){
                setVal.add(EPMSJobList[i]);
            }
        } 
        List<Files__c> newUpdateList = new List<Files__c>();
        system.debug('-------@@@----------wrapperList--------------- : ' + wrapperList);
        if(!wrapperList.isEmpty()){
            for (Integer idx = 0; idx < wrapperList.size(); idx++) {            
                if (wrapperList[idx].isSelected) {                   
                    updateFilesList.add(wrapperList[idx].fileWrap);
                    Files__c fileObj = (wrapperList[idx].fileWrap);
                    system.debug('-------@@@----------selected wrapperList--------------- : ' + wrapperList[idx].fileWrap);                   
                    stringArray  = EPMSJobList;
                    //updateJobTileChanges(fileObj , EPMSJobList);      
                    newUpdateList.add(fileObj);
                }         
            }
            
            system.debug('$$$$$$$$$$  newUpdateList :::  ' + newUpdateList);
            
        }      
        if(newUpdateList != null && newUpdateList.size() > 0){
            updateJobTileChanges(newUpdateList, EPMSJobList); 
        }
        displayJobPopUp = false;
    }
    
    //EPMSSF-513
    //public void updateJobTileChanges(Files__c fileObj, String[] EPMSJobList){
    public void updateJobTileChanges(List<Files__c> fileObjList, String[] EPMSJobList){
        string updatedPOJobTitle = jobListNames;
        Set<String> setVal = new Set<String>();      
        
        if(!EPMSJobList.isEmpty()){     
            for(Integer i=0;i < EPMSJobList.size();i++){
                setVal.add(EPMSJobList[i]);
            }
        } 
        
        list<String> JoblistValue = new list<String>();
        JoblistValue.addAll(setVal);
        List<Files__c>  pjToUpdate = new List<Files__c>();
        String Job_Values = null;
        for(Integer j=0;j < JoblistValue.size();j++){
            
            If(Job_Values == null)
            {
                Job_Values = JoblistValue[j];
            }
            Else
            {
                Job_Values = Job_Values  +','+JoblistValue[j];
            }
        }
        system.debug('Job_Values *********** : ' + Job_Values);
        
        for(Files__c fileObj : fileObjList){
            
            Files__c Fjupdate = new Files__c();
            Fjupdate.id = fileObj.id;
            if(!string.isEmpty(Job_Values)){
                Fjupdate.File_Job_Titles__c= Job_Values;
            }else{
                Fjupdate.File_Job_Titles__c= null;
            }
            
            system.debug('Fjupdate *********** : ' + Fjupdate);
            pjToUpdate.add(Fjupdate);   
        }
        try {
            if(pjToUpdate.size() > 0){                 
                update pjToUpdate;                
            }
        }catch(DMLException me) {            
            system.debug('Error Throws : ' +me.getMessage());  
        }        
    }         
}