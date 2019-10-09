/**
 * Created by Макс on 05.10.2019.
 */

public with sharing class PerformOnTerritorySyncUpdate {

    private List<Territory__c> territoriesOld;
    private List<Territory__c> territoriesNew;
    private Set<Id> users;

    public PerformOnTerritorySyncUpdate(List<Territory__c> territoriesOld, List<Territory__c> territoriesNew){
        this.territoriesOld = territoriesOld;
        this.territoriesNew = territoriesNew;
        this.users = CollectionsUtilityClass.collectAllUsers(territoriesOld);
    }

    public void execute(){
        system.debug('PerformOnTerritoryAsyncUpdate');

        List<Territory__Share> terrShares = PerformTerritorySharingsDML.deleteTerritoryShares(territoriesOld);
        PerformAccountSyncDelete job = new PerformAccountSyncDelete(terrShares, users);
        job.execute();

        system.enqueueJob(new PerformOnTerritoryAsyncInsert(territoriesNew));
    }
}