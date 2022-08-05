/*************************************************************************************@@
ClassName	: TrueLAyerService
Author		: Anjali Sharma
CreateDate	: 24/04/2021
Purpose		: To fetch data from box and return to BoxIntegration class
Test Suite  : BoxIntegrationTest
******************************************************************************************************/

public with sharing class TrueLayerService {
    public static List<Integration_Data__c> objData = new List<Integration_Data__c>();
    static { 
        objData = [SELECT ID,AccessToken__c, RefreshToken__c FROM Integration_Data__c WHERE UserId__c =:userInfo.getUserId() AND IntegrationApp__c ='Box' LIMIT 1];
   }

    //method create the url to get the authorization code
    public static String authorization(String clientId,String redirectUri) {
        String authURL =  'https://auth.truelayer-sandbox.com/?response_type=code&client_id=sandbox-salesforcebmninja-79620e&scope=info%20accounts%20balance%20cards%20transactions%20direct_debits%20standing_orders%20offline_access&redirect_uri=https://briskmindssoftwaresolutions-dev-ed.lightning.force.com/lightning/n/Try&providers=uk-ob-all%20uk-oauth-all';
        return authURL;
    }
	
    //method to make am api request to get the access token
     public static Integration_Data__c getAccessToken(String authCode, String clientId, String clientSecret) {
        String body='grant_type=authorization_code&code='+authCode+'&client_id='+clientId+'&client_secret='+clientSecret;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(BoxIntegrationConstants.ACCESSTOKENURL);
        request.setBody(body);
        request.setMethod('POST');
        request.setTimeout(60*1000);
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        Http h = new Http();
        HttpResponse resp = h.send(request);
        System.debug(resp.getBody());
        Integration_Data__c intData = new Integration_Data__c();
        Map<String,object> respMap  = (Map<String,object>)JSON.deserializeUntyped(resp.getBody());
        if(resp.getBody() != null) {
           intData.AccessToken__c = String.valueOf(respMap.get('access_token'));
            intData.UserId__c = userInfo.getUserId();
            intData.RefreshToken__c = String.valueOf(respMap.get('refresh_token'));
            intData.IntegrationApp__c = 'Box';
        }
       return intData;
     }
    
}