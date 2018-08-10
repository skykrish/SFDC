/****************************************************************************
*   Class               :       EPMS_TaskDistributionCaseLogsController         *
*   Created Date        :       17/04/2018                                      *           
*   Description         :       class to Assign task Multiple Users(EPMSSF-558) * 
/***************************************************************************/

public class EPMS_TaskDistributionCaseLogsController {
    
    Public Task Tasks {get; set;}
    public string basepath {get;set;}
    public boolean diableButton{public get;set;}
    public Case_Logs__c CLogs {get; set;}
    public String reminderTime{set;get;}
    public List<Task> TaskList {get; set;}
    List<Task> tlist = new List<Task>();
    public string fileRecord {get; set;}
    
    
    // Assign task to groups
    public string option { set; get; }
    public List<User> userlst { set; get; }
    
    public string selectedValue { set; get;}
    
    public string strlist{get; set;}
    public string taskCount{get; set;}
    
    
    Public List<string> leftselected{get;set;}
    Public List<string> rightselected{get;set;}
    public Set<string> leftvalues {get; set;}
    public Set<string> rightvalues {get; set;}
    public Set<String> uniqueCustomObjectSet {get; set;}
    public List<selectoption> roleoptions {get; set;}
    public integer CountTotalTasks {get; set;}
    
    public List<Group> Grouplist;
    public  List<User> Userlist;
    public  List<User> Userlist1;
    public List<string> reqids = new List<string>();
    public List<Case_Logs__c>  casel {public get; set;}
    
    public boolean errorFlag {get;set;}
    public boolean ErrorflagLocCheck {get;set;}
    public boolean ErrorflagstatusCheck {get;set;}
    public boolean updateButton{get;set;}
    public boolean ErrorflagstatusCheckPEND {get;set;}
    
    public string subjects {get; set;}
    public string Title {get; set;}
    public string assignedTo {get; set;}
    public string relatedTo {get; set;}
    public string comments {get; set;}
    public string status {get; set;}
    public string Priority {get; set;}
    public boolean isReminderSet {get; set;}
    public DateTime ReminderDateTime {get; set;}
    public Boolean error{get;set;}
    //public integer Userscount {get; set;}
    
    public List<String> roleListNew {get; set;}
    public List<String> groupListNew  {get; set;}
    public List<String> roleSubList  {get; set;}   
    public String[] GMTTime;
    public List<selectoption> optionpick {get; set;}
    
    public String timeFormat = '';
    public String defaultHours = '';
    public String defaultHours24H = '';
    public String defaultMins = '';   
    public Integer hrs = 0;
    public Integer mins = 0;
    
    public EPMS_TaskDistributionCaseLogsController() {   
        try {
            reminderTime = getGMTTime();
            optionpick = new List<selectoption>();
            updateButton = false;
            error=true;
            ErrorflagLocCheck=true;
            ErrorflagstatusCheck=false;
            ErrorflagstatusCheckPEND=true;
            errorFlag =false;
            diableButton = false;
            
            strlist =apexpages.currentpage().getparameters().get('Assignedto');
            basepath = ApexPages.currentPage().getParameters().get('type');
            tasks = new Task(whatId = ApexPages.currentPage().getParameters().get('whatId'));
            
            
            String id = ApexPages.currentPage().getParameters().get('whatId');
            system.debug('***********id = ' + id);
            
            //, subjects,Title, relatedTo,comments,status,reminder,Priority), 100);            
            
            casel = [select id,name,Title__c from Case_Logs__c WHERE Id = :reqids];
            try{
                
                Clogs = [select id,name,Title__c from Case_Logs__c WHERE Id = :tasks.whatid limit 1];
                Title =  CLogs.Title__c;
            }catch(Exception e) {
                
            }
            TaskList = new List<Task>();
            
            // assign task to groups
            leftselected = new List<String>();
            rightselected = new List<String>();
            leftvalues = new Set<string>();
            rightvalues = new Set<string>();
            uniqueCustomObjectSet =  new set<string>();
            
            option = 'Public Groups';
            leftvalues.addAll(uniqueCustomObjectSet);
            
            roleoptions = new List<selectoption>();
            
            
        } catch(Exception e) {
            
        } 
    }
    
