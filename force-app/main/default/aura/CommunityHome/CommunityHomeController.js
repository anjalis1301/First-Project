({	//get the user info from apex controller
    doInit : function(cmp, event, helper) {
        var action = cmp.get("c.getUserData");
        action.setCallback(this,function(response) {
            if(response.getState() === 'SUCCESS') {
                cmp.set('v.userData',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})