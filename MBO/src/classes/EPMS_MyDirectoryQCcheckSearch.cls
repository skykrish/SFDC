/**********************************************************************************
*   Class               :       EPMS_MyDirectoryQCcheckSearch                     *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Controller to diaplay files related to QC         *
**********************************************************************************/
public without sharing class EPMS_MyDirectoryQCcheckSearch{


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
    public Id parentIdValue{get; set;}
    Production_Order__c poObj = new Production_Order__c();   
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
    private Integer QueryLimit = 10;
    private Integer OffsetSizeNew = 0;
    private Integer QueryLimitNew = 10;
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
    
    /*public void setselectvalueCategory(){
        selectvalueCategory = this.selectvalueCategory;
    }
    
    public String getselectvalueCategory(){
        return selectvalueCategory;
    }*/
    
    //public EPMS_MyDirectoryQCcheck_clone1(ApexPages.StandardController controller)
    public EPMS_MyDirectoryQCcheckSearch()     
    {
        setUserChoice = 10;
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
        poObj = [SELECT Id,Name, Production_Order_TAT__c  FROM Production_Order__c where Name = : orderID];
        parentId = poObj.Name;
        parentIdValue = poObj.id;
        OnHoldCheck=false;
        totalworktime = '';
        totalworktimeOld = '';
        newcatcode='';
        multiSelectError = false;
        totalworktimeformat = '';
        newUpdatecatcode = '';
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
        public Boolean isSelected{get; set;}
        public String jobTitles{get;set;}
        public boolean isCopyFile {get;set;}

        public FileWrapper() {
            
            fileWrap = new Files__c();          
            proOrderWrap = new Production_Order__c();
            catWrap = new File_Categories__c ();
            memWrap = new Member__c();
            isSelected = false;
            isCopyFile = false;
           

        }
    }

    
    
   
    public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('10','10'));
            options.add(new SelectOption('20','20'));
            options.add(new SelectOption('30','30'));
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
        Set<Id> splitedmemberIds = new Set<Id>();
        Set<Id> splittedParentFile = new Set<Id>();
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
            
            /*if(splitParentFileErrorStatus){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected Splited Parent File(s) are On-Hold Status. Can\'t Approved')); 
                return;
            }*/
        }

        if(FileIDsList!= null && FileIDsList.size() > 0 ){            
            FileResultList = Dirservice.getQCFileDetailsForUpdate(FileIDsList);
        }
        

        if(directoryFileIdsList != null && directoryFileIdsList.size() > 0){   
             DirectoryFileList  = Dirservice.getQCChildFileDetailsForUpdate(directoryFileIdsList);
        } 
        
        string searchChild = '%' + '_copy'+'%';
        
        
        Map<Id, Decimal> normalWorkTimeMap = new Map<Id, Decimal>();
        Map<Id, Decimal> normalBreakTimeMap = new Map<Id, Decimal>();
        Map<Id, Integer> normalNoOfBreakMap = new Map<Id, Integer>();
        List<Files__c> childFilesListforParentTime = [SELECT Id, Name, No_of_Breaks__c, Parent_Id__c, Total_Work_time__c, Total_Break_time__c FROM Files__c WHERE Id IN: parentFileIdsSet AND File_Type__c = 'Image' AND (Status__c = 'QC' OR Status__c = 'QCIP' OR Status__c='On-Hold')];
        if(childFilesListforParentTime != null && childFilesListforParentTime.size() > 0){
            for(Files__c normalFile : childFilesListforParentTime){
                normalWorkTimeMap.put(normalFile.Id, normalFile.Total_Work_time__c);
                normalBreakTimeMap.put(normalFile.Id, normalFile.Total_Break_time__c);
                normalNoOfBreakMap.put(normalFile.Id, Integer.valueOf(normalFile.No_of_Breaks__c));
            }
        }
        
        

        List<Files__c> childFilesListforParent = [SELECT Id, Name, No_of_Breaks__c, Parent_Id__c, Total_Work_time__c, Total_Break_time__c FROM Files__c WHERE Parent_Id__c IN: parentFileIdsSet AND File_Type__c = 'Image' AND Name LIKE: searchChild AND (Status__c = 'QC' OR Status__c = 'QCIP' OR Status__c='On-Hold')];
        
        
        List<Files__c> SplittedChildFiles = [Select id,Name,Member__c, Splitted_Parent_id__c, No_of_Breaks__c, Parent_Id__c, Total_Work_time__c, Total_Break_time__c FROM Files__c WHERE Splitted_Parent_id__c IN: SplittedparentFileIdsSet AND File_Type__c = 'Image'];
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
            
            }
            
            if(SplittedChildFiles!=null && SplittedChildFiles.size()>0 && SplittedparentFileIdsSet!=null )
            {       
            
              for(Id SplitP : SplittedparentFileIdsSet)
                {

                Integer count = 0;
                Integer loopcount = 0;
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
                                    //totalworktime = ChildSplitFile.Total_Work_time__c + value1 + remindar;
                                    
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
            
        Map<Id, Decimal> totalWorkTimeMap = new Map<Id, Decimal>();
        Map<Id, Decimal> totalBreakTimeMap = new Map<Id, Decimal>();
        Map<Id, Integer> totalNoOfBreakMap = new Map<Id, Integer>();
        Decimal totalWorkingTime = 0.0;
        Decimal totalBreakingTime = 0.0;
        Integer totalNoOfBreak = 0;
        if(childFilesListforParent != null && childFilesListforParent.size() > 0){
            for(Id parentFileId :parentFileIdsSet){
                totalWorkingTime = 0.0;
                totalBreakingTime = 0.0;
                totalNoOfBreak = 0;
                for(Files__c childFile : childFilesListforParent){
                    if(childFile.Parent_Id__c == parentFileId){
                        
                        totalWorkingTime += childFile.Total_Work_Time__c;
                        totalBreakingTime += childFile.Total_Break_Time__c;
                        if(childFile.No_of_Breaks__c != null){
                            totalNoOfBreak += Integer.valueOf(childFile.No_of_Breaks__c);
                        }
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
                
                totalNoOfBreakMap.put(parentFileId,totalNoOfBreak);
                totalBreakTimeMap.put(parentFileId,totalBreakingTime);
                totalWorkTimeMap.put(parentFileId,totalWorkingTime);
                
            }
        }
        
        list<Performance_Rating__c> ratingdetails = new list<Performance_Rating__c>();
        ratingdetails = [Select id,Name,File_Category__c,File_Category__r.name,File_Performance_Stf_Min__c,File_Performance_Stf_Max__c,File_Category__r.Standard_Time_per_File_Min__c,File_Category__r.Standard_Time_per_File_Max__c from Performance_Rating__c where Name='Group A'];
        List<Files__c> splitedFileUpdateList = new List<Files__c>();
        if(qcCommentsForFilesForApprove !=null)
        {
             if(FileResultList != null && FileResultList.size()>0){
                for(Files__c FileObj : FileResultList){ 
                        
                        if(isImmediateUpload){
                            // Set the File Status is IMMEDIATE UPLOAD
                            FileObj.QC_Comments__c = qcCommentsForFilesForApprove;
                            FileObj.Status__c = 'Approved';
                            FileObj.Immediate_File__c = isImmediateUpload;
                        } else {
                            // Set the File Status is Approved
                            FileObj.QC_Comments__c = qcCommentsForFilesForApprove;
                            FileObj.Status__c = 'Approved';
                        }
                        if(FileObj.IsSplitedFile__c){
                            
                            if(SplittedChildFiles != null && SplittedChildFiles.size() > 0){
                            
                                for(Files__c ChildSplitFile : SplittedChildFiles){
                                    
                                    if(FileObj.Id == ChildSplitFile.Splitted_Parent_id__c){
                                    

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
                                            
                                            for(Performance_Rating__c perRate : ratingdetailSplit){
                                                if(memPerfName != null && memPerfName == perRate.Name){
                                                    minval = perRate.File_Performance_Stf_Min__c;
                                                    maxval = perRate.File_Performance_Stf_Max__c;
                                                    
                                                    if(totalmins>=minval){
                                                        if(totalmins<=maxval){
                                                            ChildSplitFile.File_Category_Code__c = perRate.File_Category__c;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        splitedFileUpdateList.add(ChildSplitFile);

                                    }
                                    
                                }
                            }
                        } else {
                            if(childFilesListforParent != null && childFilesListforParent.size() > 0 && parentFileIdsSet != null && parentFileIdsSet.size() > 0){
                            
                            
                                
                                if(totalWorkTimeMap.get(FileObj.Id) != null){
                                    FileObj.Total_Work_Time__c = totalWorkTimeMap.get(FileObj.Id);
                                }
                                if(totalBreakTimeMap.get(FileObj.Id) != null){
                                    FileObj.Total_Break_Time__c = totalBreakTimeMap.get(FileObj.Id);
                                }
                                if(totalNoOfBreakMap.get(FileObj.Id) != null){
                                    FileObj.No_of_Breaks__c = totalNoOfBreakMap.get(FileObj.Id);
                                }
                                
                                Decimal totalsecs = totalWorkTimeMap.get(FileObj.Id);
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
                                            
                                        }
                                    }
                                }
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
                    FileObj.QC_Comments__c = qcCommentsForFilesRedo;
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
                multiSelectError = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select One File to update category.'));
                return;
            } 
            for(Files__c file : selectedFileList){
                selectedFileIdsForUpdate.add(file.Id);
                fileId = file.Id;
                break;
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
      
       if(String.isBlank(selectvalueCategory) && String.isBlank(totalworktime)){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter the Work Time (or) Category for File.'));
           return;
       }
       
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
        if(selectedFileList != null && selectedFileList.size() > 0){
            for(Files__c file : selectedFileList){
                selectedFileIdsForUpdate.add(file.Id);
                fileId = file.Id;
                break;
            }
        
        }  
        
        List<Performance_Rating__c> ratingdetails = new List<Performance_Rating__c>();
        Files__c fileInfo = null;
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
        }
        
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
                    if(newCategoryGet == selectvalueCategory){
                        FileObj.File_Category_Code__c = newCategoryGet;
                    } else {
                        FileObj.File_Category_Code__c = selectvalueCategory;
                    }
                    if(!String.isBlank(totalworktime)){
                        FileObj.Total_Work_Time__c = Decimal.valueOf(totalworktime);
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
           
        
         if(selectvalueCategory != null)
         {
         options.add(new SelectOption(newCategoryGet,selectvalueCategory));
         for(File_Categories__c fileCat: Dirservice.getFileCategoryList()){
              if(selectvalueCategory != fileCat.Name){
                  options.add(new SelectOption(fileCat.Id,fileCat.Name));
              }
         }  
         }else{
             options.add(new SelectOption('','--select cat--'));
              for(File_Categories__c fileCat: Dirservice.getFileCategoryList()){
                options.add(new SelectOption(fileCat.Id,fileCat.Name));
             }
         }
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
            options.add(new SelectOption('COMBINE NOT DONE PROPERLY','COMBINE NOT DONE PROPERLY'));
            options.add(new SelectOption('HOLES REMAINING','HOLES REMAINING'));
            options.add(new SelectOption('IMAGE DEPTH CUT','IMAGE DEPTH CUT'));
            options.add(new SelectOption('PATH IS NOT EXACTLY ON THE EDGE','PATH IS NOT EXACTLY ON THE EDGE'));
            options.add(new SelectOption('MORE ANCHOR POINTS','MORE ANCHOR POINTS'));
            options.add(new SelectOption('INCORRECT PATH','INCORRECT PATH'));
            options.add(new SelectOption('CLIPPED UNNATURALLY','CLIPPED UNNATURALLY'));
            options.add(new SelectOption('MORE ANCHOR POINTS','MORE ANCHOR POINTS'));
            options.add(new SelectOption('MISSING FUNDAMENTAL','MISSING FUNDAMENTAL'));
    
        }
        else if(selectMistakeCategory=='SERIOUS MISTAKES'){
            options.add(new SelectOption('No Path','No Path'));
            options.add(new SelectOption('Path Incompleted','Path Incompleted'));
            options.add(new SelectOption('Path Name Displaced','Path Name Displaced'));
            options.add(new SelectOption('Path Duplicated','Path Duplicated'));
            options.add(new SelectOption('COMBINE NOT DONE PROPERLY','COMBINE NOT DONE PROPERLY'));           
        }
        else if(selectMistakeCategory=='VERY SERIOUS MISTAKE'){
            options.add(new SelectOption('Instruction Not Followed','Instruction Not Followed'));
            options.add(new SelectOption('Procedure Not Followed','Procedure Not Followed'));
            options.add(new SelectOption('Image Colour Changed','Image Colour Changed'));
            options.add(new SelectOption('File Renamed','File Renamed'));
            options.add(new SelectOption('Image or Mask Damaged','Image or Mask Damaged'));
            Options.add(new SelectOption('Path Stroke','Path Stroke'));           
            options.add(new SelectOption('Image Replaced','Image Replaced')); 
        }
        
        return options;
    }
      
    public List<SelectOption> getAllFileStatus(){
    
        List <SelectOption> options  = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));         
        Schema.DescribeFieldResult fieldResult = Files__c.Status__c.getDescribe();        
        for( Schema.PicklistEntry f : fieldResult.getPicklistValues())
        {   // || f.getValue() == 'QCIP' = f.getValue() == 'Cancelled' ||
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
                        if(wrapperList[idx].fileWrap.Status__c != 'QCIP'){
                            statusErrorQCIP = true;
                            break;
                        }
                        selectedFileList.add(wrapperList[idx].fileWrap);
                    }
                }
                if(statusErrorQCIP){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected File(s) is not in QCIP Status')); 
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
        
        List<Files__c> SplittedChildFiles = [Select id,Name,Member__c, Splitted_Parent_id__c, No_of_Breaks__c, Parent_Id__c, Total_Work_time__c, Total_Break_time__c FROM Files__c WHERE Splitted_Parent_id__c IN: SplittedparentFileIdsSet AND File_Type__c = 'Image'];
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
        
        List<Files__c> splitedFileUpdateList = new List<Files__c>();
        
        if(qcCommentsForFiles!=null)
        {
             if(FileResultList != null && FileResultList.size()>0){
                for(Files__c FileObj : FileResultList){ 
                    // Set the File Status is Checked
                    FileObj.QC_Comments__c = qcCommentsForFiles;
                    FileObj.Status__c = 'On-Hold';
                    
                    if(FileObj.IsSplitedFile__c){
                            
                            if(SplittedChildFiles != null && SplittedChildFiles.size() > 0){
                            
                                for(Files__c ChildSplitFile : SplittedChildFiles){
                                    if(FileObj.Id == ChildSplitFile.Splitted_Parent_id__c){
                                    
                                        //Decimal totalTimeWithParent = totalChildSplitWorkTimeMap.get(FileObj.Id);
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
                                            
                                            for(Performance_Rating__c perRate : ratingdetailSplit){
                                                if(memPerfName != null && memPerfName == perRate.Name){
                                                    minval = perRate.File_Performance_Stf_Min__c;
                                                    maxval = perRate.File_Performance_Stf_Max__c;
                                                    
                                                    if(totalmins>=minval){
                                                        if(totalmins<=maxval){
                                                            ChildSplitFile.File_Category_Code__c = perRate.File_Category__c;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        splitedFileUpdateList.add(ChildSplitFile);

                                    }
                                    
                                }
                            }
                        
                    }
                    
                    UpFileList.add(FileObj); 
                }
             }
             if(DirectoryFileList != null && DirectoryFileList.size()>0){
                for(Files__c FileObj : DirectoryFileList){ 
                    // Set the File Status is Checked
                    if(FileObj.Status__c != 'Approved' ){
                        FileObj.QC_Comments__c = qcCommentsForFiles;
                        FileObj.Status__c = 'On-Hold';

                    }   
                    
                    
                    UpFileList.add(FileObj); 
                }
             }
            
            if(splitedFileUpdateList != null && splitedFileUpdateList.size() > 0){
                try{
                    update splitedFileUpdateList;
                    System.debug(' Split Child Files - Total Work Time Updated Successfully : On-Hold Scenario');
                }catch(Exception e){                    
                    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_QC_CHECK_STATUS_CHANGE_FAILED));                  
                    System.debug(' Split Child Files - Time Update Failed : ' + e.getMessage());
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
        fileListTest = [Select id, QC_Comments__c, Name, Files_To_open__c, Current_Extension__c ,File_Job_Titles__c,Member__c, Splitted_Parent_id__c,IsSplitedFile__c,File_Location__c, Member__r.Name, Member_Assigned__r.Name,No_of_Breaks__c,File_Category_Code__r.Name,File_PS_Version__c,  File_Category_Code__c,Status__c , Instruction__c, File_HandOver_Instructions__c,File_Thumbnail_URL__c ,Job_List__c,Parent_Id__r.Instruction__c, Production_Order__r.Name,Actual_Time_HH_MM_SS__c, Production_Order__r.Production_Order_Instruction__c,Work_Start_Time__c, Thumbnail_Display__c,Work_End_Time__c,  Production_Order_Name__c, Total_Break_Time_File__c, Total_WorkTime_for_File__c, Total_Work_Time__c, Total_Break_Time__c, order_instructions__c,File_Type__c  from Files__c where Production_Order__r.Name =:orderID AND Status__c IN ('QCIP','On-Hold','Redo','Redo Re-Assigned') AND File_Type__c='Image' AND Name LIKE : queryString Order by Name];
        
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
        if(selectedFileList != null && selectedFileList.size() > 0){
            fileLocation = selectedFileList[0].File_Location__c;
            for(Files__c file : selectedFileList){
                selectedFileIdsForUpdate.add(file.Id);
                if(file.Status__c == 'On-Hold'){
                    checkedFile = true;
                    break;
                }
            }
        
        }
        
        if(checkedFile){
            errorFlag=true;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.EPMS_MBO_QC_CHECK_ON_HOLD_FILES_NO_PENALITY));
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
    
    

}