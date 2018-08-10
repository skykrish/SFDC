/****************************************************************************
*   Class               :       Team - Shift Assignment Query Locator       *
*   Created Date        :       31/12/2015                                  *           
*   Description         :       To return the requested Result              *
*                               based on the request by service class       *
*                               will be used as the Common Class            *       
/***************************************************************************/ 

public class EPMS_Shift_Assignment_Query_Locator{


    List<Member__c> unassignedTeamMembersInSelectedLocation  = null;
    List<Member__c> memberListHaveNoTeam = null;
    List<Member__c> allTeamMembersInSelectedLocation = null;
    List<Member__c> unassignedShiftAdminList = null;
    List<Member__c> allShiftAdminList = null;
    List<Member__c> allAssignorsList = null;
    List<Team__c> teamList = null;
    List<Team__c> availableteamList = null;
    List<Member__c> assignedMembersInSelectedTeam = null;
    List<Shift_Assignments__c> shiftAssignmentRecordsForTeamMember = null;
    Set<Id> shiftAdminIds = null;
    Set<Id> shiftAssignorIds=null;
    List<Shift_Assignments__c> shiftAssignmentRecordsForShift = null;
    List<Shift_Assignments__c> teamAssignmentRecordsForSelectedShift = null;
    List<Shift_Assignments__c> shiftAssignmentRecordsForShift2 = null;
    List<Shift_Assignments__c> shiftAssignmentRecordsForShift3 = null;
    List<Shift_Assignments__c> shiftAdminTeamAssignRecords = null;
    list<Shift__c> ShiftsBasedOnLoc=null;
    List<Shift_Assignments__c> shiftAdminTeamAssignRecords2 = null;
    List<Shift_Assignments__c> shiftAdminTeamAssignRecords3 = null;
    List<Shift_Assignments__c> shiftOnlyRecordsForUnAssignedTeamMembers = null;
    List<Team__c> teamListHaveShiftAssign = null;
    List<Team__c> teamListHaveOtherShiftAssign = null;
    Set<Id> sadminList = null;
    Set<Id> shiftAdminAssignedTeams = null;
    List<Shift_Assignments__c> teamRecordsForShiftAdmin = null;
    List<Shift_Assignments__c> shiftOnlyRecordsForShiftAdmin = null;
    List<Shift_Assignments__c> shiftTeamOnlyRecordsForShiftAdmin = null;
     List<Shift_Assignments__c> shiftOnlyRecordsForAssignor = null;
    List<Team__c> teamdetailslist = null;
    List<Shift__c> allShiftInLocation = null; 
    Member__c member = null;
    List<Profile> profile = null;
    public String MyProflieName{get;set;}
    public List<Member__c> memberList = null;
    List<Location__c> locationList = null;
    public List<Member__c> memberListAllLocation = null;
    public Shift__c shiftInfo = null;
    Member__c shiftAdminMemInfo = null;
    Member__c AssignorMemInfo = null;
    List<Member__c> unAssignedTeamMembers = null;
    
