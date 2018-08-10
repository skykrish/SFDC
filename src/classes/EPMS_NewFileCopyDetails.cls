/****************************************************************************
*   Class               :       EPMS_NewFileCopyDetails                     *
*   Created Date        :       23/07/2016                                  *           
*   Description         :       webservice to handle tracker                *
*   Modification        :       Modified for EPMSSF-513                     *
/***************************************************************************/

@RestResource(urlMapping = '/NewFileCopyDetails/*') //https://cs31.salesforce.com/services/apexrest/NewFileCopyDetails
global with sharing class EPMS_NewFileCopyDetails {
    @HttpPost
    global static FileWrapper doPost(String fileid, String parentId, String NoOfFile, String locationName, String fileCategoryCode, String fileStatus,
                                     String fileProcessingStatus, String fileName, String fileURL, String fileThumbURL, String filePreviewURL, String fileInstructions,
                                     String fileHandOverInstructions, String fileQCComments, String fileCopyNumber, String originalFile, String fileType, String fileOldStatus,
                                     String currentextension, String orderId, String name, String workStartTime, String workEndTime, String totalWorktime, String totalBreaktime,string totalBreaks, string Filestoopen,string deliveryextension,String operatorid,string qcinchargeid,string tlinchargeid,string filejobtitle) {
                                         RestRequest req = RestContext.request;
                                         RestResponse res = RestContext.response;
                                         system.debug('File Start Work Time :' + workStartTime);
                                         system.debug('File End Work Time   :' + workEndTime);
                                         system.debug('File Name            :' + fileName);
                                         system.debug('File Status          :' + fileStatus);
                                         system.debug('fileQCComments ****          :' + fileQCComments);
                                         system.debug('Filestoopen 1 ****          :' + Filestoopen);
                                         system.debug('filejobtitle ****          :' + filejobtitle);
                                         
                                         Files__c fileObj = new Files__c();
                                         integer totalTime = 0;
                                         integer totalCatWorkTime = 0;
                                         list < Files__c > filelistHandOver = new list < Files__c > ();
                                         list < Files__c > filelist = new list < Files__c > ();
                                         boolean  QcStatusMessage;
                                         
                                         EPMS_RestAPIService restobj = new EPMS_RestAPIService();
                                         
                                         List < Production_order__c > orderIdList = new List < Production_order__c > ();
                                         orderIdList = [select id,Production_Order_Instruction__c from Production_order__c where Name = : orderId Limit 1];
                                         FileWrapper response = new FileWrapper();
                                         if (fileid != null && fileid.length() > 0) {
                                             if (fileStatus != 'Handover') {
                                                 files__c  fileHandoverTime1 = [Select id,Is_Handover_File__c,File_Handover_Time__c  from Files__c where File_Auto_Number__c=:fileid Limit 1]; 
                                                
                                                 fileObj = restobj.fetchFileDetailsForUpdate(fileid);
                                                 if (fileObj != null) {
                                                     if (!string.isEmpty(parentId)) {
                                                         fileObj.Parent_Id__c = parentId;
                                                     } //
                                                     if (NoOfFile != null) {
                                                         fileObj.No_of_the_file__c = Decimal.valueOf(NoOfFile);
                                                     }


                                                     if(fileObj.Redo_Checked_Same_Member__c==false){
                                                         if(fileStatus!='WIP' ){
                                                             if(fileStatus!='QCIP' ){
                                                                 if ((!string.isEmpty(totalWorktime))&&(!string.isEmpty(operatorid))){
                                                                     
                                                                     totalCatWorkTime = integer.valueof(totalWorktime);
                                                                     String workTime = String.valueof(totalCatWorkTime);
                                                                     string individualCategoryCode = restobj.getCategoryCode(workTime,operatorid);  
                                                                     system.debug('---$$--individualCategoryCode----------------------'+individualCategoryCode);
                                                                     fileObj.Individual_Performance_Category__c  = individualCategoryCode;
                                                                     system.debug('--------------------workTime----------------------'+workTime);
                                                                     if(fileHandoverTime1 != null &&  fileHandoverTime1.File_Handover_Time__c != null){
                                                                        

                                                                         totalTime  = integer.valueof(totalWorktime) + integer.valueof(fileHandoverTime1.File_Handover_Time__c); 
                                                                         system.debug('Added Handover Time with total Work Time : '+totalTime);

                                                                      

                                                                     } else {
                                                                      
                                                                         totalTime = integer.valueof(totalWorktime);
                                                                     }
                                                                     
                                                                     String totalWrkTime = String.valueof(totalTime);
                                                                     string catcode = restobj.getCategoryCode(totalWrkTime,operatorid);     
                                                                     
                                                                     fileObj.File_Category_Code__c = catcode; //which tells type of File it is 
                                                                     
                                                                 }
                                                             }
                                                         }
                                                     }
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     if(fileStatus == 'Redo'){
                                                         if(!string.isEmpty(fileQCComments)){
                                                             if( !string.isEmpty(fileObj.QC_Comments__c)){
                                                                 //fileObj.QC_Comments__c = fileObj.QC_Comments__c+' [Redo Comments] '+fileQCComments;
                                                                fileObj.QC_Comments__c = new EPMS_NewFileCopyDetails().getFormatedQCComments(fileQCComments);                                                                
                                                             }else{
                                                                 //fileObj.QC_Comments__c = fileQCComments;
                                                                 fileObj.QC_Comments__c = new EPMS_NewFileCopyDetails().getFormatedQCComments(fileQCComments);
                                                             }
                                                             
                                                             
                                                             
                                                             system.debug('---------------------------'+fileObj.QC_Comments__c);
                                                         }
                                                     }else{
                                                         if(!string.isEmpty(fileQCComments)){
                                                             fileObj.QC_Comments__c = fileQCComments;
                                                         }
                                                     }
                                                     
                                                     fileObj.Status__c = fileStatus; //status of the File will changes from New to WIP once Tracker communicated with sfdc
                                                     fileObj.File_Proccessing_Status__c = fileProcessingStatus;
                                                     fileObj.File_Thumbnail_URL__c = fileThumbURL;
                                                     fileObj.File_Preview_URL__c = filePreviewURL;
                                                     if(fileURL!=null){
                                                         fileObj.File_URL__c = fileURL;
                                                     }
                                                     fileObj.Instruction__c = fileInstructions;
                                                     if(!String.isEmpty(filejobtitle)){
                                                         fileObj.File_Job_Titles__c=filejobtitle;
                                                     }
                                                     fileObj.File_HandOver_Instructions__c = fileHandOverInstructions;
                                                     /*if(!string.isEmpty(fileQCComments)){
fileObj.QC_Comments__c = fileQCComments;
}*/
                                                     if (fileCopyNumber != null) {
                                                         fileObj.File_Copy_number__c = Decimal.valueOf(fileCopyNumber);
                                                     }
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     fileObj.Original_File_Id__c = originalFile;
                                                     fileObj.File_Type__c = fileType;
                                                     fileObj.File_old_Status__c = fileOldStatus;
                                                     fileObj.Current_Extension__c = currentextension;
                                                     fileObj.Delivery_Extension__c = deliveryextension;
                                                     if (!orderIdList.isEmpty()) {
                                                         fileObj.Production_Order__c = orderIdList[0].id;
                                                     }
                                                     fileObj.Name = fileName;
                                                     if(fileObj.Redo_Checked_Same_Member__c==false){
                                                         if (workStartTime != null) {
                                                             fileObj.Work_Start_Time__c = Datetime.valueOf(workStartTime); //tracker send when employee started Work on file
                                                         }
                                                         if (workEndTime != null) {
                                                             fileObj.Work_End_Time__c = Datetime.valueOf(workEndTime); //tracker send when employee ended Work on file
                                                         }
                                                         if (!String.isEmpty(totalWorktime)) {
                                                             
                                                             files__c  fileHandoverTime = [Select id,Is_Handover_File__c,File_Handover_Time__c  from Files__c where File_Auto_Number__c=:fileid Limit 1]; 
                                                             system.debug('--------------------fileHandoverTime------------------------'+fileHandoverTime);
                                                             if(fileHandoverTime != null && fileHandoverTime.File_Handover_Time__c != null){
                                                                 fileObj.Total_Work_Time__c = Decimal.valueOf(totalWorktime)+fileHandoverTime.File_Handover_Time__c;
                                                                 
                                                             }else{
                                                                 
                                                                 fileObj.Total_Work_Time__c = Decimal.valueOf(totalWorktime);
                                                                 
                                                             }
                                                             system.debug('--------------------fileObj.Total_Work_Time__c------------------------'+fileObj.Total_Work_Time__c);
                                                         }
                                                         if (!String.isEmpty(totalBreaktime)) {
                                                             fileObj.Total_Break_Time__c = Decimal.valueOf(totalBreaktime);
                                                         }
                                                         if (!String.isEmpty(totalBreaks)) {
                                                             fileObj.No_of_Breaks__c = integer.valueOf(totalBreaks);
                                                         } 
                                                    }
                                                     fileObj.Files_To_open__c = integer.valueOf(Filestoopen);
                                                     system.debug('Filestoopen 2 ****          :' + Filestoopen);
                                                     
                                                     
                                                     
                                                     
                                                     
                                                     
                                                    
                                                     Files__C QcCheckFile = new Files__C();
                                                     
                                                     QcCheckFile =[select id,name,File_Auto_Number__c,QCIncharge__c from files__c where File_Auto_Number__c =:fileid];
                                                     
                                                   
                                                     
                                                     if(fileStatus =='QCIP' || fileStatus =='Redo'){
                                                         if(!(QcCheckFile.QCIncharge__c == qcinchargeid)){
                                                             QcStatusMessage = false;        
                                                         }else{
                                                             QcStatusMessage = true;
                                                            
                                                         }
                                                         try{
                                                            update fileObj;
                                                            system.debug('Update fileObj 1 : ' + fileStatus + ' ::: ' + fileQCComments + ' ::: ' + filejobtitle); 
                                                        }catch(exception e){
                                                        system.debug('-------------Exception-----------'+e);
                                                             response.status = '' +e;
                                                             return response;
                                                        }
                                                          
                                                          
                                                     }else{
                                                         QcStatusMessage = true;
                                                         try{
                                                              update fileObj;
                                                              system.debug('Update fileObj 2 : ' + fileStatus + ' ::: ' + fileQCComments + ' ::: ' + filejobtitle);
                                                        }catch(exception e){
                                                             system.debug('-------------Exception-----------'+e);
                                                             response.status = ''+e;
                                                             return response;
                                                        }
                                                        
                                                         
                                                     }
                                                     
                                                     system.debug('------------------------response-------------------'+response.status);
                                                     
                                                     
                                                 }
                                                 system.debug('File Status Case 2 :' + fileStatus);
                                                 
                                                 
                                                 if (QcStatusMessage) {
                                                     
                                                     response.status = 'Own'; //sending response if Update is Success
                                                     
                                                 } else {
                                                     response.status = 'Quit'; //sending response if Update Fails
                                                     
                                                 }
                                                 
                                                 
                                                 
                                                 
                                                 
                                                 
                                             } else {
                                                 
                                                 list<Files__c> fileChecked = new List<Files__c>();
                                                 list<Files__c> fileCheckedUpdate = new List<Files__c>();
                                                 if(!string.isEmpty(fileid)){
                                                     fileChecked = [Select id,setting__c, Name,InstructionNames__c,Dir_File_name__c,File_Handover_Time__c,filerenamed__c,original_file_name__c from Files__c where File_Auto_Number__c=:fileid Limit 1];    
                                                 }
                                                 system.debug('-----fileChecked-------'+fileChecked);
                                                 
                                                 
                                                 Files__c FileHand = new Files__c();
                                                 if (!string.isEmpty(parentId)) {
                                                     FileHand.Parent_Id__c = parentId;
                                                 } 
                                                 FileHand.File_Location__c = locationName;
                                                 if (NoOfFile != null) {
                                                     FileHand.No_of_the_file__c = Decimal.valueOf(NoOfFile);
                                                 }
                                                 // Add the Original Name and Renamed File Name
                                                 FileHand.filerenamed__c = fileChecked[0].filerenamed__c;
                                                 FileHand.original_file_name__c = fileChecked[0].original_file_name__c;
                                                 if(fileChecked.size()>0)
                                                 {
                                                     FileHand.setting__c = fileChecked[0].setting__c;  
                                                     
                                                 }
                                                 FileHand.InstructionNames__c =  fileChecked[0].InstructionNames__c;
                                                 FileHand.Dir_File_name__c =  fileChecked[0].Dir_File_name__c;
                                                 system.debug('-------------------------totalWorktime-----------------------'+totalWorktime);
                                                 
                                                 FileHand.Is_Handover_File__c = 1;
                                                 FileHand.Status__c = fileStatus; //status of the File will changes from TBI to WIP once Tracker communicated with sfdc
                                                 FileHand.File_Proccessing_Status__c = fileProcessingStatus;
                                                 FileHand.File_URL__c = fileURL;
                                                 FileHand.File_Thumbnail_URL__c = fileThumbURL;
                                                 FileHand.File_Preview_URL__c = filePreviewURL;
                                                 
                                                 if (!String.isEmpty(totalWorktime)) {
                                                     system.debug('---------------SECOND HANDOVER CASE -fileHandoverTime------------------------'+fileChecked[0]);
                                                     if(fileChecked != null && fileChecked[0].File_Handover_Time__c != null){
                                                         //FileHand.File_Handover_Time__c = Decimal.valueOf(totalWorktime) + fileChecked[0].File_Handover_Time__c;
                                                         FileHand.File_Handover_Time__c = Decimal.valueOf(totalWorktime);
                                                         system.debug('Add the Existing Handover time with current work time : FOR Split Scenario'+FileHand.File_Handover_Time__c);
                                                     }else{
                                                         FileHand.File_Handover_Time__c = Decimal.valueOf(totalWorktime);
                                                     }
                                                 }
                                                 
                                                 system.debug('$$ Handover File : Instruction : ' + fileInstructions);
                                                 FileHand.Instruction__c = fileInstructions;
                                                 if(!String.isEmpty(filejobtitle)){
                                                     FileHand.File_Job_Titles__c=filejobtitle;
                                                 }
                                                 FileHand.File_HandOver_Instructions__c = fileHandOverInstructions;
                                                 if(!string.isEmpty(fileQCComments)){
                                                     FileHand.QC_Comments__c = fileQCComments;
                                                 }
                                                 if (fileCopyNumber != null) {
                                                     FileHand.File_Copy_number__c = Decimal.valueOf(fileCopyNumber);
                                                 }
                                                 FileHand.Original_File_Id__c = originalFile;
                                                 FileHand.File_Type__c = fileType;
                                                 
                                                 FileHand.No_of_the_file__c = 1;
                                                 FileHand.File_old_Status__c = fileOldStatus;
                                                 FileHand.Current_Extension__c = currentextension;
                                                 FileHand.Delivery_Extension__c = deliveryextension;
                                                
                                                 if (!orderIdList.isEmpty()) {
                                                     FileHand.Production_Order__c = orderIdList[0].id;
                                                     if(orderIdList[0].Production_Order_Instruction__c!=null) 
                                                         FileHand.Order_Instructions__c= orderIdList[0].Production_Order_Instruction__c;  
                                                     
                                                 }
                                                 FileHand.Name = fileName;
                                                 FileHand.Files_To_open__c = integer.valueOf(Filestoopen);
                                                 system.debug('Filestoopen **** 3         :' + Filestoopen);
                                                 if(!string.isEmpty(qcinchargeid)){
                                                     FileHand.QCIncharge__c=qcinchargeid;
                                                 }
                                                 if(!string.isEmpty(tlinchargeid)){
                                                     FileHand.TLInCharge__c=tlinchargeid;
                                                 }
                                                 
                                                 filelistHandOver.add(FileHand);
                                                 
                                                 
                                                 if (filelistHandOver.size() > 0) {
                                                     insert filelistHandOver;
                                                     system.debug('Insert fileObj 1 : ' + fileStatus + ' ::: ' + fileQCComments+ ' ::: ' + filelistHandOver);
                                                 }
                                                 
                                                 
                                                 
                                                 if(fileChecked.size()>0){
                                                     Files__c FileStatusCheck = new Files__c();
                                                     FileStatusCheck.id = fileChecked[0].id;
                                                     FileStatusCheck.Status__c ='On-Hold';
                                                     if ((!string.isEmpty(totalWorktime))&&(!string.isEmpty(operatorid))){
                                                         string catcode = restobj.getCategoryCode(totalWorktime,operatorid);     
                                                         FileStatusCheck.Individual_Performance_Category__c  = catcode;
                                                         FileStatusCheck.File_Category_Code__c = catcode; //which tells type of File it is 
                                                     }
                                                     if (workStartTime != null) {
                                                         FileStatusCheck.Work_Start_Time__c = Datetime.valueOf(workStartTime); //tracker send when employee started Work on file
                                                     }
                                                     if (workEndTime != null) {
                                                         FileStatusCheck.Work_End_Time__c = Datetime.valueOf(workEndTime); //tracker send when employee ended Work on file
                                                     }
                                                     if (!String.isEmpty(totalWorktime)) {
                                                         FileStatusCheck.Total_Work_Time__c = Decimal.valueOf(totalWorktime);
                                                     }
                                                     if (!String.isEmpty(totalBreaktime)) {
                                                         FileStatusCheck.Total_Break_Time__c = Decimal.valueOf(totalBreaktime);
                                                     }
                                                     if (!String.isEmpty(totalBreaks)) {
                                                         FileStatusCheck.No_of_Breaks__c = integer.valueOf(totalBreaks);
                                                     }   
                                                     FileStatusCheck.Files_To_open__c=0;
                                                     FileStatusCheck.Tracker_handover__c=true;
                                                     fileCheckedUpdate.add(FileStatusCheck);
                                                     system.debug('Filestoopen FileStatusCheck.Files_To_open__c ****          :' + FileStatusCheck.Files_To_open__c);
                                                     
                                                 }
                                                 if(fileCheckedUpdate.size()>0)
                                                 {
                                                     try{
                                                     Update fileCheckedUpdate;
                                                     system.debug('Update fileObj 3 : ' + fileStatus+ ' ::: ' + fileQCComments + ' ::: ' + filejobtitle);
                                                     system.debug('----------------filecheckedSize-----------------');
                                                     }
                                                     catch(exception e){}
                                                 }    
                                                 
                                                 
                                                 if (filelistHandOver != null) {
                                                     
                                                     response.status = 'Success'; //sending response if Update is Success
                                                     
                                                 } else {
                                                     response.status = 'Error'; //sending response if Update Fails
                                                     
                                                 }
                                                 
                                                 
                                                 
                                             }
                                         } else {
                                             
                                             Files__c fileCreate = new Files__c();
                                             string copystring = 'Copy';
                                             if (Parentid != null) {
                                                 
                                                 filelist = [select id,Setting__c,Status__c,Instruction__c,Order_Instructions__c,QCIncharge__c,File_HandOver_Instructions__c, Name,filerenamed__c,original_file_name__c from Files__c where File_Auto_Number__c = : Parentid];
                                                 system.debug('---------------filelist------------------'+filelist);
                                                 
                                             }
                                             
                                             
                                             if (filelist.size() > 0) {
                                                 
                                                 system.debug('------------filelist[0].QCIncharge__c----------'+filelist[0].QCIncharge__c);
                                                 system.debug('------------qcinchargeid----------'+qcinchargeid);
                                                 
                                                 system.debug('------------qcinchargeid_bool----------'+!(filelist[0].QCIncharge__c == qcinchargeid));
                                                 system.debug('File Status Case 1 :' + fileStatus);
                                                 if(fileStatus =='QCIP' || fileStatus =='Redo'){
                                                     if(!(filelist[0].QCIncharge__c == qcinchargeid)){
                                                         response.status = 'Quit'; 
                                                         system.debug('------------------------------------------'+response);
                                                         return response;
                                                     }
                                                    
                                                     
                                                 }
                                                 
                                                 
                                                 
                                                 
                                                 String currentExtn=null;
                                                 if(fileName != null){
                                                     String[] splitedFileName = fileName.split('\\.');
                                                     system.debug(splitedFileName.size()+'---------'+splitedFileName);
                                                     if(!splitedFileName.isEmpty()){
                                                         if(splitedFileName.size() > 1){
                                                             currentExtn = '.' + splitedFileName[splitedFileName.size() - 1];                       
                                                         }
                                                     }
                                                 }
                                                 
                                                 // Add the Original Name and Renamed File Name
                                                 if((filelist[0].Status__c == 'Approved')){
                                                         response.status = 'parent file is already approved'; 
                                                         system.debug('-----------------------approved status-------------------'+response);
                                                         return response;
                                                     }
                                                 fileCreate.filerenamed__c = filelist[0].filerenamed__c;
                                                 fileCreate.original_file_name__c = filelist[0].original_file_name__c;
                                                 fileCreate.Name = fileName;
                                                 fileCreate.No_of_the_file__c= 1;
                                                 fileCreate.Setting__c = filelist[0].Setting__c;
                                                 fileCreate.Splitted_Parent_id__c = filelist[0].id;
                                                 fileCreate.Order_Instructions__c = filelist[0].Order_Instructions__c;
                                                 fileCreate.Instruction__c = filelist[0].Instruction__c;
                                                 fileCreate.File_HandOver_Instructions__c = filelist[0].File_HandOver_Instructions__c;
                                                 if(!string.isEmpty(locationName)){
                                                     fileCreate.File_Location__c = locationName;
                                                 }
                                                 if ((!string.isEmpty(totalWorktime))&&(!string.isEmpty(operatorid))){
                                                     string catcode = restobj.getCategoryCode(totalWorktime,operatorid);   
                                                     
                                                     fileCreate.File_Category_Code__c = catcode; //which tells type of File it is 
                                                     fileCreate.Individual_Performance_Category__c   = catcode;
                                                 }
                                                 
                                                 fileCreate.Status__c = fileStatus;
                                                 fileCreate.File_URL__c = fileURL;
                                                 fileCreate.File_Thumbnail_URL__c = fileThumbURL;
                                                 fileCreate.File_Preview_URL__c = filePreviewURL;
                                                 if(!String.isEmpty(filejobtitle)){
                                                     fileCreate.File_Job_Titles__c=filejobtitle;
                                                 }
                                                 if (fileCopyNumber != null) {
                                                     fileCreate.File_Copy_number__c = Decimal.valueOf(fileCopyNumber);
                                                 }
                                                 fileCreate.File_Type__c = fileType;
                                                 fileCreate.Current_Extension__c = currentExtn;
                                                 fileCreate.Delivery_Extension__c = deliveryextension;
                                                 
                                                 if (!orderIdList.isEmpty()) {
                                                     fileCreate.Production_Order__c = orderIdList[0].id;
                                                 }
                                                

                                              Files__c QCComments=[select id,QC_Comments__c,name from Files__c where id=:filelist[0].id];
                                             
                                             if(!string.isEmpty(QCComments.QC_Comments__c)){
                                             fileCreate.QC_Comments__c=QCComments.QC_Comments__c;
                                               }
                                         
                                      system.debug('------------------commentsinfield-----------'+fileCreate.QC_Comments__c);












                                            /*  if(!string.isEmpty(fileQCComments)){
                                                     fileCreate.QC_Comments__c = fileQCComments;
                                                 }*/
                                                 
                                                 
                                                 fileCreate.File_old_Status__c = fileOldStatus;
                                                 if (workStartTime != null) {
                                                     fileCreate.Work_Start_Time__c = Datetime.valueOf(workStartTime); //tracker send when employee started Work on file
                                                 }
                                                 if (workEndTime != null) {
                                                     fileCreate.Work_End_Time__c = Datetime.valueOf(workEndTime); //tracker send when employee ended Work on file
                                                 }
                                                 if(totalWorktime!=null){
                                                     fileCreate.Total_Work_Time__c = Decimal.valueOf(totalWorktime);
                                                 }
                                                 if(totalBreaktime!=null){
                                                     fileCreate.Total_Break_Time__c = Decimal.valueOf(totalBreaktime);
                                                 }
                                                 if(!string.isEmpty(totalBreaks)){
                                                     fileCreate.No_of_Breaks__c = integer.valueOf(totalBreaks);
                                                 } // Updates No of breaks by employee
                                                 fileCreate.Files_To_open__c = integer.valueOf(Filestoopen);
                                                 system.debug('Filestoopen 4 ****          :' + Filestoopen);
                                                 if(!string.isEmpty(operatorid)){
                                                     fileCreate.Member__c=operatorid;
                                                 }
                                                 if(!string.isEmpty(qcinchargeid)){
                                                     fileCreate.QCIncharge__c=qcinchargeid;
                                                 }
                                                 if(!string.isEmpty(tlinchargeid)){
                                                     fileCreate.TLInCharge__c=tlinchargeid;
                                                 }
                                                 
                                                 
                                                 
                                                 insert fileCreate;
                                                 
                                                 system.debug('Insert fileObj 3 : ' + fileStatus + ' ::: ' + fileQCComments+ ' ::: ' + fileCreate);
                                                 
                                                 
                                             }else{
                                                 
                                                 response.status = 'Error'; 
                                                 system.debug('------------------------------------------'+response);
                                                 return response;
                                             }
                                             
                                             if(fileCreate != null && fileStatus == 'Handover'){
                                                 
                                                 
                                                 Files__c onHoldFile = fileCreate.clone(false);
                                                 onHoldFile.Status__c = 'On-Hold';
                                                 onHoldFile.Tracker_handover__c=true;
                                                 system.debug('Test File Creation On-Hold on Splitted Child: ' + onHoldFile);
                                                 insert onHoldFile;
                                                 system.debug('Insert fileObj 2 : ' + fileStatus + ' ::: ' + onHoldFile);
                                                 
                                                 if (!String.isEmpty(totalWorktime)) {
                                                     fileCreate.File_Handover_Time__c = Decimal.valueOf(totalWorktime);
                                                 }
                                                 fileCreate.Work_End_Time__c =null;
                                                 fileCreate.Work_Start_Time__c =null;
                                                 fileCreate.Total_Break_Time__c =null;
                                                 fileCreate.Total_Work_Time__c =null;
                                                 fileCreate.Is_Handover_File__c = 1;
                                                 fileCreate.File_HandOver_Instructions__c = fileHandOverInstructions;
                                                 try{
                                                     update fileCreate;
                                                     system.debug('Update fileObj 4 : ' + fileStatus + ' ::: ' + fileQCComments + ' ::: ' + filejobtitle);
                                                 }catch(exception e){
                                                     system.debug('---------exception-----------'+e);
                                                     response.status = 'Error'; 
                                                 }
                                                 
                                                 
                                             }
                                             
                                             
                                             list < Files__c > parentupdate = new list < Files__c > ();
                                             if (parentId != null && filelist.size()>0) {
                                                 system.debug('-----------------------------'+filelist);
                                                 Files__c FG = new Files__c();
                                                 FG.id = filelist[0].id;
                                                 FG.IsSplitedFile__c = true;
                                                 parentupdate.add(FG);
                                             }
                                             if (parentupdate.size() > 0) {
                                                 try{
                                                 update parentupdate;
                                                 system.debug('Update fileObj 5 : ' + fileStatus + ' ::: ' + fileQCComments + ' ::: ' + filejobtitle);
                                                 }
                                                 catch(exception e){}
                                                 }
                                             
                                             
                                             
                                             
                                             
                                             
                                             
                                             
                                             
                                             
                                             
                                             
                                             
                                             
                                             
                                             if (fileCreate != null) {
                                                 system.debug('------------------created_Split_File-----------'+fileCreate.Name);
                                                 system.debug('------------------commentsinfield-----------'+fileCreate.QC_Comments__c);
                                                  system.debug('------------------commentsinparamaeter-----------'+fileQCComments);
                                                 response.status = 'Success';
                                                 
                                             } else {
                                                 response.status = 'Error';
                                                 
                                             }
                                             
                                         }
                                         
                                         system.debug('------------------final response------------------------'+response);
                                         return response;
                                     }
    
    global class FileWrapper {
        
        public String status;
        
        public FileWrapper() {
            
        }
    }
    
    private String getFormatedQCComments(String qcComments) {
        List<String> qcCommentsList = new list<String>();
        String PIPE_SEPARATOR = '\\|';
        
        if (qcComments != null) {
            qcCommentsList = qcComments.split(PIPE_SEPARATOR);
        }
        
        system.debug('********* & qcCommentsList Size : ' + qcCommentsList.size());
        system.debug('********* & qcCommentsList : ' + qcCommentsList);
        
        if (qcCommentsList != null & qcCommentsList.size() > 2) {
            
            qcComments = qcCommentsList.get(0) + ' - ' + qcCommentsList.get(1) + ' - QC Comments: ' + qcCommentsList.get(2);
            //qcComments = qcCommentsList.get(0) + '<BR>' + qcCommentsList.get(1) + '<BR>Qc Comments:-<BR>' + qcCommentsList.get(2);                    
        } else if (qcCommentsList != null & qcCommentsList.size() == 2) {
            qcComments = qcCommentsList.get(0) + ' - ' + qcCommentsList.get(1);
        } 
        
        system.debug('********* & Formated qcComments : ' + qcComments);
        
        return QCComments;    
    }   
    
    
}