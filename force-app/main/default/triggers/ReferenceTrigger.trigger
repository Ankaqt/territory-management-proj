trigger ReferenceTrigger on Reference__c (after insert, after update, before delete) {

    if(Trigger.IsInsert && Trigger.IsAfter){
       ContactSharingHandler.insertShareContact(Trigger.new);
    }

}