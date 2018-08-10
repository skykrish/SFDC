/****************************************************************************
*   Class               :       EPMS_CreationOfTask                         *
*   Created Date        :       17/04/2018                                  *           
*   Description         :       Batch to Assign task Multiple Users         * 
/***************************************************************************/
global class EPMS_CreationOfTask implements Database.Batchable<sObject> {
    
    global String query;
    global List<String> roleName;
    global List<String> pubGroup;
    global List<String> rolessubNames;
    global list<User> userList=new list<User>();
    global list<User> roleList=new list<User>();
    global list<User> pubGroupList=new list<User>();
    global list<UserRole> subRoleIdsList=new list<UserRole>();
    global set<String> subRoleIds=new set<String>();
    global list<User> subRoleUsersList=new list<User>();
    global set<String> userIds=new set<String>();
    global String Subject{get;set;}
    global String Title{get;set;}
    global String wtId{get;set;}
    global String Description{get;set;}
    global String Status{get;set;}
    global Boolean Reminder{get;set;}
    global String Priority{get;set;}
    global Boolean IsReminderSet{get;set;}
    global DateTime ReminderDateTime{get;set;}
    
    public Task tsk {get; set;}
    public Case_Logs__c CLogs {get; set;}
    
    global Location__c location=new Location__c();
    
    //To write Query on Member object based on location Record Id
    
    global EPMS_CreationOfTask(list<String> roleList,List<String> pubGroupList,List<String> rolessubList,String Subject,String Title,String wtId,String Description,String Status,String Priority,boolean isPriorityset, DateTime reminderDateTime){
       
        tsk = new task(); 
        roleName=roleList;
        pubGroup=pubGroupList;
        rolessubNames=rolessubList;
        this.Subject= Subject;
        this.Title =Title;
        this.wtId = wtId;
        this.Description = Description;
        this.Status = Status;
        this.Priority = Priority;
        this.IsReminderSet = isPriorityset;
        this.ReminderDateTime = reminderDateTime;  
    }
    //To Return Query result to the Execute Method
    
    global List<User> start(Database.BatchableContext BC){
        
        system.debug('-----startbatch----' + Query);
        if(roleName!=null){
            roleList=[Select Id, Name,UserRoleId, UserRole.Id, UserRole.Name from User  where UserRole.Name =:roleName and IsActive=True];
            system.debug('-----roleName------'+roleList);
            for(User u:roleList){
                if(userIds.add(u.id)){
                    userList.add(u);
                }   
            }
            
            
            system.debug('-----userList------'+userList);
            system.debug('-----userListsize------'+userList.size());
        }
        if(pubGroup!=null){
            
            pubGroupList=[select id, name, email, isactive, profile.name, userrole.name, usertype from user where id in (select userorgroupid from groupmember where group.name =:pubGroup) and IsActive=True];
            
            system.debug('-----pubGroupList------'+pubGroupList);
            
            for(User u:pubGroupList){
                if(userIds.add(u.id)){
                    userList.add(u);
                }   
            }
            
            system.debug('-----userList------'+userList);
            system.debug('-----userListsize------'+userList.size());
            
        }
        
        if(rolessubNames!=null){
            subRoleIdsList=[select id from UserRole where name=:rolessubNames];
            
            for(UserRole subRole:subRoleIdsList){
                subRoleIds.add(subRole.id);
            }
            
            //subRoleUsersList=[Select id,Name from User Where UserRole.ParentRoleId=:subRoleIds and IsActive=True];
            subRoleUsersList=[Select id,Name from User Where (UserRole.id =:subRoleIds OR UserRole.ParentRoleId=:subRoleIds) and IsActive=True];
            system.debug('-----rolessubNames------'+subRoleUsersList);
            
            for(User u:subRoleUsersList){
                if(userIds.add(u.id)){
                    userList.add(u);
                }   
            }
            
            system.debug('-----userList------'+userList);
            system.debug('-----userListsize------'+userList.size());            
        }
        
        system.debug('----- Final userList------'+userList);
        system.debug('-----userListsize------'+userList.size());
        
        return userList;
        
    }  
    
    global void execute(Database.BatchableContext info, List<User> userList){
        
        
        system.debug('entered into the execution block : ' + userList);
        
        List <Task> taskList = new List<Task>();
        
        // Iterate through the whole query of Members
        // Create a Task that's associated with each Members.
        
        /**************** In Batch Class ********************/
        
        system.debug('-----tsk.OwnerId-----'+tsk.OwnerId);
        system.debug('----Subject----'+Subject);
        system.debug('----wtId----'+wtId);
        system.debug('----Description----'+Description);
        system.debug('----Priority----'+Priority);
        system.debug('----Status----'+Status);
        system.debug('----IsReminderSet----'+IsReminderSet);
        system.debug('----ReminderDateTime----'+ReminderDateTime);
        
        /**************** In Batch Class ********************/
        
        for(User usr : userList) {
            tsk             = new Task();               
            tsk.OwnerId          = usr.id;
            tsk.ActivityDate     = System.today();
            tsk.Subject          = Subject;          
            tsk.Status          = status;
            tsk.Priority        = Priority;
            tsk.whatid          = wtId;
            tsk.Description     = Description;
            tsk.IsReminderSet  = True;
            if(tsk.IsReminderSet  == True) {
             tsk.ReminderDateTime = reminderDateTime;   
            } else {
              tsk.ReminderDateTime = null;  
            }            
             
            taskList.add(tsk);            
        } 
        try {
            system.debug('-----Before Insert Tasks-----');
            insert taskList;
            system.debug('-----After Insert Tasks Successfully-----');
        } catch (system.dmlexception e) {
            System.debug('Tasks not inserted: ' + e);
        }
    } 
    global void finish(Database.BatchableContext info) {    
    }
}