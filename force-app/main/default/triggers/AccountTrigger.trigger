trigger AccountTrigger on Account (after insert) {

    if(Trigger.IsInsert && Trigger.IsAfter){
        
        AccountSharingHandler.insertAccountShare(Trigger.new);
    }

}