/****************************************************************************
*   Class               :       EPMS_File_OnHold_Controller                 *
*   Created Date        :       13/06/2016                                  *           
*   Description         :       To on-hold files                            *
/***************************************************************************/


public with sharing class EPMS_File_OnHold_Controller{

     public String qcCommentsForFiles { get; set ;}
     public string fileRecord {get; set;}
     public String[] ids {
        get {
            if (ids == null) {
                String s = ApexPages.currentPage().getParameters().get('ids');
                if (s != null) {
                    ids = s.split(',');
                } else {
                    ids = new String[] {};
                }
            }

            return ids;
        }
        private set;
    }
    public String basepath {
         get {
            basepath = ApexPages.currentPage().getParameters().get('source');
            return basepath;
         }   
         private set;
    }
    
    EPMS_FileOperatorAssignmentService fileService = new EPMS_FileOperatorAssignmentService();
    
    public EPMS_File_OnHold_Controller(){
       if(ids != null && ids.size() > 0){
           fileRecord = ids[0];
       }
    }
 
 public Pagereference onhold_save(){
     system.debug('Input in qcCommentsForFiles :: ' + qcCommentsForFiles);
    if(qcCommentsForFiles == null || String.isBlank(qcCommentsForFiles)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter QC Comments.'));
        return null;
    }                

     //List<Files__c> fileList = fileService.getFileInformation(ids);

     List<Files__c> fileList = [SELECT Id, Name, QC_Comments__c, File_Auto_Number__c,FTP_Upload_Time__c,FTP_Upload_Status__c, Status__c, File_Location__c, Member__c, File_Assignment_Time__c, File_Location__r.Name FROM Files__c WHERE Id IN :ids];

      if(fileList != null && fileList.size() > 0){
           List<Files__c> updateRecord = new List<Files__c>();
           for(Files__c newvalue : fileList){              
                //newvalue.Status__c = 'QCIP';
                newvalue.Status__c = 'On-Hold';
                //newvalue.FTP_Upload_Status__c = false;
                //newvalue.FTP_Upload_Time__c = null;
                if(qcCommentsForFiles != null){
                    newvalue.QC_Comments__c = qcCommentsForFiles;
                }                

                //Update the handover Instruction in Files
                updateRecord.add(newvalue);
           }

           if(updateRecord.size() > 0){
               try {
                   update updateRecord;
                   qcCommentsForFiles = null;
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Selected File(s) are changed to On-Hold Status.'));  
               } catch(DMLException me) {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,me.getMessage()));
                   return null;
               }
           }
        }
        return null;
     }
 
  public Pagereference Cancel(){
        return null;
    }

}