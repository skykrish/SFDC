/****************************************************************************
*   Class               :       EPMS_MemberPGhelper                         *
*   Created Date        :       11/09/2015                                  *           
*   Description         :       To Add Users TO Group                       *
*   Created By          :                                                   *                       
*   Version             :       1.0                                         *            
/***************************************************************************/
public class EPMS_MemberPGhelper{

    //Add New Users to group
    @future
    public static void addUsersToGroup(String groupId, List<Id> userIds){

        List<GroupMember> GMlist = new List<GroupMember>();
        for(ID userId: userIds){
            GroupMember gm = new GroupMember();
            gm.GroupId = groupId;
            gm.UserOrGroupId = userId;
            gmList.add(gm);
        }   
    
        if(gmList.size() > 0){
            insert gmList;
        }
    }
    
    
    //updating  Users to group
    @future
    public static void UpdateUsersToGroup(String groupId, List<Id> userIds){
       system.debug('=========ids to update ===='+userIds);
        system.debug('==============update to group ====='+groupId);

        list<GroupMember> allGroupIDs = new list<GroupMember>();  
     
       
        
       allGroupIDs = [Select Id from GroupMember where  UserOrGroupId IN : userIds ];
       
            
      
    system.debug('=======id to delete from group====='+allGroupIDs);
           if(!allGroupIDs.isEmpty())
           {
          delete allGroupIDs;
           }
         system.debug('=======id to delete from group====='+allGroupIDs);
            List<GroupMember> GMlist = new List<GroupMember>();
        for(ID userId: userIds){
            GroupMember gm = new GroupMember();
            gm.GroupId = groupId;
            gm.UserOrGroupId = userId;
            gmList.add(GM);
        }   
    
        if(gmList.size() > 0){
            insert gmList;
        }     
        
  
}
}