/**********************************************************************************
*   Class               :       EPMS_AnkenClassifications                         *
*   Created Date        :       26/07/2016                                        *           
*   Description         :       To display order files based on Files category    *
**********************************************************************************/

global class EPMS_AnkenClassifications
{
    public String Orderid{get;set;}
    public List<Files__c> ListOfFilesRecords=new list<Files__c>();
    public String PONumber{get;set;}
    
    public SelectOption[] PORedoList{get;set;}
    //public String Orderids{get;set;}
    public String selectedCategory {get;set;}
    public string ProductionOrderName{get;set;}
    public anken__c ankenquery{get;set;}
    public Production_Order__c POquery{get;set;}
    public list<WrapperFiles> FilesClassification{get;set;}
    public integer SumOfTotal{get;set;}
    public integer CompSumOfTotal{get;set;}
    public EPMS_AnkenService_Class service = new EPMS_AnkenService_Class();
    public map<string,list<Files__c> > catMap = new map<string,list<Files__c>>();
    transient public list<Files__c> catquery = new list<Files__c>();
    public set<String> filecat = new set<String>();
    public list<Files__c> filequery = new list<Files__c>();
    public list<String> listcat = new list<String>();
    public list<Job_Titles__c> jobNames=new list<Job_Titles__c>();
    public  map<string,integer> mapInteger {get;set;}
    public list<Anken__c> ank=new list<Anken__c>();
    public String POrecord{get;set;}
    public list<Production_Order__c> PORedoRecords{public get;set;}
    public Boolean OptionalFlag{get;set;}
    public Boolean catFlag{get;set;}
    public String POName{get;set;}
    
    
    public EPMS_AnkenClassifications() {
        
        OptionalFlag=True;
        catFlag=True;
        
        
        
        Production_Order__c po=new Production_Order__c();
        
        //To get PO Name from qc check screen to get id of that po number based on CR-499 --->Modified by Udayasri
        
        POName= ApexPages.currentPage().getParameters().get('id');
        system.debug('-----POName----'+POName);
        if(POName!=null){
            
            po=[select id,name from Production_Order__c where Name=:POName];
            POrecord=po.id;
        }
        
        
        system.debug('----entering into anken classification---');
        Orderid = ApexPages.currentPage().getParameters().get('ids');  
        
        //To get Picklist of Redo PO's in Anken Classification based on CR-499 --->modified by Udayasri
        
        PORedoRecords=[select id,name from Production_Order__c where Anken_Order__c=:Orderid limit 1000];   
        
        PORedoList=new list<SelectOption>();
        for(Production_Order__c PORedo: PORedoRecords) { 
            PORedoList.add(new SelectOption(PORedo.Id,PORedo.Name));
        }
        system.debug('----id---'+Orderid);
        
        ankenquery = new anken__c();
        ankenquery = service.getAnkenrecord(Orderid); 
        
        system.debug('----ankenquery----'+ankenquery);
        
        POquery = new Production_order__c();
        
        if(POName!=null){
            POquery =  [select id,name,Total_Anken_Count__c  from Production_Order__c where Name=:POName];
            PONumber=POquery.Name; 
            if(POquery == null) {
                POquery = new Production_Order__c(Name=Label.EPMS_MBO_ANKEN_VIEW_CLASSIFY);
            }
        }else{
            if(ankenquery!=null) {
                POquery = service.getPOrecord(ankenquery.Name); 
                
                if(PONumber != null) {
                    PONumber=POquery.Name; 
                }
                
                if(POquery == null) {
                    POquery = new Production_Order__c(Name=Label.EPMS_MBO_ANKEN_VIEW_CLASSIFY);
                }
            } 
        }        
        filequery = service.getallFiles(POquery.id);           
        for(Files__c FCat: filequery ) {
            filecat.add(FCat.File_Category_Code__r.Name);
        }    
        listcat.addall(filecat);
        
        Map<string,integer> maptotalfiles = new Map<String,integer>();
        Map<string,integer> maptotalfilesC = new Map<String,integer>();
        List<AggregateResult> files = new  List<AggregateResult>();
        
        ListOfFilesRecords=[select id,name,File_Job_Titles__c FROM Files__c WHERE Production_Order__c =: POquery.id and Status__c='Approved' and file_type__C='Image'];
        jobNames = [select id,Name from Job_Titles__c where Name!='Clipping' and Disabled__c = false ORDER BY Name ASC];
        system.debug('--------------------jobNames---------------------------'+jobNames);
        Map<id,string> optinalJobMap = new Map<id,string>();
        
        if(ListOfFilesRecords.size()>0) {
            for(Files__c f:ListOfFilesRecords) {
                
                optinalJobMap.put(f.id,f.File_Job_Titles__c);
            }
        }
        system.debug('--------------------optinalJobMap---------------------------'+optinalJobMap);
        map<string,List<string>> totalOptionalJobs = new  map<string,List<string>>();
        mapInteger = new map<string,integer>();
        
        for(Job_Titles__c sl:jobNames) {
            
            integer i = 0;
            
            for(string s:optinalJobMap.KeySet()) {               
                
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
                    
                    /*    if(totalOptionalJobs.containsKey(sl.name)){
totalOptionalJobs.get(sl.name).add(s);
}else{
totalOptionalJobs.put(sl.name,new List<string>{s});
} */
                    
                } 
            }
            
        }
        if(!(mapInteger.size()>0)) {       
            OptionalFlag=false;
            
        }  
        
        system.debug('--------------totalOptionalJobs--------------'+totalOptionalJobs);
        system.debug('--------------mapInteger--------------'+mapInteger);
        
        files = [SELECT File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Production_Order__c =: POquery.id and Status__c='Approved' group by File_Category_Code__r.name]; 
        if(files != null && files.size() > 0) {
            for(AggregateResult ar : files) {
                Integer totalNoOfFiles = Integer.valueOf(ar.get('NumberOfFiles'));
                String catogoryName = (string) ar.get('CategoryCode');
                maptotalfiles.put(catogoryName,totalNoOfFiles);
                maptotalfilesC.put(catogoryName,totalNoOfFiles);
            }
        }
        FilesClassification = new list<WrapperFiles>();
        for(string finalfor:filecat) {
            if(maptotalfiles.KeySet().contains(finalfor)) {
                WrapperFiles Wrapobj = new WrapperFiles();
                Wrapobj.ClassificationName = finalfor;
                Wrapobj.TotalFilesCount = maptotalfiles.get(finalfor);
                Wrapobj.CompletedFilesCount = maptotalfilesC.get(finalfor);
                FilesClassification.add(Wrapobj);
                
                if(SumOfTotal==null) {
                    SumOfTotal = maptotalfiles.get(finalfor); 
                }else{
                    if(maptotalfiles.get(finalfor) != null){
                        SumOfTotal = SumOfTotal+maptotalfiles.get(finalfor);
                    }
                }
                if(CompSumOfTotal==null) {
                    CompSumOfTotal = maptotalfilesC.get(finalfor); 
                }else{
                    if(maptotalfilesC.get(finalfor) != null) {
                        CompSumOfTotal = CompSumOfTotal+maptotalfilesC.get(finalfor);
                    }
                }
            }    
        }
        
        if(!(FilesClassification.size()>0)) {         
            catFlag=false;  
        }  
        
        if(!(FilesClassification.size()>0)) {
            catFlag=false;
        }  
        FilesClassification.sort();// sorting Wrapper list based on Category Name 
        
    }
    
    public void refreshRedoRecords() {
        SumOfTotal=0;
        FilesClassification.clear();
        system.debug('?????wrapperlist????'+FilesClassification);
        filterByStatus();   
    }
    public List<SelectOption> getAllTypeCategory() {     
        List <SelectOption> options  = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('Approved','Approved'));
        return options;
    }
    
    
    public void filterByStatus() {
        SumOfTotal = 0;
        CompSumOfTotal = 0;
        
        system.debug('Selected Category is : ' + selectedCategory);
        Map<string,integer> maptotalfiles = new Map<String,integer>();
        Map<string,integer> maptotalfilesC = new Map<String,integer>();
        List<AggregateResult> files = new  List<AggregateResult>();
        selectedCategory = 'All';
        
        if(POrecord!=null) {
            POquery=[Select id,Name,Total_Anken_Count__c  from Production_Order__c where id=:POrecord];
        }
        
        
        if(selectedCategory == 'All'){
            files = [SELECT File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Production_Order__c =: POquery.id and Status__c='Approved' group by File_Category_Code__r.name];         
            system.debug(' Approved Files scenario : ' + files.size());
        } 
        
        
        Production_Order__c ProdName=[select id,name from Production_Order__c where id=:PORecord];
        PONumber=ProdName.name;
        
        files = [SELECT File_Category_Code__r.name CategoryCode,Count(Name) NumberOfFiles FROM Files__c WHERE Production_Order__c =: POquery.id and Status__c='Approved' group by File_Category_Code__r.name];  // AND Status__c='Approved'               
        system.debug(' All Files scenario : ' + files.size());
        
        
        system.debug('Files are in AggregateResult : ' + files);
        if(files != null && files.size() > 0){
            for(AggregateResult ar : files){
                Integer totalNoOfFiles = Integer.valueOf(ar.get('NumberOfFiles'));
                String catogoryName = (string) ar.get('CategoryCode');
                maptotalfiles.put(catogoryName,totalNoOfFiles);
                maptotalfilesC.put(catogoryName,totalNoOfFiles);
            }
        }
        system.debug(' Map 1 Data : ' + maptotalfiles);
        system.debug(' Map 2 Data : ' + maptotalfilesC);
        FilesClassification = new list<WrapperFiles>();
        
        //To get number of occurences of Each JobTitle in an Particular PO When the po number was changed in PO Picklist based on CR-499--->Modified by Udayasri
        
        ListOfFilesRecords=[select id,name,File_Job_Titles__c FROM Files__c WHERE Production_Order__c =: POquery.id and Status__c='Approved'];
        jobNames = [select id,Name from Job_Titles__c where Name!='Clipping' and Disabled__c = false ORDER BY Name ASC];
        system.debug('--------------------jobNames---------------------------'+jobNames);
        Map<id,string> optinalJobMap = new Map<id,string>();
        
        if(ListOfFilesRecords.size()>0){
            for(Files__c f:ListOfFilesRecords){
                
                optinalJobMap.put(f.id,f.File_Job_Titles__c);
                
            }
        }
        
        map<string,List<string>> totalOptionalJobs = new  map<string,List<string>>();
        mapInteger = new map<string,integer>();
        
        for(Job_Titles__c sl:jobNames) {
            integer i = 0;
            
            for(string s:optinalJobMap.KeySet()) {
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
        
        //To get number of occurences of each category in particular PO number based on CR-499 -->Modified by Udayasri
        filequery = service.getallFiles(POquery.id);           
        for(Files__c FCat: filequery ) {
            filecat.add(FCat.File_Category_Code__r.Name);
        }   
        
        for(string finalfor:filecat) {
            if(maptotalfiles.KeySet().contains(finalfor)) {
                WrapperFiles Wrapobj = new WrapperFiles();
                Wrapobj.ClassificationName = finalfor;
                Wrapobj.TotalFilesCount = maptotalfiles.get(finalfor);
                Wrapobj.CompletedFilesCount = maptotalfilesC.get(finalfor);
                FilesClassification.add(Wrapobj);
                
                if(SumOfTotal==null) {
                    SumOfTotal = maptotalfiles.get(finalfor); 
                }else{
                    if(maptotalfiles.get(finalfor) != null){
                        SumOfTotal = SumOfTotal+maptotalfiles.get(finalfor);
                    }
                }
                if(CompSumOfTotal==null) {
                    CompSumOfTotal = maptotalfilesC.get(finalfor); 
                }else{
                    if(maptotalfilesC.get(finalfor) != null){
                        CompSumOfTotal = CompSumOfTotal+maptotalfilesC.get(finalfor);
                    }
                }
            }    
        }
        
        if(!(SumOfTotal>0)) {
            SumOfTotal=0;
            
        }
        
        FilesClassification.sort();// sorting Wrapper list based on Category Name
    }
    
    //calling another VF page to download page result
    public PageReference  ExportToExcel(){
        PageReference Exportexcelpage = new Pagereference('/apex/EPMS_AnkenClassificationsExportExcel' + '?id=' + POquery.id);
        Exportexcelpage.setRedirect(false);
        return Exportexcelpage;
    }
    
    //calling another VF page to download Estimation page result
    public PageReference  ExportToExcelEstimation(){
        PageReference Exportexcelpage = new Pagereference('/apex/EPMS_AnkenEstimationExportExcel' + '?id=' + POquery.id);
        Exportexcelpage.setRedirect(false);
        return Exportexcelpage;
    }
    
    //define wrapper list
    global class WrapperFiles implements Comparable {
        
        public String ClassificationName{get;set;}
        public integer TotalFilesCount{get;set;}
        public integer CompletedFilesCount{get;set;}
        
        public WrapperFiles(String Classification,integer TotalFiles, integer CompletedFiles  ) {
            this.ClassificationName =  Classification;
            this.TotalFilesCount = TotalFiles;
            this.CompletedFilesCount =  CompletedFiles ;             
            
        }
        
        public WrapperFiles(){}
        
        global Integer compareTo(Object ObjToCompare) {
            return ClassificationName.CompareTo(((WrapperFiles)ObjToCompare).ClassificationName);
        }
        
    }
    
}