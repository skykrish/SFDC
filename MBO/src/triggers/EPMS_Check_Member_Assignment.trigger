/**********************************************************************************
*   Class               :       EPMS_Check_Member_Assignment                      *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Trigger will throw error message while deleting 
                                the member already shift assigned is true         *
**********************************************************************************/

trigger EPMS_Check_Member_Assignment on Member__C (before delete) {
    
    Integer inactive=0;
    Integer active=0;
    List<id> memAsnmts = new list<id>();
    
    // getting member for delete    
    for(member__c m : trigger.old)
    {
        memAsnmts.add(m.id);
    }

    // quering shift assignment records for member
    List<Shift_Assignments__c> shiftAsnmts = new list<Shift_Assignments__c>();
    
    shiftAsnmts = [select Member__c, Shift_Assigned__c from Shift_Assignments__c where Member__c =:memAsnmts
                     and Shift_Assigned__c=true];
    
    Map<String, Shift_Assignments__c> assingmentMap = new Map<String, Shift_Assignments__c>();
    
    // delete member
    for(Member__c M : trigger.old){
        if(shiftAsnmts.size()>0){
            M.adderror(Label.EPMS_MBO_Shift_Assign_Member);
        }
    } 
    
}