/**********************************************************************************
*   Class               :       EPMS_Trg_addToGroup                               *
*   Created Date        :       08/09/2016                                        *           
*   Description         :       Trigger to call EPMS_AddUsersToChatterGroup       *
**********************************************************************************/
trigger EPMS_Trg_addToGroup on User (after insert, after update) {
   
   //calling metod from 
   boolean isSalesRegionUser = false; 
   Set<Id> userIds = new Set<Id>();
   for(User usrId : Trigger.New){
       userIds.add(usrId.Id);
   }
   //Querying users
   
     List<User> users=[select id,UserRoleId, Username,Country__c ,IsActive from User where id in :trigger.newMap.keySet()];
     //querying sales region roles
     UserRole Roles=[select Id,Name from UserRole where Name=:Label.Sales_Users_Role];
     if(users != null && users.size() > 0) {
         for(User newUser : users) {
             if(Roles != null && newUser.UserRoleId != Roles.Id){
                isSalesRegionUser = false;             
             } else {
                isSalesRegionUser = true; 
             }
         }
     }
      if(isSalesRegionUser){
           EPMS_AddUsersToChatterGroup.addToMainGroup(trigger.newMap.keySet());
      }     
}