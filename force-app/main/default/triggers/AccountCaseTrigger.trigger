trigger AccountCaseTrigger on Account (before insert,after update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            AccountCaseHandler.noDuplicate(Trigger.New);
        }
    }
    if(Trigger.isAfter){
       if(Trigger.isUpdate){
                AccountCaseHandler.changeCases(Trigger.newMap,Trigger.oldMap);
            }
    }
}