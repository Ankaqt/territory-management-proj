public with sharing class TerritorySharingHandler {

    public TerritorySharingHandler() {
    }

    public static void insertShareTerritory(List<TerritoryUser__c> newList) {
        List <Territory__Share> shares = new List<Territory__Share>();
        Territory__Share territoryShare;
        Territory__Share subTerritoryShare;
        Territory__Share nextSubTerritoryShare;
        List <Territory__c> terId;
        List<Territory__c>subTerId;

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
                    subTerId = [SELECT Id From Territory__c WHERE Territory__c = : terId];

                    if (subTerId != null) {
                        for (Territory__c subTer: subTerId) {
                            nextSubTerritoryShare = new Territory__Share();
                            nextSubTerritoryShare.UserOrGroupId = terUser.User__c;
                            nextSubTerritoryShare.ParentId = subTer.Id;
                            nextSubTerritoryShare.AccessLevel = 'read';
                            nextSubTerritoryShare.RowCause = Schema.Territory__Share.RowCause.Manual;
                            shares.add(nextSubTerritoryShare);
                        }
                    }
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
        List <Territory__c> terId;
        List <Territory__c> subTerId;

        for(TerritoryUser__c terUser : oldList) {
            id.add(terUser.Territory__c);
            terId = [SELECT Id  FROM Territory__c WHERE Territory__c = : terUser.Territory__c];

            if(terId != null) {
                for (Territory__c ter : terId) {
                    subTerId = [SELECT Id  FROM Territory__c WHERE Territory__c = : terId];
                }
            }  
        }   

        List<Territory__Share> shares = [SELECT ID FROM Territory__Share WHERE ParentId IN: id];
        List<Territory__Share> subShares = [SELECT ID FROM Territory__Share WHERE ParentId IN: terId];
        List<Territory__Share> nextSubShares = [SELECT ID FROM Territory__Share WHERE ParentId IN: subTerId];
        Database.delete(shares, false);
        Database.delete(subShares, false);
        Database.delete(nextSubShares, false);
    }
}
