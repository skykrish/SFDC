/**********************************************************************************
*   Class               :       EPMS_MemberQueryLocator                           *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Query locator for member object                   *
**********************************************************************************/
public class EPMS_MemberQueryLocator {
     
    public list<Member__c> getMemberlistinfo(list<String> memids){
        list<Member__c> memobj = new list<Member__c>();
        memobj=  [SELECT id,Name,Country__C,Designation__c,Location_id__c,location__c FROM member__C WHERE Id = :memids];
        return memobj;
    }
    
     public list<Member__c> getMemberlist(id memids){
        list<Member__c> memobj = new list<Member__c>();
        memobj=  [SELECT id,Name,Designation__c,Status__c,First_Name__C,Is_Estimator__c,Last_name__C,Email__c,Country__C,Location_id__c,location__c FROM member__C WHERE Id = :memids];
        return memobj;
    }
   
     public list<Member__c> getMemberUpdateUser(set<id> memids){
        list<Member__c> memobj = new list<Member__c>();
        memobj=  [SELECT id,Name,Status__c,Designation__c,Emp_id__c,First_Name__C,Last_name__C,Email__c,Country__C,Location_id__c,location__c FROM member__C WHERE Id = :memids];
        return memobj;
    }
    
     public list<Member__c> getMemberlistinsert(list<id> SelectedID){        
        list<Member__c> memobj = new list<Member__c>();
        memobj= [select id,name ,status__c ,Emp_id__c,Country__c,location_id__c, first_name__c, designation__c,Last_name__c, email__c, User_id__c from Member__c where id IN :SelectedID];
        return memobj;
    }
    
     public list<Member__c> getMemberlistUpdate(list<id> SelectedID){
        list<Member__c> memobj = new list<Member__c>();
        memobj=   [select id,name ,status__c,Today_Attendance__c,Current_Shift__c,Team_Id__c,Emp_id__c,location_id__c, first_name__c, designation__c,Last_name__c, email__c, User_id__c,Contact_Number__c,Date_Of_Birth__c,Sex__c from Member__c where id IN :SelectedID FOR UPDATE];      
        return memobj;
    }
    
    public List<Member__c> getExistMemberList()
    {
        list<Member__c> existMemberList = [select id,name ,status__c ,Emp_id__c,location_id__c, first_name__c, designation__c,Last_name__c, email__c, User_id__c from Member__c];
        return existMemberList;
    }
    public list<Location__c> getLocation(String locname)
    {
        list<location__c> locid = new list<location__c>();
        locid = [Select id,Name from Location__c where id=:locname Limit 1] ; 
        return locid;             
    }
    public group getGroup(String locname)
    {
        list<location__c> locid = new list<location__c>();
        locid = [Select id,Name,Group_Name__c from Location__c where id=:locname Limit 1] ; 
        Group theGroup = [select id from Group where Name=:locid[0].Group_Name__c Limit 1];
        return theGroup;
     }  
     
    public list<Shift_Assignments__c> getTeamAssign(list<id> SelectedID)
    {
        list<Shift_Assignments__c> ST =[Select id, Name, ToTime__c,Member__c from Shift_Assignments__c where Member__c IN: SelectedID AND Shift_Assigned__c=true Limit 10 ];
        return ST;
    }
             
       public list<Shift_Assignments__c> getShiftAssign(list<id> SelectedID)
    {
        list<Shift_Assignments__c> ST1 =[Select id, Name, ToTime__c,Member__c from Shift_Assignments__c where Member__c IN: SelectedID AND Shift_Assigned__c=true Limit 10 ];
        return ST1;
    }  
    
    public list<Member__c> getMemberUpdateOldLoctiondetails(list<id> memid)
    {
        list<Member__c> Memeberdetails = [select id,name,location_id__c from Member__c where id=:memid];
        return Memeberdetails;
    }
    
    public list<user> getUserlist(set<string> MemberEmails)
    {
        list<User> useremaillist = new list<User>();
        useremaillist = [select id,UserName, Email from User where Email IN : MemberEmails];
        return useremaillist;
    }
    
    public list<user> getUserEmailList(set<string> MemberEmails)
    {
        list<User> useremaillist = new list<User>();
        useremaillist = [select id,UserName, Email from User where UserName IN : MemberEmails];        
        return useremaillist;
    }
    
    public list<profile> getUserProfileHolder()        
    {
        list<Profile> profile = [select id,name,UserLicense.Name,UserLicense.Id from profile];
        return profile;
    }

    public list<profile> getUserProfile(string Designation)

    {
        list<Profile> profile = [select id,name,UserLicense.Name,UserLicense.Id from profile where Name=:Designation];
        return profile;
    }
    public  List<userRole> getUserRole()
    {
        List<userRole> userrole =[select id,Name,DeveloperName from userRole]; 
        return userrole;
    }
    public  List<userRole> getUserRoleUpdate(String Designation)
    {
        List<userRole> userrole =[select id,Name,DeveloperName from userRole where Name=:Designation]; 
        return userrole;
    }
    public List<user> getuserdetails(id userid)
    {
        list<User> userdetails = [select id,profileid,UserRoleId,UserName,Email,IsActive,Is_Estimator__c,FirstName,LastName from user where id=:userid];
        return userdetails;
    }
    public List<user> getExistUserList()
    {
        list<User> existUserList = [select id,profileid,UserRoleId,UserName,Email,IsActive,FirstName,LastName from user];
        return existUserList;
    }

