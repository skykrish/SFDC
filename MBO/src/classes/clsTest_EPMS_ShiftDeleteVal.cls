/**********************************************************************************
*   Class               :       clsTest_EPMS_ShiftDeleteVal                       *
*   Created Date        :       06/04/2016                                        *
*   Description         :       Test Class for EPMS_ShiftDeleteVal                *
**********************************************************************************/
@isTest
private class clsTest_EPMS_ShiftDeleteVal{ 

   static testMethod void EPMS_ShiftDeleteVal()
   {
        Location__c location = new Location__c();
        location.Name = 'INDIA PRIVATE LIMITED - Phaseex2';
        location.Location_Country__c='India';
        location.Location_Status__c ='active';
        location.Group_Name__c='INDIA PVT LTD -Phase2x2';
        insert location;             
   
        Shift__c shift=new Shift__c();
        shift.Name='General Shift';
        shift.Shift_Start_Time__c=system.Now();
        shift.Shift_End_Time__c=system.Now()+2;
        shift.Shift_Location__c=location.Id;
        shift.Status__c='Active';
        shift.Implements_From__c=System.Today();
        insert shift;
        
        Shift_Assignments__c sa=new Shift_Assignments__c();
        sa.Shift_Assigned__c=true;
        sa.Location__c=location.Id;
        sa.Shift_Code__c=shift.Id;
        insert sa;
        
        Test.StartTest();          
            
        Exception e;
        try{
            shift.Status__c ='Inactive';
            update shift;
        
        } catch(Exception ex){
              e = ex;
        } 
        
        list<Shift__c> oldlist=[select Name,Status__c from Shift__c where id=:Shift.id];
        
        try{
            delete oldlist;
        } catch(Exception ex){
            e = ex;
        }
        Test.StopTest();            
   }
}