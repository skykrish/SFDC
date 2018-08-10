/**********************************************************************************
*   Class               :       clsTest_EPMS_Scheduler_class                      *
*   Created Date        :       09/04/2016                                        *
*   Description         :       Test Class for EPMS_Scheduler_InsertAttendance    *
**********************************************************************************/
@isTest
private class clsTest_EPMS_Scheduler_class {
    static testMethod void EPMS_Scheduler_class(){
    Test.startTest();       
    EPMS_Scheduler_InsertAttendance.scheduleMe();        
    Test.stopTest();   
   }
}