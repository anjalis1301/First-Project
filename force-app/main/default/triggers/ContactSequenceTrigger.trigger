trigger ContactSequenceTrigger on Contact (after insert,after delete,after undelete,after update, before Update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUndelete) {
            ContactSequenceHandler2.afterInsertOrUndeleteRec(Trigger.new);
        }
        if(Trigger.isDelete) { 
            ContactSequenceHandler2.afterDeleteRecords(Trigger.old);
        }
        if(Trigger.isUpdate) {
            ContactSequenceHandler2.afterUpdateRecords(Trigger.oldMap,Trigger.newMap);
        }
    }
    if(Trigger.isBefore) {
        if(Trigger.isUpdate) {
            ContactSequenceHandler2.beforeUpdateRecords(Trigger.oldMap, Trigger.newMap);
        }
    }
}