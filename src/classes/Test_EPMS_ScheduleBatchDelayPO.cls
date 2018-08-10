/**********************************************************************************
*   Class               :       clstest_EPMS_ScheduleBatchDelayPO                       *
*   Created Date        :       16/01/2018                                             *           
*   Description         :       Test class for EPMS_ScheduleBatchDelayPO             *
**********************************************************************************/
@isTest
private class Test_EPMS_ScheduleBatchDelayPO {
    
    static testmethod void  testscheduleBatchEmailAlert(){
        System.Test.StartTest();
        EPMS_ScheduleBatchDelayPO spo = new EPMS_ScheduleBatchDelayPO();
        spo.schedulerMethodFiveMinutes();
        System.Test.StopTest();       
    }
}