/****************************************************************************
*   Class               :       EPMS_ShiftAssignment (Team Based)           *
*   Created Date        :       08/09/2016                                 *           
*   Description         :       Team Assignment                             *
*                               Shift_Assignments__c                        *
*   Created By          :                                                   *                       
*   Version             :       3.0                                         *             
/***************************************************************************/

public with sharing class EPMS_Shift_Assignment_Controller{
    
    public String redirectShift { get; set; }
    public List<SelectOption> selectedContacts { get; set; }
    public List<SelectOption> selectedTeamMembers { get; set; }
    public List<SelectOption> availableTeamMembers { get; set; }
    public SelectOption[] allContacts { get; set; }
    public SelectOption[] allTeamsOption { get; set; }
    public Boolean selectTeamForSA {get;set;}
    public List<SelectOption> assignedTeamsForSA{ get; set; }
    public String message { get; set; }
    List<Team__c> teamsList {get;set;}
    public List<Member__c> selectMember {get;set;}
    public ID selectvalue  {get;set;}
    public ID shiftAdministrator {get;set;}
    public ID LocationID {get;set;}
    public ID PreviousLocation {get;set;}
    public ID temploca  {get;set;}      
    public string userProfileName {get;set;}
    public Member__c loggedMember {get;set;}
    public Shift_Assignments__c Shift{get;set;}
    public string alertMessage;
    public string CurrentShifts;
    public string CurrentTeams;
    public string productionAdminLocation {get;set;}
    public List<Profile> profilelist {get;set;}
    public List<Member__c> memberList {get;set;}
    public string assignType;
    public string selectShiftNameForDisplay {get;set;}
    public ID  prev {get;set;}
    public string basepath {get;set;}
    public Id Assignor{get;set;}
    
    
    public void settemploca(Id locaID){ 
        prev =temploca;
        temploca =locaID;
    }
    
    public string getassignType(){
        return this.assignType;              
    }    
    
    public void setAlertMessage(string alertMsg){
        this.alertMessage = alertMsg;
    }  
    
    public string getAlertMessage(){
        return this.alertMessage;              
    }   
    
    public void setAssignType(string assignType){
        this.assignType = assignType;
    }  
    
    
    public string getCurrentShifts(){
        return this.CurrentShifts;              
    }   
    
    public void setCurrentShifts(string Shifts){
        this.CurrentShifts= Shifts;
    } 
    
    public string getCurrentTeams(){
        return this.CurrentTeams;              
    }    
    
    public void setCurrentTeams(string team){
        this.CurrentTeams = team;
    }
    
   
    public EPMS_Shift_Assignment_Controller() {
         Schema.DescribeSObjectResult result = Shift_Assignments__c.SObjectType.getDescribe();
         basepath = ApexPages.currentPage().getParameters().get('type');
         
         String sfUrl=URL.getSalesforceBaseUrl().getHost();
         redirectShift = 'https://'+sfUrl+'/'+result.getKeyPrefix();
         
        
        selectedContacts = new List<SelectOption>();
        selectedTeamMembers = new List<SelectOption>();
        availableTeamMembers = new List<SelectOption>();
        teamsList = new List<Team__c>();
        allContacts = new List<SelectOption>();
        
        Shift = new Shift_Assignments__c();

        profilelist  = newService.getProfiles();
        if(profilelist.size() > 0){
            userProfileName = profilelist[0].Name;
        }
        if(userProfileName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && userProfileName!='Country Administrator'){
            // Retrieve the list of active members associated with logged member's location
            memberList = newService.getMemberInLocation();
          
            if(memberList != null &  memberList[0].Location_id__c != null){
            
                productionAdminLocation = memberList[0].Location_id__r.Name;
                
                LocationID = memberList[0].Location_id__c;
            } else{
                // Show Error for Production administrator does not have location in member
            }         
        }        
        

    }
    
    
    public void getallContacts(){
        allContacts = new List<SelectOption>();
        selectedContacts = new List<SelectOption>();
        assignedTeamsForSA = new List<SelectOption>();

        List<Team__c> teams = new List<Team__c>();
        List<Team__c> teamsAssigned = new List<Team__c>();
        List<Team__c> teamsOtherAssigned = new List<Team__c>();
        
        // Get All Assigned team for selected shift        
        if(CurrentShifts != null && selectValue != null){
            teamsAssigned = newService.getAssignedTeamForSelectedShift(selectValue,CurrentShifts); 
        } 
            
            
        if(teamsAssigned != null && teamsAssigned.size() > 0){
            for ( Team__c team : teamsAssigned) {
                selectedContacts.add(new SelectOption(team.Id, team.Name));
            }
        }

        // Get un-assigned team for selected shift
        
        if(assignType != 'All'){
           teams = newService.getAvailableTeamsInLocation(selectValue);
        } else if(assignType!=null) {
           teams = newService.getAllTeamsInLocation(selectValue,CurrentShifts);
        }
        if(CurrentShifts != null && selectValue != null && assignType != null){
            if(teamsAssigned != null && teamsAssigned.size() > 0 && teams != null && assignType != 'All'){
                // Assigned Team Exists : Remove the assigned shift from available shift
                Set<Id> assignedteam = new Set<Id>();
                for(Team__c assigned : teamsAssigned){
                    assignedteam.add(assigned.Id);
                }
                
                for (Team__c team : teams) {
                    if(assignedteam.size() > 0 && assignedteam.contains(team.Id)){
                        // Ignore the Team from assigned
                    } else{
                        allContacts.add(new SelectOption(team.Id, team.Name));
                    }
                }
            
            } else if(assignType != 'All' && teamsAssigned == null && teams != null && teams.size() > 0){

                teamsOtherAssigned = newService.getAssignedTeamForOtherShift(selectValue);

                if(teamsOtherAssigned !=null && teamsOtherAssigned.size() > 0){
                    Set<Id> teamOtherIds = new Set<Id>();
                    for(Team__c team2 : teamsOtherAssigned){
                        teamOtherIds.add(team2.Id);
                    }

                    for (Team__c team : teams) {
                        if(teamOtherIds.size() > 0 && teamOtherIds.contains(team.Id)){
                            // Ignore the Team from assigned
                        } else{
                            allContacts.add(new SelectOption(team.Id, team.Name));
                        }
                    }
                } else {
                    // No assigned team
                    for (Team__c team : teams) {
                        allContacts.add(new SelectOption(team.Id, team.Name));
                    }
               }
            } else if(teams != null){
                // No assigned team
                for (Team__c team : teams) {
                    allContacts.add(new SelectOption(team.Id, team.Name));
                }

            }
        }
                    
        if(teamsAssigned != null && teamsAssigned.size() > 0){
            teamsAssigned.clear();
        }

    }
    
   // Method for processing the un-assigned team members : Assignment and Un-Assignment
   public PageReference save_new() {
        
        if(selectValue == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_SELECT_LOCATION));
            return null;
        }
        
        if(CurrentShifts == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_SELECT_SHIFT));
            return null;
        }
        
        if(selectedTeamMembers.size() == 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SELECT_UN_ASSIGN_TEAM_MEMBER));
            return null;
        }
        
        List<Shift_Assignments__c> shiftupdateRecords2 = new List<Shift_Assignments__c>();
        
        
        // Get the selected team member Ids for insert or update the shift assignments
        Set<Id> selectedTeamMemberIds = new Set<Id>();
        if(selectedTeamMembers != null && selectedTeamMembers.size() > 0){
            for(SelectOption selectedvalue : selectedTeamMembers){
                selectedTeamMemberIds.add(selectedvalue.getValue());
            } 

        }
        
        if(selectedTeamMemberIds.size() > 0){
            List<Shift_Assignments__c> shiftAssignmentforNonTeam = null;
            shiftAssignmentforNonTeam = newService.getShiftOnlyAssignmentForAssignedTeamMembers(selectedTeamMemberIds);
            // Update the existing shift records of selected shift Administrator in shift(type) assignments
            if(shiftAssignmentforNonTeam != null && shiftAssignmentforNonTeam.size() > 0){
                for(Shift_Assignments__c nonTeamMember : shiftAssignmentforNonTeam){
                    nonTeamMember.ToTime__c = system.today();
                    nonTeamMember.Shift_Assigned__c = false;
                    shiftupdateRecords2.add(nonTeamMember);
                }
            }
            
            // Add the current shift into Member Table
            List<Member__c> newUpdatedMembers = new List<Member__c>();
            Shift__c newShift = newService.getShiftInfo(currentShifts);
           
            String shiftName = '';
            if(newShift != null){
                shiftName = newShift.Name;
            }
            
            // Insert New record for Selected Members to shift assignment directly
            for(Id memberId : selectedTeamMemberIds){
                Shift_Assignments__c record = new Shift_Assignments__c();
           
                record.FromTime__c = system.today();
                record.Shift_Assigned__c= true;
                record.Shift_Code__c=CurrentShifts;
                if(userProfileName!=EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && userProfileName!='Country Administrator'){
                    record.Location__c = LocationID ;
                }else{
                    record.Location__c = selectValue;   
                }
                record.Member__c = memberId;
                shiftupdateRecords2.add(record);                
            }
            
            // Update the current Shift in All the members in un-assigned team
            List<Member__c> getUnAssignedTeamMembers = null;
            if(selectedTeamMemberIds.size() > 0){
                getUnAssignedTeamMembers = newService.getUnAssignedTeamMembersInfo(selectedTeamMemberIds);
                if(getUnAssignedTeamMembers != null && getUnAssignedTeamMembers.size() > 0){
                    for(Member__c member : getUnAssignedTeamMembers){
                        member.Current_Shift__c = shiftName;
                        newUpdatedMembers.add(member);
                    }
                }
                
            }
            
            
            //return null;
            // Update Existing record or Insert the new shift assignment records.
            if(shiftupdateRecords2.size() > 0){
        
                try {
                    upsert shiftupdateRecords2;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_SHIFT_MEM_ASSGN));
                    CurrentShifts = null;
                    selectedTeamMembers = new List<SelectOption>();
                    availableTeamMembers = new List<SelectOption>();
                    selectValue = null;
                } catch(DMLException me) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                    return null;
                }
        
            } 
            
            if(newUpdatedMembers.size() > 0){
        
                try {
                    update newUpdatedMembers;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_SHIFT_UPDATE_TODAY_SHIFT));
                } catch(DMLException me) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                    return null;
                }
        
            } 
            
        }
        
        return null;
    
    }
   
   
   
   
   
    // Method for processing the team : Assignment and Un-Assignment of team member in Shift Assignments
    public PageReference save() {
        message = 'Selected Members are: ';

        List<Team__c> teams = new List<Team__c>();
        List<Member__c> assignedMemberForTeam = new List<Member__c>();
        Set<Id> shiftAdminis = new Set<Id>();
        Set<Id> AssignorList = new Set<Id>();
        
        // Basic validation for shift assignment screen
        if(selectValue != null && CurrentShifts != null){
            shiftAdminis = newService.getAssignedShiftAdministratorInSelectedShift(selectValue,CurrentShifts);
        }
            
        
        if(selectValue == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_SELECT_LOCATION));
            return null;
        }
        
        if(CurrentShifts == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_SELECT_SHIFT));
            return null;
        }
        
       
        /*if(selectedContacts.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_SELECT_ATLEAST_ONE_TEAM));
            return null;
        }*/
        
        Set<Id> shiftAdmins = new Set<Id>();
        if(CurrentShifts != null){
            shiftAdmins = newService.getAssignedShiftAdminForShift(CurrentShifts);
        }
        
        // If no shift admin exists in shift assignment , through error
        if(shiftAdmins.size() == 0 && (shiftAdministrator == null && Assignor == null)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_NO_SHIFT_ADMIN));
            return null;
        }
        
        // Existing Teams already assigned to selected shift
        List<Team__c> teamsAssigned = null;
        Set<Id> existingTeamIds = new Set<Id>();
        // Get All Assigned team for selected shift        
        if(CurrentShifts != null && selectValue != null){
            teamsAssigned = newService.getAssignedTeamForSelectedShift(selectValue,CurrentShifts); 

            if(teamsAssigned != null && teamsAssigned.size() > 0){
                for(Team__c existingTeam : teamsAssigned){
                    existingTeamIds.add(existingTeam.Id);
                }
            }
        }
        
        // Get the selected team Ids for insert or update the shift assignments
        Set<Id> selectedTeamIdsCheck = new Set<Id>();
        if(selectedContacts != null && selectedContacts.size() > 0){
            for(SelectOption selectedvalue : selectedContacts){
                selectedTeamIdsCheck.add(selectedvalue.getValue());
            } 

        }
        
        List<Member__c> memberForTeam = null;
        if(selectedTeamIdsCheck.size() > 0) {
            memberForTeam = newService.getAssignedMemberForTeam(selectValue,selectedTeamIdsCheck);

            if(memberForTeam == null || memberForTeam.isEmpty()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_NO_MEMBER_IN_TEAM));
                return null;
            }
            // Team Name Display : No Members in Selected Teams
            Map<Id, String> teamName = new Map<Id, String>();
            List<Team__c> teamDetails = newService.getAllTeamList(selectvalue);
            if(teamDetails != null){
                for(Team__c t : teamDetails){
                    teamName.put(t.Id, t.Name);
                }
            }

            Map<Id, Integer> memberForTeamCount = newService.getAssignedMemberForTeamMemberCount(selectValue, selectedTeamIdsCheck);
            
            List<String> errorMessages = new List<String>();

            if(memberForTeamCount != null && memberForTeamCount.size() > 0){
                for(Id selectTeam : selectedTeamIdsCheck){
                    if(teamDetails != null){
                        String errorMessage = '';
                        Integer size = memberForTeamCount.get(selectTeam);
                        if(size == 0){
                            errorMessage = ' Team : ' + teamName.get(selectTeam);
                            errorMessages.add(errorMessage);
                        }
                    }
                }
            }
            if(errorMessages != null && errorMessages.size() > 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_NO_MEMBER_IN_TEAM + errorMessages));
                return null;
            }
        }
        

        
        List<Shift_Assignments__c> shiftupdateRecords = new List<Shift_Assignments__c>();
        // Get the shift administrator (member) records
        Member__c shiftAdminMemberInfo = newService.getShiftAdminMemberInfo(shiftAdministrator);
        if(shiftAdmins.size() > 0 && shiftAdministrator != null){

            if(shiftAdmins.contains(shiftAdministrator)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_SHIFT_ADMIN_ALREADY_ASSGN));
                return null;
            }
        }
        
        // Prepare the shift assignment record for shift Administrator
        if (shiftAdministrator != null) {
            
            List<Shift_Assignments__c> shiftAssignmentOfSA = null;
            shiftAssignmentOfSA = newService.getShiftOnlyAssignmentForAssignedTeam(shiftAdministrator);
            // Update the existing shift records of selected shift Administrator in shift(type) assignments
            if(shiftAssignmentOfSA != null && shiftAssignmentOfSA.size() > 0){
                for(Shift_Assignments__c admin : shiftAssignmentOfSA){
                    admin.ToTime__c = system.today();
                    admin.Shift_Assigned__c = false;
                    shiftupdateRecords.add(admin);
                }
            } 

            // Update the other shift administrator records in shift assignment
            
            List<Shift_Assignments__c> shiftOtherAssignmentOfSA = null;
            shiftOtherAssignmentOfSA = newService.getOtherShiftAdminAssignmentForSelectedShift(CurrentShifts);
            
            // Update the existing shift records of selected shift Administrator in shift(type) assignments
            if(shiftOtherAssignmentOfSA != null && shiftOtherAssignmentOfSA.size() > 0){
                for(Shift_Assignments__c admin : shiftOtherAssignmentOfSA){
                    admin.ToTime__c = system.today();
                    admin.Shift_Assigned__c = false;
                    shiftupdateRecords.add(admin);
                }
            } 
            
            // Insert SHIFT ADMIN IN Shift ASSIGNMENT

            Shift_Assignments__c record = new Shift_Assignments__c();
               
            record.FromTime__c = system.today();
            record.Shift_Assigned__c= true;
            record.Shift_Code__c=CurrentShifts;
            if(userProfileName!=EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && userProfileName!='Country Administrator'){
                record.Location__c = LocationID ;
            }else{
                record.Location__c = selectValue;   
            }
            record.Member__c = shiftAdministrator;
            shiftupdateRecords.add(record);
            // Add the current shift into Member Table
            Shift__c newShift = newService.getShiftInfo(currentShifts);
           
            String shiftName = '';
            if(newShift != null){
                shiftName = newShift.Name;
            }
            if(shiftAdminMemberInfo != null){
                shiftAdminMemberInfo.Current_Shift__c = shiftName;
              
            }
        }
        
        
        // Get the selected team Ids for insert or update the shift assignments
        Set<Id> selectedTeamIds = new Set<Id>();
        if(selectedContacts != null && selectedContacts.size() > 0){
            for(SelectOption selectedvalue : selectedContacts){
                selectedTeamIds.add(selectedvalue.getValue());
            } 

        }
        
        Set<Id> updtExistingteam = new Set<Id>();
        if(existingTeamIds != null && selectedTeamIds != null){
        
            for(Id exist : existingTeamIds){
                if(!selectedTeamIds.contains(exist)){
                    updtExistingteam.add(exist);
                }else{
                
                }
            }
            
            for(Id selects : selectedTeamIds){
                if(!existingTeamIds.contains(selects)){
                    updtExistingteam.add(selects);
                }else{
                
                }
            }
            
        
        }
        
        Set<Id> teamIds = new Set<Id>();
        Set<Id> updateTeamIds = new Set<Id>();
        Set<Id> tobeInsertMemberIDs = new Set<Id>();
        Set<Id> tobeUpdatedMemberIDs = new Set<Id>();
        List<Shift_Assignments__c> updateRecords = new List<Shift_Assignments__c>();
        if(updtExistingteam.size() > 0) {
                
                List<Member__c> assignedMemberForTeamtobeupdt = new List<Member__c>();

                assignedMemberForTeamtobeupdt = newService.getAssignedMemberForTeam(selectValue,updtExistingteam);
        
                if(assignedMemberForTeamtobeupdt == null || assignedMemberForTeamtobeupdt.isEmpty()){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_NO_MEMBER_IN_SEL_TEAM));
                    return null;
                }
                Set<Id> shiftAdminIdForTeam = new Set<Id>();
                if(assignedMemberForTeamtobeupdt != null && assignedMemberForTeamtobeupdt.size() > 0){
                    for(Member__c member : assignedMemberForTeamtobeupdt){

                        if(member.Designation__c != 'Shift Administrator'){
                            tobeUpdatedMemberIDs.add(member.Id);
                        } else if(member.Designation__c == 'Shift Administrator'){
                            shiftAdminIdForTeam.add(member.Id);
                        }
                                  
                    }
                    
                    if(tobeUpdatedMemberIDs.size() > 0){

                        // Get Shift Assignment Details
                        List<Shift_Assignments__c> shiftAssignmentrecordsForUpdate = new List<Shift_Assignments__c>();
                        List<Shift_Assignments__c> shiftAdminForUpdateShift = new List<Shift_Assignments__c>();
                        List<Shift_Assignments__c> teamAssignmentExOfShiftAdmin = null;
                        shiftAssignmentrecordsForUpdate = newService.getShiftAssignmentforTeamMember(selectValue,tobeUpdatedMemberIDs);

                        if(shiftAssignmentrecordsForUpdate != null && shiftAssignmentrecordsForUpdate.size() > 0){
                            for(Shift_Assignments__c assignUpdate : shiftAssignmentrecordsForUpdate){
                                assignUpdate.ToTime__c = system.today();
                                assignUpdate.Shift_Assigned__c = false;
                                updateRecords.add(assignUpdate);
                            }
                        }
                        // Add the current shift into Member Table
                        List<Member__c> newUpdatedMembers = new List<Member__c>();
                        String shiftName = '';

                        // Update the current Shift in All the members in un-assigned team
                        List<Member__c> getUnAssignedTeamMembers = null;
                        if(tobeUpdatedMemberIDs.size() > 0){
                            getUnAssignedTeamMembers = newService.getUnAssignedTeamMembersInfo(tobeUpdatedMemberIDs);
                            if(getUnAssignedTeamMembers != null && getUnAssignedTeamMembers.size() > 0){
                                for(Member__c member : getUnAssignedTeamMembers){
                                    member.Current_Shift__c = shiftName;
                                    newUpdatedMembers.add(member);
                                }
                            }
                            
                        }
                       
                       
                        // If Shift Admin exists in un-assigned team, un-assigned from team assignment also
                        if(shiftAdminIdForTeam.size() > 0){
                            Id ShiftAdmin = null;
                            for(Id Id : shiftAdminIdForTeam){
                                ShiftAdmin = Id;
                                break;
                            }
                            
                            teamAssignmentExOfShiftAdmin = newservice.getTeamAssignmentForAssignedTeam(ShiftAdmin);
                            if(teamAssignmentExOfShiftAdmin != null && teamAssignmentExOfShiftAdmin.size() > 0){
                                for(Shift_Assignments__c assignteamUpdate : teamAssignmentExOfShiftAdmin){
                                    assignteamUpdate.ToTime__c = system.today();
                                    assignteamUpdate.Shift_Assigned__c = false;
                                    updateRecords.add(assignteamUpdate);
                                }
                            } else{
                                //No Shift Admin records exists in team assignments
                            }

                        }
                        
                        if(updateRecords.size() > 0){
                            try {
                                update updateRecords;
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_UN_ASSIGNED_FROM_SHIFT));
                            } catch(DMLException me) {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                                return null;
                            }
                        }
                        
                        // Update Member's Current shift
                        if(newUpdatedMembers.size() > 0){
                    
                            try {
                                update newUpdatedMembers;
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_SHIFT_UPDATE_TODAY_SHIFT));
                            } catch(DMLException me) {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                                return null;
                            }
                    
                        } 
                    }
                }
            }
        // For Preparing the insert records for shift assignment

        if(selectedTeamIds != null && !selectedContacts.isEmpty() ){
            List<Member__c> assignedMemberForTeamtobeinsert = new List<Member__c>();

            Set<Id> newTeamIds = new Set<Id>();
            if(existingTeamIds != null ){
                for(Id teamId : selectedTeamIds){
                    if(!existingTeamIds.contains(teamId)){
                        newTeamIds.add(teamId);
                    }
                } 
            }

            Set<Id> existingMembers = new Set<Id>();
            List<Member__c> assignedMemberForAlreadyAssignedTeam  = new List<Member__c>();
            if(existingTeamIds != null){
                assignedMemberForAlreadyAssignedTeam = newService.getAssignedMemberForTeam(selectValue,existingTeamIds);

                for(Member__c members : assignedMemberForAlreadyAssignedTeam){
                    existingMembers.add(members.Id);
                }
            } 
            assignedMemberForTeamtobeinsert= newService.getAssignedMemberForTeam(selectValue,selectedTeamIds);

            if(assignedMemberForTeamtobeinsert!= null && assignedMemberForTeamtobeinsert.size() > 0){
                    List<Shift_Assignments__c> makeRecords = new List<Shift_Assignments__c>(); 
                    // Add the current shift into Member Table
                    List<Member__c> newUpdatedMembers = new List<Member__c>();
                    Shift__c newShift = newService.getShiftInfo(currentShifts);
                   
                    String shiftName = '';
                    if(newShift != null){
                        shiftName = newShift.Name;
                    }
                  
                    Date fromDateTime = system.today();
                    for(Member__c memberId : assignedMemberForTeamtobeinsert){
                    
                        if((!existingMembers.contains(memberId.Id)) || (existingTeamIds.size()== 0)){
                            Shift_Assignments__c record = new Shift_Assignments__c();
                               
                            record.FromTime__c = fromDateTime;
                            record.Shift_Code__c = currentShifts;
                            record.Shift_Assigned__c= true;
                            if(userProfileName!=EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && userProfileName!='Country Administrator'){
                                record.Location__c = LocationID ;
                            }else{
                                record.Location__c = selectValue;   
                            }

                            record.Member__c = memberId.Id;
                            record.Team_Assignment_Id__c = memberId.Team_Id__r.Name;
                            if(memberId.Designation__c != 'Shift Administrator'){
                                 makeRecords.add(record);
                            }
                            //makeRecords.add(record);
                            memberId.Current_Shift__c = shiftName;
                            newUpdatedMembers.add(memberId);
                          
                        }
                    }
                    
                    // Insert the records into shift assignment
                    if(makeRecords.size() > 0) {
                        try {
                            insert makeRecords;
                            selectedContacts = new List<SelectOption>();
                            allContacts = new List<SelectOption>();
                            //selectvalue = null;
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_ASSIGNED_TO_SHIFT));
                        } catch(DMLException me) {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                        }
                    }

                    // Update the member information.
                    if(newUpdatedMembers.size() > 0){
                         try {
                            update newUpdatedMembers;
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_SHIFT_UPDATE_TODAY_SHIFT));
                        } catch(DMLException me) {
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                        }
                    }

                 }           
            
        }

        if(shiftupdateRecords.size() > 0){
        
            try {
                upsert shiftupdateRecords;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_SHIFT_ADMIN_ASSGN));
                shiftAdministrator = null;
                selectValue = null;
            } catch(DMLException me) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                return null;
            }
        
        } 
        
        // Update the current Shift in selected shift administrator records
        
        if(shiftAdminMemberInfo != null){
            
            try {
                update shiftAdminMemberInfo;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_SHIFT_UPDATE_TODAY_SHIFT_ADMIN));
            } catch(DMLException me) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                return null;
            }
        }
        
        //modified by udayasri
         // Basic validation for shift assignment screen
        if(selectValue != null && CurrentShifts != null){
            AssignorList = newService.getAssignedAssignorsInSelectedShift(selectValue,CurrentShifts);
        }
        
        Set<Id> shiftAssignors = new Set<Id>();
        if(CurrentShifts != null){
            shiftAssignors = newService.getAssignedAssignorForShift(CurrentShifts);
        }
        
        
         // Get the Assignors (member) records
        Member__c assignorMemberInfo  = newService.getAssignorMemberInfo(Assignor);
        if(shiftAssignors.size() > 0 && Assignor != null){

            if(shiftAdmins.contains(Assignor)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_SHIFT_ASSGN3_TEAM_SHIFT_ADMIN_ALREADY_ASSGN));
                return null;
            }
        }
        
        // Prepare the shift assignment record for Assignors
        if (Assignor != null) {
            
            List<Shift_Assignments__c> shiftAssignmentOfA = null;
            shiftAssignmentOfA = newService.getShiftOnlyAssignmentForAssignedAssignor(Assignor);
            // Update the existing shift records of selected shift Administrator in shift(type) assignments
            if(shiftAssignmentOfA != null && shiftAssignmentOfA.size() > 0){
                for(Shift_Assignments__c assign : shiftAssignmentOfA){
                    assign.ToTime__c = system.today();
                    assign.Shift_Assigned__c = false;
                    shiftupdateRecords.add(assign);
                }
            } 

            // Update the other shift administrator records in shift assignment
            
            List<Shift_Assignments__c> shiftOtherAssignmentOfA = null;
            shiftOtherAssignmentOfA = newService.getOtherAssignorAssignmentForSelectedShift(CurrentShifts);
            
            // Update the existing shift records of selected shift Administrator in shift(type) assignments
            if(shiftOtherAssignmentOfA != null && shiftOtherAssignmentOfA.size() > 0){
                for(Shift_Assignments__c assign : shiftOtherAssignmentOfA){
                    assign.ToTime__c = system.today();
                    assign.Shift_Assigned__c = false;
                    shiftupdateRecords.add(assign);
                }
            } 
            
            // Insert SHIFT ADMIN IN Shift ASSIGNMENT

            Shift_Assignments__c record = new Shift_Assignments__c();
               
            record.FromTime__c = system.today();
            record.Shift_Assigned__c= true;
            record.Shift_Code__c=CurrentShifts;
            if(userProfileName!=EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && userProfileName!='Country Administrator'){
                record.Location__c = LocationID ;
            }else{
                record.Location__c = selectValue;   
            }
            record.Member__c = Assignor;
            shiftupdateRecords.add(record);
            // Add the current shift into Member Table
            Shift__c newShift = newService.getShiftInfo(currentShifts);
           
            String shiftName = '';
            if(newShift != null){
                shiftName = newShift.Name;
            }
            if(assignorMemberInfo != null){
                assignorMemberInfo.Current_Shift__c = shiftName;
              
            }
        }
        
          
        return null;
    }
     


    // Shift Assignment service

    EPMS_Shift_Assignment_Service_New newService = new EPMS_Shift_Assignment_Service_New();
     // Selection option for location
     public List<SelectOption> getLocations(){     
          
         List <SelectOption> options  = new List<SelectOption>();
           options.add(new SelectOption('','--None--'));
         for(Location__c locations: newService.getLocations()){
            options.add(new SelectOption(locations.Id,locations.Name));
         }
        return options;
    }

    public List<selectoption> getAllShiftAdministrators(){
        List<SelectOption> options = new List<SelectOption>();
        List<Member__c> shiftAdminList = new List<Member__c>();
        options.add(new SelectOption('','--None--'));
        shiftAdminList = newService.getAllShiftAdministrator(selectvalue);
        if(selectvalue==NULL){
     
           return options; 
        }

        if(shiftAdminList != null){
            for(Member__c mem : shiftAdminList){
            
            if(mem.Performance_Rating__r.Name==null){
            
            options.add(new SelectOption(mem.Id,mem.Name+'-'+ mem.Emp_ID__c ));
            }
            else{
                options.add(new SelectOption(mem.Id,mem.Name+'-'+mem.Performance_Rating__r.Name+' - ' + mem.Emp_ID__c ));
            }
            }
        } 
        
        
        return options;
    }
    

   public Pagereference Cancel(){
        return null;
    }
    
    // Selection for list of shift associated with location    
    public List<selectoption> getShifts(){
    
        CurrentTeams = null;
        List<SelectOption> options = new List<SelectOption>();
        List<Shift__c> Shiftdetails= new List<Shift__c>();
        options.add(new SelectOption('','--None--'));
        // Retrieve the shift list from service
        if(userProfileName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && userProfileName!='Country Administrator'){
           Shiftdetails= newService.getAllShiftListForSelectedLocation(LocationID);
        } else{
           Shiftdetails= newService.getAllShiftListForSelectedLocation(selectvalue);
        }
        if(Shiftdetails != null){
            for(Shift__c shift: Shiftdetails){
                options.add(new SelectOption(shift.Id,shift.Name));
            }
        } 
        return options;
    }
    
    // Selection for list of Team associated with location    
    public List<selectoption> getTeams(){
    
        CurrentShifts = null;

        List<SelectOption> options = new List<SelectOption>();
        // Retrieve the team list from service
        List<Team__c> Teamdetails = new List<Team__c>();
        if(userProfileName != EPMS_UTIL.EPMS_SYS_ADMIN_PROFILE_NAME && userProfileName!='Country Administrator'){
           Teamdetails = newService.getAllTeamList(LocationID);
        } else{
           Teamdetails = newService.getAllTeamList(selectvalue);
        }
        
        options.add(new SelectOption('','--None--'));

        if(Teamdetails != null){
            for(Team__c team: Teamdetails){
                options.add(new SelectOption(team.Id,team.Name));
            }
        }       
        
        return options;
    }
    
    // Selection option for location for production admin and readonly option for shift admin 
     public List<SelectOption> getlocation(){
     
         temploca=selectvalue; 
         List <SelectOption> options  = new List<SelectOption>();
           options.add(new SelectOption('','--None--'));
         for(Location__c locations:newService.getAllLocations()){
            options.add(new SelectOption(locations.Id,locations.Name));
         }
        return options;
    }
    
    
    // Selection for assigned or un-assigned    
    public List<SelectOption> getAssignmentType(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('All','All Teams'));
        options.add(new SelectOption('Available','Available Teams'));

        if(prev!=NULL && prev!=selectvalue){
            //options=null; 
        }        
        return options;        
    }
    
    public void ShowPanel(){
        
        if(selectvalue == null){
            selectedContacts = new List<SelectOption>();
            allContacts = new List<SelectOption>();
        }
        
    } 

    public List<SelectOption> getMemberNotInTeam(){
     
         temploca=selectvalue; 

         List <SelectOption> options  = new List<SelectOption>();
         availableTeamMembers = new List<SelectOption>();

         if(selectvalue == null){
             return options; 
         }
         List<Member__c> availableUnAssignedTeamMembersInLocation = newService.getMemberNotInTeam(selectvalue);
         
         if(availableUnAssignedTeamMembersInLocation != null && availableUnAssignedTeamMembersInLocation.size() > 0){
             for(Member__c Memberss : availableUnAssignedTeamMembersInLocation){
             if(Memberss.Performance_Rating__r.Name==null){
                availableTeamMembers.add(new SelectOption(Memberss.Id,Memberss.Name+' - '+Memberss.Emp_ID__c));
             }
             else{
             
             availableTeamMembers.add(new SelectOption(Memberss.Id,Memberss.Name+' - '+Memberss.Performance_Rating__r.Name+' - '+Memberss.Emp_ID__c));
             }
             }
         }
         
         
         if(availableTeamMembers.size() == 0){
             availableTeamMembers.add(new SelectOption('','--None--'));
         }
         
         if(availableUnAssignedTeamMembersInLocation != null && availableUnAssignedTeamMembersInLocation.size() > 0){
             availableUnAssignedTeamMembersInLocation.clear();
         }
        return availableTeamMembers;
    }
    
     public List<Member__c> getMemberNotInTeamHaveAssignments(){
         
         Shift__c  shiftInfo = null;
         if(currentShifts != null){
             shiftInfo = newService.getShiftInfo(currentShifts);
         }
         if(shiftInfo != null){
             selectShiftNameForDisplay = shiftInfo.Name;
         }
         List<Member__c> memberShiftAss = newService.getMemberNotInTeamHaveShiftAssignments(selectvalue,currentShifts);
     
         return memberShiftAss;
     }
     
    

}