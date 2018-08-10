/****************************************************************************
*   Class               :       Operator File Assignment Query Locator      * 
*   Created Date        :       15/12/2015                                  *           
*   Description         :       To return the requested Result              * 
*                               based on the request by service class       *
*                               will be used as the Common Class            *
*   Created By          :                                                   *                        
*   Version             :       1.0                                         *            
/***************************************************************************/

public class EPMS_File_Assignment_Order_Query_Locator{
    
    public List<Member__c> assignedOperators = null;
    public List<Member__c> availableOperatorsToday = null;
    public List<Member__c> assignedOperatorsInShift = null;
    public List<Member__c> assignedOperatorsInTeam = null;
    public List<Team__c> teamdetails = null;
    public Set<Id> teamIds = null;
    public List<Shift_Assignments__c> availableOperatorsInTeamToday = null;
    public List<Files__c> fileList = null;
    public List<Files__c> fileDetailsList = null;
    public List<Files__c> fileNameCopyList  = null;
    public List<Files__c> fileInformation = null;
    public List<Files__c> updateFileInformation = null;
    public List<Files__c> directoryTypefilesList = null;
    public List<Member__c> availableEstimator = null;
    public List<Production_Order__c> poList = null;
    public List<Production_Order__c> poRecords=null;
    
    public List<Files__c> getUpdateFileInformation(String[] ids){
        updateFileInformation = [SELECT Id, Name,File_Auto_Number__c,IsSplitedFile__c,Splitted_Parent_id__c,File_Copy_number__c, Status__c, File_Location__c, Member__c, File_Assignment_Time__c, File_Location__r.Name FROM Files__c WHERE Id IN :ids]; 
        return updateFileInformation;
    }
    
    public List<Files__c> getFileInformation(String[] ids){
        if(ids != null && ids.size() > 0){
            fileInformation = [SELECT Id, Name,File_Auto_Number__c, File_Location__c, File_Location__r.Name, File_Type__c, Status__c, Member__c,Production_Order__c,Production_Order_Name__c FROM Files__c WHERE Id IN :ids];
        }
        return fileInformation;
    }
    
    public String getFileLocationName(Id locationId){
        String locationName = null;        
        List<Location__c> location = [SELECT Id, Name FROM Location__c WHERE Id =: locationId AND Location_Status__c = 'Active' LIMIT 1];
        if(location != null && location.size() > 0){
            return location[0].Name;
        }
        return locationName;
    }
    public List<Member__c> getOperatorsAssignedInShift(String shiftId){
        String today = Date.today().format();
        Date fromdt = null;
        if(String.isNotEmpty(today)){
            fromdt = Date.parse(today);
        }
        assignedOperatorsInShift = [SELECT Id, Name, Designation__c, Emp_ID__c, Team_Id__c FROM Member__c WHERE Status__c ='Active' AND Id IN (select Member__c from Shift_Assignments__c where Shift_Code__c =: shiftId  AND Shift_Assigned__c = true AND ToTime__c = null AND Designation__c != 'File Manager' AND Designation__c != 'Sales Region' AND Designation__c != 'Production Administrator')];      
        return assignedOperatorsInShift;    
    }
    