    public pagereference saveNew() {
        
        try {  
            system.debug('Test Task ID:' + tasks.WhatId);
            
            system.debug('--------Subject---------'+tasks.Subject);
            system.debug('--------tasks---------'+tasks);
            
            if(tasks.subject == null) {
                error=false;
                tasks.subject.addError('Please enter task subject');
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Please enter task subject'));
                return null;
            }
            
            
            error=true;
            system.debug('**************Inside saveNew');
            //save();
            
            List<String> roleList = new List<String>();
            List<String> groupList = new List<String>();
            List<String> roleSubList = new List<String>();
            List<String> assignerList = new List<String>();
            List<String> combinedList = new List<String>();
            String key = '';
            String val = '';   
            
            system.debug('str list value before:'+ strlist);
            if(strlist == '' || strlist == null) {
                // strlist.addError('Assigned to field is required');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,'Assigned to:you should enter a value')); 
            }
            
            system.debug('str list value After:'+ strlist);
            if(strlist != null && strlist != '') {
                assignerList = strlist.split('\\,');
                system.debug('*********assignerList : ' + assignerList);
                
                if (assignerList != null && assignerList.size() > 0) {
                    for (String strassigner : assignerList) {
                        //system.debug('*********strassigner : ' + strassigner);
                        combinedList = strassigner.split('\\:');
                        //system.debug('*********combinedList : ' + combinedList);
                        if (combinedList != null && combinedList.size() > 0) {
                            key = combinedList[0].trim();
                            val = combinedList[1].trim();
                            //system.debug('*********combinedList[0] : ' + key);
                            //system.debug('*********combinedList[1] : ' + val);
                            if (key == 'Group') {
                                groupList.add(val);
                            }
                            if (key == 'Role') {
                                roleList.add(val);
                            }
                            if (key == 'Roles and Subordinates') {
                                roleSubList.add(val);
                            }           
                        }
                    }
                }         
                
                
                subjects = tasks.Subject;
                relatedTo = tasks.whatid;
                
                comments = tasks.Description;
                
                status = tasks.Status;
                
                Priority = tasks.Priority;
                isReminderSet = tasks.isReminderSet;
                
                /*if(tasks.ReminderTime__c != null){
GMTTime=tasks.ReminderTime__c.split(':');
}*/
                
                //tasks.ReminderTime__c = getTime();
                //reminderTime = getGMTTime();
                system.debug('GMT Time:'+reminderTime);
                //system.debug('Get time:'+);
                //GMTTime = reminderTime.split(':');
                //getTime(String selectedTme)
                if(tasks.isReminderSet == True) {
                    //system.debug('tasks.ReminderTime__c : ' + tasks.ReminderTime__c);
                    system.debug('Hour : ' + defaultHours24H);
                    system.debug('Minute : ' + defaultMins);
                    getTime(reminderTime);
                    //system.debug('Second : ' + tasks.ReminderDate__c.second());
                    
                    //ReminderDateTime = DateTime.newInstance(tasks.ReminderDate__c.Year(),tasks.ReminderDate__c.Month(),tasks.ReminderDate__c.day(), Integer.ValueOf(GMTTime[0]),Integer.ValueOf(GMTTime[1]), 0);      
                    ReminderDateTime = DateTime.newInstance(tasks.ReminderDate__c.Year(),tasks.ReminderDate__c.Month(),tasks.ReminderDate__c.day(), hrs,mins, 0);
                    
                    system.debug('ReminderDateTime : ' + ReminderDateTime);
                    tasks.Reminderdatetime = ReminderDateTime;
                    
                } else {
                    tasks.Reminderdatetime = null; 
                }
                
                /**************** In Controller ********************/
                
                system.debug('*********roleList : ' + roleList);
                system.debug('*********groupList : ' + groupList);
                system.debug('*********roleSubList : ' + roleSubList);             
                system.debug('Clogs.Title__c---:'+Clogs.Title__c);
                system.debug('Subject---:'+subjects);
                system.debug('relatedTo---:'+relatedTo);
                system.debug('Priority---:'+Priority);
                system.debug('comments---:'+comments);
                system.debug('status---:'+status);
                system.debug('isReminderSet---: ' + isReminderSet);
                system.debug('ReminderDateTime---: ' + ReminderDateTime);
                
                /**************** In Controller ********************/
                system.debug('Remibder before:'+ tasks.ReminderDateTime);
                system.debug('Remibder Now:'+ system.now());
                
                Id batchJobId = Database.executeBatch(new EPMS_CreationOfTask(roleList, groupList, roleSubList, subjects, Clogs.Title__c, relatedTo,comments,status,Priority, isReminderSet, ReminderDateTime), 100);            
                system.debug('Batch Job ID---:' + batchJobId);
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Task is assigned to Multiple Users Successfully!'));                              
                
            }
            
        }catch(DMLException de) {            
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, de.getDmlMessage(0)));
            return NULL;
        }
        catch(Exception e) {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL, e.getMessage()));
            return NULL;
        }
        
        return null;
    }
    
    public List<selectoption> getReminderTimeOptions() {
        
        optionpick.add(new selectoption('12:00 AM','12:00 AM'));
        optionpick.add(new selectoption('12:30 AM','12:30 AM'));        
        optionpick.add(new selectoption('1:00 AM','1:00 AM'));
        optionpick.add(new selectoption('1:30 AM','1:30 AM'));
        optionpick.add(new selectoption('2:00 AM','2:00 AM'));
        optionpick.add(new selectoption('2:30 AM','2:30 AM'));
        optionpick.add(new selectoption('3:00 AM','3:00 AM'));
        optionpick.add(new selectoption('3:30 AM','3:30 AM'));
        optionpick.add(new selectoption('4:00 AM','4:00 AM'));
        optionpick.add(new selectoption('4:30 AM','4:30 AM'));
        optionpick.add(new selectoption('5:00 AM','5:00 AM'));
        optionpick.add(new selectoption('5:30 AM','5:30 AM'));
        optionpick.add(new selectoption('6:00 AM','6:00 AM'));
        optionpick.add(new selectoption('6:30 AM','6:30 AM'));
        optionpick.add(new selectoption('7:00 AM','7:00 AM'));
        optionpick.add(new selectoption('7:30 AM','7:30 AM'));
        optionpick.add(new selectoption('8:00 AM','8:00 AM'));
        optionpick.add(new selectoption('8:30 AM','8:30 AM'));
        optionpick.add(new selectoption('9:00 AM','9:00 AM'));
        optionpick.add(new selectoption('9:30 AM','9:30 AM'));
        optionpick.add(new selectoption('10:00 AM','10:00 AM'));
        optionpick.add(new selectoption('10:30 AM','10:30 AM'));
        optionpick.add(new selectoption('11:00 AM','11:00 AM'));
        optionpick.add(new selectoption('11:30 AM','11:30 AM'));
        optionpick.add(new selectoption('12:00 PM','12:00 PM'));
        optionpick.add(new selectoption('12:30 PM','12:30 PM'));
        optionpick.add(new selectoption('1:00 PM','1:00 PM'));
        optionpick.add(new selectoption('1:30 PM','1:30 PM'));
        optionpick.add(new selectoption('2:00 PM','2:00 PM'));
        optionpick.add(new selectoption('2:30 PM','2:30 PM'));
        optionpick.add(new selectoption('3:00 PM','3:00 PM'));
        optionpick.add(new selectoption('3:30 PM','3:30 PM'));
        optionpick.add(new selectoption('4:00 PM','4:00 PM'));
        optionpick.add(new selectoption('4:30 PM','4:30 PM'));
        optionpick.add(new selectoption('5:00 PM','5:00 PM'));
        optionpick.add(new selectoption('5:30 PM','5:30 PM'));
        optionpick.add(new selectoption('6:00 PM','6:00 PM'));
        optionpick.add(new selectoption('6:30 PM','6:30 PM'));
        optionpick.add(new selectoption('7:00 PM','7:00 PM'));
        optionpick.add(new selectoption('7:30 PM','7:30 PM'));
        optionpick.add(new selectoption('8:00 PM','8:00 PM'));
        optionpick.add(new selectoption('8:30 PM','8:30 PM'));
        optionpick.add(new selectoption('9:00 PM','9:00 PM'));
        optionpick.add(new selectoption('9:30 PM','9:30 PM'));
        optionpick.add(new selectoption('10:00 PM','10:00 PM'));
        optionpick.add(new selectoption('10:30 PM','10:30 PM'));
        optionpick.add(new selectoption('11:00 PM','11:00 PM'));
        optionpick.add(new selectoption('11:30 PM','11:30 PM'));       
        return optionpick; 
    }
    
    public String getGMTTime() {
        
        DateTime DtTime = DateTime.now();
        DtTime.format();
        system.debug('date formt:'+DateTime.now());
        String[] dTime = string.valueOfGmt(DateTime.now()).split('\\ ');
        System.debug('Date : ' + dTime[0]);
        System.debug('Time : ' + dTime[1]); // 11:46:57
        String tme = dTime[1];
        timeFormat = 'AM';
        String[] timeArr = tme.split('\\:');
        Integer hrs = 0;
        Integer mins = 0;
        
        if (timeArr.size() > 1) {
            hrs = Integer.valueof(timeArr[0]);
            mins = Integer.valueof(timeArr[1]);
            
            if (mins > 30) {
                defaultHours24H = string.valueOf(hrs+1); 
                defaultMins = '00';         
            } else {
                defaultHours24H = string.valueOf(hrs); 
                defaultMins = string.valueOf(30);
            }
            
            System.debug('defaultHours24H 1 : ' + defaultHours24H);
            
            Integer temphrs = Integer.valueof(defaultHours24H);
            
            if (temphrs > 12) {
                temphrs = temphrs - 12;
                defaultHours = string.valueOf(temphrs);
                timeFormat = 'PM';        
            } else {
                defaultHours = defaultHours24H;
            }
        }
        
        String defaultTime = defaultHours+':'+defaultMins+' '+timeFormat;    
        
        System.debug('defaultHours24H : ' + defaultHours24H);
        System.debug('defaultHours : ' + defaultHours);
        System.debug('defaultMins : ' + defaultMins);
        System.debug('defaultTime : ' + defaultTime);
        
        return defaultTime;
    }
    
    public void getTime(String selectedTme) {
        // 5:00 AM
        String[] timeArray = selectedTme.split('\\ ');
        String tme = timeArray[0];
        String tmeFrmt = timeArray[1];
        System.debug('Hrs*** : ' + tme); //5:00
        System.debug('Format*** : ' + tmeFrmt); // AM
        String[] tmeArr = tme.split('\\:');
        hrs = Integer.valueof(tmeArr[0]);
        mins = Integer.valueof(tmeArr[1]);
        
        if (tmeFrmt == 'PM') {
            hrs = hrs + 12;
        }
        
        System.debug('Hrs***** : ' + hrs); 
        System.debug('Mins*** : ' + mins); 
    }      
    
    
    public List<SelectOption> getValues()  {
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Public Groups','Public Groups'));
        options.add(new SelectOption('Roles','Roles'));
        //options.add(new SelectOption('Roles and Subordinates','Roles and Subordinates'));
        return options; 
    }
    
    public List<SelectOption> getListValues() {
        
        Grouplist = [SELECT Name FROM Group];
        List<Groupmember> Groupmemlist = [Select GroupId, UserOrGroupId From GroupMember Where GroupId IN :Grouplist];
        Set<Id> SetOfUsers = new Set<Id>();
        for (GroupMember GrpMem : Groupmemlist){
            if (GrpMem.UserOrGroupId.getSObjectType() == User.SObjectType)
                SetOfUsers.add(GrpMem.UserOrGroupId);
            //rightvalues.add(GrpMem.UserOrGroupId);
            
        }
        system.debug('Group users count:'+ rightvalues.size());
        system.debug('Set of Group users==>'+ SetOfUsers.size());
        
        Userlist = [Select u.FirstName, u.Id, u.LastName, u.UserRoleId, u.UserRole.Name from User u ];
        Userlist1 = [Select u1.FirstName, u1.Id, u1.LastName, u1.UserRoleId, u1.UserRole.Name from User u1];
        system.debug('Set Of Users==>'+ Userlist.size());
        
        userlst = new List<User>();
        EPMS_TaskDistributionCaseLogsController lup = new EPMS_TaskDistributionCaseLogsController();
        lup.refreshPage();
        
        List<SelectOption> options = new List<SelectOption>();
        // options.add(new SelectOption('-- Select One --', '-- Select One --'));
        
        uniqueCustomObjectSet =   new Set<String>();
        
        if( option == 'Public Groups') {            
            for ( Group g : Grouplist) {
                if(g.name != null) {
                    uniqueCustomObjectSet.add('Group :'+g.Name);    
                }
                
            } 
        }
        if (option == 'Roles') {
            for (User u : Userlist) {
                if(u.UserRole.Name != null) {
                    uniqueCustomObjectSet.add('Role : '+u.UserRole.Name);
                }
            }
        }           
        
        if (option == 'Roles and Subordinates') {                        
            for (User u1 : Userlist1) {
                if(u1.UserRole.Name != null) {
                    uniqueCustomObjectSet.add('Roles and Subordinates :'+u1.UserRole.Name);
                }
            } 
        } 
        for(String s : leftselected){
            uniqueCustomObjectSet.remove(s);
            rightvalues.add(s);
        }
        
        List<String> uniqueCustomObjectList = new List<String>(uniqueCustomObjectSet);    
        for(integer i=0; i<uniqueCustomObjectList.size(); i++){
            if ( uniqueCustomObjectList[i] != '' && uniqueCustomObjectList[i] != null)
                options.add(new SelectOption(uniqueCustomObjectList[i],uniqueCustomObjectList[i]));
            
        }
        leftselected.clear();
        uniqueCustomObjectList.clear();        
        return options;  
    }
    
    public PageReference selectclick() {
        rightselected.clear();
        
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
        }
        
        
        
        return null;
    }
    
    public PageReference unselectclick() {
        
        leftselected.clear();
        
        for(String s : rightselected) {
            
            rightvalues.remove(s);
            leftvalues.add(s);
        }
        
        
        return null;
    }
    
    public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options;
        
        options = new List<SelectOption>();
        
        List<string> tempList = new List<String>();
        
        tempList.addAll(leftvalues);
        
        tempList.sort();
        
        for(string s : tempList) {
            options.add(new SelectOption(s,s));
        }
        
        
        
        return options;
        
    }
    
    public List<SelectOption> getSelectedValues(){
        List<SelectOption> options1;
        
        options1 = new List<SelectOption>();
        
        List<string> tempList = new List<String>();
        
        tempList.addAll(rightvalues);        
        tempList.sort();
        
        for(String s : tempList) {
            
            options1.add(new SelectOption(s,s));
        }
        
        
        return options1;
    }
    
    public void refreshPage() {
        
        leftselected.clear();
        selectedValue = option;
        System.debug('*****'+selectedValue +'******Option*****'+option);
        
        
    } 
    
    public pagereference AssignedSave() {
        
        EPMS_TaskDistributionCaseLogsController lup1 = new EPMS_TaskDistributionCaseLogsController();
        lup1.refreshPage();
        
        CountTotalTasks =rightvalues.size();
        system.debug('Count Total Tasks:'+ CountTotalTasks);
        
        system.debug('rightvalues:'+ rightvalues.size());
        system.debug('rightvalues:'+ rightvalues);
        for(String Rvalues : rightvalues) {
            if(strlist != null && strlist != ''){
                strlist = strlist +','+Rvalues;
            }else{
                strlist = Rvalues;
            }
            
        }
        
        
        system.debug('strlist values:'+ strlist);
        
        splitUsers();
        Integer noofUsers = calculateUsers();
        
        taskCount = noofUsers + ' Total Tasks'; 
        
        system.debug('strlist values:'+ strlist);
        
        
        
        return null; 
    }
    
    public Integer calculateUsers() {
        
        integer noofusers = 0;
        List<String> roleName;
        List<String> pubGroup;
        List<String> rolessubNames;   
        list<User> userList=new list<User>();
        list<User> roleList1=new list<User>();
        list<User> pubGroupList1=new list<User>();
        list<UserRole> subRoleIdsList1=new list<UserRole>();
        set<String> userIds=new set<String>();
        set<String> subRoleIds=new set<String>();
        list<User> subRoleUsersList=new list<User>();
        
        roleName=roleListNew;
        pubGroup=groupListNew;
        rolessubNames=roleSubList;
        
        
        if(roleName!=null){
            roleList1=[Select Id, Name,UserRoleId, UserRole.Id, UserRole.Name from User  where UserRole.Name =:roleName and IsActive=True];
            
            for(User u:roleList1){
                if(userIds.add(u.id)){
                    userList.add(u);
                }   
            }
            
            
            system.debug('-----userList------'+userList);
            system.debug('-----userListsize------'+userList.size());
        }
        if(pubGroup!=null){
            
            pubGroupList1=[select id, name, email, isactive, profile.name, userrole.name, usertype from user where id in (select userorgroupid from groupmember where group.name =:pubGroup) and IsActive=True];
            
            system.debug('-----pubGroupList1------'+pubGroupList1);
            
            for(User u:pubGroupList1){
                if(userIds.add(u.id)){
                    userList.add(u);
                }   
            }
            
            system.debug('-----userList------'+userList);
            system.debug('-----userListsize------'+userList.size());
        }
        
        if(rolessubNames!=null){
            subRoleIdsList1=[select id from UserRole where name=:rolessubNames];
            
            for(UserRole subRole:subRoleIdsList1){
                subRoleIds.add(subRole.id);
            }
            
            subRoleUsersList=[Select id,Name from User Where (UserRole.id =:subRoleIds OR UserRole.ParentRoleId=:subRoleIds) and IsActive=True];
            
            //subRoleUsersList=[Select id,Name from User Where UserRole.ParentRoleId=:subRoleIds and IsActive=True];
            
            for(User u:subRoleUsersList){
                if(userIds.add(u.id)){
                    userList.add(u);
                }   
            }
        }
        
        return userList.size();
    }
    
    
    public void splitUsers() {    
        try {
            system.debug('**************After saved Task : ' + tlist); 
            roleListNew = new List<String>();
            groupListNew = new List<String>();
            roleSubList = new List<String>();
            List<String> assignerList = new List<String>();
            List<String> combinedList = new List<String>();
            String key = '';
            String val = '';
            
            assignerList = strlist.split('\\,');
            system.debug('*********assignerList : ' + assignerList);
            
            if (assignerList != null && assignerList.size() > 0) {
                for (String strassigner : assignerList) {
                    //system.debug('*********strassigner : ' + strassigner);
                    combinedList = strassigner.split('\\:');
                    system.debug('*********combinedList : ' + combinedList);
                    if (combinedList != null && combinedList.size() > 0) {
                        key = combinedList[0].trim();
                        val = combinedList[1].trim();
                        system.debug('*********combinedList[0] : ' + key);
                        system.debug('*********combinedList[1] : ' + val);
                        if (key == 'Group') {
                            groupListNew.add(val);
                        }
                        if (key == 'Role') {
                            roleListNew.add(val);
                        }
                        if (key == 'Roles and Subordinates') {
                            roleSubList.add(val);
                        }           
                    }
                    
                }
            }
            
        }catch (Exception e) {
            
        }
    }
}