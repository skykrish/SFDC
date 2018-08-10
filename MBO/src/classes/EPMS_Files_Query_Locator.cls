/****************************************************************************
*   Class               :       Files Query Locator                         *
*   Created Date        :       20/01/2016                                  *           
*   Description         :       To return the requested Result              *
*                               based on the request by service class       *
*                               will be used as the Common Class            *
*   Created By          :                                                   *                       
*   Version             :       1.0                                         *            
/***************************************************************************/ 

public class EPMS_Files_Query_Locator{

    public List<Member__c> availableTeamLeaders = null;
    public List<Member__c> assignedTeamLeaders = null;
    public List<Member__c> assignedTeamLeadersInShift = null;
    public List<Member__c> assignedQCInTeam = null;
    public List<Member__c> availableQCInTeam = null;
    public List<Member__c> availableTeamLeaderInTeam = null;
    public List<Shift_Assignments__c> availableTeamLeaderTeamAssignments = null;
    public List<Team__c> availableTeamForTeamLeader = null;
    public List<Team__c> teamdetails = null;
    public Set<Id> teamIds = new Set<Id>();
    public Set<Id> TeamLeadersTeamAssignmentInfo {get;set;}
    
    public List<Member__c> getTeamLeadersShiftAssignmentInfo(String shiftId){
        String today = Date.today().format();
        Date fromdt = null;
        if(String.isNotEmpty(today)){
            fromdt = Date.parse(today);
        }
        assignedTeamLeadersInShift = [SELECT Id, Name, Designation__c FROM Member__c WHERE Designation__c ='Team Leader' AND Id IN (select Member__c from Shift_Assignments__c where Shift_Code__c =: shiftId  AND Shift_Assigned__c = true AND (FromTime__c <=: fromdt AND (ToTime__c >:fromdt OR ToTime__c = null)) )];
     
        return assignedTeamLeadersInShift;
    
    }
    
    public Set<Id> getTeamLeadersTeamAssignmentInfo(String locationId){
        String today = Date.today().format();
        Date fromdt = null;
        if(String.isNotEmpty(today)){
            fromdt = Date.parse(today);
        }

        availableTeamLeaderInTeam = [SELECT Id, Name, Designation__c FROM Member__c WHERE Designation__c ='Team Leader' AND Id IN (select Member__c from Shift_Assignments__c where Location__c =: locationId  AND Shift_Assigned__c = true AND (FromTime__c <=: fromdt AND (ToTime__c >:fromdt OR ToTime__c = null)) )];
                   
        if(availableTeamLeaderInTeam != null && availableTeamLeaderInTeam.size() > 0){
            availableTeamLeaderTeamAssignments = [select Id, Name, Member__c, Member__r.Name, Member__r.Team_Id__c from Shift_Assignments__c where Location__c =: locationId  AND Shift_Assigned__c = true AND Member__r.Designation__c ='Team Leader' AND (FromTime__c <=: fromdt AND (ToTime__c >:fromdt OR ToTime__c = null))];
        }
        if(availableTeamLeaderTeamAssignments != null && availableTeamLeaderTeamAssignments.size() > 0){
            for(Shift_Assignments__c assignment : availableTeamLeaderTeamAssignments){
                teamIds.add(assignment.Member__r.Team_Id__c);
            }
        } 

        return teamIds;
    
    }

