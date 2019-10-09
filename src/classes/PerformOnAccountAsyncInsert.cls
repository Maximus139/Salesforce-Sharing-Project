/**
 * Created by Макс on 02.10.2019.
 */

public with sharing class PerformOnAccountAsyncInsert implements Queueable {

    private List<Account> accounts;

    public PerformOnAccountAsyncInsert(List<Account> accounts){
        this.accounts = accounts;
    }

    public void execute(QueueableContext context){
        system.debug('PerformOnAccountAsyncInsert');

        PerformAccountSharingsDML.insertAccountShares(accounts);
    }
}