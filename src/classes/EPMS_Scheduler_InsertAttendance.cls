/**********************************************************************************
*   Class               :       EPMS_Scheduler_class                               *
*   Created Date        :       13/04/2016                                         *           
*   Description         :       Scheduler class for  EPMS_BatchinsertAttendance    *
**********************************************************************************/

global class EPMS_Scheduler_InsertAttendance implements Schedulable{

    public static String sched = '0 0 16 * * ?';  //Every Day at Midnight 

    global static String scheduleMe() {
        EPMS_Scheduler_InsertAttendance SC = new EPMS_Scheduler_InsertAttendance(); 
        return System.schedule('your batch Job', sched, SC);
    }

    global void execute(SchedulableContext sc) {

        EPMS_BatchinsertAttendance b1 = new EPMS_BatchinsertAttendance();
        ID batchprocessid = Database.executeBatch(b1,500);    }
}