public class AccountCaseHandler {
    public static void noDuplicate(List<Account> acList){
        for(Account a:acList){
            for(Account nm:[SELECT Name From Account]){
                if(a.Name==nm.Name){
                    a.addError('You cannot insert this name it already exist');
                }
            }
        }
    }
    public static void changeCases(Map<Id,Account> newAccMap, Map<Id, Account> oldAccMap){
        List<Case> accCaseUpdate=new List<Case>();
        List<Case> accRelatedCase = [SELECT Status, AccountId FROM Case WHERE	 AccountId IN :newAccMap.keySet()];
        for(Id accId:newAccMap.keySet()){
            Account a=newAccMap.get(accId);
           if(a.Case_Status__c != oldAccMap.get(accId).Case_Status__c){
                for(Case cs:accRelatedCase){
                    if(cs.AccountId==a.Id){
                        cs.Status=a.Case_Status__c;
                        accCaseUpdate.add(cs);
                    }
                    
                }
            }
        }
        if(accCaseUpdate.size()>0){
            update accCaseUpdate;
        }
    }
}