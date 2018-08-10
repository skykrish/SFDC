/**********************************************************************************
*   Class               :       TestEPMS_QueryLocator                             *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Test class for EPMS_QueryLocator                  *
**********************************************************************************/

@isTest(SeeAllData = True)
private class TestEPMS_QueryLocator {    

    static testMethod void TestQueryLocator() {
    
        List<Member__c> proMember=[Select id,Location_id__c,User_Id__c,Location_id__r.Name, Designation__c from Member__c where  Status__c='Active' AND Designation__c='Production Administrator' Limit 1];
        User PAuser =[SELECT Id FROM User WHERE User.id=:proMember[0].User_Id__c];

        EPMS_QueryLocator QueryLocator = new EPMS_QueryLocator(); 
        
        QueryLocator.getProfiles();
        QueryLocator.getMember();
        QueryLocator.getAvailableTeamInLocation();
        QueryLocator.getIncentiveList();
        QueryLocator.getMemberListAssociatedLocation();
        QueryLocator.getAvailableShiftInLocation();
        QueryLocator.getAllExceptSAMemberInLocation();
        QueryLocator.getlocation();
        QueryLocator.getAllLocations();
        QueryLocator.getAllMemberInLocation();
        
        List<Location__c> Locations=QueryLocator.getlocations();
        QueryLocator.getCostByLoc(Locations[0].id);
        Set<Id> membersid;
        List<String>allmembers;
        List<Member__c> Memberrec=[Select id,Location_id__c,Location_id__r.Name, Designation__c from Member__c where  Status__c='Active'];
        system.debug('@ Member is : ' + Memberrec);        
        for (Member__c mem:Memberrec){
        system.debug('#### Member is ####: ' + mem);
        membersid=new Set<Id>();
        allmembers=new List<String>();
        membersid.Add(mem.id);
        allmembers.Add(mem.id);
        }
        
        QueryLocator.getAllShiftAssignmentInfo(membersid);
        QueryLocator.getAllTeamAssignmentInfo(membersid);
        QueryLocator.getMembersInfo(allmembers);
        QueryLocator.getUserAssignmentInfo(Memberrec[0].id,'Team');
        QueryLocator.getUserAssignmentInfo(Memberrec[0].id,'Shift');
        QueryLocator.getAllPendingProductionOrders(membersid);
        QueryLocator.getAllFilesListAssignedToMember(membersid);
        
        List<Team__c> AllTeamList=QueryLocator.getAllTeamList(Memberrec[0].Location_id__c);
        QueryLocator.getSelectedMemberDetails(membersid,Locations[0].id);
        QueryLocator.getSelectedMemberDetails(membersid,null);
        QueryLocator.retrieveShiftUnAssignmentDetails(membersid,'Team','2016/12/10','2016/12/14');
        QueryLocator.retrieveShiftUnAssignmentDetails(membersid,'Team','2016/12/10','');
        QueryLocator.retrieveShiftUnAssignmentDetails(membersid,'Team','','');
        QueryLocator.retrieveShiftUnAssignmentDetails(membersid,'Shift','2016/12/10','2016/12/14');
        QueryLocator.retrieveShiftUnAssignmentDetails(membersid,'Shift','2016/12/10','');
        QueryLocator.retrieveShiftUnAssignmentDetails(membersid,'Shift','','');
        QueryLocator.retrieveTeamUnAssignmentDetails(membersid,'Team','2016/12/10','2016/12/14');
        QueryLocator.retrieveTeamUnAssignmentDetails(membersid,'Team','2016/12/10','');
        QueryLocator.retrieveTeamUnAssignmentDetails(membersid,'Team','','');
        QueryLocator.getMembersInLocation(Locations[0].id);
        QueryLocator.getAllShiftListForSelectedLocation(Memberrec[0].Location_id__c);
        
        List<Shift__c> AllShiftList = QueryLocator.getAllShiftList();
        List<Team__c> getAvailableTeamInLocation =  [Select id from Team__c where Location__r.Name='MBOI Phase-1'];
        
        Shift_Assignments__c teamAssignment = new Shift_Assignments__c();
        teamAssignment.FromTime__c=System.today().AddDays(2);
        teamAssignment.ToTime__c=null;
        teamAssignment.Member__c=Memberrec[0].id;
        insert teamAssignment;
        
        Shift_Assignments__c ShiftAssignment = new Shift_Assignments__c();
        ShiftAssignment.FromTime__c=System.today().AddDays(2);
        ShiftAssignment.ToTime__c=null;
        ShiftAssignment.Member__c=Memberrec[1].id;
        ShiftAssignment.Shift_Code__c=AllShiftList[0].id;
        insert ShiftAssignment;
        
        QueryLocator.getTeamAssignmentInfo(membersid,teamAssignment.id);
        QueryLocator.getUserAssignmentForShiftOrTeam(membersid,teamAssignment.id,'Team');
        QueryLocator.getUserAssignmentForShiftOrTeam(membersid,ShiftAssignment.id,'Shift');
        QueryLocator.retrieveShiftAssignmentDetails(membersid,teamAssignment.id,'Team','2016/12/10','2016/12/14');
        QueryLocator.retrieveShiftAssignmentDetails(membersid,teamAssignment.id,'Team','2016/12/10','');
        QueryLocator.retrieveShiftAssignmentDetails(membersid,teamAssignment.id,'Team','','');
        QueryLocator.retrieveShiftAssignmentDetails(membersid,ShiftAssignment.id,'Shift','2016/12/10','2016/12/14');
        QueryLocator.retrieveShiftAssignmentDetails(membersid,ShiftAssignment.id,'Shift','2016/12/10','');
        QueryLocator.retrieveShiftAssignmentDetails(membersid,ShiftAssignment.id,'Shift','','');
        QueryLocator.getUserAssignedInfos(membersid,teamAssignment.id,'Team');
        QueryLocator.getUserAssignedInfos(membersid,ShiftAssignment.id,'Shift');
        QueryLocator.getShiftInfo(AllShiftList[0].id);
        QueryLocator.getshift(Memberrec[1].Location_id__c);
        QueryLocator.getshift(null);
        
      
        /*System.runAs(PAuser){        
            List<Member__c> Memberrec2=[Select id,Location_id__c,Location_id__r.Name, Designation__c from Member__c where  Status__c='Active' AND Designation__c = 'Team Leader'];
            system.debug(' PA Member : ' + Memberrec2);
            QueryLocator.getAvailableTeamInLocation();
            QueryLocator.getshift(Memberrec2[0].Location_id__c);      
        }*/
    }
}