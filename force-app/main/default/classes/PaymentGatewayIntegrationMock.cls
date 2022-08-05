/*************************************************************************************@@
Class Name     :  PaymentGatewayIntegrationMock
Purpose		   :  To return the response of each callout made by to PaymentGatewayIntegrationTest class
DATE           :  28/04/2021
Author         :  Anjali Sharma
*********************************************************************************************************/

@isTest
public class PaymentGatewayIntegrationMock implements HttpCalloutMock{

    public HTTPResponse respond(HTTPRequest req) {
        //mock response for card request
        if(req.getBody().contains('CardNumber')){
            String resp = '{"transactionResponse":{"responseCode":"3","authCode":"","avsResultCode":"P","cvvResultCode":"","cavvResultCode":"","transId":"0","refTransID":"","transHash":"","testRequest":"0","accountNumber":"XXXX2564","accountType":"","errors":[{"errorCode":"6","errorText":"The credit card number is invalid."}],"userFields":[{"name":"MerchantDefinedFieldName1","value":"MerchantDefinedFieldValue1"},{"name":"favorite_color","value":"blue"}],"transHashSha2":"","SupplementalDataQualificationIndicator":3},"refId":"123456","messages":{"resultCode":"Error","message":[{"code":"E00027","text":"The transaction was unsuccessful."}]}}';
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody(resp);
            return res;
        } else { ////mock response for echeck request
            String resp = '{"responseCode":"3","authCode":"","avsResultCode":"P","cvvResultCode":"","cavvResultCode":"","transId":"0","refTransID":"","transHash":"","testRequest":"0","accountNumber":"XXXX4789","accountType":"eCheck","errors":[{"errorCode":"9","errorText":"The ABA code is invalid"}],"transHashSha2":"","SupplementalDataQualificationIndicator":3},"refId":"123456","messages":{"resultCode":"Error","message":[{"code":"E00027","text":"The transaction was unsuccessful."}]}';
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody(resp);
            return res;
        }
    }
}