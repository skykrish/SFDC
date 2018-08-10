trigger HachuInfoTrigger on HachuInfo__c (after delete, after update, after undelete) {

    HachuInfoTriggerHandler handler = new HachuInfoTriggerHandler(Trigger.isExecuting, Trigger.size);

    if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
    else if(Trigger.isDelete && Trigger.isAfter){
        handler.OnAfterDelete(Trigger.old, Trigger.oldMap);
    }
    else if(Trigger.isUnDelete){
        handler.OnUndelete(Trigger.new);
    }

}