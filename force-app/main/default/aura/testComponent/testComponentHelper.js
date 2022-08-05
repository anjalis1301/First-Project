({
	saveData : function(validCon,component) {
		var action = component.get("c.saveContact");
        alert(validCon);
        action.setParams({
            'con' : validCon
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.insertedCon",response.getReturnValue());
            } else {
                alert('An Error occur'+JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
	}
})