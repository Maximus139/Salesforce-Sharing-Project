/**
 * Created by Макс on 01.10.2019.
 */

public with sharing class CollectContactSharings {

    public static List<ContactShare> sharingsToInsert(Map<Id, Set<Id>> contactToUser){
        List<ContactShare> sharingsToInsert = new List<ContactShare>();

        for (Id contId :contactToUser.keySet()){
            for (Id userId :contactToUser.get(contId)){
                sharingsToInsert.add(new ContactShare(
                        ContactId = contId,
                        UserOrGroupId = userId,
                        ContactAccessLevel = 'Edit',
                        RowCause = 'Manual'
                ));
            }
        }

        return sharingsToInsert;
    }

    public static List<ContactShare> sharingsToDelete(Map<Id, Set<Id>> contactToUser){
        Set<Id> userIds = new Set<Id>();

        for (Id contId : contactToUser.keySet()){
            userIds.addAll(contactToUser.get(contId));
        }

        List<ContactShare> sharingsToDelete = new List<ContactShare>([
                SELECT Id
                FROM ContactShare
                WHERE UserOrGroupId IN :userIds
                AND ContactId IN :contactToUser.keySet()
                AND RowCause = 'Manual'
        ]);

        return sharingsToDelete;
    }
    
}