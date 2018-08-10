/**********************************************************************************
*   Class               :       EPMS_PO_Re_Download_Controller                    *
*   Created Date        :       27/06/2016                                        *           
*   Description         :       Controller - re-download files in production order*
*   Modified            :       Included Estimation Request                       *
**********************************************************************************/
public class EPMS_PO_Re_Download_Controller {
    public Production_Order__c poObjDisplay {public get; public set;}
  
    public string datavalues{get;set;}
    public boolean errorflag {get;set;}
    public boolean isWorkProgress {get;set;}
    public string orderID{get;set;}
    public string parentId {get; set;}
    public List<Bean> Files {get;set;}
    public string instructionIds{get;set;}
    EPMS_POViewDirectory_Service service = new EPMS_POViewDirectory_Service();
    public String FileCalJSON  { get; set; }
    List<Files__C> FileInstructionList = new  List<Files__C>();
    List<Files__C> UpdateFileInstructionList = new  List<Files__C>();
    public List<string> reqids = new List<string>();
    public string base {get;set;}
    public string fileRecord {get; set;}
    public string popupUpMessage {get;set;}
    public EPMS_PO_Re_Download_Controller()
    {
        orderID = ApexPages.currentPage().getParameters().get('ids');
        base = ApexPages.currentPage().getParameters().get('type');
        fileRecord = orderID;
        system.debug('-- SELECTED ORDER ID ---' + orderID);
        poObjDisplay = new Production_Order__c();
        poObjDisplay  = [SELECT Id,Name,Jobs_List__c, Production_Order_TAT__c,Job_List__c,QC_Incharge__c,TL_Incharge__c,QC_Incharge__r.Name,
                                 Production_Order_Status__c,Total_File_Count__c,TL_Incharge__r.Name,Production_Order_Instruction__c  FROM Production_Order__c where Id = : orderID];
               datavalues = string.valueof(poObjDisplay.Production_Order_TAT__c); 
               system.debug('Production Order Name : ' + poObjDisplay);      
         parentId = poObjDisplay.Name;
         errorflag = false;
         if(poObjDisplay != null){
             if(poObjDisplay.Production_Order_Status__c != 'New'){
                 if(poObjDisplay.Production_Order_Status__c != 'Assigned'){
                    if (poObjDisplay.Production_Order_Status__c != Label.EPMS_FileStatus_Estimation_Request) {
                        isWorkProgress = true;
                    }    
                 }
             } else {
                 isWorkProgress = false;
             }
         }
         system.debug('Order Status --> '+ poObjDisplay.Production_Order_Status__c + 'Is In-Progress Files ??? ' + isWorkProgress);
        
         popupUpMessage = 'Production Order Status is ' + poObjDisplay.Production_Order_Status__c;
         duplicateCheck();
    }


public void duplicateCheck(){
    production_order__c selectedOrder = new production_order__c();
    List<production_order__c> dupliOrders = new List<production_order__c>();
    selectedOrder  = [SELECT Id,Name FROM Production_Order__c where Id = : orderID];

    dupliOrders = [SELECT Id,Name FROM Production_Order__c where Name =:selectedOrder.Name];

    if(dupliOrders != null && dupliOrders.size()>1){
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,'opps!! there are  other production orders with the same number, please check and remove.'));
            system.debug('-----------------------got more files---'+dupliOrders);

    }else{
         system.debug('-----------------------got one file---'+dupliOrders);
    }




}
    

    public void CallConfirmationPopupVD(){
        
        if(poObjDisplay != null){
             if(poObjDisplay.Production_Order_Status__c != 'New' || poObjDisplay.Production_Order_Status__c != 'Assigned' || poObjDisplay.Production_Order_Status__c != Label.EPMS_FileStatus_Estimation_Request){
                 isWorkProgress = true;    
             } else {
                 isWorkProgress = false;
             }
         }
         system.debug('Order Status --> '+ poObjDisplay.Production_Order_Status__c + 'Is In-Progress Files ??? ' + isWorkProgress);
        
    }

    public String getAllDetails() {
        List<Bean> Files = new List<Bean>(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String orderID = ApexPages.currentPage().getParameters().get('ids');
        List<Files__c> filesComponent = new List<Files__c>();
        FilejasonWrapper responsejsonFiles = new FilejasonWrapper();
        /*instructionIds = ApexPages.currentPage().getParameters().get('instruction');
        List<Id> newFileIds = new List<Id>();
        if(instructionIds.length()>0){
            instructionIds = instructionIds.substring(0, instructionIds.length()-1);
           
            for(String key:instructionIds.split(',')){
                reqids.add(key);
            } 
           
        }

        if(instructionIds.length()>0){
            FileInstructionList = service.getFilesInstructionList(reqids); 
            if(FileInstructionList.size()>0){
                for(Files__C f:FileInstructionList){
                    f.File_Type__c = 'File Instruction';                     
                    UpdateFileInstructionList.add(f);
                }
            }
        }
        */
        
        if(orderID  != null){
            filesComponent =  [SELECT id, File_Type__c,Name,Parent_Id__c,Splitted_Parent_id__c,Parent_Id__r.instruction__c, Status__c,Production_Order__c FROM Files__c where Production_Order__c = :orderID ];
            //id not in:reqids 
        }


        if(filesComponent.size() > 0){
            for(Files__c f: filesComponent){
                system.debug('-- FILE S DETAILS ---' + f);
                Files.add(new Bean(f)); 
            }
        }
        FileCalJSON = JSON.serialize(Files);
        return FileCalJSON;               
    }
    
    public void deleteSelectedOrderFiles(){
        production_order__c POorder = new production_order__c();
        system.debug('------ORDER FILES DELETION STARTS -----deleteSelectedOrderFiles-------' + orderID);
        if(poObjDisplay != null && (poObjDisplay.Production_Order_Status__c == 'WIP' || poObjDisplay.Production_Order_Status__c == 'New' || poObjDisplay.Production_Order_Status__c == 'Assigned' || poObjDisplay.Production_Order_Status__c == Label.EPMS_FileStatus_Estimation_Request)){
            
            List<Files__c> tobeDeletedFiles = null;
            if(orderID  != null){
                POorder = [select id, Production_Order_Status__c, FTP_Download_Status__c,ReUpload__c from production_order__c where id=:orderID];
                if(POorder!=null){
                    if(POorder.ReUpload__c){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Selected Order is already in Re-downloaded request. Re-Dowloaded in-progress.'));
                        return;
                    } else if (POorder.Production_Order_Status__c == Label.EPMS_FileStatus_Estimation_Request) {
                        POorder.ReUpload__c = true;
                        POorder.FTP_Download_Status__c = false;
                        POorder.Production_Order_Status__c = Label.EPMS_FileStatus_Estimation_Request;
                    } else {
                        POorder.ReUpload__c = true;
                        POorder.FTP_Download_Status__c = false;
                        POorder.Production_Order_Status__c = 'New';
                    }
                }
            
                tobeDeletedFiles =  [SELECT id, File_Type__c,Name,Parent_Id__c,ReUpload__c,Splitted_Parent_id__c,Parent_Id__r.instruction__c, Status__c,Production_Order__c FROM Files__c where Production_Order__c = :orderID ];
                
                //id not in:reqids 
                if(tobeDeletedFiles != null && tobeDeletedFiles.size() > 0){
                    system.debug('To be Deleted Files count : ' + tobeDeletedFiles.size());
                    try{
                        delete tobeDeletedFiles;
                        update POorder;
                        system.debug('To be Deleted Files count : Inside' + tobeDeletedFiles.size());
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Selected Files are deleted for Re-Download Order Files.'));
                    } catch (DmlException de){
                        system.debug('Exception throws during deletion of order files : ' + de.getMessage());
                        return;
                    }
                } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'The Order is being Re-downloaded! Thank you.'));
                    update POorder;
                    return;
                }
            }
            
        } else {
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Orders of status New Or Assigned Or WIP Or Estimation Request'));
              return;
        }
    }
    
    public void deleteSelectedFiles(){
       boolean statusError = false;
        String files=Apexpages.currentPage().getParameters().get('openInstrFiles');
        system.debug('Selected Files to re-uploaded is : ' + files);
        String[] FileIds = files.split(',');
        List<id> FileIDsList=new List<id>();
         for(string membersSplited:FileIds){
              if(membersSplited!=null){
                  FileIDsList.add(membersSplited);
              }
           }
        system.debug('Selected Files to re-uploaded is [FILE IDS] : ' + FileIDsList);
        List<Files__c> FileList = new List<Files__c> ();
        List<Files__c> UpFileList = new List<Files__c> ();
        boolean alreadyReDownloadFile = false;
        if(FileIds!= null){            
            //FileList  =  service.getFilesInstructionList(FileIDsList);
            FileList  =  [SELECT Id, Name,ReUpload__c,Work_End_Time__c,Member__c,Work_Start_Time__c,File_Type__c, Status__c,Total_Work_Time__c,Total_Break_Time__c,No_of_Breaks__c FROM Files__c WHERE Id IN:FileIDsList];
            
            if(FileList.size() > 0){
                for(Files__c file : FileList){
                    if(file.Status__c =='New' || file.Status__c =='Assigned' || file.Status__c =='WIP' || file.Status__c == Label.EPMS_FileStatus_Estimation_Request ){
                        if(file.ReUpload__c){
                            alreadyReDownloadFile = true;
                            break;
                        }
                        
                        if (file.Status__c == Label.EPMS_FileStatus_Estimation_Request) {
                            system.debug('Selected Files are : ' + file);
                            file.ReUpload__c = true;
                            file.Status__c = Label.EPMS_FileStatus_Estimation_Request;
                            file.Work_End_Time__c = null;
                            file.Work_Start_Time__c = null;
                            file.Total_Work_Time__c = 0;
                            file.Total_Break_Time__c = 0;
                            file.No_of_Breaks__c = 0;   
                            file.Member__c = null;
                            errorflag = false;
                            system.debug('------statusError1---PASS--errorflag -----'+errorflag );                        
                        } else {
                            system.debug('Selected Files are : ' + file);
                            file.ReUpload__c = true;
                            file.Status__c = 'New';
                            file.Work_End_Time__c = null;
                            file.Work_Start_Time__c = null;
                            file.Total_Work_Time__c = 0;
                            file.Total_Break_Time__c = 0;
                            file.No_of_Breaks__c = 0;   
                            file.Member__c = null;
                            file.TLInCharge__c = null;
                            errorflag = false;
                            system.debug('------statusError2---PASS--errorflag -----'+errorflag );
                        }
                        UpFileList.add(file);  
                        
                    }else{
                        statusError = true;
                        errorflag = true;
                        system.debug('------statusError-----------'+statusError);
                        system.debug('------statusError---ERR--errorflag -----'+errorflag );
                        break;
                    
                    }
                                     
                }      
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ' No Files are available in Selected Order. '));
                return;
            }
            if(alreadyReDownloadFile){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected File(s) are already marked as re-downloaded file.'));
                return;
            }
            if(statusError){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Files of status New Or Assigned Or WIP Or Estimation Request'));
                return;
            }
             try{
                 update UpFileList;
                 if(UpdateFileInstructionList.size()>0){
                    update UpdateFileInstructionList;
                 }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Selected Files are marked as Re-Download File.'));
            }catch(exception e){
                system.debug('-----------exception--------'+e);
            }
            
        } else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Record_Select));
           
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
            this.splittedParentId       =    (string) sob.get('Splitted_Parent_id__c');
        }                                                                            
    }
    
}