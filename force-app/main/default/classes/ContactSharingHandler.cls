public with sharing class ContactSharingHandler {
    public ContactSharingHandler() {
    }

    public static void insertShareContact(List<Reference__c> newList) {
        List <ContactShare> shares = new List<ContactShare>();
        ContactShare contactShare;
        TerritoryUser__c userter;
        Account accTer;
        Id terId;
        List <TerritoryUser__c> terUser;
        Set <Id> accountIdSet = new Set <Id>();
        Set <Id> territoryIdSet = new Set <Id>();
        Set<Id> users = new Set<Id>();
        Set<Territory__c> parentTerSet;

        for (Reference__c ref : newList) {
            accountIdSet.add(ref.Account__c);
        }

        accTer = [SELECT Territory__c FROM Account WHERE Id = : accountIdSet];
        terId = accTer.Territory__c;
        parentTerSet = TerritoryUserSharingHalper.getTerritoriesHierarchy(terId);

        for (Territory__c ter: parentTerSet) {
            territoryIdSet.add(ter.Id);
        }
        System.debug(territoryIdSet);
        //todo You need to check and share the entire hierarchy of territories
        if (accTer != null) {
            terUser = [SELECT User__c FROM TerritoryUser__c WHERE Territory__c = : territoryIdSet];  
        }
        for(TerritoryUser__c terrUser: terUser) {
            users.add(terrUser.User__c);
        }

        System.debug(terUser);
        System.debug(users);
        if (terUser != null) {
            for(Reference__c ref : newList) {
                for(Id user: users) {
                    contactShare = new ContactShare ();
                    contactShare.ContactId = ref.Contact__c;
                    contactShare.ContactAccessLevel = 'Edit';
                    contactShare.RowCause = 'Manual';
                    contactShare.UserOrGroupId = user;
                    shares.add(contactShare);
                }
            }   
        }

        System.debug(shares);
        Database.SaveResult[] lsr = Database.insert(shares, false);
        for(Database.SaveResult sr : lsr) {
            if(!sr.isSuccess()) {
                Database.Error err = sr.getErrors()[0];
            }
        }
    }

    public static void deleteShareContact(List<Reference__c> oldList) {

    }
}