    public List<Member__c> getQcTeamAssignmentInfo(String teamId){
        String today = Date.today().format();
        Date fromdt = null;
        if(String.isNotEmpty(today)){
            fromdt = Date.parse(today);
        }

        assignedQCInTeam = [SELECT Id, Name, Designation__c,Status__c,Location_id__c,User_Id__c,Team_Id__c FROM Member__c WHERE Designation__c ='Quality Control' AND User_Id__c!=NULL AND Team_Id__c!=NULL AND
                           Id IN (select Member__c from Shift_Assignments__c where Member__r.Team_Id__c =:teamId  AND Shift_Assigned__c = true AND (FromTime__c <=: fromdt AND (ToTime__c >:fromdt OR ToTime__c = null)) )];
                
        // Check the QC member is present today
        if(assignedQCInTeam != null){
            if(teamId != null && fromdt != null && assignedQCInTeam.size() > 0){
                availableQCInTeam = [SELECT Id, Name, Designation__c,Status__c,Location_id__c,User_Id__c,Team_Id__c FROM Member__c WHERE Status__c='Active' AND Designation__c ='Quality Control' 
                                    AND Id NOT IN (select Employee_Name__c from Shift_Attendance__c where Employee_Name__c IN : assignedQCInTeam AND Attendance_Date__c =: fromdt) AND Team_Id__c!=NULL
                                    AND User_Id__c!=NULL];            
            }
        }

        return availableQCInTeam;       
       
    
    }
   
    
    public List<Member__c> getAvailableTeamLeaderToday(String teamId){
        String today = Date.today().format();
        Date fromdt = null;
        if(String.isNotEmpty(today)){
            fromdt = Date.parse(today);
        }
        
        assignedTeamLeaders = [SELECT Id, Name, Designation__c FROM Member__c WHERE Designation__c ='Team Leader' AND Id IN (select Member__c from Shift_Assignments__c where Member__r.Team_Id__c =: teamId  AND Shift_Assigned__c = true AND (FromTime__c <=: fromdt AND (ToTime__c >:fromdt OR ToTime__c = null)) )];            
        Set<Id> availableTL = new Set<Id>();
        if(assignedTeamLeaders != null && assignedTeamLeaders.size() > 0){
            for (Member__c member : assignedTeamLeaders){
                availableTL.add(member.Id);
            }
        }
       
        // Check the selected Team member is present today
        if(teamId != null && fromdt != null && availableTL.size() > 0){
            availableTeamLeaders = [SELECT Id, Name, Designation__c FROM Member__c WHERE Designation__c ='Team Leader' AND Id IN (select Employee_Name__c from Shift_Attendance__c where Employee_Name__c IN : availableTL AND Attendance_Date__c =: fromdt AND Attendance_Status__c = 'P')];            
        }
        return availableTeamLeaders;
    }
    
    
    public List<Team__c> getTeamDetails(Set<Id> teamIds){
        try{            
            teamdetails = [select id,Name from Team__c WHERE Id IN: teamIds];
            
        }catch(Exception e){
            System.debug(e);  
        }
        return teamdetails;
    }
      
    
    public list<Location__c> getlocationsquery()
    {
        list<Location__c> loc =[select id ,name from Location__c where Location_Status__c ='Active'];
        return loc;
    }   
    
    public list<Files__c> getFileCheck(list<String> reqids)
    {
        list<Files__c> filechecking = [Select Name,File_Location__c,Qc_Assigment_Time__c,File_Type__c,id,Production_Order__c,Production_Order__r.Mbo_Location__c 
                                        from Files__c where id IN:reqids AND File_Type__c!='Instruction'];
        return filechecking ;
    }
    
    public list<Files__c> getFilesList(list<String> reqids)
    {
        list<Files__c> Fileslist = [Select QCIncharge__c,File_Location__c,File_Type__c,Qc_Assigment_Time__c from Files__c where id IN:reqids AND File_Type__c!='Instruction']; 
        return Fileslist;
    }
  
    
    public List<Shift__c> getShift(String PLocation)
    {
        List<Shift__c> shiftlist = [select Id, Name from Shift__c where Shift_Location__c=:PLocation AND Status__c='Active' and Implements_From__c <=TODAY ];
        return shiftlist;
    }
    
    public List<Shift_Assignments__c> getShiftMemberlist(String selShift)
    {
        List<Shift_Assignments__c> memshiftlist = [select Name,Member__c from Shift_Assignments__c where Shift_Code__c =:selShift]; 
        return memshiftlist;
    }
    public list<Member__c> getteammembers(set<id> teamids,string location)
    {
        list<member__c> teammember = [select Team_id__c from Member__c where id IN:teamids and location_id__c=:location];
        return teammember;
    }
    public List<Team__c> getTeam(set<id> memids,string location)
    {
        List<Team__c> teamlist =  [Select id, Name from Team__c where id IN:memids and Location__c=:location];
        return teamlist;
    }
    public list<Member__c> getmembers(string Selteam,String Location)
    {
        list<Member__c> memlist = [Select Name,id,Location_id__c,Performance_Rating__r.Name from Member__c where Team_id__c =:Selteam and location_id__c=:Location and Designation__c='Quality Control' and status__c='Active' ];
        return memlist;
    }
    
    
    public list<Member__c> getmembersTL(string Selteam,String Location)
    {
        list<Member__c> memlistTL = [Select Name,id,Location_id__c from Member__c where Team_id__c =:Selteam and location_id__c=:Location and Designation__c='Team Leader' and status__c='Active' ];
        return memlistTL;
    }
      
}