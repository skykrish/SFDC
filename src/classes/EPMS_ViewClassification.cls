/****************************************************************************
*   Class               :       EPMS_ViewClassification                     *
*   Created Date        :       12/08/2016                                  *           
*   Description         :       Display Order Files                         *
*                               View classification                         *
*   Created By          :                                                   *                       
*   Version             :       3.0                                         *            
/***************************************************************************/
global  class EPMS_ViewClassification{

    public string poids {get;set;}
    public string catName{get;set;}
    public String sortingChoice {get; set;}
    public String sortType {get;set;}
    public List<SelectOption> sortingoptions {get;set;}
    public List<SelectOption> sortingTypeoptions {get;set;}
    public integer newFileForPageCount  {get; set;}
    public Integer oldPageNumber {get ; set ;}
    public boolean errorTypeFlag {get;set;}
    public boolean isMemberExist{get;set;}
    public string datavalues {get;set;}
    public List<FileWrapper>  wrapperList {public get; public set;}
    public string selectvalueCategory {get; set;}
    public string OrderId{get;set;}
    public List<string> Industoryname{get;set;}
    public Boolean errorFlag{get; set;} 
    public String completeMsg           {get;set;}
    public boolean displayChangeExt     {get;set;}
    public boolean submitButtonCat {get;set;}
    public boolean viewDirectory {get;set;}
    public boolean classification{get;set;}
    public boolean orderInformation {get;set;}
    public boolean orderFiles {get;set;}
    public string parentId {get; set;}
    public Id parentIdValue{get; set;}
    Set<Id> resultsId = new Set<Id>();
    public List<Files__c> poFilesList{public get; public set;}
    Production_Order__c poObj = new Production_Order__c();     
    public boolean multiSelectError {get;set;}

    // Used in displayOrderFiles
    List<Files__c> fileList = new List<Files__c>();  
    public Boolean showGrid{get;set;}
    public Boolean showList{get;set;}
    EPMS_MyDirectory_Service Dirservice = new EPMS_MyDirectory_Service();
    //Used in showJobTitlePopUp()
    List<Files__c> selList;
  
    //Used in showVDJobpopup
    public string salesregionuser{get;set;}
    public string thumbnailIP {get;set;}
    public string Locationid{get;set;}

    public List<Files__c> filePopList;
    public List<Files__c> fileStatusList; 
    // Used in UpdateObject
    String[] stringArray = new String[]{};
  
  
    List<Files__c> updateFilesList;
    // Used in ViewClassification()

    public List<AggregateResult> fileClassficationList {public get; public set;}

    List<File_Categories__c> categoryList = new List<File_Categories__c>();
    public List<AggregateResult> Result {get;set;} 
    List<Id> Ids;
    public Integer SumOfTotal { get; set; }
    public Integer CompSumOfTotal { get; set; }
    public Production_Order__c POquery{get;set;}
    
    public Integer setUserChoice { get; set; }
    
    EPMS_ViewDirectoryService serviceObj = new EPMS_ViewDirectoryService();
    // Call the service : Production Order - View Directory
    EPMS_ViewClassification_Service service = new EPMS_ViewClassification_Service();
    public Production_Order__c poObjDisplay {public get; public set;}
    public string instructionVDSource {public get; public set;}
    private Integer OffsetSize = 0;
    private Integer QueryLimit = 10;
    private Integer CountTotalRecords = 0;
    public Long noOfPages {get; set;}
    public Long currentPage {get; set;}
    List<string> reqids = new List<string>();
    public string status {get;set;}
    public EPMS_ViewClassification()     
    {
        
        showGrid = true;
        displayChangeExt = false;
        submitButtonCat = true;
        poids = ApexPages.currentPage().getParameters().get('ids');
        status =ApexPages.currentPage().getParameters().get('status');
        system.debug('$$$$$$$ status ' + status);
        
        if (status == 'Estimation') { 
            status = 'Estimation';
        } else {
            status = 'Approved';
        }   
        for(String key:poids.split(',')){
           reqids.add(key);
        }      
        if(reqids.size()>1)
        {
            orderID = reqids[0];
            catName=reqids[1];
        }
        setUserChoice = 10;
        noOfPages = 1;
        currentPage = 1;
        oldPageNumber = 1;
        errorTypeFlag = false;
        isMemberExist= false;        
        newFileForPageCount = 1;
        selList = new List<Files__c>();
        //orderID = OrderName;
        Industoryname =new List<String>();        
           
        poObj = service.getProdOrderDetails(orderID);      
        parentId = poObj.Name;
        parentIdValue = poObj.id; 
        salesregionuser = poObj.User__c;
        Locationid = poObj.Mbo_Location__c;
        SumOfTotal =0;
        multiSelectError = false;
       
        if(orderID != null){        
            
            fileList = service.getFilesRelatedToProductionOrder(orderID,QueryLimit,OffsetSize,sortingChoice,sortType,catName,status);
            CountTotalRecords = service.getFilesRelatedToProductionOrderCount(orderID,catName,status);
            poObjDisplay  = [SELECT Id,Name,Jobs_List__c, Production_Order_TAT__c,Job_List__c,QC_Incharge__c,TL_Incharge__c,QC_Incharge__r.Name,
                             Production_Order_Status__c,Total_File_Count__c,TL_Incharge__r.Name,Production_Order_Instruction__c  FROM Production_Order__c where Name= : orderID];
           datavalues = string.valueof(poObjDisplay.Production_Order_TAT__c);
           
            if(CountTotalRecords > setUserChoice){              
                Decimal pageCount = (Decimal.valueOf(CountTotalRecords) / Decimal.valueOf(setUserChoice));
                noOfPages = pageCount.round(System.RoundingMode.UP); 
                }else {
                noOfPages = 1;
            } 
            
        }  

           string jobtitle_jobs= null;
           
        if(!fileList.isEmpty()){
            for(Files__c filesObj : fileList ){
               
                jobtitle_jobs=filesObj.File_Job_Titles__c;
            }
        }  
        
       
        wrapperList = new List<FileWrapper>();
        
        
        String titleValues;
        for(Integer i =0; i<fileList.size(); i++ ){

            FileWrapper filewrpObj  = new FileWrapper();
            titleValues = '';
            String instructionToBeDisplay = fileList[i].Instruction__c;          
            
           
            String[] completeSplitInstruction  = new String[]{} ;
            String instructionDisplay = '';                      
            
            filewrpObj.fileInstruction=fileList[i].Instruction__c;
            
            filewrpObj.fileWrap = fileList[i];
            filewrpObj.Thumbnailurl= thumbnailIP +'/'+fileList[i].File_Thumbnail_URL__c;
            filewrpObj.proOrderWrap = fileList[i].Production_Order__r;
            filewrpObj.catWrap = fileList[i].File_Category_Code__r;
            filewrpObj.jobTitles = fileList[i].File_Job_Titles__c;           
            filewrpObj.memWrap = fileList[i].Member__r;          
            wrapperList.add(filewrpObj);
        }
        instructionVDSource = ApexPages.currentPage().getParameters().get('VOId'); 

        if(instructionVDSource != null){

            orderFiles  = false; 
            viewDirectory = true;        
        } else {

            orderFiles  = true ; 
            viewDirectory = false;    
        }      
        
        orderInformation  = false;
        
        classification = false;       
        sortingoptions = new List<SelectOption>();
        sortingoptions.add(new SelectOption('Name','Name'));
        sortingoptions.add(new SelectOption('Status','Status')); 
        sortingoptions.add(new SelectOption('Operator','Operator')); 
        if(sortingoptions.size() > 0){
            sortingChoice = 'Name';
        }        
        sortingTypeoptions = new List<SelectOption>();
        sortingTypeoptions.add(new SelectOption('ASC','ASC'));
        sortingTypeoptions.add(new SelectOption('DESC','DESC'));       
        if(sortingTypeoptions.size() > 0){
            sortType = 'ASC';
        }
    }

    
    public void displayOrderFiles(){       
            
         orderID = ApexPages.currentPage().getParameters().get('ids');
        status =ApexPages.currentPage().getParameters().get('status');
    
        List<Files__c> newfileList = new List<Files__c>();
        if(orderID != null){       
            
           Integer QueryLimit2 =10;
           Integer OffsetSize2 = 0;           
             newfileList = service.getFilesRelatedToProductionOrder(orderID,QueryLimit2,OffsetSize2,sortingChoice,sortType);
             CountTotalRecords = service.getFilesRelatedToProductionOrderCount(orderID,catName,status);           
        }     
        
       
        wrapperList = new List<FileWrapper>();
        
        
       
        for(Integer i =0; i<newfileList.size(); i++ ){

            FileWrapper filewrpObj  = new FileWrapper();            
            
            filewrpObj.fileWrap = newfileList[i];
            filewrpObj.Thumbnailurl= thumbnailIP +'/'+newfileList[i].File_Thumbnail_URL__c;
            filewrpObj.proOrderWrap = newfileList[i].Production_Order__r;
            filewrpObj.catWrap = newfileList[i].File_Category_Code__r;
            filewrpObj.jobTitles = newfileList[i].File_Job_Titles__c;
           
            filewrpObj.memWrap = newfileList[i].Member__r;

            wrapperList.add(filewrpObj);
        }     
        
       
        orderFiles  = true ; 
        orderInformation  = false;
        viewDirectory = false;
        classification = false;
    }
    

    public void getdisplayOrderFiles2(){

       
        List<Files__c> newfileList = new List<Files__c>();       
        if(CountTotalRecords > setUserChoice){

            Decimal pageCount = (Decimal.valueOf(CountTotalRecords) / Decimal.valueOf(setUserChoice));
            noOfPages = pageCount.round(System.RoundingMode.UP); 

        } else {
                noOfPages = 1;
            }
       
        if(orderID != null){            
          try{
             if(setUserChoice == 0 && setUserChoice ==null)
             {
                newfileList = service.getFilesRelatedToProductionOrder(orderID,QueryLimit,OffsetSize,sortingChoice,sortType,catName,status);
             }
             else{
                QueryLimit = setUserChoice;
                newfileList = service.getFilesRelatedToProductionOrder(orderID,setUserChoice,OffsetSize,sortingChoice,sortType,catName,status);
             }            
            
            CountTotalRecords = service.getFilesRelatedToProductionOrderCount(orderID,catName,status);
            }catch(exception e){
            system.debug('---------------getdisplayOrderFiles2-------------'+e);
            }
            
        }  
             
        wrapperList = new List<FileWrapper>();    
        
        for(Integer i =0; i<newfileList.size(); i++ ){         

           FileWrapper filewrpObj  = new FileWrapper();  
           
           String instructionToBeDisplay = newfileList[i].Instruction__c;         
          
             
            String[] completeSplitInstruction = new String[]{};
            String instructionDisplay = '';           
            
            //filewrpObj.fileInstruction=instructionDisplay;
            filewrpObj.fileInstruction =newfileList[i].Instruction__c;
            filewrpObj.fileWrap = newfileList[i];
            filewrpObj.Thumbnailurl= thumbnailIP +'/'+newfileList[i].File_Thumbnail_URL__c;
            filewrpObj.proOrderWrap = newfileList[i].Production_Order__r;
            filewrpObj.catWrap = newfileList[i].File_Category_Code__r;
            filewrpObj.jobTitles = newfileList[i].File_Job_Titles__c;          
            filewrpObj.memWrap = newfileList[i].Member__r;
            filewrpObj.TLIncharge = newfileList[i].QCIncharge__r.Name;
            filewrpObj.QCIncharge = newfileList[i].TLInCharge__r.Name;
            wrapperList.add(filewrpObj);
        }  
        
     
        orderFiles  = true ; 
        orderInformation  = false;
        viewDirectory = false;
        classification = false;
        
        SumOfTotal=0;
    }
    

    public pageReference refreshPageRecords(){
         
         if(newFileForPageCount == 0){
            
             newFileForPageCount = 1;
             OffsetSize = 0;
             oldPageNumber = 1;
             getdisplayOrderFiles2();
             return null;
         }
       
         if(newFileForPageCount > noOfPages){ 
             newFileForPageCount = Integer.valueOf(noOfPages);
             OffsetSize = (Integer.valueOf(noOfPages) * QueryLimit) - QueryLimit;           
             oldPageNumber = Integer.valueOf(newFileForPageCount);
             getdisplayOrderFiles2();
             return null;
         }
        
         if(oldPageNumber < Integer.valueOf(newFileForPageCount)){   
         
             Integer diff = Integer.valueOf(newFileForPageCount) - oldPageNumber ;
             
             OffsetSize += (QueryLimit * diff);
         } else {          
            if(newFileForPageCount == 0){                 
                newFileForPageCount = 1;
                OffsetSize = 0;
                getdisplayOrderFiles2();
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
         getdisplayOrderFiles2();       
         return null;
    }

     public pageReference refreshPageRecordsList(){         
         return null;
    }
   
    public with sharing class WrappedRecord {
        
        public Files__c detail { get; set; }
        public List<WrappedRecord> children { get; set; }
        public WrappedRecord(Files__c theRecord) {
            this.detail = theRecord;
            this.children = new List<WrappedRecord>();
        }
    }
    
    public with sharing class FileWrapper{

        public Files__c fileWrap{ public get; public set; }
       
        public Production_Order__c proOrderWrap{public get; public set;}
        public File_Categories__c  catWrap{public get; public set;}
        public Member__c memWrap{public get; public set;}
        public Boolean isSelected{get; set;}
        public String Thumbnailurl{get;set;}
        public String jobTitles{get;set;}
        public String fileInstruction{get;set;}
        public string QCIncharge{get;set;}
        public string TLIncharge{get;set;}
        
        public FileWrapper() {
            fileWrap = new Files__c();
            proOrderWrap = new Production_Order__c();
            catWrap = new File_Categories__c ();
            memWrap = new Member__c();
            isSelected = false;
            fileInstruction = '';
            Thumbnailurl='';
            TLIncharge = '';
            QCIncharge = '';
        }
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
    
        Pagereference pageref=new Pagereference('/apex/EPMS_View_Classifications'); 
        pageRef.getParameters().put('ids',orderID+','+catName);
        pageRef.getParameters().put('status',status);
        
        pageRef.setredirect(true);
        OffsetSize += QueryLimit;
        currentPage += 1;
        newFileForPageCount+=1;
        getdisplayOrderFiles2();
         return null;
    }
 
    public PageReference Previous() {      

        OffsetSize -= QueryLimit;
        currentPage -= 1;
        newFileForPageCount -=1;
        getdisplayOrderFiles2();
        return null;
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

    public pageReference refresh() {
        OffsetSize=0;
        getdisplayOrderFiles2();
        newFileForPageCount = 1;
        return null;
    }
        
        
    public pageReference DisplayGrid(){
        showGrid = true;
        showList = false;
        return null;
    }
    public pageReference DisplayList(){
        showGrid = false;
        showList = true;
        

        if(viewDirectory){

            orderFiles  = false; 
            viewDirectory = true;        
        } else {

            OffsetSize=0;
            orderFiles  = true ; 
            viewDirectory = false;    
            getdisplayOrderFiles2();
            newFileForPageCount = 1;
        }
        return null;
    }
    
    
       public void saveChangeCategory(){
      
       if(String.isBlank(selectvalueCategory) || selectvalueCategory == null){
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the category to update a File.'));
           return;
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
            system.debug('***********status = ' + status);
            if(FileList != null && FileList.size()>0){
                for(Files__c FileObj : FileList){
                    
                    if (status == 'Estimation') {
                        FileObj.Estimated_File_Category__c = selectvalueCategory;
                    } else {
                        FileObj.File_Category_Code__c = selectvalueCategory;
                    }
                    
                    
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
        options.add(new SelectOption('','--Select Category--'));
        for(File_Categories__c fileCat: Dirservice.getFileCategoryList()){
        options.add(new SelectOption(fileCat.Id,fileCat.Name));
        }
        return options;
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
            for(Files__c file : selectedFileList){
                selectedFileIdsForUpdate.add(file.Id);                
            }        
        }       
        
    }
    
    
      public void changeCategory(){
      system.debug('File Member is :: &&&&&&&' );
        displayChangeExt = true;
        completeMsg = null;

        String files=Apexpages.currentPage().getParameters().get('fileCategoryId');
         List<id> FileIDsList=new List<id>();

         Files__c filequery = new files__c();
          
    }
   
}