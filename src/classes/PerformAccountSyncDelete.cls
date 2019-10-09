/**
 * Created by Макс on 05.10.2019.
 */

public with sharing class PerformAccountSyncDelete {

    private List<Territory__Share> terrSharings;
    private Set<Id> users;

    public PerformAccountSyncDelete(List<Territory__Share> terrSharings, Set<Id> users){
        this.terrSharings = terrSharings;
        this.users = users;
    }

    public void execute(){
        system.debug('PerformAccountSyncDelete');

        List<AccountShare> accountShares = PerformAccountSharingsDML.deleteAccountShares(terrSharings);

        system.enqueueJob(new PerformContactAsyncDelete(accountShares, users));
    }
}