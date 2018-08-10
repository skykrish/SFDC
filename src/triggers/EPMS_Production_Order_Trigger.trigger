/**************************************************************************************
*   Trigger             :       EPMS_Production_Order_Trigger                         *
*   Created Date        :       13/04/2016                                            *           
*   Description         :       This trigger will run based on the Production order 
                                trigger handler functions                             *     
                                                                                       
****************************************************************************************/

trigger EPMS_Production_Order_Trigger on Production_Order__c (before insert,before update,after update) {
    
    
     if(EPMS_CheckRecursive.runOnce()){    
        if(trigger.isBefore){
            if(trigger.isInsert ){
                EPMS_Production_Order_TriggerHandler.onBeforeInsert(trigger.new);
            }  
            
            if(trigger.isUpdate){            
                Set<Id> POIds = new Set<Id>();
                for(Production_order__c pOrder: Trigger.New){
                    POIds.add(pOrder.Id);
                }
                
                for(Production_order__c pOIncharge: Trigger.New){
                    if(pOIncharge.TL_Incharge__c ==null){
                        pOIncharge.Production_Order_TL_Assignment_Time__c=null;

                    }
                    if(pOIncharge.QC_Incharge__c==null){
                        pOIncharge.Production_Order_Qc_Assignment_Time__c=null;

                    }
                    
                    
                }

                List<Files__c> filesList=[select id,Status__c from Files__c where Production_Order__c IN: POIds AND File_Type__c =: label.EPMS_File_Type_Image];

                Map<Id,Production_Order__c> oldPOMap = new Map<ID, Production_Order__c>([select id,Production_Order_Status__c from Production_Order__c where id IN:POIds]);
                

                for(Production_order__c newPO: Trigger.New){
                  
                    if(newPO.Production_Order_Status__c !=oldPOMap.get(newPO.Id).Production_Order_Status__c){
                        newPO.Production_Order_Old_Status__c =oldPOMap.get(newPO.Id).Production_Order_Status__c ;
                        system.debug('Old PO Status Changed to ::: ' + newPO.Production_Order_Old_Status__c);
                        system.debug('PO Status Changed to ::: ' + newPO.Production_Order_Status__c);                        
                    }                                  
                
                }
                if(trigger.isUpdate){
                    EPMS_Production_Order_TriggerHandler.onBeforeUpdate(trigger.new);
                }
            }    
   
         }
         
    }
}