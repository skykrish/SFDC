/**********************************************************************************
*   Trigger             :       EPMS_ShiftDeleteVal                               *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Trigger will throw error message while deleting 
                                the team already assigned in any shift            *
**********************************************************************************/


trigger EPMS_ShiftDeleteVal on Shift__c (before delete,before update) {

    List<Shift__C> ShiftHolder = null;
    List<id> shiftNames = new List<id>();
    
    //getting shift record to delete.deactivate
    
    if(Trigger.isDelete){
  
        for(Shift__C shift:Trigger.old){
            shiftNames.add(shift.id);
        }
        
        //Querying shift from shift assignment records
        List<Shift_Assignments__c> shiftAsnmts = Database.query('select Shift_Code__c from Shift_Assignments__c where Shift_Code__c=:shiftNames');
        //trying to delete shift 
        if(shiftAsnmts.size()>0){
           
            Trigger.old[0].addError(label.MBO_EPMS_ERR_RECORD_INACTIVATE);
    }
   }
    if(Trigger.isUpdate){
     
    //getting shift record to delete/deactivate
        for(Shift__C shift:Trigger.new){  
            if(shift.status__C != 'Active'){
                shiftNames.add(shift.id);
             }
        }
    
            //Querying shift from shift assignment records

         List<Shift_Assignments__c> shiftAsnmts = Database.query('select Shift_Code__c from Shift_Assignments__c where Shift_Code__c=:ShiftNames');

         //trying to deactivate shift 
        if(shiftAsnmts.size()>0){           
            Trigger.new[0].addError(Label.MBO_EPMS_ERR_RECORD_INACTIVATE);
        }
        
 }
}