/**
 * Created by Макс on 01.10.2019.
 */

public with sharing class TerrUserTriggerHandler {

    public void onBeforeInsert(List<TerrUser__c> newList) {
        system.enqueueJob(new PerformOnTerrUserAsyncInsert(newList));
    }

    public void onBeforeUpdate(Map<Id, TerrUser__c> oldMap, Map<Id, TerrUser__c> newMap){
        system.enqueueJob(new PerformOnTerrUserAsyncUpdate(oldMap.values(), newMap.values()));
    }

    public void onBeforeDelete(Map<Id, TerrUser__c> oldMap){
        system.enqueueJob(new PerformOnTerrUserAsyncDelete(oldMap.values()));
    }

}