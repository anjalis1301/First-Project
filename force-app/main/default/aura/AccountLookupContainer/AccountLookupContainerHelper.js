({	//method to get data at initial load
	getContact : function(component) {
		var recId = component.get("v.recordId");
		var action=component.get("c.getRecord");
		action.setParams({
			"accId" : recId 
		});
		action.setCallback(this,function(response){
			if(response.getState() === 'SUCCESS') {				
				component.set("v.accRec",response.getReturnValue());
				if(component.get('v.accRec').Contacts === undefined) {
					component.set('v.displayCon',false);
				} else {
					component.set('v.displayCon',true);
					component.set('v.conRec',component.get('v.accRec').Contacts[0]);
				}              	
			}
		});
		$A.enqueueAction(action);
	},

	//method to update the contacts information
    updateRec : function(component) {
        var changeAccId = component.get('v.accRec.Id');
		var con = component.get('v.conRec');
		var action = component.get("c.updateCon");
		action.setParams({
			"conObj": con,
			"accId" : changeAccId
		});
		action.setCallback(this,function(response){
			if(response.getState() === 'SUCCESS') {
				this.getContact(component);
				$A.get("e.force:refreshView").fire();
				$A.util.addClass(component.find('Spinner'),'slds-hide');	
			}
		});
		$A.enqueueAction(action);
    }
})