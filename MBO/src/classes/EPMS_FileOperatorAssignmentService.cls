/****************************************************************************
*   Class               :       EPMS_FileOperatorAssignmentService          *
*   Created Date        :       15/12/2015                                  *           
*   Description         :       To Communicate with the  query locator      *
*                               and return the fetched result set           *
*                                                                           *
*   Created By          :                                                   *                       
*   Version             :       1.0                                         *            
/***************************************************************************/ 
          

public class EPMS_FileOperatorAssignmentService{

    public List<Member__c> assignedOperators = null;
    public List<Member__c> availableOperatorsToday = null;
    public List<Member__c> assignedOperatorsInShift = null;
    public List<Member__c> assignedOperatorsInTeam = null;
    public List<Team__c> teamdetails = null;
    public List<Files__c> fileDetails = null;
    public List<Files__c> fileDetailsList = null;
    public Set<Id> teamIds = null;
    public List<Shift_Assignments__c> availableOperatorsInTeamToday = null;
    public Integer fileNameCount = 0;
    public List<Files__c> fileInformation = null;
    public String fileLocationName = null;
    public List<Files__c> updateFileInformation = null;
    public List<Files__c> directoryTypefilesList = null;
    public List<Member__c> availableEstimator = null;
    public List<Files__c> fileList = null;
    public List<Production_Order__c> poList = null;
    public List<Production_Order__c> poRecords=null;
    
    public EPMS_File_Assignment_Order_Query_Locator fileQueryObj = new EPMS_File_Assignment_Order_Query_Locator();
    
    
    public List<Files__c> getDirectoryTypeFiles(Set<Id> directoryFileIds){ 
        directoryTypefilesList = fileQueryObj.getDirectoryTypeFiles(directoryFileIds);
        return directoryTypefilesList;
    }
    
    public List<Files__c> getUpdateFileInformation(String[] ids){
        updateFileInformation = fileQueryObj.getUpdateFileInformation(ids);
        return updateFileInformation;
    }   
    public List<Files__c> getFileInformation(String[] ids){
        fileInformation = fileQueryObj.getFileInformation(ids);
        return fileInformation;
    }
    
    public String getFileLocationName(Id locationId){
        fileLocationName = fileQueryObj.getFileLocationName(locationId);
        return fileLocationName;
    }
    
    public List<Member__c> getOperatorsAssignedInShift(String shiftId){
        assignedOperatorsInShift = fileQueryObj.getOperatorsAssignedInShift(shiftId);
        return assignedOperatorsInShift;
    }
    
    public Set<Id> getOperatorsAssignedInTeam(String locationId, String shiftId){
        teamIds = fileQueryObj.getOperatorsAssignedInTeam(locationId,shiftId);
        return teamIds;            
    }

    public List<Member__c> getAvailableOperatorToday(String teamId, String shiftId){
        availableOperatorsToday = fileQueryObj.getAvailableOperatorToday(teamId, shiftId);
        return availableOperatorsToday;
    }
    
    public List<Team__c> getTeamDetails(Set<Id> teamIds){
        teamDetails = fileQueryObj.getTeamDetails(teamIds);
        return teamDetails;
    }
    
    public List<Files__c> getRelatedFilesInsideSelectedDirectory(Set<Id> fileIds){ 
        fileDetails = fileQueryObj.getRelatedFilesInsideSelectedDirectory(fileIds);
        return fileDetails;
    }
    
    public List<Files__c> getFilesLists(Set<Id> fileIds){ 
        fileDetailsList = fileQueryObj.getFilesLists(fileIds);
        return fileDetailsList;
    }
    
    public Integer getFilesCopyCountInFileAssignment(Id fileId, String fileName,string currentext){ 
        fileNameCount = fileQueryObj.getFilesCopyCountInFileAssignment(fileId,fileName,currentext);
        return fileNameCount;
    }
    
    public Member__c getLoggedMemberInformation(){
        Member__c userMemberInfo = fileQueryObj.getLoggedMemberInformation();
        return userMemberInfo;
    }
    
    public Shift_Assignments__c getLoggedMemberShiftAssignmentInformation(Id userMemberInfo){
        Shift_Assignments__c shiftInfo = null;
        shiftInfo = fileQueryObj.getLoggedMemberShiftAssignmentInformation(userMemberInfo);
        return shiftInfo;
    }
    
     public Member__c getPerformanceRatingMemberInformation(Id memberId){
        Member__c userMemberInfoDetail = fileQueryObj.getPerformanceRatingMemberInformation(memberId);
        return userMemberInfoDetail;
    }
    
    public Member__c getMemberQualityControlInSelectedTeam(Id CurrentTeams){
         Member__c qcmemberInSelectedTeam = fileQueryObj.getMemberQualityControlInSelectedTeam(CurrentTeams);          
         return qcmemberInSelectedTeam;
    }
    
    public List<Member__c> getAllEstimator(String locationId){
        availableEstimator = fileQueryObj.getAllEstimator(locationId);
        return availableEstimator;
    }
    
    public List<Files__c> getFileList(Set<String> POIds){
        fileList = fileQueryObj.getFileList(POIds);
        return fileList;
    }
    
    public List<Production_Order__c> getPOList(Set<String> poNames){
        poList = fileQueryObj.getPOList(poNames);
        return poList;
    }
    
    public List<Production_Order__c> getpoRecords(set<String> poIds){
    poRecords=fileQueryObj.getpoRecords(poIds);
    return poRecords;
    
    }
   
}