public with sharing class TestContact {
	@AuraEnabled
    public static Contact saveContact(Contact con) {
        System.debug('con' + con);
        insert con;
        return con;
    }
}