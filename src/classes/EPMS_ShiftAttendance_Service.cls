/****************************************************************************
*   Class               :       EPMS_ShiftAttendance_Service                 *
*   Created Date        :       13/04/2016                                   *           
*   Description         :       Query Service Class for Attendance           *
*                               Shift_Attendance__c                          *
        
/***************************************************************************/

public with sharing class EPMS_ShiftAttendance_Service{
    
    public Integer CountTotalRecords=0;
    public List<Member__c> memberList =null;
    public List<Shift_Attendance__c> AttendanceList =null;
    
    EPMS_ShiftAttendance_QueryLocator queryObj = new EPMS_ShiftAttendance_QueryLocator();
    
    //Member Details with Query Limit
    public List<Member__c> getMemberDetails(Integer QueryLimit,Integer OffsetSize){
    
        return memberList = queryObj.getMemberDetails(QueryLimit,OffsetSize);
    }
    
   //Default Member Count
   public Integer getMemberCount(){
    
       return CountTotalRecords= queryObj.getMemberCount();
    }
    
    //Member Details with Location Based
    public List<Member__c> getMemberDetails(Id locationId,Integer QueryLimit,Integer OffsetSize){
    
        return memberList = queryObj.getMemberDetails(locationId,QueryLimit,OffsetSize);
    }
    
   //Member Count with Location Based
   public Integer getMemberCount(Id locationId){
    
       return CountTotalRecords= queryObj.getMemberCount(locationId);
    }
    
    //Attendance Details with Member ID
    public List<Shift_Attendance__c> getAttendanceDetails(Id memberId,Date startDate, Date endDate){
        return  AttendanceList=queryObj.getAttendanceDetails(memberId,startDate,endDate);
    }
    
    //Attendance Details
    public List<Shift_Attendance__c> getAttendanceDetails(Date startDate, Date endDate){
        return  AttendanceList=queryObj.getAttendanceDetails(startDate,endDate);
    }
}