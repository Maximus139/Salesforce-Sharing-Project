/**
 * Created by Макс on 03.10.2019.
 */

public with sharing class PerformOnAccountAsyncUpdate implements Queueable {

    private List<Account> accountsOld;
    private List<Account> accountsNew;
    private Set<Id> users;

    public PerformOnAccountAsyncUpdate(List<Account> accountsOld, List<Account> accountsNew){
        this.accountsOld = accountsOld;
        this.accountsNew = accountsNew;
        this.users = CollectionsUtilityClass.collectAllUsers(accountsOld);
    }

    public void execute(QueueableContext context){
        system.debug('PerformOnAccountAsyncUpdate');

        List<AccountShare> accountSharesToDelete = PerformAccountSharingsDML.deleteAccountShares(accountsOld);

        if (accountSharesToDelete != null) {
            system.enqueueJob(new PerformContactAsyncDelete(accountSharesToDelete, users));
        }

        List<AccountShare> accountShares = PerformAccountSharingsDML.insertAccountShares(accountsNew);
        PerformContactSharesDML.insertContactShares(accountShares);
    }
}