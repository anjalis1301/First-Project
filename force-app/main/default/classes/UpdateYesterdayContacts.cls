/*************************************************************************************@@
ClassName	: UpdateYesterdayContacts
Author		: Anjali Sharma
CreateDate	: 08/02/2021
Purpose		: To update yesterday's contact status  
*************************************************************************************/
global class UpdateYesterdayContacts implements Database.Batchable<Sobject>,Schedulable,Database.Stateful {
    String finalString = '';
    Attachment at;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String header = 'Id,LastName,Status__c,CreatedDate,Last_Change__c,Description,NRI__c\n';
        finalString = header;
        //Map<Id,Contact> tempCon = 
        return Database.getQueryLocator('SELECT Id,LastName,Status__c,CreatedDate,Last_Change__c,NRI__c,Description FROM Contact WHERE CreatedDate = TODAY AND Status__c != \'Ready For Approval\'');
            
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> coList) {
            for(Contact c: coList) {
                c.Status__c = 'Ready For Approval';
                finalString += c.id+','+c.LastName+','+c.Status__c+','+c.CreatedDate+','+c.Last_Change__c+','+c.Description?.escapeCsv() +','+c.NRI__c+'\n';
                
                if(at == null){
                    at = new Attachment(Name='tempAtt', parentId=c.Id);
                }
                
            }
            update coList;
    }
    
    global void finish(Database.BatchableContext bc) {
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[]{'anjali@briskminds.com'};
        String[] ccAdd = new String[]{'pradhuman.sharma@briskminds.com'};
        mail.setToAddresses(toAddress);
        mail.setccaddresses(ccAdd);
        mail.setSubject('Yesterday\'s Contacts');
        mail.setPlainTextBody('All Yesterday\'s Contact are in Attached CSV');
        Messaging.EmailFileAttachment csvAtt = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalString);
        csvAtt.setFileName('Contacts.csv');
        csvAtt.setBody(csvBlob);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAtt});
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
    
    global void execute(SchedulableContext sc) {
        UpdateYesterdayContacts uYC = new UpdateYesterdayContacts();
        Database.executeBatch(uYC);
    }
    
}