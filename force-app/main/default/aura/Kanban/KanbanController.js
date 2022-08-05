({  //handler function loads initially all the objects names
    doInit : function(cmp, event, helper) {
        console.log('inIt');
        helper.getObjects(cmp);
    },
    
    //method to get all the fields and pickList fields of the selected object
    getFieldAndPickList : function(cmp, event, helper) {
        var objLabel = event.getSource().get("v.value");
        var objMap = cmp.get('v.objectMap');
        var objName = objMap[objLabel];
        cmp.set("v.selectedObject",objName);
        helper.getFieldsAndPickLists(cmp,objName);
        cmp.set('v.showFields',false);
        cmp.set('v.displayKanban',false);        
    },
    
    //method to store the selected pickList and required options for dualList box
    getPickList : function(cmp,event, helper) {
        var selectedList = cmp.find('pickSelect').get('v.value');  
        var select = cmp.get('v.reqOptions')[0];    
        var vals = [];
        vals.push(select);
        vals.push(selectedList);
        cmp.set('v.reqOptions',vals); 
        cmp.set('v.selectPickListValues',vals);
        cmp.set('v.showFields',true);
        cmp.set("v.selectedPickList",selectedList);
        cmp.set("v.selectedFields",vals.toString());
        if(vals[0] != undefined) {
            alert(vals[0]);
            cmp.set("v.processBtn",false);
        } else {cmp.set("v.processBtn",true);}
    },
    
    //method store the selected fields 
    selectedFieldNames : function(cmp,event,helper) {  
        var selected = event.getParam('value');
        cmp.set("v.selectedFields",selected.toString());
        if(selected.length >= 2 && selected.length<=4) {
            cmp.set("v.processBtn",false);
        } else {cmp.set("v.processBtn",true);}  
    },
    
    //method to call helper to show the data in kanban view
    showKanban : function(cmp,event,helper) {
        cmp.set("v.displayKanban",true);        
        helper.getSelectedData(cmp);
    },
    
    //method to open the clicked records detail page in edit mode
    editRecord  : function(component, event, helper) {
        var editRec = $A.get("e.force:navigateToSObject");
        editRec.setParams({
            "recordId": event.target.id
        });
        editRec.fire();
    },
    /**
    * methods to allow the drag and drop of the record item
    */
    allowDrop: function(component, event, helper) {
        event.preventDefault();
    },
    
    dragStart: function (component, event, helper) {
        event.dataTransfer.setData("text", event.target.id);        
    },
    
    dropData: function (cmp, event, helper) {
        event.preventDefault();
        var data = event.dataTransfer.getData("text");
        document.getElementById(data).style.backgroundColor = "#AFEEEE";
        event.target.appendChild(document.getElementById(data));
        helper.updateRecord(cmp,data,cmp.get("v.selectedPickList"),event.target.getAttribute('data-Pick-Val'));
    },
})