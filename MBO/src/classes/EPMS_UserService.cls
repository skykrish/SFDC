/**********************************************************************************
*   Class               :       EPMS_UserService                                  *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Used for creating user from member                * 
**********************************************************************************/ 
public class EPMS_UserService{  
 
    public static id  Createu(List<Member__c> mem){
        
        List<Profile> profileHolder = new list<Profile>();
        
        List<userRole> roleHolder = new list<userRole>();
        
        list<string> memgroup = new list<string>();
        string qcprofileid;
        
        //Map<String,User> userMap = new Map<String,User>();
        Set<String> userNameSet = new Set<String>();

        EPMS_MemberQueryLocator queryObj = new EPMS_MemberQueryLocator();
        profileHolder = queryObj.getUserProfileHolder();
        roleHolder = queryObj.getUserRole();
        List<user> existUserList = QueryObj.getExistUserList(); 
        Profile EstimatorProfile=new Profile();
        
        for(User u:existUserList){
            userNameSet.add(u.UserName);
        }
         
        //default email for new user retreiving  from custom settings
        UserEmail__c emailuser= UserEmail__c.getInstance('New User Email');
        String userEmail= emailuser.Email__c;
        
        //Query the profile id with specific name       
        EPMS_CheckRecursive.isFutureUpdate = true;
        string FirstName = mem[0].First_Name__c;
        User userRecHolder = new User();
        
        if(userNameSet.contains(mem[0].Email__c)){
            mem[0].addError(label.EPMS_MemberEmail_Validation);
        }else{
            if(FirstName!=null){
                if(FirstName.length() >= 4){
                    userRecHolder.Alias = FirstName.substring(0,4);
                }else{
                    userRecHolder.Alias = FirstName;
                }
            }else{
                if(mem[0].Last_Name__c.length() >= 4){
                    userRecHolder.Alias = mem[0].Last_Name__c.substring(0,4);
                }else{
                    userRecHolder.Alias = mem[0].Last_Name__c;
                }
            }  
            userRecHolder.Email=userEmail;
            userRecHolder.EmailEncodingKey=EPMS_UTIL.EPMS_EmailEncodingKey;
            userRecHolder.FirstName = mem[0].First_Name__c;    
            userRecHolder.LastName=mem[0].Last_Name__c;
                
            if(mem[0].Designation__c==LABEL.EPMS_DESIG_ESTIMATOR){
            userRecHolder.Is_Estimator__c = True;
            }
            
            else{
            userRecHolder.Is_Estimator__c = False;
            }   
            
            system.debug('--------------'+userRecHolder.Is_Estimator__c);
            
            if(mem[0].country__c == 'India'){
        
                userRecHolder.LanguageLocaleKey=EPMS_UTIL.EPMS_US_LanguageLocaleKey;
                userRecHolder.LocaleSidKey=EPMS_UTIL.EPMS_US_LocaleSidKey; 
                userRecHolder.TimeZoneSidKey=EPMS_UTIL.EPMS_INDIA_TimeZoneSidKey;
                
            }else if(mem[0].country__c == 'USA'){
            
                userRecHolder.LanguageLocaleKey=EPMS_UTIL.EPMS_US_LanguageLocaleKey; 
                userRecHolder.LocaleSidKey=EPMS_UTIL.EPMS_US_LocaleSidKey; 
                userRecHolder.TimeZoneSidKey=EPMS_UTIL.EPMS_US_TimeZoneSidKey;
            }else if(mem[0].country__c == 'Africa'){
            
                userRecHolder.LanguageLocaleKey=EPMS_UTIL.EPMS_US_LanguageLocaleKey; 
                userRecHolder.LocaleSidKey=EPMS_UTIL.EPMS_US_LocaleSidKey; 
                userRecHolder.TimeZoneSidKey=EPMS_UTIL.EPMS_AFRICA_TimeZoneSidKey;
            }else{
                
                userRecHolder.LanguageLocaleKey=EPMS_UTIL.EPMS_JAPAN_LanguageLocaleKey; 
                userRecHolder.LocaleSidKey=EPMS_UTIL.EPMS_JAPAN_LocaleSidKey; 
                userRecHolder.TimeZoneSidKey=EPMS_UTIL.EPMS_JAPAN_TimeZoneSidKey;
            }           
            
            userRecHolder.UserName=mem[0].Email__c;
            
            EstimatorProfile=[select id,name,UserLicense.Name,UserLicense.Id from Profile where Name='Quality Control'];
  
            for(Profile p : profileHolder){
            if(mem[0].Designation__c==LABEL.EPMS_DESIG_ESTIMATOR){
            userRecHolder.profileid=EstimatorProfile.id;
            }
            
            else{   
                if(mem[0].Designation__c == p.name){
                    userRecHolder.profileid = p.id;
                }else if(mem[0].Designation__c == 'EPMS_UTIL.EPMS_FILEESTIMATOR_PROFILE_NAME'){
                    userRecHolder.profileid = qcprofileid;
                }
                }
            }
               
            //testing purpose
            if(userRecHolder.profileid == null){   
               userRecHolder.profileid ='00eN0000000DuFq';
            }      
        
            userRecHolder.IsActive=true; 
            
            if (!Test.isRunningTest()) {
                insert userRecHolder;
            }else {
             //start new context via system.runAs() for the same user for test code only
                    System.runAs(new User(Id = Userinfo.getUserId())) {
                    insert userRecHolder;
                    }
                }
        }
        
        List<Group> PGList= new List<Group>();
               PGList=[select id,name from group];
               system.debug('------PGList----'+PGList);
        
        return userRecHolder.id;        
    }

