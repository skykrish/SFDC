/****************************************************************************
*   Class               :       EPMS_BatchUpdateMemAttendance               *
*   Created Date        :       13/04/2016                                  *           
*   Description         :       Create shift attendance records for No Work
                                 and absent members                         *
/***************************************************************************/

global class EPMS_BatchUpdateMemAttendance implements 
             Database.Batchable<SObject>, Database.Stateful{
             
             
             
    
     Double failedInserts {get; set;}
    //initilize constructor
    global EPMS_BatchUpdateMemAttendance (){
    
        failedInserts = 0;
        
    }
    
    //get records in members based on No work and Absent status
    global Database.queryLocator 
                    start(Database.BatchableContext ctx){
        return Database.getQueryLocator([SELECT id, Status__c,Name,Designation__c,Location_Id__r.Name,Today_Attendance__c FROM Member__c 
                                        WHERE Today_Attendance__c IN ('A', 'NW') AND Id!=NULL]);
        
    }
    
    
    //update member status
    global void execute(Database.BatchableContext ctx, List<Sobject>
                        scope){
        List<Member__c> members= (List<Member__c>)scope;
        
        List<Member__c> memNewList= new  List<Member__c>();            
        for(Member__c mem:members){
            if(mem.Today_Attendance__c ==EPMS_UTIL.EPMS_AbsentStatus || mem.Today_Attendance__c==EPMS_UTIL.EPMS_NWStatus){
               mem.Today_Attendance__c='';
               memNewList.add(mem);                    
              
            } 
        } 

        List<Database.SaveResult> dsrs = Database.update(memNewList, false);
        for(Database.SaveResult dsr : dsrs){
            if(!dsr.isSuccess()){
                failedInserts ++;
            }
            
        } 
    }
    
    
    public PageReference executeUpdateAttendance () {
        ID batchprocessid = Database.executeBatch(this,500);
        return null;
    }
    
    
    //method to send email after batch was completed
    global void finish(Database.BatchableContext ctx){
    
        AsyncApexJob a = [SELECT id, ApexClassId, 
                       JobItemsProcessed, TotalJobItems, 
                       NumberOfErrors, CreatedBy.Email 
                       FROM AsyncApexJob 
                       WHERE id = :ctx.getJobId()];
        String emailMessage = 'Your batch job '
             + 'EPMS_BatchUpdateMemAttendance'
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