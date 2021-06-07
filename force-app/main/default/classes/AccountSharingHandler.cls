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
    public static void deleteAccountAndContactShare (List<Account> oldList) {
        List <Id> accId = new List<Id>();
        List<Reference__c> refList = new List<Reference__c>();
        List<Id> conList = new List<Id>();

        for(Account acc : oldList) {
            accId.add(acc.Id);
        }

        refList = [SELECT Id, Contact__c FROM Reference__c WHERE Account__c IN :accId];

        for(Reference__c ref: refList) {
            conList.add(ref.Contact__c);
        }
        //todo Sharing will be removed for all users ????
        List<AccountShare> accShares = [SELECT ID FROM AccountShare WHERE AccountId IN: accId];
        List<ContactShare> conShares = [SELECT ID FROM ContactShare WHERE ContactId IN: conList];
        // todo DML operation with allOrNone = false and no results processing
        Database.DeleteResult[] accSharesResult = Database.delete(accShares, false);
        Database.DeleteResult[] conSharesResult = Database.delete(conShares, false);

        for(Database.DeleteResult sr : accSharesResult) {
            if(!sr.isSuccess()) {
                Database.Error err = sr.getErrors()[0];
            }
        }

        for(Database.DeleteResult sr : conSharesResult) {
            if(!sr.isSuccess()) {
                Database.Error err = sr.getErrors()[0];
            }
        }
    }
}