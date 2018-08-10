/**********************************************************************************
*   Trigger             :       EPMS_TeamDel                                      *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Trigger will throw error message while deleting 
                                the team already assigned in any shift            *
**********************************************************************************/
trigger EPMS_TeamDel on Team__c (before update,before delete) {

    Set<string> ids = new Set<string>();
    
    List<team__C> ShiftHolder = null;
    if(Trigger.isDelete){
        ShiftHolder = Trigger.old;
        for(team__C team:ShiftHolder){
            ids.add(team.Name);
        }
        
        // querying team from shift assignment records 
        List<Shift_Assignments__c> shiftAsnmts = Database.query('select id,member__c from Shift_Assignments__c where team_assignment_id__c IN : ids');
       
        
        for(team__C team:ShiftHolder){
            if(shiftAsnmts.size()>0){
                team.addError(Label.Reference_Records_DeActive);
            }
        }
        
  }

   
}