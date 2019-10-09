/**
 * Created by Макс on 29.09.2019.
 */

public with sharing class PerformAccountAsyncInsert implements Queueable  {

    private List<Territory__Share> terrSharings;
    private List<Account> accounts;

    public PerformAccountAsyncInsert(List<Territory__Share> terrSharings){
        this.terrSharings = terrSharings;
    }

    public PerformAccountAsyncInsert(List<Account> accounts){
        this.accounts = accounts;
    }

    public void execute(QueueableContext context){
        system.debug('PerformAccountAsyncInsert');

        List<AccountShare> accountShares;

        if (terrSharings != null && !terrSharings.isEmpty()) {
            accountShares = PerformAccountSharingsDML.insertAccountShares(terrSharings);
        }
        else if (accounts != null && !accounts.isEmpty()){
            accountShares = PerformAccountSharingsDML.insertAccountShares(accounts);
        }

        system.enqueueJob(new PerformContactAsyncInsert(accountShares));
    }
}