    @future
    public static void insertRoleAfter(id usrnid,id memId){
    EPMS_MemberQueryLocator QueryObj = new EPMS_MemberQueryLocator();      
        List<Member__c> mem = QueryObj.getMemberlist(memId);                
        List<user> userUpdate = new List<user>();
        List<userRole> uRole=new list<userRole>();
        
        if(mem[0].Designation__c==LABEL.EPMS_DESIG_ESTIMATOR){
        
         uRole = QueryObj.getUserRoleUpdate(LABEL.EPMS_DESIG_ESTIMATOR);
        
        }
        
        
        else{
        uRole = QueryObj.getUserRoleUpdate(mem[0].Designation__c); 
        }
        List<user> usr = QueryObj.getuserdetails(usrnid);         

        //default email for new user retreiving  from custom settings
        UserEmail__c emailuser= UserEmail__c.getInstance('New User Email');
        String userEmail= emailuser.Email__c;
        
        List<Profile> profileHolder = new list<Profile>();
        profileHolder = queryObj.getUserProfileHolder();
        
        if(!uRole.isEmpty()){       
            for(userRole r:uRole){       
                usr[0].UserRoleId = r.Id;
                 
                if(usr[0].username!= mem[0].Email__c ){                                               
                    usr[0].username = mem[0].Email__c;
                }
                for(Profile p : profileHolder){            
                    if(r.Name == p.name){
                        usr[0].profileid = p.id;                        
                    }
                }
                
                if(mem[0].Status__c==EPMS_UTIL.EPMS_ACTIVE_STATUS){
                    usr[0].IsActive=true;
                }
                else if(mem[0].Status__c==EPMS_UTIL.EPMS_INACTIVE_STATUS){
                    usr[0].IsActive=false;
                }
                          
                usr[0].FirstName = mem[0].First_Name__c;    
                usr[0].LastName=mem[0].Last_Name__c;
                usr[0].Email=userEmail;
                userUpdate.add(usr[0]);
            }
            if(userUpdate.size()>0){
                if (!Test.isRunningTest()) {
                    update userUpdate;
                }else {
                   // start new context via system.runAs() for the same user for test code only
                    System.runAs(new User(Id = Userinfo.getUserId())) {
                        update userUpdate;
                    }
                }
            }
        }
    }   
    