    public Set<Id> getOperatorsAssignedInTeam(String locationId, String shiftId){
        String today = Date.today().format();
        Date fromdt = null;
        teamIds = new Set<Id>();
        if(String.isNotEmpty(today)){
            fromdt = Date.parse(today);
        }
        
        assignedOperatorsInTeam = [SELECT Id, Name, Designation__c, Emp_ID__c, Team_Id__c FROM Member__c WHERE Status__c ='Active' AND Designation__c != 'File Manager' AND Designation__c != 'Sales Region' AND Designation__c != 'Production Administrator' AND Id IN (select Member__c from Shift_Assignments__c where Location__c =: locationId AND Shift_Code__c =: shiftId AND Shift_Assigned__c = true AND ToTime__c = null)];
        if(assignedOperatorsInTeam != null && assignedOperatorsInTeam.size() > 0){
            for(Member__c assignment : assignedOperatorsInTeam){
                Id teamId = assignment.Team_Id__c;
                if(teamId != null){
                    teamIds.add(teamId);
                }
            }
        } 
        return teamIds;
    }
    
    
    public List<Member__c> getAvailableOperatorToday(String teamId, String shiftId){
        system.debug('******** teamId : ' + teamId);
        system.debug('******** shiftId : ' + shiftId);
        
        String today = Date.today().format();
        Date fromdt = null;
        Set<Id> finalAvailableMember = new Set<Id>();
        if(String.isNotEmpty(today)){
            fromdt = Date.parse(today);
        }
        List<Shift_Assignments__c> availableOperatorsTodayAssignment = new List<Shift_Assignments__c>();
        
        if(teamId != null){
            assignedOperators = [SELECT Id, Name, Designation__c,Performance_Rating__r.Name,Emp_ID__c FROM Member__c WHERE Status__c ='Active' AND Team_Id__c =: teamId AND Id IN (select Member__c from Shift_Assignments__c where Shift_Assigned__c = true AND ToTime__c = null) ];
        }
        // Update team details  
        Set<Id> availableOperators = new Set<Id>();
        if(assignedOperators != null && assignedOperators.size() > 0){
            for (Member__c member : assignedOperators){
                availableOperators.add(member.Id);
            }
        }
        
        // Retrieve the shift Administrator assigned in a selected shift and added to available members set
        
        List<Member__c> assignedAdminsInShift = [SELECT Id, Name, Designation__c,Performance_Rating__r.Name,Emp_ID__c FROM Member__c WHERE Status__c ='Active' AND Team_Id__c = null AND Id IN (select Member__c from Shift_Assignments__c where Shift_Code__c =: shiftId AND Shift_Assigned__c = true AND ToTime__c = null)];
        if(assignedAdminsInShift != null && assignedAdminsInShift.size() > 0){
            for (Member__c member : assignedAdminsInShift){
                availableOperators.add(member.Id);
            }
        }
        system.debug('**************** availableOperators ' + availableOperators);
        
        // Check the selected Team member is present today
        if(teamId != null && fromdt != null && availableOperators.size() > 0){
            Team__c teamIn = null;
            
            if(teamId != null && String.isNotBlank(teamId)){
                teamIn = [SELECT Id, Name FROM Team__c WHERE Id = : teamId LIMIT 1];
            }
            
            String teamName = null;
            if(teamIn != null){
                teamName = teamIn.Name;
            }
            
            // Available Operators based on the shift attendance member record (Absent only exists in Attendance Record)
            
            availableOperatorsTodayAssignment = [SELECT Id, Member__c FROM Shift_Assignments__c WHERE Team_Assignment_Id__c = : teamName AND Shift_Code__c =: shiftId AND Shift_Assigned__c = true AND ToTime__c = null AND Member__c NOT IN (select Employee_Name__c from Shift_Attendance__c where Employee_Name__c IN : availableOperators AND Attendance_Date__c =: fromdt)];
            //AND Shift_Code__c =: shiftId
            if(availableOperatorsTodayAssignment != null && availableOperatorsTodayAssignment.size() > 0){
                for(Shift_Assignments__c assdet : availableOperatorsTodayAssignment){
                    finalAvailableMember.add(assdet.Member__c);
                }
            }
            availableOperatorsToday = [SELECT Id, Name, Designation__c,Performance_Rating__r.Name,Emp_ID__c FROM Member__c WHERE Status__c ='Active' AND Id IN : finalAvailableMember ];
            system.debug('**************** availableOperatorsToday 1 ' + availableOperatorsToday);            
            
        } else if (teamId == null && fromdt != null && availableOperators.size() > 0){
            availableOperatorsTodayAssignment = [SELECT Id, Member__c FROM Shift_Assignments__c WHERE Team_Assignment_Id__c = null AND Shift_Code__c =: shiftId AND Shift_Assigned__c = true AND ToTime__c = null AND Member__c NOT IN (select Employee_Name__c from Shift_Attendance__c where Employee_Name__c IN : availableOperators AND Attendance_Date__c =: fromdt)];
            //AND Shift_Code__c =: shiftId
            if(availableOperatorsTodayAssignment != null && availableOperatorsTodayAssignment.size() > 0){
                for(Shift_Assignments__c assdet : availableOperatorsTodayAssignment){
                    finalAvailableMember.add(assdet.Member__c);
                }
            }
            availableOperatorsToday = [SELECT Id, Name, Designation__c, Emp_ID__c,Performance_Rating__r.Name FROM Member__c WHERE Status__c ='Active' AND Id IN : finalAvailableMember ];
            system.debug('**************** availableOperatorsToday 2 ' + availableOperatorsToday);            
        }
        
        
        
        return availableOperatorsToday;
    }
    
    
    public List<Team__c> getTeamDetails(Set<Id> teamIds){
        
        try{
            // Retrieve the logged member details 
            teamdetails = [select id,Name from Team__c WHERE Id IN: teamIds];            
        }catch(Exception e){
            System.debug(e);  
        }
        return teamdetails;
        
    }
    
    
    public List<Files__c> getRelatedFilesInsideSelectedDirectory(Set<Id> fileIds){ 
        
        try{           
            // Retrieve the directory inside the selected directory
            List<Files__c> fileDirList = [SELECT Id, Name,File_Auto_Number__c,File_Copy_number__c,File_Location__c, File_Location__r.Name, File_Type__c, Production_Order__c, Production_Order_Name__c FROM Files__c WHERE Parent_Id__c IN :fileIds];
            if(fileDirList != null && fileDirList.size() > 0){
                for(Files__c file : fileDirList){
                    if(file.File_Type__c == 'Directory' && fileIds != null){
                        fileIds.add(file.Id);
                    }
                }
            }
            
            fileList = [SELECT Id, Name,File_Auto_Number__c, File_Location__c, Status__c, File_Location__r.Name, File_Type__c,Production_Order__c, Production_Order_Name__c FROM Files__c WHERE Parent_Id__c IN :fileIds AND File_Type__c = 'Image'];
        }catch(Exception e){
            System.debug(e);  
        }
        return fileList;
    }
    
