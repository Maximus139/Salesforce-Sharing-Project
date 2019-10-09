/**
 * Created by Макс on 04.10.2019.
 */

trigger TerritoryTrigger on Territory__c (before insert, before update, before delete, after insert) {
    TerritoryTriggerHandler handler = new TerritoryTriggerHandler();

    if(Trigger.isBefore){

        if(Trigger.isUpdate){
            handler.onBeforeUpdate(Trigger.oldMap, Trigger.newMap);
        }

        if(Trigger.isDelete){
            handler.onBeforeDelete(Trigger.oldMap);
        }
    }
    else {
        if(Trigger.isInsert){
            handler.onAfterInsert(Trigger.newMap);
        }
    }
}