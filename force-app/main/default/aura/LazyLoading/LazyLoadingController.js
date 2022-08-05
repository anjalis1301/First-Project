({	//handler function loads initial values
	doInit : function(cmp, event, helper) {
        var fieldsNm = cmp.get('v.fields').split(',');
        var header =[];
        for(var i = 0;i < fieldsNm.length;i++) {
            header.push({label: fieldsNm[i], fieldName: fieldsNm[i], sortable:true});
        }
        cmp.set('v.tableHeaders',header);
        var action = cmp.get("c.totalCount");
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS') {
                cmp.set("v.totalAccounts",response.getReturnValue());
                helper.getData(cmp,event,'0');
            }   
        });
        $A.enqueueAction(action);
	},
    //this function calls on scrolling to load more data
    loadMoreData : function(cmp, event, helper) {
        var data = cmp.get('v.dataList');  
        var last = data.length;
        if(last < cmp.get("v.totalAccounts")) {
            var lastId = data[last-1].Id;
            helper.getData(cmp,event,lastId);
        } else {
            cmp.set("v.enableLazyLoading",false);
        }
        
    },
    //method for sorting
    sortDataByColumn : function(cmp, event, helper) {
        var sortHeader = event.getParam('fieldName');
        var sortDir = event.getParam('sortDirection');
        cmp.set('v.sortBy',sortHeader);
        cmp.set('v.sortDirection',sortDir);
        helper.sortData(cmp, sortHeader, sortDir);
    }
})