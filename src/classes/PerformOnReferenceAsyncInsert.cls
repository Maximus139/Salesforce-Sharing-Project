/**
 * Created by Макс on 29.09.2019.
 */

public with sharing class PerformOnReferenceAsyncInsert implements Queueable {

    private List<Reference__c> references;

    public PerformOnReferenceAsyncInsert(List<Reference__c> references){
        this.references = references;
    }

    public void execute(QueueableContext context){
        system.debug('PerformOnReferenceAsyncInsert');

        PerformContactSharesDML.insertContactShares(references);
    }
}