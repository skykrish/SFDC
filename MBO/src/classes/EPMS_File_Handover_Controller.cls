/****************************************************************************
*   Class               :       EPMS_File_Handover_Controller               *
*   Created Date        :       13/04/2016                                  *           
*   Description         :       To handover files                           *
/***************************************************************************/


public with sharing class EPMS_File_Handover_Controller{

     public String handoverInstruction { get; set ;}
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
    
    public EPMS_File_Handover_Controller(){
       if(ids != null && ids.size() > 0){
           fileRecord = ids[0];
       }
    }
 
 public Pagereference handover_save(){
     
     List<Files__c> fileList = fileService.getFileInformation(ids);
      if(fileList != null && fileList.size() > 0){
           List<Files__c> updateRecord = new List<Files__c>();
           for(Files__c newvalue : fileList){              
                newvalue.Status__c = 'Handover';
                if(handoverInstruction != null){
                    newvalue.File_HandOver_Instructions__c = handoverInstruction;
                }                

                //Update the handover Instruction in Files
                updateRecord.add(newvalue);
           }

           if(updateRecord.size() > 0){
               try {
                   update updateRecord;
                   handoverInstruction = null;
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,label.EPMS_HANDOVER_STATUS));  
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