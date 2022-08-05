({
    doInit : function(component, event, helper) {
        helper.onInit(component, event, helper);
    },

    doHandleChange : function(component, event, helper) {
       // helper.onHandleChange(component, event, helper);
       helper.getFields(component, event, helper);
    },

    handleChange: function (cmp, event) {
        // This will contain an array of the "value" attribute of the selected options
        var selectedOptionValue = event.getParam("value");
        cmp.set("v.selectedFields",selectedOptionValue);
        
    },

    handleClick: function(cmp,event,helper) {
        //{label:"Account Name",fieldName:"Name",type:"text", sortable:true},
        var listSelFld = cmp.get("v.selectedFields");
        var tempFields = [];
        var temp = [];
        var fieldMap = cmp.get("v.fieldNameList");
        console.log('selectedF',fieldMap);
        for(var i =0; i< fieldMap.length;i++){
            if(listSelFld.includes(fieldMap[i].value)){
                alert('gu');
               tempFields.push({label:fieldMap[i].label, fieldName:fieldMap[i].value,sortable:true});
               temp.push(fieldMap[i]);
            }
        }
        console.log('headers',tempFields);
        cmp.set('v.tableFields',tempFields);
        cmp.set('v.fieldsList',temp);
        console.log('v.fieldsList',cmp.get('v.fieldsList'));
        helper.getData(cmp);
        cmp.set('v.displayDataTable','true');
    },

    displayList : function(component,event,hepler){
        var selObject = component.find('selectObject').get('v.value');
        var action = component.get('c.listAllFields');
       // var action = cmp.get("c.serverEcho");
		action.setParams({ selectedObject : selObject });
        if(selObject!=null && selObject!='' && selObject!=undefined){
            component.set("v.fieldsList",fieldList);
            alert(JSON.stringify(fieldList)+ ' @@@@@@@@@@@@@');
		}
    }
})