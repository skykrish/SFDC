/**********************************************************************************
*   Class               :       clsTest_EPMS_BatchinsertAttendance                *
*   Created Date        :       25/03/2016                                        *
*   Description         :       Test Class for EPMS_BatchinsertAttendance         *
**********************************************************************************/
@isTest(SeeAllData=true)
private class clsTest_EPMS_BatchinsertAttendance{ 

   static testMethod void EPMS_BatchinsertAttendance(){
        
        Location__c loc=[select id,Name from Location__c where Name='MBOI Phase-4'];
        Member__c member=[SELECT id, Status__c,Name,Designation__c,Location_Id__r.Name FROM Member__c 
                                        WHERE Status__c='Deputed' AND Location_Id__c=:loc.Id limit 4];
        Test.startTest();
                                   
        EPMS_BatchinsertAttendance Attendance=new EPMS_BatchinsertAttendance();
        Database.executeBatch(Attendance);
        Attendance.executeinsertAttendance();
        Test.stopTest();
                                   
   }
}