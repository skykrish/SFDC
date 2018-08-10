/**********************************************************************************
*   Trigger             :       EPMS_SetAnkenStatus                               *
*   Created Date        :       13/04/2016                                        *           
*   Description         :       Update Anken Status based on production order     *
**********************************************************************************/

trigger EPMS_SetAnkenStatus on Production_Order__C(After insert,after update) 
{
    //begins after update 
    if(Trigger.isUpdate&&Trigger.isAfter){
    
        Boolean doStatusCheck = false;
        
        for(Production_Order__c newPO : Trigger.new){
            for(Production_Order__c oldPO : Trigger.old){
            
            if(newPO.FTP_Upload_Status__c != oldPO.FTP_Upload_Status__c){
                doStatusCheck = true;
            }
            }
            }
    
        try
        {
        if(doStatusCheck){      
        
            List<Anken__c> AnkenList= new List<Anken__c>();
            List<Anken__c> CheckAnken = new List<Anken__c>();
        
            //Set of anken Ids that we will iterate through
            Set<id> Ids = new Set<id>();
            for (Production_Order__c  PO : Trigger.new) {
                Ids.add(PO.Anken_Order__c);
            }

            // Get the Anken id and status for each anken
            
            
            
            Map<id, Anken__c> ankenmap= new Map<id, Anken__c>([Select Status__c from Anken__c Where Id in :Ids]);

             CheckAnken = [Select Status__c from Anken__c Where Id in :Ids];            
            
            if(CheckAnken[0].Status__c=='受注委託済み'){             
                for (Production_Order__c pro : Trigger.new) 
                {                                
                            if(pro.Production_Order_Status__c == label.EPMS_UploadedStatus_Order && pro.FTP_Upload_Status__c==true)
                            {
                                //Instantiate a new anken and set it to the current production order parent.  
                                Anken__c anken= ankenmap.get(pro.Anken_Order__c);
                                anken.Status__c= 'アップロード完了';
                                AnkenList.add(anken);
                            }    
                         
                     
                }
            }
            if(AnkenList.size()>0){         
            update AnkenList;
            }
        }
}       
         catch(Exception e) {
            System.debug('ERROR: '+ e);        
        }
    }
    
    // Begins after insert
    if(Trigger.isAfter && Trigger.IsInsert)
    {
        try{
            List<Anken__c> AnkenListStatus= new List<Anken__c>();
            set<id> Orderid = new set<id>();
            set<string> ordername = new set<String>();
            string Locationname = null;

            for(Production_Order__c POT : Trigger.new)
            {
                Orderid.add(POT.Anken_Order__c);
                ordername.add(POT.Name);
                Locationname = POT.Location_For_Sharing__c;
            }
            List<Anken__c> Ankenvalues = [select id,Name,Status__c,HachusakiText__c from Anken__c where Id in: Orderid]; 
            
           if(Ankenvalues!=null){ 
            for(Anken__c  ank:Ankenvalues){
              ank.status__c ='受注委託済み';
              ank.HachusakiText__c = Trigger.new[0].Location_For_Sharing__c;
               AnkenListStatus.add(ank);
              }
            }
            
          
            //update ankenlist
            if(AnkenListStatus.size()>0){
                update AnkenListStatus;
            }
        }catch(Exception e)
        {
            system.debug(''+e);
        }           
    }
}