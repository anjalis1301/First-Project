({  //method to get the objects from apex
    getObjects : function(cmp) {
        var action = cmp.get("c.objectNames");
        var objLst = [];
        action.setCallback(this,function(response){ 
            if(response.getState() === 'SUCCESS') {
                objLst = response.getReturnValue();
                cmp.set("v.objectMap",objLst);
                cmp.set("v.objectList",Object.keys(objLst));
            }
        });
        $A.enqueueAction(action);
    },
    
    //method to get selected object fields and pickList fields
    getFieldsAndPickLists : function(cmp, objName) {
        var action = cmp.get("c.fieldsAndPkLst");
        action.setParams({
            "objName" : objName
        });
        action.setCallback(this,function(response) {
            if(response.getState() === 'SUCCESS') {
                var resp = response.getReturnValue();
                var options=[];
                var reqOpt = [];
                for(var i in resp.fieldMap) {
                    if(resp.fieldMap[i] == 'Name') {
                        reqOpt.push(resp.fieldMap[i]);
                    }
                    options.push({label: i, value: resp.fieldMap[i]});
                }
                cmp.set("v.fieldOptions",options);
                cmp.set("v.reqOptions",reqOpt);
                var opt = [];
                for(var i in resp.pickLst) {
                    opt.push({label: i, value: resp.pickLst[i]});                    
                }
                cmp.set("v.pickListNames",opt);
                cmp.set("v.showPickList",true);
            }
        });
        $A.enqueueAction(action);
    },
    
    //method to get the data of the selected records and selected pickList values
    getSelectedData : function(cmp) {
        var selectedFlds = cmp.get("v.selectedFields");
        var selectedObj = cmp.get("v.selectedObject");
        var pickListNm = cmp.get("v.selectedPickList");
        var action = cmp.get("c.getData");
        action.setParams({
            "objName" : selectedObj,
            "fields"  : selectedFlds,
            "pickListName" : pickListNm
        });
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS') {
                var selectFld = selectedFlds.split(',');
                var resp = response.getReturnValue();
                cmp.set('v.kanbanHeaders',resp.pickListValues);
                var jsonStr = '[';
                var recData = resp.objRecords;
                for(var i = 0; i < recData.length;i++) {
                    jsonStr +='{ "Id" : "'+recData[i].Id+'", ';
                    for(var j = 0; j < selectFld.length; j++) {
                        if(recData[i][selectFld[j]] == undefined) {
                            recData[i][selectFld[j]] = '';
                        }
                        jsonStr += ' "label'+ j + '" : "'+recData[i][selectFld[j]]+'",';                        
                    }
                    jsonStr = jsonStr.slice(0,-1);
                    jsonStr += ' },';
                }
                jsonStr = jsonStr.slice(0,-1);
                jsonStr += ']';
                var arr = JSON.parse(jsonStr);
                cmp.set("v.sObjectRecords",arr);
                this.displayCount(cmp);
                cmp.set('v.displayKanban',true);
            }
        });
        $A.enqueueAction(action);
    },
    
    //update selcted records pickList value
    updateRecord : function(cmp,selectedId , selectedPickFld, newPickVal) {
        var action = cmp.get("c.updatePickVal");
        action.setParams({
            "selectObj":cmp.get("v.selectedObject"),
            "selectFlds":cmp.get("v.selectedFields"),
            "selectId":selectedId,
            "selectPickFld":selectedPickFld,
            "newVal":newPickVal
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                this.getSelectedData(cmp);
            }
        });
        $A.enqueueAction(action);
    },
    
    //display the number of records on each pickList value
    displayCount : function(cmp) {
        var countList = [];
        var headers = cmp.get('v.kanbanHeaders');
        var data = cmp.get('v.sObjectRecords');
        for(var i = 0;i < headers.length; i++) {
            var count = 0;           
            for(var j = 0;j<data.length; j++) {
                if(headers[i] == data[j]['label1']) {
                    count++;
                }
            }
            countList.push({header:headers[i],count:count});
        }
        cmp.set('v.headerList',countList);
    }
    
})