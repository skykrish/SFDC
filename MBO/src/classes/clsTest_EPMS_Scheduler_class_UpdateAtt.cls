/**********************************************************************************
*   Class               :       clsTest_EPMS_Scheduler_class_UpdateAtt            *
*   Created Date        :       09/04/2016                                        *
*   Description         :       Test Class for EPMS_Scheduler_class_UpdateAtt     *
**********************************************************************************/
@isTest
private class clsTest_EPMS_Scheduler_class_UpdateAtt {
    static testMethod void EPMS_Scheduler_class_UpdateAttendance(){
    Test.startTest();       
    EPMS_Scheduler_class_UpdateAttendance.scheduleMe();        
    Test.stopTest();   
   }
}