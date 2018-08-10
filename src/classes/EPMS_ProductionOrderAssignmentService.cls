/****************************************************************************
*   Class               :       EPMS_ProductionAssignmentService        *
*   Created Date        :       11/09/2015                                  *           
*   Description         :       To Communicate with the  query locator      *
*                               and return the fetched result set           *
*                                                                           *
*   Created By          :                                                   *                       
*   Version             :       1.0                                         *            
/***************************************************************************/


public class EPMS_ProductionOrderAssignmentService{

    public List<Team__c> teamList = null;
    public List<Team__c> teamDetails = null;
    public List<Member__c> availableTeamLeaderToday = null;
    public List<Member__c> availableQCToday = null;
    public List<Member__c> availableTeamLeaderInShift = null;
    public Set<Id> teamIds = new Set<Id>();
    EPMS_QueryLocator queryObj = new EPMS_QueryLocator();
    EPMS_ProductionOrder_Query_Locator productionQueryObj = new EPMS_ProductionOrder_Query_Locator();
    
    // Get All the shift exists in team object    
    public List<Team__c> getAllTeamList(Id locationId){
         teamList = queryObj.getAllTeamList(locationId);
         return teamList;
    }
    
    public List<Member__c> getTeamLeadersShiftAssignmentInfo(String shiftId){
        availableTeamLeaderInShift = productionQueryObj.getTeamLeadersShiftAssignmentInfo(shiftId);
        return availableTeamLeaderInShift;
    }
    
    public Set<Id> getTeamLeadersTeamAssignmentInfo(String locationId){
        teamIds = productionQueryObj.getTeamLeadersTeamAssignmentInfo(locationId);
        return teamIds;
    }
    
    // Get Available team leaders list 
    public List<Member__c> getAvailableTeamLeaderToday(String teamId){
        availableTeamLeaderToday = productionQueryObj.getAvailableTeamLeaderToday(teamId);
        return availableTeamLeaderToday;
    }
    
    public List<Member__c> getQcTeamAssignmentInfo(String teamId){
        availableQCToday = productionQueryObj.getQcTeamAssignmentInfo(teamId);
        return availableQCToday;
    }
    public List<Team__c> getTeamDetails(Set<Id> teamIds){
        teamDetails = productionQueryObj.getTeamDetails(teamIds);
        return teamDetails;
    }
    
}