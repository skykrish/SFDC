trigger AnkenMeisaiTrigger on AnkenMeisai__c (before insert, before update, before delete, after UnDelete) {

    AnkenMeisaiTriggerHandler handler = new AnkenMeisaiTriggerHandler(Trigger.isExecuting, Trigger.size);

    if(Trigger.isInsert && Trigger.isBefore){
        handler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        handler.OnBeforeUpdate(Trigger.new);
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        handler.OnBeforeDelete(Trigger.old);
    }
    else if(Trigger.isUnDelete){
        handler.OnUndelete(Trigger.new);
    }

}