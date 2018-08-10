/****************************************************************************************************
    *   Class               :       EPMS_UpdateAnkenAndPOStatus                                     *
    *   Created Date        :       8/04/2018                                                       *            
    *   Description         :       This trigger will update the File Status and PO status to New   *
                            :       from 'Awaiting Approval' and Anken Status to '受注委託済み'       *
****************************************************************************************************/
global class EPMS_UpdateAnkenAndPOStatus {
    
    webservice static void executeBatchUpdateStatus(Id ankid) {             
        String[] orderTime;
            
        Anken__c ank = [select id,name,Status__c, Nouki_Date__c, Nouki_Time__c from Anken__c where id=: ankid];
        List<Production_Order__c>  polist = [Select Name, Production_Order_Status__c,Anken_Order__c,Anken_Order__r.status__c from Production_order__c where Anken_Order__c=:ank.id];
        
        if(polist[0].Production_Order_Status__c == label.EPMS_Status_Awaiting_Approval) {
            //ank.status__c = label.EPMS_AnkenStatus_Dispatched;
            ank.status__c = '受注委託済み';
            polist[0].Production_Order_Status__c = label.EPMS_Status_New;
            
            //system.debug('*********ank.Nouki_Time__c ::: ' + ank.Nouki_Time__c);
            //system.debug('*********ank.Nouki_Date__c ::: ' + ank.Nouki_Date__c);
            if(ank.Nouki_Time__c != null){
                orderTime = ank.Nouki_Time__c.split(':');
                polist[0].Production_Order_TAT__c = DateTime.newInstance(ank.Nouki_Date__c.Year(),ank.Nouki_Date__c.Month(),ank.Nouki_Date__c.day(), integer.valueof(orderTime[0]),integer.valueof(orderTime[1]), 0);            
            }            
        }
        
        system.debug('*********ank ::: ' + ank); 
        
        if(ank != null || polist != null){
            update ank;
            update polist;
            Database.executeBatch(new EPMS_UpdateAnkenAndPOStatusBatch(polist[0].Name));
        }  
    }
}