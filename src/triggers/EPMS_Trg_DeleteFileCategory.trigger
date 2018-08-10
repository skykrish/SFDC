/**************************************************************************************
*   Trigger             :       EPMS_Trg_DeleteFileCategory                            *
*   Created Date        :       13/04/2016                                             *           
*   Description         :       This trigger will throw error message when you try to 
                                delete file category has relationship records in files
                                and performance rating                                  *     
                                                                                       
****************************************************************************************/

trigger EPMS_Trg_DeleteFileCategory  on File_Categories__c (before delete) {

    List<File_Categories__c > FileCategryHolder =null;    
    List<id> Fileids = new List<id>();
    
    // getting category records for deletion and updation
    if(Trigger.isDelete){
         FileCategryHolder = Trigger.old;
    }
    
    if(Trigger.isUpdate){
        FileCategryHolder = Trigger.new;
    } 
     
    for(File_categories__c FCid : Trigger.old)
    {
        Fileids.add(FCid.Id);
    }
    
    // querying performance rating and files related with file category
    List<Performance_Rating__c> PerformaceCategory= [select Id from Performance_Rating__c where File_Category__c=:Fileids];             
    List<Files__c> Files = [select File_Location__c from Files__c where File_Category_Code__c=:Fileids]; 
    
    // validating file category before delete/update
    for(File_Categories__c   FC : Trigger.old){    
        if((Files.size() > 0)  || (PerformaceCategory.size() > 0)){        
            FC.addError(label.EPMS_MBO_Location_Delete);                
        }    
    }      
 

}