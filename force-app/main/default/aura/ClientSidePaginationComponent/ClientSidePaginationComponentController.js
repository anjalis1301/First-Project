({	
    //Handler function load initial Values 
	doInit : function(cmp, event, helper) {
        
        var completeData = cmp.get("v.completeData");
       cmp.set('v.currentPage','1');
       cmp.find("prev").set("v.disabled",true);       
       cmp.find("first").set("v.disabled",true);
         cmp.set("v.header",[
             {label:"Account Name",fieldName:"Name",type:"text", sortable:true},
             {label:"Account Type",fieldName:"Type",type:"text",sortable:true}
           ]);
         var action = cmp.get("c.getData"); 
        action.setCallback(this, function(response) { 
            var result = response.getReturnValue(); 
            var newData = completeData.concat(result);
            cmp.set("v.completeData", newData);
            helper.data(cmp);
        }); 
        $A.enqueueAction(action); 
	},
    //this function call on the recordSize select option change, 
    onrecordChange : function(cmp, event, helper) {
        cmp.set("v.currentPage","1");
        var sortBy = cmp.get('v.sortBy');
        var sortDir = cmp.get('v.sortOrder');
        cmp.set("v.recordsPerPg",true);
        helper.data(cmp); 
        
    },
    //this function calls on checkbox selection 
    rowSelected : function(cmp, event, helper) {
      var rowsSelected = event.getParam('selectedRows');
      var selectIds = cmp.get("v.selectedIds");
      var currentPgData = cmp.get("v.displayList");
      var tempIds = [];
      console.log('selected',JSON.stringify(rowsSelected));
        var currentIds = [];
        for(var i=0;i<rowsSelected.length;i++) {
            tempIds.push(rowsSelected[i].Id);
			 if(!selectIds.includes(rowsSelected[i].Id)) {
            	selectIds.push(rowsSelected[i].Id);
        	}            
        }
        for(var i = 0;i < currentPgData.length;i++) {
            if(selectIds.includes(currentPgData[i].Id) && !tempIds.includes(currentPgData[i].Id)) {
                selectIds.splice(selectIds.indexOf(currentPgData[i].Id),1);
            }
        }
        cmp.set("v.selectedIds",selectIds);
      
       
    },
    //this function calls on any datatable header is clicked to perform sorting
    sortByField:function(cmp, event, helper) {
        var sortBy = event.getParam('fieldName');
        var sortDir = event.getParam('sortDirection');
        cmp.set("v.sortField",sortBy);
        cmp.set("v.sortOrder",sortDir);
        helper.sortData(cmp,sortBy,sortDir);
    },
   //this method calls when any navigation button is clicked
    navigate: function(cmp, event, helper) {
        
       cmp.find("prev").set("v.disabled",false);
       cmp.find("first").set("v.disabled",false);
        var sortBy = cmp.get('v.sortBy');
        var sortDir = cmp.get('v.sortOrder');
        var lastPage = cmp.get("v.totalPages");
        var page = parseInt(cmp.get("v.currentPage"));
    	var btn = event.getSource().get("v.title");
        page = btn === "Previous" ? (page - 1) : btn === "First" ? 1 : btn === "Last" ? lastPage: (page + 1);
        cmp.set('v.currentPage',page);
        if(page == '1') {
            console.log('page1');            
            cmp.find("prev").set("v.disabled",true);
            cmp.find('first').set("v.disabled",true);
        }
        console.log('^^^^',page);
        helper.navBtnNumberChange(cmp,page,btn,lastPage);
        console.log('///',page);
        helper.data(cmp);
        console.log(page);
	},
    // this method is called when the numeric navigation button is clicked
    navigateNumberClick: function(cmp,event,helper) {
		var page = parseInt(event.getSource().get("v.label"));
        if(page == '1') {
            console.log('page1');            
            cmp.find("prev").set("v.disabled",true);
            cmp.find('first').set("v.disabled",true);
        }
        var counter = -2;
        console.log('efore loop',page);
        if( (page - 2 >= 1) && (page + 2 <=cmp.get('v.totalPages'))) {    
            console.log('in condition');
            for(var i = 1; i < 6 ;i++) {
                console.log('in loop');
                console.log('@@@',counter);
                cmp.find("btn"+i).set("v.label",page + counter);
                counter++;
            }
        } else if(page - 1 == 1) {
            for(var i = 1; i < 6 ;i++) {
                cmp.find("btn"+i).set("v.label", i);
            }
        } else if(page + 1 == cmp.get('v.totalPages')){
            var count=0;
            for(var i = 5; i >=1  ;i--) {
                cmp.find("btn"+i).set("v.label",cmp.get('v.totalPages')-count);
                count++;
            }
        } else if(page - 1 == cmp.get('v.totalPages')) {
            var total = cmp.get('v.totalPages');
            console.log(total);
            for(var i = 5;i>=1;i++) {
                cmp.find("btn"+i).set("v.label", total);
                total--;
            }
        }
        cmp.set('v.currentPage',page);
        helper.data(cmp);
    },
    

})