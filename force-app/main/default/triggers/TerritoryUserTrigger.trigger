trigger TerritoryUserTrigger on TerritoryUser__c (after insert, after update, before delete) {

    if(Trigger.IsInsert) {
        TerritoryUserSharingHandler.insertShareTerritory(Trigger.new);
        TerritoryUserSharingHandler.insertAccountAndContactShare(Trigger.new);
    }

    if(Trigger.IsAfter && Trigger.IsUpdate) {
        //TerritoryUserSharingHandler.deleteShareTerritory(Trigger.old);
        //TerritoryUserSharingHandler.insertShareTerritory(Trigger.new);
    }
    
    if(Trigger.IsDelete) {
        TerritoryUserSharingHandler.deleteShareTerritory(Trigger.old);
        TerritoryUserSharingHandler.deleteAccountsAndContacts(Trigger.old);
    }
}