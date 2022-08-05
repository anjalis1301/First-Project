({  //handler to load data initially
	doInit : function(component, event, helper) { 
		 helper.getContact(component);
	},
    //method to call helper to update records
    updateRecord : function(component,event,helper) {
        $A.util.removeClass(component.find('Spinner'),'slds-hide');
        helper.updateRec(component);
    }
    
})