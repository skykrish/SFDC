/**********************************************************************************
*   Class               :       EPMS_FileAssignmentQCDetails                      *
*   Date                :       13/04/2016                                        *           
*   Description         :       This Web service is invoke to send files from 
                                Salesforce to Tracker when Artist Clicks getFiles *
**********************************************************************************/


@RestResource(urlMapping='/File_AssignmentsQC/*')
global without sharing class EPMS_FileAssignmentQCDetails {
    
    @HttpGet
    global static  void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        CategoryWrapper response = new CategoryWrapper();
        List<Files__c> result = new List<Files__c>();
        List<Member__c> member = new List<Member__c>();
        List<Bean> Files = new List<Bean>();      
        List<Production_Order__c> prodOrder = new List<Production_Order__c>();
        List<Files__c> fles = new List<Files__c>();
        WS_FileDetailService serv = new WS_FileDetailService(); 
       
        string userId = String.valueOf(userinfo.getuserid());     
        result = serv.getQCFile(userId);
        
        if(result != null && result.size() > 0) {
            for(Files__c f: result){
                Files.add(new Bean(f)); 
                response.Filedetails = Files;   
            }
        }
        else {      
            res.StatusCode = 404;// sending response as 404 if it Fails to Communicate with Tracker         
        }         
        
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serializePretty(response));        
    }
    
    
    global class CategoryWrapper {
        public list<Bean> Filedetails;       
        
        public CategoryWrapper(){
           
        }
    }
    
    //Bean class for CategoryWrapper
    global class Bean{
        public  string  fileid = '';
        public  string  OrderId = '';
        public  string  parentId ='';
        public  Decimal  NoOfFile=0;
        public  string  orderNumber='';
        public  string  locationName='';
        public  Decimal  FileCategoryId=0;
        public  string FileCategoryCode='';
        public  Decimal  clientFileCategoryCode=0;
        public  string  fileType='';
        public  string  FileStatus='';
        public  string  fileOldStatus='';
        public  string  FileProcessingStatus='';
        public  string  FileName='';
        public  string  FileThumbURL='';
        public  string  filePreviewURL='';
        public  string  FileURL='';
        public  string  FileTAT='';
        public  string  JobTitle='';
        public  string  FileInstructions='';
        public  string  fileJobIDs='';
        public  string  FileHandOverTo='';
        public  string  FileHandOverInstructions='';
        public  string  FileQCComments='';
        public  Decimal  fileCopyNumber=0;
        public  string  originalFile='';
        public  string  fileRedo='';
        public  string  operatorId='';
        public  string  operatorName='';
        public  string  operatorCode='';
        public  string  tlinchargeid='';
        public  string  tlName='';
        //public  Boolean Rename;
        public  string  tlCode='';
        public  string  shiftId='';
        public  string  shiftCode='';
        public  string  teamId='';
        public  string  teamName='';
        public  string  teamOperatorCount='';
        public  string  qcinchargeid='';
        public  string  qcName='';
        public  string  qcCode='';
        public  string  currentFileExtension='';
        public  string  psVersion='';
        public  string  rowWeight='';
        public  string  viewMode='';
        public string  workStartTime='';
        public string  workEndTime='';
        public Decimal  totalWorkTime=0;
        public Decimal  totalbreakTime=0;
        public string deliveryextension ='';
        public string filejobtitle='';
      
          //Intilating the Object Values      
        Bean(SObject sob){           
        this.fileid                     =    (string) sob.get('File_Auto_Number__c');// sending Name as string
        this.OrderId                =    (string) sob.get('Production_Order_Name__c'); // sending Production order as String
        this.parentId               =    (string) sob.get('Parent_Id__c');
        this.NoOfFile               =    (Decimal) sob.get('No_of_the_file__c'); // sending No of file as Decimal Number
        this.orderNumber            =    (string) sob.get('Production_Order_Name__c');
        this.locationName           =    (string) sob.get('File_Location__c');
        this.FileCategoryId         =    (Decimal) sob.get('File_category_id__c');
        this.FileCategoryCode       =    (id) sob.get('File_Category_Code__c');
        this.fileType               =    (string) sob.get('File_Type__c');
        this.FileStatus             =    (string) sob.get('Status__c');
        this.fileOldStatus          =    (string) sob.get('File_old_Status__c');
        this.FileProcessingStatus   =    (string) sob.get('File_Proccessing_Status__c');
        this.FileName               =    (string) sob.get('Name');
        this.FileThumbURL           =    (string) sob.get('File_Thumbnail_URL__c');
        this.filePreviewURL         =    (string) sob.get('File_Preview_URL__c');
        this.FileURL                =    (string) sob.get('File_URL__c');
        //this.Rename                 =    (Boolean)sob.get('Rename__c');
        this.FileInstructions       =    (string) sob.get('Instruction__c');
        this.workStartTime          =    (string) string.valueof(sob.get('Work_Start_Time__c'));
        this.workEndTime            =    (string) string.valueof(sob.get('Work_End_Time__c'));
        this.totalWorkTime          =    (Decimal) sob.get('Total_Work_Time__c');
        this.totalbreakTime         =    (Decimal) sob.get('Total_Break_Time__c');
        this.FileHandOverInstructions=    (string) sob.get('File_HandOver_Instructions__c');
        
        this.FileQCComments         =    getQCComments((string) sob.get('QC_Comments__c'));
        
        this.fileCopyNumber         =    (Decimal) sob.get('File_Copy_number__c');
        this.originalFile           =    (string) sob.get('Original_File_Id__c');
        this.fileRedo               =    (string) sob.get('Is_File_Redo__c');
        this.operatorid             =    (string) sob.get('Member__c');
        this.tlinchargeid           =    (string) sob.get('TLInCharge__c');
        this.qcinchargeid                   =    (string) sob.get('QCIncharge__c');
        this.currentFileExtension   =    (string) sob.get('Current_Extension__c');
        this.psVersion              =    (string) sob.get('File_PS_Version__c');
        this.deliveryextension =     (string) sob.get('Delivery_Extension__c');
         this.filejobtitle           = (string)sob.get('File_Job_Titles__c');
      
        }
        
        public String getQCComments(String qcComm){
            List<String> qcCommentsList = new list<String>();
            String QCCOMMENTS_TEXT = 'Qc Comments:';
            if (qcComm != null) {
                qcCommentsList = qcComm.split(QCCOMMENTS_TEXT);
            } 
            
            if (qcCommentsList != null && qcCommentsList.size() > 1) {
                qcComm = qcCommentsList.get(1);
            }
            system.debug('qcComm ******** : ' + qcComm);
            
            return qcComm;
        }                                                                                    
   }
}