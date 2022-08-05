({	//initiate
    doInit : function(cmp, event, helper) {
        cmp.find("inputLookup").set("v.autocomplete","off");
        $A.util.addClass(cmp.find('listbox-id-1'),'slds-hide');
        var x = cmp.get('v.userInputs');
        var obj = JSON.parse(x);
        cmp.set('v.userInputs',obj[0]);
        $A.util.addClass(cmp.find('resultsDiv'),'slds-is-close');
        if(cmp.get('v.selectedRecordId') == '') {
            $A.util.addClass(cmp.find('lookup-pill'),'slds-hide');
        } else {
            $A.util.addClass(cmp.find('lookup-pill'),'slds-show');
            $A.util.addClass(cmp.find('lookupField'),'slds-hide');
        }
       
    },
	//searching records
    searchRecords : function(cmp,event,helper) {
       var inputData =  event.getParam("value");
       if(inputData.length > 2 ) {
           $A.util.removeClass(cmp.find('Spinner'), 'slds-hide');
           $A.util.removeClass(cmp.find('resultsDiv'),'slds-hide');
        	$A.util.removeClass(cmp.find('resultsDiv'),'slds-is-close');
           $A.util.addClass(cmp.find('resultsDiv'),'slds-is-open');
           cmp.set('v.searchTerm',inputData);
           helper.getRecords(cmp,inputData);
       } else {
           $A.util.addClass(cmp.find('resultsDiv'),'slds-is-close');
           $A.util.removeClass(cmp.find('resultsDiv'),'slds-is-open');
       }
    },
    // when record selected
    selectItem : function( component, event, helper ) {
        var recData = event.currentTarget.name;
        console.log(recData.Id);
        component.set('v.selectedPill',recData.Name);
        component.set('v.selectedRecordId',recData.Id);
        var d = component.get('v.selectedPill'); 
        console.log("t=====",component.get('v.selectedPill')); 
        component.set('v.value',event.currentTarget.id);
        $A.util.addClass(component.find('lookupField'),'slds-hide');
	 	$A.util.removeClass(component.find('lookup-pill'),'slds-hide'); 
        $A.util.addClass(component.find('lookup-pill'),'slds-show');
        $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        $A.util.addClass(component.find('resultsDiv'),'slds-is-close');
	},
    //when pill removed
    removeItem : function( component, event, helper ){
        component.set('v.selectedPill','');
        component.set('v.searchTerm','');
        component.set('v.selectedRecordId','');
        $A.util.removeClass(component.find('lookupField'),'slds-hide');
        $A.util.addClass(component.find('lookupField'),'slds-show');
	 	$A.util.addClass(component.find('lookup-pill'),'slds-hide');
       	$A.util.removeClass(component.find('lookup-pill'),'slds-show');
        setTimeout( function() {
            component.find( 'inputLookup' ).focus();
        }, 250);
    },
    
})