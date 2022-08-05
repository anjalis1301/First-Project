({
    doInit : function(component,event, helper){
        console.log('innnnnnnnnnnnnnnnnnnn');
        console.log('page ref cmp22222 ==> ',component.get("v.pageReference"));
        var myPageRef = component.get("v.pageReference");
        var myId = myPageRef.state.c__infoTabb;
        console.log(myId);
        component.set("v.tabId",myId);
    }
})