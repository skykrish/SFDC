/****************************************************************************
*   Class               :       EPMS_ShiftAssignmentService (Team Based)    *
*   Created Date        :       13/04/2016                                  *           
*   Description         :       To Communicate with the  query locator      *
*                               and return the fetched result set           * 
/***************************************************************************/

public class EPMS_Shift_Assignment_Service_New {
    
    List<Team__c> teamsAssigned = null;
    List<Team__c> availableTeam = null;
    List<Team__c> teamList = null;
    List<Team__c> teamListloc = null;
    List<Team__c> teamOtherList = null;
    Set<Id> shiftAdmins = new Set<Id>();
     Set<Id> shiftAssignors = new Set<Id>();
     List<Shift__c> ShiftsBasedOnLoc=new List<Shift__c>();
    Set<Id> shiftAdminIds = new Set<Id>();
    Set<Id> shiftAssignIds = new Set<Id>();
    List<Shift_Assignments__c> teamRecordsForShiftAdmin = null;
    List<Member__c> allShiftAdminList = null;
    List<Member__c> allAssignors= null; 
    List<Shift_Assignments__c> shiftAssignmentDetails = null;
    List<Member__c> assignedMembersInSelectedTeam = null;
    List<Shift_Assignments__c> shiftOnlyRecordsForShiftAdmin = null;
    List<Shift_Assignments__c> shiftOtherRecordsForShiftAdmin  = null;
    List<Shift_Assignments__c> shiftOtherRecordsForAssignor  = null; 
    List<Shift_Assignments__c>  shiftTeamOnlyRecordsForShiftAdmin = null;
    List<Shift_Assignments__c>  shiftOnlyRecordsForAssignor = null;
    List<Shift__c> selectedShiftList = null;
    public Member__c loggedmember = null;
    public List<Member__c> membersInfo = null;
    public List<Profile> profileList = null;
    public List<Member__c> members = null;
    public List<Location__c> locationAll = null;
    public List<Member__c> membersNotInTeam = null;    
    public List<Member__c> membersNotInTeamShiftAss = null; 
    List<Shift_Assignments__c> shiftOnlyRecordsForUnassignedTeamMembers = null;
    public Shift__c shiftInfo = null;
    Member__c shiftAdminMemInfo = null;
    Member__c AssignorMemInfo = null;
    Member__c AssignorInfo = null;
    List<Member__c> unAssignedTeamMembers = null;
    //************************************************************************************************************************//
    
    //EPMS_Team_Shift_Assignment_QueryLocator queryObj = new EPMS_Team_Shift_Assignment_QueryLocator();
    EPMS_Shift_Assignment_Query_Locator queryObj = new EPMS_Shift_Assignment_Query_Locator();
    public List<Team__c> getAssignedTeamForSelectedShift(Id locationId, Id shiftId){
        //teamsAssigned = queryObj.getAssignedTeamForSelectedShift(locationId,shiftId);
        teamsAssigned = queryObj.getAssignedTeamForSelectedShift2(locationId,shiftId);
        return teamsAssigned;
    }   
    
    public List<Team__c> getAvailableTeamsInLocation(Id locationId){
        availableTeam = queryObj.getAvailableTeamsInLocation(locationId);
        return availableTeam;
    }   
    
    public List<Team__c> getAllTeamsInLocation(Id locationId, Id shiftId){

        teamList = queryObj.getAllTeamsInLocation(locationId,shiftId);
        return teamList;
    }
    
    public List<Team__c> getAssignedTeamForOtherShift(Id locationId){
        teamOtherList = queryObj.getAssignedTeamForOtherShift(locationId);
        return teamOtherList;
    }   
    
    public Set<Id> getAssignedShiftAdministratorInSelectedShift(Id locationId, Id shiftId){
        shiftAdmins = queryObj.getAssignedShiftAdministratorInSelectedShift(locationId,shiftId);
        return shiftAdmins;
    }   
    
    public Set<Id> getAssignedShiftAdminForShift(Id shiftId){
        shiftAdminIds = queryObj.getAssignedShiftAdminForShift(shiftId);
        return shiftAdminIds;
    }
    
    public List<Shift_Assignments__c> getTeamAssignmentForAssignedTeam(Id shiftAdministrator){
        teamRecordsForShiftAdmin = queryObj.getTeamAssignmentForAssignedTeam(shiftAdministrator);
        return teamRecordsForShiftAdmin;
    }

    public List<Member__c> getAllShiftAdministrator(Id locationId){
        allShiftAdminList = queryObj.getAllShiftAdministrator(locationId);
        return allShiftAdminList;
    }
    
    
    
    public List<Shift_Assignments__c> getShiftAssignmentforTeamMember(Id locationId, Set<Id> memberIds){
        shiftAssignmentDetails = queryObj.getShiftAssignmentforTeamMember(locationId,memberIds);
        return shiftAssignmentDetails;
    }   
    
    public List<Member__c> getAssignedMemberForTeam(Id locationId, Set<Id> teamIds){
        assignedMembersInSelectedTeam = queryObj.getAssignedMemberForTeam(locationId,teamIds);
        return assignedMembersInSelectedTeam;
    }
    
    public List<Shift_Assignments__c> getShiftOnlyAssignmentForAssignedTeam(Id shiftAdministrator){
        shiftOnlyRecordsForShiftAdmin =  queryObj.getShiftOnlyAssignmentForAssignedTeam(shiftAdministrator);
        return shiftOnlyRecordsForShiftAdmin;
    }
    
