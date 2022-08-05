({ 
    //this method get the data from apex and set it in dataTable
    getRecordsData: function(cmp, currentPage,lastId, sortColName, sortDirection) { 
        var spinn = cmp.find('spin');
/*        if(fromInit) {
            var lastDate = '';
        } else {
            var data = cmp.get("v.AccountRecords");
            var last = data.length;
            
            var lastDate = data[last - 1].Id;
        }*/
        $A.util.removeClass(spinn,"slds-hide");
        var recPerPage = cmp.find("recordsPerPage").get("v.value"); 
        var action = cmp.get("c.getRecords"); 
        action.setParams({
            
            "pageNumber": currentPage,
            "lastId":lastId,
            "recordToDisplay": recPerPage,
            "sortColName":sortColName,
            "sortDirection":sortDirection
        }); 
         
        action.setCallback(this, function(response) { 
            var result = response.getReturnValue(); 
            cmp.set("v.AccountRecords", result.recordsList); 
            cmp.set("v.currentPage", result.currentPageNo); 
           // cmp.set("v.totalRecords", result.totalAccRecords); '
           var total =cmp.get("v.totalAccRecords") ;
            cmp.set("v.totalPages", Math.ceil(total / recPerPage));
            var table = cmp.find('recordsTable').set('v.selectedRows',cmp.get('v.selectedRecords'));         
            $A.util.addClass(spinn,"slds-hide"); 
        }); 
        $A.enqueueAction(action); 
    },
    
})