/*************************************************************************************@@
ClassName	: ClientSidePagination
Author		: Anjali Sharma
CreateDate	: 06/03/2021
Purpose		: To query the accounts data and return it to the component
*************************************************************************************/

public with sharing class ClientSideController {
    @AuraEnabled public static List<Account> getData() {
        List<Account> acc = [SELECT Name,Type FROM Account ORDER BY Id LIMIT 50000];
        return acc;
    }
}