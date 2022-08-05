({
    onInit : function(component, event, helper) {
        /* Call the Apex class method to fetch the List of all object */
        var action = component.get('c.listAllObject');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                /* set the value to the attribute of the component */
                var responseValue = response.getReturnValue();
                var lstOptions = [];
                for(var i=0; i < responseValue.length; i++){
                    lstOptions.push({
                        value : responseValue[i].split('####')[1],
                        key : responseValue[i].split('####')[0]
                    });
                }
                lstOptions.sort();
                component.set('v.objectList', lstOptions);
                
            }else{
                var errors = response.getError();
                $A.log(errors);
                if(errors || errors[0].message){
                    console(errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getFields : function(component, event, helper){
        var selObject = component.find('selectObject').get('v.value');
        var action = component.get('c.listFields');
        action.setParams({
            "objectName" : selObject  
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if( state === 'SUCCESS' && component.isValid()){
                var responseVal = response.getReturnValue(); //response.getReturnValue()
                var fieldList = [];
                var tempList = [];
                for(var i = 0; i < responseVal.length ; i++) {
                    fieldList.push({key:responseVal[i].apiName,value:responseVal[i].label});
                    tempList.push({label:responseVal[i].label, value : responseVal[i].apiName});
                    console.log('values  ',JSON.stringify(tempList));
                }
                var fList = Object.values(fieldList);
                component.set("v.fieldNameList",tempList);
               // component.set("v.fieldData",fieldList);
               // component.set("v.fieldsList",Object.values(fieldList));
                component.find("dualList").set("v.options",tempList); 
            }
        });
        $A.enqueueAction(action);
    },

    getData : function(component) { 
        var selObject = component.find('selectObject').get('v.value');
        var selectedFields = component.get("v.selectedFields");
        var fld = selectedFields.toString().replace("[", "").replace("]", "");
        alert(fld);
        var action = component.get("c.dataList");
        action.setParams({
            "fieldList" : fld  ,
            "objectName" : selObject 
        });
        action.setCallback(this,function(response) {
            if(response.getState() === 'SUCCESS') {
                var fields = component.get('v.fieldsList');
                var tableRow = [];
                var row = [];
                var resp = response.getReturnValue();
               // console.log('@@@@@@@@@',resp[0].sObjectData);
//                console.log(JSON.stringify(fields)+ '@@@@@@');
                for(var i = 0; i<resp.length; i++) {
                    tableRow.push(resp[i].sObjectData);
                    var fieldData = []; 
                    for(var fld in fields) {
                        //console.log(resp[i].sObjectData);
                        if(resp[i].sObjectData == undefined){
                            //console.log('In If');
                            fieldData.push({value:null});
                        } else {
                           //console.log(fields[fld].value+'///////////');
                           // console.log(resp[i].sObjectData[fields[fld].value]+ '!!!!!!!');
                            fieldData.push({value: resp[i].sObjectData[fields[fld].value]});
                        }   
                    }
                    row.push({
                        	  isChecked:resp[i].isChecked,
                              Id: resp[i].sObjectData.Id,
                              values: fieldData
                    });  
                }
               // console.log('row',JSON.stringify(row));
               // console.log('col',JSON.stringify(fieldData));
                component.set('v.data',row);
                console.log('tabledata',tableRow);
                component.set('v.allData',tableRow);
                
               /* var resp = response.getReturnValue();
                var objectData = resp.sObjectData;
                console.log('vg',objectData);
                for(var i=0;i < resp.length;i++){
                    console.log('gii');
                    for(var j =0;j <selectedFields.length;j++){
                        var ser = resp[i].sObjectData;
                        console.log(ser,'ser');
                        var fieldNm =  selectedFields;
                        console.log(fieldNm,'fdnm');
                        // objectValue[j][fieldList[i].apiName];
                        tempJSON.push({access: resp[i].sObjectData.Name});
                        console.log('dataaaa',JSON.stringify(tempJSON));
                        // tempJSON.push(resp[i].sObjectData);
                    }
                    // data.push(resp[i].sObjectData);   
                }
                console.log('yash ki shadi',JSON.stringify(tempJSON));
                console.log('respObj',resp.sObjectData);
                component.set("v.data",tempJSON);*/
            }
            
        });
        $A.enqueueAction(action);
    },
    /*onHandleChange : function(component, event, helper){
        /* Call this method whenever user will select the Obejct
         * and show the Dynamic Content 
        var selObject = component.find('selectObject').get('v.value');
        var action = component.get('c.listAllFields');
        alert('selObject');
        if(selObject!=null && selObject!='' && selObject!=undefined){
            action.setParams({
                "objectName" : selObject  
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if( state === 'SUCCESS' && component.isValid()){
                    //component.find("dynamicBody").set("v.body",[]);
                    component.find('sfdcDiv').set("v.body",[]);
                    var responseValue = response.getReturnValue();
                    var objectValue   = responseValue.sObjectData;
                    var fieldList     = responseValue.fieldList;
                    
                    /* Create Dynamic Table /
                    var sObjectDataTableHeader = [];
                    // Create table Header
                    for (var i=0; i <  fieldList.length; i++) {
                        sObjectDataTableHeader.push(fieldList[i].label);
                    }
                    console.log(sObjectDataTableHeader);
                    //Get the count of columns.
                    var columnCount = sObjectDataTableHeader.length;
                    //Create a HTML Table element.
                    var table = document.createElement("TABLE");
                    //table.border = "1";
                    //Add the header row.
                    var row = table.insertRow(-1);
                    for (var i = 0; i < columnCount; i++) {
                        var headerCell = document.createElement("TH");
                        headerCell.innerHTML = sObjectDataTableHeader[i];
                        headerCell.className='hearderClass';
                        row.appendChild(headerCell);
                    }
                    var dvTable = document.getElementById("sfdctable");
                    dvTable.innerHTML = "";
                    dvTable.appendChild(table);
                    /* Create Dynamic Table End /
                    
                    if(objectValue.length){
                        for(var j=0; j < objectValue.length; j++){
                            // Dynamic table Row
                            row = table.insertRow(-1);
                            // Dynamic Table Row End
                            for (var i=0; i <  fieldList.length; i++) {
                                // Dynamic table Row
                                var cell = row.insertCell(-1);
                                cell.innerHTML = objectValue[j][fieldList[i].apiName];
                                component.set('v.isSending' , false);
                                
                            }
                        }
                    }else{
                        
                    }
                }else{
                    var errors = response.getError();
                    $A.log('Error Details '+errors);
                    if( errors || errors[0].message){
                        console.log('Error Details '+errors[0].message);
                    }
                }
            });
            $A.enqueueAction(action);
        }else{
            component.set('v.isSending' , false);
        }
    },*/
})