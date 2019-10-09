/**
 * Created by Макс on 02.10.2019.
 */

public with sharing class PerformOnAccountSyncDelete {

    private Set<Id> users;
    private List<Account> accounts;

    public PerformOnAccountSyncDelete(List<Account> accounts){
        this.accounts = accounts;
        this.users = CollectionsUtilityClass.collectAllUsers(accounts);
    }

    public void execute(){
        system.debug('PerformOnAccountSyncDelete');

        PerformAccountSharingsDML.deleteAccountSharesWithReferences(accounts);

        system.enqueueJob(new RecalculateSharingsChainAsync(users));
    }
}