    public List<Shift_Assignments__c> getOtherShiftAdminAssignmentForSelectedShift(Id shiftAdministrator){
        shiftOtherRecordsForShiftAdmin =  queryObj.getOtherShiftAdminAssignmentForSelectedShift(shiftAdministrator);
        return shiftOtherRecordsForShiftAdmin;
    }
    
    public List<Shift_Assignments__c> getOtherTeamShiftAdminAssignmentForSelectedShift(Id teamId){
     shiftTeamOnlyRecordsForShiftAdmin= queryObj.getOtherTeamShiftAdminAssignmentForSelectedShift(teamId);
     return shiftTeamOnlyRecordsForShiftAdmin;
    }
    
    public Map<Id, Integer> getAssignedMemberForTeamMemberCount(Id locationId, Set<Id> teamIds){
        Map<Id, Integer> membercountmap = queryObj.getAssignedMemberForTeamMemberCount(locationId,teamIds);
        return membercountmap;
    }
    
     // Get All the shift exists in team object    
    public List<Team__c> getAllTeamList(Id locationId){
         teamListloc = queryObj.getAllTeamList(locationId);
         return teamListloc;
    }
    
    // Method to retrieve the list of all shift associated with selected location
    public List<Shift__c> getAllShiftListForSelectedLocation(Id locationId){
        selectedShiftList = queryObj.getAllShiftListForSelectedLocation(locationId);
        return selectedShiftList;
    }
    
    //Return the Member Details (Used)

    public Member__c getMember(){
        
        loggedmember = queryObj.getMember();
        
        return loggedmember;
    }
    
    public List<Member__c> getAllMemberInLocation(){
        membersInfo = queryObj.getAllMemberInLocation();
        return membersInfo;
    }
    // Get the profile of logged member 
    public List<Profile> getProfiles(){
    
        profileList =  queryObj.getProfiles();
        return profileList;
    }
    
    //Get List of Members associated with location of logged member (Used)
    public List<Member__c> getMemberInLocation(){
        members = queryObj.getMemberListAssociatedLocation();
        return members;
    }
    
     // Method to retrieve the list of available location
    public List<Location__c> getAllLocations(){ 
        locationAll = queryObj.getAllLocations();
        return locationAll; 
    }
    
     // Method to retrieve member location if user logged as system administrator
    public List<Location__c> getLocations(){ 
        locationAll = queryObj.getLocations();
        return locationAll;
    }
    public List<Member__c> getMemberNotInTeam(Id locationId){ 
        membersNotInTeam = queryObj.getMemberNotInTeam(locationId);
        return membersNotInTeam;
    }
    
    public List<Member__c> getMemberNotInTeamHaveShiftAssignments(Id locationId, Id shiftId){
        membersNotInTeamShiftAss = queryObj.getMemberNotInTeamHaveShiftAssignments(locationId,shiftId);
        return membersNotInTeamShiftAss;
    }
    
    
    public List<Shift_Assignments__c> getShiftOnlyAssignmentForAssignedTeamMembers(Set<Id> memberIds){
        shiftOnlyRecordsForUnassignedTeamMembers =  queryObj.getShiftOnlyAssignmentForAssignedTeamMembers(memberIds);
        return shiftOnlyRecordsForUnassignedTeamMembers;
    }
    
    public Shift__c getShiftInfo(Id shiftId){
        shiftInfo =  queryObj.getShiftInfo(shiftId);
        return shiftInfo;
    }
    
    public Member__c getShiftAdminMemberInfo(Id shiftAdministrator){
        shiftAdminMemInfo = queryObj.getShiftAdminMemberInfo(shiftAdministrator);
        return shiftAdminMemInfo;
    }
    
    public List<Member__c> getUnAssignedTeamMembersInfo(Set<Id> selectedTeamMemberIds){
        unAssignedTeamMembers = queryObj.getUnAssignedTeamMembersInfo(selectedTeamMemberIds);
        return unAssignedTeamMembers;
    }
    
    //modified by udayasri
    
    public List<Member__c> getAllAssignors(Id locationId){
        allAssignors = queryObj.getAllAssignors(locationId);
        return allAssignors;
    }
    
    public Set<Id> getAssignedAssignorsInSelectedShift(Id locationId, Id shiftId){
        shiftAssignors = queryObj.getAssignedAssignorsInSelectedShift(locationId,shiftId);
        return shiftAssignors;
    }

     public Set<Id> getAssignedAssignorForShift(Id shiftId){
        shiftAssignIds = queryObj.getAssignedAssignorForShift(shiftId);
        return shiftAssignIds;
    }   
    
    public Member__c getAssignorMemberInfo(Id Assignor){
        AssignormemInfo = queryObj.getAssignorMemberInfo(Assignor);
        return AssignormemInfo;
    }
    
    public List<Shift_Assignments__c> getShiftOnlyAssignmentForAssignedAssignor(Id Assignor){
        shiftOnlyRecordsForAssignor =  queryObj.getShiftOnlyAssignmentForAssignedAssignor(Assignor);
        return shiftOnlyRecordsForAssignor;
    }
    
    public List<Shift_Assignments__c> getOtherAssignorAssignmentForSelectedShift(Id Assignor){
        shiftOtherRecordsForAssignor =  queryObj.getOtherAssignorAssignmentForSelectedShift(Assignor);
        return shiftOtherRecordsForAssignor;
    }
    
    //modified by udayasri to get all shifts based on location
    public list<shift__c> getShifts(id loc){
       ShiftsBasedOnLoc=queryObj.getShifts(loc);
       return ShiftsBasedOnLoc;
    }
    
    
    
}