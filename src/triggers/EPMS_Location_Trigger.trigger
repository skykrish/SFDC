/***********************************************************************************************************************
   Class               :    EPMS_Location_Trigger  
   Created Date        :    12/29/2015                                             
   Description         :    Create and Update the public Groups based on the location name
                               
   Created By          :                                                                           
   Version             :    1.0                                                  
**************************************************************************************************************************/


Trigger EPMS_Location_Trigger on  Location__c(before insert,before update,before delete){
    
    
    EPMS_LocationQueryLocator queryloc = new EPMS_LocationQueryLocator();
    //create and update group based on the location name
    boolean errorFlag = false;
    if(Trigger.isBefore && Trigger.isDelete) {
        
        Set<String> locNameSet = new Set<String>();
        Set<Id> locSetId = new Set<Id>();
        for(Location__c loc: Trigger.old){
            locSetId.add(loc.Id);
            locNameSet.add(loc.Group_Name__c);
        }
        List<Member__c> memberList =queryloc.getMemberlist(locSetId);
        List<Team__c> teamList =queryloc.getTeamlist(locSetId);
        List<Shift__c> shiftList =queryloc.getShiftlist(locSetId);
        List<Shift_Assignments__c> shiftAssignList =queryloc.getShiftASS(locSetId);
        List<Settings__c> settingList =queryloc.getSettings(locSetId);
        List<Files__c> fileList =queryloc.getFiles(locSetId);
        List<Production_Order__c> poList =queryloc.getPO(locSetId);
        List<Mistakes__c> mistakeList =queryloc.getMistake(locSetId);
        list<Group> groupExist = queryloc.getGroupName(locNameSet);
        
        
        for(Location__c loc: Trigger.old){
            if(!memberList.isEmpty() ||!groupExist.isEmpty()|| !teamList.isEmpty() || !shiftList.isEmpty() || !shiftAssignList.isEmpty() ||   !settingList.isEmpty() || !fileList.isEmpty() || !poList.isEmpty() || !mistakeList.isEmpty() ){
                errorFlag =true;
                loc.addError(Label.EPMS_MBO_You_cannot_delete_this_location_because_the_location_has_records_in_it);
            }
            
        }
        if(!errorFlag){
            EPMS_Location_Service.deleteGroup(locNameSet);
        }
        
        
    }
    if(Trigger.isBefore && Trigger.isInsert){        
        List<Group> groupList = new List<Group>();
        for(Location__c loc: Trigger.new){
            Group newGroup = new Group();
            if(loc.Location_Status__c !=EPMS_UTIL.EPMS_INACTIVE_STATUS){
                string groupname = String.valueOf(loc.Group_Name__c);
                list<Group> groupExist = queryloc.getGroup(groupname); 
                if(groupExist.size()>0)
                {
                    loc.addError(Label.EPMS_MBO_Group_Name_already_Existed_Please_Change_Group_Name);
               
                }else{
                    newGroup.Name = groupname;
                    newGroup.DoesIncludeBosses= false;
                    groupList.add(newGroup);
                }
            }
        }
        if(groupList!=null && groupList.size()>0)
            insert groupList;
        
        
    }  
    if(Trigger.isBefore && Trigger.isUpdate){   
      
        List<Group> groupList1 = new List<Group>();
        list<string> oldlocgroup = new list<string>();
       for(location__C locold : trigger.old)
       {
           oldlocgroup.add(locold.Group_Name__c);      
       }

       for(Location__c loc1: Trigger.new){
            Group newGroup = new Group();
            if(loc1.Group_Name__c!=oldlocgroup[0]){
                loc1.addError(Label.Changing_the_Group_Name_is_Not_allowed);            
            }
        }
    }
    
    
    
    
    
    
}