/**************************************************************************************
*   Trigger             :       EPMS_InstructionUpdate                                * 
*   Created Date        :       13/04/2016                                            *            
*   Description         :       Trigger will update the File order instructions 
based on the production order instruction             *     

****************************************************************************************/

trigger EPMS_InstructionUpdate on Production_Order__c (after insert,after update) {
    
    list<Production_Order__c> ProdUpdate;
    list<Files__c> fileUpdate;
    list<Files__c> Fileins = new list<Files__c>();
    Set<ID> ids = Trigger.newMap.keySet();
    boolean isInstructionChange = false;
    Boolean changeCheck = true;
    string finalstring;
    Map<Id, String> oldOrderMap = new Map<Id, String>();
    List<Production_Order__c> oldProductionInfo = Trigger.Old;
    List<Production_Order__c> newProductionInfo = Trigger.New;
    
   // system.debug('-------Recursivevalue2------'+EPMS_CheckRecursive_UpdateFileStatus.runOnce());
   // if(EPMS_CheckRecursive_UpdateFileStatus.runOnce()){
   
  //  if(EPMS_CheckRec_EPMS_InstructionUpdate.runOnce()){
   
    if(Trigger.isUpdate && Trigger.isAfter) {
        
        for(Production_Order__c oldOrderInfo : oldProductionInfo) {
            oldOrderMap.put(oldOrderInfo.Id, oldOrderInfo.Production_Order_Instruction__c);
        }
        
        for(Production_Order__c oldPO : oldProductionInfo){
            for(Production_Order__c newPO : newProductionInfo){
                if(oldPO.Production_Order_Instruction__c != newPO.Production_Order_Instruction__c){
                    isInstructionChange = true;    
                }
            }
        }
        system.debug(' Test the Status of Order Instruction : ' + isInstructionChange);
    }
    if(isInstructionChange){
        //if(EPMS_CheckRecursiveFileInstUpdate.runOnce()){
        try{
            list<Production_Order__c> poins = new list<Production_Order__c>();
            
            //preparing production order list
            poins = [select id,name,Production_Order_Instruction__c from Production_Order__c where id=:Trigger.New[0].Id limit 1];
            
            // preparing list of files based on production order
            if(poins.size()>0) {    
                Fileins = [select id,name,Order_Instructions__c,Production_Order__c from Files__c where Production_Order__c=:poins[0].Id ];    
            }
            
            fileUpdate = new list<Files__c>();
            
            for(Production_Order__c PINS : poins) {   
                if(oldOrderMap.size() > 0){
                    if(PINS.Production_Order_Instruction__c != oldOrderMap.get(PINS.Id)){
                        for(Files__c FINS : Fileins) {
                            if(PINS.id==FINS.Production_Order__c) {
                                Files__c FS = new Files__c();
                                FS.id=FINS.id;
                                FS.Order_Instructions__c=PINS.Production_Order_Instruction__c;
                                fileUpdate.add(FS);
                            }
                        }
                    }
                    
                } else {
                    for(Files__c FINS : Fileins) {
                        if(PINS.id==FINS.Production_Order__c) {
                            Files__c FS = new Files__c();
                            FS.id=FINS.id;
                            FS.Order_Instructions__c=PINS.Production_Order_Instruction__c;
                            fileUpdate.add(FS);
                        }
                    }
                }
                finalstring = null;
            }
            
            //update file order instructions
            if(fileUpdate.size()>0) {
                Update fileUpdate;
            } // exception handling
        }catch(Exception e) {
            system.debug('--e-----'+e);
        }
        
  //  }  
        
    }
}