/**
 * Created by Макс on 05.10.2019.
 */

public with sharing class PerformOnTerrUserAsyncInsert implements Queueable {

    private List<TerrUser__c> terrUsers;

    public PerformOnTerrUserAsyncInsert(List<TerrUser__c> terrUsers){
        this.terrUsers = terrUsers;
    }

    public void execute(QueueableContext context){
        system.debug('PerformOnTerrUserAsyncInsert');

        List<Territory__Share> terrShares = PerformTerritorySharingsDML.insertTerritoryShares(terrUsers);

        System.enqueueJob(new PerformAccountAsyncInsert(terrShares));
    }
}