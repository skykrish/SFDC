/****************************************************************************
*   Class               :       EPMS_NextTAT                                *
*   Created Date        :       13/04/2016                                  *           
*   Description         :       To display the current orders for TL/SA/PA  *
/***************************************************************************/


public with sharing class EPMS_NextTAT{
    public List<Production_Order__c> prodOrder {get;set;}
    private List<Member__c> mem= new List<Member__c>();
    public boolean donotDisplay{get;set;} 
    public List<Production_Order__c> lstPron;
    public  Set<datetime> stTime{get;set;}
    public Map<string,List<Production_Order__c>> mapTimewiseOrders{get;set;}
    List<Production_Order__c> lstPrOrder;
    public string userCountry {get; set;}
    public string userId {get; set;}
    public string MyProflieName {get; set;}

    //constructor
    public EPMS_NextTAT() {
        lstPron = new List<Production_Order__c>();
        datetime nowTime = system.now();
        donotDisplay  = false;
        //getting current userid
        userId = String.valueOf(userinfo.getuserid());
        
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        MyProflieName = PROFILE[0].Name;
        if(userId!=null && MyProflieName==EPMS_UTIL.EPMS_COUNTRYADMIN_PROFILE_NAME){
            userCountry=[select Country__c from User Where Id = :UserInfo.getUserId()][0].Country__c;
        }
 try{
            
            if(MyProflieName==EPMS_UTIL.EPMS_COUNTRYADMIN_PROFILE_NAME && userCountry!=null)
            {
            
                prodOrder = [select id,name,Production_Order_TAT__c,Production_Order_Status__c from Production_Order__c where Production_Order_TAT__c >=:nowTime AND (Production_Order_Status__c = 'New'
                             AND Mbo_Location__r.Location_Country__c=: userCountry)];                
           
            }
            else{
                
                mem =  [SELECT Id,Name,Location_id__c,Designation__c FROM Member__c WHERE User_Id__c=:userId limit 1];
                if(mem[0].Location_id__c != null){        
                    prodOrder = [select id,name,Production_Order_TAT__c,Mbo_Location__c,Production_Order_Status__c from Production_Order__c where Production_Order_TAT__c>=:nowTime  AND (Production_Order_Status__c = 'New'
                                AND Mbo_Location__c=: mem[0].Location_id__c) order by Production_Order_TAT__c ASC]; 
                            
                }
            }
            
            stTime = new Set<datetime>();
            For(Production_Order__c pro : prodOrder)
            {
                stTime.add(pro.Production_Order_TAT__c);
            }
            
            if(MyProflieName==EPMS_UTIL.EPMS_COUNTRYADMIN_PROFILE_NAME && userCountry!=null){
                    lstPrOrder = [select id,name,Production_Order_TAT__c,Production_Order_Status__c from Production_Order__c where Production_Order_TAT__c in :stTime AND (Production_Order_Status__c = 'New'
                                AND Mbo_Location__r.Location_Country__c=: userCountry)];
                
            }
            else{
                mem =  [SELECT Id,Name,Location_id__c,Designation__c FROM Member__c WHERE User_Id__c=:userId limit 1];
                if(mem[0].Location_id__c != null){       

                    lstPrOrder = [select id,name,Production_Order_TAT__c,Production_Order_Status__c from Production_Order__c where Production_Order_TAT__c in :stTime AND (Production_Order_Status__c = 'New'
                    AND Mbo_Location__c=: mem[0].Location_id__c)];
                }       
                
            }
            
            
            
            mapTimewiseOrders = new Map<string,List<Production_Order__c>>();

            For(Production_Order__c pron : lstPrOrder)
            {
                if(mapTimewiseOrders.containsKey(string.valueof(pron.Production_Order_TAT__c)))
                {
                    lstPron = mapTimewiseOrders.get(string.valueof(pron.Production_Order_TAT__c));
                    lstPron.add(pron);
                }
                else
                {
                    lstPron = new List<Production_Order__c>();
                    lstPron.add(pron);
                    mapTimewiseOrders.put(string.valueof(pron.Production_Order_TAT__c),lstPron);
                }
            }

            if(prodOrder.size()==0){
                donotDisplay = true;
            }else{
                donotDisplay = false;
            }
    
        }catch(exception e){
            donotDisplay = true;
        }
    }
    
    //getting orders greater than current time
    public void getCurrentOrder(){
        datetime nowTime = system.now();        
        try{
            
            if(MyProflieName==EPMS_UTIL.EPMS_COUNTRYADMIN_PROFILE_NAME && userCountry!=null)
            {
            
                prodOrder = [select id,name,Production_Order_TAT__c,Production_Order_Status__c from Production_Order__c where Production_Order_TAT__c >=:nowTime AND (Production_Order_Status__c = 'New'
                             AND Mbo_Location__r.Location_Country__c=: userCountry)];                
           
            }
            else{
                
                mem =  [SELECT Id,Name,Location_id__c,Designation__c FROM Member__c WHERE User_Id__c=:userId limit 1];
                if(mem[0].Location_id__c != null){        
                    prodOrder = [select id,name,Production_Order_TAT__c,Mbo_Location__c,Production_Order_Status__c from Production_Order__c where Production_Order_TAT__c>=:nowTime  AND (Production_Order_Status__c = 'New'
                                AND Mbo_Location__c=: mem[0].Location_id__c) order by Production_Order_TAT__c ASC]; 
                            
                }
            }
            
            stTime = new Set<datetime>();
            For(Production_Order__c pro : prodOrder)
            {
                stTime.add(pro.Production_Order_TAT__c);
            }
            
            if(MyProflieName==EPMS_UTIL.EPMS_COUNTRYADMIN_PROFILE_NAME && userCountry!=null){
                    lstPrOrder = [select id,name,Production_Order_TAT__c,Production_Order_Status__c from Production_Order__c where Production_Order_TAT__c in :stTime AND (Production_Order_Status__c = 'New'
                                AND Mbo_Location__r.Location_Country__c=: userCountry)];
                
            }
            else{
                mem =  [SELECT Id,Name,Location_id__c,Designation__c FROM Member__c WHERE User_Id__c=:userId limit 1];
                if(mem[0].Location_id__c != null){       

                    lstPrOrder = [select id,name,Production_Order_TAT__c,Production_Order_Status__c from Production_Order__c where Production_Order_TAT__c in :stTime AND (Production_Order_Status__c = 'New'
                    AND Mbo_Location__c=: mem[0].Location_id__c)];
                }       
                
            }
            
            
            
            mapTimewiseOrders = new Map<string,List<Production_Order__c>>();

            For(Production_Order__c pron : lstPrOrder)
            {
                if(mapTimewiseOrders.containsKey(string.valueof(pron.Production_Order_TAT__c)))
                {
                    lstPron = mapTimewiseOrders.get(string.valueof(pron.Production_Order_TAT__c));
                    lstPron.add(pron);
                }
                else
                {
                    lstPron = new List<Production_Order__c>();
                    lstPron.add(pron);
                    mapTimewiseOrders.put(string.valueof(pron.Production_Order_TAT__c),lstPron);
                }
            }

            if(prodOrder.size()==0){
                donotDisplay = true;
            }else{
                donotDisplay = false;
            }
    
        }catch(exception e){
            donotDisplay = true;
        }        
    }

}