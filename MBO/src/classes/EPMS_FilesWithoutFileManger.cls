/**********************************************************************************
*   Class               :       EPMS_FilesWithoutFileManger                       *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Controller to download files offline(if server not
                                available)                                        *
**********************************************************************************/

public class EPMS_FilesWithoutFileManger{

public string OrderName {set;get;}
public list<string> inputDetails {set;get;}
public list<File_Categories__c> categoryList{get;set;}
public List<ExcelWrapperclass> Exceldata{set;get;}
public list<Production_Order__c> ordernamecheck = new list<Production_Order__c>();
public String[] result = null;
public static  Map<String,String> FinalURLS = new Map<String,String>();
public static Map<String,String> FinalThumbnailURL = new Map<String,String>();
public static Map<String,String> FinalPreviewURL = new Map<String,String>();
public Static Map<String,String> DirFileURl = new Map<String,string>();
public list<String> Extensions = new list<String>();
public string directory=null;
public Blob csvFileBody{get;set;}
public string csvAsString{get;set;}
public String[] csvFileLines{get;set;}


public EPMS_FilesWithoutFileManger(){
categoryList = new list<File_Categories__c>();
categoryList=[select Name from File_Categories__c ORDER BY Name ASC  ];
csvFileLines = new String[]{}; 
Exceldata = new list<ExcelWrapperclass>(); 
  
}

public void importCSVFile(){
       try{
           csvAsString = csvFileBody.toString();
           csvFileLines = csvAsString.split('\n'); 
           
                     
           for(Integer i=1;i<csvFileLines.size();i++){
               ExcelWrapperclass Obj = new ExcelWrapperclass() ;
               string[] csvRecordData = csvFileLines[i].split(',');
               Obj.OrderName = csvRecordData[0] ;             
               Obj.Parent = csvRecordData[1];
               Obj.FileName = csvRecordData[2];   
               Obj.Extension = csvRecordData[3];                                                                             
               Exceldata.add(Obj);   
           }
         if(Exceldata.size()>0){
          EPMS_FilesWithoutFileManger.FinalExcel(Exceldata);
          ApexPages.Message SuccessMessage = new ApexPages.Message(ApexPages.severity.CONFIRM,'Successfully Uploaded Data');
            ApexPages.addMessage(SuccessMessage);
       }
        }
        catch (Exception e)
        {
        
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct---'+e+'---');
            ApexPages.addMessage(errorMessage);
        }  
  }


public class ExcelWrapperclass{
 
 public String OrderName   { get; set; } 
 public String Parent   { get; set; } 
 public String FileName   { get; set; } 
 public String Extension   { get; set; } 
 
 
  public ExcelWrapperclass(String POName,String PName,String FileNames,String Extensions) {
           OrderName   =POName;
            Parent   =PName;
             FileName   =FileNames;
              Extension   =Extensions;
           
           }
           
           public ExcelWrapperclass(){}
 
 
 }
 
  
 
