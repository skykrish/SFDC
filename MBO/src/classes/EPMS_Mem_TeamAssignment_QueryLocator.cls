/***************************************************************************
*   Class               :       Team Assignment Query Locator               *
*   Created Date        :       28/12/2015                                  *           
*   Description         :       To return the requested Result              *
*                               based on the request by service class       *
*                               will be used as the Common Class            *
*   Created By          :                                                   *                       
*   Version             :       1.0                                         *            
/***************************************************************************/

public class EPMS_Mem_TeamAssignment_QueryLocator{

    List<Profile> profile = null;
    public String MyProflieName{get;set;}
    public List<Member__c> memberList = null;
    public List<Location__c> locationList = null;
    public List<Team__c> teamdetailslist = null;
    public List<Profile> profileList = null;
    public List<Member__c> members = null;
    public List<Shift_Assignments__c> shiftAssignmentList = null;
    
    //get  members 
    public List<Member__c> getAllMemberList(ID selectvalue, String CurrentTeams){
        Set<Id> memberIds = new Set<Id>();
        List<Member__c> assignedMemberList = [SELECT Name, Id, Emp_ID__c,Designation__c FROM Member__c where Designation__c  !=  'House Keeper' AND Designation__c  !=  'IT Administrator' AND Location_id__c = : selectvalue  AND Team_Id__c = : CurrentTeams AND Status__c=:'Active' ORDER BY Name ASC];
        if(assignedMemberList.size() > 0){
            for(Member__c mem : assignedMemberList){
                memberIds.add(mem.Id);
            }
        }
       
        List<Member__c> memberList = [SELECT Name, Id, Emp_ID__c,Designation__c FROM Member__c where Designation__c  !=  'House Keeper' AND Id NOT IN : memberIds AND Location_id__c = : selectvalue AND Status__c='Active' AND Designation__c != 'Shift Administrator' AND Designation__c != 'Production Administrator' AND Designation__c != 'Sales Region' AND Designation__c != 'File Managers' AND Designation__c  !=  'IT Administrator' ORDER BY Name ASC];
        return memberList;
    }
    
    //get member list   
    public List<Member__c> getmemberList(ID selectvalue,String CurrentTeams){
     
        List<Member__c> memberList =[SELECT Name, Id, Emp_ID__c,Designation__c FROM Member__c where Designation__c  !=  'House Keeper' AND Location_id__c = : selectvalue AND Status__c=:'Active' AND Designation__c != 'Shift Administrator' AND Designation__c != 'Production Administrator' AND Designation__c != 'Sales Region' AND Designation__c != 'File Managers' AND Designation__c  !=  'IT Administrator' AND Team_Id__c = null ORDER BY Name ASC];
        return memberList;
    }     
    
    //get team assigned member list
    public List<Member__c> getassignedMemberList(ID selectvalue,String CurrentTeams){
 
        List<Member__c> assignedMemberList =[SELECT Name, Id, Emp_ID__c,Designation__c FROM Member__c where Location_id__c = : selectvalue  AND Team_Id__c = : CurrentTeams AND Status__c=:'Active' ORDER BY Name ASC];
        return assignedMemberList;
    }
    
    //get member
    public List<Member__c> getselectedmemberList( Set<Id> selectMembersID){    
        List<Member__c> selectedmemberList = [SELECT Name, Id,Designation__c FROM Member__c WHERE Id IN : selectMembersID ];
        return selectedmemberList;
    }
        
    //Return the List of Profile based User Login
    public List<Profile> getProfiles(){
        try{
             profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
             MyProflieName= profile[0].Name;
         }catch(Exception e){
              System.debug(e);  
         }
       return profile ;
    }
    
    //get members related to the selected location
    public List<Member__c> getMemberListAssociatedLocation(){
        memberList = new List<Member__c>();
        try{

            // Retrieve the logged member details 
            Member__c loggedMember = [select id,Location_id__c,Location_id__r.Name, Designation__c from Member__c where User_Id__c =: userinfo.getuserid() AND Status__c='Active' ORDER BY Name ASC];
            // Retrieve the list of active members associated with logged member's location
            memberList = [SELECT Id, Name, Location_id__c, Location_id__r.Name, First_Name__c, Designation__c FROM Member__c WHERE Location_id__c =: loggedMember.Location_id__c AND Id !=: loggedMember.Id AND Status__c='Active' AND Designation__c != 'Production Administrator' ORDER BY Name ASC];
         }catch(Exception e){
              System.debug(e);  
          }
        return memberList;
    }
    
     //Return the Location
    public List<Location__c> getAllLocations(){
     try{
        locationList = [select id,Name from Location__c where Location_Status__c = 'Active' ORDER BY Name ASC];
        }catch(Exception e){
          System.debug(e);  
      }
        return locationList;
    }
    
      // Retrieve the available team exists
    public List<Team__c> getAllTeamList(Id locationId){
        
        try{
            teamdetailslist= [select id,Name from Team__c where Location__c =: locationId ORDER BY Name ASC];
        }catch(Exception e){
            System.debug(e);  
        }
        return teamdetailslist;
    }
    
    //get shifts  
    public String getShiftNameForSelectedTeam(Id teamId){
        Team__c teamDetails  = null;
        String shiftcode = null;
        String shiftName = '';
        Shift__c shiftInfo = null;
        if(teamId != null){
            teamDetails  = [SELECT Id, Name FROM Team__c WHERE Id =: teamId LIMIT 1];
        }
        String teamName = null;
        if(teamDetails != null){
            teamName = teamDetails.Name;
            shiftAssignmentList = [SELECT Id, Name, Shift_Code__c FROM Shift_Assignments__c WHERE ToTime__c = null AND Shift_Assigned__c = true AND Team_Assignment_Id__c =:teamName];
            if(shiftAssignmentList != null && shiftAssignmentList.size() > 0){
                shiftcode = shiftAssignmentList[0].Shift_Code__c;
                if(shiftcode != null){
                    shiftInfo = [SELECT Id, Name FROM Shift__c WHERE Id =:shiftcode LIMIT 1];
                    if(shiftInfo != null){
                        shiftName = shiftInfo.Name;
                    }
                }
            }
        }
        return shiftName;
    }   
}