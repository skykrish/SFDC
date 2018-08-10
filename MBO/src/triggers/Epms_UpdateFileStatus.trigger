/********************************************************************************************************
    *   Class               :       Epms_UpdateFileStatus                                               *
    *   Created Date        :       13/04/2016                                                          *           
    *   Description         :       This trigger will update the file status based on PO status change  *
********************************************************************************************************/ 
trigger Epms_UpdateFileStatus on Production_Order__c (after update) {
    
    List<Files__c> updateFileList = new List<Files__c>();
 
    List<id> poList = new List<id>();
    
    
    
   // if(EPMS_CheckRecursive_UpdateFileStatus.runOnce()){

    if(Trigger.isAfter && Trigger.isUpdate){
        system.debug('**** Production_Order_Status__c Old Status : ' + trigger.old[0].Production_Order_Status__c);
        system.debug('**** Production_Order_Status__c New Status : ' + trigger.new[0].Production_Order_Status__c);

        //code addition by subbarao For estimation files update on po update to estimation request

//List<files__C> estfilelist = [select id , status__C from files__c where production_order__c=:trigger.newmap.keyset()];

        for(production_order__c p: trigger.new)
        {
            
            if(p.Production_Order_Status__c == Label.EPMS_FileStatus_Estimation_Request)
            {
                system.debug('-----------------production order--------------'+p);
                production_order__C oldpo = trigger.oldmap.get(p.id);
                if(oldpo.Production_Order_Status__c != Label.EPMS_FileStatus_Estimation_Request){
                     system.debug('-----------------production order--------------'+p);
                    poList.add(p.id);
                }
               

            }

        }

            if(poList.size()>0){
                System.debug('-------------------------polist------------'+poList);
             //   System.enqueueJob(new FileQeue (poList));
             Database.executeBatch(new Epms_Batch_UpdateFileStatusAs_EstReq(poList),50);
            }  
          
//code modification ends .
          
        if(trigger.new[0].Production_Order_Status__c == 'Redo') {           
            
            List<files__C> files = [SELECT Id, Name, Status__c FROM Files__c WHERE Production_Order__c =: Trigger.new];            
            for(Files__C f:files){
                f.Status__c = 'Redo';
                f.FTP_Upload_Status__c = false;
                f.FTP_Upload_Time__c = null;
                updateFileList.add(f);
            }
        // Change all Files Status to 'New' for the PO when PO Status changed from 'Awaiting Approval' to 'New'     
        } else if(trigger.old[0].Production_Order_Status__c == Label.EPMS_Status_Awaiting_Approval && trigger.new[0].Production_Order_Status__c == Label.EPMS_FileStatus_New) {           
            
            List<files__C> files = [SELECT Id, Name, Status__c FROM Files__c WHERE Production_Order__c =: Trigger.new];            
            for(Files__C f:files){
                f.Status__c = Label.EPMS_FileStatus_New;
                updateFileList.add(f);
            }           
        } 
        update updateFileList; 
        
  //  }
 
  }
}