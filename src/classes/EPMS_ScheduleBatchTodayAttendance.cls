/****************************************************************************/
/* Class Name          :  EPMS_ScheduleBatchTodayAttendance                */
/*  Created Date       :  29/03/2018                                      */
/* Description         :  Schedule to run Batch Mark Attendance          */
/*                        This will run morning 625 AM every day        */  
/* Version              : 1.0                                          */
/* Created By           : Krishna                                     */ 
/*********************************************************************/
global with sharing class EPMS_ScheduleBatchTodayAttendance implements Schedulable {

    global void execute(SchedulableContext sc) {    
      ID BatchId1 = Database.executeBatch(new EPMS_Mark_TodayAttendance(), 100);      
    }
    
    Public void scheduleMethodOnceADay() {
        //String sch = '0 0 6 * * ?';
        //String sch = '0 0 17 ? * * *';
        //String sch = '*/10 * * * *';
        //String sch = '0 25 18 * * ? *';
        String sch = '0 25 6 * * ? *';
        
        EPMS_ScheduleBatchTodayAttendance sba = new EPMS_ScheduleBatchTodayAttendance();
        system.schedule('Mark Present for Indian users', sch, sba);        
    } 
}