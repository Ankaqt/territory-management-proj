trigger TerritoryUserTrigger on TerritoryUser__c (after insert, after update, before delete) {

    if(Trigger.IsInsert && Trigger.IsAfter){
        TerritorySharingHandler.insertShareTerritory(Trigger.new);
    }

    if(Trigger.IsAfter && Trigger.IsUpdate){
        TerritorySharingHandler.deleteShareTerritory(Trigger.old);
        TerritorySharingHandler.insertShareTerritory(Trigger.new);
    }
    
    if(Trigger.IsBefore && Trigger.IsDelete){
        TerritorySharingHandler.deleteShareTerritory(Trigger.old);
    }

}