public with sharing class ContactSharingHandler {
    public ContactSharingHandler() {
    }

    public static void insertShareContact(List<Reference__c> newList) {
        List <ContactShare> shares = new List<ContactShare>();
        ContactShare contactShare;
        ContactShare subContactShare;
        TerritoryUser__c userter;
        Account accTer;
        TerritoryUser__c terUser;
        List <Territory__c> terId;
        Set <Id> accountIdSet = new Set <Id>();
        Set <Id> territoryIdSet = new Set <Id>();
        Id terUserId;

        for (Reference__c ref : newList) {
            accountIdSet.add(ref.Account__c);
        }

        accTer = [SELECT Territory__c FROM Account WHERE Id = : accountIdSet];
        territoryIdSet.add(accTer.Territory__c);

        if (accTer != null) {
            terUser = [SELECT User__c FROM TerritoryUser__c WHERE Territory__c = : accTer.Territory__c];   
        }

        if (territoryIdSet != null) {
            terId = [SELECT Id  FROM Territory__c WHERE Territory__c = : territoryIdSet];
        }

        if (terUser != null) {
            for(Reference__c ref : newList) {
                contactShare = new ContactShare ();
                contactShare.ContactId = ref.Contact__c;
                contactShare.ContactAccessLevel = 'Edit';
                contactShare.RowCause = 'Manual';
                contactShare.UserOrGroupId =  terUser.User__c;
                terUserId = terUser.User__c;
                shares.add(contactShare);
            } 
            
        } 
        insert shares;
    }
}
