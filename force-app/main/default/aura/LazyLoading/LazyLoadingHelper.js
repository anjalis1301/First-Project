({	//this function is called whenever next set of data is being fetched
	getData : function(cmp,event,lastId) {
        event.getSource().set("v.isLoading", true);
        var obj = cmp.get("v.objName");
        var fieldsName = cmp.get("v.fields");
		var action = cmp.get("c.fetchList");
        var dataList = cmp.get('v.dataList');
        action.setParams({
            "lastID" : lastId,
            "objName" : obj,
            "fields" : fieldsName
            
        });
        action.setCallback(this, function(response) {
            if(response.getState() === 'SUCCESS') {
           		var resp = response.getReturnValue();
                var newData = dataList.concat(resp);
                cmp.set('v.dataList',newData);
                event.getSource().set('v.isLoading',false);
            }
            this.sortData(cmp,cmp.get('v.sortBy'),cmp.get('v.sortDirection'));
        });
            
        $A.enqueueAction(action);
	},
    
    //this method is called when user perform sorting
    sortData : function(cmp, sortHeader, sortDirection) {
        var dataLst = cmp.get('v.dataList');
        var reverse = sortDirection !== 'asc';
        dataLst = Object.assign([],
        dataLst.sort(this.sortBy(sortHeader , reverse ? -1: 1 )));
        cmp.set('v.dataList',dataLst);
        cmp.set('v.sortBy',sortHeader);
        cmp.set('v.sortDirection',sortDirection);

    },
    sortBy: function (field, reverse, primer) {
        var key = primer
            ? function(x) {
                return primer(x[field]);
            }
            : function(x) {
                return x[field];
            };

        return function (a, b) {
            var A = key(a);
            var B = key(b);
            return reverse * ((A > B) - (B > A));
        };
    },
    
})