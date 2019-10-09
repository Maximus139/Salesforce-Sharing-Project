/**
 * Created by Макс on 01.10.2019.
 */

public with sharing class CollectAccountSharings {

    public static List<AccountShare> sharingsToInsert(Map<Id, Set<Id>> accountToUser){
        List<AccountShare> sharingsToInsert = new List<AccountShare>();

        for (Id accId :accountToUser.keySet()){
            for (Id userId :accountToUser.get(accId)){
                sharingsToInsert.add(new AccountShare(
                        AccountId = accId,
                        UserOrGroupId = userId,
                        AccountAccessLevel = 'Edit',
                        CaseAccessLevel = 'Edit',
                        ContactAccessLevel = 'Edit',
                        OpportunityAccessLevel = 'Edit',
                        RowCause = 'Manual'
                ));
            }
        }

        return sharingsToInsert;
    }

    public static List<AccountShare> sharingsToDelete(Map<Id, Set<Id>> accountToUser){
        Set<Id> userIds = new Set<Id>();

        for (Id accId : accountToUser.keySet()){
            userIds.addAll(accountToUser.get(accId));
        }

        List<AccountShare> sharingsToDelete = new List<AccountShare>([
                SELECT Id, AccountId, UserOrGroupId
                FROM AccountShare
                WHERE UserOrGroupId IN :userIds
                AND AccountId IN :accountToUser.keySet()
                AND RowCause = 'Manual'
        ]);

        return sharingsToDelete;
    }

}