trigger ShiireKingakuTrigger on ShiireKingaku__c (before insert) {

    ShiireKingakuTriggerHandler handler = new ShiireKingakuTriggerHandler(Trigger.isExecuting, Trigger.size);

    if(Trigger.isInsert && Trigger.isBefore){
        handler.OnBeforeInsert(Trigger.new);
    }

}