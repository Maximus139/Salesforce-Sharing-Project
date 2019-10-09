/**
 * Created by Макс on 02.10.2019.
 */

public with sharing class AccountTriggerHandler {

    public void onAfterInsert(List<Account> newList) {
        system.enqueueJob(new PerformOnAccountAsyncInsert(newList));
    }

    public void onBeforeUpdate(Map<Id, Account> oldMap, Map<Id, Account> newMap){
        system.enqueueJob(new PerformOnAccountAsyncUpdate(oldMap.values(), newMap.values()));
    }

    public void onBeforeDelete(Map<Id, Account> oldMap){

        PerformOnAccountSyncDelete job = new PerformOnAccountSyncDelete(oldMap.values());
        job.execute();
    }
}