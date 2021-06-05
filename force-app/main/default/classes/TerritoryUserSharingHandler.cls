public with sharing class TerritoryUserSharingHandler {

    public TerritoryUserSharingHandler() {
    }

    //todo Sharing of the territory is not needed
    //todo need Shares on Account and Contact
    public static void insertShareTerritory(List<TerritoryUser__c> newList) {
        List <Territory__Share> shares = new List<Territory__Share>();
        Territory__Share territoryShare;
        Territory__Share subTerritoryShare;
        Territory__Share nextSubTerritoryShare;
        List <Territory__c> terId;
        List <Territory__c> subTerId;
        Set <Id> territoryIdSet = new Set<Id>();
        Id territoryId;
        Id terUserId;
        Set<Territory__c> result = new Set<Territory__c>();
        Set<Id> allTerritories = new Set<Id>();

        for(TerritoryUser__c terUser : newList) {
            territoryShare = new Territory__Share();
            territoryShare.UserOrGroupId =  terUser.User__c;
            territoryShare.ParentId = terUser.Territory__c;
            territoryShare.AccessLevel = 'read';
            territoryShare.RowCause = Schema.Territory__Share.RowCause.Manual;
            shares.add(territoryShare);
            territoryIdSet.add(terUser.Territory__c);
            territoryId = terUser.Territory__c;
            terUserId = terUser.User__c;
        }

        //todo The condition contains 3 levels of nesting. How can you make unlimited nesting levels?
        allTerritories = TerritoryUserSharingHalper.getAllTerritoriesHierarchy(territoryIdSet);
        terId = [SELECT Id, Name  FROM Territory__c WHERE Territory__c = : allTerritories];

        if(terId != null) {
            for (Territory__c ter : terId) {
                subTerritoryShare = new Territory__Share();
                subTerritoryShare.UserOrGroupId = terUserId;
                subTerritoryShare.ParentId = ter.Id;
                subTerritoryShare.AccessLevel = 'read';
                subTerritoryShare.RowCause = Schema.Territory__Share.RowCause.Manual;
                shares.add(subTerritoryShare);    
            } 
        }

        Database.SaveResult[] lsr = Database.insert(shares, false);
        for(Database.SaveResult sr : lsr) {
            if(!sr.isSuccess()) {
                Database.Error err = sr.getErrors()[0];
            }
        }
    }

    public static void insertAccountAndContactShare(List<TerritoryUser__c> newList) {
        List<AccountShare> accountsShares = new List<AccountShare>();
		List<ContactShare> contactsShares = new List<ContactShare>();
        AccountShare accShare;
        ContactShare conShare;
        Set <Id> territoryIdSet = new Set<Id>();
        Id userId;
        List<Account> accList = new List<Account>();
        List<Contact> conList = new List<Contact>();
        List<Reference__c> refList = new List<Reference__c>();
        Set<Id> allTerritories = new Set<Id>();
        Set<Id>accId = new Set<Id>();
        
        for(TerritoryUser__c terUser : newList) {
            territoryIdSet.add(terUser.Territory__C);
            userId = terUser.User__c;
        }

        allTerritories = TerritoryUserSharingHalper.getAllTerritoriesHierarchy(territoryIdSet);
        accList = [SELECT Id, Name FROM Account WHERE Territory__c =: allTerritories];
        System.debug(accList);

        for (Account acc: accList) {
            accShare = new AccountShare();
            accShare.AccountId = acc.Id;
            accShare.UserOrGroupId = userId;
            accShare.AccountAccessLevel = 'edit';
            accShare.ContactAccessLevel = 'edit';
            accShare.CaseAccessLevel = 'edit';
            accShare.OpportunityAccessLevel = 'edit';
            accountsShares.add(accShare);
            accId.add(acc.Id);
        }

        refList = [SELECT Id, Contact__c, Account__c FROM Reference__c WHERE Account__c IN :accId];

        for(Reference__c ref: refList) {
            conShare = new ContactShare();
            conShare.ContactId = ref.Contact__c;
            conShare.ContactAccessLevel = 'Edit';
            conShare.RowCause = 'Manual';
            conShare.UserOrGroupId = userId;
            contactsShares.add(conShare);
        }

        System.debug(accId);
        System.debug(refList);
        insert accountsShares;
        insert contactsShares;
    }

    //todo delete Share on Account and Contact
    public static void deleteShareTerritory (List<TerritoryUser__c> oldList) {
        List <Territory__c> terId;
        List<Id> id = new List<Id>();
        Set <Id> territoryIdSet = new Set<Id>();
        Set <Id> allTerritories = new Set<Id>();

        for(TerritoryUser__c terUser : oldList) {
            id.add(terUser.Territory__c);
            territoryIdSet.add(terUser.Territory__c);
        }

        allTerritories = TerritoryUserSharingHalper.getAllTerritoriesHierarchy(territoryIdSet);
        terId = [SELECT Id, Name  FROM Territory__c WHERE Territory__c = : allTerritories]; 
        System.debug(terId);
        List<Territory__Share> shares = [SELECT ID FROM Territory__Share WHERE ParentId IN: id];
        List<Territory__Share> subShares = [SELECT ID FROM Territory__Share WHERE ParentId IN: terId];     
          
        // todo DML operation with allOrNone = false and no results processing
        Database.delete(shares, false);
        Database.delete(subShares, false);
    }

    public static void deleteAccountsAndContacts(List<TerritoryUser__c> oldList) {
        Set <Id> territoryIdSet = new Set<Id>();
        Set <Id> allTerritories = new Set<Id>();
        List<Account> accList = new List<Account>();
        List<Reference__c> refList = new List<Reference__c>();
        List<Id> conList = new List<Id>();
        Set<Id>accId = new Set<Id>();

        for(TerritoryUser__c terUser : oldList) {
            territoryIdSet.add(terUser.Territory__c);
        }

        allTerritories = TerritoryUserSharingHalper.getAllTerritoriesHierarchy(territoryIdSet);
        accList = [SELECT Id, Name FROM Account WHERE Territory__c =: allTerritories];
        System.debug(accList);

        for(Account acc: accList){
            accId.add(acc.Id);
        }
        
        refList = [SELECT Id, Contact__c, Account__c FROM Reference__c WHERE Account__c IN :accId];

        for(Reference__c ref: refList) {
            conList.add(ref.Contact__c);
        }

        List<AccountShare> accShares = [SELECT ID FROM AccountShare WHERE AccountId IN: accList];
        List<ContactShare> conShares = [SELECT ID FROM ContactShare WHERE ContactId IN: conList];
        Database.delete(accShares, false);
        Database.delete(conShares, false);
    }
}