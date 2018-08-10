global class EPMS_UpdateAnkenAndPOStatusBatch implements Database.Batchable<sObject> {
    
    global String query;
    global String poName;
    global String newStatus = Label.EPMS_FileStatus_New;
    global String fileType = 'image';
    global List<Files__c> updateFilesList = new List<Files__c>();
    
    global EPMS_UpdateAnkenAndPOStatusBatch(String poName) {
        this.poName = poName;
        query='Select File_Location__c,id,Status__c,Production_Order__r.Production_Order_Status__c,Production_Order__c,Production_Order__r.Mbo_Location__c,File_Type__c from Files__c where Production_Order_Name__c =: poName and file_type__c=: fileType';   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {   
        return Database.getQueryLocator(query);        
    }   
    
    global void execute(Database.BatchableContext BC, List<Files__c> fileList) {
        
        Try{
            if(fileList.size()>0) {
                for(Files__c file : fileList) { 
                    if(file.status__c==label.EPMS_Status_Awaiting_Approval) {
                        File.status__c=label.EPMS_Status_New;
                        //File.Production_Order__r.Production_Order_Status__c = label.EPMS_Status_New;
                        updateFilesList.add(file);
                    }
                } 
            }
            
            if (updateFilesList != null && updateFilesList.size() > 0) {
                UPDATE updateFilesList;   
            }
            
        } catch(Exception e) {
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}