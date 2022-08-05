({
	handleClick : function(component, event, helper) {
        alert('hii');
        component.set("v.message",'hello');
	},
    createCon : function(component, event, helper) {
        let validCon = component.find('conRec').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        },true);
        if(validCon) {
            let con = component.get("v.Con");
            console.log("Create Expense"+JSON.stringify(con));
            helper.saveData(con,component);	
        }
    },
    handleChange:function(component, event, helper) {
        alert('hello');
        let messag = event.getParam('mess');
        component.set("v.message",messag);
       // let mess = 
    }
})