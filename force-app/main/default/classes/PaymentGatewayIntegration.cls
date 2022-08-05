/******************************************************************************************************************************************************************************
ClassName : PaymentGatewayIntegration
Author : Anjali Sharma
CreateDate : 26/04/2021
Purpose : To fetch data from PaymentGatewayIntegrationService and return transaction status
Test Suite : PaymentGatewayIntegrationTest
******************************************************************************************************************************************************************************/

public with sharing class PaymentGatewayIntegration
{
    private static List<CommunityPaymentGatewayMeta__mdt> gatewayMeta = [Select Api__c, TransactionKey__c , EndPointUrl__c from CommunityPaymentGatewayMeta__mdt where Label = 'AuthorizePaymentGateway' Limit 1];

    //method to check card details
    @AuraEnabled
    public static String cardPayment(String CardNum,Integer ExpireMon, Integer ExpireYear,Integer CVV ,Integer Amnt){
        String APIKey = gatewayMeta[0].Api__c;
        String transKey = gatewayMeta[0].TransactionKey__c;
        String url = gatewayMeta[0].EndPointUrl__c;
        String resp = PaymentGatewayIntegrationService.cardPay(CardNum, ExpireMon, ExpireYear, CVV, Amnt, APIKey, transKey, url); 
        return resp;
    }

        //method to check eCheck details
        @AuraEnabled
        public static String eCheckPayment(Integer RoutingNumber,String AccNum, String AccName,Integer Amnt){
            String APIKey = gatewayMeta[0].Api__c;
            String transKey = gatewayMeta[0].TransactionKey__c;
            String url = gatewayMeta[0].EndPointUrl__c;
            String resp = PaymentGatewayIntegrationService.eCheckPay(RoutingNumber, AccNum, AccName, Amnt, APIKey, transKey, url);
            return resp ;
        }

}