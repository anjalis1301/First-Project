({ 
    //Handler function load initial Values 
    doInit: function(cmp, event, helper) { 
        var currentPage = cmp.get("v.currentPage") || 1; 
        
        cmp.set('v.tableHeaders', [ 
            {label: 'Account Name', fieldName: 'Name', type: 'text', sortable: true},
            {label: 'Website', fieldName: 'Website', type: 'text', sortable: true},
            {label: 'Industry', fieldName: 'Industry', type: 'text', sortable: true},
            {label: 'Created Date', fieldName: 'CreatedDate', sortable: true},
            {label: 'Phone', fieldName: 'Phone', type: 'number', sortable: true}]); 
        cmp.set("v.sortColumn",'Name');
        cmp.set("v.sortDir",'asc');
        var action = cmp.get("c.totalCount");
        action.setCallback(this,function(response) {
            if(response.getState() === 'SUCCESS')  {
                cmp.set("v.totalRecords",response.getReturnValue());
        		helper.getRecordsData(cmp, currentPage,'','Name','asc');
            }
        });
        $A.enqueueAction(action);
         
    }, 
    // this function call when any navigation button is pressed,
    navigation: function(cmp, event, helper) {
        var currentPage = cmp.get("v.currentPage") || 1;
        var lastPage = cmp.get("v.totalPages");
        var accRec = cmp.get("v.AccountRecords");
        var last = accRec.length;
        var lastId = '';
        var btnLab = event.getSource().get("v.label");
        currentPage = btnLab === "Previous Page" ? (currentPage - 1)   : btnLab === "First" ? 1 : btnLab === "Last" ? lastPage: (currentPage + 1);  
        var sortColName = cmp.get('v.sortColumn');
        var sortDirection = cmp.get('v.sortDir');
        helper.getRecordsData(cmp, currentPage,false, sortColName,sortDirection);
    }, 
    
    // this function call on the select option change,  
    changeRecordSize: function(cmp, event, helper) {
        var currentPage = 1; 
        var sortColName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        if(sortColName != undefined  && sortColName != '') {
            cmp.set("v.sortColumn",sortColName);
            cmp.set("v.sortDir",sortDirection);
            helper.getRecordsData(cmp, currentPage,false, sortColName,sortDirection);
        } else {
            cmp.set("v.sortColumn",'Name');
            cmp.set("v.sortDir",'asc');
            helper.getRecordsData(cmp, currentPage,true, 'Name','asc');
        }
    },
    
    //this function calls on any datatable header is clicked to perform sorting
    sortThroughHeaders: function(cmp, event, helper) {
        var currentPage = cmp.get("v.currentPage") || 1;
        var sortColName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortColumn",sortColName);
        cmp.set("v.sortDir",sortDirection);
        helper.getRecordsData(cmp, currentPage,false,sortColName,sortDirection);
    },
    
    //this function calls on checkbox selection 
    recodSelect: function(cmp,event,helper) {
        var selectRows = event.getParam('selectedRows');
        var selectedRec = cmp.get("v.selectedRecords");
        var accOnPage = cmp.get("v.AccountRecords");
        var currentSelectedIds = [];
        for(var i=0; i < selectRows.length; i++) {
            currentSelectedIds.push(selectRows[i].Id);
            if(!selectedRec.includes(selectRows[i].Id)) {
                selectedRec.push(selectRows[i].Id);
            }
        }
        for(var i = 0;i < accOnPage.length;i++) { 
            if(selectedRec.includes(accOnPage[i].Id) && !(currentSelectedIds.includes(accOnPage[i].Id))) {
                selectedRec.splice(selectedRec.indexOf(accOnPage[i].Id),1);
            }
        } 
        var table = cmp.find("recordsTable").set("v.selectedRows",selectedRec);
        cmp.set("v.selectedRecords",selectedRec);    
    }
})