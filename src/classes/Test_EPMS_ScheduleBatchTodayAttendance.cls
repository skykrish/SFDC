@istest
public class Test_EPMS_ScheduleBatchTodayAttendance {
    
    static testmethod void  TestScheduleBatchTodayAttendance(){
        System.Test.StartTest();
        EPMS_ScheduleBatchTodayAttendance ScheduleToday = new EPMS_ScheduleBatchTodayAttendance();
        ScheduleToday.scheduleMethodOnceADay();
        System.Test.StopTest();    
    }
    
}