/**
 * Created by Макс on 01.10.2019.
 */

public with sharing class RecalculateSharingsChainAsync implements Queueable {

    private Set<Id> users;

    public RecalculateSharingsChainAsync(Set<Id> users){
        this.users = users;
    }

    public void execute(QueueableContext context){

        RecalculateSharingsChain.recalculateWholeChain(users);
    }
}