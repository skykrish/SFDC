/****************************************************************************
*   Class               :       EPMS_BatchinsertAttendance                  *
*   Created Date        :       13/04/2016                                  *           
*   Description         :       Batch to insert records for deputed members *
/***************************************************************************/

global class EPMS_BatchinsertAttendance implements 
             Database.Batchable<SObject>, Database.Stateful{
    //initilize variables 
    Double failedInserts {get; set;}

    //initilize constructor
    global EPMS_BatchinsertAttendance (){
    
        failedInserts = 0;
        
    }
    
    //query today's attendance from member object
    global Database.queryLocator 
                    start(Database.BatchableContext ctx){
        return Database.getQueryLocator([SELECT id, Status__c,Name,Designation__c,Location_Id__r.Name FROM Member__c 
                                        WHERE Todays_Attendance__c=:EPMS_UTIL.EPMS_DeputedStatus AND Id!=NULL]);
        
    }
    
    //create shift attendance records for each member
    global void execute(Database.BatchableContext ctx, List<Sobject>
                        scope){
        List<Member__c> members= (List<Member__c>)scope;   
        List<Shift_attendance__c> attendanceList = new  List<Shift_attendance__c>();            
        for(Member__c mem:members){
            if(mem.Status__c==EPMS_UTIL.EPMS_DEPUTED_STATUS && mem.Id!=NULL){
               Shift_Attendance__c shift=new Shift_Attendance__c();
                shift.Employee_Name__c=mem.Id;
                shift.Attendance_Status__c=EPMS_UTIL.EPMS_DeputedStatus;           
                shift.Attendance_Date__c=system.today();
               attendanceList.add(shift);                    
              
            } 
        } 

        List<Database.SaveResult> dsrs = Database.insert(attendanceList, false);
        for(Database.SaveResult dsr : dsrs){
            if(!dsr.isSuccess()){
                failedInserts ++;
            }
            
        } 
    }
    
    //execute the batch process with maximum 500 records per batch
    public PageReference executeinsertAttendance () {
        ID batchprocessid = Database.executeBatch(this,500);
        return null;
    }
    
    //finish method 
    global void finish(Database.BatchableContext ctx){
    
        AsyncApexJob a = [SELECT id, ApexClassId, 
                       JobItemsProcessed, TotalJobItems, 
                       NumberOfErrors, CreatedBy.Email 
                       FROM AsyncApexJob 
                       WHERE id = :ctx.getJobId()];
        
        String emailMessage = 'Your batch job '
             + 'AccountOwnerReassignment '
             + 'has finished.  It executed ' 
             + a.totalJobItems 
             + ' batches.  Of which, ' + a.jobitemsprocessed 
             + ' processed without any exceptions thrown and ' 
             + a.numberOfErrors +
             ' batches threw unhandled exceptions.'
             + '  Of the batches that executed without error, ' 
             + failedInserts 
             + ' records were not updated successfully.';
        
        Messaging.SingleEmailMessage mail = 
              new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.createdBy.email};
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('noreply@salesforce.com');
        mail.setSenderDisplayName('Batch Job Summary');
        mail.setSubject('Batch job completed');
        mail.setPlainTextBody(emailMessage);
        mail.setHtmlBody(emailMessage);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] 
                           { mail });
    }
    }