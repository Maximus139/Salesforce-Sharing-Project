/**
 * Created by Макс on 29.09.2019.
 */

public with sharing class PerformAccountAsyncDelete implements Queueable {

    private List<Territory__Share> terrSharings;
    private Set<Id> users;

    public PerformAccountAsyncDelete(List<Territory__Share> terrSharings, Set<Id> users){
        this.terrSharings = terrSharings;
        this.users = users;
    }

    public void execute(QueueableContext context){
        system.debug('PerformAccountAsyncDelete');

        List<AccountShare> accountShares = PerformAccountSharingsDML.deleteAccountShares(terrSharings);

        system.enqueueJob(new PerformContactAsyncDelete(accountShares, users));
    }
}