public with sharing class ContactSharingHandler {
    public ContactSharingHandler() {
    }

    public static void insertShareContact(List<Reference__c> newList) {
        List <ContactShare> shares = new List<ContactShare>();
        ContactShare contactShare;
        TerritoryUser__c userter;
        Account acc;
        TerritoryUser__c ter;
        Set <Id> territoryIdSet = new Set <Id>();

        for (Reference__c ref : newList) {
            territoryIdSet.add(ref.Account__c);
        }

        acc = [SELECT Territory__c FROM Account WHERE Id = : territoryIdSet];

        if (acc != null) {
            ter = [SELECT User__c FROM TerritoryUser__c WHERE Territory__c = : acc.Territory__c];
        }

        if (ter != null) {
            for(Reference__c ref : newList) {
                contactShare = new ContactShare ();
                contactShare.ContactId = ref.Contact__c;
                contactShare.ContactAccessLevel = 'Edit';
                contactShare.RowCause = 'Manual';
                contactShare.UserOrGroupId =  ter.User__c;
                shares.add(contactShare);
            }   
        } 
        insert shares;
    }
}
