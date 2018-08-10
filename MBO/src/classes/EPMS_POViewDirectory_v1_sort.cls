/**************************************************************************************************************** 
*   Class               :       EPMS_POViewDirectory_v1_sort                                                    * 
*   Created Date        :       26/07/2016                                                                      *           
*   Description         :       Display Order Files                                                             *
*                               View Directory                                                                  *
*   Created By          :                                                                                       *                       
*   Version             :       3.0                                                                             *
* Modified              : Krishna - EPMSSF-513. Included Error meassage when files_to_open flag is 1 or when    *
Status is in WIP                                                             *           
/***************************************************************************************************************/
global  class EPMS_POViewDirectory_v1_sort{
    
    public list<files__c> fileListDetails=new list<files__c>();
    public List<File_Categories__c> catgList=new list<File_Categories__c>();
    public String sortTitle{get;set;}
    public String sortCatg{get;set;}
    public String selectedCategory {get;set;}
    public String sorting {get; set;}
    public String sortType {get;set;}
    public String sortingChoice{get;set;}
    public String sortChoice{get;set;}
    public String POrecord{get;set;}
    
    
    public List<SelectOption> sortingoptions {get;set;}
    public List<SelectOption> sortingBasedOn{get;set;}
    public List<SelectOption> sortingTypeoptions {get;set;}
    public List<SelectOption> sortingTitleoptions {get;set;}
    public List<SelectOption> sortingCatgoptions{get;set;}
    public List<SelectOption> PORedoList{get;set;}
    
    
    public set<String> filecat = new set<String>();
    public transient list<Files__c> filequery = new list<Files__c>();
    public  List<WrappedRecord> FileRecordWrapper = new List<WrappedRecord>();
    public  List<WrappedRecord> ChildFileRrdWrppr = new List<WrappedRecord>();
    public  FilejasonWrapper responsejsonFiles {get; set;}
    public integer newFileForPageCount  {get; set;}
    public list<Files__c> getFilesCheckedJobs;
    public String selQc { get; set; }
    public List<Files__c > orderInfoList {public get; public set;}
    public transient String FileCalJSON  { get; set; }
    public Map<string,integer> mapTotalFilesJobs {get;set;}
    public String jobListNames;
    public List<Bean> Files {get;set;}
    public Boolean displayChangeTLPopUp { get; set; }
    public Boolean displayChangeQCPopUp { get; set; }
    public Boolean displayVDJobPopUp {get; set;}
    public String JobTitleValue { get; set; }
    public String updateStatus {get;set;}
    public boolean removeDirectory{get;set;}
    public String getJobTitleValues() {
        return null;
    }
    public Integer oldPageNumber {get ; set ;}
    public boolean errorTypeFlag {get;set;}
    public boolean isMemberExist{get;set;}
    public String pickListName { get; set; }
    public string datavalues {get;set;}
    
    public String processType { get; set; }
    public Files__c filerecords {get;set;}   
    public List<Files__c> lstImages {get;set;}
    public List<Files__c> childFiles {get;set;}
    public boolean childCheckbox { get; set; }
    public boolean parentCheckbox{ get; set; }     
    public Files__c lst_Parentid{get; set;}
    
    public List<Production_Order__c> fetchJobLst {public get; public set;}
    public List<FileWrapper>  wrapperList {public get; public set;}
    public List<FileWrapper> filesWithourDirWrapperList {public get; public set;}
    
    public List<Files__c > childFilesList {public get; public set;}
    public String instructionEntered{public get; public set;}
    Public String jobTitleEntered{public get; public set;}
    public String VDFolInstrucEntered { get; set; }
    public String FileListInsruction { get; set; }
    public Boolean displayJobPopUp { get; set; }
    public Boolean displayPopup {get;set;}
    public Boolean displayVdPopup {get;set;}
    public List<cNodes>  mainnodes = New List <cNodes>();   
    
    public string OrderId{get;set;}
    public List<string> Industoryname{get;set;}
    public Boolean errorFlag{get; set;} 
    PageReference pg  = null;
    
    public String[] EPMSJobList = new string[]{};
        
        public boolean viewDirectory {get;set;}
    public boolean classification{get;set;}
    public boolean orderInformation {get;set;}
    public boolean orderFiles {get;set;}
    public string parentId {get; set;}
    public Id parentIdValue{get; set;}
    public string image {get; set;}
    Set<Id> resultsId = new Set<Id>();
    List<Files__c> saveIntroList;
    List<Files__c> tobeSavedIntroList;
    public Boolean displayVDFolPopup {get;set;}
    
    public List<Files__c> instFilesList {get;set;}
    public  list<string> voided;
    public set<String> avoiddup;
    public  list<string> voided_VD;
    public set<String> avoiddup_VD;
    public  list<String> Afteraplit;
    public  list<String> Afteraplit_VD;
    public list<Files__c> getfilejobsVD;
    
    Public List<cNodes> hierarchy{public get; public set;}
    public List<Files__c> poFilesList{public get; public set;}
    public String[] EPMSjob_list = new string[]{}; 
        Production_Order__c poObj = new Production_Order__c();     
    
    // Used in displayOrderFiles
    List<Files__c> fileList = new List<Files__c>();  
    //
    public List<OrderInformationWrapper> inforWrapList{public get; public set;}
    
    public Boolean showGrid{get;set;}
    public Boolean showList{get;set;}
    public  map<string,integer> mapInteger {get;set;}
    
    //Used in showJobTitlePopUp()
    List<Files__c> selList;
    
    public List<String> selectedstringlistjoblisting;
    public string SelectedStringjoblisting;
    
    //Used in showVDJobpopup
    
    public String[] VDEPMSJobList = new string[]{}; 
        public string salesregionuser{get;set;}
    public string thumbnailIP {get;set;}
    public string Locationid{get;set;}
    //
    public List<Files__c> filePopList;
    public List<Files__c> fileStatusList; 
    // Used in UpdateObject
    String[] stringArray = new String[]{};
        
        List<Files__c> updateFilesList;
    // Used in ViewClassification()
    public Integer subTotal{get; set;}
    public Integer fileCode{get; set;}
    public List<AggregateResult> fileClassficationList {public get; public set;}
    public List<String> subTotallst{public get; public set;}
    List<File_Categories__c> categoryList = new List<File_Categories__c>();
    public List<AggregateResult> Result {get;set;} 
    List<Id> Ids;
    public List<File_Categories__c> catList;
    public Map<Id, File_Categories__c> IdCategory;
    
    public List<File_Categories__c> catListNew;
    public Map<Id, File_Categories__c> IdCategoryNew;
    public List<Id> completedFileIds; 
    public Integer SumOfTotal { get; set; }
    public integer OJobTotal{get;set;}
    public Integer CompSumOfTotal { get; set; }
    public Boolean Excel=false;
    
    public Boolean rend { get; set; }
    public Production_Order__c POquery{get;set;}
    public list<WrapperFiles> FilesClassification{get;set;}
    
    //Used in ChangeTLIncharge()
    public SelectOption[] shiftNames{get;set;}
    public SelectOption[] teamNames{get;set;} 
    public SelectOption[] TLNames{get;set;}
    // public String Orderid {get;set;}
    public List<Shift_Assignments__c> teamIdList= null;
    public List<Shift__c> shiftList = new List<Shift__c>();
    public List<Team__c> teamNameList = new List<Team__c>();
    public List<Shift_Assignments__c> qcList = new List<Shift_Assignments__c>();
    Set<Id> teamIds = new Set<Id>();
    Set<Id> MemteamIds = new Set<Id>();
    public String selShift{get;set;}
    public String selTeam{get;set;}
    public list<GroupMember> AllSalesRegion = new list<GroupMember>();
    public list<Settings__c> settingsusers = new list<Settings__c>();
    Public list<member__c> memlist = new  list<member__c>();
    public String selTL{get;set;}  
    public  List<Job_Titles__c> jobNames{get;set;}
    List<Files__c> fileTLPopFilesList;
    public Integer setUserChoice { get; set; }
    
    Public List<Files__c> filesWithourDir{public get; public set;} 
    Public List<Files__c> filesComponent{public get; public set;} 
    Public List<Files__c> InsrtucWithourDir{public get; public set;}
    
    EPMS_ViewDirectoryService serviceObj = new EPMS_ViewDirectoryService();
    // Call the service : Production Order - View Directory
    EPMS_POViewDirectory_Service service = new EPMS_POViewDirectory_Service();
    public EPMS_AnkenService_Class ankenservice = new EPMS_AnkenService_Class();
    public Production_Order__c poObjDisplay {public get; public set;}
    public list<Production_Order__c> PORedoRecords{public get;set;}
    public list<Production_Order__c> PORedoRecords1{public get;set;}
    public string instructionVDSource {public get; public set;}
    private Integer OffsetSize = 0;
    private Integer QueryLimit = 10;
    private Integer CountTotalRecords = 0;
    public Long noOfPages {get; set;}
    public Long currentPage {get; set;}
    public List<Job_Titles__c > JobTitles_VD2=new list<Job_Titles__c >();
    public String selectedStatus {get;set;}
    public boolean showPopup{ get; set; } 
    
    public EPMS_POViewDirectory_v1_sort()     
    {
        system.debug('Current Time 1 : ' + system.now());
        
        if(sortTitle==null && sortCatg==null && sortChoice==null){
            
            sortTitle='None';
            sortCatg='None';
            sortChoice='None';      
            
        }
        
        
        Excel=True;
        setUserChoice = 10;
        selectedCategory ='All';
        noOfPages = 1;
        currentPage = 1;
        oldPageNumber = 1;
        errorTypeFlag = false;
        isMemberExist= false;        
        newFileForPageCount = 1;
        selList = new List<Files__c>();
        
        system.debug('----porecord----'+PORecord);
        
        orderID = ApexPages.currentPage().getParameters().get('id');
        
        
        
        
        Industoryname =new List<String>();        
        instFilesList = new List<Files__c>();     
        system.debug('-----PORecord-----'+orderID);
        poObj = service.getProdOrderDetails(orderID);
        
        system.debug('-----PORecord-----'+poObj.id); 
        
        parentId = poObj.Name;
        parentIdValue = poObj.id; 
        salesregionuser = poObj.User__c;
        Locationid = poObj.Mbo_Location__c;
        SumOfTotal =0;
        system.debug('Current Time 2 : ' + system.now());
        //JobTitles_VD2 = [Select id,Name from Job_Titles__c order by Name];
        JobTitles_VD2 = [Select id, Name from Job_Titles__c where Disabled__c = false ORDER BY Name ASC];
        system.debug('Current Time 3 : ' + system.now()); 
        
        //To get all the file categories for the filters based on CR-508 -->Modified by Udayasri
        
        catgList=[select id,Name from File_Categories__c Order by Name];
        
        if(poObj!=null) {
            AllSalesRegion= [Select Id, UserOrGroupId,Group.Name From GroupMember Where UserOrGroupId =:salesregionuser];
        }
        
        if(poObj!=null&&AllSalesRegion.size()>0) {
            settingsusers = [select id,Name,file_server_nodejs_port_ins_file_access__c,file_server_nodejs_port_thumbnail_access__c,file_server_host__c from Settings__c where Location__c=:Locationid AND Group_Name__c=:AllSalesRegion[0].Group.Name ];
        }
        
        
        if(settingsUsers.size()>0) {
            thumbnailIP =settingsusers[0].file_server_host__c+':'+settingsusers[0].file_server_nodejs_port_thumbnail_access__c;
        }
        system.debug('Current Time 4 : ' + system.now());
        if(Orderid != null) {
            system.debug('??--PORecord-----'+orderID);
            
            shiftNames= new SelectOption[0];
            shiftList = [select Id, Name from Shift__c];
            shiftNames.add(new SelectOption('Select Shift', 'Select Shift')); 
            for(Shift__c shiftObj : shiftList) {
                shiftNames.add(new SelectOption(shiftObj .Id, shiftObj.Name));
            }
            
            displayChangeTLPopUp = true;
        }
        system.debug('Current Time 5 : ' + system.now());      
        if(orderID != null) {  
            system.debug('??--PORecord-----'+orderID);
            
            system.debug('Current Time 6 : ' + system.now());
            fileList = service.getFilesRelatedToProductionOrder(orderID,QueryLimit,OffsetSize,sortChoice,sortCatg,sortTitle,sortingChoice,sortType);
            system.debug('Current Time 7 : ' + system.now());
            
            CountTotalRecords = service.getFilesRelatedToProductionOrderCount(orderID,sortChoice,sortCatg,sortTitle);
            system.debug('--------count-------'+CountTotalRecords);
            system.debug('Current Time 8 : ' + system.now());
            
            poObjDisplay  = [SELECT Id,Name,Jobs_List__c,Anken_Order__c, Production_Order_TAT__c,Job_List__c,QC_Incharge__c,TL_Incharge__c,QC_Incharge__r.Name,
                             Production_Order_Status__c,Total_File_Count__c,TL_Incharge__r.Name,Production_Order_Instruction__c  FROM Production_Order__c where Id = : orderID];
            system.debug('Current Time 9 : ' + system.now());
            PORecord=poObjDisplay.Id;
            
            system.debug('----poname----'+poObjDisplay.Name);
            
            system.debug('-------------number of POs------'+poObjDisplay.Anken_Order__c);
            
            //To get all the redo records related to the particualar Anken Order as Picklist based on CR-498 --> Modified by Udayasri
            
            PORedoRecords=[select id,name from Production_Order__c where Anken_Order__c=:poObjDisplay.Anken_Order__c limit 1000];  
            
            system.debug('Current Time 10 : ' + system.now());
            system.debug('-------------number of POs------'+PORedoRecords);
            
            
            
            PORedoList=new list<SelectOption>();
            for(Production_Order__c PORedo: PORedoRecords){ 
                PORedoList.add(new SelectOption(PORedo.Id,PORedo.Name));
            }
            
            system.debug('----PORecord----'+PORecord);
            
            
            system.debug('------poid-------'+PORedoList);
            /* if(POrecord!=null){

poObjDisplay  = [SELECT Id,Name,Jobs_List__c,Anken_Order__c, Production_Order_TAT__c,Job_List__c,QC_Incharge__c,TL_Incharge__c,QC_Incharge__r.Name,
Production_Order_Status__c,Total_File_Count__c,TL_Incharge__r.Name,Production_Order_Instruction__c  FROM Production_Order__c where Id = : POrecord]; 

}*/
            
            
            
            
            
            
            datavalues = string.valueof(poObjDisplay.Production_Order_TAT__c);
            
            jobListNames = string.valueOf(poObjDisplay.Job_List__c);
            system.debug('-----------------jobListNames---------------'+jobListNames);
            
            system.debug('--------------------jobNames---------------------------'+jobNames);
            
            jobNames = new List<Job_Titles__c>();
            
            /*     if(jobListNames != null){for(String jobName:jobListNames.split(',')){if(jobName.equals('Clipping')){jobNames.add(jobName);}} } */            jobNames = [select id,Name from Job_Titles__c where Name !=:'Clipping'];
            
            system.debug('--------------------jobNames---------------------------'+jobNames);
            if(CountTotalRecords > setUserChoice) {              
                Decimal pageCount = (Decimal.valueOf(CountTotalRecords) / Decimal.valueOf(setUserChoice));
                noOfPages = pageCount.round(System.RoundingMode.UP); 
            }else {
                noOfPages = 1;
            }              
        }  
        string jobtitle_jobs= null;
        
        if(!fileList.isEmpty()) {
            for(Files__c filesObj : fileList ){
                
                jobtitle_jobs=filesObj.File_Job_Titles__c;
            }
        }
        system.debug('Current Time 11 : ' + system.now());
          
        wrapperList = new List<FileWrapper>();
        String titleValues;
        for(Integer i =0; i<fileList.size(); i++ ) {
            
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
            system.debug('----wrapperlist----'+wrapperList);
            
        }
        instructionVDSource = ApexPages.currentPage().getParameters().get('VOId'); 
        system.debug('Current Time 12 : ' + system.now());
        if(instructionVDSource != null) {
            orderFiles  = false; 
            viewDirectory = true;        
        } else { 
            orderFiles  = true ; 
            viewDirectory = false;    
        }      
        orderInformation  = false; 
        classification = false; 
        
        // To get all the statuses as picklist based on CR-508 --->Modified by Udayasri
        
        sortingoptions = new List<SelectOption>();
        sortingoptions.add(new SelectOption('None','None'));
        sortingoptions.add(new SelectOption('Approved','Approved'));
        sortingoptions.add(new SelectOption('Assigned','Assigned'));
        sortingoptions.add(new SelectOption('Cancelled','Cancelled'));
        sortingoptions.add(new SelectOption('Handover','Handover'));
        sortingoptions.add(new SelectOption('New','New'));
        sortingoptions.add(new SelectOption('On-Hold','On-Hold'));
        sortingoptions.add(new SelectOption('QC','QC'));
        sortingoptions.add(new SelectOption('QCIP','QCIP'));
        sortingoptions.add(new SelectOption('Redo','Redo'));
        sortingoptions.add(new SelectOption('Redo Re-Assigned','Redo Re-Assigned'));
        sortingoptions.add(new SelectOption('WIP','WIP'));
        sortingoptions.add(new SelectOption('Estimation Required','Estimation Required'));
        sortingoptions.add(new SelectOption('Awaiting Approval','Awaiting Approval'));
        sortingoptions.add(new SelectOption('Estimated','Estimated'));
        sortingChoice = 'Name';
        
        /*    if(sortingoptions.size() > 0){sortChoice = 'None';}   */ 
        sortingCatgoptions=new list<SelectOption>();
        sortingCatgoptions.add(new SelectOption('None','None'));
        for(File_Categories__c catg: catgList){ 
            sortingCatgoptions.add(new SelectOption(catg.Name,catg.Name));
        }
        
        system.debug('Current Time 13 : ' + system.now());
        
        sortingBasedOn= new List<SelectOption>();
        sortingBasedOn.add(new SelectOption('Name','Name'));
        sortingBasedOn.add(new SelectOption('Status','Status'));
        sortingBasedOn.add(new SelectOption('Category','Category'));
        sortingBasedOn.add(new SelectOption('Operator','Operator'));
        if(sortingBasedOn.size() > 0){
            sortingChoice = 'Name';
        }  
        
        system.debug('Current Time 14 : ' + system.now());
        /*  if(sortingCatgoptions.size() > 0){sortCatg = 'None';}  */
        sortingTitleoptions=new list<SelectOption>();
        sortingTitleoptions.add(new SelectOption('None','None'));
        for(Job_Titles__c Job: JobTitles_VD2){ 
            sortingTitleoptions.add(new SelectOption(Job.Name,Job.Name));        
        }
        system.debug('Current Time 15 : ' + system.now());
        /*  if(sortingTitleoptions.size() > 0){sortTitle = 'None';}  */
        sortingTypeoptions = new List<SelectOption>();
        sortingTypeoptions.add(new SelectOption('ASC','ASC'));
        sortingTypeoptions.add(new SelectOption('DESC','DESC'));       
        if(sortingTypeoptions.size() > 0) {
            sortType = 'ASC';
        }
        
        system.debug('----orderid----'+orderID);
        
        filequery = ankenservice.getallFiles(orderID);           
        for(Files__c FCat: filequery ) {
            filecat.add(FCat.File_Category_Code__r.Name);
        }  
        
        system.debug('??????PO Record:?????'+POrecord);
        system.debug('Current Time 16 : ' + system.now());  
       
    }
    
    public  void setFileListInsruction  (String getFileListInsruction) {     
        this.FileListInsruction = FileListInsruction;    
         system.debug('Current Time 17 : ' + system.now());
    }
    
    public String xlsHeader {
        get {
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
    
    // EPMSSF-524 Enable Production Order Status Change in the View Directory - Lavanya P
    public pagereference savePOStatus(){
        if((poObjDisplay.Production_Order_Status__c == 'New' || poObjDisplay.Production_Order_Status__c == 'Assigned' || poObjDisplay.Production_Order_Status__c == 'Awaiting Approval'||poObjDisplay.Production_Order_Status__c == 'Cancelled'||poObjDisplay.Production_Order_Status__c == 'Completed'||poObjDisplay.Production_Order_Status__c == 'Customer-Approved'||poObjDisplay.Production_Order_Status__c == 'Estimator Assigned'||poObjDisplay.Production_Order_Status__c == 'Estimation Request'||poObjDisplay.Production_Order_Status__c == 'Handover'||poObjDisplay.Production_Order_Status__c == 'QCIP'||poObjDisplay.Production_Order_Status__c == 'Redo'||poObjDisplay.Production_Order_Status__c == 'Uploaded'||poObjDisplay.Production_Order_Status__c == 'WIP')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Pending status Order can only be changed to New'));
        } else if(poObjDisplay.Production_Order_Status__c == 'Pending'){
            poObjDisplay.Production_Order_Status__c = 'New';
            update poObjDisplay;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Production Order Status Updated Successfully'));
        }
         system.debug('Current Time 18 : ' + system.now());
        return null;
    }
    
    public List<SelectOption> getAllTypeCategory() {     
        List <SelectOption> options  = new List<SelectOption>();
        options.add(new SelectOption('','--Select Category--'));
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('Approved','Approved'));
        return options;
    }
    
    //To call the filterByStatus method when Particular redo order was selected to refresh the Classification page based on selected value based on CR-498 --->Modified by Udayasri
    
    public void refreshRedoRecords(){
        
        SumOfTotal=0;
        
        filterByStatus();
         system.debug('Current Time 19 : ' + system.now());
    }
    
    // To refresh page when the PO Name was changes in picklist of Orderfiles page based on CR-498 ---->Modified by 498
    
    public void refreshRedoRecordsForOrderFiles(){
        
        SumOfTotal=0;
        wrapperList.clear();
        
        system.debug('?????wrapperlist????'+wrapperList);
        getdisplayOrderFiles2();
        system.debug('Current Time 20 : ' + system.now());        
    }
    
    
    public void displayOrderFiles() {
        system.debug('Current Time  displayOrderFiles() : ' + system.now()); 
        system.debug('Current Time 21 : ' + system.now());
        List<Files__c> newfileList = new List<Files__c>();
        if(orderID != null){       
            Integer QueryLimit2 =10;
            Integer OffsetSize2 = 0; 
            
            
            if(POrecord!=null){
                orderID=POrecord;
            }
            
            system.debug('Current Time  displayOrderFiles() : ' + system.now());
            system.debug('Current Time 22 : ' + system.now());
            newfileList = service.getFilesRelatedToProductionOrder(orderID,QueryLimit,OffsetSize,sortChoice,sortCatg,sortTitle,sortingChoice,sortType);
            system.debug('Current Time  displayOrderFiles() : ' + system.now());
            system.debug('Current Time 23 : ' + system.now());
            CountTotalRecords = service.getFilesRelatedToProductionOrderCount(orderID,sortChoice,sortCatg,sortTitle);
            system.debug('Current Time  displayOrderFiles() : ' + system.now());  
            system.debug('Current Time 24 : ' + system.now());
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
        system.debug('Current Time  displayOrderFiles() : ' + system.now());
         system.debug('Current Time 25 : ' + system.now());
    }
    
    public void getdisplayOrderFiles2(){
        system.debug('Current Time getdisplayOrderFiles2 : ' + system.now());
         system.debug('Current Time 26 : ' + system.now());
        CountTotalRecords = service.getFilesRelatedToProductionOrderCount(orderID,sortChoice,sortCatg,sortTitle);
        
        List<Files__c> newfileList = new List<Files__c>();       
        if(CountTotalRecords > setUserChoice) {
            
            Decimal pageCount = (Decimal.valueOf(CountTotalRecords) / Decimal.valueOf(setUserChoice));
            noOfPages = pageCount.round(System.RoundingMode.UP);  
        } else {
            noOfPages = 1;
        }
        if(orderID != null) {  
            
            if(POrecord!=null){
                orderID=POrecord;
            }
            
            
            try{
                if(setUserChoice == 0 && setUserChoice ==null) {
                    
                    //To query the methods in service class based on sortCatg,sortTitle and sortChoice Values based on CR-508--->Modified by Udayasri
                    
                    
                    newfileList = service.getFilesRelatedToProductionOrder(orderID,QueryLimit,OffsetSize,sortChoice,sortCatg,sortTitle,sortingChoice,sortType);
                    
                } else {
                    QueryLimit = setUserChoice;
                    
                    newfileList = service.getFilesRelatedToProductionOrder(orderID,QueryLimit,OffsetSize,sortChoice,sortCatg,sortTitle,sortingChoice,sortType);
                    
                    
                }            
                
                
            }catch(exception e){
                system.debug('---------------getdisplayOrderFiles2-------------'+e);
            }
            system.debug('Current Time getdisplayOrderFiles2 : ' + system.now());  
        }  
        
        wrapperList = new List<FileWrapper>();    
        
        system.debug('$$$$ Total No of Files : $$$$ ' + newfileList.size());
        for(Integer i =0; i<newfileList.size(); i++ ) {         
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
            wrapperList.add(filewrpObj);
        }  
        orderFiles  = true ; 
        orderInformation  = false;
        viewDirectory = false;
        classification = false;
        
        SumOfTotal=0;
        system.debug('Current Time getdisplayOrderFiles2 : ' + system.now());
         system.debug('Current Time 27 : ' + system.now());
    }
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
                        } else if(filedata.Status__c=='Approved' || filedata.Status__c =='Pending' ||filedata.Status__c =='Deleted'|| filedata.Status__c =='Cancelled' || filedata.Status__c =='WIP'){
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
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_PO_VIEW_DIR_FILE_STATUS_ARE_NOT_ALLOWED_CHANGE_JOB_TITLE));
                displayJobPopUp = false;    
            }else{                
                getFilesCheckedJobs = [Select id, Name,File_Job_Titles__c from Files__c where id=:filePopList and Production_Order__c = : parentIdValue  ];               
                displayJobPopUp = true; 
            } 
            
        }
        
    }
    //View Directory(Menu) - Change Job Title(Button)
    List<Files__c> fileVDJobPopList;
    public void showVDjobPopup(){
        hierarchy = new List<cNodes>();
        fileVDJobPopList = new List<Files__c>();
        String files=Apexpages.currentPage().getParameters().get('openJobFiles'); 
        System.debug('job title error                     '+files);
        files = files.replace('on,','');
           
        String[] FileIds = files.split(',');
        System.debug('--------------FileIds---------------'+FileIds);
         system.debug('Current Time 29 : ' + system.now());
        List<id> FileIDsList=new List<id>();
        for(string membersSplited:FileIds){
            if(membersSplited!=null) {
                FileIDsList.add(membersSplited);
            }
        }        
        if(FileIds!= null) {             
            FileList = service.getFilesToOpenList(FileIDsList);
            for(Files__c fileData:FileList){
                fileVDJobPopList.add(fileData);
            }
        }
        if(hierarchy.size() > 0){
            for (Integer idx = 0; idx < hierarchy.size(); idx++){
                if (hierarchy[idx].isSelected){                  
                    fileVDJobPopList.add(hierarchy[idx].gparent);                 
                }
            }   
        }
        getfilejobsVD = new list<Files__c>();
        if(fileVDJobPopList.isEmpty()){          
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Record_Select));
            errorFlag = true;
            displayVDFolPopup = false;
        }else{           
            getfilejobsVD = [select id, Name , File_Job_Titles__c from Files__c where id=:fileVDJobPopList And Production_Order__c = : parentIdValue ];
            displayVDJobPopUp = true;           
        }  
    }
    
    public string[] getVDEPMSJobList() {             
        Set<String> orderJobSet2= new Set<String>();
        Set<String> vdorderJobSet1= new Set<String>();
        list<Job_Titles__c > JobTitles_VD2 = new list<Job_Titles__c>();
        //JobTitles_VD2 = [Select id,Name from Job_Titles__c order by Name];
        JobTitles_VD2 = [Select id, Name from Job_Titles__c where Disabled__c = false ORDER BY Name ASC];
        
        for(Job_Titles__c job_VD2:JobTitles_VD2){
            orderJobSet2.add(job_VD2.Name);
        }
        VDEPMSJobList  = new String[0];               
        Afteraplit_VD = new list<String>();      
        if(getfilejobsVD.size()>0){
            for(integer f = 0 ; f<getfilejobsVD.size();f++ ) {      
                if(getfilejobsVD[f].File_Job_Titles__c!=null){
                    Afteraplit_VD = getfilejobsVD[f].File_Job_Titles__c.split(',');
                }     
            }   
        }   
        avoiddup_VD = new set<String>();
        avoiddup_VD.addall(Afteraplit_VD);
        voided_VD = new list<string>();
        voided_VD.addall(avoiddup_VD);
        VDEPMSJobList.addall(voided_VD);    
        return VDEPMSJobList;
    }
    
    public  void setVDEPMSJobList  (String[] getVDEPMSJobList  ) {        
        this.VDEPMSJobList = getVDEPMSJobList;
        
    }
    Set<String> setValForVD = new Set<String>();
    //View Directory(Menu) - Change Job Title(Command Button) - Submit(popupButton)  
    public void updateVDJobPopup(){      
        if(!VDEPMSJobList.isEmpty()){
            for(Integer i=0; i < VDEPMSJobList.size();i++){
                setValForVD.add(VDEPMSJobList[i]);
            }
        }  
        List<Files__c> saveVDJobPopList;
        system.debug('************* VDEPMSJobList : ' + VDEPMSJobList);
         system.debug('Current Time 30 : ' + system.now());
        system.debug('************* fileVDJobPopList Size : ' + fileVDJobPopList.size());
         system.debug('Current Time 31 : ' + system.now());
        system.debug('************* fileVDJobPopList : ' + fileVDJobPopList);
        updateJobTileChangesForVD(fileVDJobPopList,VDEPMSJobList);
        system.debug('Current Time 32 : ' + system.now());
        
        displayVDJobPopUp = false;
    }
    
    public void updateJobTileChangesForVD(List<Files__c> fileObjs, String[] VDEPMSJobList){
        
        Set<String> setVal = new Set<String>();
        if(!VDEPMSJobList.isEmpty()){     
            for(Integer i=0;i < VDEPMSJobList.size();i++){
                setVal.add(VDEPMSJobList[i]);
            }
        }     
        list<String> JoblistValue_VD = new list<String>();
        JoblistValue_VD.addAll(setVal);
        List<Files__c>  pjToUpdate_VD = new List<Files__c>();
        String Job_Valuesvd = null;
        for(Integer q=0;q < JoblistValue_VD.size();q++){               
            If(Job_Valuesvd == null) {
                Job_Valuesvd = JoblistValue_VD[q];
            } else {
                Job_Valuesvd = Job_Valuesvd  +','+JoblistValue_VD[q];
            }
        }
        Files__c Fjupdate = new Files__c();
        
        for(Files__c file:fileObjs){
            Fjupdate = file;
            if(!string.isEmpty(Job_Valuesvd)) {
                Fjupdate.File_Job_Titles__c= Job_Valuesvd;  
            } else {
                Fjupdate.File_Job_Titles__c= null; 
            }
            pjToUpdate_VD.add(Fjupdate); 
        }
        try {
            if(pjToUpdate_VD.size() > 0){               
                update pjToUpdate_VD;                
            }
        }catch(DMLException me) {              
            system.debug('Error Throws : ' +me.getMessage());   
        } 
    }
    
    //View Directory(Menu) - Change Job Title(Command Button) - Cancel(popupButton)  
    public void closeVDJobPopup(){        
        displayVDJobPopUp = false;
    }
    
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
    public  void setEPMSJobList  (String[] getEPMSJobList  ) {
        this.EPMSJobList = getEPMSJobList;
    }
    
    /* This method is called when change jobTitle pop up is submitted */
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
    public List<SelectOption> getVDJobList() {
        
        Set<String> orderJobSet= new Set<String>();
        list<Job_Titles__c> JobTitles_VD1 = new list<Job_Titles__c>();
        //JobTitles_VD1 = [Select id,Name from Job_Titles__c order by Name];
        JobTitles_VD1 = [Select id, Name from Job_Titles__c where Disabled__c = false ORDER BY Name ASC];
        system.debug('Current Time 34 : ' + system.now());
        for(Job_Titles__c job_VD1:JobTitles_VD1){
            orderJobSet.add(job_VD1.Name);
        }   
        List <String> testJobList2= new List<String>();
        List<SelectOption> options = new List<SelectOption>();
        for(Job_Titles__c jobOption_VD1: JobTitles_VD1){
            
            testJobList2.add(jobOption_VD1.Name);
            options.add(new SelectOption(jobOption_VD1.Name,jobOption_VD1.Name));
        }
        return options;
    }
    public with sharing class cNodes
    {
        public List<Files__c> parent {get; set;}
        Public Files__c gparent {get;set;}
        public Boolean  isSelected  { get;set; }
        public cNodes(Files__c  gp, List<Files__c> p) {       
            parent = p;       
            gparent = gp;   
            isSelected =   false;
        }  
    }
    
    public String getAllDetails() {
        List<Bean> Files = new List<Bean>(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String orderID = ApexPages.currentPage().getParameters().get('id');
        List<Files__c> filesComponent = new List<Files__c>();
        FilejasonWrapper responsejsonFiles = new FilejasonWrapper();
        system.debug('-----INSIDE SALES REGION LOGIN VIEW DIRECTORY FILE-----');
        if(orderID  != null) {
            
            filesComponent = service.getFilesListRelatedToProductionOrder(orderID);
        }
        
        system.debug('-----VIEW DIRECTORY FILE-----' + filesComponent);
        if(filesComponent.size() > 0){            
            for(Files__c f: filesComponent){
                String filename = f.Name;
                // Ignore the File Name with special characters ' and \
                String ignoreSplCharInName = EPMS_UTIL.ignoreFileNameSpecialCharacters(filename);
                f.Name = ignoreSplCharInName;                
                Files.add(new Bean(f));   
            }
        }
        system.debug('Current Time 35 : ' + system.now());
        FileCalJSON = JSON.serialize(Files);
        return FileCalJSON;        
    }
    
    Public void parentChildNodes(){
        
        orderFiles  = false; 
        orderInformation  = false;
        viewDirectory = true;
        classification = false;
        SumOfTotal=0;       
    }
    
    public void ViewClassification(){
        
        orderFiles  = false; 
        orderInformation  = false;
        viewDirectory = false;
        classification = true; 
    } 
    
    // Filter by Classification All or Approved - Start
    
    public void filterByStatus(){
        if(POrecord!=null){
            orderid=POrecord;
        }
        
        
        
        
        SumOfTotal = 0;
        CompSumOfTotal = 0;
        system.debug('Selected Category is : ' + selectedCategory);
        Map<string,integer> maptotalfiles = new Map<String,integer>();
        Map<string,integer> maptotalfilesC = new Map<String,integer>();
        mapTotalFilesJobs = new Map<String,integer>();
        List<AggregateResult> files = new  List<AggregateResult>();
        List<AggregateResult> optionalFiles = new List<AggregateResult>();
        List<Files__c> optionalJobFiles = new List<Files__c>();
        Map<id,string> optinalJobMap = new Map<id,string>();
        if(orderid!=null){
            POquery = [Select id,name,Production_Order_TAT__c,Total_Anken_Count__c from Production_order__c where id=:orderid Limit 1];
        }
        system.debug('Current Time 36 : ' + system.now());
        if(POquery!=null){
            /* if(selectedCategory == 'Approved'){
files = [SELECT File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Production_Order__c =: POquery.id AND Status__c='Approved' group by File_Category_Code__r.name];         
system.debug(' Approved Files scenario : ' + files.size());
optionalFiles = [SELECT File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Production_Order__c =: POquery.id AND Job_Type__c ='Optional'AND Status__c='Approved' group by File_Category_Code__r.name];  // AND Status__c='Approved'               

}*/
            files = [SELECT File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Production_Order__c =: POquery.id AND Status__c='Approved'  group by File_Category_Code__r.name    ];  //             
            system.debug(' All Files scenario : ' + files.size());
            system.debug('Current Time 37 : ' + system.now());
            optionalFiles = [SELECT File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Production_Order__c =: POquery.id AND Job_Type__c ='Optional' group by File_Category_Code__r.name];  // AND Status__c='Approved'               
            
            
            
            system.debug('Files are in AggregateResult : ' + files);
            system.debug('Current Time 38 : ' + system.now());
            if(files != null && files.size() > 0){
                for(AggregateResult ar : files){
                    Integer totalNoOfFiles = Integer.valueOf(ar.get('NumberOfFiles'));
                    String catogoryName = (string) ar.get('CategoryCode');
                    if(catogoryName != null){
                        maptotalfiles.put(catogoryName,totalNoOfFiles);
                        maptotalfilesC.put(catogoryName,totalNoOfFiles);
                    }   
                }
            }
            
            /* Add the count of the total files which has job_type as optional to a map  */
            
            if(optionalFiles != null && optionalFiles.size() > 0){
                for(AggregateResult ar : optionalFiles){
                    Integer totalNoOfFiles = Integer.valueOf(ar.get('NumberOfFiles'));
                    String catogoryName = (string) ar.get('CategoryCode');
                    if(catogoryName != null){
                        mapTotalFilesJobs.put(catogoryName,totalNoOfFiles);
                    }  
                }
                system.debug('------------------mapTotalFilesJobs-----------------'+mapTotalFilesJobs);
            }
            OJobTotal = 0;
            for(string s:mapTotalFilesJobs.KeySet()){
                OJobTotal += mapTotalFilesJobs.get(s);
                
            }
            system.debug('--------------------OJobTotal--------------'+OJobTotal);
            system.debug('Current Time 39 : ' + system.now());
            
            
            filequery = ankenservice.getallFiles(orderID);           
            for(Files__c FCat: filequery ) {
                filecat.add(FCat.File_Category_Code__r.Name);
            }  
            
            system.debug(' Map 1 Data : ' + maptotalfiles);
            system.debug(' Map 2 Data : ' + maptotalfilesC);
            FilesClassification = new list<WrapperFiles>();
            for(string finalfor:filecat) {
                if(maptotalfiles.KeySet().contains(finalfor)) {
                    WrapperFiles Wrapobj = new WrapperFiles();
                    Wrapobj.ClassificationName = finalfor;
                    Wrapobj.TotalFilesCount = maptotalfiles.get(finalfor);
                    Wrapobj.TotalOJobsFiles = mapTotalFilesJobs.get(finalfor);
                    Wrapobj.CompletedFilesCount = maptotalfilesC.get(finalfor);
                    FilesClassification.add(Wrapobj);
                    
                    if(SumOfTotal==null) {
                        SumOfTotal = maptotalfiles.get(finalfor); 
                    } else {
                        if(maptotalfiles.get(finalfor) != null){
                            SumOfTotal = SumOfTotal+maptotalfiles.get(finalfor);
                        }
                    }
                    if(CompSumOfTotal==null) {
                        CompSumOfTotal = maptotalfilesC.get(finalfor); 
                    } else {
                        if(maptotalfilesC.get(finalfor) != null){
                            CompSumOfTotal = CompSumOfTotal+maptotalfilesC.get(finalfor);
                        }
                    }
                }    
            } 
            FilesClassification.sort();// sorting Wrapper list based on Category Name  
            
            system.debug('--------classification-------'+FilesClassification);
            system.debug('Current Time 40 : ' + system.now());

            /* get the total number of optional files EPMSSF-498 */
            optionalJobFiles = [SELECT id,File_Job_Titles__c  FROM Files__c WHERE Production_Order__c =: POquery.id and Status__c=:'Approved' and file_type__C='Image'];            
        }
        
        if(optionalJobFiles.size()>0){
            for(Files__c f:optionalJobFiles){                
                optinalJobMap.put(f.id,f.File_Job_Titles__c);                
            }
        }
        
        map<string,List<string>> totalOptionalJobs = new  map<string,List<string>>();
        mapInteger = new map<string,integer>();
        
        for(Job_Titles__c sl:jobNames)
        {                        
            integer i = 0;            
            for(string s:optinalJobMap.KeySet()){               
                if(optinalJobMap.get(s).contains(sl.name)) {
                    /**check if exact string is presant */
                    system.debug('--------------sl.name---------------------'+sl.name);
                    system.debug('------------optinalJobMap--------------------'+optinalJobMap.get(s));
                    system.debug('Current Time 41 : ' + system.now());
                    for(String jobName:optinalJobMap.get(s).split(',')) {
                        if(sl.name.equals(jobName)){
                            i++;
                        } 
                    }
                    
                    mapInteger.put(sl.name,i);
                    /*    if(totalOptionalJobs.containsKey(sl.name)){totalOptionalJobs.get(sl.name).add(s);}else{totalOptionalJobs.put(sl.name,new List<string>{s});} */                        
                }                
            }  
        }  
        
        system.debug('--------------totalOptionalJobs--------------'+totalOptionalJobs);
        system.debug('--------------mapInteger--------------'+mapInteger);
         system.debug('Current Time 42 : ' + system.now());

        orderFiles  = false; 
        orderInformation  = false;
        viewDirectory = false;
        classification = true;
    }
    
    // Filter by Classification All or Approved - End
    public void orderInformation(){ 
        
        if(POrecord!=null){
            orderID=POrecord;
        } 
        
        if(orderId != null) {
            
            orderInfoList = serviceObj.getOrderInfoDetails(orderId);
        }          
        Set<String> jobNameSet = new Set<String>();
        String orderInfoJobTitle = '';
        Production_Order__c poObj = new Production_Order__c();
        if(orderId != null) {
            
            poObj = service.getProductionOrderInchargeDetails(orderId);
        }
        inforWrapList = new List<OrderInformationWrapper>();
        OrderInformationWrapper orderInfoWrp = new OrderInformationWrapper();
        orderInfoWrp.orderNumber = parentId;       
        if(!orderInfoList.isEmpty()){
            orderInfoWrp.jobTitles = String.ValueOf(orderInfoList[0].File_Job_Titles__c);
            orderInfoWrp.totalFiles = Integer.valueOf(orderInfoList[0].Production_Order__r.Total_File_Count__c);     
            orderInfoWrp.orderTat =   String.valueOf(orderInfoList[0].Production_Order__r.Production_Order_TAT__c);
            orderInfoWrp.orderStatus = orderInfoList[0].Production_Order__r.Production_order_status__c;
            orderInfoWrp.orderInstruction = orderInfoList[0].Production_Order__r.Production_Order_Instruction__c;
        }
        orderInfoWrp.qcIncharge =  poObj.QC_Incharge__r.Name;
        orderInfoWrp.tlIncharge =  poObj.TL_incharge__r.Name;
        inforWrapList.add(orderInfoWrp);    
        orderFiles  = false; 
        orderInformation  = true;
        viewDirectory = false;
        classification = false;
        SumOfTotal=0;
    }
    public with sharing class OrderInformationWrapper{
        
        public Files__c orderInfoWrap{ public get; public set; }
        public String jobTitles{get;set;}
        public string orderNumber{get;set;}
        public Integer totalFiles{get;set;}
        public string qcIncharge {get;set;}
        public string tlIncharge {get;set;}
        public string orderTat {get;set;}
        public string orderStatus{get;set;} 
        public string orderInstruction {get;set;}
        public string orderAttachment{get;set;} 
        
        public OrderInformationWrapper(){       
            orderInfoWrap = new Files__c();            
        }       
    }
    
    public void viewDirectory() {
        
        orderFiles  = false; 
        orderInformation  = false;
        viewDirectory = true;
        classification = false;
         system.debug('Current Time 43 : ' + system.now());
    }
    
    public PageReference  ExportToExcel(){ 
        system.debug('Current Time 44 : ' + system.now());
        Boolean Excel=True;       
        PageReference Exportexcelpage = new Pagereference('/apex/EPMS_AnkenClassificationsExportExcel' + '?id=' + POquery.id);
        Exportexcelpage.setRedirect(false);
        return Exportexcelpage; 
    }
    
    public Boolean Excel(){
        system.debug('????Excel????'+Excel);
        return Excel;
        
    }
    
    public PageReference savePSCS6(){
        ErrorFlag=false;
        List<Files__c> updateFilesList = new List<Files__c>();
        List<Files__c>  toBeUpdatedList = new List<Files__c>();
        
        if(!wrapperList.isEmpty()){
            for (Integer idx = 0; idx < wrapperList.size(); idx++) {                
                if (wrapperList[idx].isSelected) {
                    updateFilesList.add(wrapperList[idx].fileWrap);
                }
            }
        }      
         system.debug('Current Time 45 : ' + system.now());
        if(updateFilesList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Record_Select));
            errorFlag = true;
        }else{
            for(Files__c obj : updateFilesList){
                if(obj.Status__c=='Assigned' || obj.Status__c =='QC' ||obj.Status__c =='Redo Re-Assigned' || obj.Status__c=='Estimator Assigned'){
                    obj.File_PS_Version__c = 'CS6';
                    obj.Files_To_open__c =  1; 
                    toBeUpdatedList.add(obj);
                } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_PO_VIEW_DIR_FILE_STATUS_TO_BE_OPEN_FOR_ASSIGNED_REDO_REASSIGN_QC));
                    errorFlag = true;
                    return null;
                }  
            }   
        }
         system.debug('Current Time 46 : ' + system.now());
        
        // Update the Photo shop version CS6 in selected files
        try {
            if(toBeUpdatedList.size() > 0){
                
                update toBeUpdatedList;
            }
        }catch(DMLException me) {
            system.debug('STATUS INSIDE THE CATCH :: savePSCS6 Method : ' + me.getMessage());
        } 
        
        return null;
    }
    
    
    public PageReference savePSCC(){
        List<Files__c> updateFilesListCC = new List<Files__c>();
        List<Files__c>  toBeUpdatedListCC = new List<Files__c>();
         system.debug('Current Time 47 : ' + system.now());
        if(!wrapperList.isEmpty()){
            for (Integer idx = 0; idx < wrapperList.size(); idx++) {
                
                if (wrapperList[idx].isSelected) {
                    updateFilesListCC.add(wrapperList[idx].fileWrap);
                }
            }  
        }    
         system.debug('Current Time 48 : ' + system.now());
        if(updateFilesListCC.isEmpty()){  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Record_Select));
            errorFlag = true;
        }else{
            for(Files__c obj : updateFilesListCC){
                obj.File_PS_Version__c = 'CC';
                obj.Files_To_open__c =  1; 
                toBeUpdatedListCC.add(obj);
            }
        }  
         system.debug('Current Time 49 : ' + system.now());
        // Update the Photo shop version CC in selected files
        try {
            if(toBeUpdatedListCC.size() > 0){
                update toBeUpdatedListCC;
            }
        }catch(DMLException me) {
            system.debug('STATUS INSIDE THE CATCH :: savePSCC Method : ' + me.getMessage());
        } 
        return null;   
    }
    
    public void  clearQueue(){
         system.debug('Current Time 50 : ' + system.now());
        List<Files__c> clearList = new List<Files__c>();
        List<Files__c> updateClearList = new List<Files__c>();
        if(!wrapperList.isEmpty()){
            for (Integer idx = 0; idx < wrapperList.size(); idx++) {
                if (wrapperList[idx].isSelected) {
                    clearList.add(wrapperList[idx].fileWrap);
                }
            } 
            system.debug('Current Time 51 : ' + system.now());
            if(clearList.size() > 0){
                for(Files__c obj : clearList){
                    if(obj.Files_To_open__c == 1){
                        obj.Files_To_open__c = 0; 
                        obj.File_PS_Version__c = '';               
                    }  
                    updateClearList.add(obj);  
                } 
                system.debug('Current Time 52 : ' + system.now());
                
                // Clear the Files queue
                try {
                    if(updateClearList.size() > 0){
                        update updateClearList;
                    }
                }catch(DMLException me) {
                    system.debug('STATUS INSIDE THE CATCH :: clearQueue Method : ' + me.getMessage());
                } 
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Record_Select));
                errorFlag = true;
            }
            
        } 
    }
    
    public STring testJobPopVar {get;set;}
    
    public void showPopup() {
        instructionEntered = '';
        errorFlag = false;
        displayPopup = false;
        List<Files__c> filePopList = new List<Files__c>();
        system.debug('Current Time 53 : ' + system.now());
        if(!wrapperList.isEmpty()){
            for (Integer idx = 0; idx < wrapperList.size(); idx++) {
                
                if (wrapperList[idx].isSelected) {
                    filePopList .add(wrapperList[idx].fileWrap);
                }
            }
        }
        system.debug('Current Time 54 : ' + system.now());
        if(filePopList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Record_Select));
            errorFlag = true;
            displayPopup = false;
        }else{
            if(filePopList != null && filePopList.size() > 0){
                for(Files__c file : filePopList){
                    if(file.File_Type__c != 'Image'){
                        displayPopup = false;                    
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_PO_VIEW_DIR_PLEASE_SELECT_FILE_TYPE_AS_IMAGE));
                        return;                    
                    }
                }
            }
            system.debug('Current Time 55 : ' + system.now());
            displayPopup = true;
        }
    }
    
    public void showPopupVDFiles(){
        displayVDFolPopup = false;
        displayJobPopUp = false;
        displayPopup = false;
        displayVdPopup = false;
        String files=Apexpages.currentPage().getParameters().get('openInstrFiles');
        FileListInsruction=files;
        system.debug('Current Time 56 : ' + system.now());
        String[] FileIds = files.split(',');
        List<id> FileIDsList=new List<id>();
        for(string membersSplited:FileIds){
            if(membersSplited!=null){
                FileIDsList.add(membersSplited);
            }
        }
        
        List<Files__c> FileList = new List<Files__c> ();
        List<Files__c> UpFileList = new List<Files__c> ();
        
        if(FileIds!= null){
            try{
                FileList  =  service.getFilesInstructionList(FileIDsList);
            }catch(exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Record_Select));
                
            }
            
            if(FileList.size() > 0){
                for(Files__c file : FileList){
                    /* if(file.File_Type__c != 'Image'){
displayVdPopup= false;                    
ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_PO_VIEW_DIR_PLEASE_SELECT_FILE_TYPE_AS_IMAGE));
return;                    
}*/
                }
                displayVdPopup = true;
                
            }
        } else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Record_Select));
            errorFlag = true;
            displayVdPopup = false;
        }
    }
    
    public void closePopup() {
        displayPopup = false;
    }
    
    public void closeJobTitlePopup() {
        displayJobPopUp = false;
    }
    
    public void cancel(){
        displayPopup = false;
    }
    
    public PageReference editFile(){
        system.debug('Current Time 57 : ' + system.now());
        errorFlag  = false;
        List<Files__c> editFileList = new List<Files__c>();
        
        if(!wrapperList.isEmpty()){
            for (Integer idx = 0; idx < wrapperList.size(); idx++) {
                if (wrapperList[idx].isSelected) {
                    editFileList.add(wrapperList[idx].fileWrap);
                }
            }
        }
        errorFlag = false;     
        string d;
        if(!editFileList.isEmpty()){        
            d = editFileList[0].id;
            pg = new PageReference('/'+d);   
            pg.setRedirect(true);
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Record_Select));
            errorFlag = true;
        }
        return pg; 
    }
    List<Files__c> saveIntrodoeFileWithourtDirList;
    List<Files__c> tobeSavedIntroFileWithoutList;
   
    public PageReference redirectPopup(){       
        saveIntroList = new List<Files__c>();
        tobeSavedIntroList = new List<Files__c>();
        system.debug('Current Time 58 : ' + system.now());
        if(!wrapperList.isEmpty()){
            for (Integer idx = 0; idx < wrapperList.size(); idx++) {               
                if (wrapperList[idx].isSelected) {                  
                    saveIntroList.add(wrapperList[idx].fileWrap);
                }
            }
        }  
        
        if(!saveIntroList.isEmpty()){
            boolean notValidFile = false;
            if(removeDirectory==true){
                for(Files__c file : saveIntroList){
                    if(file.File_Type__c == 'Image'){                    
                        file.Instruction__c= instructionEntered;                
                        
                    }               
                    tobeSavedIntroList.add(file);
                } 
            }else{
                
                for(Files__c file : saveIntroList){
                    if(file.File_Type__c == 'Image'){                   
                        file.Instruction__c= instructionEntered;                    
                    }               
                    tobeSavedIntroList.add(file);
                } 
            }
        }  
         system.debug('Current Time 59 : ' + system.now());
        try {
            if(tobeSavedIntroList.size() > 0){              
                update tobeSavedIntroList;         
            }
        }catch(DMLException me) {          
            system.debug('STATUS INSIDE THE CATCH :: redirectPopup Method : ' +me.getMessage());
        }               
        displayPopup = false;
        return null;
    }
    
    public PageReference redirectVDPopup(){       
        saveIntroList = new List<Files__c>();
        tobeSavedIntroList = new List<Files__c>();
        String[] FileIds = FileListInsruction.split(',');
        List<id> FileIDsList=new List<id>();
         system.debug('Current Time 60 : ' + system.now());
        for(string membersSplited:FileIds){
            if(membersSplited!=null){
                FileIDsList.add(membersSplited);
            }
        }
        
        system.debug('Current Time 61 : ' + system.now());
        if(FileIds!= null) {
            try{
                saveIntroList  =  service.getFilesInstructionList(FileIDsList);
            }catch(exception e){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Record_Select)); 
            }
        }
        List<Files__c> FileList = new List<Files__c> ();
        List<Files__c> UpFileList = new List<Files__c> ();
        if(!saveIntroList.isEmpty()){
            boolean notValidFile = false;          
            for(Files__c file : saveIntroList){
                if(file.File_Type__c == 'Image'){                   
                    
                    file.Instruction__c= instructionEntered;                  
                }               
                tobeSavedIntroList.add(file);
            }    
        }       
        system.debug('Current Time 62 : ' + system.now());
        try {
            if(tobeSavedIntroList.size() > 0){              
                update tobeSavedIntroList;         
            }
        }catch(DMLException me) {          
            system.debug('STATUS INSIDE THE CATCH :: redirectPopup Method : ' +me.getMessage());
        }              
        
        displayPopup = false;
        return null;
    }
    public PageReference redirectJobPopUp(){
        displayJobPopUp  = false;
        return null; 
    }
    // View Directory(Menu) - Change Folder Instructions(Button)
    List<Files__c> fileVDPopList;
    List<Files__c> fileVDPopList1;
    List<Files__c> updateFileswithourDirList;
    
    public void showVDFolPopup() {
        
        String files=Apexpages.currentPage().getParameters().get('openInstrFiles');
        FileListInsruction=files;
        system.debug('Current Time 63 : ' + system.now());
        String[] FileIds = files.split(',');
        List<id> FileIDsList=new List<id>();
        for(string membersSplited:FileIds){
            if(membersSplited!=null){
                FileIDsList.add(membersSplited);
            }
        }
        
        List<Files__c> FileList = new List<Files__c> ();
        List<Files__c> UpFileList = new List<Files__c> ();
        system.debug('Current Time 64 : ' + system.now());
        if(FileIds!= null){
            
            FileList  =  service.getFilesInstructionList(FileIDsList);
            if(FileList.size() > 0){
                if(FileList.size() > 2){
                    VDFolInstrucEntered=FileList[0].Instruction__c;
                }else{
                    for(Files__c fileData:FileList){
                        VDFolInstrucEntered=fileData.Instruction__c;
                    }
                }
            }
        } 
        
        if(FileList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Record_Select));
            errorFlag = true;
            displayVDFolPopup = false;
        }else{
            displayVDFolPopup = true;
        } 
    }
    
    //View Directory(Menu) - Change Folder Instructions(Button) - Submit(button in popup)
    
    List<Files__c> saveVDPopList;
    List<Files__c> saveVDDirFilesPopList;
    List<Files__c> tobeUpdatedList;
    List<Files__c> UpdateFileInsreuction;
    Set<Files__c>  UpdateFileInsreuctionSet;
    List<Files__c> tobeUpdatedListForDirFiles;
    List<Files__c> saveVDFileWithourDirPopList;
    List<Files__c> ToBeUpdatedVDFileWithourDirPopList;
    
    public string redirectVDFolPopup(){   
        
        UpdateFileInsreuction = new List<Files__c>();
        UpdateFileInsreuctionSet = new Set<Files__c>();
        saveVDPopList = new List<Files__c>();
        tobeUpdatedList = new List<Files__c>();
        saveVDFileWithourDirPopList= new List<Files__c>();
        tobeUpdatedListForDirFiles = new List<Files__c>();
        ToBeUpdatedVDFileWithourDirPopList= new List<Files__c>();
        saveVDDirFilesPopList = new List<Files__C>();        
        system.debug('Current Time 65 : ' + system.now());
        if(hierarchy!=null){
            for (Integer idx = 0; idx < hierarchy.size(); idx++){              
                if (hierarchy[idx].isSelected) {                   
                    saveVDPopList.add(hierarchy[idx].gparent);
                }
                if (hierarchy[idx].isSelected) {
                    
                }
            }
        }
        
        if(FileListInsruction!=''){
            
            String files=FileListInsruction;        
            String[] FileIds = files.split(',');
            List<id> FileIDsList=new List<id>();
            for(string membersSplited:FileIds){
                if(membersSplited!=null){
                    FileIDsList.add(membersSplited);
                }
            }
            
            List<Files__c> FileList = new List<Files__c> ();
            List<Files__c> UpFileList = new List<Files__c> ();
            List<Files__c> childFileList = new List<Files__c> ();
            
            if(FileIds!= null){                
                
                FileList  =  service.getFilesInstructionList(FileIDsList); 
                childFileList = service.getChildFilesRecordsInfo(FileIDsList);              
                
                if(FileList.size() > 0 ){
                    for(Files__c fileObj : FileList){
                        // Update the instruction for folder type only
                        if(fileObj.File_Type__c == 'Directory'){
                            fileObj.Instruction__c= VDFolInstrucEntered ; 
                            UpdateFileInsreuctionSet.add(fileObj);   
                        }
                    }                  
                    if(childFileList != null && childFileList.size() > 0){
                        for(Files__c fileObj : childFileList){
                            // Update the instruction for folder type only
                            if(fileObj.File_Type__c == 'Image'){
                                if(fileObj.Instruction__c != null){
                                    String[] instructionArray = fileObj.Instruction__c.split('\\[');                 
                                    if(instructionArray != null && instructionArray.size() > 1){
                                        String fileInst = instructionArray[0];
                                        String[] str2 = fileInst.split('<br>');                                      
                                        fileObj.Instruction__c= str2[0] + ' <br> [ Directory Instruction : ' + VDFolInstrucEntered + ' ]' ;    
                                    } else {
                                        fileObj.Instruction__c= fileObj.Instruction__c + ' <br> [ Directory Instruction : ' + VDFolInstrucEntered + ' ]' ; 
                                    }
                                } else {
                                    fileObj.Instruction__c= ' [ Directory Instruction : ' + VDFolInstrucEntered + ' ] ' ;
                                }
                                
                                UpdateFileInsreuctionSet.add(fileObj);
                            }                         
                            
                        }
                    }
                    UpdateFileInsreuction.addAll(UpdateFileInsreuctionSet);                 
                    try {
                        if(UpdateFileInsreuction.size() > 0){
                            update UpdateFileInsreuction;        
                        }
                    }catch(DMLException me) {
                        system.debug('STATUS INSIDE THE CATCH :: redirectVDFolPopup Method1 : ' + me.getMessage());
                    }               
                }
            }
            
        }
        
        for(Files__c fileObj : saveVDPopList){
            if(fileObj.file_Type__c == 'Directory'){
                fileObj.Instruction__c= VDFolInstrucEntered ;
                tobeUpdatedList.add(fileObj);
            }
        }
        system.debug('Current Time 66 : ' + system.now());
        if(filesWithourDirWrapperList!=null){
            for (Integer idx = 0; idx < filesWithourDirWrapperList.size(); idx++){              
                if (filesWithourDirWrapperList[idx].isSelected) {                  
                    saveVDFileWithourDirPopList.add(filesWithourDirWrapperList[idx].fileWrap);                   
                }               
            }
        }
        
        for(Files__c fileObj : saveVDFileWithourDirPopList){
            if(fileObj.file_Type__c == 'Image'){
                fileObj.Instruction__c= VDFolInstrucEntered ;
                ToBeUpdatedVDFileWithourDirPopList.add(fileObj);
            }
        }        
        
        try {
            if(ToBeUpdatedVDFileWithourDirPopList.size() > 0){
                update  ToBeUpdatedVDFileWithourDirPopList;          
            }
        }catch(DMLException me) {        
            system.debug('STATUS INSIDE THE CATCH :: redirectVDFolPopup Method2 : ' + me.getMessage());        
        }                           
        
        // Update the Files Instruction description for selected file(s)
        try {
            if(tobeUpdatedList.size() > 0){              
                update tobeUpdatedList;              
            }
        }catch(DMLException me) {   
            
        }                   
        
        displayVDFolPopup  = false;
        rend = true;
        return null;
    }
    
    //View Directory(Menu) - Change Folder Instructions(Button) - Cancel(button in popup)
    public void cancelVDFolPop(){
        displayVDFolPopup = false;
    }
    public PageReference changeFileInstruion(){
        system.debug('Current Time 67 : ' + system.now());
        pg = new PageReference('/apex/ChangeTLIncharge');
        pg.setRedirect(true);
        return pg; 
    }
    public void changeTLIncharge(){
        
        fileTLPopFilesList = new List<Files__c>();
        system.debug('Current Time 68 : ' + system.now());
        for (Integer idx = 0; idx < hierarchy.size(); idx++) {
            if (hierarchy[idx].isSelected) {
                fileTLPopFilesList.add(hierarchy[idx].gparent);
            }
        }
        
        if(fileTLPopFilesList.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Record_Select));
            errorFlag = true;
            displayChangeTLPopUp = false;
        }else{
            displayChangeTLPopUp = true;   
        }      
    }
    
    public void changeShift(){
        displayChangeTLPopUp = true;
        teamNames= new SelectOption[0];
        teamNames.add(new SelectOption('Select Team', 'Select Team'));
         system.debug('Current Time 69 : ' + system.now());
        if(selShift != null){
            teamIdList = service.getMemberAssignedInShift(selShift);
        } 
        
        for(Shift_Assignments__c memberObj : teamIdList){
            teamIds.add(memberObj.Member__C);
        }
        
        list<member__c> memTeam = new list<Member__c>();
        memTeam = [select Team_id__c from Member__c where id IN:teamIds];
        for(Member__c teams:memTeam) {
            MemteamIds.add(teams.Team_id__c);
        }
        
        teamNameList  = service.getTeamDetails(MemteamIds);
        for(Team__c teamObj : teamNameList) {
            teamNames.add(new SelectOption(teamObj.id, teamObj.Name));
        }
    }
    
    public void changeTeam(){
        
        displayChangeTLPopUp = true;
        TLNames= new SelectOption[0];
        TLNames.add(new SelectOption('Select TL', 'Select TL'));
         system.debug('Current Time 70 : ' + system.now());
        if(selTeam != null){
            memlist = service.getMemberLocationDetails(selTeam);
        }   
        
        for(member__c qcObj : memlist ){
            TLNames.add(new SelectOption(qcObj.id, qcObj.Name));
        } 
    }  
    
    
    public void saveChanges(){
        
        List<Production_order__c> OrderList = new List<Production_order__c>();
        List<Production_order__c> UpdateOList = new List<Production_order__c>();
        system.debug('Current Time 71 : ' + system.now());
        if(selTL!= null){
            if(POrecord!=null){
                orderID=POrecord;
            }
            OrderList  = service.getProductionOrderTLInchargeDetails(Orderid);
        }
        
        if(!OrderList.isEmpty() && selTL != null){
            for(Production_order__c PObj : OrderList){
                PObj.TL_InCharge__c = selTL;
                UpdateOList.add(PObj);
            }
            
            // Update the Files from Instruction to Image
            try {
                if(UpdateOList.size() > 0){
                    update UpdateOList;
                }
            }catch(DMLException me) {
                system.debug('STATUS INSIDE THE CATCH :: saveChanges Method : ' + me.getMessage());
            } 
            displayChangeTLPopUp = false;
        }
    }   
    public void closeChangeTLPopup(){
        system.debug('Current Time 72 : ' + system.now());
        displayChangeTLPopUp = false;
    }
    
    public SelectOption[] shiftNamesForQC{get;set;}
    public SelectOption[] teamNamesForQC{get;set;} 
    public SelectOption[] qcNamesForQC{get;set;}
    
    public List<Shift_Assignments__c> teamIdListForQC= null;
    public List<Shift__c> shiftListForQC = new List<Shift__c>();
    public List<Team__c> teamNameListForQC= new List<Team__c>();
    
    public list<member__c> memlistForQC = new  list<member__c>();
    Set<Id> teamIdsForQC = new Set<Id>();
    Set<Id> MemteamIdsForQC = new Set<Id>();
    public String selShiftForQC{get;set;}
    public String selTeamForQC{get;set;}
    public String selQcForQC{get;set;}  
    
    public PageReference changeQCIncharge(){
        system.debug('Current Time 73 : ' + system.now());
        if(Orderid != null){
            String files=Apexpages.currentPage().getParameters().get('openFiles');
        }
        
        return null;
        
    }
    
    public void changeShiftForQC(){
        
        teamNamesForQC= new SelectOption[0];
        teamNamesForQC.add(new SelectOption('Select Team', 'Select Team'));
        system.debug('Current Time 74 : ' + system.now());
        if(selShiftForQC != null){
            teamIdListForQC = service.getMemberAssignedInShift(selShiftForQC);
        } 
        
        for(Shift_Assignments__c memberObj : teamIdListForQC){
            teamIdsForQC.add(memberObj.Member__C);
        }
        
        list<member__c> memTeamForQC = new list<Member__c>();
        
        memTeamForQC = service.getMemberTeamDetails(teamIdsForQC);
        for(Member__c teams:memTeamForQC) 
        {
            MemteamIdsForQC.add(teams.Team_id__c);
        }
        
        teamNameListForQC  = service.getTeamDetails(MemteamIdsForQC);
        for(Team__c teamObj : teamNameListForQC){
            teamNamesForQC.add(new SelectOption(teamObj.id, teamObj.Name));
        }
    }  
    
    public void changeTeamforQC(){
        qcNamesForQC = new SelectOption[0];
        qcNamesForQC.add(new SelectOption('Select QC', 'Select QC'));
        system.debug('Current Time 75 : ' + system.now());
        if(selTeamForQC != null){
            memlistForQC = service.getQCMemberOfSelectedTeam(selTeamForQC);
        }   
        for(member__c qcObj : memlistForQC ){
            qcNamesForQC.add(new SelectOption(qcObj.id, qcObj.Name));
        }
    }
    
    public PageReference saveQcChanges()  {
        List<Production_order__c> OrderQCList = new List<Production_order__c>();
        List<Production_order__c> UpdateQCList = new List<Production_order__c>();
        system.debug('Current Time 76 : ' + system.now());
        if(selQcForQC!= null){
            if(POrecord!=null){
                orderID=POrecord;
            }
            OrderQCList  =  service.getProductionOrderQCInchargeDetails(Orderid);
        }
        
        if(!OrderQCList .isEmpty() && selQcForQC != null){
            for(Production_order__c PObj : OrderQCList){
                PObj.QC_InCharge__c = selQcForQC;
                UpdateQCList.add(PObj);
            }
            // Update the Files from Instruction to Image
            try {
                if(UpdateQCList.size() > 0){
                    update UpdateQCList;
                }
            }catch(DMLException me) {
                system.debug('STATUS INSIDE THE CATCH :: saveQcChanges Method : ' + me.getMessage());
            } 
            
            displayChangeQCPopUp = false;
            
        }
        return null;
    }
    
    public List<Files__c> repostFiles(String files){
        
        String[] FileIds = files.split(',');
        List<id> FileIDsList=new List<id>();
        system.debug('Current Time 77 : ' + system.now());
        for(string membersSplited:FileIds){
            if(membersSplited!=null){
                FileIDsList.add(membersSplited);
            }
        }
        List<Files__c> FileList = new List<Files__c> ();
        List<Files__c> UpFileList = new List<Files__c> ();
        if(FileIds!= null){
            FileList  =  service.getOpenFilesTypeList(FileIDsList);
        }
        return FileList;
    }
    
    public List<Files__c> repostDeleteFiles(String files){
        
        String[] FileIds = files.split(',');
        List<id> FileIDsList=new List<id>();
        system.debug('Current Time 78 : ' + system.now());
        for(string membersSplited:FileIds){
            if(membersSplited!=null){
                FileIDsList.add(membersSplited);
            }
        }
        
        List<Files__c> FileList = new List<Files__c> ();
        List<Files__c> UpFileList = new List<Files__c> ();
        if(FileIds!= null && FileIDsList.size()>0){       
            FileList  =  service.getFilesRecords(FileIDsList);
        }
        
        return FileList;
    }
    
    public void  ConvertToorder(){
        List<Files__c> FileList = new List<Files__c> ();
        String files=Apexpages.currentPage().getParameters().get('convertToOrder');
        
        FileList  = repostFiles(files);
        List<Files__c> UpFileList = new List<Files__c> ();
        List<Files__c> UnUpFileList = new List<Files__c> ();
        set<string> ProductionOrderid = new set<String>();
        List<Files__c> InsFileList = new List<Files__c> ();
        List<string> Orderids = new List<String>();
        list<string> insFiles = new list<String>();
        list<Files__c> AllFiles = new list<Files__c>();
        list<Files__c> InstructionExisted = new list<Files__c>();
        list<String> SplitedNames = new List<String>();
        List<Files__c> singleins = new List<Files__c> ();
        List<Files__c> UpdateINSFiles = new List<Files__c> ();
        List<Files__c> UpdateINSSingleFiles = new List<Files__c> ();
        string insval = null;
        map<id,String> InsConatins = new map<id,String>(); 
        system.debug('Current Time 79 : ' + system.now());
        if(FileList.size() > 0)
        {
            for(Files__c FileObj : FileList){
                if(FileObj.File_Type__c == 'Image'){
                    UpFileList.add(FileObj);
                }
                ProductionOrderid.add(FileObj.Production_Order__c);
                insFiles.add(FileObj.id);
            }
        }
        Orderids.addall(ProductionOrderid);
        system.debug('Current Time 80 : ' + system.now());
        
        if(Orderids.size()>0)
        {           
            AllFiles = [select id,Name,File_Type__c,InstructionNames__c from Files__c where Production_Order__c IN:Orderids AND File_Type__c='image' And InstructionNames__c!=Null ];
            system.debug('----------AllFiles------------'+AllFiles);
        }
        system.debug('----------------insfiles-----------'+insFiles);
        for(String FT :insFiles)
        {
            if(insval==null)
            {
                insval=FT;
            }else
            {
                insval=insval+','+FT;
                system.debug('---------insval-------------'+insval);
            }            
        }   
system.debug('Current Time 81 : ' + system.now());        
        for(Files__c F :AllFiles)
        {
            system.debug('---------------TF.InstructionNames__c-------------'+F.InstructionNames__c);
            if(F.InstructionNames__c==insval)
            {
                
                InsFileList.add(F);         
            }else{
                
                SplitedNames = (string.ValueOf(F.InstructionNames__c)).Split(',');             
                for(String T :insFiles)
                {
                    if(SplitedNames.size()==1)
                    {
                        system.debug('---------------T-------------'+T);
                        system.debug('---------------SplitedNames[0]-------------'+SplitedNames[0]);
                        if(T==SplitedNames[0])
                        {
                            singleins.add(F);
                        }               
                    }else{
                        if((string.ValueOf(F.InstructionNames__c)).Contains(T))
                        {
                            InstructionExisted.add(F);
                            InsConatins.put(F.id,T);
                        }               
                    }              
                }             
            }
            system.debug('Current Time 82 : ' + system.now());
            SplitedNames.clear();
        }   
        if(InsFileList.size()>0)
        {
            for(Files__c GY:InsFileList)
            {
                Files__c IU = new Files__c();
                IU.id = GY.id;              
                IU.InstructionNames__c = null;
                UpdateINSFiles.add(IU);
            }
            
        }
        if(singleins.size()>0)
        {
            for(Files__c YRF:singleins)
            {
                Files__c UT = new Files__c();
                UT.id = YRF.id;             
                UT.InstructionNames__c = null;
                UpdateINSSingleFiles.add(UT);
            }
            
        }
        system.debug('Current Time 83 : ' + system.now());
        if(FileList.size() > 0 ){
            for(Files__c FileObj : FileList){                
                if(FileObj.File_Type__c == 'Order Instruction'||FileObj.File_Type__c == 'File Instruction'){
                    string fileid = FileObj.id;                 
                    FileObj.File_Type__c = 'Image';
                    UnUpFileList.add(FileObj);
                    
                } 
            }
            system.debug('Current Time 84 : ' + system.now());
            // Update the Files from Instruction to Image
            try {
                
                if(UpFileList.size()>0){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_PO_VIEW_DIR_PLEASE_SELECT_FILE_TYPE_AS_INSTRUCTION));
                }
                else if(UnUpFileList.size() > 0){
                    update UnUpFileList;
                }
            }catch(DMLException me) {
                system.debug('STATUS INSIDE THE CATCH :: ConvertToorder Method : ' + me.getMessage());
            } 
        }
        system.debug('Current Time 85 : ' + system.now());
        list<String> SplittedValues = new list<String>();
        map<id,String> FinalMap = new Map<id,String>();
        list<files__c> Updateinstructions = new list<files__c>();
        string Names = null;
        for(Files__C HO :InstructionExisted) {
            SplittedValues = (HO.InstructionNames__c).split(',');
            for(integer i =0;i<SplittedValues.size();i++) {
                if((InsConatins.get(HO.id))!=SplittedValues[i]) {
                    if(Names==null) {
                        Names=SplittedValues[i];        
                    }else {
                        Names = Names +','+SplittedValues[i];
                    }
                }           
            }
            FinalMap.put(HO.id,Names);
            Names = null;
            SplittedValues.clear();
        }
        system.debug('Current Time 86 : ' + system.now());
        for(Files__C UP :InstructionExisted) {
            Files__c FI = new Files__c();
            FI.id = UP.id;
            FI.InstructionNames__c = FinalMap.get(UP.id);
            Updateinstructions.add(FI);
        }   
        try{
            if(UpdateINSFiles.size()>0) {
                update UpdateINSFiles;
            }
            if(UpdateINSSingleFiles.size()>0) {
                update UpdateINSSingleFiles;
            }
            
            if(Updateinstructions.size()>0) {
                update Updateinstructions;
            }
        }catch(Exception e) {
            System.debug('THROWS EXCEPTION ::::'+e);
        }
    }
    public void convertToInstrFile() {
        isMemberExist = false;
        system.debug('Current Time 87 : ' + system.now());
        String files=Apexpages.currentPage().getParameters().get('convertToInstrMem');
        instFilesList =repostFiles(files);
        if(instFilesList.size() > 0 ) {
            
            for(Files__c FileObj : instFilesList) {
                if(FileObj.Member__c!=null){
                    isMemberExist=true;
                }
            }
        }   
    }
    
    public void convertToInstructMember(){
        system.debug('Marking Order Attachment : ');
        List<Files__c> UpFileList = new List<Files__c> ();
        List<Files__c> UpdateMemFileList = new List<Files__c> ();
        list<string> existedids = new list<string>();
        set<string> ProductionOrderid = new set<string>();
        system.debug('Current Time 88 : ' + system.now());
        updateStatus = '';
        List<string> Orderids = new List<String>();
        if(instFilesList.size() > 0 ){
            for(Files__c FileObj : instFilesList){
                ProductionOrderid.add(FileObj.Production_Order__c);
            }
        }
        Orderids.addall(ProductionOrderid);
        
        if(instFilesList.size() > 0 ) {
            
            for(Files__c FileObj : instFilesList) {
                FileObj.Member__c=null;
                UpdateMemFileList.add(FileObj);
            }
            system.debug('Current Time 89 : ' + system.now());
            try{
                if(UpdateMemFileList.size()>0 && UpdateMemFileList!=null){
                    update UpdateMemFileList;
                }
            }catch(Exception e){
                system.debug('Error Message 1st catch :::' + e.getMessage());
            }
            
            for(Files__c FileObj : UpdateMemFileList){
                if(FileObj.File_Type__c=='image'){
                    FileObj.File_Type__c = 'Order Instruction';
                    UpFileList.add(FileObj);
                }else{
                    if(FileObj.File_Type__c != 'Directory'){
                        FileObj.File_Type__c = 'Order Instruction';
                        UpFileList.add(FileObj);
                        existedids.add(FileObj.id); 
                    } 
                }
            }
            system.debug('Final Updated Files List : ' + UpFileList);
            // Update the Files type 
            try {
                if(UpFileList.size() > 0){
                    update UpFileList;
                    updateStatus = 'SuccessFully updated Selected Records';
                    instFilesList.clear();
                }
            }catch(DMLException me) {
                system.debug('Error Message :::' + me.getMessage());
            }            
            UpdateInstructionNamesinFile(existedids,Orderids);
        }        
    }
    
    public void ConvertToInstruction() {
        List<Files__c> FileList = new List<Files__c> ();
        String files=Apexpages.currentPage().getParameters().get('convertToInstr');
        FileList  = repostFiles(files);
        List<Files__c> UpFileList = new List<Files__c> ();
        list<String> existedids = new list<String>();
        updateStatus = '';      
        set<string> ProductionOrderid = new set<String>();
        List<string> Orderids = new List<String>();
        system.debug('Current Time 90 : ' + system.now());
        if(FileList.size() > 0 ) {
            for(Files__c FileObj : FileList){
                ProductionOrderid.add(FileObj.id);
            }
        }
        Orderids.addall(ProductionOrderid);
        
        if(FileList.size() > 0 ) {
            for(Files__c FileObj : FileList){
                if(FileObj.File_Type__c=='image') {
                    FileObj.File_Type__c = 'Order Instruction';
                    UpFileList.add(FileObj);
                } else {
                    FileObj.File_Type__c = 'Order Instruction';
                    UpFileList.add(FileObj);
                    existedids.add(FileObj.id);
                }
            } 
            system.debug('Current Time 91 : ' + system.now());
            // Update the Files type 
            try {
                if(UpFileList.size() > 0) {
                    //update UpFileList;
                }
            }catch(DMLException me) {
                system.debug('STATUS INSIDE THE CATCH :::' + me.getMessage());
            }           
        }
        if(existedids.size()>0&&existedids!=null) {
            
            List<Files__c> AllinsFiles = new list<Files__c>();
            List<Files__c> InsFileList = new list<Files__c>();
            List<Files__c> singleins = new list<Files__c>();
            List<Files__c> InstructionExisted = new list<Files__c>();
            List<Files__c> UpdateINSFiles = new list<Files__c>();
            List<Files__c> UpdateINSSingleFiles = new list<Files__c>();
            Map<id,string> InsConatins = new Map<id,string>();
            list<string> SplitedNames = new list<String>();
            AllinsFiles = [select id,Name,InstructionNames__c,File_Type__c,Production_Order__c from Files__c where Production_Order__c IN:Orderids And File_Type__c='image' and InstructionNames__c!=null ];
            
            string insFiles= null;
            for(String FT :existedids) {
                if(insFiles==null) {
                    insFiles=FT;
                }else {
                    insFiles=insFiles+','+FT;
                }            
            }   
            system.debug('Current Time 92 : ' + system.now());
            for(Files__c F :AllinsFiles) {
                if(F.InstructionNames__c==insFiles) {
                    InsFileList.add(F);         
                } else {
                    SplitedNames = (string.ValueOf(F.InstructionNames__c)).Split(',');             
                    for(String T :existedids) {
                        if(SplitedNames.size()==1) {
                            if(T==SplitedNames[0]) {
                                singleins.add(F);
                            }               
                        } else {
                            if((string.ValueOf(F.InstructionNames__c)).Contains(T)) {
                                InstructionExisted.add(F);
                                InsConatins.put(F.id,T);
                            }               
                        }              
                    }             
                }
                
                SplitedNames.clear();
            }   
            system.debug('Current Time 93 : ' + system.now());
            list<String> SplittedValues = new list<String>();
            map<id,String> FinalMap = new Map<id,String>();
            list<files__c> Updateinstructions = new list<files__c>();
            string Names = null;
            for(Files__C HO :InstructionExisted) {
                SplittedValues = (HO.InstructionNames__c).split(',');
                for(integer i =0;i<SplittedValues.size();i++){
                    if((InsConatins.get(HO.id))!=SplittedValues[i]) {
                        if(Names==null) {
                            Names=SplittedValues[i];        
                        } else {
                            Names = Names +','+SplittedValues[i];
                        }
                    }           
                    
                }
                FinalMap.put(HO.id,Names);
                Names = null;
                SplittedValues.clear();
            }  
            system.debug('Current Time 94 : ' + system.now());
            for(Files__C UP :InstructionExisted) {
                Files__c FI = new Files__c();
                FI.id = UP.id;
                FI.InstructionNames__c = FinalMap.get(UP.id);
                Updateinstructions.add(FI);
            }   
            
            try{
                if(InsFileList.size()>0) {
                    for(Files__c GY:InsFileList) {
                        Files__c IU = new Files__c();
                        IU.id = GY.id;              
                        IU.InstructionNames__c = null;
                        UpdateINSFiles.add(IU);
                    }
                    
                }
                if(singleins.size()>0) {
                    for(Files__c YRF:singleins) {
                        Files__c UT = new Files__c();
                        UT.id = YRF.id;             
                        UT.InstructionNames__c = null;
                        UpdateINSSingleFiles.add(UT);
                    } 
                }
                
                if(UpdateINSFiles.size()>0) {
                    update UpdateINSFiles;
                }
                if(UpdateINSSingleFiles.size()>0) {
                    update UpdateINSSingleFiles;
                }
                
                if(Updateinstructions.size()>0) {
                    update Updateinstructions;
                }
            }catch(Exception e){
                System.debug('EXCEPTION ::::'+E);
            }          
        }   
    }
    
    public void  deleteFiles() {
        
        List<Files__c> FileList = new List<Files__c> ();
        String files=Apexpages.currentPage().getParameters().get('deleteFilesID');
        List<Files__c> UpFileList = new List<Files__c> ();
        FileList  = repostDeleteFiles(files);
        system.debug('Current Time 95 : ' + system.now());
        if(FileList.size() > 0 ) {            
            UpFileList  =  service.getFilesRecordsInfo(FileList);
            // Delete the Files 
            try {
                if(UpFileList.size() > 0) {
                    delete UpFileList;
                }
            }catch(DMLException me) {
                system.debug('STATUS INSIDE THE CATCH ::; deleteFiles Method :' + me.getMessage());
            }           
        }
    }
    
    public String openDirectory(){
        String files=Apexpages.currentPage().getParameters().get('openFiles');
        String[] FileIds = files.split(',');
        List<id> FileIDsList=new List<id>();
        system.debug('Current Time 96 : ' + system.now());
        for(string membersSplited:FileIds){
            if(membersSplited!=null){
                FileIDsList.add(membersSplited);
            }
        }
        
        List<Files__c> FileList = new List<Files__c> ();
        List<Files__c> UpFileList = new List<Files__c> ();
        if(FileIds!= null){
            FileList  =  service.getOpenFilesRecordsInfo(FileIDsList);
        }
        
        if(!FileList .isEmpty() && FileList != null){
            for(Files__c FileObj : FileList){
                String userId = userinfo.getuserid();
                List<member__c> memDetails = new list<Member__c>();
                memDetails = service.getMemberDesignation(userId);
                for(Member__c memData :memDetails){
                    if(memData.Designation__c=='Quality Control')
                    {
                        FileObj.Status__c='QCIP';
                    }
                }               
                FileObj.Files_To_open__c = 1;   
                UpFileList.add(FileObj);                
            }
            system.debug('Current Time 97 : ' + system.now());
            // Update the Files with open status for selected directory
            try {
                if(UpFileList.size() > 0){
                    update UpFileList;
                }
            }catch(DMLException me) {
                system.debug('STATUS INSIDE THE CATCH ::; deleteFiles Method :' + me.getMessage());
            }         
        }
        return null;
    }
    public void closeChangeQCPopup(){
        displayChangeQCPopUp = false;
    }
    
    public void UpdateInstructionNamesinFile(list<string> existedids, list<String> Orderids)
    {  
        if(existedids.size()>0&&existedids!=null){
            
            List<Files__c> AllinsFiles = new list<Files__c>();
            List<Files__c> InsFileList = new list<Files__c>();
            List<Files__c> singleins = new list<Files__c>();
            List<Files__c> InstructionExisted = new list<Files__c>();
            List<Files__c> UpdateINSFiles = new list<Files__c>();
            List<Files__c> UpdateINSSingleFiles = new list<Files__c>();
            Map<id,string> InsConatins = new Map<id,string>();
            list<string> SplitedNames = new list<String>();
            AllinsFiles = [select id,Name,InstructionNames__c,File_Type__c,Production_Order__c from Files__c where Production_Order__c IN:Orderids And File_Type__c='image' and InstructionNames__c!=null ];
            system.debug('Current Time 98 : ' + system.now());
            string insFiles= null;
            for(String FT :existedids) {
                if(insFiles==null) {
                    insFiles=FT;
                }else {
                    insFiles=insFiles+','+FT;
                }            
            }   
            
            for(Files__c F :AllinsFiles) {
                if(F.InstructionNames__c==insFiles) {
                    InsFileList.add(F);         
                }else{  
                    SplitedNames = (string.ValueOf(F.InstructionNames__c)).Split(',');             
                    for(String T :existedids) {
                        if(SplitedNames.size()==1) {
                            if(T==SplitedNames[0]) {
                                singleins.add(F);
                            }               
                        }else{
                            if((string.ValueOf(F.InstructionNames__c)).Contains(T)) {
                                InstructionExisted.add(F);
                                InsConatins.put(F.id,T);
                            }               
                        }              
                    }             
                }
                system.debug('Current Time 99 : ' + system.now());
                SplitedNames.clear();
            }   
            
            list<String> SplittedValues = new list<String>();
            map<id,String> FinalMap = new Map<id,String>();
            list<files__c> Updateinstructions = new list<files__c>();
            string Names = null;
            for(Files__C HO :InstructionExisted) {
                SplittedValues = (HO.InstructionNames__c).split(',');
                for(integer i =0;i<SplittedValues.size();i++) {
                    if((InsConatins.get(HO.id))!=SplittedValues[i]) {
                        if(Names==null) {
                            Names=SplittedValues[i];        
                        } else {
                            Names = Names +','+SplittedValues[i];
                        }
                    }           
                    
                }
                FinalMap.put(HO.id,Names);
                Names = null;
                SplittedValues.clear();
            }
            for(Files__C UP :InstructionExisted) {
                Files__c FI = new Files__c();
                FI.id = UP.id;
                FI.InstructionNames__c = FinalMap.get(UP.id);
                Updateinstructions.add(FI);
            } 
            system.debug('Current Time 100 : ' + system.now());
            try{
                if(InsFileList.size()>0) {
                    for(Files__c GY:InsFileList) {
                        Files__c IU = new Files__c();
                        IU.id = GY.id;              
                        IU.InstructionNames__c = null;
                        UpdateINSFiles.add(IU);
                    }
                }
                if(singleins.size()>0) {
                    for(Files__c YRF:singleins) {
                        Files__c UT = new Files__c();
                        UT.id = YRF.id;             
                        UT.InstructionNames__c = null;
                        UpdateINSSingleFiles.add(UT);
                    }  
                }
                
                if(UpdateINSFiles.size()>0) {
                    update UpdateINSFiles;
                }
                if(UpdateINSSingleFiles.size()>0) {
                    update UpdateINSSingleFiles;
                }
                
                if(Updateinstructions.size()>0) {
                    update Updateinstructions;
                }
            }catch(Exception E)
            {
                System.debug('EXCEPTION ::::'+E);
            }             
        }   
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
        public Member__c   memWrap{public get; public set;}
        public Boolean isSelected{get; set;}
        public String Thumbnailurl{get;set;}
        public String jobTitles{get;set;}
        public String fileInstruction{get;set;}
        
        public FileWrapper() {
            fileWrap = new Files__c();
            proOrderWrap = new Production_Order__c();
            catWrap = new File_Categories__c ();
            memWrap = new Member__c();
            isSelected = false;
            fileInstruction = '';
            Thumbnailurl='';
        }
    }
    
    global class WrapperFiles implements Comparable {
        
        public String ClassificationName{get;set;}
        public integer TotalFilesCount{get;set;}
        public integer TotalOJobsFiles{get;set;}
        public integer CompletedFilesCount{get;set;}
        
        public WrapperFiles(String Classification,integer TotalFiles,integer TotalOJobFiles, integer CompletedFiles ) {
            this.ClassificationName =  Classification;
            this.TotalFilesCount = TotalFiles;
            this.TotalOJobsFiles = TotalOJobFiles;
            this.CompletedFilesCount =  CompletedFiles ;             
        }
        
        public WrapperFiles(){}
        
        global Integer compareTo(Object ObjToCompare) {
            return ClassificationName.CompareTo(((WrapperFiles)ObjToCompare).ClassificationName);
        }       
    }
    
    public with sharing class FilejasonWrapper {
        public list<Bean> Filedetails;
        
        
        public FilejasonWrapper(){
            
        }
    }
    //Bean class for FilejasonWrapper
    public with sharing class Bean{
        
        public  String  FileIDId = '';
        public  String  FileStatus = '';
        public  string  FileName='';
        public  string  File_AutoNumber = '';
        public  string  parentId ='';
        public  string  fileType='';
        public  string  orderNumber='';
        public  string  splittedParentId='';
        
        
        Bean(SObject sob){
            this.FileIDId               =    (string) sob.get('id');// sending Name as string
            this.FileStatus             =    (string) sob.get('Status__c');
            this.FileName               =    (string) sob.get('Name');
            this.File_AutoNumber        =    (string) sob.get('Name'); // sending Production order as String
            this.parentId               =    (string) sob.get('Parent_Id__c');
            this.fileType               =    (string) sob.get('File_Type__c');
            this.orderNumber            =    (string) sob.get('Production_Order__c');
            this.splittedParentId            =    (string) sob.get('Splitted_Parent_id__c');
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
         system.debug('Current Time 101 : ' + system.now());
        OffsetSize += QueryLimit;
        currentPage += 1;
        newFileForPageCount+=1;
        getdisplayOrderFiles2();
        return null;
    }
    
    public PageReference Previous() {
         system.debug('Current Time 102 : ' + system.now());
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
         system.debug('Current Time 103 : ' + system.now());
        OffsetSize=0;
        getdisplayOrderFiles2();
        service.refresh();
        newFileForPageCount = 1;
        return null;
    }
    
    
    public pageReference DisplayGrid(){
         system.debug('Current Time 104 : ' + system.now());
        showGrid = true;
        showList = false;
        return null;
    }
    
    public pageReference closepage(){
         system.debug('Current Time 105 : ' + system.now());
        
        return new PageReference('javascript:window.close()');
    }
    
    public void refreshOrderFilesPage(){
         system.debug('Current Time 106 : ' + system.now());
        sortTitle='None';
        sortChoice='None';
        sortCatg='None';
        
        system.debug('----------sortings-------'+sortTitle+sortCatg+sortChoice);
        
    }
    
    public pageReference DisplayList(){
        showGrid = false;
        showList = true;
        
         system.debug('Current Time 107 : ' + system.now());
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
}