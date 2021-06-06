public with sharing class AccountSharingHandler {

    public AccountSharingHandler() {
    }

    public static void insertAccountShare(List<Account> newList) {
        List<AccountShare> shareList = new List<AccountShare>();
        AccountShare accountShare;
        ContactShare conShare;
        List<Reference__c> accountReferences = new List<Reference__c>();
        List <TerritoryUser__c> terUser;
        Set<Id> accountsIdSet = new Set<Id>();
        Set<Id> territoryIdSet = new Set<Id>();
        Set<Id> users = new Set<Id>();
        Account accTer;
        Set<Territory__c> parentTerSet;
        Id terId;
        
        for(Account acc : newList) {
            accountsIdSet.add(acc.Id);
            terId = acc.Territory__c;
        }

        parentTerSet = TerritoryUserSharingHalper.getTerritoriesHierarchy(terId);
        for (Territory__c ter: parentTerSet) {
            territoryIdSet.add(ter.Id);
        }
        System.debug(territoryIdSet);

        accTer = [SELECT Territory__c FROM Account WHERE Id = : accountsIdSet];
        territoryIdSet.add(accTer.Territory__c);
        //todo You need to check and share the entire hierarchy of territories
        if (accTer != null) {
            terUser = [SELECT User__c FROM TerritoryUser__c WHERE Territory__c =: territoryIdSet];
        }
        System.debug(terUser);

        for(TerritoryUser__c terrUser: terUser) {
            users.add(terrUser.User__c);
        }

        if (terUser != null) {
            for(Account acc : newList) {
                for(Id user: users) {
                    accountShare = new AccountShare();
                    accountShare.AccountId = acc.Id;
                    accountShare.UserOrGroupId = user;
                    accountShare.AccountAccessLevel = 'edit';
                    accountShare.ContactAccessLevel = 'edit';
                    accountShare.CaseAccessLevel = 'edit';
                    accountShare.OpportunityAccessLevel = 'edit';
                    shareList.add(accountShare);
                }
            }

            System.debug(shareList);
            Database.SaveResult[] lsr = Database.insert(shareList, false);
            for(Database.SaveResult sr : lsr) {
                if(!sr.isSuccess()) {
                    Database.Error err = sr.getErrors()[0];
                }
            }  
        } else {
            //some warning
            System.debug('Inserting an Account with a territory to which the user is not assigned');   
        }
    }

    // todo Check sharing for contacts
    public static void deleteAccountShare (List<Account> oldList) {
        List <Id> id = new List<Id>();

        for(Account acc : oldList) {
            id.add(acc.Id);
        }

        //todo Sharing will be removed for all users
        List<AccountShare> shares = [SELECT ID FROM AccountShare WHERE AccountId IN: id];

        // todo DML operation with allOrNone = false and no results processing
        Database.delete(shares, false);
    }
}