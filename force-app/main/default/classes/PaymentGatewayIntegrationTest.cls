/*************************************************************************************@@
Class Name     :  PaymentGatewayIntegrationTest
Purpose        :  Test class for the class PaymentGatewayIntegration
DATE           :  28/04/2021
Author         :  Anjali Sharma
*********************************************************************************************************/

@isTest
private class PaymentGatewayIntegrationTest {

    //test method to check card transaction status
    @isTest 
    public static void cardPaymentTest (){
        String CardNumber='12564';
        Integer ExpireMonth=05;
        Integer ExpireYear=2034;
        Integer CVVNumber=255;
        Integer Amount=2500;
        Test.setMock(HttpCalloutMock.class, new PaymentGatewayIntegrationMock());
        String result = PaymentGatewayIntegration.cardPayment(CardNumber,ExpireMonth,ExpireYear,CVVNumber,Amount);
        System.assertNotEquals(null, result);
    }

    // test method to check echeck transaction status
    @isTest 
    public static void eCheckPaymentTest(){
        Integer RoutingNumber=125452;
        String AccountNumber='12355';
        String AccountName='457454';
        Integer Amount=2500;
        Test.setMock(HttpCalloutMock.class, new PaymentGatewayIntegrationMock());
        String result = PaymentGatewayIntegration.eCheckPayment(RoutingNumber,AccountNumber,AccountName,Amount);
        System.assertNotEquals(null,result);
    }
}