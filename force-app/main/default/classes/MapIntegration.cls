/*************************************************************************************@@
Class Name     :  MapIntegration
Purpose        :  To query the necessary data and return it to the js helper  
DATE           :  01/06/2021
Author         :  Anjali Sharma
*********************************************************************************************************/

public with sharing class MapIntegration {
   @AuraEnabled
   public static void getData(Id currentRecordId) {
    System.debug(currentRecordId);
        List<GoogleMapIntegrationMeta__mdt> MapApiData = [SELECT API_Key__c FROM GoogleMapIntegrationMeta__mdt WHERE Label = 'MapIntegrationData'];
        if(MapApiData.size() > 0) {
            Account acc = [SELECT BillingStreet, (SELECT MailingStreet FROM Contacts) FROM Account WHERE Id = :currentRecordId];
            String newBillingStreet = acc.BillingStreet.replace(' ','+');
            System.debug(newBillingStreet);
            // HttpRequest request = new HttpRequest();
            // request.setEndpoint('https://maps.googleapis.com/maps/api/js?key=AIzaSyBTOHLm2G8vgQYxz_wkiBagXQi8jY1v7dE&callback=initMap&libraries=&v=weekly');
            // request.setMethod('POST');
            // Http httpObj = new Http();
            // HttpResponse response = httpObj.send(request); 
            // System.debug(response.getBody());
        }
       
   } 
   public static void initMap() {

   }
}