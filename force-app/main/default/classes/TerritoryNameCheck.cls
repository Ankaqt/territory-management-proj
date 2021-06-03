public with sharing class TerritoryNameCheck {
    public TerritoryNameCheck() {
    }

    public static void checkUniqueName (List<Territory__c> newList) {
        List<Territory__c> territoriesWithParent = new List<Territory__c>();
        List<Territory__c> territoriesWithoutParent = new List<Territory__c>();
        Set<Id> parentTerIds = new Set<Id>();
        List<Territory__c> territoriesWithParents = new List<Territory__c>();
        List<Territory__c> terr = new List<Territory__c>();

        for(Territory__c ter: newList) {

            if(ter.Territory__c != null) {
                territoriesWithParent.add(ter);
                parentTerIds.add(ter.Territory__c);
            } else {
                territoriesWithoutParent.add(ter);
            }
        }

        if(!territoriesWithParent.isEmpty()) {
            territoriesWithParents = [SELECT Id, Name  FROM Territory__c WHERE Territory__c = : parentTerIds];
            if (!territoriesWithParent.isEmpty()) {
                for(Territory__c ter: newList) {
                    compareTerritoryName(ter, territoriesWithParents);
                }
            }
        }

        if(!territoriesWithoutParent.isEmpty()) {
            terr = [SELECT Id, Name FROM Territory__c WHERE Territory__c = null];
            for (Territory__c ter: terr) {
                compareTerritoryName(ter, terr);

            }
        }
    }

    public static void compareTerritoryName (Territory__c newTerritory, List<Territory__c> existingTer) {
        for(Territory__c ter: existingTer) {
            if(ter.Name == newTerritory.Name) {
                newTerritory.addError('The Territory with such name already exists in the system');
            }
        }
    }
}
