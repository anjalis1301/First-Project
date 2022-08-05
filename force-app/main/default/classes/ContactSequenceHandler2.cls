/*************************************************************************************@@
ClassName	: ContactSequenceHandler2
Author		: Anjali Sharma
CreateDate	: 30/12/2020
Purpose		: To maintain the sequence number on each contact that is associated with an account 
*************************************************************************************************/

public class ContactSequenceHandler2 {
    
    public static List<Account> accoldList = new List<Account>();		 //List of account that contains old values from beforeUpdate method
    public static List<Contact> conOldList = new List<Contact>();		//List of old Contacts from before update
    public static List<Contact> relatedContacts= new List<Contact>(); 	//List To store relatedContacts and update them at end
    public static boolean updateCall=true;								//Boolean Flag for calling and stoping after update
    public static boolean updateBeforeCall=true;						//Boolean Flag for calling and stoping before update
    
    //method that is called after insert and after undelete to manage the sequence number
    public static void afterInsertOrUndeleteRec(List<Contact> newContactList) {
        Set<Id> parentId= new Set<Id>();                        //Set to store parent Accounts Ids
 		Map<Id,List<Contact>> contactMap=new Map<Id,List<Contact>>();  //Map to store account id and its related contacts
        List<Contact> sortedNewList = [SELECT Id, AccountId, LastName, Sequence_Number__c FROM Contact WHERE Id IN :newContactList ORDER BY Sequence_Number__c NULLS LAST];
        for(Contact c : sortedNewList) {
            parentId.add(c.AccountId);
        }        
        List<Account> acc = [SELECT Id,(SELECT Id,AccountId,LastName,Sequence_Number__c FROM Contacts where id NOT IN:newContactList Order By CreatedDate) From Account where Id IN :parentId];
        for(Account accTemp : acc) {
            for(integer i = 0;i < accTemp.Contacts.size();i++) {
                if(accTemp.Contacts[i].Sequence_Number__c == null) {
                    accTemp.Contacts[i].Sequence_Number__c = i+1;
                }
            }
            relatedContacts = accTemp.Contacts;
            contactMap.put(accTemp.Id, relatedContacts);
        }
        for(Contact con : sortedNewList){ 
            for(Account a : acc){
                
                if(a.id == con.AccountId){
                    relatedContacts = new List<Contact>();
                    if(contactMap.containsKey(a.id)) {
                        relatedContacts = contactMap.get(a.Id);     
                    } else {
                        relatedContacts = a.Contacts;
                    }
                    relatedContacts.add(new Contact(id = con.Id,lastName = con.LastName, Sequence_Number__c = relatedContacts.size()+1));                    
                    if(!contactMap.containsKey(a.id)) {
                        contactMap.put(a.id,new List<Contact>());
                    }
                    contactMap.put(a.id,relatedContacts);
                }                
            }            
        }
        relatedContacts = new List<Contact>();
       // relatedContacts.addAll(contactMap.values());
        for(id conKey : ContactMap.keySet()) {            
            relatedContacts.addAll(contactMap.get(conKey));
        }
        updateCall = false;
        updateBeforeCall = false;
        update relatedContacts;
        updateCall = true;
    }
    
    //method that is called after delete operations so that the remaining records sequence number can be shifted back 
    public static void afterDeleteRecords(List<Contact> oldContactList) {
        Set<Id> parentId = new Set<Id>();
        Map<Id,Integer> deletedCon=new Map<Id,Integer>();
        Map<Id,List<Contact>> accMap = new Map<Id,List<Contact>>();
        List<Contact> conToUpdate = new List<Contact>();
        for(Contact c : oldContactList) {
            parentId.add(c.AccountId);
        }   
        List<Account> parentAcc = [SELECT Id,(SELECT Id,Sequence_Number__c,AccountId FROM Contacts where id not in :oldContactList )from Account where Id IN :parentId];
        List<Contact> sortedContact = [SELECT Id, AccountId, Sequence_Number__c FROM Contact WHERE Id IN :oldContactList ORDER BY Sequence_Number__c DESC ALL ROWS];
        for(Account acc : parentAcc) {
            accMap.put(acc.Id, acc.Contacts);
        }
        for(Contact oldC : sortedContact) {
            if(accMAp.get(oldC.AccountId).size() > 0) {
                for(Contact relatedC:accMap.get(oldC.AccountId)) {
                    if(relatedC.sequence_Number__c > oldC.Sequence_Number__c) {                     
                        relatedC.Sequence_Number__c--;
                    }
                }
            }
        }
        relatedContacts = new List<Contact>();
        for(id conKey : accMap.keySet()) {            
            relatedContacts.addAll(accMap.get(conKey));
        }
        updateCall = false;
        updateBeforeCall = false;
        update relatedContacts;
    }
    
