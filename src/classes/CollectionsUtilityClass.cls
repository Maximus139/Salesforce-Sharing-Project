/**
 * Created by Макс on 05.10.2019.
 */

public with sharing class CollectionsUtilityClass {

    public static Set<Id> collectAllUsers(List<Set<Id>> users){
        Set<Id> userIds = new Set<Id>();

        for (Set<Id> userSet : users){
            userIds.addAll(userSet);
        }

        return userIds;
    }

    public static Set<Id> collectAllUsers(List<Territory__c> territories){

        return collectAllUsers(collectTerritoryToUsers(territories).values());
    }

    public static Set<Id> collectAllUsers(List<Account> accounts){

        return collectAllUsers(collectTerritoryToUsers(accounts).values());
    }

    public static Set<Id> collectAllUsers(List<Reference__c> references){

        return collectAllUsers(collectContactToUsers(references).values());
    }

    public static Set<Id> collectAllUsers(List<TerrUser__c> terrUsers){

        return collectAllUsers(collectTerritoryToUsers(terrUsers).values());
    }

    public static Map<Id, Set<Id>> collectTerritoryToUsers(List<Territory__c> territories){
        Map<Id, Set<Id>> territoryToUser = new Map<Id, Set<Id>>();

        List<Territory__Share> terrShares = new List<Territory__Share>([
                SELECT UserOrGroupId, ParentId
                FROM Territory__Share
                WHERE ParentId IN :territories
                AND RowCause = 'Manual'
        ]);

        for (Territory__Share terrShare : terrShares){
            if (territoryToUser.containsKey(terrShare.ParentId)){
                territoryToUser.get(terrShare.ParentId).add((terrShare.UserOrGroupId));
            }
            else {
                territoryToUser.put(terrShare.ParentId, new Set<Id>{terrShare.UserOrGroupId});
            }
        }

        return territoryToUser;
    }

    public static Map<Id, Set<Id>> collectTerritoryToUsers(List<TerrUser__c> territoryUsers){
        Map<Id, Set<Id>> territoryToUser = new Map<Id, Set<Id>>();

        for (TerrUser__c terrItem : territoryUsers) {
            if (terrItem.Territory__c != null && terrItem.User__c != null) {
                if (territoryToUser.containsKey(terrItem.Territory__c)){
                    territoryToUser.get(terrItem.Territory__c).add(terrItem.User__c);
                }
                else {
                    territoryToUser.put(terrItem.Territory__c, new Set<Id>{terrItem.User__c});
                }
            }
        }
        return territoryToUser;
    }

    public static Map<Id, Set<Id>> collectTerritoryToUsersToInsert(List<Territory__c> territories){
        Map<Id, Set<Id>> territoryToUser = new Map<Id, Set<Id>>();
        Map<Id, Id> parentTerritoryToTerritories = new Map<Id, Id>();

        for (Territory__c territory : territories){
            if (territory.Parent_Territory__c != null){
                parentTerritoryToTerritories.put(territory.Parent_Territory__c, territory.Id);
            }
        }

        List<Territory__Share> terrShares = new List<Territory__Share>([
                SELECT Id, ParentId, UserOrGroupId
                FROM Territory__Share
                WHERE ParentId IN :parentTerritoryToTerritories.keySet()
                AND RowCause = 'Manual'
        ]);

        for (Territory__Share terrShare : terrShares){
            if (parentTerritoryToTerritories.containsKey(terrShare.ParentId)){
                if (territoryToUser.containsKey(terrShare.ParentId)){
                    territoryToUser.get(parentTerritoryToTerritories.get(terrShare.ParentId)).add(terrShare.UserOrGroupId);
                }
                else {
                    territoryToUser.put(parentTerritoryToTerritories.get(terrShare.ParentId), new Set<Id>{terrShare.UserOrGroupId});
                }
            }
        }

        return territoryToUser;
    }

    public static List<TerrUser__c> collectTerrUsersToDelete(List<Territory__c> territories){

        List<TerrUser__c> terrUsers = new List<TerrUser__c>([
                SELECT Id, Territory__c, User__c
                FROM TerrUser__c
                WHERE Territory__c IN :territories
        ]);

        return terrUsers;
    }

    public static Map<Id, Set<Id>> collectContactToUsers(List<AccountShare> accountSharings){
        Map<Id, Set<Id>> contactToUsers = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> accountToUser = new Map<Id, Set<Id>>();

        for (AccountShare accItem :accountSharings){
            if (accountToUser.containsKey(accItem.AccountId)){
                accountToUser.get(accItem.AccountId).add(accItem.UserOrGroupId);
            }
            else {
                accountToUser.put(accItem.AccountId, new Set<Id>{accItem.UserOrGroupId});
            }
        }

        Map<Id, Reference__c> references = new Map<Id, Reference__c>([
                SELECT Id, Account__c, Contact__c
                FROM Reference__c
                WHERE Account__c IN :accountToUser.keySet()
        ]);

        for (Reference__c refItem :references.values()){
            if (contactToUsers.containsKey(refItem.Contact__c)){
                contactToUsers.get(refItem.Contact__c).addAll(accountToUser.get(refItem.Account__c));
            }
            else {
                contactToUsers.put(refItem.Contact__c, new Set<Id>(accountToUser.get(refItem.Account__c)));
            }
        }

        return contactToUsers;
    }

    public static Map<Id, Set<Id>> collectContactToUsers(List<Reference__c> references){
        Map<Id, Set<Id>> contactsToUsers = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> accountToUsers = new Map<Id, Set<Id>>();
        Set<Id> accIds = new Set<Id>();


        for (Reference__c reffItem : references){
            accIds.add(reffItem.Account__c);
        }
        List<AccountShare> accountShares = new List<AccountShare>([
                SELECT Id, AccountId, UserOrGroupId
                FROM AccountShare
                WHERE AccountId IN :accIds
                AND RowCause = 'Manual'
        ]);

        if (!accountShares.isEmpty()) {
            for (AccountShare accShare : accountShares) {
                if (accountToUsers.containsKey(accShare.AccountId)) {
                    accountToUsers.get(accShare.AccountId).add(accShare.UserOrGroupId);
                } else {
                    accountToUsers.put(accShare.AccountId, new Set<Id>{
                            accShare.UserOrGroupId
                    });
                }
            }

            for (Reference__c refItem : references) {
                if (contactsToUsers.containsKey(refItem.Contact__c)) {
                    contactsToUsers.get(refItem.Contact__c).addAll(accountToUsers.get(refItem.Account__c));
                }
                else {
                    contactsToUsers.put(refItem.Contact__c, new Set<Id>(accountToUsers.get(refItem.Account__c)));
                }
            }
        }

        return contactsToUsers;
    }

    public static Map<Id, Set<Id>> collectAccountToUsers(List<Territory__Share> territorySharings){
        Map<Id, Set<Id>> accountToUsers = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> territoryToUser = new Map<Id, Set<Id>>();

        for (Territory__Share terrItem :territorySharings){
            if (territoryToUser.containsKey(terrItem.ParentId)){
                territoryToUser.get(terrItem.ParentId).add(terrItem.UserOrGroupId);
            }
            else {
                territoryToUser.put(terrItem.ParentId, new Set<Id>{terrItem.UserOrGroupId});
            }
        }

        Map<Id, Account> accounts = new Map<Id, Account>([
                SELECT Id, Territory__c
                FROM Account
                WHERE Territory__c IN :territoryToUser.keySet()
        ]);

        for (Id accId : accounts.keySet()){
            if (accountToUsers.containsKey(accId)){
                accountToUsers.get(accId).addAll(territoryToUser.get(accounts.get(accId).Territory__c));
            }
            else {
                accountToUsers.put(accId, new Set<Id>(territoryToUser.get(accounts.get(accId).Territory__c)));
            }
        }

        return accountToUsers;
    }

    public static Map<Id, Set<Id>> collectAccountToUsers(List<Account> accounts){
        Map<Id, Set<Id>> accountToUsers = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> terrToUser = new Map<Id, Set<Id>>();
        Set<Id> accountTerritory = new Set<Id>();

        for (Account acc:accounts){
            accountTerritory.add(acc.Territory__c);
        }

        List<Territory__Share> terrShares = new List<Territory__Share>([
                SELECT ParentId, UserOrGroupId
                FROM Territory__Share
                WHERE ParentId IN :accountTerritory
                AND RowCause = 'Manual'
        ]);
        if (!terrShares.isEmpty()) {
            for (Territory__Share terrShare : terrShares) {
                if (terrToUser.containsKey(terrShare.ParentId)) {
                    terrToUser.get(terrShare.ParentId).add(terrShare.UserOrGroupId);
                } else {
                    terrToUser.put(terrShare.ParentId, new Set<Id>{
                            terrShare.UserOrGroupId
                    });
                }
            }

            for (Account acc : accounts) {
                if (acc.Territory__c != null) {
                    if (accountToUsers.containsKey(acc.Id)) {
                        accountToUsers.get(acc.Id).addAll(terrToUser.get(acc.Territory__c));
                    } else {
                        accountToUsers.put(acc.Id, new Set<Id>(terrToUser.get(acc.Territory__c)));
                    }
                }
            }
        }

        return accountToUsers;
    }

    public static List<Reference__c> collectReferencesOfAccounts(List<Account> accounts){

        List<Reference__c> accountReferences = new List<Reference__c>([
                SELECT Id, Account__c, Contact__c
                FROM Reference__c
                WHERE Account__c IN :accounts
        ]);

        return accountReferences;
    }

    public static List<AccountShare> collectAccountSharingsForUsers(List<Reference__c> references){

        Set<Id> accIds = new Set<Id>();

        for (Reference__c reffItem : references){
            accIds.add(reffItem.Account__c);
        }
        List<AccountShare> accountShares = new List<AccountShare>([
                SELECT Id, UserOrGroupId, AccountId
                FROM AccountShare
                WHERE AccountId IN :accIds
                AND RowCause = 'Manual'
        ]);

        return accountShares;
    }

    public static Map<Id, Set<Id>> collectTerritoryToUsers(List<Account> accounts){
        Set<Id> territories = new Set<Id>();
        Map<Id, Set<Id>> territoryToUsers = new Map<Id, Set<Id>>();

        for (Account acc: accounts){
            if (acc.Territory__c != null){
                territories.add(acc.Territory__c);
            }
        }

        List<Territory__Share> terrShares = new List<Territory__Share>([
           SELECT UserOrGroupId, ParentId
           FROM Territory__Share
           WHERE ParentId IN :territories
        ]);

        for (Territory__Share terrShare : terrShares){
            if (territoryToUsers.containsKey(terrShare.ParentId)){
                territoryToUsers.get(terrShare.ParentId).add(terrShare.UserOrGroupId);
            }
            else {
                territoryToUsers.put(terrShare.ParentId, new Set<Id>{terrShare.UserOrGroupId});
            }
        }

        return territoryToUsers;
    }
}