/**********************************************************************************
*   Class               :       EPMS_AnkenEstimationExportExcel              *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       export excel for anken files                      *
**********************************************************************************/
global class EPMS_AnkenEstimationExportExcel {
    
    public String Orderid{get;set;}
    public Boolean Catg{get;set;}
    
    public Production_Order__c POquery{get;set;}
    public list<WrapperFiles> FilesClassification{get;set;}
    public EPMS_AnkenService_Class service = new EPMS_AnkenService_Class();
    
    public Anken__c AnkenQuery=new Anken__c();
    public set<String> filename = new set<String>();    
    public list<Files__c> filequery = new list<Files__c>();
    public Map<string,string> maptotalDirName = new Map<String,string>();
    public Map<string,string> mapfinalCat = new Map<String,string>();
    public  list<String> FinaldirValues; 
    public list<Job_Titles__c> jobNames=new list<Job_Titles__c>();
    public  map<string,integer> mapInteger {get;set;}
    public list<WrapperFilesList> FilesClassificationCatg{get;set;}
    public integer SumOfTotal{get;set;}
    public integer CompSumOfTotal{get;set;}
    public map<string,list<Files__c> > catMap = new map<string,list<Files__c>>();
    transient public list<Files__c> catquery = new list<Files__c>();
    public set<String> filecat = new set<String>();
    public list<Files__c> filequerys = new list<Files__c>();
    public list<String> listcat = new list<String>();
    
    public Boolean OptionalFlag{get;set;}
    
    
    public EPMS_AnkenEstimationExportExcel(){
        
        
        
        Orderid = ApexPages.currentPage().getParameters().get('id');//getting order id for which order we need get file details
        
        //Store all Categories in set of String
        
        //filequerys = service.getallFiles(Orderid);
        filequerys =     [Select id,Name,Estimated_File_Category__r.Name from Files__c where Production_Order__c =:orderid and Estimated_File_Category__c != null ];           
        for(Files__c FCat: filequerys){
            filecat.add(FCat.Estimated_File_Category__r.Name);
        }    
        
        listcat.addall(filecat);
        
        Map<string,integer> maptotalfiles = new Map<String,integer>();
        Map<string,integer> maptotalfilesC = new Map<String,integer>();
        List<AggregateResult> files = new  List<AggregateResult>();
        
        POquery=new Production_order__c();
        if(Orderid!=null) {
            POquery = service.getProductionOrderrecord(Orderid);//based on Order id getting Production Order details
            
        }
        string OrderName = POquery.Name+'/';   
        //filequery = service.getallFilesEXCEL(POquery.id); //getting all Files of Production Order
        filequery = [Select id,Name,Estimated_File_Category__r.Name,Dir_File_name__c from Files__c where Production_Order__c =:orderid and  Estimated_File_Category__c != null and File_type__c='image'];
        for(Files__c FCat: filequery ) {
            filename.add(FCat.Name);
        }  
        FilesClassification = new list<WrapperFiles>();
        
        Map<Id, Files__c> finalDisplayMap = new Map<Id, Files__c>();
          if(filequery != null && filequery.size() > 0){
                for(Files__c newFileList : filequery){
                    finalDisplayMap.put(newFileList.Id, newFileList);
                    WrapperFiles Wrapobj = new WrapperFiles();//adding all maps and details to wrapper list
                    Wrapobj.FileNames=newFileList.Name;
                    String[] dirUrl;
                    String dirName = '';
                    
                    if(newFileList.Dir_File_name__c != null){
                        dirUrl = newFileList.Dir_File_name__c.split(OrderName);
                        system.debug('Excel Classification : Folder Directory ' + dirUrl);
                        if(dirUrl != null && dirUrl.size() > 1){
                            Wrapobj.DirectoryName = dirUrl[1];
                        } else {
                            Wrapobj.DirectoryName='';
                        }
                        system.debug('Excel Classification : Folder Directory ' + Wrapobj.DirectoryName);
                    } else {
                        Wrapobj.DirectoryName='';
                    }    
                    Wrapobj.ClassificationName=newFileList.Estimated_File_Category__r.Name; 
                    FilesClassification.add(Wrapobj);
                }
            }
        
           
    
        Catg=True;
        if(!(FilesClassification.size()>0)) {
            
            Catg=False;
        }
        FilesClassification.sort();
        
        jobNames = [select id,Name from Job_Titles__c where Name!='Clipping' and Disabled__c = false ORDER BY Name ASC];
        
        map<string,List<string>> totalOptionalJobs = new  map<string,List<string>>();
        mapInteger = new map<string,integer>();
        List<Files__c> ListOfFilesRecords=new list<Files__c>();
        
        ListOfFilesRecords=[select id,name,File_Job_Titles__c FROM Files__c WHERE Production_Order__c =: POquery.id and Estimated_File_Category__c != null and file_type__C='Image'];
        jobNames = [select id,Name from Job_Titles__c where Name!='Clipping' and Disabled__c = false ORDER BY Name ASC];
        system.debug('--------------------jobNames---------------------------'+jobNames);
        
        Map<id,string> optinalJobMap = new Map<id,string>();
        //To count Number of optional jobs in an Particualar Order
        if(ListOfFilesRecords.size()>0) {
            for(Files__c f:ListOfFilesRecords) {
                optinalJobMap.put(f.id,f.File_Job_Titles__c);
            }
        }
        for(Job_Titles__c sl:jobNames) {
            integer i = 0;
            for(string s:optinalJobMap.KeySet()){               
                
                if(optinalJobMap.get(s).contains(sl.name)) {
                    /**check if exact string is presant */
                    system.debug('--------------sl.name---------------------'+sl.name);
                    system.debug('------------optinalJobMap--------------------'+optinalJobMap.get(s));
                    for(String jobName:optinalJobMap.get(s).split(',')) {
                        if(sl.name.equals(jobName)) {
                            i++;
                        }   
                    }
                    mapInteger.put(sl.name,i);
                    OptionalFlag=true;
                    if(!(mapInteger.size()>0)) { 
                        OptionalFlag=false;  
                    }                  
                    
                    /*    if(totalOptionalJobs.containsKey(sl.name)){
totalOptionalJobs.get(sl.name).add(s);
}else{
totalOptionalJobs.put(sl.name,new List<string>{s});
} */ 
                }   
            }   
        }  
        
        //Store Total Number of Files for an Individual Category for an order in an map
        
        files = [SELECT Estimated_File_Category__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Production_Order__c =: POquery.id group by Estimated_File_Category__r.name]; 
        
        
        system.debug('--------------totalOptionalJobs--------------'+totalOptionalJobs);
        system.debug('--------------mapInteger--------------'+mapInteger);
    }
    
     //defined Wrapper list structure
        global class WrapperFiles implements Comparable { 
    
            public string FileNames{get;set;}
            public String  DirectoryName{get;set;}
            public String ClassificationName{get;set;}
        
            public WrapperFiles(string  FilesName, String DirectoriesName,String Classification  ) {
                this.FileNames = FilesName;
                this.DirectoryName =  DirectoriesName ;
                this.ClassificationName =  Classification;
            }
            public WrapperFiles(){ }
           
             global Integer compareTo(Object ObjToCompare) {
                return ClassificationName.CompareTo(((WrapperFiles)ObjToCompare).ClassificationName);
            }
        }
    //Wrapper class for FileClassificationCategory
    
    
    global class WrapperFilesList implements Comparable {
        
        public String ClassificationName{get;set;}
        public integer TotalFilesCount{get;set;}
        public integer CompletedFilesCount{get;set;}
        
        public WrapperFilesList(String Classification,integer TotalFiles, integer CompletedFiles  ) {
            this.ClassificationName =  Classification;
            this.TotalFilesCount = TotalFiles;
            this.CompletedFilesCount =  CompletedFiles ;             
            
        }
        
        public WrapperFilesList(){}
        
        global Integer compareTo(Object ObjToCompare) {
            return ClassificationName.CompareTo(((WrapperFilesList)ObjToCompare).ClassificationName);
        }
    } 
}