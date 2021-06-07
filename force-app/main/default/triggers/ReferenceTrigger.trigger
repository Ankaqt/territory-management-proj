trigger ReferenceTrigger on Reference__c (after insert, after update) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ContactSharingHandler.insertShareContact(Trigger.new);
        }
        if (Trigger.isDelete) {
            ContactSharingHandler.deleteShareContact(Trigger.old);
        }
    }
}