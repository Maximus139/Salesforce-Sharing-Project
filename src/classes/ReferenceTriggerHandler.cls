/**
 * Created by Макс on 01.10.2019.
 */

public with sharing class ReferenceTriggerHandler {

    public void onBeforeInsert(List<Reference__c> newList) {
        system.enqueueJob(new PerformOnReferenceAsyncInsert(newList));
    }

    public void onBeforeUpdate(Map<Id, Reference__c> oldMap, Map<Id, Reference__c> newMap){
        system.enqueueJob(new PerformOnReferenceAsyncUpdate(oldMap.values(), newMap.values()));
    }

    public void onBeforeDelete(Map<Id, Reference__c> oldMap){
        system.enqueueJob(new PerformOnReferenceAsyncDelete(oldMap.values()));
    }

}