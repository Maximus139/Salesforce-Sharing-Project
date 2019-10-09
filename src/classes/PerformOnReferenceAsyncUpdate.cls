/**
 * Created by Макс on 29.09.2019.
 */

public with sharing class PerformOnReferenceAsyncUpdate implements Queueable{

    private List<Reference__c> referencesOld;
    private List<Reference__c> referencesNew;

    public PerformOnReferenceAsyncUpdate(List<Reference__c> referencesOld, List<Reference__c> referencesNew){
        this.referencesOld = referencesOld;
        this.referencesNew = referencesNew;
    }

    public void execute(QueueableContext context){
        system.debug('PerformOnReferenceAsyncUpdate');

        system.enqueueJob(new PerformOnReferenceAsyncDelete(referencesOld, referencesNew));
    }
}