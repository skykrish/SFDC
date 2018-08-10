/**********************************************************************************
*   Class               :       EPMS_FileFielddetails                             *
*   Date                :       13/04/2016                                        *           
*   Description         :       webservice to Create/update all file              *
**********************************************************************************/ 

@RestResource(urlMapping = '/FilesFieldUpdate/*') //https://login.salesforce.com/services/apexrest/FilesFieldUpdate
global with sharing class EPMS_FileFielddetails {
    public static list<Production_order__c> ordernumber = new list<Production_order__c>();
    
    public List < POHierarchy > POHierarchy { get; set; }
    public static String ProductionOrder {  get;  set; }

    public static list < string > directoryname = new list < string > ();
    public static map<string,string> mapstring= new map<string,string>();
    public static map<string,string> mapdir= new map<string,string>();
    public static map<string,string > directoryChild = new map< string,string> ();
    public static list < Files__c > FinaldirList = New list < Files__c > ();
    public static  map<string,string> directoryInfoMap = new map<string,string>();
    public static  list<Files__c> CheckFilesExisted = new list<Files__c>();
    public static string ordernumberid;
    public static string filestat;
    public static boolean redo;
  
    public static string PorderName;
    public static string Locationid;
    public static string SettingsNameid;
    public static string JobList;
    public static list < FileVar > CompleteFileVar = new list < FileVar > ();
  public static list < string > filesvarParentIdList = new list < string > ();
    public static list < Files__c > Updatep = new list < Files__c > ();
    public static String Except;
    
    @httppost
    global static list < string > doPost() {

        RestRequest req = RestContext.request;
        string jsonstring = req.requestBody.toString();
        JSONParser parser = System.JSON.createParser(jsonstring);

        ProductionOrder = null;  
        string  statusType;
        string Status;
        string toDelete_PO_No;
        list < string > response = new list < string > ();
        list<string> arrays = new list<string>();
        boolean toDelete_PO_Files = false;
        // Reading Json String Starts Here for Delete PO file before Insert
        while(parser.nextToken() != JSONToken.END_OBJECT){
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME){
                String text = parser.getText();
                system.debug(' [ JSON STRING KEY ] ' +  text);
                if(parser.nextToken() != JSONToken.VALUE_NULL){
                    if(text == 'DeleteInsertPO'){
                        toDelete_PO_No = parser.getText();
                        system.debug('Requested PO File Deletion ' + toDelete_PO_Files + ' [ ORDER NO ] ' +  toDelete_PO_No);
                        if(toDelete_PO_No != null){
                            toDelete_PO_Files = true;
                            system.debug('Is Delete FIles before insert : ' + toDelete_PO_Files + ' [ ORDER NO ] ' +  toDelete_PO_No);                      
                        }
                        
                    }
                }
            }
        }
        
        if(toDelete_PO_Files && toDelete_PO_No != null){
            system.debug('[ INSIDE THE EXISTING FILE DELETION BLOCK ]');
            List<Files__c> deleteFilesList = [SELECT Id, Name FROM Files__c WHERE Production_Order__r.Name =: toDelete_PO_No];
            if(deleteFilesList != null && deleteFilesList.size() > 0){
                try{
                    system.debug('File Deletion Initiated : order no - [' + toDelete_PO_No + ']');
                    delete deleteFilesList;
                    system.debug('File Deletion Completed : order no - [' + toDelete_PO_No + ']');
                
                } catch(Exception de){
                    system.debug('Unable to delete the exisiting files for input production order : ' + de.getMessage());
                }
            }
        
        }
        parser = System.JSON.createParser(jsonstring);
        //Reading Json String Starts Here
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'ProductionOrder') {
                         system.debug('Production Order :-----------****** ' +ProductionOrder);
                        ProductionOrder = parser.getText(); // getting ProductionOrder which we are Requesting 
                        EPMS_FileFielddetails.Productiondetails(ProductionOrder);
                    } 
                    else if (text == 'statusType') {
                        statusType = parser.getText(); // getting Type whether its download or Upload
                        if (ProductionOrder != null && statusType != null) {
                            EPMS_FileFielddetails.updatePOstatus(ProductionOrder, statusType);
                        }
                    }else if (text == 'POHierarchy') {      
                    // Started reading Complete Files and Directories Starts Here
                        List < POHierarchy > POHierarchy = new List < POHierarchy > ();
                        while (parser.nextToken() != JSONToken.END_ARRAY) {
                            POHierarchy.add(new POHierarchy(parser,null,0));
                        }
                    } 
                    else {
                        consumeObject(parser);//check whether we reached depth and end of Json String
                    }
                }
            }
        }
        
        system.debug('Production Order :----------- ' + ProductionOrder);
        Set<String> dirFileSet = new Set<String>();
        List<Files__c> filesExistingList = null;
        Id orderTeamLeader = null;
        Id orderQualityControl = null;
        Production_Order__c orderInformationUpdate = null;
        if(ProductionOrder != null){
            system.debug('Production order not equal to null-------------------');
             //Process the Team Leader and Quality Control
            //orderInformationUpdate = [SELECT Id, Name, TL_Incharge__c, QC_Incharge__c FROM Production_Order__c WHERE Name = :ProductionOrder AND (Production_Order_Status__c = 'New' OR Production_Order_Status__c = 'Pending') ];
            orderInformationUpdate = [SELECT Id, Name, TL_Incharge__c, QC_Incharge__c FROM Production_Order__c WHERE Name = :ProductionOrder AND (Production_Order_Status__c = 'New' OR Production_Order_Status__c = 'Pending' OR Production_Order_Status__c = 'Estimation Request')];
            system.debug('orderInformationUpdate-----------------------'+orderInformationUpdate);
            filesExistingList = [SELECT Id, Name, Dir_File_name__c, File_URL__c,Production_Order__r.Redo__c,Redo__c FROM Files__c WHERE Production_Order__r.Name =: ProductionOrder AND File_Type__c = 'Image'];
            if(filesExistingList != null && filesExistingList.size() > 0){
                for(Files__c existFile : filesExistingList){
                    if(existFile.Dir_File_name__c != null){
                        dirFileSet.add(existFile.File_URL__c);
                        system.debug('Files Inside the Order is : ' + existFile);
                    }
                }
            }
        }
        system.debug('Existing File URL List : ' + dirFileSet);
        Set<String> fileUrlNameList = new Set<String>();
        list < Files__c > FileList = New list < Files__c > ();  
        if (ordernumber.size() > 0) {
            for (integer index=0;index<CompleteFileVar.size();index++) {
        FileVar i = CompleteFileVar.get(index);
        string parentId = filesvarParentIdList.get(index);
                boolean fileExist = false;
                if(dirFileSet != null && dirFileSet.size() > 0){
                    if(dirFileSet.contains(i.fileurlme)){
                        fileExist = true;
                        fileUrlNameList.add(i.fileurlme);
                        system.debug('Duplicate Found !!! - File Exists : ' + i);
                        system.debug('CURRENT URL ' + i.fileurlme);
                        
                    }
                } 
                system.debug('Is File Exists : ' + fileExist);
                if(!fileExist){
                    files__c FS = new files__c();
                    FS.Name = i.Name;
                    FS.Current_Extension__c = i.currentext;
                    FS.Dir_File_name__c = i.Dirfilename;
                    FS.File_Location__c = ordernumber[0].Mbo_Location__c;
                    FS.File_Preview_URL__c = i.filepreviewurl;
                    FS.File_Thumbnail_URL__c = i.filethumburl;
                    FS.Production_Order__c = ordernumber[0].id;
                    FS.Redo__c = ordernumber[0].Redo__c;
                    system.debug('*** EPMS_FileFielddetails i.filestatus :: ' + i.filestatus);
                    //FS.Status__c = i.filestatus; // Copying filr status from FM to SFDC is commented out and calculated based on PO
                    
                    system.debug('-----filestat----'+filestat);
                    
                    FS.Status__c = filestat;
                    FS.Parent_Id__c = parentId;
                    FS.File_URL__c = i.fileurlme;
                    if(!String.isEmpty(SettingsNameid)){
                        FS.Setting__c = SettingsNameid;
                    }
                    if(orderInformationUpdate != null){
                        FS.QCIncharge__c = orderInformationUpdate.QC_Incharge__c;
                        FS.TLInCharge__c = orderInformationUpdate.TL_Incharge__c;
                        system.debug('Team Leader : ' + orderInformationUpdate.TL_Incharge__c);
                        system.debug('Quality Control : ' + orderInformationUpdate.QC_Incharge__c);
                    }
                    //if(i.fileRenamed == 'true'){
                        //FS.filerenamed__c = true;
                    //} 
                    if(i.fileRenamed != null){
                        FS.filerenamed__c = i.fileRenamed;
                    } 
                    system.debug('Received File Name :Original Text :' + i.receivedFileName + ' is renamed ??' + i.fileRenamed);
                    FS.original_file_name__c = i.receivedFileName;
                    FS.File_Type__c = 'image';
                    FS.Order_Instructions__c=ordernumber[0].Production_Order_Instruction__c;
                    FS.File_Job_Titles__c=JobList;
                    FileList.add(FS);
                }
                
            }
        }
        
        system.debug('File URL Name List : ' + fileUrlNameList);
        
        try{
        if (FileList.size() > 0) { 
            insert FileList;   
            Except='Success';
        }
        }catch (exception e)
        {
            Except=String.valueof(e);
            system.debug('****exception raised ***'+e);  
        }
        
        List<Files__c> reDownloadFileList = null;
        List<Files__c> updateFilesList = new List<Files__c>();
        if(fileUrlNameList != null && fileUrlNameList.size() > 0){
            reDownloadFileList = [SELECT Id, Name, ReUpload__c FROM Files__c WHERE File_URL__c IN: fileUrlNameList];
            system.debug('Result Re-Download : ' + reDownloadFileList);
            if(reDownloadFileList != null && reDownloadFileList.size() > 0){
                for(Files__c fileName : reDownloadFileList){
                    system.debug('Result Re-Download Files are : ' + fileName);
                    fileName.ReUpload__c = false;
                    updateFilesList.add(fileName);
                }
            }
        }
        
        try{
            if(updateFilesList.size() > 0){
                system.debug('Re-Upload File Status Disable : ' + fileUrlNameList);
                update updateFilesList;
            }
        }catch (exception e){
            system.debug('****Update Failed during re-download file details:exception raised ***'+e);  
        }

        list<Files__c> spliturl = new list<Files__c>();
        list<String> splitted = new list<String>();
        list<String> splittedfinal = new list<String>();
        list<String> dirNames = new list<String>();
       

        if (FileList.size() > 0 && statusType == 'download') { 
            system.debug('[ UPDATE PARENT ID FOR FILES ] - Inside the block ' + FileList);
            system.debug('[ DIRECTORY LIST ] - Inside the block ' + FinaldirList);
            system.debug(ordernumberid + '[ PRODUCTION ORDER NO ] - Inside the block ' + ordernumber[0].id);
            system.debug('[ LOCATION NAME ] - Inside the block ' + Locationid);
            // In case of file alone received in JSON, Query the list of directory in order
            if(FinaldirList.isEmpty()){
                system.debug('Inside the Empty directory list (before)' + FinaldirList);
                FinaldirList = [Select id,Name from Files__c where Production_Order__c=:ordernumberid AND File_Type__c='Directory' AND File_location__c=:Locationid];
                system.debug('Inside the Empty directory list (after)' + FinaldirList);
            }
            EPMS_FileFielddetails.updateParent(FileList, FinaldirList, ordernumber[0].id); // calling method which will update The parent_id of files    
            system.debug('----statusType----'+statusType);
          //  Status = 'Success';
            Status=Except;
             system.debug('----Status----'+Status);
        } else {
            Status = 'Failed'; 
        }
        if (statusType == 'upload') {
        
        system.debug('----statusType----'+statusType);
        
            Status = 'Success';
        }

        response.add('ProductionOrder :' + ProductionOrder); 
        response.add('Status :' + Status);
        return response;// sending Status to File Manager
    }


    public static void Productiondetails(string productionName)
    {
    
        list<GroupMember> AllSalesRegion = new list<GroupMember>();
        list<Settings__c> settingsusers = new list<Settings__c>();
        String JobTitle_Default = 'Clipping';

        if (productionName != null) {
        //getting id from OrderNAme 
            ordernumber = [select id,Name, Mbo_Location__c,Job_List__c,Production_Order_Instruction__c,User__c, Production_Order_Status__c, Anken_Order__c,Redo__c  from Production_order__c where Name =: productionName  Limit 10];
        }

        if (ordernumber.size() > 0) {
            // Copying JobTitle from Anken to Files
            Anken__c anken = [select id,Name, Job_Titles__c from Anken__c where Id =: ordernumber[0].Anken_Order__c  Limit 1];
            
            if (anken != null && anken.Job_Titles__c != null) {
                JobList = anken.Job_Titles__c;
            } else {
                JobList = JobTitle_Default; 
            }
            system.debug('***** $$ JobList : ' + JobList);
            
            // Copying File status based on PO Status for download files 
            if (ordernumber[0].Production_Order_Status__c ==  Label.EPMS_FileStatus_Estimation_Request) {
                filestat = Label.EPMS_FileStatus_Estimation_Request;
            } else 
                filestat = Label.EPMS_FileStatus_New;
                
                Redo=ordernumber[0].Redo__c;
                
                system.debug('-----redo-----'+Redo);

            system.debug('***** $$ filestat : ' + filestat);
            
            ordernumberid = ordernumber[0].id;
            PorderName = ordernumber[0].Name;
            Locationid=ordernumber[0].Mbo_Location__c;
            //JobList=ordernumber[0].Job_List__c;   
        }

        if(ordernumber.size()>0){
            AllSalesRegion= [Select Id, UserOrGroupId,Group.Name From GroupMember Where UserOrGroupId =:ordernumber[0].User__c];
        }

        if(ordernumber.size()>0&&AllSalesRegion.size()>0){
            settingsusers = [select id,Name,file_server_nodejs_port_ins_file_access__c,file_server_nodejs_port_thumbnail_access__c,file_server_host__c from Settings__c where Location__c=:Locationid AND Group_Name__c=:AllSalesRegion[0].Group.Name ];
        }

        if(settingsusers.size()>0){
            SettingsNameid = settingsusers[0].id;
        } 
    
    CheckFilesExisted = [Select id,Name,parent_id__c from Files__c where Production_Order__c=:ordernumberid AND File_Type__c='Directory' AND File_location__c=:Locationid ];
    
    
    }

    Public static string Insertdirectory(string dirname,string parentid,integer currentlevel)
    {

    list<files__c> checkExistingFiles = new list<Files__c>();
        list<Files__c> dirList = new list<Files__c>();
        string SDirname = dirname.replace('/', '');
        if(parentid==null){
            system.debug('entered into parentid null of insertdirectory');
      for(Files__c checkfiles:CheckFilesExisted){
        if(checkfiles.Name == SDirname && checkfiles.Parent_id__c==null){
           checkExistingFiles.add(checkfiles);
        }
      }
            
        }else{
      for(Files__c checkfiles:CheckFilesExisted){
        if(checkfiles.Name == SDirname && checkfiles.Parent_id__c==parentid){
          checkExistingFiles.add(checkfiles);
        }
      }
         
        }

        if(checkExistingFiles.size()==0){
            system.debug('entered into parentid null of insertdirectory checkExistingFiles');
            if(parentid!=null){
                string D_name = dirname.replace('/', '');
                Files__c FF = new Files__C();
                FF.Name = D_name;
                FF.Production_Order__c = ordernumberid;
                FF.File_Type__c = 'Directory';
             // FF.Status__c = 'New';
                FF.Status__c = filestat;
                FF.Redo__c = Redo;
                FF.Current_Extension__c = 'N/A';
                FF.Parent_id__c=parentid;
                FF.File_Job_Titles__c=JobList;
                FF.File_Location__c=Locationid;
                dirList.add(FF);
                system.debug('***** $$ File1 : ' + FF);

            }else{
                string D_name = dirname.replace('/', '');
                Files__c FF = new Files__C();
                FF.Name = D_name;
                FF.Production_Order__c = ordernumberid;
                FF.File_Type__c = 'Directory';
                //FF.Status__c = 'New';
                FF.Status__c = filestat;
                FF.Current_Extension__c = 'N/A';
                FF.File_Job_Titles__c=JobList;
                FF.File_Location__c=Locationid;
                dirList.add(FF);
                system.debug('***** $$ File2 : ' + FF);
            }
        }else{
            system.debug('entered else part  into parentid null of insertdirectory checkExistingFiles');
            FinaldirList.addAll(checkExistingFiles);
        }

        if(dirList.size()>0){
            insert dirList;
            FinaldirList.addAll(dirList);
            return dirList[0].id;
        }else{
            return checkExistingFiles[0].id;
        } 

    }
     // POHierarchy Wrapper Class starts here...
     public class POHierarchy {

        public FileVar FileVar { get; set; }
        public list < FileVar > filesvarlist;

        public POHierarchy(JSONParser parser,string parentid,integer currentlevel) {

            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    system.debug(' TEXT RECEIVED : ' + text);
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'FileVar') { //check where it has any Files 
                            system.debug(' FILE TEXT RECEIVED : ' + text);
                            FileVar = new FileVar(parser);// calling FileVar method for reading All Fields in FileVar from Json String
                            system.debug(' FILE VAR RECEIVED : ' + FileVar);
                            EPMS_FileFielddetails.insertfiles(FileVar,parentid);//calling method to store the File data in static list 
                        } else if (text.contains('/')) { //check where it has any Folders 
                            system.debug(' FOLDER TEXT RECEIVED : ' + text);
                            string fold = string.valueOf(text);
                            string currentdirid = EPMS_FileFielddetails.Insertdirectory(fold,parentid,currentlevel);
                            directoryname.add(fold);
                        //if folder is there adding name of the folder to string list     
                            List < POHierarchy > folder1 = new List < POHierarchy > ();
                            while (parser.nextToken() != JSONToken.END_ARRAY) {
                                folder1.add(new POHierarchy(parser,currentdirid,currentlevel++)); // if Folder exists calling another Wrapper to Read inside the Folder 
                            }
                        } else {
                            consumeObject(parser);// checking the Depth of Json String 
                        }
                    }
                }
            }
        }
    }



    // De-serialization of each FileStarts Here..
    global class FileVar {
        public String Name {
        get;
        set;
        }
        public String currentext {
        get;
        set;
        }
        public String Dirfilename {
        get;
        set;
        }
        public String location {
        get;
        set;
        }
        public String filepreviewurl {
        get;
        set;
        }
        public String filethumburl {
        get;
        set;
        }
        public String orderid {
        get;
        set;
        }
        public String filestatus {
        get;
        set;
        }
        public String fileurlme {
        get;
        set;
        }
        
        public String fileRenamed{
        get;
        set;
        }
        
        public String receivedFileName{
        get;
        set;
        }
        
        list < FileVar > fileVarList = new list < FileVar > ();

        public FileVar() {

        }

        public FileVar(JSONParser parser) {

            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();   
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'Name') { // Reading Name fof File
                            Name = parser.getText();
                        } else if (text == 'currentext') { // Reading Extension Of File
                            currentext = parser.getText();
                        } else if (text == 'Dirfilename') { // Reading Dirfilename  field
                            Dirfilename = parser.getText();
                        } else if (text == 'location') { // reading File Location 
                            location = parser.getText();
                        } else if (text == 'filepreviewurl') { // Reading Preview URl to View File 
                            filepreviewurl = parser.getText();
                        } else if (text == 'filethumburl') { // Reading Thumbnail URL for File 
                            filethumburl = parser.getText();
                        } else if (text == 'orderid') { // Reading Production Order Id where the File Belongs to..
                            orderid = parser.getText();
                        } else if (text == 'filestatus') { // Reading Original Status Of File 
                            filestatus = parser.getText();
                        } else if (text == 'fileurlme') { // Reading File URL Where File IN FTP 
                            fileurlme = parser.getText();
                        } else if(text == 'receivedFileName'){
                            receivedFileName = parser.getText();
                        } else if(text == 'fileRenamed'){
                            fileRenamed = parser.getText();
                        }else {
                            EPMS_FileFielddetails.consumeObject(parser); // Checking Depth 
                        }
                    }
                }  
            }
        }



    }
    // adding FileVar to static list 
    public static void insertfiles(FileVar filevariables,string parentid) {
        CompleteFileVar.add(filevariables);
    filesvarParentIdList.add(parentid);
    }
    // after Insert need to Update Parent Id of Each File we inserted if it has a folder Upon it 
    public static void updateParent(List < files__C > fileList, List <Files__c> dirList, Id orderId) {
    system.debug('--------file list--------'+fileList);
     system.debug('-------dir-list------'+dirList);
      
    Map<Id,String> mapDirFile = new Map<Id,String>();
    list < Files__c > newlist = new list < Files__c > ();
    newlist = [Select Id, File_Auto_Number__c, Name, File_URL__c, Parent_Id__c from Files__c where Production_Order__c = : orderId And File_Type__c = 'image']; // getting File list which we are inserted 
    list < Files__c > newdirlist = new list < Files__c > ();
    newdirlist = [Select Id, File_Auto_Number__c, Name, File_URL__c from Files__c where Production_Order__c = : orderId And File_Type__c = 'Directory']; // getting dir list if folder are there 

    map<integer,string> directoryIndexMap = new map<integer,string>();
    if(newdirlist != null && newdirlist.size() > 0){
        String wholeDirectoyName = '';
        Integer strCount = 0;
        for (Files__c dir: dirList) {
            directoryIndexMap.put(strCount,dir.Name);
            directoryInfoMap.put(dir.Name, dir.Id);
        }
    }
    system.debug('[DirectoryIndex Map ] : ' + directoryIndexMap);
    system.debug('{directoryInfoMap } :' + directoryInfoMap);
    list < files__c > updatelist;  
    List < Files__c > filesInDir; 
    if (dirList.size() > 0 && fileList.size() > 0) {
        for (Files__c dir: dirList) {
            String parentDirForFile = null;
            updatelist = new List < Files__c > ();
            for (Files__c files: fileList) {
                if ((string.valueOf(files.File_URL__c)).contains('/'+dir.Name)) {
                    String fileUrlInfo = files.File_URL__c;
                    system.debug('----- fileUrlInfo -----' + fileUrlInfo);
                    String fileUrlInfo2 = fileUrlInfo.replace('/'+files.Name, '');
                    system.debug('----- fileUrlInfo2 -----' + fileUrlInfo2);
                    String[] findDirectory = fileUrlInfo2.split('/'+PorderName);
                    if(findDirectory != null && findDirectory.size() > 1){
                        system.debug('----- DIRECTORY LIST -----' + findDirectory);
                        String[] fileDirectoryNames = findDirectory[1].split('/');
                        system.debug('--STRING LIST-----' + fileDirectoryNames);
                        for(integer i= 0; i < fileDirectoryNames.size(); i++){
                            if(fileDirectoryNames[i]==dir.Name){
                                system.debug('===MATCHED+++');
                            }
                        }
                        if(fileDirectoryNames != null && fileDirectoryNames.size() > 0){
                            parentDirForFile = fileDirectoryNames.get(fileDirectoryNames.size()-1);
                            mapDirFile.put(files.Id,parentDirForFile );
                        }
                    }
                    updatelist.add(files);
                }
            }

        // calling another to update Parent id 
        }

    }
    //system.debug(updatelist.size()+'--------updatelist-------'+updatelist);

    EPMS_FileFielddetails.updateParentFinal(mapDirFile, fileList);

    }
    // it is the Final Method to Update Parent id of file if it has ...
    public static Void updateParentFinal( Map<Id,String> mapDirFile, list < Files__c > FileList_Parent) {
    
    system.debug('---------directoryInfoMap--------'+directoryInfoMap);
    system.debug('---------FileList_Parent--------'+FileList_Parent);
    system.debug('---###------FINAL PARENT CHILD MAP--------'+mapDirFile);
        if (mapDirFile!= null && FileList_Parent.size() > 0) {
            for (Files__c FT: FileList_Parent) {
                Files__c FG = new Files__c();
                FG.id = FT.id;
                string parentid = directoryInfoMap.get(mapDirFile.get(FT.id));
                system.debug('[Directory Id for Files is ] : ' + parentid);
                //FG.Parent_Id__c = parentid;
                Updatep.add(FG);    
            }
        }
        system.debug('--------Updatep------'+Updatep);
        if (Updatep.size() > 0) {
            //Update Updatep;
        }
        Updatep.clear(); // clearing the Update List 
    }

    // method to Update Production Order as Download..once it inserted successfully..
    public static Void updatePOstatus(String PONumber, string StatusType) {

        list < Production_Order__c > PO_Number = new list < Production_Order__c > ();
        list < Production_Order__c > PO_Update = new list < Production_Order__c > ();
        PO_Number = [select id, Production_Order_Status__c,Production_Order_Old_Status__c,Name, FTP_Download_Status__c, ReUpload__c from Production_Order__c where Name = : PONumber Limit 100];
        Production_Order__c updatePO = new Production_Order__c();
        if (PO_Number.size() > 0) {
            if (StatusType == 'download') {
                for (Production_Order__c po1: PO_Number) {
                    //if (po1.Production_Order_Status__c == 'New' || po1.Production_Order_Status__c == 'Pending') {
                    if (po1.Production_Order_Status__c == 'New' || po1.Production_Order_Status__c == 'Pending' || po1.Production_Order_Status__c == 'Estimation Request') {
                        updatePO.id = po1.id;
                        updatePO.FTP_Download_Status__c = true;
                        updatePO.ReUpload__c = false;
                        PO_Update.add(updatePO);
                    }
                }
            }
        }
        if (PO_Number.size() > 0) {
            if (StatusType == 'upload') {
                for (Production_Order__c po: PO_Number) {
                    if (po.Production_Order_Status__c == 'Completed') {
                        updatePO.id = po.id;
                        updatePO.Production_Order_Status__c='Uploaded';
                        updatePO.FTP_Upload_Status__c = true;
                        updatePO.FTP_Upload_Time__c = System.Now();
                        PO_Update.add(updatePO);
                    }
                }
            }
        }
        if (PO_Update.size() > 0) {
            Update PO_Update;
        }
    }

    //checking everytime the depth of json string 
    public static void consumeObject(JSONParser parser) {
        Integer depth = 0;
        do {
            JSONToken curr = parser.getCurrentToken();
            if (curr == JSONToken.START_OBJECT ||
                curr == JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == JSONToken.END_OBJECT ||
                curr == JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
        }

    }