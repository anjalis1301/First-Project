/******************************************************************************************************************************************************************************
ClassName : PaymentGatewayIntegrationService
Author : Anjali Sharma
CreateDate : 26/04/2021
Purpose : To fetch data from Authorize.net and return transaction status
******************************************************************************************************************************************************************************/


public with sharing class PaymentGatewayIntegrationService {
    /*
    *@ description : This method call for get transaction status 
    *@ params : 1. CardNum :- Customers Card Number
                2. ExpireMon:- Cards Expire Month
                3. ExpireYear :- Cards Expire Year
                4. CVV : - Cards Cvv number
                5. Amnt :- Amount to be deducted
                6. APIKey:- Merchants API Key
                7. transKey :- Merchants Trancation key
                8. url :- Endpoint url of api request
    *@ returns : method returns string
    */
    public static String cardPay(String CardNum,Integer ExpireMon, Integer ExpireYear,Integer CVV ,Integer Amnt,String APIKey, String transKey, String url){
        String body = '{"createTransactionRequest": { "merchantAuthentication": {"name": "'+APIkey+'","transactionKey": "'+transKey+'"},"refId": "123456","transactionRequest": {'+
        '"transactionType": "authCaptureTransaction", "amount": "'+Amnt+'","payment": {"creditCard": {"cardNumber": "'+CardNum+'",'+
        '"expirationDate": "'+ExpireYear+'-'+ExpireMon+'","cardCode": "'+CVV+'"}}}}}';

        Http obj = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setBody(body);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        HttpResponse resp = obj.send(req);
        return resp.getBody();
    }

     /*
    *@ description : This method call for get transaction status 
    *@ params : 1. RoutingNum :- Customers unique 9 digit code
                2. AccNum:- Customers Account number
                3. AccName :- Account holders Name
                5. Amnt :- Amount to be deducted
                6. APIKey:- Merchants API Key
                7. transKey :- Merchants Trancation key
                8. url :- Endpoint url of api request
    *@ returns : method returns string
    */
    public static String eCheckPay(Integer RoutingNum,String AccNum, String AccName,Integer Amnt,String APIKey, String transKey, String url){
        String body = '{"createTransactionRequest": {"merchantAuthentication": {"name": "'+APIKey+'","transactionKey": "'+transKey+'"},"refId": "123456",'
        +'"transactionRequest": {"transactionType": "authCaptureTransaction","amount":"'+Amnt
            +'","payment": {"bankAccount": {"accountType": "checking",'
            +'"routingNumber": "'+RoutingNum+'","accountNumber": "'+AccNum+'","nameOnAccount": "'+AccName+'"}},'
            +'}}}';
            Http obj = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setBody(body);
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('POST');
            HttpResponse resp = obj.send(req);
            return resp.getBody();
    }
}