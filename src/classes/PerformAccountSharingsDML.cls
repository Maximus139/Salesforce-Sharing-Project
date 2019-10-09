/**
 * Created by Макс on 28.09.2019.
 */

public with sharing class PerformAccountSharingsDML {

    public static List<AccountShare> insertAccountShares(List<Territory__Share> territorySharings){

        Map<Id, Set<Id>> accountToUsers = CollectionsUtilityClass.collectAccountToUsers(territorySharings);
        List<AccountShare> accountSharing = CollectAccountSharings.sharingsToInsert(accountToUsers);

        insert accountSharing;
        return accountSharing;
    }

    public static List<AccountShare> deleteAccountShares(List<Territory__Share> territorySharings){

        Map<Id, Set<Id>> accountToUsers = CollectionsUtilityClass.collectAccountToUsers(territorySharings);
        List<AccountShare> accountSharing = CollectAccountSharings.sharingsToDelete(accountToUsers);

        delete accountSharing;
        return accountSharing;
    }

    public static List<AccountShare> insertAccountShares(List<Account> accounts){

        Map<Id, Set<Id>> accountToUsers = CollectionsUtilityClass.collectAccountToUsers(accounts);
        List<AccountShare> accountSharing = CollectAccountSharings.sharingsToInsert(accountToUsers);

        insert accountSharing;
        return accountSharing;
    }

    public static List<AccountShare> deleteAccountShares(List<Account> accounts){

        Map<Id, Set<Id>> accountToUsers = CollectionsUtilityClass.collectAccountToUsers(accounts);
        List<AccountShare> accountSharing = CollectAccountSharings.sharingsToDelete(accountToUsers);

        if (accountSharing != null) {
            delete accountSharing;
        }

        return accountSharing;
    }

    public static void deleteAccountSharesWithReferences(List<Account> accounts){

        List<Reference__c> accountReferences = CollectionsUtilityClass.collectReferencesOfAccounts(accounts);
        PerformContactSharesDML.DeleteContactShares(accountReferences);

        delete accountReferences;
    }

}