 public pagereference Reset(){
   
       return null;
  }
  
  
  public static void FinalExcel(list<ExcelWrapperclass> Exceldata) {
  

  set<ExcelWrapperclass>   uniquevalues = new set<ExcelWrapperclass>(); 
  uniquevalues.addall(Exceldata);
  list<ExcelWrapperclass> afterunique = new list<ExcelWrapperclass>();
  afterunique.addall(uniquevalues); 
  set<string> POrderNames = new set<string>();
  list<ExcelWrapperclass> FilesNotHaveDirectory = new List<ExcelWrapperclass>();
   list<ExcelWrapperclass> FilesHaveNestedDirectory = new List<ExcelWrapperclass>();
    list<ExcelWrapperclass> FilesHaveDirectory = new List<ExcelWrapperclass>();
    if(afterunique.size()>0){
            for(ExcelWrapperclass FT : afterunique )
            {
                          
                 if(string.isEmpty(FT.Parent)){
                 FilesNotHaveDirectory.add(FT);
                 POrderNames.add('00'+FT.OrderName);
                 }else if((String.valueOf(FT.Parent)).contains('/')){
                 FilesHaveNestedDirectory.add(FT);
                   POrderNames.add('00'+FT.OrderName);
                 } else{
                 FilesHaveDirectory.add(FT);
                   POrderNames.add('00'+FT.OrderName);
                 }
                 
            }           
    }
     Date dateToday= system.today();
       String sMonth = String.valueof(dateToday.month());
       String sDay = String.valueof(dateToday.day());
       if(sMonth.length()==1){
         sMonth = '0' + sMonth;
              }
       if(sDay.length()==1){
          sDay = '0' + sDay;
         }
      string sToday = String.valueof(dateToday.year()) + sMonth + sDay ;     
   
    EPMS_FilesWithoutFileManger.InsertFileshavenoDir(FilesNotHaveDirectory,POrderNames,sToday);
    EPMS_FilesWithoutFileManger.InsertFilesHaveNestedDir(FilesHaveNestedDirectory,POrderNames,sToday);
    EPMS_FilesWithoutFileManger.insertFilesHaveSingleDir(FilesHaveDirectory,POrderNames,sToday);
    
    
    }
    
    
    public static void InsertFileshavenoDir(list<ExcelWrapperclass> FilesNotHaveDirectory,set<string> POrderNames,string sToday )
    {    
    string Productionordername = null;   
    Production_order__c ordernamecheck = new Production_order__c();
    list<string> NamesPO = new list<String>();
    NamesPO.addall(POrderNames);
        if(NamesPO.size()>0)
        { 
        Productionordername = NamesPO[0];
        }       
        
        
       
        if(Productionordername!=null){
        ordernamecheck= [select id,Name,Mbo_Location__c,Job_List__c,Production_Order_Status__c From Production_Order__c where Name=:Productionordername Limit 1 ];
        }
        
         
       list<Settings__c> locationsetting = new list<Settings__c>();
       if(ordernamecheck!=null){
       locationsetting = [Select Name,file_server_nodejs_port_thumbnail_access__c,file_server_nodejs_port_ins_file_access__c, Samba_File_Input_Location__c,Samba_File_Output_Location__c,file_server_host__c from Settings__c where Location__c =: ordernamecheck.Mbo_Location__c Limit 1];
       }
      

       FinalURLS.clear();
        String FileURL = null;
        if(FilesNotHaveDirectory.size()>0){
           for(ExcelWrapperclass URL :FilesNotHaveDirectory)
           {     
            FileURL = sToday+'/'+Productionordername+'/'+URL.FileName;  
            FinalURLS.put(URL.FileName,FileURL);
            FileURL = null;
           
           }
       }
     
      
      String ThumbURL = null;
      list<string> SplitName = new list<String>();
      string FinalStringName = null;
      FinalThumbnailURL.clear();
      if(locationsetting.size()>0){
     if((String.Valueof(locationsetting[0].Samba_File_Input_Location__c)).Contains(String.ValueOf(locationsetting[0].file_server_host__c))){
     for(ExcelWrapperclass TURL :FilesNotHaveDirectory){
     SplitName= (string.valueOf(TURL.FileName)).split('\\.');
     if(SplitName.size()>1){
     FinalStringName = SplitName[0]+'_t.'+SplitName[1];
     }
     ThumbURL = String.ValueOf(locationsetting[0].file_server_host__c)+':'+locationsetting[0].file_server_nodejs_port_thumbnail_access__c+'/'+sToday+'/'+Productionordername+'/'+FinalStringName;
     FinalThumbnailURL.Put(TURL.FileName,ThumbURL);
     ThumbURL=null; 
     FinalStringName=null;
     SplitName.clear();  
     }
    
     }else{
    
     }
     }
     
     
     string PreviewURL = null;
     FinalPreviewURL.clear();
     if(locationsetting.size()>0){
     if((String.Valueof(locationsetting[0].Samba_File_Input_Location__c)).Contains(String.ValueOf(locationsetting[0].file_server_host__c))){
     for(ExcelWrapperclass ST :FilesNotHaveDirectory){
     
     PreviewURL = String.ValueOf(locationsetting[0].file_server_host__c)+':'+locationsetting[0].file_server_nodejs_port_ins_file_access__c+'/'+FinalURLS.get(ST.FileName);
     FinalPreviewURL.Put(ST.FileName,PreviewURL);
     PreviewURL=null; 
     }
  
     }else{
    
     }
     }
     
     string dirurl = null;
     DirFileURl.clear();
     list<string> dirNamesList = new List<String>();
     if(locationsetting.size()>0){
         for(ExcelWrapperclass STQ :FilesNotHaveDirectory)
         {
         dirNamesList=(String.Valueof(locationsetting[0].Samba_File_Input_Location__c)).split(':445');
         if(dirNamesList.size()>1){
         dirurl = dirNamesList[1]+'/'+FinalURLS.get(STQ.FileName);
         }
         DirFileURl.put(STQ.FileName,dirurl);
         dirurl=null;
         dirNamesList.clear();
         }
     }
     
     
     
      list<Files__c> insertfiles = new list<Files__c>();
      if(ordernamecheck!=null){
     for(ExcelWrapperclass File :FilesNotHaveDirectory){
     Files__c FI = new Files__c();
     FI.Name=File.FileName;
     FI.Production_Order__c=ordernamecheck.id;
     FI.Current_Extension__c=File.Extension;
     FI.File_Type__c='image';
     FI.Status__c='New';
     FI.File_Location__c=ordernamecheck.Mbo_Location__c;
     FI.File_URL__c=FinalURLS.get(File.FileName);
     FI.File_Thumbnail_URL__c=FinalThumbnailURL.get(File.FileName);
     FI.Dir_File_name__c=DirFileURl.get(File.FileName);
     FI.File_Preview_URL__c=FinalPreviewURL.get(File.FileName);
     if(ordernamecheck.Job_List__c!=null){
      FI.File_Job_Titles__c=ordernamecheck.Job_List__c;
      }
     insertfiles.add(FI);    
     }
     }   
        try{
            if(insertfiles.size()>0){
            insert insertfiles;  
            }       
        }catch(Exception e){
            system.debug('--insertfiles--'+e);
            }
    
    }
    
