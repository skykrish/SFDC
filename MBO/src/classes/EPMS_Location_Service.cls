/**********************************************************************************
*   Class               :       EPMS_Location_Service                             *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       service class to create public group              *
**********************************************************************************/
public class EPMS_Location_Service{

    @future
    public static void deleteGroup(set<String> locNameSet){
        List<Group> publicGroupList = new List<Group>();
        Set<String> groupNameSet = new Set<String>();
        
        if(locNameSet!=null && locNameSet.size()>0){
            for(String groupName : locNameSet){
                groupNameSet.add(groupName);
            }
        }
        
        if(groupNameSet!=null && groupNameSet.size()>0)
            publicGroupList = [SELECT Id,Name FROM Group WHERE Name IN:groupNameSet];
            if(publicGroupList!=null && publicGroupList.size()>0){
                if (Test.isRunningTest()) {
                    // start new context via system.runAs() for the same user for test code only
                    System.runAs(new User(Id = Userinfo.getUserId())) {
                        delete publicGroupList;
                    }
                } else {                    
                    // in non-test code delete normally
                    delete publicGroupList;
                }
            }
    }
}