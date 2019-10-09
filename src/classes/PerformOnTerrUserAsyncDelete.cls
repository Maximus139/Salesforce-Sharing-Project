/**
 * Created by Макс on 05.10.2019.
 */

public with sharing class PerformOnTerrUserAsyncDelete implements Queueable {

    private List<TerrUser__c> terrUsersOld;
    private List<TerrUser__c> terrUsersNew;
    private Set<Id> users;

    public PerformOnTerrUserAsyncDelete(List<TerrUser__c> terrUsers){
        this.terrUsersOld = terrUsers;
        this.users = CollectionsUtilityClass.collectAllUsers(terrUsers);
    }

    public PerformOnTerrUserAsyncDelete(List<TerrUser__c> terrUsersOld, List<TerrUser__c> terrUsersNew){
        this.terrUsersOld = terrUsersOld;
        this.terrUsersNew = terrUsersNew;
        this.users = CollectionsUtilityClass.collectAllUsers(terrUsersOld);
        this.users.addAll(CollectionsUtilityClass.collectAllUsers(terrUsersNew));
    }


    public void execute(QueueableContext context){
        system.debug('PerformOnTerrUserAsyncDelete');

        List<Territory__Share> terrShares = PerformTerritorySharingsDML.deleteTerritoryShares(terrUsersOld);

        System.enqueueJob(new PerformAccountAsyncDelete(terrShares, users));
    }
}