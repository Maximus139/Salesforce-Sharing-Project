/**
 * Created by Макс on 04.10.2019.
 */

public with sharing class PerformOnTerritoryAsyncInsert implements Queueable {

    private List<Territory__c> territories;

    public PerformOnTerritoryAsyncInsert(List<Territory__c> territories){
        this.territories = territories;
    }

    public void execute(QueueableContext context){
        system.debug('PerformOnTerritoryAsyncInsert');

        List<Territory__Share> territorySharings = PerformTerritorySharingsDML.insertTerritoryShares(territories);
        System.enqueueJob(new PerformAccountAsyncInsert(territorySharings));
    }

}