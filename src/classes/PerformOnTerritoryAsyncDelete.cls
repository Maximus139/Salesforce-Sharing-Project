/**
 * Created by Макс on 04.10.2019.
 */

public with sharing class PerformOnTerritoryAsyncDelete {

    private List<Territory__c> territories;
    private Set<Id> users;

    public PerformOnTerritoryAsyncDelete(List<Territory__c> territories){
        this.territories = territories;
        this.users = CollectionsUtilityClass.collectAllUsers(territories);
    }

    public void execute(){
        system.debug('PerformOnTerritoryAsyncDelete');

        List<Territory__Share> terrShares = PerformTerritorySharingsDML.deleteTerritorySharesWithTerrUsers(territories);

        PerformAccountSyncDelete job = new PerformAccountSyncDelete(terrShares, users);
        job.execute();
    }

}