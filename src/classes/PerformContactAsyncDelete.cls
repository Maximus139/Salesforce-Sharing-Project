/**
 * Created by Макс on 29.09.2019.
 */

public with sharing class PerformContactAsyncDelete implements Queueable {

    private List<AccountShare> accSharings;
    private Set<Id> users;

    public PerformContactAsyncDelete(List<AccountShare> accSharings, Set<Id> users){
        this.accSharings = accSharings;
        this.users = users;
    }

    public void execute(QueueableContext context){
        system.debug('PerformContactAsyncDelete');

        PerformContactSharesDML.deleteContactShares(accSharings);

        if (users != null && !users.isEmpty()) {
            system.enqueueJob(new RecalculateSharingsChainAsync(users));
        }
    }
}