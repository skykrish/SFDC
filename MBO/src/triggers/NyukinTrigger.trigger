trigger NyukinTrigger on Nyukin__c (before insert) {

	NyukinTriggerHandler handler = new NyukinTriggerHandler(Trigger.isExecuting, Trigger.size);

	if(Trigger.isInsert && Trigger.isBefore){
		handler.OnBeforeInsert(Trigger.new);
	}

}