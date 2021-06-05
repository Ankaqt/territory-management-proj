public with sharing class TerritoryUserSharingHalper {
    public TerritoryUserSharingHalper() {

    }

    public static Set<Territory__c> getTerritoriesHierarchy(Id terId) {
        Set<Territory__c> result = new Set<Territory__c>();
        Id territoryParentId = terId;
        Territory__c ter;

        while(territoryParentId != null) {
            ter = [SELECT Id, Name, Territory__r.Territory__c FROM Territory__C WHERE Id =: territoryParentId LIMIT 1];

            // if(ter.TerritoryUser__r != null) {
                result.add(ter);
            // }
            territoryParentId = ter.Territory__c;
        }
        System.debug(ter);
        System.debug(result);

        return result;
    }

    public static Set<Id> getAllTerritoriesHierarchy(Set<Id> parIdSet) {
        Set<Id> allTerritories = new Set<Id>(parIdSet);
		Set<Id> parentId = new Set<Id>(parIdSet);
        List<Territory__c> childrenTerritories = new List<Territory__c>();

        while (!parentId.isEmpty()) {
			childrenTerritories = [SELECT Id, Name, Territory__c,(SELECT Id FROM Territory__r) FROM Territory__c WHERE Id In: parentId];
			parentId.clear();
			for(Territory__c elem: childrenTerritories) {
				allTerritories.add(elem.Id);
				for (Territory__c childTerritory: elem.Territory__r){
					parentId.add(childTerritory.Id);
				}
			}
		}
        System.debug(allTerritories);
		return allTerritories;
    }
}
