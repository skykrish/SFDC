/********************************************************************************************************************************   
*   Trigger             :       Epms_changeAnkenStatus                                                                           *
*   Created Date        :       09/08/2017                                                                                      *           
*   Description         :       Update Anken Status as Uploaded  and TotalProcessingTime also based on production order         *
*   Modification        :       EPMSSF- 521 : Anken Status changed to Waiting Estimation when PO Status is Estimation Request   *   
*                                               Anken Status changed to Estimation Complete when PO Status is Awaiting Approval *       
********************************************************************************************************************************/

trigger Epms_changeAnkenStatus on Production_Order__c (after insert,after update) {
    
    List<id> AnkenIdList = new List<id>();
    List<Anken__c> updateAnkenList = new List<Anken__c>();
    List<id> AnkenEstmIdList = new List<id>();
    Map<id,Anken__c> AnkenMap = new Map<id,Anken__c>();
    List<Anken__c> updateAnkenEstmList = new List<Anken__c>();      
    boolean doStatusCheck = false;
    boolean estimationStatus = false;
    String oldPOStatus = 'false';
     set<id> poids = new set<id>();
       list<Anken__c> updateAnken=new list<Anken__c>();
    boolean estimationCompletedStatus = false;         
    //List<Production_Order__c> prodOrders = [select id,name,Production_Order_Status__c,TotalProcessingTime__c,Anken_Order__c  from Production_Order__c where id=:Trigger.new];
    List<Anken__c> ankenList = new List<Anken__c>();
    for(Production_Order__c PO:Trigger.new) {
        if(!PO.Redo__c || (PO.Redo__c && PO.Production_Order_Status__c == 'Uploaded')) {
            AnkenIdList.add(PO.Anken_Order__c);
            system.debug('********** AnkenIdList : ' + AnkenIdList);
        }
        
        if (PO.Production_Order_Status__c == Label.EPMS_FileStatus_Estimation_Request) {
            AnkenEstmIdList.add(PO.Anken_Order__c);
            estimationStatus = true;
        }
        
        if (PO.Production_Order_Status__c == Label.EPMS_Status_Awaiting_Approval) {
            AnkenEstmIdList.add(PO.Anken_Order__c);
            estimationCompletedStatus = true;
        }            
    }
    system.debug('********** AnkenEstmIdList : ' + AnkenEstmIdList);
    system.debug('********** estimationStatus : ' + estimationStatus);
    system.debug('********** estimationCompletedStatus : ' + estimationCompletedStatus);
    if(Trigger.isUpdate){
        for(integer i=0;i<Trigger.new.size();i++) {
        
        poids.add(Trigger.new[i].id);
        
            system.debug('Entered Here-----------------------------------------------'+trigger.old[i].Production_Order_Status__c);
            system.debug('Entered Here----new status-------------------------------------------'+trigger.new[i].Production_Order_Status__c);
            oldPOStatus = trigger.old[i].Production_Order_Status__c; 
            if(Trigger.old[i]!=null) {
                if(Trigger.new[i].Production_Order_Status__c != Trigger.old[i].Production_Order_Status__c){
                    doStatusCheck = true;    
                }
            }
        }
    }  
    if(!AnkenIdList.isEmpty()&&AnkenIdList.size()>0) {
        
        if(EPMS_CheckRecursive_stus.runTwice()) {
            
            List<Anken__c> ankenOrders = [select id,name,status__c,TotalProcessingTime__c from Anken__c where id=:AnkenIdList];
          //  Map<id,Anken__c> AnkenMap = new Map<id,Anken__c>();
            for(Anken__c anks:ankenOrders) {
                AnkenMap.put(anks.Id, anks);  
                
                 system.debug('--------------AnkenMap------------------------'+AnkenMap);
            } 
            
            // system.debug('--------------prodOrders------------------------'+prodOrders);
            system.debug('--------------ankenOrders------------------------'+ankenOrders);
            
            if(Trigger.isAfter&&Trigger.isInsert) {
                
                system.debug('-------------------Entered Trigger insert------------');
                if(!ankenOrders.isEmpty()&& ankenOrders.size()>0) {
                    for(Anken__c ank:ankenOrders){
                        ank.Status__c = '受注委託済み';
                        ank.HachusakiText__c = Trigger.new[0].Location_For_Sharing__c;
                        ankenList.add(ank);  
                    }
                }    
            }
            if(ankenList.size()>0){
                try{
                    system.debug('********** ankenList : ' + ankenList);
                    update ankenList;
                }catch(exception e){
                    system.debug('--------------exception--------------'+e);
                } 
            }
            
            system.debug('********** doStatusCheck : ' + doStatusCheck);
            
                
                if(Trigger.isUpdate){
                

            if(doStatusCheck){
                   
               //  EPMS_Update_Anken_Status.UpdateAnkenStatus(poids);
                
                   for(Production_Order__c POS:Trigger.new){
                     /*   system.debug('----------------EnteredUpdateOrder---------------------');
                        system.debug('----------------PO.Redo__c---------------------' + POS.Redo__c);
                        if(!POS.Redo__c && POS.Production_Order_Status__c =='Uploaded'){
                            Anken__c ankenOrder = new Anken__c();
                            ankenOrder = AnkenMap.get(POS.Anken_Order__c);
                            ankenOrder.Status__c = 'アップロード完了';
                            //Requirement to get the Total Processing time of Files in Anken Object
                            ankenOrder.TotalProcessingTime__c=POS.TotalProcessingTime__c; 
                            updateAnkenList.add(ankenOrder);
                            system.debug('-----------------------ankenOrder--------------------------'+ankenOrder);
                            // When old PO status is 'Estimation Request' and new PO status is 'New' then Anken status changed to 'Order outsourced' 
                        } else */
                        
                        
                        if(POS.Production_Order_Status__c =='New' && oldPOStatus == Label.EPMS_FileStatus_Estimation_Request){
                            Anken__c ankenOrder = new Anken__c();
                            ankenOrder = AnkenMap.get(POS.Anken_Order__c);
                            ankenOrder.Status__c = 'Order outsourced';
                            updateAnkenList.add(ankenOrder);
                            system.debug('-----------------------ankenOrder--------------------------'+ankenOrder);
                        }                        
                    }   
                }  
                if(updateAnkenList.size()>0){
                  //  try{                        
                        system.debug('********** updateAnkenList : ' + updateAnkenList);
                        Database.SaveResult[] results = Database.Update(updateAnkenList, false);
                        
                        for(Database.SaveResult sr:results){
                        
                        if (sr.isSuccess()) {
       
        System.debug('Successfully inserted record. record ID: ' + sr.getId());
    }
    else {
        // Operation failed, so get all errors               
        for(Database.Error err : sr.getErrors()) {
            System.debug('The following error has occurred.');                   
          System.debug(err.getStatusCode() + ': ' + err.getMessage());
           System.debug('record fields that affected this error: ' + err.getFields());
        }
    }

                        
                        
                        }
                        
                        
                        
                   // }catch(exception e){
                   //     system.debug('--------------exception--------------'+e);
                   // }
                } 
            }
        }
    }
    
    if(!AnkenEstmIdList.isEmpty() && AnkenEstmIdList.size() > 0) {
        
        List<Anken__c> ankenOrders = [select id,name,status__c from Anken__c where id=:AnkenEstmIdList];
        system.debug('********* ankenOrders *******: ' + ankenOrders);
        system.debug('********* estimationStatus *******: ' + estimationStatus);
        system.debug('********* estimationCompletedStatus *******: ' + estimationCompletedStatus);
        Map<id,Anken__c> AnkenEstmMap = new Map<id,Anken__c>();
        for(Anken__c ank:ankenOrders) {
            AnkenEstmMap.put(ank.Id, ank);  
            system.debug('----AnkenEstmMap----'+AnkenEstmMap);
        }
        // When PO is created with 'Estimation Request' status then Anken status changed to 'Waiting Estimation'       
        if(Trigger.isAfter && Trigger.isInsert && estimationStatus) {
            for(Production_Order__c PO : Trigger.new){
                Anken__c ankenOrder = new Anken__c();
                ankenOrder = AnkenEstmMap.get(PO.Anken_Order__c);
                ankenOrder.Status__c = Label.EPMS_AnkenStatus_Waiting_Estimation;
                updateAnkenEstmList.add(ankenOrder);
            }
        // When PO status is changed to 'Estimation Request' then Anken status changed to 'Waiting Estimation'           
        } else if(Trigger.isUpdate && estimationStatus) {
            for(Production_Order__c PO : Trigger.new){
            
            system.debug('---podetails-----'+PO);
                Anken__c ankenOrder = new Anken__c();
                
                if(AnkenMap.get(PO.Anken_Order__c)!=null){
                ankenOrder = AnkenMap.get(PO.Anken_Order__c);
                }
                else{
                ankenOrder = AnkenEstmMap.get(PO.Anken_Order__c);
                }
                
                
                system.debug('------ankenOrderinEst----'+ankenOrder);
                
                ankenOrder.Status__c = Label.EPMS_AnkenStatus_Waiting_Estimation;
           
                updateAnkenEstmList.add(ankenOrder);
            }
            
        // When PO status is changed to 'Awaiting Approval' then Anken status changed to 'Estimation Complete'           
        } else if(Trigger.isUpdate && estimationCompletedStatus) {
            for(Production_Order__c PO : Trigger.new){
                Anken__c ankenOrder = new Anken__c();
                ankenOrder = AnkenEstmMap.get(PO.Anken_Order__c);
                ankenOrder.Status__c = Label.EPMS_AnkenStatus_Estimation_Complete;
                updateAnkenEstmList.add(ankenOrder);
            }       
        }

        if(updateAnkenEstmList.size()>0){
            try{
                system.debug('********** updateAnkenEstmList : ' + updateAnkenEstmList);
                update updateAnkenEstmList; 
            }catch(exception e){
                system.debug('--------------exception--------------'+e);
            }
        }    
    }    
}