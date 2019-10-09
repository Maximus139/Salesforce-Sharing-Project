/**
 * Created by Макс on 01.10.2019.
 */

trigger ReferenceTrigger on Reference__c (before insert, before update, before delete) {
    ReferenceTriggerHandler handler = new ReferenceTriggerHandler();

    if(Trigger.isBefore){

        if(Trigger.isInsert){
            handler.onBeforeInsert(Trigger.new);
        }

        if(Trigger.isUpdate){
            handler.onBeforeUpdate(Trigger.oldMap, Trigger.newMap);
        }

        if(Trigger.isDelete){
            handler.onBeforeDelete(Trigger.oldMap);
        }
    }
}