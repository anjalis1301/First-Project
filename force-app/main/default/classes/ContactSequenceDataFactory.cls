@isTest
public class ContactSequenceDataFactory {   

     public static List<Account> accountsAndCon(Integer noAcc, Integer noConPerAcc){
        Account[] accts = new List<Account>();
        for(Integer i = 0; i <noAcc; i++){
            Account a = new Account(Name='Account ' + i);
            accts.add(a);
        }
        insert accts;
        
        List<Contact> con = new List<Contact>();
        for(Integer i=0;i<noAcc;i++){
            Account acct=accts[i];
            for(Integer j=1;j<=noConPerAcc;j++){
                con.add(new Contact(lastName='c'+j,AccountId=acct.Id));    
            }
        }
        insert con;
        return accts;
    }
    
    public static void insertCheck(Integer numOfContact, List<Integer> SeqNo){
        
        List<Contact> inList = new List<Contact>();
        List<Account> parAcc = new List<Account>();
   		 parAcc.add(new Account(Name='Account A'));
   		 parAcc.add(new Account(Name = 'Account B'));
        insert parAcc;
        
        for(integer j=0;j<2;j++){
            Account acct = parAcc[j];
            for(integer i=0;i<5;i++){
                inList.add(new Contact(LastName = 'A'+i, AccountId = acct.Id));    
            }
        }
        
        
    }
}