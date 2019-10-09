/**
 * Created by Макс on 01.10.2019.
 */

public with sharing class PerformOnTerrUserAsyncUpdate implements Queueable {

    private List<TerrUser__c> terrUsersOld;
    private List<TerrUser__c> terrUsersNew;

    public PerformOnTerrUserAsyncUpdate(List<TerrUser__c> terrUsersOld, List<TerrUser__c> terrUsersNew){
        this.terrUsersOld = terrUsersOld;
        this.terrUsersNew = terrUsersNew;
    }

    public void execute(QueueableContext context){
        system.debug('PerformOnTerrUserAsyncUpdate');

        system.enqueueJob(new PerformOnTerrUserAsyncDelete(terrUsersOld, terrUsersNew));
    }
}