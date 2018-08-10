/**********************************************************************************
*   Class               :       EPMS_CreateProductionOrderRedo                  *
*   Created Date        :       06/12/2017                                      *           
*   Description         :       Controller to create Redo PO from Anken         *
*   Version             :       1.0                                             *
**********************************************************************************/

public class EPMS_CreateProductionOrderRedo {
    
    EPMS_ProductionOrderService POService = new EPMS_ProductionOrderService();
    public List<Production_Order__c> existingPO {get;set;}
    public List<Anken__c>  ank {public get; set;}
    public Anken__c  ankenQuery {public get; set;}
    public Production_Order__c currentPO{get;set;}
    public integer posize;
    public string poInstruction{get;set;}
    public string basepath {get;set;}
    public Set<String> orderNameSet = new Set<String>();
    public boolean diableButton{public get;set;}
    Production_Order__c nextPO {get;set;}
    public string fileRecord {get; set;}
    public List<User> currentuser;
    public decimal Filecount {get;set;}
    public List<string> timeValues = new List<string>();
    public String[] orderTime;
    
    //constructor
    public EPMS_CreateProductionOrderRedo() {
        string ids = ApexPages.currentPage().getParameters().get('ids');
        basepath = ApexPages.currentPage().getParameters().get('type');
        List<string> reqids = new List<string>();
        existingPO = new List<Production_Order__c>();
        currentPO = new Production_Order__c();
        currentuser=[Select Id,Name,Country__c from User where Id=:userinfo.getuserId()];
        
        for(String key:ids.split(',')) {
            reqids.add(key);
        } 
        if(reqids!=null) {      
            fileRecord=reqids[0];
        }
        ank = POService.getAnken(reqids);
        
        for(Anken__c  an:ank) {
            orderNameSet.add(String.valueOf(an.Name)+'%');
            timeValues.add(string.valueof(an.Nouki_Time__c));
            Filecount=an.ItemCnt__c;
            if(an.Nouki_Time__c != null){
                orderTime=an.Nouki_Time__c.split(':');
            }
        }
        
        //Query existing production order      
        existingPO =[select id,Name,Mbo_Location__c,Anken_Order__c,Job_List__c,Anken_Order__r.Status__c,Production_Order_Instruction__c,Production_Order_Status__c,Location_For_Sharing__c,Mbo_Location__r.Name from Production_Order__c where Name Like:orderNameSet Limit 100];
        
        //To create Redo Order only when Anken Status was Uploaded - uday sri
       // ankenQuery=[select id,name,Status__c from Anken__c where id=:fileRecord];
        
        
        for(Production_Order__c po:existingPO){
        
            system.debug('????Status Check?????'+po.Production_Order_Status__c);
            if(po.Production_Order_Status__c=='Completed' || po.Production_Order_Status__c=='Uploaded'){
            
            system.debug('-----entering into if block when po status was not equal to completed or uploaded---');
            
           
        }
        else{
        diableButton = true;
         ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,'Redo Order can only be created for the Uploaded or Completed Production Orders'));  
        
        }
        }
        // End - uday sri
        system.debug('===================existingPO==================='+existingPO);
        if(existingPO.size()>0) {
            posize = existingPO.size();
            system.debug('===================poSize==================='+posize);
            currentPO = existingPO[0];
            poInstruction = existingPO[0].Production_Order_Instruction__c;   
        } else {
            diableButton = true;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,'An existing production order is not found to create a redo'));
        } 
    }
    
    public void save() {
        if(ank.size()>0) {
            //ank[0].Status__c = 'Redo'; 
            ank[0].Redo_In_Progress__c =  True;
        }
       // ank[0].Redo_In_Progress__c =  True;
        
        nextPO = new Production_Order__c();
        nextPO.Name = currentPO.Name+'-'+posize;
        nextPO.Redo__c = true;
        nextPO.Mbo_Location__c = currentPO.Mbo_Location__c;
        if(ank[0].Nouki_Time__c != null){
            nextPO.Production_Order_TAT__c = DateTime.newInstance(ank[0].Nouki_Date__c.Year(),ank[0].Nouki_Date__c.Month(),ank[0].Nouki_Date__c.day(), integer.valueof(orderTime[0]),integer.valueof(orderTime[1]), 0);
        }
        nextPO.Location_For_Sharing__c =  currentPO.Location_For_Sharing__c;
        nextPO.Anken_Order__c = currentPO.Anken_Order__c; 
        nextPO.Client_Name__c  = ank[0].KokyakuName__c;
        nextPO.Production_Order_Status__c = 'New';
        nextPO.User__c  = currentuser[0].Id;
        nextPO.Sales_Region_Country__c=currentuser[0].Country__c;
        nextPO.Production_Order_Instruction__c = poInstruction;
        nextPO.Total_Files_Count__c=Filecount; 
        nextPO.Job_List__c=currentPO.Job_List__c;
        try {
            update ank[0];
            insert nextPO;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info,'A Redo Order has been created with name '+nextPO.Name));
            system.debug('--------------------success--------------- '+nextPO);
            system.debug('--------------------ank--------------- '+ank);
        } catch(exception e) {
            system.debug('--------------------error--------------- '+e);
        } 
    }  
}