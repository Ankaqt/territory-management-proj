public with sharing class AccountSharingHandler {

    public AccountSharingHandler() {
    }

    public static void insertAccountShare(List<Account> newList) {
        List<AccountShare> shareList = new List<AccountShare>();
        AccountShare accountShare;
        TerritoryUser__c userter;
        Set<Id> territoryIdSet = new Set<Id>();
        

        for(Account acc : newList) {
            territoryIdSet.add(acc.Territory__c);
        }

        //todo You need to check and share the entire hierarchy of territories
        userter = [SELECT User__c FROM TerritoryUser__c WHERE Territory__c =: territoryIdSet];

        if (userter != null) {
            for(Account acc : newList) {

                accountShare = new AccountShare();
                accountShare.AccountId = acc.Id;
                accountShare.UserOrGroupId = userter.User__c;
                accountShare.AccountAccessLevel = 'edit';
                accountShare.ContactAccessLevel = 'edit';
                accountShare.CaseAccessLevel = 'edit';
                accountShare.OpportunityAccessLevel = 'edit';
                shareList.add(accountShare);
            }

            insert shareList;  
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