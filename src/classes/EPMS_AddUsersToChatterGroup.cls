/**********************************************************************************
*   Class               :       EPMS_AddUsersToChatterGroup                       *
*   Created Date        :       08/09/2016                                        *           
*   Description         :       Adding sales region users to chatter group        *
**********************************************************************************/


public class EPMS_AddUsersToChatterGroup{


  //inserting users to chatter group using future method
    @future
    public static void addToMainGroup(Set<Id> userIds) {
       boolean isSalesRegionUser = false; 
    //Querying users
     List<User> users=[select id,UserRoleId, Username,Country__c ,IsActive from User where id in :userIds];
     //querying sales region roles
     UserRole Roles=[select Id,Name from UserRole where Name='Full-time Employee'];
     if(users != null && users.size() > 0) {
         for(User newUser : users) {
             if(Roles != null && newUser.UserRoleId != Roles.Id){
                isSalesRegionUser = false;             
             } else {
                isSalesRegionUser = true; 
             }
         }
     }
     system.debug(' Is Sales Region User available : ' + isSalesRegionUser);
     
     List<String> groups=New List<String> {'Sales Region - Japan', 'Sales Region - Africa', 'Sales Region - USA'};
     
     if(isSalesRegionUser){
     //querying chatter group 
     List<CollaborationGroup> chatterGroup=[select Id, Name from CollaborationGroup Where Name IN:groups];
     Map<String, Id> nameGroupId = new Map<String, Id>();
     if(chatterGroup != null && chatterGroup.size() > 0){
         for(CollaborationGroup grp : chatterGroup){
             String grpKey = grp.Name;
             system.debug(' Group Name : ' + grpKey);
             if(grpKey != null){
                 String[] spltGrpName = grpKey.split('Sales Region - ');
                 system.debug(' All the Strings are : ' + spltGrpName);
                 nameGroupId.put(spltGrpName[1], grp.Id);
                 system.debug('Map are : ' + nameGroupId);
             }
         }
     }
     
     List<CollaborationGroupMember> chatterGroupMembers=new List<CollaborationGroupMember>();
     
      // Check the Member is already Existing in the group
     List<CollaborationGroupMember> existingChatterRecord = [SELECT Id, CollaborationGroupId, MemberId FROM CollaborationGroupMember WHERE MemberId IN : userIds];
     system.debug(' Existing Collaboration Group Member Id : ' + existingChatterRecord );
     if(existingChatterRecord != null && existingChatterRecord.size() > 0){
         try{
             delete existingChatterRecord;
         } catch(Exception de){
             system.debug('Error updating the records : ' + de.getMessage());
         }
     }
     
     
     for(User user: users){
     
     //inserting USA sales region members
         if(user.UserRoleId ==Roles.Id && user.Country__c=='USA' && user.IsActive==true){
             //CollaborationGroupMember newMember = new CollaborationGroupMember(CollaborationGroupId=chatterGroup[0].id, MemberId = user.Id, NotificationFrequency = 'N');
             CollaborationGroupMember newMember = new CollaborationGroupMember(CollaborationGroupId=nameGroupId.get(user.Country__c), MemberId = user.Id, NotificationFrequency = 'N');
             system.debug(' USA User : ' + nameGroupId.get(user.Country__c));
             chatterGroupMembers.add(newMember);
         }
         
      //inserting africa sales region members
        
         else if(user.UserRoleId ==Roles.Id && user.Country__c=='Africa' && user.IsActive==true){
             //CollaborationGroupMember newMember = new CollaborationGroupMember(CollaborationGroupId=chatterGroup[1].id, MemberId = user.Id, NotificationFrequency = 'N');
             CollaborationGroupMember newMember = new CollaborationGroupMember(CollaborationGroupId=nameGroupId.get(user.Country__c), MemberId = user.Id, NotificationFrequency = 'N');
             system.debug(' Africa User : ' + nameGroupId.get(user.Country__c));
             chatterGroupMembers.add(newMember);
         }
         
       //inserting japan sales region members
         else if(user.UserRoleId ==Roles.Id && user.Country__c=='Japan' && user.IsActive==true){
             //CollaborationGroupMember newMember = new CollaborationGroupMember(CollaborationGroupId=chatterGroup[2].id, MemberId = user.Id, NotificationFrequency = 'N');
             CollaborationGroupMember newMember = new CollaborationGroupMember(CollaborationGroupId=nameGroupId.get(user.Country__c), MemberId = user.Id, NotificationFrequency = 'N');
             system.debug(' Japan User : ' + nameGroupId.get(user.Country__c));
             chatterGroupMembers.add(newMember);
         }     
     }
     //inserting members of chattergroup
    if(chatterGroupMembers.size()>0){
        if (!Test.isRunningTest()) {
            upsert chatterGroupMembers;
        }
        //else {
        //start new context via system.runAs() for the same user for test code only
        //    System.runAs(new User(Id = Userinfo.getUserId())) {
        //        upsert chatterGroupMembers;
        //    }
      //  }
       }
    }
    
    }
}