    public String getLocationCountry(Id locationID){
        String Country;
        Location__c LocCountry= [Select  Location_Country__c from Location__c where  Id =:locationID];
        return Country=LocCountry.Location_Country__c;
    }

    public list<Member__c> getAutoincrementNumber(list<Member__c> Triggernew)
    {
        list<Member__c> memquery =[select Emp_ID__c  from Member__c where country__c=:Triggernew[0].country__c and Emp_ID__c!=null order by Emp_ID__c desc limit 1];
        return memquery;
    }

    public list<Member__c> getAutoincrementNumber(Member__c Triggernew)
    {
        list<Member__c> memquery =[select Emp_ID__c  from Member__c where country__c=:Triggernew.country__c and Emp_ID__c!=null order by Emp_ID__c desc limit 1];
        return memquery;
    }
    
    public List<Member__c> getMemberOriginalLoc(List<String> MemberEmail,Set<Id> LocID){
        
       list<Member__c> memReurnList = new list<Member__c>();
       Map<String, Member__c> memMap = new Map<String, Member__c>();
       
       list<Member__c> memobj = new list<Member__c>();
        memobj=  [SELECT id,Name,Designation__c,Status__c,First_Name__C,Last_name__C,Email__c,Country__C,Location_id__c,location__c FROM member__C WHERE Location_id__c IN  :LocID AND Status__c=:EPMS_UTIL.EPMS_DEPUTED_STATUS];
        
        for(String EmailData : MemberEmail){
            for(Member__c memberData : memobj){
                if(EmailData==memberData.Email__c){
                    memReurnList.add(memberData);
                }
            }
        }
        
       return memReurnList;
         
    }
     
     public List<Member__c> getMemberOriginalLoc1(List<String> MemberEmail,Set<Id> LocID){        
       list<Member__c> memReurnList = new list<Member__c>();
       list<Member__c> memobj = new list<Member__c>();
        memobj=  [SELECT id,Name,Designation__c,Status__c,First_Name__C,Last_name__C,Email__c,Country__C,Location_id__c,location__c FROM member__C WHERE Location_id__c IN  :LocID  AND Status__c=:EPMS_UTIL.EPMS_DEPUTED_STATUS];
         if(MemberEmail.size()>=2){
             if(MemberEmail[0]==MemberEmail[1]){
               for(Member__c memberData : memobj){
                 if(MemberEmail[0]==memberData.Email__c){
                    memReurnList.add(memberData);
                    }
               }
             }else {               
         for(String EmailData : MemberEmail){             
            for(Member__c memberData : memobj){
                if(EmailData==memberData.Email__c){
                    memReurnList.add(memberData);
                }
            }
        }                   
             }
         }else{
              for(Member__c memberData : memobj){
                 if(MemberEmail[0]==memberData.Email__c){
                    memReurnList.add(memberData);
                }
               }
         }         
       return memReurnList;         
    }
    
     public List<Location__c> getLocationCountryName(List<Member__c> Triggernew){        
        List<Location__c> memquery =[select Location_Country__c  from Location__c where Name=:Triggernew[0].Location__c limit 1];
        return memquery;        
    }
    
    public list<Member__c> getmemberids(list<id> Memberid)
    {
        list<Member__c> memquery = [select id,Name,Emp_ID__c,Today_Attendance__c from Member__c where id IN:Memberid];
        return memquery;
    }
    public list<Shift_Assignments__c> getAssign()
    {
        List<Shift_Assignments__c> assquery = [select id ,Location__c,Member__c,Shift_Code__c from Shift_Assignments__c ];
        return assquery;
    }
    public list<Shift_Assignments__c> getShiftCode(list<Member__c> memberlist)
    {
        List<Shift_Assignments__c> Shiftquery = [select id, Shift_Code__c,Shift_Code__r.Name,Member__c, Member__r.Name,ToTime__c,FromTime__c  from Shift_Assignments__c where Member__c=:memberlist AND Shift_Assigned__c=true ];
        return Shiftquery;
    }

    public List<shift_attendance__c>  getattendance(list<Member__c> memberlist)
    {
        List<shift_attendance__c>  attenquery = [select attendance_status__c,Employee_name__c  from shift_attendance__c where Employee_name__c=:memberlist and Attendance_Date__c=:system.today() Limit 100];
        return attenquery;
    }

    public List<shift_attendance__c>  getShiftAttendance(list<Member__c> memberlist)
    {
        List<shift_attendance__c>  attenquery = [select attendance_status__c,Employee_name__c  from shift_attendance__c where Employee_name__c=:memberlist and Attendance_Date__c=:system.today() ];
        return attenquery;
    }
    public list<member__c> getDeputedMEm(list<id> deputedids)
    {
        list<member__c> memdeputed = [select id,Emp_ID__c,Name,Status__c from Member__c where id =:deputedids and Status__c= :EPMS_UTIL.EPMS_DEPUTED_STATUS];
        return memdeputed;
    }
    public list<member__c> getDeputedMEmAct(list<id> deputedids)
    {
        list<member__c> memdeputed = [select id,Emp_ID__c,Name,Status__c from Member__c where id =:deputedids and Status__c =:EPMS_UTIL.EPMS_ACTIVE_STATUS];
        return memdeputed;
    }
    
    
    public List<shift_attendance__c>  getAllShiftAttendance(list<Member__c> memberlist)
    {
        List<shift_attendance__c>  attenquery = [select attendance_status__c,Employee_name__c  from shift_attendance__c where Employee_name__c=:memberlist];
        return attenquery;
    }

}