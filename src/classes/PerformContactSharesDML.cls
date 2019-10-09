/**
 * Created by Макс on 28.09.2019.
 */

public with sharing class PerformContactSharesDML {

    public static void insertContactShares(List<AccountShare> accountSharings) {

        Map<Id, Set<Id>> contactToUsers = CollectionsUtilityClass.collectContactToUsers(accountSharings);

        if (contactToUsers != null) {
            List<ContactShare> contactSharing = CollectContactSharings.sharingsToInsert(contactToUsers);

            insert contactSharing;
        }
    }

    public static void deleteContactShares(List<AccountShare> accountSharings){

        Map<Id, Set<Id>> contactToUsers = CollectionsUtilityClass.collectContactToUsers(accountSharings);
        List<ContactShare> contactSharing = CollectContactSharings.sharingsToDelete(contactToUsers);

        delete contactSharing;
    }

    public static void insertContactShares(List<Reference__c> references){

        Map<Id, Set<Id>> contactToUsers = CollectionsUtilityClass.collectContactToUsers(references);

        if (contactToUsers != null) {
            List<ContactShare> contactSharing = CollectContactSharings.sharingsToInsert(contactToUsers);

            insert contactSharing;
        }
    }

    public static void deleteContactShares(List<Reference__c> references){

        Map<Id, Set<Id>> contactToUsers = CollectionsUtilityClass.collectContactToUsers(references);
        List<ContactShare> contactSharing = CollectContactSharings.sharingsToDelete(contactToUsers);

        delete contactSharing;
    }

}