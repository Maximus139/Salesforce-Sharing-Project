/**
 * Created by Макс on 07.10.2019.
 */

public with sharing class PerformTerritoryValidation {

    public static Map<Id, Territory__c> check(Map<Id, Territory__c> newMap){
        Map<Id, Id> ParentTerritoryWithTerritory = new Map<Id, Id>();
        Map<String, id> territoryNamesWithoutParent = new Map<String, id>();

        for (Territory__c territory : newMap.values()){
            if (territory.Parent_Territory__c != null){
                ParentTerritoryWithTerritory.put(territory.Parent_Territory__c, territory.Id);
            }
            else {
                territoryNamesWithoutParent.put(territory.Name, territory.Id);
            }
        }

        if (!ParentTerritoryWithTerritory.keySet().isEmpty()){
            List<Territory__c> territoriesOfTheSameLevel = new List<Territory__c>([
                    SELECT Id, Name, Parent_Territory__c, IsDeleted
                    FROM Territory__c
                    WHERE Parent_Territory__c IN :ParentTerritoryWithTerritory.keySet()
                    AND IsDeleted = false
                    AND Id NOT IN :newMap.keySet()
            ]);

            for (Territory__c territory : territoriesOfTheSameLevel){
                if (newMap.containsKey(ParentTerritoryWithTerritory.get(territory.Parent_Territory__c))) {
                    Territory__c terr = newMap.get(ParentTerritoryWithTerritory.get(territory.Parent_Territory__c));
                    if (terr.Name == territory.Name) {
                        newMap.get(terr.Id).Name.addError('This Name is already taken by another Territory in this hierarchy');
                    }
                }
            }
        }

        if (!territoryNamesWithoutParent.keySet().isEmpty()){
            List<Territory__c> territoryWithTheSameName = new List<Territory__c>([
                    SELECT Id, Name
                    FROM Territory__c
                    WHERE Name IN :territoryNamesWithoutParent.keySet()
            ]);

            for (Territory__c territory : territoryWithTheSameName){
                newMap.get(territoryNamesWithoutParent.get(territory.Name)).Name.addError('This Name is already taken by another Territory in Organization');
            }
        }

        return newMap;
    }

    public static Map<id, Territory__c> checkRecursionHierarchy(Map<Id, Territory__c> newMap){
        Set<id> parentTerrritories = new Set<id>();

        for (Territory__c territory : newMap.values()){
            parentTerrritories.add(territory.Parent_Territory__c);
        }

        Map<Id, Territory__c> parentTerritoryHierarchy = new Map<Id, Territory__c>([
           SELECT id,
                   Parent_Territory__c,
                   Parent_Territory__r.Parent_Territory__c,
                   Parent_Territory__r.Parent_Territory__r.Parent_Territory__c,
                   Parent_Territory__r.Parent_Territory__r.Parent_Territory__r.Parent_Territory__c
           FROM Territory__c
           WHERE id IN :parentTerrritories
        ]);

        for (Territory__c territory : newMap.values()){
            if (parentTerritoryHierarchy.containsKey(territory.Parent_Territory__c)){
                if (
                        territory.Id == parentTerritoryHierarchy.get(territory.Parent_Territory__c).id ||
                        territory.Id == parentTerritoryHierarchy.get(territory.Parent_Territory__c).Parent_Territory__c ||
                        territory.Id == parentTerritoryHierarchy.get(territory.Parent_Territory__c).Parent_Territory__r.Parent_Territory__c ||
                        territory.Id == parentTerritoryHierarchy.get(territory.Parent_Territory__c).Parent_Territory__r.Parent_Territory__r.Parent_Territory__c ||
                        territory.Id == parentTerritoryHierarchy.get(territory.Parent_Territory__c).Parent_Territory__r.Parent_Territory__r.Parent_Territory__r.Parent_Territory__c
                    ) {
                        territory.Parent_Territory__c.addError('Unfortunately, it will create hierarchy recursion');
                      }
            }
        }

        return newMap;
    }

}