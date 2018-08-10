/**********************************************************************************
*   Class               :       EPMS_Scheduler_class_UpdateAttendance              *
*   Created Date        :       13/04/2016                                         *           
*   Description         :       Scheduler class for  EPMS_BatchUpdateMemAttendance *
**********************************************************************************/


global class EPMS_Scheduler_class_UpdateAttendance implements Schedulable{

    public static String sched = '0 0 16 * * ?';  //Every Day at Midnight 

    global static String scheduleMe() {
        EPMS_Scheduler_class_UpdateAttendance SC = new EPMS_Scheduler_class_UpdateAttendance (); 
        return System.schedule('your batch Job', sched, SC);
    }

    global void execute(SchedulableContext sc) {

        EPMS_BatchUpdateMemAttendance b1 = new EPMS_BatchUpdateMemAttendance();
        ID batchprocessid = Database.executeBatch(b1,500);    }
}