trigger AccountTrigger on Account (after insert) {

    if(Trigger.IsInsert && Trigger.IsAfter){
        AccountSharingHandler.insertAccountShare(Trigger.new);
    }

    if(Trigger.IsAfter && Trigger.IsUpdate){
        AccountSharingHandler.deleteAccountShare(Trigger.old);
        AccountSharingHandler.insertAccountShare(Trigger.new);
    }

    if(Trigger.IsBefore && Trigger.IsDelete){
        AccountSharingHandler.deleteAccountShare(Trigger.old);
    }
}