/**********************************************************************************
*   Class               :       EPMS_MyDirectory                                  *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Controller to display PO files for QC/TL       *
**********************************************************************************/

public without sharing class EPMS_MyDirectory{

    public String FileCalJSON  { get; set; }
    public Boolean displayChangeTLPopUp { get; set; }
    public Boolean displayChangeQCPopUp { get; set; }
    public Map<Id, Id> memberTL_QC_Map {get; set;}
    public List<id> FileIDsList         {get;set;}
    public Set<id> FileIDSet            {get;set;}
    public String extentionTxt          {get;set;} 
    public string extvalue               {get;set;}
    public boolean submitButton {get;set;}
    public boolean submitButtonCat {get;set;}
    public boolean statusC  {get;set;}
    
    public boolean errorTypeFlag {get;set;}
    public boolean isMemberExist{get;set;}
    public String VDFolInstrucEntered { get; set; }
    public String FileListInsruction { get; set; }
    public Boolean displayJobPopUp { get; set; }
    public Boolean displayPopup {get;set;}
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
    Set<Id> resultsId = new Set<Id>();
    List<Files__c> saveIntroList;
    List<Files__c> tobeSavedIntroList;
    public Boolean displayVDFolPopup {get;set;}
    public List<Files__c> instFilesList {get;set;}
    public Files__c changeFileExt       {get;set;}    
    public Set<id> FileIDSetForInst     {get;set;}
    public Set<id> changeFileIDSet      {get;set;}  
    public List<Files__c> poFilesList{public get; public set;}
    public String[] EPMSjob_list = new string[]{}; 
    Production_Order__c poObj = new Production_Order__c();
    List<Files__c> fileList = new List<Files__c>();
    public String completeMsg           {get;set;}
    List<Files__c> selList;
    public String[] VDEPMSJobList = new string[]{}; 

    public List<Files__c> filePopList;
    public List<Files__c> fileStatusList; 
    // Used in UpdateObject
    String[] stringArray = new String[]{};
  
    List<Files__c> updateFilesList;
    List<File_Categories__c> categoryList = new List<File_Categories__c>();
    List<Id> Ids;
    public List<File_Categories__c> catList;
    public Map<Id, File_Categories__c> IdCategory;
    public List<File_Categories__c> catListNew;
    public Map<Id, File_Categories__c> IdCategoryNew;
    public List<Id> completedFileIds; 
   
    public Boolean rend { get; set; }

    public SelectOption[] shiftNames{get;set;}
    
    public List<Shift_Assignments__c> teamIdList= null;
    public List<Shift__c> shiftList = new List<Shift__c>();
    public List<Team__c> teamNameList = new List<Team__c>();
    public List<Shift_Assignments__c> qcList = new List<Shift_Assignments__c>();
    Set<Id> teamIds = new Set<Id>();
    Set<Id> MemteamIds = new Set<Id>();
    Public list<member__c> memlist = new  list<member__c>();
    List<Files__c> fileTLPopFilesList;
    Public List<Files__c> filesComponent{public get; public set;} 
    
    EPMS_ViewDirectoryService serviceObj = new EPMS_ViewDirectoryService();
    
    // Call the service : Production Order - View Directory
    
    EPMS_POViewDirectory_Service service = new EPMS_POViewDirectory_Service();
    EPMS_MyDirectory_Service Dirservice = new EPMS_MyDirectory_Service();
    public boolean displayChangeExt     {get;set;}

    private Integer OffsetSize = 0;
    private Integer QueryLimit = 20;
    private Integer OffsetSizeNew = 0;
    private Integer QueryLimitNew = 20;
    private Integer CountTotalRecords = 0;
     private Integer CountTotalRecordsNew = 0;
     public string proflieName {get;set;}
     public string currentLoginUserID {get;set;}
     
    public EPMS_MyDirectory()     
    {

        User UserId = Dirservice.getLoggedUserInformation();
        Profile profile = Dirservice.getLoggedUserProfileInformation();
        errorFlag = false;
        if(profile != null){
            proflieName= profile.Name;
        }
        
        if(UserId !=null)
        {
            currentLoginUserID = UserId.Id;
        }
        
        statusC = false;
        submitButton = true;
        submitButtonCat = true;
        errorTypeFlag = false;
        isMemberExist= false;
        selList = new List<Files__c>();
        orderID = ApexPages.currentPage().getParameters().get('id');
        Industoryname =new List<String>();
        
        instFilesList = new List<Files__c>();
        
        poObj = service.getProdOrderDetails(orderID);

        parentId = poObj.Name;
        parentIdValue = poObj.id;
        
        
        if(Orderid != null){
            shiftNames= new SelectOption[0];
            shiftList = Dirservice.getAllShiftList();
            shiftNames.add(new SelectOption('Select Shift', 'Select Shift')); 
            for(Shift__c shiftObj : shiftList) {
                shiftNames.add(new SelectOption(shiftObj .Id, shiftObj.Name));
            }
            
            displayChangeTLPopUp = true;
        }
    }
    
     
    public List<Production_Order__c> getproductionOrderDetails(){
            completeMsg = null;
            displayChangeExt    =   false;

            List<Production_Order__c> prodDetails = new  List<Production_Order__c>();
            List<Production_Order__c> ProdOrderDetails = new  List<Production_Order__c>();

            String userId = userinfo.getuserid();
            
            Id profileId = userinfo.getProfileId();
            system.debug('Profle Name : ' + profileId);
            String pname = Dirservice.getUserProfileInfo(profileId).Name;  
            system.debug('Profle Name < --- >: ' + pname);        
            if(pname =='System Administrator' || pname=='システム管理者' || pname =='Country Administrator'){ 
                CountTotalRecords = Dirservice.getProductionOrderCount();
                ProdOrderDetails = Dirservice.getProductionOrderListOrderByName(QueryLimit,OffsetSize);
            } else if(pname == 'Sales Region'){
                ProdOrderDetails = Dirservice.getProductionOrderForSaleRegion(userId,QueryLimit,OffsetSize);
            } else {      
             
                Member__c memberHolder= Dirservice.getActiveMemberInfo(userId);
           
                CountTotalRecords = Dirservice.getProductionOrderCountByQC_Or_TL(memberHolder.Id);

                ProdOrderDetails = Dirservice.getProductionOrderAssigedTO_QC_OR_TL(memberHolder.Id,QueryLimit,OffsetSize);
            }  
     
        return ProdOrderDetails;
    }

    
    public  void setFileListInsruction  (String getFileListInsruction  ) {

        this.FileListInsruction = FileListInsruction;
    }
    

    Set<String> setValForVD = new Set<String>();

    public String getAllDetails() {

        List<Bean> Files = new List<Bean>(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        List<Files__c> filesComponent = new List<Files__c>();

         memberTL_QC_Map = new Map<Id, Id>();
        if(orderID  != null){
            
            filesComponent = Dirservice.getRelatedFileListForProductionOrders(orderID);
            
            Production_Order__c productionOrderInfo = Dirservice.getOrderLocationOfSelectedOrder(orderID);
            
            if(productionOrderInfo != null){
                List<Member__c> memberTL_QC_List = Dirservice.getMemberListExistInLocation(productionOrderInfo.Mbo_Location__c);
                if(memberTL_QC_List != null && memberTL_QC_List.size() > 0){
                    for(Member__c member : memberTL_QC_List){
                        memberTL_QC_Map.put(member.Id,member.User_Id__c);
                    }
                }
                
            }
        }
        
        if(filesComponent.size() > 0){

            for(Files__c f: filesComponent){
                if(memberTL_QC_Map.size() > 0 && (proflieName == 'Quality Control' || proflieName == 'Team Leader')){
                    if((f.QCIncharge__c != null) || (f.TLInCharge__c != null)){
                        Files.add(new Bean(f,memberTL_QC_Map.get(f.QCIncharge__c),memberTL_QC_Map.get(f.TLInCharge__c)));

                    }
                } else if(proflieName == 'System Administrator' || proflieName =='システム管理者' || proflieName =='Country Administrator'){
                    Files.add(new Bean(f)); 
                }

            }
        }
        
        FileCalJSON = JSON.serialize(Files);
        return FileCalJSON;
    }
    
    
    Public void parentChildNodes(){
        
        completeMsg         =   null;
        displayChangeExt    =   false;
        FileIDSet           =   new Set<Id>();
        FileIDsList         =   new List<Id>();
        changeFileExt       =   new Files__c();
        changeFileIDSet     = new Set<Id>();
        viewDirectory = true;
        
        orderID = ApexPages.currentPage().getParameters().get('prodOrderID');

        poObj = service.getProdOrderDetails(orderID);

        parentId = poObj.Name;
        parentIdValue = poObj.id;
        
         
        orderFiles  = false; 
        orderInformation  = false;
        viewDirectory = true;
        classification = false;
    }

    public PageReference  ExportToExcel(){

        PageReference Exportexcelpage = new Pagereference('/apex/ExportToExcel' + '?id=' + parentIdValue);
        Exportexcelpage.setRedirect(false);
        return Exportexcelpage;

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
    
    List<Files__c> saveIntrodoeFileWithourtDirList;
    List<Files__c> tobeSavedIntroFileWithoutList;

    // View Directory(Menu) - Change Folder Instructions(Button)

    List<Files__c> fileVDPopList;
    List<Files__c> fileVDPopList1;
    List<Files__c> updateFileswithourDirList;
    

    public void showVDFolPopup() {
        
        String files=Apexpages.currentPage().getParameters().get('openInstrFiles');
        FileListInsruction=files;
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
            
            FileList  =  service.getFilesInstructionList(FileIDsList);
            if(FileList.size() > 0){
                if(FileList.size() > 2){
                    VDFolInstrucEntered='';
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
    
    //List<Files__c> saveVDPopList;
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
        tobeUpdatedList = new List<Files__c>();
        saveVDFileWithourDirPopList= new List<Files__c>();
        tobeUpdatedListForDirFiles = new List<Files__c>();
        ToBeUpdatedVDFileWithourDirPopList= new List<Files__c>();
        saveVDDirFilesPopList = new List<Files__C>();
        
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
                            fileObj.Instruction__c  = VDFolInstrucEntered ;  
                            UpdateFileInsreuctionSet.add(fileObj);     
                        }
                        //UpdateFileInsreuction.add(fileObj);
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
                            //UpdateFileInsreuction.add(fileObj);
                            
                        }
                    }
                    UpdateFileInsreuction.addAll(UpdateFileInsreuctionSet);
                    // Update the Files related to Instruction type
                    try {
                        if(UpdateFileInsreuction.size() > 0){
                            update UpdateFileInsreuction;
                        }
                    }catch(DMLException me) {

                    } 
                }   
            }
        }

        displayVDFolPopup  = false;
        rend = true;
        return null;
    }


    //View Directory(Menu) - Change Folder Instructions(Button) - Cancel(button in popup)
    public void cancelVDFolPop(){
        displayVDFolPopup = false;
    }

      
    public void closeChangeTLPopup(){
        
        displayChangeTLPopUp = false;
    }

    public List<Shift_Assignments__c> teamIdListForQC= null;
    public List<Shift__c> shiftListForQC = new List<Shift__c>();
    public List<Team__c> teamNameListForQC= new List<Team__c>();

    public list<member__c> memlistForQC = new  list<member__c>();
    Set<Id> teamIdsForQC = new Set<Id>();
    Set<Id> MemteamIdsForQC = new Set<Id>();
    //public String selQcForQC{get;set;}  
    
    public String openDirectory(){
        String files=Apexpages.currentPage().getParameters().get('openFiles');
        String[] FileIds = files.split(',');
        List<id> FileIDsList=new List<id>();
         for(string membersSplited:FileIds){
              if(membersSplited!=null){
                  FileIDsList.add(membersSplited);
              }
           }
        errorFlag = false;
        List<Files__c> FileList = new List<Files__c> ();
        List<Files__c> UpFileList = new List<Files__c> ();
        
        if(FileIds!= null){
            FileList  =  service.getOpenFilesRecordsInfo(FileIDsList);
        }
        
        if(!FileList.isEmpty() && FileList != null){
            for(Files__c FileObj : FileList){
            
                if(FileObj.Status__c=='Assigned' || FileObj.Status__c =='QC' ||FileObj.Status__c =='Redo Re-Assigned'){
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
                    FileObj.File_PS_Version__c = 'CS6'; 
                    UpFileList.add(FileObj);                
                } else {
                    errorFlag = true;
                    break;
                }
            }
            
            // Update the Files with open status for selected directory
            try {
                if(UpFileList.size() > 0){
                    update UpFileList;
                }
            } catch(DMLException me) {

            }         
        }
        return null;
    }
    
    public void closeChangeQCPopup(){
        displayChangeQCPopUp = false;

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
        public  string  currentTLUserID='';
        public  string  currentQCUserID='';
        public  string  splittedParentId='';

        
        //Bean(SObject sob, String currentLoginUserID){
          Bean(SObject sob){
            this.FileIDId               =    (string) sob.get('id');// sending Name as string
            this.FileStatus             =    (string) sob.get('Status__c');
            this.FileName               =    (string) sob.get('Name');
            this.File_AutoNumber        =    (string) sob.get('Name'); // sending Production order as String
            this.parentId               =    (string) sob.get('Parent_Id__c');
            this.fileType               =    (string) sob.get('File_Type__c');
            this.orderNumber            =    (string) sob.get('Production_Order__c');
            this.currentQCUserID            =  (string) sob.get('QCIncharge__c');
            this.currentTLUserID            =  (string) sob.get('TLIncharge__c');
            this.splittedParentId       =    (string) sob.get('Splitted_Parent_id__c');

        }  
        
        
        Bean(SObject sob, Id qcUserId, Id tlUserId){
            this.FileIDId               =    (string) sob.get('id');// sending Name as string
            this.FileStatus             =    (string) sob.get('Status__c');
            this.FileName               =    (string) sob.get('Name');
            this.File_AutoNumber        =    (string) sob.get('Name'); // sending Production order as String
            this.parentId               =    (string) sob.get('Parent_Id__c');
            this.fileType               =    (string) sob.get('File_Type__c');
            this.orderNumber            =    (string) sob.get('Production_Order__c');
            this.splittedParentId       =    (string) sob.get('Splitted_Parent_id__c');
            
            if(qcUserId != null && tlUserId == null){
                this.currentQCUserID            =  (string) qcUserId;
                this.currentTLUserID            =  (string) sob.get('TLIncharge__c');
            } else if(qcUserId == null && tlUserId != null){
                this.currentQCUserID            =  (string) sob.get('QCIncharge__c');
                this.currentTLUserID            =  (string) tlUserId;
            } else if(qcUserId != null && tlUserId != null){
                this.currentQCUserID            =  (string) qcUserId;
                this.currentTLUserID            =  (string) tlUserId;
            } else {
                this.currentQCUserID            =  (string) sob.get('QCIncharge__c');
                this.currentTLUserID            =  (string) sob.get('TLIncharge__c');
            }

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
        OffsetSize += QueryLimit;
        return null;
    }
 
    public PageReference Previous() {
        OffsetSize -= QueryLimit;
        return null;
    }
    
     
    public void changeExtention(){
    
        displayChangeExt = true;
        completeMsg = null;
        String files=Apexpages.currentPage().getParameters().get('fileExt');
        
        if(files!=null){
            String[] FileIds = files.split(',');
            for(string membersSplited:FileIds){
                if(membersSplited!=null){
                    FileIDsList.add(membersSplited);
                }
            }
            FileIDSet.addAll(FileIDsList);
            if(FileIDsList.size()<=1){
                List<files__c> fl = Dirservice.getFileDetailInformation(FileIDsList);
                extentionTxt = fl[0].Current_Extension__c;
            } else {
               extentionTxt = null;
            }   
            
        }else{

        }
    }
    public List<SelectOption> getAllFileExtension(){     
         List <SelectOption> options  = new List<SelectOption>();
           options.add(new SelectOption('','--Select Extension --'));
            options.add(new SelectOption('psd','psd'));
             options.add(new SelectOption('eps','eps'));
              options.add(new SelectOption('tif','tif'));
               options.add(new SelectOption('tiff','tiff'));
                options.add(new SelectOption('jpg','jpg'));
                 options.add(new SelectOption('jpeg','jpeg'));
                  options.add(new SelectOption('gif','gif'));
                   options.add(new SelectOption('bmp','bmp'));
                 
        return options;
     }
            
            
    public void saveChangeExtention(){ 
        extvalue = extentionTxt;
        completeMsg =null;
        List<Files__c> FileList = new List<Files__c> ();
        List<Files__c> UpFileList = new List<Files__c> ();
        
        if(FileIDSet!= null){            
           FileList  = Dirservice.getFileExtensionInformation(FileIDSet);
        }

        if(String.isNotBlank(extentionTxt)){
        
            if(FileList != null && FileList.size()>0){
                for(Files__c FileObj : FileList){           
                    if(FileObj.File_Type__c == 'Image'){
                        FileObj.Delivery_Extension__c= extentionTxt;
                        UpFileList.add(FileObj);                        
                    }
                }
            }
            if(UpFileList.size()>0){
                try{
                    update UpFileList;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_MY_DIR_FILE_EXTN_UPDATED));
                    displayChangeExt = false;
                } catch(Exception e){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_MY_DIR_FILE_UPDATION_FAILED));
                }
            }   
        } else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_MY_DIR_PLEASE_SELECT_EXTN));
        }
    }
    
    // Method to retrieve the received directory (its order) handover to logged users
    public List<Production_Order__c> getAssignedFileListWithoutProductionOrders(){

            List<Production_Order__c> ProdOrderDetailsNew = new  List<Production_Order__c>();
            String userId = userinfo.getuserid();
            Id profileId = userinfo.getProfileId();
            String pname = Dirservice.getUserProfileInfo(profileId).Name;  
        
            if(pname =='System Administrator' || pname=='システム管理者' || pname =='Country Administrator'){ 
                CountTotalRecordsNew = Dirservice.getProductionOrderCount();
           
            } else if(pname == 'Sales Region'){

            } else {   
            
                Member__c memberHolder= Dirservice.getActiveMemberInfo(userId);

                CountTotalRecordsNew = Dirservice.getOrderCountFromFilesList(memberHolder.Id);

                ProdOrderDetailsNew = Dirservice.getAssignedFileListWithoutProductionOrders(QueryLimitNew,OffsetSizeNew);            
                if(ProdOrderDetailsNew == null){
                    ProdOrderDetailsNew = new  List<Production_Order__c>();
                }
            }
        return ProdOrderDetailsNew;
    }
    
    // Method to retrieve the order information
     public void parentChildNodesNew(){
        
        completeMsg         =   null;
        displayChangeExt    =   false;
        FileIDSet           =   new Set<Id>();
        FileIDsList         =   new List<Id>();
        changeFileExt       =   new Files__c();
        changeFileIDSet     = new Set<Id>();
        viewDirectory = true;

        orderID = ApexPages.currentPage().getParameters().get('prodOrderID');
        poObj = service.getProdOrderDetails(orderID);
        parentId = poObj.Name;
        parentIdValue = poObj.id;
         
        orderFiles  = false; 
        orderInformation  = false;
        viewDirectory = true;
        classification = false;
        
    }


    // Method to retrieve the received order and its files are handover to logged users
    public String getAllDetailsNew() {

        List<Bean> Files = new List<Bean>(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<Files__c> filesComponent = new List<Files__c>();
        //FilejasonWrapper responsejsonFiles = new FilejasonWrapper();
        if(orderID  != null){
            filesComponent = Dirservice.getAssignedFileListWithProductionOrdersFor_QC_Or_TL(orderID);
        }
        

        if(filesComponent.size() > 0){
            for(Files__c f: filesComponent){
                Files.add(new Bean(f)); 
            }
        }

        FileCalJSON = JSON.serialize(Files);
        return FileCalJSON;
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
    
    
}