/**********************************************************************************
*   Class               :       EPMS_TeamAssign_detail_QryLocator                 *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Query locator for EPMS_TeamAssign                 *
**********************************************************************************/


public with sharing class EPMS_TeamAssign_detail_QryLocator{

    List<Profile> profile = null;
    public Member__c member = null;
    public String MyProflieName{get;set;}
    
    
    // getting QC and TL 
    public List<Member__c> getTeamQC_TLMembers(ID teamId){

         List<Member__c> MemberList= new List<Member__c>();
      
         memberList = [select Id,Name,Emp_ID__c,Team_Id__c,Team_Id__r.Name,Designation__c  from Member__c where Team_Id__c =:teamId  AND (Designation__c=:EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME OR Designation__c=:EPMS_UTIL.EPMS_QC_PROFILE_NAME)  order by Team_Id__c,Designation__c ];
         return MemberList;
    }
    
    // getting team members
    
    public List<Member__c> getTeamMembers(ID teamId){

        List<Member__c> MemberList= new List<Member__c>();
        
         memberList = [select Id,Name,Emp_ID__c,Team_Id__c,Team_Id__r.Name,Designation__c  from Member__c where Team_Id__c = :teamId  AND Designation__c!=:EPMS_UTIL.EPMS_TEAM_LEAD_PROFILE_NAME AND Designation__c!=:EPMS_UTIL.EPMS_QC_PROFILE_NAME order by Team_Id__c,Designation__c];
         return MemberList;
    }
    /*
    // Getting profiles
    public List<Profile> getProfiles(){
        try{
             profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
             MyProflieName= profile[0].Name;
         }catch(Exception e){
              System.debug(e);  
         }
       return profile ;
    }
    */
    /*
     //Return the Member Details to List 
    public Member__c getMember(){
    
        try{
            member  = [select id,Location_id__c,Location_id__r.Name, Designation__c from Member__c where User_Id__c =:userinfo.getuserid()];
        }catch(Exception e){
          System.debug(e);  
        }
        return member;
    }
     */

}