/**
 * Created by Макс on 29.09.2019.
 */

public with sharing class PerformOnReferenceAsyncDelete implements Queueable {

    private List<Reference__c> referencesOld;
    private List<Reference__c> referencesNew;
    private Set<Id> users;

    public PerformOnReferenceAsyncDelete(List<Reference__c> references){
        this.referencesOld = references;
        this.users = CollectionsUtilityClass.collectAllUsers(references);
    }

    public PerformOnReferenceAsyncDelete(List<Reference__c> referencesOld, List<Reference__c> referencesNew){
        this.referencesOld = referencesOld;
        this.referencesNew = referencesNew;
        this.users = CollectionsUtilityClass.collectAllUsers(referencesOld);
        this.users.addAll(CollectionsUtilityClass.collectAllUsers(referencesNew));
    }

    public void execute(QueueableContext context){
        system.debug('PerformOnReferenceAsyncDelete');

        PerformContactSharesDML.DeleteContactShares(referencesOld);

        system.enqueueJob(new RecalculateSharingsChainAsync(users));
    }
}