    public static void insertFilesHaveSingleDir(list<ExcelWrapperclass> FilesHaveDirectory ,set<string> POrderNames,string sToday)
    {
    string Productionordername = null;   
    Production_order__c ordernamecheck = new Production_order__c();
    list<string> NamesPO = new list<String>();
    Map<String,string> Dirids = new Map<String,String>(); 
    list<Files__c> FileDirList = new List<Files__c>(); 
    NamesPO.addall(POrderNames);
        if(NamesPO.size()>0)
        { 
        Productionordername = NamesPO[0];
        }       
      
        
        if(Productionordername!=null){
        ordernamecheck= [select id,Name,Job_List__c,Mbo_Location__c,Production_Order_Status__c From Production_Order__c where Name=:Productionordername Limit 1 ];
        }
          
        set<String> Dnames = new Set<String>();
        Boolean Valuethere= false;
        list<string> DirNames = new list<String>();
        list<String> ExistedNames = new List<String>();
        list<String> NonExistedDirNames = new list<String>();
        for(ExcelWrapperclass FTS: FilesHaveDirectory ){
          Dnames.add(FTS.Parent);
        }
        DirNames.addall(Dnames);
        list<Files__c> ExistingdirNames = new List<Files__c>();
        ExistingdirNames = [Select id,Name from Files__c where Name IN:DirNames and File_Type__c='Directory' and Production_order__r.Name=:Productionordername ];
        if(ExistingdirNames.size()>0)
        {
        for(Files__c FU : ExistingdirNames )
        {
        for(integer j=0;j<DirNames.size();j++)
            {
                if(FU.Name == DirNames[j])
                    {
                    ExistedNames.add(DirNames[j]);
                    }else{
                    Valuethere = true;
                    NonExistedDirNames.add(DirNames[j]);
                    }
            }       
        }
       
        }else if(DirNames.size()>0&&ordernamecheck!=null)
            {
                for(integer i=0;i<DirNames.size();i++){
                    Files__c FI = new Files__c();
                     FI.Name=DirNames[i];
                     FI.Production_Order__c=ordernamecheck.id;
                     FI.Current_Extension__c='N/A';
                     FI.File_Type__c='Directory';
                     FI.Status__c='New';
                     FI.File_Location__c=ordernamecheck.Mbo_Location__c;
                     FileDirList.add(FI);  
                }
            }
            
            if(Valuethere==true)
            {
            if(NonExistedDirNames.size()>0&&ordernamecheck!=null){
            for(integer K=0;K<NonExistedDirNames.size();K++){
                    Files__c FI = new Files__c();
                     FI.Name=NonExistedDirNames[K];
                     FI.Production_Order__c=ordernamecheck.id;
                     FI.Current_Extension__c='N/A';
                     FI.File_Type__c='Directory';
                     FI.Status__c='New';
                     FI.File_Location__c=ordernamecheck.Mbo_Location__c;
                     FileDirList.add(FI);  
                }       
            }
        }
            
        try
                    {
                    if(FileDirList.size()>0){
                    insert FileDirList;  
                    }       
        }catch(Exception e){
            system.debug('----'+e);
            }
        if(FileDirList.size()>0)
        {
        FileDirList.addall(ExistingdirNames);
      
            for(Files__c FY: FileDirList){
            Dirids.put(FY.Name,FY.id);
            }
        }else if(ExistingdirNames.size()>0){
         for(Files__c FY: ExistingdirNames){
            Dirids.put(FY.Name,FY.id);
            }       
        }
    
      
       list<Settings__c> locationsetting = new list<Settings__c>();
       if(ordernamecheck!=null){
       locationsetting = [Select Name,file_server_nodejs_port_thumbnail_access__c,file_server_nodejs_port_ins_file_access__c,Samba_File_Input_Location__c,Samba_File_Output_Location__c,file_server_host__c from Settings__c where Location__c =: ordernamecheck.Mbo_Location__c Limit 1];
       }
     
      
        FinalURLS.clear();
        String FileURL = null;
        if(FilesHaveDirectory.size()>0){
           for(ExcelWrapperclass DIRU :FilesHaveDirectory)
           {     
            FileURL = sToday+'/'+Productionordername+'/'+DIRU.Parent+'/'+DIRU.FileName;  
            FinalURLS.put(DIRU.FileName,FileURL);
            FileURL = null;           
           }
       }
     
      String ThumbURL = null;
      list<string> SplitName = new list<String>();
      string FinalStringName = null;
      FinalThumbnailURL.clear();
      if(locationsetting.size()>0){
     if((String.Valueof(locationsetting[0].Samba_File_Input_Location__c)).Contains(String.ValueOf(locationsetting[0].file_server_host__c))){
     for(ExcelWrapperclass TURL :FilesHaveDirectory){
     SplitName= (string.valueOf(TURL.FileName)).split('\\.');
     if(SplitName.size()>1){
     FinalStringName = SplitName[0]+'_t.'+SplitName[1];
     }
     ThumbURL = String.ValueOf(locationsetting[0].file_server_host__c)+':'+locationsetting[0].file_server_nodejs_port_thumbnail_access__c+'/'+sToday+'/'+Productionordername+'/'+FinalStringName;
     FinalThumbnailURL.Put(TURL.FileName,ThumbURL);
     ThumbURL=null; 
     FinalStringName=null;
     SplitName.clear();  
     }
  
     }else{
  
     }
     }
     
     string PreviewURL = null;
     FinalPreviewURL.clear();
     if(locationsetting.size()>0){
     if((String.Valueof(locationsetting[0].Samba_File_Input_Location__c)).Contains(String.ValueOf(locationsetting[0].file_server_host__c))){
     for(ExcelWrapperclass ST :FilesHaveDirectory){
     
     PreviewURL = String.ValueOf(locationsetting[0].file_server_host__c)+':'+locationsetting[0].file_server_nodejs_port_ins_file_access__c+'/'+FinalURLS.get(ST.FileName);
     FinalPreviewURL.Put(ST.FileName,PreviewURL);
     PreviewURL=null; 
     }
     
     }else{
   
     }
     }
     
     string dirurl = null;
     DirFileURl.clear();
     list<string> dirNamesList = new List<String>();
     if(locationsetting.size()>0){
         for(ExcelWrapperclass STQ :FilesHaveDirectory)
         {
         dirNamesList=(String.Valueof(locationsetting[0].Samba_File_Input_Location__c)).split(':445');
         if(dirNamesList.size()>1){
         dirurl = dirNamesList[1]+'/'+FinalURLS.get(STQ.FileName);
         }
         DirFileURl.put(STQ.FileName,dirurl);
         dirurl=null;
         dirNamesList.clear();
         }
     }
    
     
     
     
     list<Files__c> filestoinsert = new list<Files__c>();
      if(ordernamecheck!=null){
         for(ExcelWrapperclass FileD :FilesHaveDirectory){
         Files__c FI = new Files__c();
         FI.Name=FileD.FileName;
         FI.Production_Order__c=ordernamecheck.id;
         FI.Current_Extension__c=FileD.Extension;
         FI.File_Type__c='image';
         FI.Status__c='New';
         FI.File_Location__c=ordernamecheck.Mbo_Location__c;
         FI.File_URL__c=FinalURLS.get(FileD.FileName);
         FI.File_Thumbnail_URL__c=FinalThumbnailURL.get(FileD.FileName);
         FI.Dir_File_name__c=DirFileURl.get(FileD.FileName);
         FI.File_Preview_URL__c=FinalPreviewURL.get(FileD.FileName);
         FI.Parent_id__c=Dirids.get(FileD.Parent);
     if(ordernamecheck.Job_List__c!=null){
        FI.File_Job_Titles__c=ordernamecheck.Job_List__c;
     }
        filestoinsert.add(FI);    
     }
     }
           try{
            if(filestoinsert.size()>0){
            insert filestoinsert;    
            }       
        }catch(Exception e){
            system.debug('--insertfiles--'+e);
            } 
      
      
      
    }
    

