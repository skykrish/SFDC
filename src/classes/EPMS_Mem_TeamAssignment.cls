/****************************************************************************
*   Class               :       EPMS_Mem_TeamAssignment                      *
*   Created Date        :       22/12/2015                                   *           
*   Description         :       Team Assignment                              *
*                               Shift_Assignments__c                         *
*   Created By          :                                                    *                       
*   Version             :       1.0                                          *            
/***************************************************************************/

public with sharing class EPMS_Mem_TeamAssignment{
    
    public SelectOption[] selectedContacts { get; set; }
    public SelectOption[] allContacts { get; set; }
    public List<SelectOption> memberTypes {get;set;}
    public string membersTypeOption{get;set;}
    // public String message { get; set; }
    // public List<Member__c> selectMember {get;set;}
    public ID selectvalue  {get;set;}
    public ID LocationID {get;set;}
    public ID temploca  {get;set;}      
    public string userProfileName {get;set;}
    public Shift_Assignments__c Shift{get;set;}
    public string CurrentShifts;
    public string CurrentTeams;
    //  public string productionAdminLocation {get;set;}    
    public string Settingtype;  
    public List<Profile> profilelist {get;set;}
    public List<Member__c> memberList {get;set;}    
    public Set<Id> RMembersID{get;set;}    
    public boolean errorFlag {get;set;}
    public string urlType    {get;set;}
    
    public string getCurrentTeams(){
        return this.CurrentTeams;              
    } 
    public void setCurrentTeams(string team)
    {
        this.CurrentTeams = team;
    }
    
    ////////////  Valid Codes Start for Team Assignment ////////////////
       
    EPMS_Mem_TeamAssignment_Service  teamAssignService = new EPMS_Mem_TeamAssignment_Service();

    // Shift Assignment service
   // EPMS_ShiftAssignmentService shiftService = new EPMS_ShiftAssignmentService();
    
    public EPMS_Mem_TeamAssignment(){
    
        List<Member__c> selectMember = new List<Member__c>();
    
        Schema.DescribeSObjectResult result = Shift_Assignments__c.SObjectType.getDescribe();
        String sfUrl=URL.getSalesforceBaseUrl().getHost();
        urlType = 'https://'+sfUrl+'/'+result.getKeyPrefix();
        
        selectedContacts = new List<SelectOption>();
        allContacts = new List<SelectOption>();
        memberTypes = new List<SelectOption>();
        getmembersType();
        errorFlag=false;
        
        Shift = new Shift_Assignments__c();
        profilelist  = teamAssignService.getProfiles();
        if(profilelist.size() > 0){
            userProfileName = profilelist[0].Name;
        }
        if(userProfileName != 'System Administrator'){
            // Retrieve the list of active members associated with logged member's location
            memberList = teamAssignService.getMemberInLocation();
            if(memberList.size()>0 && memberList!=null){
                system.debug('Inside Production List');
              String productionAdminLocation = memberList[0].Location_id__r.Name;
              LocationID = memberList[0].Location_id__c;
            } else{
                system.debug('Show Error for Production administrator does not have location in member');
            }         
        }     
    }    
    
    // Selection option for location for production admin and readonly option for shift admin 
     public List<SelectOption> getAllLocations(){
     
         temploca=selectvalue; 
         List <SelectOption> options  = new List<SelectOption>();
           options.add(new SelectOption('','--None--'));
         for(Location__c locations:teamAssignService.getAllLocations()){
            options.add(new SelectOption(locations.Id,locations.Name));
         }
        return options;
    }
    
    // Selection option for Member Type
    public List<SelectOption> getMembersType(){
    
        memberTypes.add(new SelectOption('','--None--'));
        memberTypes.add(new SelectOption('All','All Members'));
        memberTypes.add(new SelectOption('Available','Available Members'));
        return memberTypes;
    }
    
    
    // Selection for list of Team associated with location    
    public List<selectoption> getLocationTeams(){
    
        CurrentShifts = null;
        List<SelectOption> options = new List<SelectOption>();
        // Retrieve the team list from service
        List<Team__c> Teamdetails = new List<Team__c>();
        if(userProfileName != 'System Administrator'){
           Teamdetails = teamAssignService.getAllTeamList(LocationID);
        } else{
           Teamdetails = teamAssignService.getAllTeamList(selectvalue);
        }
        options.add(new SelectOption('','--None--'));
        if(Teamdetails != null){
            for(Team__c team: Teamdetails){
                options.add(new SelectOption(team.Id,team.Name));
            }
        }
        return options;
    }
       
    public void ShowPanel(){
        if(Settingtype==null){
            CurrentShifts=null;
            CurrentTeams=null;
        }
        //return null;
    } 
    
    // Selection for list of Members associated with Team    
    public void getallContacts(){
    
        RMembersID = new Set<Id>();
        List<Member__c> memberList = new List<Member__c>();
        List<Member__c> assignedMemberList = new List<Member__c>();
               
        
         if(CurrentTeams !=null){
           if(membersTypeOption=='Available'){
                memberList=teamAssignService.getmemberList(selectvalue,CurrentTeams);
            }else{
                if(membersTypeOption !=null){
                    memberList=teamAssignService.getAllMemberList(selectvalue,CurrentTeams);
                }           
            }
        }
                
        allContacts = new List<SelectOption>();
        system.debug('memberList @@@'+memberList);  
        if(memberList.size()>0 && selectvalue!=null){
            for (Member__c member : memberList) {
              if(member.Designation__c == 'Team Leader' || member.Designation__c == 'Quality Control'){
                allContacts.add(new SelectOption(member.Id,member.Emp_ID__c +' - ' + member.Name+' ('+ member.Designation__c+')'));
              }else{
                allContacts.add(new SelectOption(member.Id,member.Emp_ID__c +' - ' + member.Name  ));
              }
            }
        }
        
        selectedContacts = new List <SelectOption>();
        assignedMemberList = teamAssignService.getassignedMemberList(selectvalue,CurrentTeams);
        
        if(assignedMemberList.size()>0 && CurrentTeams !=null){
            for (Member__c assignedMember : assignedMemberList) {
                if(assignedMember.Designation__c == 'Team Leader' || assignedMember.Designation__c == 'Quality Control'){
                    selectedContacts.add(new SelectOption(assignedMember.Id, assignedMember.Emp_ID__c +' - ' + assignedMember.Name+' ('+ assignedMember.Designation__c+')'));
                }else{
                    selectedContacts.add(new SelectOption(assignedMember.Id,assignedMember.Emp_ID__c +' - ' + assignedMember.Name  ));
                }
            }
        }
        
        for(Member__c  Rmember:assignedMemberList){
            RMembersID.add(Rmember.id);
        }
        assignedMemberList.clear();
        memberList.clear();
        errorFlag=false;
    }
    
    // Save Method members to team
    public PageReference saveMemberstoTeam() {
    
        errorFlag=false;
        List<Member__c> teamMembersList = new List<Member__c>();
        Set<Id> selectMembersID = new Set<Id>();
        Set<Id> assignedTLIds = new Set<Id>();
        Set<Id> assignedQCIds = new Set<Id>();
        Set<Id> unassignedID  = new Set<Id>();
        Set<Id> assignedID  = new Set<Id>();
        
        if(selectvalue == null) {
            errorFlag=true;
            // Validation : Location            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Select_Location));
            return null;
        }
        if(CurrentTeams == null) {
            errorFlag=true;
            // Validation : Teams            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Select_Team));
            return null;
        }
        if(selectedContacts.size() == 0)
        {
            errorFlag=true;
            // Validation : Teams            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_Select_Members_to_Assign));
            return null;
        }
        if(selectedContacts!=null && CurrentTeams != null && selectvalue != null){
        
            for(SelectOption selMembers : selectedContacts){
               selectMembersID.add(selMembers.getValue());
            }
            
            Set<Id> assignedteammemberid= new Set<Id> ();
            //Id ShiftCode;
            List<Member__c> memberList = teamAssignService.getselectedmemberList(selectMembersID);
            
            // Validation Single Team Leader or Quality Checker Per File
            if(memberList.size()>0){
                Set<Id> moreTLIds = new Set<Id>();
                Set<Id> moreQCIds = new Set<Id>();
                for(Member__c selectMember : memberList){
                    if(selectMember.Designation__c == 'Quality Control'){
                        moreQCIds.add(selectMember.Id);
                    } else if(selectMember.Designation__c == 'Team Leader'){
                        moreTLIds.add(selectMember.Id);
                    }
                }
            
                // Error Handling               
                if(moreQCIds.size() > 1){
                    errorFlag=true;
                    // Only One QC Should be selected                   
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_ONE_QC));
                    return null;
                }
                if(moreTLIds.size() > 1){
                    errorFlag=true;
                    // Only One TL Should be selected
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.EPMS_MBO_ONE_TL));
                    return null;
                }
            }
            String shiftName = '';
            
            for(id newMembersID :selectMembersID){
                if((!(RMembersID.contains(newMembersID))) || RMembersID == null){                      
                    
                    Member__c newteamMembers = [select id from Member__c where id =:newMembersID];
                    newteamMembers.Team_Id__c =  CurrentTeams;
                    shiftName =  teamAssignService.getShiftNameForSelectedTeam(CurrentTeams);
                    newteamMembers.Current_Shift__c = shiftName;
                    teamMembersList.add(newteamMembers);
                }
            }
            
            for(id newMembersID :RMembersID){
                if(selectMembersID.contains(newMembersID)){
                    system.debug('Ignore the member ID :::::' + newMembersID);
                } else {
                    system.debug('Reset ID :::::::::::' + newMembersID);
                    Member__c newteamMembers = [select id from Member__c where id =:newMembersID];
                    newteamMembers.Team_Id__c =  null;
                    teamMembersList.add(newteamMembers);
                }
            }
            try {
                    update teamMembersList;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.EPMS_MBO_MEM_ASSIGN));
                    CurrentTeams = selectvalue =  membersTypeOption = null;
                    selectedContacts = new List<SelectOption>();
                    allContacts = new List<SelectOption>(); 
                    //return null;
                
            } catch(DMLException me) {
                //errorFlag = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                //return null;
            }           
        }
        return null;
    }
    
    public Pagereference Cancel(){
        return null;
    }
    
   ////////////  Valid Codes End for Team Assignment ////////////////
       
}