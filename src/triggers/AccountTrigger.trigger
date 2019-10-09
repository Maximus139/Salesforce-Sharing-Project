/**
 * Created by Макс on 02.10.2019.
 */

trigger AccountTrigger on Account (before insert, before update, before delete, after insert) {
    AccountTriggerHandler handler = new AccountTriggerHandler();

    if(Trigger.isBefore){

        if(Trigger.isUpdate){
            handler.onBeforeUpdate(Trigger.oldMap, Trigger.newMap);
        }

        if(Trigger.isDelete){
            handler.onBeforeDelete(Trigger.oldMap);
        }
    }
    else{

        if(Trigger.isInsert){
            handler.onAfterInsert(Trigger.new);
        }
    }
}