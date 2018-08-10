/**************************************************************************************
*   Class               :       EPMS_TeamAssign_detailService                         *
*   Created Date        :       13/04/2016                                            *           
*   Description         :       Service class for Member team assignment              *     
                                                                                       
****************************************************************************************/
public with sharing class EPMS_TeamAssign_detailService{

     public Member__c member = null;
     EPMS_TeamAssign_detail_QryLocator queryLoc = new EPMS_TeamAssign_detail_QryLocator(); 
     
     public List<Member__c> getTeamQC_TLMembers(ID teamId){
         List<Member__c> MemberList= new List<Member__c>();
         MemberList= queryLoc.getTeamQC_TLMembers(teamId);
         return MemberList;
         
     }
     public List<Member__c> getTeamMembers(ID teamId){
         List<Member__c> MemberList= new List<Member__c>();
         MemberList= queryLoc.getTeamMembers(teamId);
         return MemberList;
         
     }
     /*
     //Get List of Members
    public Member__C getMember(){
        member = queryLoc.getMember();
        return member;
    }
    */
}