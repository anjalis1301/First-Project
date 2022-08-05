({
    //method that sets the data on the component when any change is made
    data: function(cmp) { 
        var recPerPage = cmp.find("rec").get("v.value");
        var sIds = cmp.get('v.selectedIds');
        var sortBy = cmp.get('v.sortField');
        var sortDir = cmp.get('v.sortOrder');
        var allData = cmp.get('v.completeData');
        var recordSizeChange = cmp.get("v.recordsPerPg");
        var page = cmp.get('v.currentPage');
        var len = allData.length;
        var lastPage = Math.ceil(len / recPerPage);
        cmp.set('v.totalPages',lastPage);
        var start = (page-1) * recPerPage;
        var end = recPerPage * page;
        var dpList = [];
        for(var i=start;i < end;i++) {
            if(allData[i] !== undefined){
                dpList.push(allData[i]);
            }
        }
        cmp.set("v.displayList",dpList);
        if(recordSizeChange) {
            cmp.set("v.recordsPerPg",false);
            this.navBtnNumberChange(cmp,page,'First',lastPage);
        }
        this.sortData(cmp,sortBy,sortDir);
        cmp.find('recordsTable').set('v.selectedRows',sIds);
    },
    
    //this method changes the labels of numbered navigation button
    navBtnNumberChange: function(cmp, currentPg, btnPressed,lastPage) {
        if(btnPressed === 'Next') {
            if((currentPg - 2 > 1) && (currentPg + 2 <= lastPage)) {
                for(var i = 1;i < 6;i++) {
                    var label = parseInt(cmp.find("btn"+i).get("v.label"));
                    cmp.find("btn"+i).set("v.label",label + 1);
            	}
            }
        } else if(btnPressed === 'Previous') {
            if((currentPg - 2 >= 1) && (currentPg + 2 < lastPage)) {
                for(var i = 1;i < 6;i++) {
                    var label = parseInt(cmp.find("btn"+i).get("v.label"));
                    cmp.find("btn"+i).set("v.label",label - 1);
            	}
            }
        } else if(btnPressed === 'Last') {
            var count = 0;
            for(var i = 5;i >= 1;i--) {
                    var label = parseInt(cmp.find("btn"+i).get("v.label"));
                    cmp.find("btn"+i).set("v.label",lastPage - count);
                	count++;
            } 
        } else {
            for(var i = 1;i < 6;i++) {
                var label = parseInt(cmp.find("btn"+i).get("v.label"));
                cmp.find("btn"+i).set("v.label",i);
            }
        }
        
        
    },
    
    //method to perform client side sorting
    sortData: function(cmp, sortField,sortOrder) {
        var data = cmp.get("v.displayList");
        var reverse = sortOrder !== 'asc' ;
        data = Object.assign([],data.sort(this.sortBy(sortField,reverse	? -1 : 1)));
        cmp.set('v.displayList',data);
    },
    sortBy: function(sortField,reverse,primer) {
        var key = primer ? function(x) { return primer(x[sortField]);} : function(x) { return x[sortField]; };
        return function(a, b) {
            var A = key(a);
            var B = key(b);
            return reverse * ((A > B) - (B > A));
        };
    },
})