trigger PosSeqChk on Position__c (after insert) {
    if(Trigger.isAfter){
        if(Trigger.isInsert){
           /* List<Position__c> pos =[SELECT Id,Name,Max_Pay__c FROm Position__c WHERE Id IN :Trigger.new];
            for(integer i=0;i<Trigger.new.size();i++){
                pos[i].Max_Pay__c = i;
            }
            update pos;*/
            for(integer i=0;i<Trigger.new.size();i++){
                System.debug('trigger.new'+Trigger.new[i].Name+'@@@'+Trigger.new[i].Max_Pay__c);
            }    
        }
    }
}