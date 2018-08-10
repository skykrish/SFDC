trigger EPMS_CreatePO_Chatter on Production_Order__c (after insert) {
    
    if(Trigger.isInsert && Trigger.isAfter){
        for(Production_Order__c newOrder : Trigger.new){
            system.debug('--- ENTER INTO CHATTER TRIGGER FOR CREATE_PO ---' + newOrder);
            Map<String, Object> params = new Map<String, Object>();

            // Adding Chatter Notification into flow parameters
            params.put('ProductionFeed', newOrder);
            // Adding Order Names into flow parameters
            params.put('prodOrderName', newOrder.Name);
            
            // Adding Location into flow parameters
            params.put('CreatedProdID', newOrder.Mbo_Location__c);
            

            system.debug('--- FLOW PARAMS CHATTER TRIGGER FOR CREATE_PO ---' + params);
            // Call the Flow                
            Flow.Interview.Production_Order_Flow chatterFlow = new Flow.Interview.Production_Order_Flow(params);
            chatterFlow.start();
        }   
        
    }
}