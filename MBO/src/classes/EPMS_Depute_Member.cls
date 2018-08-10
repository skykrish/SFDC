/**********************************************************************************
*   Class               :       EPMS_Depute_Member                                *
*   Created Date        :       01/09/2016                                        *           
*   Description         :       Controller for depute members from location       *
**********************************************************************************/

public without sharing class EPMS_Depute_Member{
    
    EPMS_Member_service MemberService = new EPMS_Member_service();
    public List<member__c> mem{get;set;}
    public List<SelectOption> LocOptionList;
    public String selectedLocId {set;get;}   
    public list<member__c> memlist = new list<member__c>();
    public Id id1 = UserInfo.getProfileId(); 
    public String userid = UserInfo.getUserId();    
    public  list<Profile> profileName = [Select Name from Profile where Id =:id1];
    Id holdUserId = null;
    //Map<Id,Id> memberUserMap = null;
    Map<String,Id> memberUserMap = null;
   //CONSTRUCTOR
    public EPMS_Depute_Member() {
        
        string ids = ApexPages.currentPage().getParameters().get('ids');
        List<string> reqids = new List<string>();
        for(String key:ids.split(',')){
            reqids.add(key);
        }
        mem = MemberService.getMemberlist(reqids);  
        memberUserMap = new Map<String, Id>();        
    }
    
    
    //get locations
    public List<SelectOption> getListOfLocations(){
        
        list<Member__c> memberuser = [select id, Name , Country__c from Member__c where User_id__c =:userid];        
        if(profileName[0].Name=='System Administrator' || profileName[0].Name=='Country Administrator'){
        List<Location__c> locations = [select id ,name from Location__c where Location_Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS];
        LocOptionList = new List<SelectOption>();
        LocOptionList.add(new SelectOption( ' ' ,'---Select Location---'));
        for(Location__c L : locations){
            LocOptionList.add(new SelectOption(L.Id , L.Name));
        }
        }
        else 
        {
            if(memberuser.size()>0) {          
                List<Location__c> locations = [select id ,name from Location__c where Location_Status__c=:EPMS_UTIL.EPMS_ACTIVE_STATUS];
                LocOptionList = new List<SelectOption>();
                LocOptionList.add(new SelectOption( ' ' ,'---Select Location---'));
                for(Location__c L : locations){
                    LocOptionList.add(new SelectOption(L.Id , L.Name));
                }           
            }
        }
        return LocOptionList;
    }
    
    //method for save deputed members
    public PageReference save() {
        try {            
            List<member__c> FetchedMemberList = new  List<member__c>();
            List<member__c> FetchedMemberList1 = new  List<member__c>(); 
            list<Member__c> MemberDeputeUpdate = new List<Member__c>(); 
            List<String> memberEmail = new List<String>();
            Set<Id> memberIds = new Set<Id>();
            string ids1 = ApexPages.currentPage().getParameters().get('ids'); 
            Set<Id> reactiveMemberIds = new Set<Id>();
            String [] splitedID=ids1.split(',');
            list<Id> SelectedID = new list<Id>();
            
            Boolean skipinsert= false;
            Boolean doubleinsert = false;
            Boolean HomeLocation = false;
            
            for(String idSlected:splitedID){
                SelectedID.add(idSlected);
            }
      
            List<member__c> memclone1 = MemberService.getMemberinsertlist(SelectedID);
            for(member__c C : memclone1){
                if(C.location_id__c==selectedLocId){                    
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,Label.EPMS_SAME_LOCATION));                        
                }else{
                    skipinsert=true;    
                }                
            }
            
                
            if(skipinsert==true){                
               
                list<Shift_Assignments__c> Shiftassign = new list<shift_Assignments__c>();
                Shiftassign=MemberService.getShiftmAssignments(SelectedID);
                set<String> members = new set<String>();                
                List<member__c> reActivateMember= new list<member__c>();
                List<member__c> memUpdate= new list<member__c>();
                List<member__c> memOldLcationCheck= new list<member__c>();
                memUpdate = MemberService.getMemberUpdatelist(SelectedID);           
                List<member__c> UpdateMemberList = new  List<member__c>(); 
                List<member__c> ReActMemberList = new  List<member__c>();
                
                list<shift_Assignments__c> Shiftupdate = new list<Shift_Assignments__c>();            
               
                 if(Shiftassign.size()>0){
                    for(Shift_Assignments__c TS : Shiftassign)
                    {
                        shift_Assignments__c shf = new Shift_Assignments__c();
                        shf.id = TS.id;
                        shf.ToTime__c=system.today();
                        shf.Shift_Assigned__c=False;
                        Shiftupdate.add(shf);
                    }
                }   
                 
                 update Shiftupdate;                
                for(member__c MemberListUpdate:memUpdate){
                    system.debug('Exist Member Info : ' + MemberListUpdate);
                    member__c memobjupdate = new member__c();
                    holdUserId = MemberListUpdate.User_Id__c;
                    //memberUserMap.put(MemberListUpdate.Id,MemberListUpdate.User_Id__c);
                    memberUserMap.put(String.valueOf(MemberListUpdate.email__c),MemberListUpdate.User_Id__c);
                    memobjupdate.id = MemberListUpdate.id;
                    memobjupdate.User_Id__c = null;
                    memobjupdate.Status__c= EPMS_UTIL.EPMS_DEPUTED_STATUS;
                    members.add(MemberListUpdate.Emp_id__c);
                    memobjupdate.Current_Shift__c='';
                    memobjupdate.Today_Attendance__c='';   
                    memobjupdate.Team_Id__c=null;
                    system.debug('Update Exist Member Info : ' + memobjupdate);
                    system.debug('Member User Mapping : ' + memberUserMap);
                    UpdateMemberList.add(memobjupdate);
                }
                update UpdateMemberList;
           
                List<member__c> memclone = MemberService.getMemberinsertlist(SelectedID);
                for(member__c loopMemberList:memUpdate){
                        Set<Id> LocationHold=new Set<Id>();
                        Set<Id> MemberID=new Set<Id>();
                        memOldLcationCheck=[select Id,location_id__c,User_id__c from Member__c where Emp_id__c =:loopMemberList.Emp_id__c];
                        for(member__c MemberListLoc : memOldLcationCheck){
                            LocationHold.add(MemberListLoc.location_id__c)  ;
                            MemberID.add(MemberListLoc.Id)  ;
                        }                        
                        if(LocationHold.contains(selectedLocId)){
                            reActivateMember.add([select Id,location_id__c,User_id__c,email__c from Member__c where Emp_id__c =:loopMemberList.Emp_id__c AND location_id__c =:selectedLocId]);
                        }else{
                            member__c memobj = new member__c();
                            memobj.location_id__c=selectedLocId;
                            memobj.Id=null; 
                            memobj.Name=loopMemberList.name;
                            memobj.Last_Name__c=loopMemberList.Last_Name__c;
                            memobj.First_Name__c=loopMemberList.First_Name__c;           
                            memobj.Email__c=loopMemberList.Email__c;
                            memobj.Status__c=EPMS_UTIL.EPMS_ACTIVE_STATUS;
                            memobj.User_Id__c=loopMemberList.User_Id__c;
                            memobj.Designation__c=loopMemberList.Designation__c;
                            memobj.Emp_id__c=loopMemberList.Emp_id__c;
                            memobj.Country__c = MemberService.getLocationCountry(selectedLocId);                            
                            memobj.Contact_Number__c=loopMemberList.Contact_Number__c;
                            memobj.Date_Of_Birth__c=loopMemberList.Date_Of_Birth__c;
                            memobj.Sex__c=loopMemberList.Sex__c;                            
                            FetchedMemberList1.add(memobj);
                        }                     
                 }
                 
                 if(FetchedMemberList1.size() > 0){
                     insert FetchedMemberList1;
                 }
                 List<Member__c> MemTActive = new List<Member__c>();
                 if(reActivateMember.size() > 0 ){
                    for(Member__c MemberAct : reActivateMember){
                        system.debug('Mapping User with New : ' + MemberAct);
                        system.debug('Mapping old User : ' + holdUserId);
                        MemberAct.Status__c=EPMS_UTIL.EPMS_ACTIVE_STATUS;
                        //MemberAct.User_id__c = holdUserId;
                        if(memberUserMap != null && memberUserMap.size() > 0){
                            MemberAct.User_id__c = memberUserMap.get(MemberAct.email__c);
                        }
                        MemberAct.Id=MemberAct.Id;
                        reactiveMemberIds.add(MemberAct.Id);
                        MemTActive.add(MemberAct);
                        system.debug('Mapping Old User with New : ' + MemberAct);
                    }
                    if(MemTActive.size() > 0 ){
                        update MemTActive;
                    }
                 }                          
                
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,label.EPMS_MBO_Success_DEPUTE));     
                
            }
            
            // Delete the shift attendance records if exits for selected member for deputed location
            system.debug('Selected member shift attendance records : Location ' + selectedLocId);
            system.debug('Selected member shift attendance records : Member ' + reactiveMemberIds +' Today : ' + System.today());
            Date todayDt = System.today();
            system.debug('Selected member shift attendance records : Member ' + SelectedID +' Today : ' + todayDt);
            Location__c selectedLocation = [SELECT Id, Name FROM Location__c WHERE Id =: selectedLocId];
            system.debug('Selected Location Name : ' + selectedLocation); 
            if(selectedLocation != null && reactiveMemberIds.size() > 0){
                List<Shift_Attendance__c> existDeputedRecords = [SELECT Id, Name, Attendance_Date__c, Attendance_Status__c, Shift_Location__c FROM Shift_Attendance__c WHERE Employee_Name__c IN: reactiveMemberIds AND Attendance_Date__c =: todayDt AND Attendance_Status__c = 'D' AND Shift_Location__c =: selectedLocation.Name];
                
                system.debug('Selected member shift attendance records : ' + existDeputedRecords);
                if(existDeputedRecords != null && existDeputedRecords.size() > 0){
                    try{
                        delete existDeputedRecords;
                    } catch (Exception de){
                        system.debug('Error during deleting the shift attendance record for selected member :' + de.getMessage());
                    }
                }
            }
            
        }
        catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        
        
        return null;
    }
    
}