/***********************************************************************/
/* Class Name          :  EPMS_ScheduleBatchDelayPO                        */
/*  Created Date       :  11/12/2017                                      */
/* Description         :  Email Alerts to IT Support for New Orders      */
/* Version              : 1.0                                           */
/* Created By           : Lavanya P                                    */
/***********************************************************************/
global with sharing class EPMS_ScheduleBatchDelayPO implements Schedulable {

    global void execute(SchedulableContext sc) {
    
      ID BatchId1 = Database.executeBatch(new EPMS_BatchEmailAlertstoITSupport('MBOI Phase-1'), 200);
       ID BatchId2 = Database.executeBatch(new EPMS_BatchEmailAlertstoITSupport('MBOI Phase-2'), 200);
    }


    Public void schedulerMethodFiveMinutes() {
        String sch1 = '0 0 * * * ?';
        EPMS_ScheduleBatchDelayPO sbich1 = new EPMS_ScheduleBatchDelayPO();
        system.schedule('Every Hour plus 0 min', sch1, sbich1);
        
     
        String sch2 = '0 5 * * * ?';
        EPMS_ScheduleBatchDelayPO sbich2 = new EPMS_ScheduleBatchDelayPO();
        system.schedule('Every Hour plus 5 min', sch2, sbich2);
       
        String sch3 = '0 10 * * * ?';
        EPMS_ScheduleBatchDelayPO sbich3 = new EPMS_ScheduleBatchDelayPO();
        system.schedule('Every Hour plus 10 min', sch3, sbich3);

        String sch4 = '0 15 * * * ?';
        EPMS_ScheduleBatchDelayPO sbich4 = new EPMS_ScheduleBatchDelayPO();
        system.schedule('Every Hour plus 15 min', sch4, sbich4);
        
        String sch5 = '0 20 * * * ?';
        EPMS_ScheduleBatchDelayPO sbich5 = new EPMS_ScheduleBatchDelayPO();
        system.schedule('Every Hour plus 20 min', sch5, sbich5);

        String sch6 = '0 25 * * * ?';
        EPMS_ScheduleBatchDelayPO sbich6 = new EPMS_ScheduleBatchDelayPO();
        system.schedule('Every Hour plus 25 min', sch6, sbich6);

        String sch7 = '0 30 * * * ?';
        EPMS_ScheduleBatchDelayPO sbich7 = new EPMS_ScheduleBatchDelayPO();
        system.schedule('Every Hour plus 30 min', sch7, sbich7);

        String sch8 = '0 35 * * * ?';
        EPMS_ScheduleBatchDelayPO sbich8 = new EPMS_ScheduleBatchDelayPO();
        system.schedule('Every Hour plus 35 min', sch8, sbich8);
        
        String sch9 = '0 40 * * * ?';
        EPMS_ScheduleBatchDelayPO sbich9 = new EPMS_ScheduleBatchDelayPO();
        system.schedule('Every Hour plus 40 min', sch9, sbich9);

        String sch10 = '0 45 * * * ?';
        EPMS_ScheduleBatchDelayPO sbich10 = new EPMS_ScheduleBatchDelayPO();
        system.schedule('Every Hour plus 45 min', sch10, sbich10);

        String sch11 = '0 50 * * * ?';
        EPMS_ScheduleBatchDelayPO sbich11 = new EPMS_ScheduleBatchDelayPO();
        system.schedule('Every Hour plus 50 min', sch11, sbich11);

        String sch12 = '0 55 * * * ?';
        EPMS_ScheduleBatchDelayPO sbich12 = new EPMS_ScheduleBatchDelayPO();
        system.schedule('Every Hour plus 55 min', sch12, sbich12 );
        
    } 
}