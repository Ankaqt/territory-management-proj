trigger TerritoryTrigger on Territory__c (before insert, before update, before delete, after update) {

    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            TerritoryNameCheck.checkUniqueName(Trigger.new);
        }
        if (Trigger.isUpdate) {
            TerritoryNameCheck.checkUniqueName(Trigger.new);
        }
    }

}