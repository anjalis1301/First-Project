({//handler to load data initially
	doInit : function(component, event, helper) { 
		 helper.getContact(component);
	},
    //method to call helper to update records
    updateRecord : function(component,event,helper) {
        $A.util.removeClass(component.find('Spinner'),'slds-hide');
		component.set("v.conRec.AccountId",component.get('v.accRec.Id'));
        helper.updateRec(component);
    },

	//method to get the changed values of test results field from lwc component
	getTestResults :function(component,event,helper){	
		component.set("v.conRec.Test_Results__c",event.getParam('value'));
	},

	 //method to get the changed values of recent visits field from lwc component
	getRecentVisits :function(component,event,helper){
		component.set("v.conRec.Recent_Visits__c",event.getParam('value'));
	},
	
})