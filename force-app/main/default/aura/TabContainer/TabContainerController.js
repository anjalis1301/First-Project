({
	reInit : function(component, event, helper) {
        console.log('page ref ==> ',component.get("v.pageReference"));
        var myPageRef = component.get("v.pageReference");
        var myId = myPageRef.state.c__info;
        console.log('before'+myId);
        /*if(!$A.util.isEmpty(myId)) {
             localStorage.setItem('tabId', myId);
        }*/
        /*if($A.util.isEmpty(myId)) {
            myId = localStorage.getItem('tabId');
        }*/
        $A.get('e.force:refreshView').fire();
        console.log('idDddd'+myId);
        //component.set("v.tabState",myId);
        //alert(component.get("v.tabState"));
        //console.log('State'+component.get("v.tabState"));
    },

    init : function(component, event) {
        var myId = localStorage.getItem('tabId');
        console.log(myId);
       /* component.set("v.tabState",myId);
        localStorage.removeItem('tabId');
        alert(component.get("v.tabState"));*/

    },

    fetchTabId :function(component, event, helper){
        if(!$A.util.isEmpty(event.getParam('value'))) {
            localStorage.setItem('tabId',event.getParam('value'));
       }
    }
})