/****************************************************************************
*   Class               :       EPMS_ShiftAttendance_QueryLocator            *
*   Created Date        :       10/12/2015                                   *           
*   Description         :       Query For Shift Attendance                   *
       
/***************************************************************************/

public with sharing class EPMS_ShiftAttendance_QueryLocator{
    
    public Integer CountTotalRecords=0;
    public List<Member__c> memberList =null;
    public List<Shift_Attendance__c> AttendanceList =null;
    
    //Member Details with Query Limit
    public List<Member__c> getMemberDetails(Integer QueryLimit,Integer OffsetSize){
    
        return memberList = [select Id,Name,Emp_ID__c from Member__c order by Name limit :QueryLimit offset :OffsetSize];
    }
    
    //Default Member Count
    public Integer getMemberCount(){
    
       return CountTotalRecords= [select count() from Member__c];
    }
    
    //Member Details with Location Based
    public List<Member__c> getMemberDetails(Id locationId,Integer QueryLimit,Integer OffsetSize){
    
        return memberList = [select Id,Name,Emp_ID__c from Member__c where Location_id__c=:locationId order by Name limit :QueryLimit offset :OffsetSize];
    }
    
    //Member Count with Location Based
    public Integer getMemberCount(Id locationId){
    
       return CountTotalRecords= [select count() from Member__c where Location_id__c=:locationId];
    }
    
    //Attendance Details with Member ID
    public List<Shift_Attendance__c> getAttendanceDetails(Id memberId,Date startDate, Date endDate){
    
        Date fromdt = null;
        Date todt = null;
        if(startDate!=null){
            fromdt = startDate;
        }
        if(endDate!=null){
            todt = endDate;
        }     
        return  AttendanceList=[select Attendance_Date__c,Attendance_Status__c from Shift_Attendance__c where Employee_Name__c =: memberId AND Attendance_Date__c >=:fromdt AND Attendance_Date__c <=:todt ];   
    }  
    
    //Attendance Details
    public List<Shift_Attendance__c> getAttendanceDetails(Date startDate, Date endDate){
    
        Date fromdt = null;
        Date todt = null;
        if(startDate!=null){
            fromdt = startDate;
        }
        if(endDate!=null){
            todt = endDate;
        }     
        return  AttendanceList=[select Attendance_Date__c,Attendance_Status__c from Shift_Attendance__c where Attendance_Date__c >=:fromdt AND Attendance_Date__c <=:todt ];   
    } 
}