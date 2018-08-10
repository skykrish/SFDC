/**************************************************************************************
*   Trigger             :       ChatterNotificationFor_TL_QC                          *
*   Created Date        :       13/04/2016                                            *           
*   Description         :       Once the Production order is assigned to QC/TL this 
                                Trigger will send chatter notification to the 
                                assigned TL/QC                                        *     
                                                                                       
****************************************************************************************/

trigger ChatterNotificationFor_TL_QC on Production_Order__c (after update) {

    List<Production_Order__c> oldOrderList = trigger.old;
    List<Production_Order__c> updateOrderList = trigger.new;
    Date today = date.today();
    Set<Id> olderOrderTLs = new Set<Id>();
    Set<Id> olderOrderQCs = new Set<Id>();
    Set<Id> memberIds = new Set<Id>();
    
    // Get the member Id of Old Order values
    if(oldOrderList != null && oldOrderList.size() > 0){
        for(Production_Order__c old : oldOrderList){
            olderOrderTLs.add(old.TL_Incharge__c);
            olderOrderQCs.add(old.QC_Incharge__c);
        }
    }
   
    
    Map<String, Object> params = new Map<String, Object>();
    Id orderlocation = null;
    
    // List of Feed Items to be posted for selected Members
    List<FeedItem> finalpost = new List<FeedItem>();
    String productionOrderNames = '';
    
    for(Production_Order__c newOrder : updateOrderList){        
        // Adding Team Leader to flow parameters        
        if(olderOrderTLs.size() > 0){
            // Scenario -> If Team leader is changed from old value 
            if(!olderOrderTLs.contains(newOrder.TL_Incharge__c)){
                params.put('TL_Incharge_Id', newOrder.TL_Incharge__c);
            }
        } else {
            // Scenario -> First Time : When TL is assigned 
            params.put('TL_Incharge_Id', newOrder.TL_Incharge__c);
        }   
        
        // Adding Quality Control to flow parameters
        if(olderOrderQCs.size() > 0){
            // Scenario -> If Quality Control is changed from old value 
            if(!olderOrderQCs.contains(newOrder.QC_Incharge__c)){
                params.put('QC_Incharge_Id', newOrder.QC_Incharge__c);
            }
        } else {
            // Scenario -> First Time : When QC is assigned 
            params.put('TL_Incharge_Id', newOrder.TL_Incharge__c);
        }     
        // Add the production order name to single string
        if(productionOrderNames == ''){
            productionOrderNames = newOrder.Name;
            orderlocation = newOrder.Mbo_Location__c;
        } else{
            productionOrderNames = productionOrderNames + ' , ' + newOrder.Name;
        }

    }    
    // Adding Order Names into flow parameters
    params.put('PrdOrderName', productionOrderNames);    
    // Adding Location into flow parameters
    params.put('ProdOrdLocation', orderlocation);    
    // Adding Chatter Notification into flow parameters
    params.put('displayChatterMessage', 'You Are Assigned to this Production Order(s). Please View these order(s) : ');
    
    // Call the Flow    
    Flow.Interview.TL_QC_LookUp chatterFlow = new Flow.Interview.TL_QC_LookUp(params);
    chatterFlow.start();
}