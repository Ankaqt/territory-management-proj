public with sharing class TerritorySharingHandler {

    public TerritorySharingHandler() {
    }

    public static void insertShareTerritory(List<TerritoryUser__c> newList) {
        List <Territory__Share> shares = new List<Territory__Share>();
        Territory__Share territoryShare;
        Territory__Share subTerritoryShare;
        List <Territory__c> terId;

        for(TerritoryUser__c terUser : newList) {
            territoryShare = new Territory__Share();
            territoryShare.UserOrGroupId =  terUser.User__c;
            territoryShare.ParentId = terUser.Territory__c;
            territoryShare.AccessLevel = 'read';
            territoryShare.RowCause = Schema.Territory__Share.RowCause.Manual;
            shares.add(territoryShare);
            terId = [SELECT Id  FROM Territory__c WHERE Territory__c = : terUser.Territory__c];
            
            if(terId != null) {
                for (Territory__c ter:terId) {
                    subTerritoryShare = new Territory__Share();
                    subTerritoryShare.UserOrGroupId = terUser.User__c;
                    subTerritoryShare.ParentId = ter.Id;
                    subTerritoryShare.AccessLevel = 'read';
                    subTerritoryShare.RowCause = Schema.Territory__Share.RowCause.Manual;
                    shares.add(subTerritoryShare);
                }
            }
        }

        Database.SaveResult[] lsr = Database.insert(shares, false);
        for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];
            }
        }
    }

    public static void deleteShareTerritory (List<TerritoryUser__c> oldList) {
        List <Id> id = new List<Id>();

        for(TerritoryUser__c terUser : oldList) {
            id.add(terUser.Territory__c);
        }

        List<Territory__Share> shares = [SELECT ID FROM Territory__Share WHERE ParentId IN: id];
        Database.delete(shares, false);
    }
}