    @future
    public static void UpdateUserDetails(id userid,id memId){
    
        EPMS_MemberQueryLocator QueryObj = new EPMS_MemberQueryLocator();  
        Set<String> userNameSet = new Set<String>();
        Map<String,User> userMap = new Map<String,User>();
        List<user> existUserList = QueryObj.getExistUserList();         
        List<Member__c> mem = QueryObj.getMemberlist(memId);        
        List<user> userUpdate = new List<user>();
        List<userRole> uRole =new list<userRole>();
        
        if(mem[0].Designation__c==LABEL.EPMS_DESIG_ESTIMATOR){
        
        uRole = QueryObj.getUserRoleUpdate(LABEL.EPMS_DESIG_ESTIMATOR);
        
        }
        else{
        uRole = QueryObj.getUserRoleUpdate(mem[0].Designation__c); 
        }
        List<user> userdetail = QueryObj.getuserdetails(userid); 

        for(User u:existUserList){
            userNameSet.add(u.UserName);
        }
        
        if(userdetail[0].id!=userid){
            if(userNameSet.contains(mem[0].Email__c)){
                mem[0].addError(label.EPMS_MemberEmail_Validation);
            }
        }else{
            //default email for new user retreiving  from custom settings
            UserEmail__c emailuser= UserEmail__c.getInstance('New User Email');
            String userEmail= emailuser.Email__c;        
            
            if(!uRole.isEmpty()){       
                for(userRole r:uRole){       
                    userdetail[0].UserRoleId = r.Id;
                    
                    if(userdetail[0].username!= mem[0].Email__c ){                                               
                        userdetail[0].username = mem[0].Email__c;
                    } 
                    
                    if(mem[0].Status__c==EPMS_UTIL.EPMS_ACTIVE_STATUS){
                        userdetail[0].IsActive=true;
                    }
                    else if(mem[0].Status__c==EPMS_UTIL.EPMS_INACTIVE_STATUS){
                        userdetail[0].IsActive=false;
                    }                   
                              
                    userdetail[0].FirstName = mem[0].First_Name__c;    
                    userdetail[0].LastName=mem[0].Last_Name__c;
                    userdetail[0].Email=userEmail;
                    
                      if(mem[0].Designation__c==LABEL.EPMS_DESIG_ESTIMATOR){
                    userdetail[0].Is_Estimator__c =True;
                    }
                    else{
                    
                    userdetail[0].Is_Estimator__c = False;
                    }
                    system.debug('--------------'+userdetail[0].Is_Estimator__c);
                    userUpdate.add(userdetail[0]);
                }
                if(userUpdate.size()>0){
                    if (!Test.isRunningTest()) {
                        update userUpdate;
                    }else {
                       // start new context via system.runAs() for the same user for test code only
                        System.runAs(new User(Id = Userinfo.getUserId())) {
                            update userUpdate;
                        }
                    }
                }
            }
             
            EPMS_MemberQueryLocator QueryObj1 = new EPMS_MemberQueryLocator();
            List<user> userdetailProfile = QueryObj1.getuserdetails(userid);
            List<user> userList = new List<user>();
            List<Member__c> mem1 = QueryObj1.getMemberlist(memId);    
       
            List<Profile> profilel= QueryObj1.getUserProfile(mem1[0].Designation__c);
            for(Profile p:profilel){          
                userdetailProfile[0].profileid = p.id;
                userList.add(userdetailProfile[0]);         
            }
            if(userList.size()>0)
            {
                if (!Test.isRunningTest()) {
                            update userList;
                }else {
                   //start new context via system.runAs() for the same user for test code only
                    System.runAs(new User(Id = Userinfo.getUserId())) {
                        update userList;
                    }
                }
            }
        }
        
        }
        
        
        

    }