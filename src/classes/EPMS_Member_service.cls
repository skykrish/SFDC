/**********************************************************************************
*   Class               :       EPMS_Member_service                               *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Service class to communicate with 
                                EPMS_MemberQueryLocator                           *
**********************************************************************************/

public without sharing class  EPMS_Member_service {
    
    //create instance for EPMS_MemberQueryLocator
    EPMS_MemberQueryLocator Memberquery = new EPMS_MemberQueryLocator();
    
    //get member list from EPMS_MemberQueryLocator
    public list<Member__c> getMemberlist(list<String> memids){
       list<Member__c> memobj = new list<Member__c>();
        memobj= Memberquery.getMemberlistinfo(memids);       
       return memobj;
    }
    
    //get member insert list from EPMS_MemberQueryLocator
    public list<Member__c> getMemberinsertlist(list<id> SelectedID){
       list<Member__c> memobj1 = new list<Member__c>();
        memobj1=  Memberquery.getMemberlistinsert(SelectedID);       
       return memobj1;
    }
    
    //get member update list from EPMS_MemberQueryLocator
    public list<Member__c> getMemberUpdatelist(list<id> SelectedID){
       list<Member__c> memobj2 = new list<Member__c>();
        memobj2=  Memberquery.getMemberlistUpdate(SelectedID);        
       return memobj2;
    }
    
   //get location based on country from EPMS_MemberQueryLocator 
    public String getLocationCountry(Id locid){
        String Country = Memberquery.getLocationCountry(locid);
        return Country;
    }
  
    //get shift assignment records from EPMS_MemberQueryLocator
    public list<Shift_Assignments__c> getShiftmAssignments(list<id> SelectedID)
    {
        list<Shift_Assignments__c> TS =Memberquery.getShiftAssign(SelectedID);        
        return TS;
    }

    //get members from EPMS_MemberQueryLocator
    public List<Member__c> getMemberOriginalLoc(List<String> MemberEmail,Set<Id> LocID){
       List<Member__c> MemberData = Memberquery.getMemberOriginalLoc(MemberEmail,LocID);
       return MemberData;
 
    }
    
    //get members location from EPMS_MemberQueryLocator
    public List<Member__c> getMemberOriginalLoc1(List<String> MemberEmail,Set<Id> LocID){
       List<Member__c> MemberData = Memberquery.getMemberOriginalLoc1(MemberEmail,LocID);
       return MemberData;
 
    }
    
}