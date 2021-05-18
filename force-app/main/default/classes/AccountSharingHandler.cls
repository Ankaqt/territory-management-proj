public with sharing class AccountSharingHandler {

    public AccountSharingHandler() {
    }

    public static void insertAccountShare(List<Account> newList) {
        List<AccountShare> shareList = new List<AccountShare>();
        AccountShare accountShare;
        TerritoryUser__c userter;

        for(Account acc : newList) {
            userter = [SELECT User__c FROM TerritoryUser__c WHERE Territory__c = : acc.Territory__c];
            System.debug(userter);
        }

        if (userter != null) {
            for(Account acc : newList) {
                accountShare = new AccountShare();
                accountShare.AccountId = acc.Id;
                accountShare.UserOrGroupId = userter.User__c;
                accountShare.AccountAccessLevel = 'edit';
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

    public static void deleteAccountShare (List<Account> oldList) {
        List <Id> id = new List<Id>();

        for(Account acc : oldList) {
            id.add(acc.Id);
        }

        List<AccountShare> shares = [SELECT ID FROM AccountShare WHERE AccountId IN: id];
        Database.delete(shares, false);
    }
}