    public List<Files__c> getDirectoryTypeFiles(Set<Id> directoryFileIds){ 
        if(directoryFileIds.size() > 0){
            directoryTypefilesList = [SELECT Id, Name, File_Auto_Number__c, Status__c, File_Location__c, File_Type__c FROM Files__c WHERE Id IN :directoryFileIds];
        }
        return directoryTypefilesList;
    }
    
    public List<Files__c> getFilesLists(Set<Id> fileIds){ 
        
        try{
            fileDetailsList = [SELECT Id, Name, filerenamed__c,original_file_name__c, InstructionNames__c, Total_Work_Time__c, File_Copy_number__c, No_of_the_file__c,Total_Break_Time__c, File_Job_Titles__c, Files_To_open__c, File_Auto_Number__c, Status__c, File_Location__c, FTP_Upload_Status__c, 
                               FTP_Upload_Time__c, File_Type__c,  Production_Order__c, Production_Order_Name__c,File_Category_Code__c,
                               File_URL__c,File_Thumbnail_URL__c,File_Preview_URL__c,Member__c,Member_Assigned__c,Current_Extension__c,
                               Parent_Id__c,Instruction__c,Order_Instructions__c,File_HandOver_Instructions__c,TLInCharge__c,QCIncharge__c,Dir_File_name__c, QC_Comments__c, Mistake__c, 
                               IsSplitedFile__c, Splitted_Parent_id__c,Is_Merge_File__c,setting__c FROM Files__c WHERE Id IN :fileIds AND File_Type__c = 'Image'];
        }catch(Exception e){
            System.debug(e);  
        }
        return fileDetailsList;
    }
    
    public Integer getFilesCopyCountInFileAssignment(Id fileId, String fileName,string currentext){ 
        list<String> SplitedName = new list<string>();
        Integer fileCount = 0;
        try{
            
            if(fileName != null && currentext!=null){
                
                SplitedName = fileName.split(currentext);
                String s = null;
                if(SplitedName != null){
                    s = '%' + SplitedName[0] + '_copy'+'%';
                }
                
                //fileNameCopyList = [SELECT Id, Name, File_Auto_Number__c, Status__c FROM Files__c WHERE File_Type__c = 'Image' AND Name Like : s];
                fileNameCopyList = [SELECT Id, Name, File_Auto_Number__c, Status__c FROM Files__c WHERE File_Type__c = 'Image' AND Name Like : s AND Parent_Id__c =: fileId];
                if(fileNameCopyList != null){
                    fileCount = fileNameCopyList.size();
                }
            }
            
        }catch(Exception e){
            System.debug('Exception During String Splitting : '+e);  
        }
        
        return fileCount;
    }    
    
