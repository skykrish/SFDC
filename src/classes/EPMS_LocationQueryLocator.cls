/**********************************************************************************
*   Class               :       EPMS_UTIL                                         *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Query locator for location service class          *
**********************************************************************************/
public class EPMS_LocationQueryLocator {
    
    //query members
    public List<Member__c> getMemberlist(set<ID> locSetId){
        list<Member__c> memlist = [select id from Member__c where Location_id__c IN:locSetId];
        return memlist;
    }
    //query teams from location
    public List<Team__c> getTeamlist(set<ID> locSetId){
        list<Team__c> teamlist = [select id from Team__c where Location__c IN:locSetId];
        return teamlist;
    }
    
    //query shifts from location
    public List<Shift__c> getShiftlist(set<ID> locSetId){
        list<Shift__c> shiftlist = [select id from Shift__c where Shift_Location__c IN:locSetId];
        return shiftlist;
    }
    
    //query shift assignment from location
    public List<Shift_Assignments__c> getShiftASS(set<ID> locSetId){
        list<Shift_Assignments__c> shiftAss = [select id from Shift_Assignments__c where Location__c IN:locSetId];
        return shiftAss;
    }
    //query settings from location
    public List<Settings__c> getSettings(set<ID> locSetId){
        list<Settings__c> settings = [select id from Settings__c where Location__c IN:locSetId];
        return settings;
    }
    //query all files related with the location
    public List<Files__c> getFiles(set<ID> locSetId){
        list<Files__c> Files = [select id from Files__c where File_Location__c IN:locSetId];
        return Files;
    }
    //query Production order from the location
    public List<Production_Order__c> getPO(set<ID> locSetId){
        list<Production_Order__c> production = [select id from Production_Order__c where Mbo_Location__c IN:locSetId];
        return production;
    }
    
    //query mistakes from location
    public List<Mistakes__c> getMistake(set<ID> locSetId){
        list<Mistakes__c> mistake = [select id from Mistakes__c where Location__c IN:locSetId];
        return mistake;
    }
    
    //query group related with location
    public List<Group> getGroupName(Set<String> locNameSet){
        list<Group> groupnames = [select id from Group where Name IN:locNameSet];
        return groupnames;
    }
    //query group names
    public list<Group> getGroup(string groupname)
    {
        list<Group> groupExist = [select id,name from Group where Name=:groupname Limit 1];
        return groupExist;
    } 
}