/**************************************************************************************
*   Class               :       EPMS_ShiftcodeUpdate                                  *
*   Created Date        :       13/04/2016                                            *           
*   Description         :       class using to create and update shift attendance
                                records                                               *     
                                                                                       
****************************************************************************************/

global class EPMS_ShiftcodeUpdate {
    

webService static void updateNoWork(String UpdateMembers)
{    
    EPMS_MemberQueryLocator QueryLoc = new EPMS_MemberQueryLocator();
    String[] members= UpdateMembers.split(',');
    List<id> memberIDS=new List<id>();
    set<Id> memberIdSet = new Set<id>();
    
    for(string membersSplited:members){
        memberIDS.add(membersSplited);
    }
    memberIdSet.addAll(memberIDS);
    List<Member__c> memberList =QueryLoc.getmemberids(memberIDS);
    List<Member__c> toatalmemberList =QueryLoc.getmemberids(memberIDS);
    list<id> noWorkIds = new list<id>();    
   
    for(Member__c memobj :toatalmemberList )
    {
        noWorkIds.add(memobj.Id);  
    }   
    
    List<shift_attendance__c> shiftAttendStatusList;    
    shiftAttendStatusList = QueryLoc.getShiftAttendance(memberList);    
       
    if(shiftAttendStatusList.size()>0 && shiftAttendStatusList != null)
    {
        List<Shift_attendance__c> updateNoWorkAttendance = new  List<Shift_attendance__c>();
        List<Shift_attendance__c> insertNoWorkAttendance = new  List<Shift_attendance__c>();
        Set<Id> memberAttendanceMap = new Set<Id>();
        List<Shift_attendance__c> updateShiftAttendanceList = new  List<Shift_attendance__c>();        
        set<id> updatedmemberid= new set<id>();        
        for(shift_attendance__c shiftAttendance : shiftAttendStatusList){            
                if(memberIdSet.contains(shiftAttendance.Employee_Name__c)){
                    shiftAttendance.Attendance_Status__c=EPMS_UTIL.EPMS_NWStatus;  
                    updatedmemberid.add(shiftAttendance.Employee_Name__c);
                    updateNoWorkAttendance.add(shiftAttendance);
                }            
        }
        
        for(id memid : memberIdSet){
            
            if(!updatedmemberid.contains(memid)){
                Shift_attendance__c noWorkattend = new Shift_attendance__c();
                noWorkattend.Employee_Name__c=memid;
                noWorkattend.Attendance_Status__c=EPMS_UTIL.EPMS_NWStatus;
                noWorkattend.Attendance_Date__c=system.today();
                updateNoWorkAttendance.add(noWorkattend);
                
            }
        }
        if(updateNoWorkAttendance.size()>0)
        {
            upsert updateNoWorkAttendance;
        }
        
        if(memberList.size()>0 && memberList!=null)
        {
           List<Member__c> updateMemAttendance = new  List<Member__c>();           
            for(Member__c memAttendance : memberList){         
                memAttendance.Today_Attendance__c=EPMS_UTIL.EPMS_NWStatus;
                updateMemAttendance.add(memAttendance);
            }
            if(updateMemAttendance.size()>0 && updateMemAttendance!=null )
            {
                update updateMemAttendance;
            }
        }

    }else{
    
        List<Shift_attendance__c> updateNoWorkAttendance = new  List<Shift_attendance__c>();
    
        for(Member__c noWorkmem : memberList)
        {
            Shift_attendance__c noWorkattend = new Shift_attendance__c();
            noWorkattend.Employee_Name__c=noWorkmem.Id;
            noWorkattend.Attendance_Status__c=EPMS_UTIL.EPMS_NWStatus;
            noWorkattend.Employee_ID__c=noWorkmem.Emp_ID__c;
            noWorkattend.Attendance_Date__c=system.today();
            updateNoWorkAttendance.add(noWorkattend);
        }
        
        if(updateNoWorkAttendance.size()>0 && updateNoWorkAttendance!=null)
        {
            insert updateNoWorkAttendance;    
        }
        
        if(memberList.size()>0 && memberList!=null)
        {
           List<Member__c> updateMemAttendance = new  List<Member__c>();
           
            for(Member__c memAttendance : memberList){         
                memAttendance.Today_Attendance__c=EPMS_UTIL.EPMS_NWStatus;
                updateMemAttendance.add(memAttendance);
            }
            if(updateMemAttendance.size()>0)
            {
                update updateMemAttendance;
            }
        }
    }   
}

// For Absent

webService static void updateAbsent(String UpdateMembers)
{
    
    EPMS_MemberQueryLocator QueryLoc = new EPMS_MemberQueryLocator();
    String[] members= UpdateMembers.split(',');
    List<id> memberIDS=new List<id>();
    set<Id> memberIdSet = new Set<id>();
    for(string membersSplited:members){
        memberIDS.add(membersSplited);
    }
    memberIdSet.addAll(memberIDS);    
    List<Member__c> memberList =QueryLoc.getmemberids(memberIDS);
    List<Member__c> toatalmemberList =QueryLoc.getmemberids(memberIDS);
    list<id> noWorkIds = new list<id>();
    for(Member__c memobj :toatalmemberList )
    {
        noWorkIds.add(memobj.Id);  
    }
    
    
    List<shift_attendance__c> shiftAttendStatusList;
    List<Shift_Assignments__c> shiftCodeList = new list<Shift_Assignments__c>();
    shiftCodeList = QueryLoc.getShiftCode(memberList);  
    shiftAttendStatusList = QueryLoc.getShiftAttendance(memberList);
    
    if(shiftAttendStatusList.size()>0)
    {
        List<Shift_attendance__c> updateNoWorkAttendance = new  List<Shift_attendance__c>();
        List<Shift_attendance__c> updateNoWorkAttendance1 = new  List<Shift_attendance__c>();
        Set<Id> memberAttendanceMap = new Set<Id>();
        List<Shift_attendance__c> updateShiftAttendanceList = new  List<Shift_attendance__c>();
        
        if(shiftAttendStatusList != null){
            for(shift_attendance__c attendance :shiftAttendStatusList){         
                memberAttendanceMap.add(attendance.Employee_Name__c);
            }
        }       
        
        set<id> updatedmemberid= new set<id>();
        for(shift_attendance__c shiftAttendance : shiftAttendStatusList){            
                if(memberIdSet.contains(shiftAttendance.Employee_Name__c)){
                    shiftAttendance.Attendance_Status__c=EPMS_UTIL.EPMS_AbsentStatus;   
                    updatedmemberid.add(shiftAttendance.Employee_Name__c);
                    updateNoWorkAttendance.add(shiftAttendance);
                }            
        }
        for(id memid : memberIdSet){            
            if(!updatedmemberid.contains(memid)){
                Shift_attendance__c noWorkattend = new Shift_attendance__c();
                noWorkattend.Employee_Name__c=memid;
                noWorkattend.Attendance_Status__c=EPMS_UTIL.EPMS_AbsentStatus;
                noWorkattend.Attendance_Date__c=system.today();
                updateNoWorkAttendance.add(noWorkattend);                
            }
        }
        
        if(updateNoWorkAttendance.size()>0)
        {
            upsert updateNoWorkAttendance;
        }
        
        
        if(memberList.size()>0 && memberList!=null)
        {
           List<Member__c> updateMemAttendance = new  List<Member__c>();           
            for(Member__c memAttendance : memberList){         
                memAttendance.Today_Attendance__c=EPMS_UTIL.EPMS_AbsentStatus;
                updateMemAttendance.add(memAttendance);
            }
            if(updateMemAttendance.size()>0)
            {
                update updateMemAttendance;
            }
        }
        
       
    }else{
    
        List<Shift_attendance__c> updateNoWorkAttendance = new  List<Shift_attendance__c>();
    
        for(Member__c noWorkmem : memberList)
        {
          Shift_attendance__c noWorkattend = new Shift_attendance__c();
            noWorkattend.Employee_Name__c=noWorkmem.Id;
            noWorkattend.Attendance_Status__c=EPMS_UTIL.EPMS_AbsentStatus;
            noWorkattend.Employee_ID__c=noWorkmem.Emp_ID__c;
            noWorkattend.Attendance_Date__c=system.today();
            updateNoWorkAttendance.add(noWorkattend);
        }
        
        if(updateNoWorkAttendance.size()>0 && updateNoWorkAttendance!=null)
        {
            insert updateNoWorkAttendance;    
        }
        
        if(memberList.size()>0 && memberList!=null)
        {
           List<Member__c> updateMemAttendance = new  List<Member__c>();           
            for(Member__c memAttendance : memberList){         
                memAttendance.Today_Attendance__c=EPMS_UTIL.EPMS_AbsentStatus;
                updateMemAttendance.add(memAttendance);
            }
            if(updateMemAttendance.size()>0)
            {
                update updateMemAttendance;
            }
        }
    }
    
}

//For Remove Absent

webService static void removeAbsent(String UpdateMembers)
{
    string updateStatus=''; 
    EPMS_MemberQueryLocator QueryLoc = new EPMS_MemberQueryLocator();
    String[] members= UpdateMembers.split(',');
    List<id> memberIDS=new List<id>();
    set<Id> memberIdSet = new Set<id>();
    
    for(string membersSplited:members){
        memberIDS.add(membersSplited);
    }
    memberIdSet.addAll(memberIDS);
    List<Member__c> memberList =QueryLoc.getmemberids(memberIDS);
    List<Member__c> toatalmemberList =QueryLoc.getmemberids(memberIDS);
    list<id> removeAbsentIds = new list<id>();
    for(Member__c memobj :toatalmemberList )
    {
        removeAbsentIds.add(memobj.Id);  
    }
    List<shift_attendance__c> shiftAttendStatusList;
    shiftAttendStatusList = QueryLoc.getAllShiftAttendance(memberList);
    
    List<shift_attendance__c> updateNoWorkAttendance = new List<shift_attendance__c>();
    if(shiftAttendStatusList.size()>0)
    {
          for(shift_attendance__c shiftAttendance : shiftAttendStatusList){
          
            if(memberIdSet.contains(shiftAttendance.Employee_Name__c) && (shiftAttendance.Attendance_Status__c==EPMS_UTIL.EPMS_AbsentStatus)){
                updateNoWorkAttendance.add(shiftAttendance);
            }
        }
        
        if(memberList.size()>0 && memberList!=null)
        {
            List<Member__c> updateMemAttendance = new  List<Member__c>();           
            for(Member__c memAttendance : memberList){         
                memAttendance.Today_Attendance__c='';
                updateMemAttendance.add(memAttendance);
            }
            if(updateMemAttendance.size()>0)
            {
                update updateMemAttendance;
            }
        }       
        
         try {
            if(updateNoWorkAttendance.size() > 0){
                delete updateNoWorkAttendance;
            } else{
                updateStatus = 'Error';
            }
        }
        catch(DMLException me) {
            updateStatus = 'Error';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
        } 
    }else{
        updateStatus = 'Error';
    }
}

}