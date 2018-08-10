/**************************************************************************************
*   Trigger             :       EPMS_Add_Mem_PG                                       *
*   Created Date        :       27/09/2016                                            *           
*   Description         :       This trigger will add the users to public group
                                based on location name                                *     
                                                                                       
****************************************************************************************/

trigger EPMS_Add_Mem_PG on Member__c (after insert,after update)
{

    EPMS_MemberQueryLocator  queryobj = new EPMS_MemberQueryLocator ();
    List<GroupMember> GMlist = new List<GroupMember>();
    Set<String> MemberEmails = new Set<String>();
    List<string> memloc = new List<string>(); 
    list<string> memgroup = new list<string>();
    for(Member__c addgroup :Trigger.new)
    {
        memgroup.add(addgroup.location_id__C);
    }

    list<location__c> locationid = queryobj.getLocation(memgroup[0]);
    
    Group thegroup= queryobj.getGroup(memgroup[0]);    
    if(trigger.isAfter && trigger.isInsert)
    {     
        for(member__c member : Trigger.New) {    
            MemberEmails.add(member.Email__c);
        }
        list<member__c> memLocoldval = new list<member__c>();
        list<member__c> locquery= new list<member__c>();   
    
        //query for the  users and put them in a map,//where the key is the email and the value is the user
        Map<String, User> emailUserMap = new Map<String, User> ();
        list<User> useremail = queryobj.getUserEmailList(MemberEmails);   
        for(User user: useremail){
            emailUserMap.put(user.UserName , user);//mapping user through there email address.
        }           
        List<Id> userIdList = new List<Id>();//            
        for(Member__c member_obj : Trigger.new) {        
            if(member_obj.location_id__c != Null){
                try{
                    //getting the user list based on there unique e-mail address 
                        userIdList.add(emailUserMap.get(member_obj.Email__c).id);             
                }
                catch(System.NullPointerException e){
                    system.debug('exception'+e);
                }
            }         
        }    

     //assigning the group of ids to Group id depends on Member Location;
        for(member__c member : Trigger.New){                       
            if(locationid[0].id!=null && (member.location_id__c == locationid[0].id)){
               if(Limits.getFutureCalls() >= Limits.getLimitFutureCalls()){
                system.debug('future calls=============>exceeded');
               }else{                   
                   EPMS_MemberPublicGroupService.addUsersToGroup(theGroup.id,userIdList);
               }                
            }
        }        
    }
              
    //Update 
    if(trigger.isAfter && trigger.isUpdate)
    {  
        for(member__c member : Trigger.New) {   
            MemberEmails.add(member.Email__c);                 
        }        

        //query for the  users and put them in a map,//where the key is the email and the value is the user
        Map<String, User> emailUserMap = new Map<String, User> ();
        list<User> useremail = queryobj.getUserEmailList(MemberEmails);
        for(User aUser :useremail ){
            emailUserMap.put(aUser.UserName, aUser);//mapping user through there email address.
        }            
        List<Id> userIdList = new List<Id>();//           
        for(Member__c member_obj : Trigger.new) {       
            if(member_obj.location_id__c != Null){
                try{            
                    userIdList.add(emailUserMap.get(member_obj.Email__c).id);                   
                }
                catch(System.NullPointerException e){
                    system.debug('exception'+e);
                }
            } 
        
        }    
        list<member__c> memLocoldval = new list<member__c >();
    
        for(member__c member : Trigger.old) {    
            memLocoldval .add(member);    
        }
        for(member__c member : Trigger.New){            
           
            if(member.location_id__c!=trigger.old[0].location_id__c )
            { 
                if(locationid[0].id!=null && (member.location_id__c == locationid[0].id)){
                      
                    if(Limits.getFutureCalls() >= Limits.getLimitFutureCalls()){
                        system.debug('future calls=============>exceeded'); 
                   }else{
                       EPMS_MemberPublicGroupService.UpdateUsersToGroup(theGroup.id,userIdList);                 
                   } 
              
                }
           }
           else if(member.location_id__c==trigger.old[0].location_id__c && trigger.old[0].User_Id__c==null) {
                       EPMS_MemberPublicGroupService.UpdateUsersToGroup(theGroup.id,userIdList);               
            }
        }
    }
}