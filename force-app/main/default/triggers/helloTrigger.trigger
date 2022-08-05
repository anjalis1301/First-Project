trigger helloTrigger on hello__c (after insert) {
	List<hello__c> check=[SELECT Id,Name FROM hello__c WHERE Id IN :Trigger.new];
 
		check[0].NameCheck__c='Hello';
  
    update check;
}