/**
 * Created by Макс on 28.09.2019.
 */

public with sharing class PerformTerritorySharingsDML {

    public static List<Territory__Share> insertTerritoryShares(List<TerrUser__c> terrUsers){
        List<Territory__Share> territorySharings = new List<Territory__Share>();

        Map<Id, Set<Id>> territoryToUser = CollectionsUtilityClass.collectTerritoryToUsers(terrUsers);
        territorySharings.addAll(CollectTerritorySharings.sharingsToInsert(territoryToUser));

        insert territorySharings;
        return territorySharings;
    }

    public static List<Territory__Share> deleteTerritoryShares(List<TerrUser__c> terrUsers){
        List<Territory__Share> territorySharings = new List<Territory__Share>();

        Map<Id, Set<Id>> territoryToUser = CollectionsUtilityClass.collectTerritoryToUsers(terrUsers);
        territorySharings.addAll(CollectTerritorySharings.sharingsToDelete(territoryToUser));

        delete territorySharings;
        return territorySharings;
    }

    public static List<Territory__Share> insertTerritoryShares(List<Territory__c> territories){
        List<Territory__Share> territorySharings = new List<Territory__Share>();

        Map<Id, Set<Id>> territoryToUser = CollectionsUtilityClass.collectTerritoryToUsersToInsert(territories);
        territorySharings.addAll(CollectTerritorySharings.sharingsToInsert(territoryToUser));

        insert territorySharings;
        return territorySharings;
    }

    public static List<Territory__Share> deleteTerritorySharesWithTerrUsers(List<Territory__c> territories){
        List<Territory__Share> territorySharings = new List<Territory__Share>();

        List<TerrUser__c> terrUsers = CollectionsUtilityClass.collectTerrUsersToDelete(territories);
        Map<Id, Set<Id>> territoryToUser = CollectionsUtilityClass.collectTerritoryToUsers(territories);
        territorySharings.addAll(CollectTerritorySharings.sharingsToDelete(territoryToUser));

        delete terrUsers;
        delete territorySharings;
        return territorySharings;
    }

    public static List<Territory__Share> deleteTerritoryShares(List<Territory__c> territories){
        List<Territory__Share> territorySharings = new List<Territory__Share>();

        Map<Id, Set<Id>> territoryToUser = CollectionsUtilityClass.collectTerritoryToUsers(territories);
        territorySharings.addAll(CollectTerritorySharings.sharingsToDelete(territoryToUser));

        delete territorySharings;
        return territorySharings;
    }
}