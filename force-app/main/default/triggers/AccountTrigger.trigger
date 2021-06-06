trigger AccountTrigger on Account (after insert, after update) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            AccountSharingHandler.insertAccountShare(Trigger.new);
        }

        // if( Trigger.IsUpdate) {
        //     AccountSharingHandler.deleteAccountShare(Trigger.old);
        //     AccountSharingHandler.insertAccountShare(Trigger.new);
        // }
    }

    // if(Trigger.IsBefore && Trigger.IsDelete){
    //     AccountSharingHandler.deleteAccountShare(Trigger.old);
    // }
}