({ //method to get records
    getRecords : function(cmp,inputTerm) {
        var inputs = cmp.get("v.userInputs");
        
        var action = cmp.get("c.fetchRecords");
        console.log(inputs.fieldName);
        action.setParams({
            "searchTerm": inputTerm,
            "objectName" : inputs.object,
            "fieldName" :inputs.fieldName
        });
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS') {               
                var recordsData =[];
                recordsData = response.getReturnValue();
                if(response.getReturnValue().length < 1){
                    cmp.set('v.error',true);
                } else {
                    cmp.set('v.error',false);
                }
                cmp.set('v.resultantRecords',recordsData);
                console.log(cmp.get('v.resultantRecords'));
            }
            $A.util.addClass(cmp.find('Spinner'), "slds-hide");
        });
         $A.enqueueAction(action);
    }
})