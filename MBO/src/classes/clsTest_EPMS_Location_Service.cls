/**********************************************************************************
*   Class               :       clsTest_EPMS_Location_Service                     *
*   Created Date        :       25/03/2016                                        *
*   Description         :       Test Class for EPMS_Location_Service              *
**********************************************************************************/

@isTest
private class clsTest_EPMS_Location_Service {
    static testMethod void testDeleteGroup() {
        
        Set<Id> Ids = new Set<Id>();
        Set<String> nameSet = new Set<String>();
        List<Group> groupList = new List<Group>();
        for(Integer i=1;i<=5;i++){
            Group group1= new Group();
            group1.Name='testGroup'+i;
            group1.DeveloperName = 'ABC'+i;
            groupList.add(group1);
        }
        
        Test.startTest();
        try{
            insert groupList;
        }
        catch(Exception e){
            System.debug(e);
        }
        for(Group g:groupList ){
            Ids.add(g.Id);
        }
        List<Group> oldGroup=[select id,name from Group where Id IN:Ids];
        for(Group g1: oldGroup){
            nameSet.add(g1.name);
        }
        EPMS_Location_Service.deleteGroup(nameSet);
        Test.stopTest();
        
    }
}