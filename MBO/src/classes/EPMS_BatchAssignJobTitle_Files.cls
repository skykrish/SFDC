/**********************************************************************************
*   Class               :       EPMS_BatchAssignJobTitle_Files                    *
*   Created Date        :       01/02/2018                                        *           
*   Description         :       This Batch Used to Assign Job Title from Anken    * 
*                               to Files when PO status is new                    *
*                                                                                 *
**********************************************************************************/

global class EPMS_BatchAssignJobTitle_Files implements Database.Batchable<sObject> {

    global String query;
    global String jobTitles;
    global String poName;
    global String newStatus = Label.EPMS_FileStatus_New;
    global String fileType = 'image';
    global List<Files__c> updateFilesList = new List<Files__c>();

    //To write Query on Production Order object based on Anken Id
    
    global EPMS_BatchAssignJobTitle_Files(String poName, String jobTitles){
        this.jobTitles=jobTitles;
        this.poName = poName;
        system.debug('----jobTitles----'+jobTitles);
        system.debug('----poName----'+poName);
        query='Select id, Name, File_Job_Titles__c from Files__c where Production_Order_Name__c =: poName and file_type__c=: fileType';
        
    }
    //To Return Query result to the Execute Method
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('-----startbatch----');
        
        return Database.getQueryLocator(query);     
    }  

    global void execute(Database.BatchableContext info, List<Files__c> fileList){
        
        system.debug('-----executebatch-----');

        boolean updateFiles = false; 
        List<Production_Order__c> updatePO = new List<Production_Order__c>();
        

        try {
        
            //filesList = [Select id, Name, File_Job_Titles__c from Files__c where Production_Order_Name__c =: poList[0].Name and file_type__c='image'];
            system.debug('----fileList----'+fileList);
            
            for(Files__c file : fileList) {                
                file.File_Job_Titles__c = jobTitles;
                updateFilesList.add(file);
                //updateFiles = true;
            }
                
            //Update Job Title to files
            if (updateFilesList != null && updateFilesList.size() > 0) {
                system.debug('----After Updated Job Title updateFilesList----'+updateFilesList);
                UPDATE updateFilesList;
            }

        } catch (Exception ex) {
            system.debug('Exception in Updating Job Title to Files : ' + ex);
        } 
    } 
    global void finish(Database.BatchableContext info) {    
    }
}