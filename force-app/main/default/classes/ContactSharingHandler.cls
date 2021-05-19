public with sharing class ContactSharingHandler {
    public ContactSharingHandler() {
    }

    public static void insertShareContact(List<Reference__c> newList) {
        List <ContactShare> shares = new List<ContactShare>();
        ContactShare contactShare;
        TerritoryUser__c userter;


        for(Reference__c ref : newList) {
            contactShare = new ContactShare ();
            //userter = [];
            //contactShare.UserOrGroupId =  ref.User__c;
            //accountShare.ContactId = ref.Id;
            //cs.ContactAccessLevel = 'Edit';

            shares.add(contactShare);
        }

        //insert shares;

    }
}
