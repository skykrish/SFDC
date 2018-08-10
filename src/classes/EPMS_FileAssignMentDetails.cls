/**********************************************************************************
*   Class               :       EPMS_FileAssignMentDetails                        * 
*   Created Date        :       13/04/2016                                        *           
*   Description         :       This Web service is used to send files from 
                                Salesforce to Tracker when Artist Clicks getFiles *
**********************************************************************************/
 
@RestResource(urlMapping='/File_Assignments/*')
global without sharing class EPMS_FileAssignMentDetails {
    
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
          result = serv.getFile(userId);
         if(result != null && result.size() > 0) {
            for(Files__c f: result){
            
             /*Add files to a new bean class  which is wrapped  to send responce*/
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
    
     //wrapping Bean 
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
        public  Boolean  trackerCrash ;
        public  string  FileThumbURL='';
        public  string  filePreviewURL='';
        public  string  FileURL='';
        public  string  FileTAT='';
        //public  Boolean Rename;
        public  string  JobTitle='';
        public  string  FileInstructions='';
        public String orderInstructions = '';
        public  string  fileJobIDs='';
        public  string  FileHandOverTo='';
        public  string  FileHandOverInstructions='';
        public  string  FileQCComments='';
        public  Decimal  fileCopyNumber=0;
        public  string  originalFile='';
        public  string  fileRedo='';
        public  string  operatorid='';
        public  string  operatorName='';
        public  string  operatorCode='';
        public  string  tlinchargeid='';
        public  string  tlName='';
        public  string  tlCode='';
        public  string  shiftId='';
        public  string  shiftCode='';
        public  string  teamId='';
        public  string  teamName='';
        public  string  teamOperatorCount='';
        public  string  qcinchargeid='';
        public  string  currentFileExtension='';
        public  string  psVersion='';
        public  string  rowWeight='';
        public  string  viewMode='';
        public string  workStartTime='';
        public string  workEndTime='';
        public Decimal  totalWorkTime=0;
        public Decimal  totalbreakTime=0;
        public Decimal Filestoopen=0;
        public string deliveryextension ='';
        //EPMSSF-521 Changes - Included Order_Instructions__c and Image_Definition__c
        public string filejobtitle ='';
        public string imageDefinition = '';
      
        //Intilating the Object Values      
        Bean(SObject sob){
        this.fileid                     =    (string) sob.get('File_Auto_Number__c');// sending Name as string
        this.OrderId                =    (string) sob.get('Production_Order_Name__c'); // sending Production order as String
        this.parentId               =    (string) sob.get('Parent_Id__c');
        this.NoOfFile                  =    (Decimal) sob.get('No_of_the_file__c'); // sending NoOfFile as Decimal Number
        this.orderNumber            =    (string) sob.get('Production_Order_Name__c');
        this.locationName           =    (string) sob.get('File_Location__c');
        this.FileCategoryId         =    (Decimal) sob.get('File_category_id__c');
        this.FileCategoryCode       =    (id) sob.get('File_Category_Code__c');
        this.fileType               =    (string) sob.get('File_Type__c');
        this.FileStatus             =    (string) sob.get('Status__c');
        this.fileOldStatus          =    (string) sob.get('File_old_Status__c');
        this.FileProcessingStatus   =    (string) sob.get('File_Proccessing_Status__c');
        this.FileName               =    (string) sob.get('Name');
        this.trackerCrash           =    (Boolean) sob.get('Tracker_Crashed__c');
        this.FileThumbURL           =    (string) sob.get('File_Thumbnail_URL__c');
        this.filePreviewURL         =    (string) sob.get('File_Preview_URL__c');
        this.FileURL                =    (string) sob.get('File_URL__c');
        //this.Rename                 =    (Boolean)sob.get('Rename__c');
        this.FileInstructions       =    (string) sob.get('instruction__c');
        this.workStartTime          =    (string) string.valueof(sob.get('Work_Start_Time__c'));
        this.workEndTime            =    (string) string.valueof(sob.get('Work_End_Time__c'));
        this.totalWorkTime          =    (Decimal) sob.get('Total_Work_Time__c');
        this.totalbreakTime         =    (Decimal) sob.get('Total_Break_Time__c');
        this.FileHandOverInstructions=    (string) sob.get('File_HandOver_Instructions__c');
        this.FileQCComments         =    (string) sob.get('QC_Comments__c');
        this.fileCopyNumber         =    (Decimal) sob.get('File_Copy_number__c');
        this.originalFile           =    (string) sob.get('Original_File_Id__c');
        this.fileRedo               =    (string) sob.get('Is_File_Redo__c');
        this.operatorid             =    (string) sob.get('Member__c');     
        this.qcinchargeid            =    (string) sob.get('QCIncharge__c');
        this.currentFileExtension   =    (string) sob.get('Current_Extension__c');
        this.psVersion              =    (string) sob.get('File_PS_Version__c');
        this.Filestoopen        =       (Decimal) sob.get('Files_To_open__c'); 
        this.deliveryextension =     (string) sob.get('Delivery_Extension__c');
        this.tlinchargeid          = (string)sob.get('TLInCharge__c');
         this.filejobtitle           = (string)sob.get('File_Job_Titles__c');
         //EPMSSF-521 Changes - Included Order_Instructions__c and Image_Definition__c
         this.orderInstructions  = (string)sob.get('Order_Instructions__c');
         this.imageDefinition = (string)sob.get('Image_Definition__c');
      
        }                                                                            
   }
}