 public static void InsertFilesHaveNestedDir(list<ExcelWrapperclass> FilesHaveNestedDirectory ,set<string> POrderNames,string sToday)
    {   
    string Productionordername = null;
        Map<String, Id> fileIdmaps = new Map<String, Id>();   
    Production_order__c ordernamecheck = new Production_order__c();
    list<Settings__c> locationsetting = new list<Settings__c>();
    List<String> splitedCopy = new list<String>(); 
    list<string> NamesPO = new list<String>();
    NamesPO.addall(POrderNames);
       if(NamesPO.size()>0)
       { 
       Productionordername = NamesPO[0];
       }       
     
       
       if(Productionordername!=null){
        ordernamecheck= [select id,Name,Mbo_Location__c,Job_List__c,Production_Order_Status__c From Production_Order__c where Name=:Productionordername Limit 1 ];
        }
              
       // Process the Wrapper List 
       Set<String> directoryNames = new Set<String>();
       Set<String> fileNames = new Set<String>();
       Map<Integer, String> orderFolderMap =  new Map<Integer, String>();
       Map<String, Id> parentMapForFiles = new Map<String, Id>();
       if(FilesHaveNestedDirectory != null && FilesHaveNestedDirectory.size() > 0){
             for(ExcelWrapperclass newExcelWrap : FilesHaveNestedDirectory){
                String rootFolderFile = null;
                if(newExcelWrap.Parent != null){
                    String rootFolderPath = newExcelWrap.Parent;
                    List<String> splitedFolderNames  = rootFolderPath.split('/');                   
                    splitedCopy.addall(splitedFolderNames);
                        if(splitedFolderNames.size() > 0){
                            Integer depthCount = 0;
                            for(String dirName : splitedFolderNames){                               
                                list<Files__c> ExistingdirNames = new List<Files__c>();
                          ExistingdirNames = [Select id,Name from Files__c where Name =:dirName and File_Type__c='Directory' and Production_order__r.Name=:Productionordername ];
                                if(ExistingdirNames == null || ExistingdirNames.isEmpty()){
                                    if(depthCount == 0){
                                        rootFolderFile = dirName;
                                    }
                                    directoryNames.add(dirName);
                                    orderFolderMap.put(depthCount,dirName);
                                    depthCount ++;
                                
                                }
                            }
                        }
                }
                
            
                if(ordernamecheck != null){
                    if(directoryNames != null && directoryNames.size() > 0 && orderFolderMap.size() > 0){
                        List<Files__c> toBeInsertFileList = new List<Files__c>();
                        for(String directory : directoryNames){
                            Files__c newFile = new Files__c();
                            newFile.Name = directory;
                            newFile.Production_Order__c = ordernamecheck.Id;    
                            newFile.File_Location__c = ordernamecheck.Mbo_Location__c;
                            newFile.File_Type__c = 'Directory';
                            newFile.Status__c = 'New';
                            newFile.Current_Extension__c = 'NA';
                            newFile.Parent_Id__c = null;
                            toBeInsertFileList.add(newFile);
                        }
                        
                        if(toBeInsertFileList.size() > 0){
                            insert toBeInsertFileList;
                        }
                        
                        
                        for(Files__c insertedFile : toBeInsertFileList){
                            fileIdmaps.put(insertedFile.Name, insertedFile.Id);
                        }
                      
                        List<Files__c> toBeUpdatedFileList = new List<Files__c>();
                        Integer count = 0;
                        Integer maxsize = directoryNames.size();
                        List<Files__c> finalUpdateList = new List<Files__c>();
                       
                        for(Files__c updateFile : toBeInsertFileList){
                       
                          
                            if(rootFolderFile != null && rootFolderFile != updateFile.Name){                                
                                if(count < maxsize){
                                    String parentFile = orderFolderMap.get(count);                                   
                                    if(parentFile != null){
                                        updateFile.Parent_Id__c = fileIdmaps.get(parentFile);
                                    }
                                    count ++;
                                }
                            }
                            
                            finalUpdateList.add(updateFile);
                        }
                        
                        if(finalUpdateList.size() > 0){
                            update finalUpdateList;
                        }
                    }
                    
                }
                List<String> dirList = new List<String>();
                if(newExcelWrap.Parent != null && newExcelWrap.FileName != null){
                    if(directoryNames != null && directoryNames.size() > 0){
                        dirList.addAll(directoryNames);
                        string immediateParent = dirList[directoryNames.size() - 1];                       
                        parentMapForFiles.put(newExcelWrap.FileName, fileIdmaps.get(immediateParent));
                    }
                }
                
            }
            
            
    
       if(ordernamecheck!=null){
       locationsetting = [Select Name,file_server_nodejs_port_thumbnail_access__c,file_server_nodejs_port_ins_file_access__c, Samba_File_Input_Location__c,Samba_File_Output_Location__c,file_server_host__c from Settings__c where Location__c =: ordernamecheck.Mbo_Location__c Limit 1];
       }
            
        FinalURLS.clear();
        String FileURL = null;
        if(FilesHaveNestedDirectory.size()>0){
           for(ExcelWrapperclass DIRU :FilesHaveNestedDirectory)
           {     
            FileURL = sToday+'/'+Productionordername+'/'+DIRU.Parent+'/'+DIRU.FileName;  
            FinalURLS.put(DIRU.FileName,FileURL);
            FileURL = null;           
           }
       }
       
       
      String ThumbURL = null;
      list<string> SplitName = new list<String>();
      string FinalStringName = null;
      FinalThumbnailURL.clear();
      if(locationsetting.size()>0){
     if((String.Valueof(locationsetting[0].Samba_File_Input_Location__c)).Contains(String.ValueOf(locationsetting[0].file_server_host__c))){
     for(ExcelWrapperclass TURL :FilesHaveNestedDirectory){
     SplitName= (string.valueOf(TURL.FileName)).split('\\.');
     if(SplitName.size()>1){
     FinalStringName = SplitName[0]+'_t.'+SplitName[1];
     }
     ThumbURL = String.ValueOf(locationsetting[0].file_server_host__c)+':'+locationsetting[0].file_server_nodejs_port_thumbnail_access__c+'/'+sToday+'/'+Productionordername+'/'+FinalStringName;
     FinalThumbnailURL.Put(TURL.FileName,ThumbURL);
     ThumbURL=null; 
     FinalStringName=null;
     SplitName.clear();  
     }
    
     }else{
   
     }
     }
     
     string PreviewURL = null;
     FinalPreviewURL.clear();
     if(locationsetting.size()>0){
     if((String.Valueof(locationsetting[0].Samba_File_Input_Location__c)).Contains(String.ValueOf(locationsetting[0].file_server_host__c))){
     for(ExcelWrapperclass ST :FilesHaveNestedDirectory){
     
     PreviewURL = String.ValueOf(locationsetting[0].file_server_host__c)+':'+locationsetting[0].file_server_nodejs_port_ins_file_access__c+'/'+FinalURLS.get(ST.FileName);
     FinalPreviewURL.Put(ST.FileName,PreviewURL);
     PreviewURL=null; 
     }    
     }else{
     
     }
     }
     
     string dirurl = null;
     DirFileURl.clear();
     list<string> dirNamesList = new List<String>();
     if(locationsetting.size()>0){
         for(ExcelWrapperclass STQ :FilesHaveNestedDirectory)
         {
         dirNamesList=(String.Valueof(locationsetting[0].Samba_File_Input_Location__c)).split(':445');
         if(dirNamesList.size()>1){
         dirurl = dirNamesList[1]+'/'+FinalURLS.get(STQ.FileName);
         }
         DirFileURl.put(STQ.FileName,dirurl);
         dirurl=null;
         dirNamesList.clear();
         }
     }
     
     
     
     
     
     
     list<Files__c> filestoinsert = new list<Files__c>();
      if(ordernamecheck!=null){
     for(ExcelWrapperclass FileD :FilesHaveNestedDirectory){
     Files__c FI = new Files__c();
     FI.Name=FileD.FileName;
     FI.Production_Order__c=ordernamecheck.id;
     FI.Current_Extension__c=FileD.Extension;
     FI.File_Type__c='image';
     FI.Status__c='New';
     FI.File_Location__c=ordernamecheck.Mbo_Location__c;
     FI.File_URL__c=FinalURLS.get(FileD.FileName);
     FI.File_Thumbnail_URL__c=FinalThumbnailURL.get(FileD.FileName);
     FI.Dir_File_name__c=DirFileURl.get(FileD.FileName);
     FI.File_Preview_URL__c=FinalPreviewURL.get(FileD.FileName);
     if(parentMapForFiles != null && parentMapForFiles.size() > 0){
        FI.Parent_id__c=parentMapForFiles.get(FileD.FileName);
       
     }
     if(ordernamecheck.Job_List__c!=null){
     FI.File_Job_Titles__c=ordernamecheck.Job_List__c;
     }
     filestoinsert.add(FI);    
     }
     }
  
        try{
            if(filestoinsert.size()>0){
            insert filestoinsert;    
            }       
        }catch(Exception e){
            system.debug('--insertfiles--'+e);
            }   
           
           
       }
    
    
    }
}