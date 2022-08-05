trigger AccountTrigger on Account (after insert) {
    for(Account acc: Trigger.new){
        if(acc.Name == 'Anjali2356'){
            acc.addError('This person is too complicated');
        }
    }
}