/****************************************************************************
*   Class               :       EPMS_Mem_TeamAssignment_Service                  *
*   Created Date        :       22/12/2015                                   *           
*   Description         :       Query Service Class for Team Assignment      *
*                               Shift_Assignments__c                         *
*   Created By          :                                                    *                       
*   Version             :       1.0                                          *            
/***************************************************************************/

public with sharing class EPMS_Mem_TeamAssignment_Service{
    
    EPMS_Mem_TeamAssignment_QueryLocator TeamShiftAssignment_QueryLocator = new EPMS_Mem_TeamAssignment_QueryLocator();
    
    public List<Member__c> getAllMemberList(ID selectvalue, String CurrentTeams){
        List<Member__c> memberList = TeamShiftAssignment_QueryLocator.getAllMemberList(selectvalue,CurrentTeams);
        return memberList;
    }
   
    public List<Member__c> getmemberList(ID selectvalue,String CurrentTeams){
        List<Member__c> memberList = TeamShiftAssignment_QueryLocator.getmemberList(selectvalue,CurrentTeams);
        return memberList;
    }
    
    public List<Member__c> getassignedMemberList(ID selectvalue,String CurrentTeams){
        List<Member__c> assignedMemberList = TeamShiftAssignment_QueryLocator.getassignedMemberList(selectvalue,CurrentTeams);
        return assignedMemberList;
    }
    
    public List<Member__c> getselectedmemberList( Set<Id> selectMembersID){
        List<Member__c> selectedmemberList =  TeamShiftAssignment_QueryLocator.getselectedmemberList(selectMembersID);
        return selectedmemberList;
    }
        
        // Get the profile of logged member 
    public List<Profile> getProfiles(){
        List<Profile>profileList =  TeamShiftAssignment_QueryLocator.getProfiles();
        return profileList;
    }
    
    //Get List of Members associated with location of logged member (Used)
    public List<Member__c> getMemberInLocation(){
        List<Member__c>members = TeamShiftAssignment_QueryLocator.getMemberListAssociatedLocation();
        return members;
    }
    
    // Method to retrieve the list of available location
    public List<Location__c> getAllLocations(){ 
        List<Location__c>locationAll = TeamShiftAssignment_QueryLocator.getAllLocations();
        return locationAll;
    }
    
    // Get All the shift exists in team object    
    public List<Team__c> getAllTeamList(Id locationId){
         List<Team__c>teamList = TeamShiftAssignment_QueryLocator.getAllTeamList(locationId);
         return teamList;
    }
    
    public String getShiftNameForSelectedTeam(Id teamId){
        String shiftName = TeamShiftAssignment_QueryLocator.getShiftNameForSelectedTeam(teamId);
        return shiftName;
    }   
    
    
}