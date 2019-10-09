/**
 * Created by Макс on 01.10.2019.
 */

public with sharing class RecalculateSharingsChain {

    public static void recalculateWholeChain(Set<Id> users){
        system.debug('recalculateSharingChain');

        List<Territory__Share> terrShares = recalculateTerritories(users);
        List<AccountShare> accountShares = recalculateAccounts(terrShares);
        recalculateContacts(accountShares);
    }

    public static List<Territory__Share> recalculateTerritories(Set<Id> users){
        system.debug('recalculateTerritories');

        List<TerrUser__c> terrToUser = new List<TerrUser__c>([
                SELECT Id, Territory__c, User__c
                FROM TerrUser__c
                WHERE User__c IN :users
        ]);

        List<Territory__Share> terrShares = PerformTerritorySharingsDML.insertTerritoryShares(terrToUser);

        return terrShares;
    }

    public static List<AccountShare> recalculateAccounts(List<Territory__Share> territorySharings){
        system.debug('recalculateAccounts');

        List<AccountShare> accountShares = PerformAccountSharingsDML.insertAccountShares(territorySharings);

        return accountShares;
    }

    public static void recalculateContacts(List<AccountShare> accountSharings){
        system.debug('recalculateContacts');

        PerformContactSharesDML.insertContactShares(accountSharings);
    }

}