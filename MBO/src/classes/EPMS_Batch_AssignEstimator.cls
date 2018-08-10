/**********************************************************************************
*   Class               :       EPMS_Batch_AssignEstimator                    *
*   Created Date        :       10/05/2018                                        *           
*   Description         :       This Batch Used to Assign Estimator             * 
*                                                                                 *
**********************************************************************************/

global class EPMS_Batch_AssignEstimator implements Database.Batchable<sObject> {

    global String query;
    global String Estimator;
    global String fileType = 'image';
    global List<String> POIds {get; set;}

    global EPMS_Batch_AssignEstimator(List<String> POIds, String Estimator){
        this.Estimator = Estimator;
        this.POIds = POIds;
        query = 'SELECT Id, Name, Member__c,Splitted_Parent_id__c,IsSplitedFile__c,Member_Assigned__c, Status__c, File_Type__c FROM Files__c WHERE Production_Order__c =: POIds AND File_Type__c =: fileType';
        system.debug('-----query---- : ' + query);
        system.debug('-----POIds---- : ' + POIds);
        system.debug('-----Estimator---- : ' + Estimator);
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('-----startbatch---- : ' + query);
        
        return Database.getQueryLocator(query);     
    }  

    global void execute(Database.BatchableContext info, List<Files__c> fileList){
        
        system.debug('-----executebatch-----');

        boolean updatefile = false; 
        //List<Production_Order__c> updatePO = new List<Production_Order__c>();
        try {
        
            system.debug('---Before-fileList----'+fileList);
            
            if(fileList != null && fileList.size() > 0){        
                for(Files__c fileObj : fileList){
                   fileObj.Estimator__c = Estimator;
                   fileObj.Status__c =  Label.EPMS_Status_Estimator_Assigned;
                   updatefile = true;
                }
            }
            system.debug('Updation files ******** : ' + fileList);

            if (updatefile) {
                UPDATE fileList;
            }
        } catch (Exception ex){
            ApexPages.Addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Problem in assigning Estimator. Please contact support team'));
        }
   } 
    global void finish(Database.BatchableContext info) {    
    }
}