trigger AnkenTrigger on Anken__c (before insert, after insert, before update, after update) {

    AnkenTriggerHandler handler = new AnkenTriggerHandler(Trigger.isExecuting, Trigger.size);

    if(Trigger.isInsert && Trigger.isBefore){
        handler.onBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        handler.onAfterInsert(Trigger.new, Trigger.newMap);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        handler.onBeforeUpdate(Trigger.old, Trigger.oldMap, Trigger.new, Trigger.newMap);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        handler.onAfterUpdate(Trigger.old, Trigger.new, Trigger.newMap);
    }
}