public class ContactSequenceHandler {
    public static Set<Id> parentId=new Set<Id>();
    public static List<Account> parentAcc = new List<Account>();
	 public static Map<Id,List<Contact>> contactMap=new Map<Id,List<Contact>>();
     public static List<Contact> relatedContacts= new List<Contact>(); 
  	 public static List<Contact> toUpdate = new List<Contact>();
    public static String a='hello';
    
    public static void insertCheck(List<Contact> newContactList){
        for(Contact con:newContactList){
            parentId.add(con.AccountId);
            //  List<Contact> alreadyRec = [SELECT Name FROM Contact WHERE Account.Id=con.AccountId];
        }
        if(parentId.size()>0){
            parentAcc=[SELECT Id,Name,(SELECT Name,Sequence_Number__c
                                       FROM Contacts ORDER BY Sequence_Number__c) FROM Account WHERE Id IN :parentId];
            System.debug(parentAcc);
        }
      //  List<Contact> con1=[SELECT Sequence_Number__c,Name FROM Contact WHERE Account.Id=:parentId AND Sequence_Number__c != null];  
       for(Contact con:newContactList){
           for(Account a:parentacc){
                    if(a.id==con.AccountId){
                        System.debug(a.Contacts.size());
                        relatedContacts=a.Contacts;
                        System.debug('relatedContacts'+relatedContacts);
                        if(!contactMap.containsKey(a.id)){
                            contactMap.put(a.id, new List<Contact>());
                        }
                        contactMap.put(a.id,relatedContacts);
                    }
                }     
            if(con.Sequence_Number__c==null || con.Sequence_Number__c > contactMap.get(con.AccountId).size()+ newContactList.size()){
                toUpdate.add(new Contact(Id=con.Id,Sequence_Number__c = contactMap.get(con.AccountId).size()+1));
               // con.Sequence_Number__c = con1.size()+1;
               // con1.add(con);
            }
         /* else{
                if(con.Sequence_Number__c <= 0){ 
                    for(Contact c:con1){
                        c.Sequence_Number__c++;
                    }
                    con.Sequence_Number__c=1;
                   // con1.add(con);
                    update con1;
                }
                else if(con.Sequence_Number__c < con1.size()){
                    for(Contact c:con1){
                        if(c.Sequence_Number__c >= con.Sequence_Number__c){
                            c.Sequence_Number__c++;
                        }
                    }
                    //con1.add(con);
                    update con1;
                } 
            }*/
            
        }
        
    }
    public static void beforeDelete(Map<Id,Contact> oldContactMap){
        Map<Id,List<contact>> delMap=new Map<id,List<Contact>>();
        System.debug('oldContactMap'+oldContactMap);
        for(Contact c:oldContactMap.values()){
            parentId.add(c.AccountId);
        }
        List<Account> parAcc=[SELECT Id,(SELECT Id, AccountId, Sequence_Number__c FROM Contacts Order By Name) From Account where Id IN :parentId];
        for(Account acc:parAcc){
            if(!delMap.containsKey(acc.id)){
                delMap.put(acc.id, new List<Contact>());
            }
            delMap.put(acc.id,acc.Contacts);
        }System.debug(delMap);
    }        
}