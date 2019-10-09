/**
 * Created by Макс on 29.09.2019.
 */

public with sharing class PerformContactAsyncInsert implements Queueable {

    private List<AccountShare> accSharings;

    public PerformContactAsyncInsert(List<AccountShare> accSharings){
        this.accSharings = accSharings;
    }

    public void execute(QueueableContext context){
        system.debug('PerformContactAsyncInsert');
        if (accSharings != null) {
            PerformContactSharesDML.insertContactShares(accSharings);
        }
    }
}