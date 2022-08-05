({
	fireEvent : function(component, event, helper) {
        let message = $A.get("e.c:sampleEvent");
        message.setParams({
            'mess':'hello'
        })
        alert(message.getParam('mess'));
        message.fire();
	}
})