      // Retrieve the all members 
    public List<Member__c> getAllMemberInLocation(){
         try{
            memberListAllLocation = [SELECT Id, Name, Location_id__c, First_Name__c, Designation__c FROM Member__c WHERE Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS ORDER BY Name ASC];
        }catch(Exception e){
            System.debug(e);  
        }
        return memberListAllLocation;
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
    
    //Return the Member Details to List 
    public Member__c getMember(){
    
        try{
            member  = [select id,Location_id__c,Location_id__r.Name, Designation__c from Member__c where User_Id__c =:userinfo.getuserid()];
        }catch(Exception e){
          System.debug(e);  
        }
        return member;
    }
    
     //Return the Location
    public List<Location__c> getAllLocations(){
     try{
        locationList = [select id,Name from Location__c where Location_Status__c =: EPMS_UTIL.EPMS_ACTIVE_STATUS ORDER BY Name ASC];
        }catch(Exception e){
          System.debug(e);  
      }
        return locationList;
    }
    
    public List<Member__c> getMemberListAssociatedLocation(){
        memberList = new List<Member__c>();

        try{
            // Retrieve the logged member details 
            Member__c loggedMember = [select id,Location_id__c,Location_id__r.Name, Designation__c from Member__c where User_Id__c =: userinfo.getuserid() AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS ORDER BY Name ASC];

            // Retrieve the list of active members associated with logged member's location
            memberList = [SELECT Id, Name, Location_id__c, Location_id__r.Name, First_Name__c, Designation__c FROM Member__c WHERE Location_id__c =: loggedMember.Location_id__c AND Id !=: loggedMember.Id AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Designation__c != 'Production Administrator' ORDER BY Name ASC];

         }catch(Exception e){
              System.debug(e);  
          }
        return memberList;
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
    
    public List<Shift__c> getAllShiftListForSelectedLocation(Id locationId){
    
         try{
            // Retrieve the available shift in logged user's location
            allShiftInLocation =[select id,Name, Implements_From__c, Implements_To__c, Shift_Start_Time__c, Shift_End_Time__c from Shift__c WHERE Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Shift_Location__c=: locationId ORDER BY Name ASC];

         }catch(Exception e){
          System.debug(e);  
         }
           return allShiftInLocation;
    }
    
        
    public List<Member__c> getUnAssignedMemberForTeam(Id locationId, String fromDate, String toTime){
    
        unassignedTeamMembersInSelectedLocation = [SELECT Id, Name, First_Name__c,User_Id__c, User_Id__r.Name,Emp_ID__c, Last_Name__c, Designation__c FROM Member__c WHERE Location_id__c = : locationId AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Designation__c != 'Shift Administrator' AND Designation__c != 'Production Administrator' AND Designation__c != 'Team Leader' AND Designation__c != 'Quality Control' AND Designation__c!='File Manager' AND Designation__c!='Sales Region' AND Id NOT IN (SELECT Member__c FROM Shift_Assignments__c WHERE Location__c = : locationId  AND Shift_Assigned__c = true AND ToTime__c = null) ORDER BY Name ASC];     
         
        return unassignedTeamMembersInSelectedLocation;
    }
    
    public List<Member__c> getAllMemberForTeam(Id locationId){
    
        allTeamMembersInSelectedLocation = [SELECT Id, Name, First_Name__c,User_Id__c, User_Id__r.Name,Emp_ID__c, Last_Name__c, Designation__c FROM Member__c WHERE Location_id__c = : locationId AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Designation__c != 'Shift Administrator' AND Designation__c != 'Production Administrator' AND Designation__c != 'Team Leader' AND Designation__c != 'Quality Control' AND Designation__c!='File Manager' AND Designation__c!='Sales Region' ORDER BY Name ASC];     
         
        return unassignedTeamMembersInSelectedLocation;
    }
    
    // Method to get an un-assigned Shift Administrator
    public List<Member__c> getUnAssignedShiftAdministrator(Id locationId){

        if (locationId != null){
            unassignedShiftAdminList = [SELECT Id, Name, First_Name__c,User_Id__c, User_Id__r.Name, Last_Name__c, Designation__c, Emp_ID__c FROM Member__c WHERE Location_id__c = : locationId AND Designation__c = 'Shift Administrator' AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Id NOT IN (SELECT Member__c FROM Shift_Assignments__c WHERE Location__c = : locationId  AND Shift_Assigned__c = true AND Shift_Code__c != NULL AND ToTime__c=NULL) ORDER BY Name ASC];
        }            
      return unassignedShiftAdminList ;
      
    }
    
    // Method to get an all Shift Administrator in selected locations
    public List<Member__c> getAllShiftAdministrator(Id locationId){

        if (locationId != null){
            // All Shift Administrator
            allShiftAdminList = [SELECT Id, Name,Performance_Rating__r.Name,First_Name__c,User_Id__c, User_Id__r.Name, Last_Name__c, Designation__c, Emp_ID__c FROM Member__c WHERE Location_id__c = : locationId AND Designation__c = 'Shift Administrator' AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS ORDER BY Name ASC];     
        }     

      return allShiftAdminList;
    }
    
     // Method to get an all teams associated with selected location
    public List<Team__c> getAllTeamsInLocation(Id locationId, Id shiftId){
        //
        List<Team__c> teams = getAssignedTeamForSelectedShift2(locationId,shiftId);
        Set<Id> teamIds = new Set<Id>();
        if(teams != null && teams.size() > 0){
            for(Team__c t : teams){
                teamIds.add(t.Id);
            }
        }
        // Ignore the assigned team from all teams list
        teamList = [select id,Name from Team__c where Location__c =: locationId AND Id NOT IN : teamIds ORDER BY Name ASC];
        return teamList;
    }
    
    public List<Team__c> getAvailableTeamsInLocation(Id locationId){
        
        // From Member Records
        Set<Id> assignedTeamIds = new Set<Id>();
        Set<Id> availableteams = new Set<Id>();
        List<Member__c> memberList = [SELECT Team_Id__c, Team_Id__r.Name FROM Member__c WHERE Status__c =: EPMS_UTIL.EPMS_ACTIVE_STATUS AND Id IN (SELECT Member__c FROM Shift_Assignments__c WHERE Location__c = : locationId AND Shift_Assigned__c = true AND ToTime__c=NULL)];
        if(memberList != null && memberList.size() > 0){
            for(Member__c member : memberList){
                assignedTeamIds.add(member.Team_Id__c);
            }
        }
        // Query the member object and get all active member who have relation with team object
        availableteamList = [SELECT Id, Name FROM Team__c WHERE Location__c =: locationId AND Id IN (SELECT Team_Id__c FROM Member__c WHERE Status__c =: EPMS_UTIL.EPMS_ACTIVE_STATUS AND Location_id__c = :locationId )];
       
        if(availableteamList!= null && availableteamList.size() > 0 && assignedTeamIds.size() > 0){
            for(Team__c team : availableteamList){
                if(assignedTeamIds.contains(team.Id)){
                    // Ignore the teams
                } else {
                    availableteams.add(team.Id);
                }
            }
        }

        if(availableteams.size() > 0){
            availableteamList = [SELECT Id, Name FROM Team__c WHERE Location__c =: locationId AND Id IN :availableteams];        
        } else {
            availableteamList = [SELECT Id, Name FROM Team__c WHERE Location__c =: locationId AND Id IN (SELECT Team_Id__c FROM Member__c WHERE Status__c =: EPMS_UTIL.EPMS_ACTIVE_STATUS AND Location_id__c = :locationId )];        
        }
        return availableteamList;
    }
    
     public List<Member__c> getAssignedMemberForTeam(Id locationId, Set<Id> teamIds){

        if (teamIds != null && teamIds.size() > 0){
            assignedMembersInSelectedTeam = [SELECT Id, Name, Current_Shift__c, First_Name__c,User_Id__c, User_Id__r.Name,Emp_ID__c, Last_Name__c, Team_Id__c, Team_Id__r.Name, Designation__c FROM Member__c WHERE Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Team_Id__c IN : teamIds ORDER BY Name ASC];     
        }
        return assignedMembersInSelectedTeam;
        
      }
    
    
    public List<Shift_Assignments__c> getShiftAssignmentforTeamMember(Id locationId, Set<Id> memberIds){
    
        shiftAssignmentRecordsForTeamMember = [SELECT Id, Name, Shift_Code__c, Member__c, Member__r.Name, Location__c, FromTime__c, ToTime__c  FROM Shift_Assignments__c WHERE Location__c = : locationId   AND Member__c IN : memberIds AND Shift_Assigned__c = true AND ToTime__c=NULL];
        return shiftAssignmentRecordsForTeamMember;
    }
    
    public Set<Id> getAssignedShiftAdminForShift(Id shiftId){
        shiftAdminIds = new Set<Id>();
        List<Member__c> assignedShiftAdministratorList = [SELECT Id, Name, Designation__c FROM Member__c WHERE Id IN (SELECT Member__c FROM Shift_Assignments__c WHERE Shift_Code__c = : shiftId AND Shift_Assigned__c = true AND ToTime__c=NULL)];    
        if(assignedShiftAdministratorList != null){
            for(Member__c assignment : assignedShiftAdministratorList){
                if(assignment.Designation__c == 'Shift Administrator'){
                    shiftAdminIds.add(assignment.Id);
                }
                
            }
        }

        return shiftAdminIds;
    }
    
    
     public List<Shift_Assignments__c> getShiftAssignmentforShift(Id locationId, Set<Id> memberIds, Id shiftCode){
    
        shiftAssignmentRecordsForShift = [SELECT Id, Name, Shift_Code__c, Member__c, Member__r.Name, Location__c, FromTime__c, ToTime__c  FROM Shift_Assignments__c WHERE Location__c = : locationId   AND Shift_Code__c =:shiftCode AND Member__c IN : memberIds AND Shift_Assigned__c = true AND ToTime__c=NULL];

        return shiftAssignmentRecordsForShift ;
    }
    
    
    public List<Team__c> getAssignedTeamForSelectedShift(Id locationId, Id shiftId){


        Set<Id> members = new Set<Id>();
        Set<Id> teamIds = new Set<Id>();
        List<Shift_Assignments__c> teamAssignmentRecords = null;
        shiftAssignmentRecordsForShift2 = [SELECT Id, Name, Shift_Code__c, Member__c, Member__r.Name, Location__c, FromTime__c, ToTime__c  FROM Shift_Assignments__c WHERE Location__c = : locationId   AND Shift_Code__c =:shiftId AND Shift_Assigned__c = true AND ToTime__c=NULL];        
        if(shiftAssignmentRecordsForShift2 != null && shiftAssignmentRecordsForShift2.size() > 0){

            for(Shift_Assignments__c assignment : shiftAssignmentRecordsForShift2){
                members.add(assignment.Member__c);
            }

            if(members.size() > 0){
               teamAssignmentRecords = [SELECT Id, Name, Member__c, Member__r.Team_Id__c FROM Shift_Assignments__c WHERE Location__c = : locationId  AND Member__c IN : members AND Shift_Assigned__c = true AND ToTime__c = null];            
               if(teamAssignmentRecords != null){
                   for(Shift_Assignments__c teamAssign : teamAssignmentRecords){
                       teamIds.add(teamAssign.Member__r.Team_Id__c);
                   }

                   if(teamIds.size() > 0){
                       teamListHaveShiftAssign = [SELECT Id, Name FROM Team__c WHERE Id IN :teamIds];
                   }

               }
            }
               
        }
        
        return teamListHaveShiftAssign;
    }
    
    
    public List<Team__c> getAssignedTeamForOtherShift(Id locationId){

        Set<Id> members = new Set<Id>();
        Set<Id> teamIds = new Set<Id>();
        List<Shift_Assignments__c> teamAssignmentRecords = null;
        shiftAssignmentRecordsForShift3 = [SELECT Id, Name, Shift_Code__c, Member__c, Member__r.Name, Location__c, FromTime__c, ToTime__c  FROM Shift_Assignments__c WHERE Location__c = : locationId   AND Shift_Assigned__c = true AND ToTime__c=NULL];        
        if(shiftAssignmentRecordsForShift3 != null && shiftAssignmentRecordsForShift3.size() > 0){

            for(Shift_Assignments__c assignment : shiftAssignmentRecordsForShift3){
                members.add(assignment.Member__c);
            }

            if(members.size() > 0){
               teamAssignmentRecords = [SELECT Id, Name, Member__c, Member__r.Team_Id__c FROM Shift_Assignments__c WHERE Location__c = : locationId  AND Member__c IN : members AND Shift_Assigned__c = true AND ToTime__c = null];            
               if(teamAssignmentRecords != null){
                   for(Shift_Assignments__c teamAssign : teamAssignmentRecords){
                       teamIds.add(teamAssign.Member__r.Team_Id__c);
                   }

                   if(teamIds.size() > 0){
                       teamListHaveOtherShiftAssign = [SELECT Id, Name FROM Team__c WHERE Id IN :teamIds];
                   }
               }
            }
               
        }
        
        return teamListHaveOtherShiftAssign;
    }
    
    public Set<Id> getAssignedShiftAdministratorInSelectedShift(Id locationId, Id shiftId){

        List<Member__c> assignedShiftAdminMembers = null;
        assignedShiftAdminMembers = [SELECT Id, Name, First_Name__c,User_Id__c, User_Id__r.Name,Emp_ID__c, Last_Name__c, Designation__c FROM Member__c WHERE Designation__c  = 'Shift Administrator' AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Id IN (SELECT Member__c FROM Shift_Assignments__c WHERE Location__c = : locationId AND Shift_Code__c = : shiftId  AND Shift_Assigned__c = true AND ToTime__c=NULL)];    

        if(assignedShiftAdminMembers != null && assignedShiftAdminMembers.size() > 0){
            sadminList = new Set<Id>();
            for(Member__c member : assignedShiftAdminMembers){
                sadminList.add(member.Id);
            }
        }
        return sadminList;
    }   
    
    public Set<Id> getTeamAssignedForSelectShiftAdmin(Id locationId, Id shiftAdminMemberId){

        if(shiftAdminMemberId != null){
            shiftAdminTeamAssignRecords = [SELECT Id, Name, Member__r.Team_Id__c  FROM Shift_Assignments__c WHERE Location__c = : locationId  AND Shift_Assigned__c = true AND Member__c =: shiftAdminMemberId AND ToTime__c=NULL];
            if(shiftAdminTeamAssignRecords != null && shiftAdminTeamAssignRecords.size() > 0){
                for(Shift_Assignments__c assignments : shiftAdminTeamAssignRecords){
                    shiftAdminAssignedTeams = new Set<Id>();
                    shiftAdminAssignedTeams.add(assignments.Member__r.Team_Id__c);    
                }
            }
             
        }
        return shiftAdminAssignedTeams;        
    }
    
    public List<Shift_Assignments__c > getTeamAssignmentForSelectShiftAdmin(Id locationId, Id shiftAdminMemberId){
        if(shiftAdminMemberId != null){
            shiftAdminTeamAssignRecords2 = [SELECT Id, Name, Member__c, ToTime__c, Member__r.Team_Id__c , Shift_Assigned__c FROM Shift_Assignments__c WHERE Location__c = : locationId  AND Shift_Assigned__c = true AND Member__c =: shiftAdminMemberId AND ToTime__c=NULL];
        }
        
        return shiftAdminTeamAssignRecords2;        
    }
    
    
    public List<Shift_Assignments__c> getTeamAssignmentForAssignedTeam(Id shiftAdministrator){

        //         
        if(shiftAdministrator != null){
            teamRecordsForShiftAdmin = [SELECT Id, Name, Member__c, ToTime__c, Member__r.Team_Id__c, Shift_Assigned__c FROM Shift_Assignments__c WHERE ToTime__c = NULL AND Shift_Assigned__c = true AND Member__c =: shiftAdministrator];
        }
        return teamRecordsForShiftAdmin;
    }
    
    public List<Shift_Assignments__c> getShiftOnlyAssignmentForAssignedTeam(Id shiftAdministrator){

        //         
        if(shiftAdministrator != null){
            shiftOnlyRecordsForShiftAdmin= [SELECT Id, Name, Member__c, ToTime__c, Member__r.Team_Id__c, Shift_Assigned__c FROM Shift_Assignments__c WHERE ToTime__c = NULL  AND Shift_Assigned__c = true AND Member__c =: shiftAdministrator];
        }
        return shiftOnlyRecordsForShiftAdmin;
    }
    
    
    public List<Shift_Assignments__c> getOtherShiftAdminAssignmentForSelectedShift(Id shiftId){

        //         
        if(shiftId != null){
            shiftOnlyRecordsForShiftAdmin= [SELECT Id, Name, Shift_Code__c, ToTime__c, Member__c, Member__r.Designation__c, Member__r.Team_Id__c, Shift_Assigned__c FROM Shift_Assignments__c WHERE ToTime__c = NULL  AND Shift_Code__c = : shiftId AND Shift_Assigned__c = true AND Member__r.Designation__c = 'Shift Administrator'];
        }

        return shiftOnlyRecordsForShiftAdmin;
    }
    
    public List<Shift_Assignments__c> getOtherTeamShiftAdminAssignmentForSelectedShift(Id teamId){
    
        if(teamId != null){
            shiftTeamOnlyRecordsForShiftAdmin= [SELECT Id, Name, ToTime__c, Member__c, Member__r.Designation__c, Member__r.Team_Id__c, Shift_Assigned__c FROM Shift_Assignments__c WHERE ToTime__c = NULL  AND Member__r.Team_Id__c =: teamId AND Shift_Assigned__c = true AND Member__r.Designation__c = 'Shift Administrator'];
        }

        return shiftTeamOnlyRecordsForShiftAdmin;
    }
    
    public Map<Id, Integer> getAssignedMemberForTeamMemberCount(Id locationId, Set<Id> teamIds){

        List<Team__c> teamDetails = [SELECT Id, Name FROM Team__c WHERE Location__c =: locationId];

        Map<Id, Integer> membercountmap = new Map<Id, Integer>();
        if (teamIds != null && teamIds.size() > 0){
           for(Id team : teamIds){

                List<Member__c> assignedMembersInSelectedTeam = [SELECT Id, Name, Current_Shift__c, First_Name__c,User_Id__c, User_Id__r.Name,Emp_ID__c, Last_Name__c, Designation__c FROM Member__c WHERE Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Team_Id__c = : team ];
                if(assignedMembersInSelectedTeam != null && assignedMembersInSelectedTeam.size() > 0){
                    membercountmap.put(team,assignedMembersInSelectedTeam.size());
                }else{
                    membercountmap.put(team,0);
                }

            }
        }
        
        return membercountmap;
            
      }
      
     //Return the Location
    public List<Location__c> getLocations(){
     try{
        locationList = [select id,Name from Location__c where Location_Status__c =: EPMS_UTIL.EPMS_ACTIVE_STATUS ORDER BY Name ASC];
        }catch(Exception e){
          System.debug(e);  
      }
        return locationList;
    }
    
   
   
    public List<Member__c> getAssignedMemberForTeam2(Id locationId, Set<Id> teamIds){

        if (teamIds != null && teamIds.size() > 0){
            assignedMembersInSelectedTeam = [SELECT Id, Name, Current_Shift__c, First_Name__c,User_Id__c, User_Id__r.Name,Emp_ID__c, Last_Name__c, Designation__c FROM Member__c WHERE Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Id IN (SELECT Member__c FROM Shift_Assignments__c WHERE Location__c = : locationId AND Member__r.Team_Id__c IN : teamIds  AND Shift_Assigned__c = true AND ToTime__c=NULL) ORDER BY Name ASC];     
        }

        return assignedMembersInSelectedTeam;
        
      }
      
   public List<Team__c> getAssignedTeamForSelectedShift2(Id locationId, Id shiftId){

        Set<Id> members = new Set<Id>();
        Set<Id> teamIds = new Set<Id>();
        List<Shift_Assignments__c> teamAssignmentRecords = null;
        shiftAssignmentRecordsForShift2 = [SELECT Id, Name, Shift_Code__c, Member__c, Member__r.Team_Id__c, Member__r.Name, Location__c, FromTime__c, ToTime__c  FROM Shift_Assignments__c WHERE Location__c = : locationId   AND Shift_Code__c =:shiftId AND Shift_Assigned__c = true AND ToTime__c=NULL];        
        if(shiftAssignmentRecordsForShift2 != null && shiftAssignmentRecordsForShift2.size() > 0){

            for(Shift_Assignments__c assignment : shiftAssignmentRecordsForShift2){
                teamIds.add(assignment.Member__r.Team_Id__c);
            }

            if(teamIds.size() > 0){
                teamListHaveShiftAssign = [SELECT Id, Name FROM Team__c WHERE Id IN :teamIds];
            }

         }

        return teamListHaveShiftAssign;
    }
    
    public List<Member__c> getMemberNotInTeam(Id locationId){

        try{
            memberListAllLocation = [SELECT Id, Name, Location_id__c, First_Name__c, Designation__c,Emp_ID__c, Performance_Rating__r.Name FROM Member__c WHERE Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS and Location_id__c =: locationId and Team_Id__c=NULL AND Designation__c  !=  'House Keeper' AND Designation__c  !=  'Sales Region' AND Designation__c  !=  'Shift Administrator' AND Designation__c  !=  'File Manager' AND Designation__c  != 'Production Administrator' ORDER BY Name ASC];
        }catch(Exception e){
            System.debug(e);  
        }
        return memberListAllLocation;
    }
      
    public List<Member__c> getMemberNotInTeamHaveShiftAssignments(Id locationId, Id shiftId){

        try{
            memberListHaveNoTeam = [SELECT Id, User_Id__c, User_Id__r.Name, Name, Designation__c, Emp_ID__c FROM Member__c WHERE Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Id IN (SELECT Member__c FROM Shift_Assignments__c WHERE Location__c = : locationId  AND Shift_Assigned__c = true AND Shift_Code__c =: shiftId AND ToTime__c=NULL AND Member__r.Team_Id__c = null)];  
        }catch(Exception e){
            System.debug(e);  
        }
        return memberListHaveNoTeam;
    }    
    
    public List<Shift_Assignments__c> getShiftOnlyAssignmentForAssignedTeamMembers(Set<Id> memberIds){

        //         
        if(memberIds != null && memberIds.size() > 0){
            shiftOnlyRecordsForUnAssignedTeamMembers = [SELECT Id, Name, Member__c, ToTime__c, Member__r.Team_Id__c, Shift_Assigned__c FROM Shift_Assignments__c WHERE ToTime__c = NULL  AND Shift_Assigned__c = true AND Member__c IN : memberIds];
        }
        system.debug('Shift Assigned for selected un-assigned team members:::::'+shiftOnlyRecordsForUnAssignedTeamMembers);
        return shiftOnlyRecordsForUnAssignedTeamMembers;
    }
    
        // Get the shift information for input shift code 

    public Shift__c getShiftInfo(Id shiftId){
        try{
            shiftInfo = [SELECT Id, Name, Implements_From__c, Implements_To__c, Shift_Start_Time__c, Shift_End_Time__c FROM Shift__c WHERE Id =: shiftId];
        }catch(Exception e){
            System.debug(e);  
        }
        return shiftInfo;
    }
    
    public Member__c getShiftAdminMemberInfo(Id shiftAdministrator){
        try{
            if(shiftAdministrator != null){
                shiftAdminMemInfo = [SELECT Id, Name, Current_Shift__c, First_Name__c,User_Id__c, User_Id__r.Name,Emp_ID__c, Last_Name__c, Designation__c FROM Member__c WHERE Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Id =: shiftAdministrator];    
            }
            
        }catch(Exception e){
            System.debug(e);  
        }
        return shiftAdminMemInfo;
    }
    
    public List<Member__c> getUnAssignedTeamMembersInfo(Set<Id> selectedTeamMemberIds){
        try{
            if(selectedTeamMemberIds != null && selectedTeamMemberIds.size() > 0){
                unAssignedTeamMembers = [SELECT Id, Name, Current_Shift__c, First_Name__c,User_Id__c, User_Id__r.Name,Emp_ID__c, Last_Name__c, Designation__c FROM Member__c WHERE Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Id IN: selectedTeamMemberIds];    
            }
            
        }catch(Exception e){
            System.debug(e);  
        }
        return unAssignedTeamMembers;
    }
    
    // Method to get an all Assignors in selected locations--->modified by udayasri
    public List<Member__c> getAllAssignors(Id locationId){

        if (locationId != null){
            // All Assignors
            allAssignorsList = [SELECT Id, Name, First_Name__c,User_Id__c, User_Id__r.Name, Last_Name__c, Designation__c, Emp_ID__c FROM Member__c WHERE Location_id__c = : locationId AND Designation__c = 'Assignor' AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS ORDER BY Name ASC];     
        }     

      return allAssignorsList;
    }
    
    public Set<Id> getAssignedAssignorsInSelectedShift(Id locationId, Id shiftId){

        List<Member__c> assignedAssignor = null;
        assignedAssignor = [SELECT Id, Name, First_Name__c,User_Id__c, User_Id__r.Name,Emp_ID__c, Last_Name__c, Designation__c FROM Member__c WHERE Designation__c  = 'Assignor' AND Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Id IN (SELECT Member__c FROM Shift_Assignments__c WHERE Location__c = : locationId AND Shift_Code__c = : shiftId  AND Shift_Assigned__c = true AND ToTime__c=NULL)];    

        if(assignedAssignor != null && assignedAssignor.size() > 0){
            sadminList = new Set<Id>();
            for(Member__c member : assignedAssignor){
                sadminList.add(member.Id);
            }
        }
        return sadminList;
    } 

    public Set<Id> getAssignedAssignorForShift(Id shiftId){
        shiftAssignorIds = new Set<Id>();
        List<Member__c> assignedAssignorList = [SELECT Id, Name, Designation__c FROM Member__c WHERE Id IN (SELECT Member__c FROM Shift_Assignments__c WHERE Shift_Code__c = : shiftId AND Shift_Assigned__c = true AND ToTime__c=NULL)];    
        if(assignedAssignorList != null){
            for(Member__c assignment : assignedAssignorList){
                if(assignment.Designation__c == 'Assignor'){
                    shiftAssignorIds.add(assignment.Id);
                }
                
            }
        }

        return shiftAssignorIds;
    }   
    
    public Member__c getAssignorMemberInfo(Id Assignor){
        try{
            if(Assignor != null){
                AssignorMemInfo = [SELECT Id, Name, Current_Shift__c, First_Name__c,User_Id__c, User_Id__r.Name,Emp_ID__c, Last_Name__c, Designation__c FROM Member__c WHERE Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS AND Id =: Assignor];    
            }
            
        }catch(Exception e){
            System.debug(e);  
        }
        return AssignorMemInfo;
    }
    
     public List<Shift_Assignments__c> getShiftOnlyAssignmentForAssignedAssignor(Id Assignor){

        //         
        if(Assignor != null){
            shiftOnlyRecordsForAssignor= [SELECT Id, Name, Member__c, ToTime__c, Member__r.Team_Id__c, Shift_Assigned__c FROM Shift_Assignments__c WHERE ToTime__c = NULL  AND Shift_Assigned__c = true AND Member__c =:Assignor];
        }
        return shiftOnlyRecordsForAssignor;
    }
    
      public List<Shift_Assignments__c> getOtherAssignorAssignmentForSelectedShift(Id shiftId){

        //         
        if(shiftId != null){
            shiftOnlyRecordsForAssignor= [SELECT Id, Name, Shift_Code__c, ToTime__c, Member__c, Member__r.Designation__c, Member__r.Team_Id__c, Shift_Assigned__c FROM Shift_Assignments__c WHERE ToTime__c = NULL  AND Shift_Code__c = : shiftId AND Shift_Assigned__c = true AND Member__r.Designation__c = 'Assignor'];
        }

        return shiftOnlyRecordsForAssignor;
    }
    
    public list<Shift__c> getShifts(id loc){
    if(loc!=null){
    ShiftsBasedOnLoc=[select id,name from Shift__c where Shift_Location__c=:loc];
    }
    
    return ShiftsBasedOnLoc;
    
    }
      
}