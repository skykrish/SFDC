/**********************************************************************************
*   Class               :       EPMS_instructiontree                              *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Controller to update file asinstructions          *
**********************************************************************************/
public class EPMS_instructiontree{
    public Production_Order__c poObjDisplay {public get; public set;}
    public string datavalues{get;set;}
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
   
    public EPMS_instructiontree()
    {
        orderID = ApexPages.currentPage().getParameters().get('id');
        base = ApexPages.currentPage().getParameters().get('type');
        fileRecord = orderID;
        poObjDisplay = new Production_Order__c();
        poObjDisplay  = [SELECT Id,Name,Jobs_List__c, Production_Order_TAT__c,Job_List__c,QC_Incharge__c,TL_Incharge__c,QC_Incharge__r.Name,
                                 Production_Order_Status__c,Total_File_Count__c,TL_Incharge__r.Name,Production_Order_Instruction__c  FROM Production_Order__c where Id = : orderID];
               datavalues = string.valueof(poObjDisplay.Production_Order_TAT__c);       
         parentId = poObjDisplay.Name;
    }
    
    
    public String getAllDetails() {
        List<Bean> Files = new List<Bean>(); 
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String orderID = ApexPages.currentPage().getParameters().get('id');
        List<Files__c> filesComponent = new List<Files__c>();
        FilejasonWrapper responsejsonFiles = new FilejasonWrapper();
        instructionIds = ApexPages.currentPage().getParameters().get('instruction');
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
                    if(f.File_Type__c != 'Directory'){
                        f.File_Type__c = 'File Instruction';                     
                        UpdateFileInstructionList.add(f);
                    }
                }
            }
        }
        
        system.debug('File Instruction : ' + UpdateFileInstructionList);
        if(orderID  != null && reqids.size()>0){
            filesComponent =  [SELECT id, File_Type__c,Name,Parent_Id__c,Splitted_Parent_id__c,Parent_Id__r.instruction__c, Status__c,Production_Order__c FROM Files__c where id not in:reqids AND Production_Order__c = :orderID and (File_type__c='Directory' OR File_type__c='image')];
        }


        if(filesComponent.size() > 0){
            for(Files__c f: filesComponent){
                String filename = f.Name;
                // Ignore the File Name with special characters ' and \
                String ignoreSplCharInName = EPMS_UTIL.ignoreFileNameSpecialCharacters(filename);
                f.Name = ignoreSplCharInName;
                Files.add(new Bean(f)); 
            }
        }
        FileCalJSON = JSON.serialize(Files);
        return FileCalJSON;               
    }
    
      
     public void updateInstructions(){
       
        String files=Apexpages.currentPage().getParameters().get('openInstrFiles');
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
                for(Files__c file : FileList){
                    file.InstructionNames__c = instructionIds;
                    UpFileList.add(file);                    
                }      
            }            
             try{
                 update UpFileList;
                 if(UpdateFileInstructionList.size()>0){
                    update UpdateFileInstructionList;
                 }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_INSTRUCTION_TREE_INST_UPDATED));
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
            this.splittedParentId            =    (string) sob.get('Splitted_Parent_id__c');
        }                                                                            
    }
}