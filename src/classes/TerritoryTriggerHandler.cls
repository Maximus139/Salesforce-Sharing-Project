/**
 * Created by Макс on 04.10.2019.
 */

public with sharing class TerritoryTriggerHandler {

    public void onAfterInsert(Map<Id, Territory__c> newMap) {

        newMap = PerformTerritoryValidation.check(newMap);
        system.enqueueJob(new PerformOnTerritoryAsyncInsert(newMap.values()));
    }

    public void onBeforeUpdate(Map<Id, Territory__c> oldMap, Map<Id, Territory__c> newMap){

        newMap = PerformTerritoryValidation.check(newMap);
        newMap = PerformTerritoryValidation.checkRecursionHierarchy(newMap);
        PerformOnTerritorySyncUpdate job = new PerformOnTerritorySyncUpdate(oldMap.values(), newMap.values());
        job.execute();
    }

    public void onBeforeDelete(Map<Id, Territory__c> oldMap){

        PerformOnTerritoryAsyncDelete job = new PerformOnTerritoryAsyncDelete(oldMap.values());
        job.execute();
    }

}