    public Member__c getLoggedMemberInformation(){
        Member__c userMemberInfo = [SELECT Id, Name, User_Id__c, Team_Id__c FROM Member__c WHERE User_Id__c = : UserInfo.getUserId() AND Status__c = 'Active' LIMIT 1];
        return userMemberInfo;
    }
    
    public Shift_Assignments__c getLoggedMemberShiftAssignmentInformation(Id userMemberInfo){
        Shift_Assignments__c shiftInfo = null;
        shiftInfo = [SELECT Id, Name, Shift_Code__c, Member__c FROM Shift_Assignments__c WHERE ToTime__c = null AND Shift_Assigned__c = true AND Member__c = : userMemberInfo LIMIT 1]; 
        return shiftInfo;
    }
    
    public Member__c getPerformanceRatingMemberInformation(Id memberId){
        Member__c userMemberInfoDetail = [SELECT Id, Name, Performance_Rating__c, Location_id__c, First_Name__c, Last_Name__c FROM Member__c WHERE Id=: memberId AND Status__c = 'Active' LIMIT 1];
        return userMemberInfoDetail;
    }
    
    public Member__c getMemberQualityControlInSelectedTeam(Id CurrentTeams){
        system.debug('--getMemberQualityControlInSelectedTeam- TEAM --- ' + CurrentTeams);
        List<Member__c> qcmemberInSelectedTeam = null;
        Member__c qcMember = null;
        if(CurrentTeams != null){
            qcmemberInSelectedTeam = [SELECT Id, Name, First_Name__c, Last_Name__c FROM Member__c WHERE Team_Id__c =: CurrentTeams AND Status__c = 'Active' AND Designation__c = 'Quality Control'];          
            if(qcmemberInSelectedTeam != null && qcmemberInSelectedTeam.size() > 0){
                qcMember = qcmemberInSelectedTeam[0];
                return qcMember ;
            } else {
                return qcMember;
            }
        } else {
            return qcMember;
        }
        
        return qcMember;
    }
    
    public List<Member__c> getAllEstimator(String locationId){
        
        if(locationId != null){
            //availableEstimator = [SELECT Id, Name, Designation__c, Emp_ID__c FROM Member__c WHERE Status__c ='Active' AND Designation__c = 'Quality Control' AND Is_Estimator__c = true AND Location_id__c IN (select Id from Location__c where id =: locationId) ];
            availableEstimator = [SELECT Id, Name, Designation__c, Emp_ID__c, Performance_Rating__r.Name FROM Member__c WHERE Status__c ='Active' AND Designation__c =: Label.EPMS_DESIG_ESTIMATOR AND Location_id__c IN (select Id from Location__c where id =: locationId) ];
            system.debug('$$ locationId : ' + locationId + ',  availableEstimator : ' + availableEstimator);
        }        
        return availableEstimator;
    }
    
    public List<Files__c> getFileList(Set<String> POIds){
        
        if(POIds != null){
            fileList = [SELECT Id, Name, Member__c,Splitted_Parent_id__c,IsSplitedFile__c,Member_Assigned__c, Status__c, File_Type__c FROM Files__c WHERE Production_Order__c IN: POIds AND File_Type__c = 'Image'];
            system.debug('$$ POIds : ' + POIds + ',  fileList : ' + fileList);
        }        
        return fileList;
    }
    
    public List<Production_Order__c> getPOList(Set<String> poNames){
        
        if(poNames != null){
            poList = [SELECT Id, Name, Production_Order_Status__c FROM Production_Order__c WHERE Name IN: poNames];
            system.debug('$$ poNames : ' + poNames + ',  poList : ' + poList);
        }        
        return poList;
    }
    
    //modified by udayasri fro CR-501
    public List<Production_Order__c> getpoRecords(Set<String> poIds){
        if(poIds!=null){
            poRecords=[select id,name,TLQCusers__c,qcId__c,TLQCusers1__c,qcId1__c from Production_Order__c where id IN:poIds];
        }
        return poRecords;
    }
    
    
}