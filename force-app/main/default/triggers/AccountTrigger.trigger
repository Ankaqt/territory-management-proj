trigger AccountTrigger on Account (after insert, after update) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountSharingHandler.insertAccountShare(Trigger.new);
        }
    }

    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            AccountSharingHandler.deleteAccountAndContactShare(Trigger.old);
        }
    }
}