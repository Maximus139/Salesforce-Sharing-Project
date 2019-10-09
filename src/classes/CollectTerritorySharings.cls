/**
 * Created by Макс on 01.10.2019.
 */

public with sharing class CollectTerritorySharings {

    private static final Integer DEEP_LEVEL = 10;
    private static Integer CURRENT_DELETE_LEVEL = 0;
    private static Integer CURRENT_INSERT_LEVEL = 0;

    public static List<Territory__Share> sharingsToInsert(Map<Id, Set<Id>> territoryToUsers) {
        List<Territory__Share> sharingToInsert = new List<Territory__Share>();

        if (CURRENT_INSERT_LEVEL < DEEP_LEVEL && !territoryToUsers.isEmpty()) {
            CURRENT_INSERT_LEVEL++;

            Map<Id, Set<Id>> childTerritoryToUsers = new Map<Id, Set<Id>>();
            Map<Id, Territory__c> territoryHierarchy = new Map<Id, Territory__c>([
                    SELECT Id, Parent_Territory__c, (SELECT Id FROM Territories__r),
                    (SELECT UserOrGroupId, ParentId
                    FROM Shares
                    WHERE RowCause = 'Manual'
                    )
                    FROM Territory__c
                    WHERE Id IN :territoryToUsers.keySet()
            ]);

            for (Id terrItem : territoryToUsers.keySet()) {
                for (Id userId : territoryToUsers.get(terrItem)) {
                    sharingToInsert.add(new Territory__Share(
                            ParentId = terrItem,
                            UserOrGroupId = userId,
                            AccessLevel = 'Read',
                            RowCause = 'Manual'
                    ));
                }
                if (territoryHierarchy.get(terrItem) != null) {
                    if (territoryHierarchy.get(terrItem).Territories__r.size() != 0) {
                        for (Territory__c childTerritoryItem : territoryHierarchy.get(terrItem).Territories__r) {
                            childTerritoryToUsers.put(childTerritoryItem.Id, territoryToUsers.get(terrItem));
                        }
                    }
                }
            }
            sharingToInsert.addAll(sharingsToInsert(childTerritoryToUsers));
        }

        return sharingToInsert;
    }

    public static List<Territory__Share> sharingsToDelete(Map<Id, Set<Id>> territoryToUsers) {
        List<Territory__Share> sharingToDelete = new List<Territory__Share>();

        if (CURRENT_DELETE_LEVEL < DEEP_LEVEL && !territoryToUsers.isEmpty()) {
            CURRENT_DELETE_LEVEL++;
            Map<Id, Set<Id>> childTerritoryToUsers = new Map<Id, Set<Id>>();
            Map<Id, Territory__c> territoryHierarchy = new Map<Id, Territory__c>([
                    SELECT Id, Parent_Territory__c, Name, OwnerId, (
                            SELECT Id
                            FROM Territories__r
                    )
                    FROM Territory__c
                    WHERE Id IN :territoryToUsers.keySet()
            ]);
            Map<Id, Territory__Share> terrSharings = new Map<Id, Territory__Share>([
                    SELECT Id, ParentId, UserOrGroupId
                    FROM Territory__Share
                    WHERE ParentId IN :territoryToUsers.keySet()
                    AND RowCause = 'Manual'
            ]);

            for (Id terrId : territoryToUsers.keySet()) {
                for (Territory__Share terrShare : terrSharings.values()) {
                    if (territoryToUsers.get(terrId).contains(terrShare.UserOrGroupId)) {
                        if (!sharingToDelete.contains(terrShare)) {
                            sharingToDelete.add(terrShare);
                        }
                        terrSharings.remove(terrShare.Id);
                    }
                }
                if (territoryHierarchy.get(terrId).Territories__r.size() != 0) {
                    for (Territory__c childTerritoryItem : territoryHierarchy.get(terrId).Territories__r) {
                        childTerritoryToUsers.put(childTerritoryItem.Id, territoryToUsers.get(terrId));
                    }
                }
            }

            sharingToDelete.addAll(sharingsToDelete(childTerritoryToUsers));
        }
        return sharingToDelete;
    }

}