    //method that is called before update operation 
    public static void beforeUpdateRecords(Map<Id,Contact> oldUpdateRecMap,Map<Id,Contact> newUpdateRecMap) {
        if(updateBeforeCall) {
            Set<Id> parentId = new Set<Id>();
            Set<Id> allParentId = new Set<Id>();
            for(Contact con : oldUpdateRecMap.values()) {
                parentId.add(con.AccountId);
            }
            for(Contact con : newUpdateRecMap.values()) {
                allParentId.add(con.AccountId);
            }
            allParentId.addAll(parentId);
            accOldList = [SELECT Id,(SELECT Id,LastName,Sequence_Number__c,AccountId FROM Contacts) From Account WHERE Id IN :allParentId];
            conOldList = [SELECT  Id,LastName,Sequence_Number__c,AccountId FROM Contact WHERE Id IN :oldUpdateRecMap.keySet()];
        }
    }
    
    //method that is called after update operation
    public static void afterUpdateRecords(Map<Id,Contact> oldUpdateRecMap,Map<Id,Contact> newUpdateRecMap) {
        if(updateCall) {
            Map<Id,List<Contact>> accMap = new Map<Id,List<Contact>>();
            List<Contact> relContact = new List<Contact>();
            List<Contact> newList = [SELECT Id,LastName,AccountId,Sequence_Number__c FROM Contact WHERE ID IN :newUpdateRecMap.keySet() ORDER BY Sequence_Number__c DESC ];
            Map<Id,Contact> newUpdateMap = new Map<Id,Contact>();
            Map<Id,Contact> oldUpdateMap = new Map<Id,Contact>();
            List<Contact> chngAccAddLast = new List<Contact>();
            newUpdateMap.putAll(newList);
            oldUpdateMap.putAll(conOldList);
            for(Account ac : accOldList) {
                accMap.put(ac.Id,ac.Contacts);
            }
            for(Contact con : newUpdateMap.values()) {
                if(oldUpdateMap.get(con.Id).AccountId != con.AccountId){
                    relContact = accMap.get(oldUpdateRecMap.get(con.Id).AccountId);
                    chngAccAddLast = accMap.get(con.AccountId);
                    for(Contact rCon : relContact) {
                        if(rCon.Sequence_Number__c > oldUpdateRecMap.get(con.Id).Sequence_Number__c) {
                            rCon.Sequence_Number__c --;
                        }
                    }
                    con.Sequence_Number__c = accMap.get(con.AccountId).size()+1;
                    chngAccAddLast.add(con);
                    accMap.put(con.AccountId,chngAccAddLast);
                    for(integer i = 0;i < relContact.size();i++) {
                        if(relContact[i].Id == con.Id){
                            relContact.remove(i);
                        }
                    }
                    accMap.put(oldUpdateRecMap.get(con.Id).AccountId,relContact);
                }
                else if (con.Sequence_Number__c == null || con.Sequence_Number__c <=0 || con.Sequence_Number__c > accMap.get(con.AccountId).size()) {
                    newUpdateRecMap.get(con.id).Sequence_Number__c.addError('Insert a valid sequence number');
                }
                else {
                    relContact = accMap.get(con.AccountId);
                    for(Contact rCon : relContact){
                        if(rCon.Id == con.Id){
                            rCon.Sequence_Number__c = con.Sequence_Number__c;
                        }
                        else if(rCon.Sequence_Number__c > oldUpdateMap.get(con.Id).Sequence_Number__c && rCon.Sequence_Number__c <= con.Sequence_Number__c) {
                            rCon.Sequence_Number__c--;
                        }
                        else if(rCon.Sequence_Number__c < oldUpdateMap.get(con.Id).Sequence_Number__c && rCon.Sequence_Number__c >= con.Sequence_Number__c) {
                            rCon.Sequence_Number__c++;
                        }
                    }
                    for(Contact c : relContact ) {
                        if(oldUpdateMap.keySet().contains(c.Id)) {
                            oldUpdateMap.get(c.Id).Sequence_Number__c = c.Sequence_Number__c;
                        }
                    }
                    
                    accMap.put(con.AccountId,relContact);
                }
            }
            relContact = new List<Contact>();
            for(Id acId : accMap.keySet()) {
                relContact.addAll(accMap.get(acId));
            }
            updateCall = false;
            updateBeforeCall = false;
            update relContact;
        } 
    }
}