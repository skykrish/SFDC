/****************************************************************************
*   Class               :       EPMS_MemberPublicGroupService               *
*   Created Date        :       11/09/2015                                  *           
*   Description         :       To Add Users TO Group                       *          
/***************************************************************************/
public class EPMS_MemberPublicGroupService{

    //Add New Users to group
    @future
    public static void addUsersToGroup(String groupId, List<Id> userIds){
        
      list<GroupMember> allGroupIDs = new list<GroupMember>();      
       allGroupIDs = [Select Id from GroupMember where  UserOrGroupId IN : userIds ];

           if(!allGroupIDs.isEmpty())
           {
          delete allGroupIDs;
           }   
        
        List<GroupMember> GMlist = new List<GroupMember>();
        for(ID userId: userIds){
            GroupMember gm = new GroupMember();
            gm.GroupId = groupId;
            gm.UserOrGroupId = userId;
            GMlist.add(gm);
        }   
   
        if(GMlist.size() > 0){
            if (Test.isRunningTest()) {

                // start new context via system.runAs() for the same user for test code only
                System.runAs(new User(Id = Userinfo.getUserId())) {
                   insert GMlist;
                }
            } else {
                   // in non-test code insert normally
                   insert GMlist;
            }            
             
        }
    }
    
    
    //updating  Users to group
    @future
    public static void UpdateUsersToGroup(String groupId, List<Id> userIds){
       
        list<GroupMember> allGroupIDs = new list<GroupMember>();  
     
       
        
       allGroupIDs = [Select Id from GroupMember where  UserOrGroupId IN : userIds ];
           
      
        if(!allGroupIDs.isEmpty())
        {   
            if (Test.isRunningTest()) {

                // start new context via system.runAs() for the same user for test code only
                System.runAs(new User(Id = Userinfo.getUserId())) {
                   delete allGroupIDs;
                }
            } else {
                   // in non-test code insert normally
                   delete allGroupIDs;
            }
                
        }

            List<GroupMember> GMlist = new List<GroupMember>();
        for(ID userId: userIds){
            GroupMember gm = new GroupMember();
            gm.GroupId = groupId;
            gm.UserOrGroupId = userId;
            gmList.add(GM);
        }   
    
        if(gmList.size() > 0){
            if (Test.isRunningTest()) {

                // start new context via system.runAs() for the same user for test code only
                System.runAs(new User(Id = Userinfo.getUserId())) {
                   insert gmList;
                }
            } else {
                   // in non-test code insert normally
                   insert gmList;
            }
            
        }     
        
  
}
}