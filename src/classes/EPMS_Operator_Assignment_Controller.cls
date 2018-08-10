/**************************************************************************** 
*   Class               :       File : Operator Assignment                  * 
*                               Controller Class                            *
*   Created Date        :       13/04/2016                                  *           
*   Description         :       Allow Production admin/global admin to      *
*                               Assign the operator to Files                * 
   
/***************************************************************************/
    

public with sharing class EPMS_Operator_Assignment_Controller{
 
    public List<Profile> profilelist {get;set;}
    public string userProfileName {get;set;}
    public String CurrentTeams{get; set;}
    public String selectedTeamlead{get; set;}
    public String selectvalue {get;set;}
    public string selectedShift {get;set;}
    //public string locationId {get;set;}
    public Integer availableteamsize {get;set;}
    //public List<Production_order__c> fileList {get; set;}
    public List<Member__c> listMembers {get;set;}
    //public List<Member__c> memberQclist {get;set;}
    public string productionLocation {get;set;}
    //public string productionLocation2 {get;set;}
    public Set<Id> teamIds {get;set;}
    public Set<Id> directoryIds {get;set;}
    //public Set<Id> relatedFileIds {get;set;}
    public Set<Id> reassignFileIds {get;set;}
    public Set<Id> reassignMemberIds {get;set;}
    public Set<Id> unassignFileIds {get;set;}
    public Set<Id> unassignMemberIds {get;set;}
    public Set<Id> redoReassignFileIds {get;set;}
    public List<String> directoryFileNames {get;set;}
    public List<SelectOption> teamoptions {get;set;}
    //public List<SelectOption> shiftoptions {get;set;}
    public List<Files__c> fileListDisplay {get;set;}
    public boolean setUnAssignMember {get; set;}
    public String userCurrentShift {get;set;}
    public String userCurrentTeam {get;set;}
    public string fileRecord {get; set;}
    public String tlUserId{get;set;}
    public string qcUserId{get;set;}
    public list<Production_Order__c> POListwithTLids=new list<production_Order__c>();
    public string tlstring{get;set;}
    public string qcstring{get;set;}
    public set<production_Order__c> setpolist=new set<production_Order__c>();
    public set<string> posetids=new set<string>();
    public set<String> posetuserids=new set<string>();
    public list<Production_Order__c> prodList{get;set;}
    
    //modified by udayasri based on CR-501
    public String Operator_TL = '';
       public  String Operator_QC = '';
       public set<String> poIds=new set<String>();
       public list<Production_Order__c> poList=new list<Production_Order__c>();
       //public string ParentFile{get;set;}
       //public string copy2TeamId{get;set;}
       public Member__c copy1record=new Member__c();
       public Member__c copy2record=new Member__c();
    
     public string basepath {
         get{
             String basepath = ApexPages.currentPage().getParameters().get('source');
             return basepath;
         }
         set;
    }
    
    public String type {
         get{
             String type = ApexPages.currentPage().getParameters().get('type');

             return type;
         }
         private set;
    }
    public String[] ids {
        get {
            if (ids == null) {
                String s = ApexPages.currentPage().getParameters().get('ids');
                if (s != null) {
                    ids = s.split(',');
                } else {
                    ids = new String[] {};
                }
            }

            return ids;
        }
        private set;
    }
   
    public string getSelectedShift(){
        return this.selectedShift;              
    }
    
    public void setSelectedShift(string selectShift){
        this.selectedShift= selectShift;
    }

   
   
    EPMS_ProductionOrderAssignmentService service = new EPMS_ProductionOrderAssignmentService();
    // Shift Assignment service
    EPMS_Shift_Assignment_Service_New shiftService = new EPMS_Shift_Assignment_Service_New();

    // File Operator Assignment service
    EPMS_FileOperatorAssignmentService fileService = new EPMS_FileOperatorAssignmentService();
    
    public EPMS_Operator_Assignment_Controller(){
        profilelist  = shiftService.getProfiles();
        if(profilelist.size() > 0){
            userProfileName = profilelist[0].Name;
        }
       
        fileListDisplay = new List<Files__c>();
        List<Files__c> fileList = fileService.getFileInformation(ids);

        if(fileList != null && fileList.size() > 0){
            // Copy the selected file List for display
            fileListDisplay = fileList;
            directoryIds = new Set<Id>();
            reassignFileIds = new Set<Id>();
            reassignMemberIds = new Set<Id>(); 
            unassignFileIds = new Set<Id>();
            unassignMemberIds = new Set<Id>();
            redoReassignFileIds = new Set<Id>();
            directoryFileNames = new List<String>();
            for(Files__c file : fileList){
                 
                   poIds.add(file.Production_Order__c);
                   
                if(file.File_Type__c == label.EPMS_File_Type_Directory){
                    
                    directoryIds.add(file.Id);
                    directoryFileNames.add(file.Name); 
                }

                // Re-assignment File : Ids Collected
                
                if(file.File_Type__c == label.EPMS_File_Type_Image && type == 'assign' && file.Status__c == label.EPMS_FileStatus_Assigned){
                    reassignFileIds.add(file.Id);
                    reassignMemberIds.add(file.Member__c);
                    

                }
                
                if(file.Member__c != null && file.File_Type__c == label.EPMS_File_Type_Image && type == 'unassign'){
                    unassignFileIds.add(file.Id);
                    unassignMemberIds.add(file.Member__c);
                    
                }
                
                if(file.Member__c != null && file.File_Type__c == label.EPMS_File_Type_Image && type == 'reassign' && file.Status__c == label.EPMS_FileStatus_Redo){
                    redoReassignFileIds.add(file.Id);
                   

                }
                
     
            }
            
            //To get all the PO's related to the files which are selected ---->modified by udayasri for CR-501
            
            poList=fileService.getpoRecords(poIds);
            
            
           
            selectvalue = fileList[0].File_Location__c;


            productionLocation = fileList[0].File_Location__r.Name;
            setUnAssignMember = false;


            if(userProfileName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && userProfileName != EPMS_UTIL.EPMS_PROD_ADMIN_PROFILE_NAME && userProfileName != 'Country Administrator'){

                Member__c userMemberInfo = fileService.getLoggedMemberInformation();

                if(userMemberInfo != null){

                    Shift_Assignments__c shiftInfo = fileService.getLoggedMemberShiftAssignmentInformation(userMemberInfo.Id);
                    if(shiftInfo != null){
                        userCurrentShift = shiftInfo.Shift_Code__c;
                        userCurrentTeam = userMemberInfo.Team_Id__c;

                    }
                }
            }
            
            if(userCurrentShift != null){
                selectedShift = userCurrentShift;
            }
            
            if(userCurrentTeam != null){
                CurrentTeams = userCurrentTeam;
            }
            
        }
        
        if(ids != null && ids.size() > 0){
               fileRecord = ids[0];
           }

    }

    public List<Files__c> getFilesInfoForDisplay(){
        return fileListDisplay;
    }


     // Selection for list of shift associated with location    
    public List<selectoption> getShifts(){

        List<SelectOption> options = new List<SelectOption>();
        List<Shift__c> Shiftdetails= new List<Shift__c>();
        options.add(new SelectOption('','--None--'));
       
        // Retrieve the shift list from service
        if(userProfileName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && userProfileName != 'Country Administrator'){

           Shiftdetails= shiftService.getAllShiftListForSelectedLocation(selectvalue);

        } else{
           Shiftdetails= shiftService.getAllShiftListForSelectedLocation(selectvalue);

        }
        if(Shiftdetails != null){
            for(Shift__c shift: Shiftdetails){
                options.add(new SelectOption(shift.Id,shift.Name));

            }
        }
       
     
            
        return options;

    }
    
    
    public List<selectoption> getTeams(){
          
        List<SelectOption> options = new List<SelectOption>();
        teamoptions = new List<SelectOption>();
       
        // Retrieve the team list from service
        List<Team__c> Teamdetails = null;
        

        Set<Id> teamIdSet = new Set<Id>();
        teamIdSet = getAssignmentDetails();

        if(teamIdSet != null && teamIdSet.size() >0){
            Teamdetails = fileService.getTeamDetails(teamIdSet);
        }
        

        teamoptions.add(new SelectOption('','--None--'));
        if(selectedShift == null){
            return teamoptions;
        }
        if(Teamdetails != null){
            for(Team__c team: Teamdetails){
                teamoptions.add(new SelectOption(team.Id,team.Name));
            }
        } 
       
       
        return teamoptions;
    }
    
    public Set<Id> getAssignmentDetails(){

        listMembers = fileService.getOperatorsAssignedInShift(selectedShift);

        if(listMembers == null || listMembers.size() == 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_FILE_ASSIGN_NO_OPERATORS_IN_SHIFT));
            return null;
        }
        teamIds = new Set<Id>();
        // Call the service

        if(selectvalue != null){
            teamIds = fileService.getOperatorsAssignedInTeam(selectvalue,selectedShift);
        }
        
        availableteamsize = teamIds.size();
        return teamIds;    
    }
    
    
    
    public List<selectoption> getAvailableTeamLeaders(){
       
        List<SelectOption> options = new List<SelectOption>();

        List<Member__c> memberlist = new List<Member__c>();
        options.add(new SelectOption('','--None--'));
        // Call the service

            memberlist = fileService.getAvailableOperatorToday(CurrentTeams,selectedShift);
            
            if(memberlist != null){
                 for(Member__c member: memberlist){
                 if(member.Performance_Rating__r.Name ==null){
                 
                                     options.add(new SelectOption(member.Id, member.Emp_ID__c + '-' + member.Name + '-' + member.Designation__c));
                 }
                 else{
                    options.add(new SelectOption(member.Id, member.Emp_ID__c + '-' + member.Name + '-'+ member.Performance_Rating__r.Name + '-' + member.Designation__c));
                }
                }
            }

        return options;
    }
    
    
    public Pagereference assign_save(){        
    // Method to handle the team lead assignments 
        
        List<Member__c> selectedTeam = new List<Member__c>();
        
        system.debug('********* selectedTeamlead : ' + selectedTeamlead);
        
        // EPMSSF-501 Changes
        // Fetch selected member's TL & QC 
        if (selectedTeamlead != null) {
            Member__c member = [select id, name, Team_Id__c from Member__c where Id =: selectedTeamlead];
            if (member != null) {
                selectedTeam = [select id, name, Team_Id__c,User_Id__c, Designation__c from Member__c where Team_Id__c =: member.Team_Id__c and Designation__c IN('Team Leader','Quality Control') and Status__c = 'Active'];
                system.debug('********* selectedTeam : ' + selectedTeam);
                for (Member__c mem : selectedTeam) {
                    if (mem.Designation__c == 'Team Leader') {
                        Operator_TL = mem.Id;
                        tlUserId=mem.User_Id__c;
                    } else if (mem.Designation__c == 'Quality Control') {
                        Operator_QC = mem.Id;
                        qcUserId=mem.User_Id__c;
                    }
                }
            }
        }
        
        
        
        
        
        if(selectedShift == null && !setUnAssignMember){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_SELECT_SHIFT));
            return null;
        }
       
        if(selectedTeamlead == null && !setUnAssignMember){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_FILE_ASSIGN_PLEASE_SELECT_OPERATORS));
          return null;
        } 
        
        if(selectedTeamlead != null && setUnAssignMember && type == 'unassign'){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.EPMS_MemUnAssignment_ErrorMsg));
          return null;
        } 
        
        if(reassignMemberIds != null && reassignMemberIds.size() > 0){
            if(reassignMemberIds.contains(selectedTeamlead)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_FILE_ASSIGN_ALREADY_OPERATOR_ASSIGNED_TO_FILE));
                return null;
            }
        }
       
      // Get the performance rating of the selected member
        
        Member__c selecteOperatorInfo = null;
        Shift__c shiftInfo = null;
        if(selectedTeamlead != null){
            selecteOperatorInfo = fileService.getPerformanceRatingMemberInformation(selectedTeamlead);
            shiftInfo = shiftService.getShiftInfo(selectedShift);
            if(selecteOperatorInfo != null){
                if(selecteOperatorInfo.Performance_Rating__c == null){
                    // Send Error Message and Chatter Notification to Pro Admin and shift Admin
                    Map<String, Object> params = new Map<String, Object>();
                    Id orderlocation = selectvalue;                   
                    String filesNames = '';
                    // Adding Order Names into flow parameters
                    params.put('prodOrderName', selecteOperatorInfo.Name);
                    // Adding Location into flow parameters
                    params.put('CreatedProdID', orderlocation);
                    
                    // Adding Chatter Notification into flow parameters
                    if(shiftInfo != null){
                        params.put('selectedShift', shiftInfo.Name);
                    }
                    
                    // Call the Flow
                    
                    //Flow.Interview.TL_QC_LookUp chatterFlow = new Flow.Interview.TL_QC_LookUp(params);
                    Flow.Interview.Rating_Notification_To_Shift_And_Production_Admin chatterFlow = new Flow.Interview.Rating_Notification_To_Shift_And_Production_Admin(params);
                    chatterFlow.start();
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected Operator doesn\'t have a Rating. Kindly Check the Member Information'));
                    return null;
                }
            
            }
        }
        
        
        List<Files__c> unAssignfilesDetList = null; 
        List<Files__c> updateUnAssignFileRecord = new List<Files__c>();
        
        // Functionality - Un-Assignment / Re-Assignment for Operator
        
        if(unassignMemberIds != null && unassignMemberIds.size() > 0){
            unAssignfilesDetList = fileService.getFilesLists(unassignFileIds);
            if(selectedTeamlead != null){
                if(unassignMemberIds.contains(selectedTeamlead)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_FILE_ASSIGN_ALREADY_OPERATOR_ASSIGNED_TO_FILE));
                    return null;
                } else {
                    if(unAssignfilesDetList != null && unAssignfilesDetList.size() > 0){
                        for(Files__c updateValue : unAssignfilesDetList){
                            system.debug('Re-Assigned File *** : ' + updateValue.Files_To_open__c);
                            system.debug('Re-Assigned Scenario : ' + updateValue);
                             if(updateValue.status__c=='Assigned'){  
                                if(updateValue.Files_To_open__c != 1){
                                    updateValue.Files_To_open__c = 0;
                                    updateValue.Member__c = selectedTeamlead;
                                    try{
                                     updateValue.TLInCharge__c = Operator_TL;
                                     
                             if((updateValue.File_Copy_number__c!=null && updateValue.File_Copy_number__c!=0) || (updateValue.IsSplitedFile__c == True ||   updateValue.Splitted_Parent_id__c!=null)){
            
                                //tbd
                                 system.debug('----updateValue.File_Copy_number__c---'+updateValue.File_Copy_number__c);
                
                                    }else{
                                    
                                    system.debug('----handover10---'+updateValue.File_Copy_number__c);
                                      updateValue.QCIncharge__c = Operator_QC;
                                    
                                    }
                                     
                                     
                                  
                                    
                                     }catch(Exception e){
                        
                                }
                                    
                                    
                                    updateValue.File_Assignment_Time__c = system.now();
                                    
                                    updateUnAssignFileRecord.add(updateValue);
                                    //update updateUnAssignFileRecord;
                                    //updateTLandQC();
                                    system.debug('Re-Assigned Scenario UPDT : ' +updateUnAssignFileRecord);
                                    
                                }else{
                                  //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Photo Artist Already Openend the File in Photoshop.'));
                                  //return null;
                                }
                                
                            }
                        } 
                    } 
                }
            } else {
                    if(unAssignfilesDetList != null && unAssignfilesDetList.size() > 0){
                        for(Files__c updateValue : unAssignfilesDetList){
                        
                            if(updateValue.status__c=='Assigned'){  
                                if(updateValue.Files_To_open__c!=1){
                                    updateValue.Member__c = null;
                                    updateValue.Files_To_open__c = 0;
                                    updateValue.Status__c = label.EPMS_FileStatus_New;
                                    updateValue.File_Assignment_Time__c = system.now();
                                    updateUnAssignFileRecord.add(updateValue);
                                    system.debug('UN-Assigned Scenario UPDT : ' +updateUnAssignFileRecord);
                                }else{
                                  //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Photo Artist Already Openend the File in Photoshop.'));
                                  //return null;
                                }
                            }
                        }
                    }       
                }
            }
            
        
        system.debug('-- Un-Assign Record : ' + updateUnAssignFileRecord);
        
        if(updateUnAssignFileRecord.size() > 0){
               try {
                system.debug('update fileObj 1 : *********** updateUnAssignFileRecord : ' + updateUnAssignFileRecord);
                   update updateUnAssignFileRecord;
                   updateTLandQC();
                   
                   if(selectedTeamlead == null){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,label.EPMS_MemAssignment_Success)); 
                   } else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,label.EPMS_MemUnAssignment_Success));    
                   }
                   
                   selectedTeamlead = null;
                   CurrentTeams = null;
                   selectedShift = null;
                   setUnAssignMember = false;
               } catch(DMLException me) {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                   return null;
               }
               return null;
        } 
        
        if(updateUnAssignFileRecord.size() == 0 && unassignFileIds.size() > 0){
            system.debug('-- Re-Assign Scenario : All Files are opened ' + updateUnAssignFileRecord);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Selected file(s) are already opened in Photoshop'));
            return null;
        }
        
        // Functionality - Redo - Re-Assignment for Operator
        
        
        
        
        List<Files__c> redofilesList = null;
        if(redoReassignFileIds != null && redoReassignFileIds.size() > 0){
            List<Files__c> insertRedoFileRecords = new List<Files__c>();
            List<Files__c> updateRedoFileRecords = new List<Files__c>();
            redofilesList = fileService.getFilesLists(redoReassignFileIds);
            if(redofilesList != null && redofilesList.size() > 0){
                system.debug('*********** redofilesList : ' + redofilesList);
                
                for(Files__c insertRedoValue : redofilesList){
                    Files__c newRedoFile = new Files__c();
                    newRedoFile = insertRedoValue.clone(false);
                    newRedoFile.Name = insertRedoValue.Name; //+ '_copy'
                    newRedoFile.File_Job_Titles__c=insertRedoValue.File_Job_Titles__c;
                    newRedoFile.Status__c = label.EPMS_FileStatus_Assigned;
                    newRedoFile.setting__c = insertRedoValue.setting__c;
                    newRedoFile.No_of_the_file__c=1;
                    //EPMSSF-522 Changes - When copying new files, comments are removed
                    //newRedoFile.QC_Comments__c = '';
                    newRedoFile.QC_Comments__c = insertRedoValue.QC_Comments__c;
                    if(selectedTeamlead == insertRedoValue.Member__c){
                        newRedoFile.File_Category_Code__c = insertRedoValue.File_Category_Code__c;
                        newRedoFile.Total_Work_Time__c = insertRedoValue.Total_Work_Time__c;
                        newRedoFile.Total_Break_Time__c = insertRedoValue.Total_Break_Time__c;
                        newRedoFile.Redo_Checked_Same_Member__c = true;
                        // Update Order Files - Status to Redo Re-Assigned      
                        insertRedoValue.Status__c = 'On-Hold';
                    } else {
                        // Update Order Files - Status to Redo Re-Assigned
                        insertRedoValue.Status__c = label.EPMS_FileStatus_Redo_Re_Assigned;
                    }
                    newRedoFile.Member__c = selectedTeamlead;
                    newRedoFile.Files_To_open__c = 0;
                    newRedoFile.File_Copy_number__c = insertRedoValue.File_Copy_number__c;
                    
                    // EPMSSF-501 Changes
                    try{
                    newRedoFile.TLInCharge__c = Operator_TL;
                         if((newRedoFile.File_Copy_number__c!=null && newRedoFile.File_Copy_number__c!=0)||(newRedoFile.IsSplitedFile__c== True || newRedoFile.Splitted_Parent_id__c!=null)){
            
                                //tbd
                                system.debug('---------------redo assigned file--------------------');
                
                                    }else{
                                    
                                    system.debug('----handover10---');
                                      newRedoFile.QCIncharge__c = Operator_QC;
                                    
                                    }
                    
                     }catch(Exception e){
                        
                    }
                    
                    insertRedoFileRecords.add(newRedoFile);
                    // Update Order Files - Status to Redo Re-Assigned      
                    //insertRedoValue.Status__c = label.EPMS_FileStatus_Redo_Re_Assigned;     
                    updateRedoFileRecords.add(insertRedoValue);

                }
            }

            if(insertRedoFileRecords.size() > 0){
                try {
                    system.debug('Insert fileObj 1 : *********** insertRedoFileRecords : ' + insertRedoFileRecords);
                   insert insertRedoFileRecords;
                   updateTLandQC();
                   selectedTeamlead = null;
                   CurrentTeams = null;
                   selectedShift = null;
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_FILE_ASSIGN_FILE_REDO_RE_ASSIGNED_TO_OPERATOR));  
               } catch(DMLException me) {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                   return null;
               }               
            }
            // Change Parent File Status to Redo Re-Assigned        
            if(updateRedoFileRecords.size() > 0){       
                try {
                    system.debug('update fileObj 2 : *********** updateRedoFileRecords : ' + updateRedoFileRecords);       
                    update updateRedoFileRecords;    
system.debug('-----updateRedoFileRecords----'+updateRedoFileRecords);
                    
                } catch(DMLException me) {      
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));       
                   return null;     
                }       
            }       

            return null;
        }
        List<Files__c> filesList = null;
        List<Files__c> directoryFilesList = null;
        List<Files__c> reAssignfilesDetList = null; 
        Integer fileCopyCount  = 0;   
        if(reassignFileIds != null && reassignFileIds.size() > 0){
            List<Files__c> insertFileRecords = new List<Files__c>();
            List<Files__c> updateParentFileRecords = new List<Files__c>();
            reAssignfilesDetList = fileService.getFilesLists(reassignFileIds);
            
            if(reAssignfilesDetList != null && reAssignfilesDetList.size() > 0){
                for(Files__c insertValue : reAssignfilesDetList){
                
                    if(insertValue.status__c=='Assigned'){  
                       
                        if(insertValue.Files_To_open__c!=1){
                            Files__c newFile = new Files__c();
                            Files__c newFile2 = new Files__c();
                            fileCopyCount = fileService.getFilesCopyCountInFileAssignment(insertValue.Id,insertValue.Name,insertValue.Current_Extension__c);
                            newFile = insertValue.clone(false);
                            fileCopyCount++;
                            if(fileCopyCount == 1){
                                // Creating Copy Files
                                String fileWithExtn = insertValue.Name;
                                String[] splitedFiles = new String[]{};
                                String extn = null;
                                String fileWithoutExtn = null;
                                if(fileWithExtn != null){
                                    splitedFiles = fileWithExtn.split(insertValue.Current_Extension__c);
                                    if(splitedFiles!=null){
                                        fileWithoutExtn = splitedFiles[0];
                                       // extn = splitedFiles[1];
                                       extn= insertValue.Current_Extension__c;
                                    }
                                    
                                }
                                if(fileWithoutExtn != null && extn != null){
                                    newFile.Name = fileWithoutExtn + '_copy'+fileCopyCount+extn;
                                }
                                //newFile.Name = insertValue.Name + '_copy'+fileCopyCount;
                                newFile.Parent_Id__c = insertValue.Id;
                                newFile.File_Copy_number__c = fileCopyCount;
                                
                                
                                
                                fileCopyCount++;
                                newFile2 = insertValue.clone(false);
                                if(fileWithoutExtn != null && extn != null){
                                    newFile2.Name = fileWithoutExtn + '_copy'+fileCopyCount+extn;
                                }
                                //newFile2.Name = insertValue.Name + '_copy'+fileCopyCount;
                                newFile2.Member__c = selectedTeamlead;
                                try{
                                newFile2.TLInCharge__c = Operator_TL;
                                newFile2.QCIncharge__c = insertValue.QCIncharge__c;
                                }catch(Exception e){
                        
                    }
                                newFile2.Parent_Id__c = insertValue.Id;
                                newFile2.File_Copy_number__c = fileCopyCount;
                                insertFileRecords.add(newFile);
                                insertFileRecords.add(newFile2);
                                // To update the member in parent file of the copy files
                                //insertValue.Member__c = null;
                                if(CurrentTeams != null){
                                    //Member__c qcmemberInSelectedTeam = [SELECT Id, Name, First_Name__c, Last_Name__c FROM Member__c WHERE Team_Id__c =: CurrentTeams AND Status__c = 'Active' AND Designation__c = 'Quality Control' LIMIT 1]; 
                                    Member__c qcmemberInSelectedTeam = fileService.getMemberQualityControlInSelectedTeam(CurrentTeams);
                                    /*if(qcmemberInSelectedTeam != null){
                                        insertValue.Member__c = qcmemberInSelectedTeam.Id;
                                    } else {
                                        insertValue.Member__c = insertValue.QCIncharge__c;
                                    }*/
                                    insertValue.Member__c = insertValue.QCIncharge__c;
                                } else if(insertValue.QCIncharge__c != null){
                                    insertValue.Member__c = insertValue.QCIncharge__c;
                                } else {
                                    insertValue.Member__c = null;
                                }
                                insertValue.Status__c = 'Assigned';
                                updateParentFileRecords.add(insertValue);
                            } else {                    
                                String fileWithExtn = insertValue.Name;
                                String[] splitedFiles = new String[]{};
                                String extn = null;
                                String fileWithoutExtn = null;

                                if(fileWithExtn != null){
                                    splitedFiles = fileWithExtn.split(insertValue.current_extension__c);
                                    if(splitedFiles != null){
                                        fileWithoutExtn = splitedFiles[0];
                                        extn= insertValue.Current_Extension__c;
                                    }
                                                           
                                    
                                }
                                if(fileWithoutExtn != null && extn != null){
                                    newFile.Name = fileWithoutExtn + '_copy'+fileCopyCount+extn;
                                }               
                                // Copy Files more than 2 files
                                newFile.Member__c = selectedTeamlead;
                                try{
                                newFile.TLInCharge__c = Operator_TL;
                                
                                
                   
                                
                                
                                
                                
                                
                               
                                 }catch(Exception e){
                        
                                 }
                                newFile.File_Copy_number__c = fileCopyCount;
                                newFile.Parent_Id__c = insertValue.Id;
                                //newFile.QC_Comments__c = insertValue.QC_Comments__c; 
                                
                                 if((newFile.File_Copy_number__c!=null && newFile.File_Copy_number__c!=0) || (newFile.IsSplitedFile__c== True || newFile.Splitted_Parent_id__c!=null)){
            
                                //tbd
                
                                    }else{
                
                                    system.debug('----handover10---');
                            newFile.QCIncharge__c = Operator_QC;
                
                                }   
                                
                                insertFileRecords.add(newFile);
                                
                                // updateTLandQC();
                            }
                        }else{
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Photo Artist Already Openend the File in Photoshop. Unable to create copy files. '));
                            return null;
                        }
                    }
                }
            } 

            // Update the parent files 
            if(updateParentFileRecords.size() > 0){
                try {
                    system.debug('update fileObj 3 : *********** updateParentFileRecords : ' + updateParentFileRecords);
                   update updateParentFileRecords;
               } catch(DMLException me) {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                   return null;
               }    
            }


            if(insertFileRecords.size() > 0){
               try {
                system.debug('Insert fileObj 2 : *********** insertFileRecords : ' + insertFileRecords);
                
                   insert insertFileRecords;
                   updateTLandQC();
                   selectedTeamlead = null;
                   CurrentTeams = null;
                   selectedShift = null;
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_FILE_ASSIGN_FILE_RE_ASSIGNED_TO_OPERATOR));  
               } catch(DMLException me) {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                   return null;
               }
           }
           return null;
        }
        
        // If type of assignment is directory - check the related files are exists
        if(directoryIds != null && directoryIds.size() > 0){
            // Retrieve the files inside the directory
            filesList = fileService.getRelatedFilesInsideSelectedDirectory(directoryIds);
            // Retrieve the directory type files for status update
            directoryFilesList = fileService.getDirectoryTypeFiles(directoryIds);
            if(filesList == null || filesList.size() == 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_FILE_ASSGN_NO_FILES_IN_DIRECTORY+directoryFileNames));
                return null;
            }
            List<Files__c> updateRelatedFileRecord = new List<Files__c>();
            if(directoryFilesList != null && directoryFilesList.size() > 0){
                for(Files__c updateValue : directoryFilesList){
                    updateValue.File_Assignment_Time__c = system.now();
                    system.debug('----handover4---');
                    
                    if(updateValue.Status__c == label.EPMS_FileStatus_New || updateValue.Status__c == label.EPMS_FileStatus_Handover){
                        updateValue.Status__c = label.EPMS_FileStatus_Assigned;
                        system.debug('----handover1---');
                    }
                    updateRelatedFileRecord.add(updateValue);
                    
                    
                }  
            }
            if(filesList != null && filesList.size() > 0){
                for(Files__c updateValue : filesList){
                    updateValue.Member__c = selectedTeamlead;
                    try{
                    updateValue.TLInCharge__c = Operator_TL;
                    system.debug('----handover5---');
                    
                    if((updateValue.File_Copy_number__c!=null && updateValue.File_Copy_number__c!=0) || (updateValue.IsSplitedFile__c== True || updateValue.Splitted_Parent_id__c!=null)){
            
                //tbd
                
                }else{
                
                system.debug('----handover10---');
                 updateValue.QCIncharge__c = Operator_QC;
                
                }
                    
       
                     }catch(Exception e){
                        
                    }
                    updateValue.File_Assignment_Time__c = system.now();
                    system.debug('----handover6---');
                    if(updateValue.Status__c == label.EPMS_FileStatus_New || updateValue.Status__c == label.EPMS_FileStatus_Handover){
                    system.debug('----handover2---');
                        updateValue.Status__c = label.EPMS_FileStatus_Assigned;
                    }
                    updateRelatedFileRecord.add(updateValue);
                    
                }            
            }
            if(updateRelatedFileRecord.size() > 0){
               try {
                system.debug('update fileObj 4 : *********** updateRelatedFileRecord : ' + updateRelatedFileRecord);
                   update updateRelatedFileRecord;
                  updateTLandQC();
                   
                   selectedTeamlead = null;
                   CurrentTeams = null;
                   selectedShift = null;
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_FILE_ASSIGN_OPERATOR_ASSIGNED_TO_ALL_FILES_INSIDE_DIR));  
               } catch(DMLException me) {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                   return null;
               }
           }
           
           return null;
        }
        

        

        List<Files__c> updateFileList = fileService.getUpdateFileInformation(ids);
        
        if(updateFileList != null && updateFileList.size() > 0){
        system.debug('---------------------'+updateFileList);
           List<Files__c> updateRecord = new List<Files__c>();
           
    
           for(Files__c newvalue : updateFileList){
                
                newvalue.Member__c = selectedTeamlead;
                try{
                newvalue.TLInCharge__c=Operator_TL;
                
                
                
                system.debug('---newvalue.Status__c---'+newvalue.Status__c);
                system.debug('---newvalue.File_Copy_number__c---'+newvalue.File_Copy_number__c);
                system.debug('----filename----'+newvalue.name);
                
                
                system.debug('----newvalue.File_Copy_number__c---'+newvalue.File_Copy_number__c);
                if((newvalue.File_Copy_number__c!=0 && newvalue.File_Copy_number__c!=null) || (newvalue.IsSplitedFile__c== True || newvalue.Splitted_Parent_id__c!=null)){
            
                //tbd  
                system.debug('----newvalue.File_Copy_number__c---'+newvalue.File_Copy_number__c);
                
                }else{
                
                system.debug('----handover10---');
                newvalue.QCInCharge__c=Operator_QC;
                
                }
                 }catch(Exception e){
                        
                    }
                newvalue.File_Assignment_Time__c = system.now();

                if(newvalue.Status__c == label.EPMS_FileStatus_Redo){
                    newvalue.Status__c = label.EPMS_FileStatus_Redo_Re_Assigned;
                }
                system.debug('----handover8---');
                if(newvalue.Status__c == label.EPMS_FileStatus_New || newvalue.Status__c == label.EPMS_FileStatus_Handover){
                system.debug('----handover9---');
                    newvalue.Status__c = label.EPMS_FileStatus_Assigned;
                }
                
                //Update the team leader in production order
                updateRecord.add(newvalue);
               
           }

           if(updateRecord.size() > 0){
               try {
                system.debug('update fileObj 5 : *********** updateRecord : ' + updateRecord);
                   update updateRecord;
                   updateTLandQC();
                   selectedTeamlead = null;
                   CurrentTeams = null;
                   selectedShift = null;
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_FILE_ASSIGN_OPERATOR_IS_ASSIGNED_TO_FILES));  
               } catch(DMLException me) {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                   return null;
               }
           }
            
         }
       
        return null;
    }

    public Pagereference Cancel(){
        return null;
    }
    
   public void updateTLandQC(){
    
    prodList=new list<Production_Order__c>();
    
    system.debug('-----tluserid----'+TLUserId);
    system.debug('-----QCUserId----'+QCUserId);
     
    for(Production_Order__c poRecord:poList){
    
    if(TLUserId!=null){
    if(poRecord.TLQCusers__c!=null) {
                
                if (!getPOIdsSize(poRecord.TLQCusers__c)) {        
                    if(!(poRecord.TLQCusers__c.contains(TLUserId))) {
                        poRecord.TLQCusers__c +=','+TLUserId;
                    }
                } else {                
                    if( poRecord.TLQCusers1__c!=null && (!(poRecord.TLQCusers__c.contains(TLUserId))) && (!(poRecord.TLQCusers1__c.contains(TLUserId)))) {              
                        if ((!getPOIdsSize(poRecord.TLQCusers1__c))) {
                            poRecord.TLQCusers1__c +=','+TLUserId;                          
                        }
                    }
                    else if(!(poRecord.TLQCusers__c.contains(TLUserId)))
                    {
                    poRecord.TLQCusers1__c=TLUserId;
                    
                    }
                }   
            }               
                else {
                        poRecord.TLQCusers__c=TLUserId;
                    }
                    }
                    
                    
              if(QCUserId!=null){
             if(poRecord.qcId__c!=null) {
                
                if (!getPOIdsSize(poRecord.qcid__c)) {        
                    if(!(poRecord.qcid__c.contains(QCUserId))) {
                        poRecord.qcid__c +=','+QCUserId;
                    }
                } else {                
                    if(poRecord.qcId1__c!=null && (!getPOIdsSize(poRecord.qcid__c)) && (!getPOIdsSize(poRecord.qcid1__c))) {              
                        if (!getPOIdsSize(poRecord.qcId1__c)) {
                            poRecord.qcId1__c +=','+QCUserId;                          
                        }
                    }
                    else if(!getPOIdsSize(poRecord.qcid__c))
                    {
                     poRecord.qcId1__c=QCUserId;
                    
                    }
                }   
              }             
                else {
                        poRecord.qcId__c=QCUserId;
                    }
                    

             if(posetuserids.add(poRecord.id)){
        prodList.add(poRecord); 
        }
        
}       
       }
       
    update prodList;
    
    
    

        
        POListwithTLids=([select Name,id,TLuseridR1__c,TLuseridR2__c,QCidr1__c,QCidr2__c,(select id,TLInCharge__r.User_Id__c,QCInCharge__r.User_Id__c from files__r where Status__c!='On-Hold' AND Status__c!='Approved') from production_Order__c where id=:poIds]);
        system.debug('----POListwithTLids----'+POListwithTLids);
 

        for(production_Order__c po:POListwithTLids){
        po.TLuseridR1__c ='';
        po.TLuseridR1__c='';
        po.QCidr1__c='';
        po.QCidr2__c='';
        
        for(Files__c file:po.files__r){
        
         if(file.TLInCharge__r.User_Id__c !=null){
        if(po.TLuseridR1__c == null || po.TLuseridR1__c == ''){
        
        po.TLuseridR1__c=file.TLInCharge__r.User_Id__c;
        }
        else{
                                     tlstring=po.TLuseridR1__c;
                                     
                                     if(tlstring.length()<236){
                                     if(!(tlstring.contains(file.TLInCharge__r.User_Id__c))) {
                                     po.TLuseridR1__c += ','+file.TLInCharge__r.User_Id__c;
                                     }
                                     }
                                     
                                     
                                      else if(po.TLuseridR2__c == null){
                                       if(!(tlstring.contains(file.TLInCharge__r.User_Id__c))) {
                                po.TLuseridR2__c = file.TLInCharge__r.User_Id__c;
                                }
                                     }else{
                                     tlstring +=','+po.TLuseridR2__c;
                                     if(tlstring.length()>236){
                                     if(!(tlstring.contains(file.TLInCharge__r.User_Id__c))) {
                                     po.TLuseridR2__c += ','+file.TLInCharge__r.User_Id__c;
                                     }
                                     
                                     
                            }
                            }
                         
                         }
        
        
        
        }
        
        
          if(file.QCInCharge__r.User_Id__c !=null){
        if(po.QCidr1__c==null || po.QCidr1__c==''){
       
        po.QCidr1__c=file.QCInCharge__r.User_Id__c;
        }
        else{
                                     qcstring=po.QCidr1__c;
                                     
                                     if(qcstring.length()<236){
                                     if(!(qcstring.contains(file.QCInCharge__r.User_Id__c))) {
                                     po.QCidr1__c += ','+file.QCInCharge__r.User_Id__c;
                                     }
                                     }
                                     
                                     
                                      else if(po.QCidr2__c == null){
                                       if(!(qcstring.contains(file.QCInCharge__r.User_Id__c))) {
                                po.QCidr2__c = file.QCInCharge__r.User_Id__c;
                                }
                                     }else{
                                     qcstring +=','+po.QCidr2__c;
                                     if(qcstring.length()>236){
                                     if(!(qcstring.contains(file.QCInCharge__r.User_Id__c))) {
                                     po.QCidr2__c += ','+file.QCInCharge__r.User_Id__c;
                                     }
                                     
                                     
                            }
                            }
                         
                         }
        
        
        
        }
        
        
        }
        
        if(posetids.add(po.id)){
        setpolist.add(po);
        }
        }
        
        if(!setpolist.isEmpty()){

        List<production_Order__c> prodOrderList = new List<production_Order__c>(setpolist);
        update prodOrderList;
        }
    
    
    
    
    }
     
     
    
    // return true when no of PO ids reached 13 else return false
    public boolean getPOIdsSize(String poids) {
        boolean exceedLimit = false;
        String[] arrPOIds = poids.split(',');
        
        if (arrPOIds.size() > 12) {
            exceedLimit = true;
        }
    
        return exceedLimit; 
    }
    
    public void ShowPanel(){
        String clearVal = apexpages.currentpage().getparameters().get('clearVal');
        if(clearVal == 'shift'){            
            selectedTeamlead = null;
            CurrentTeams = null;
        }
        if(clearVal == 'team'){
           getAvailableTeamLeaders();           
        }            
    } 
   
}