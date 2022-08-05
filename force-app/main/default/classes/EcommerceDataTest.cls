/*************************************************************************************@@
Class Name     :  EcommerceDataTest
Purpose        :  Test class for the class EcommerceData
DATE           :  27/05/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
@isTest
private with sharing class EcommerceDataTest {
    @testSetup static void createData() {
        Product2 parentProduct = new Product2(ProductCode='P001',Name='ParentTest');
        insert parentProduct;
        List<Product2> childProductList = new List<Product2>();
        for(integer i=0;i<5;i++) {
            Product2 childProduct = new Product2(Name='ChildTest'+i,ProductCode='C00'+i,Parent_Product__c=parentProduct.Id);
            childProductList.add(childProduct);
        }        
        List<Product_Attribute__c> productAttributeList = new List<Product_Attribute__c>();
        for(Integer i = 0; i<2;i++) {
            Product_Attribute__c ProductAttribute = new Product_Attribute__c(Name = 'TestAttribute'+i);
            productAttributeList.add(ProductAttribute);
        }
        insert childProductList;
        insert productAttributeList;
        childProductList = [SELECT Id FROM Product2 WHERE Parent_Product__c <> ''];
        productAttributeList = [SELECT Name FROM Product_Attribute__c];
        List<Product_Attribute_Value__c> ProductAttributeValueList = new List<Product_Attribute_Value__c>();

        for(Product2 childProduct : childProductList) {
            for(Product_Attribute__c ProductAttribute : productAttributeList) {
                Product_Attribute_Value__c productAttributeValue = new Product_Attribute_Value__c(Product__c = childProduct.Id, Product_Attribute__c = ProductAttribute.Id, Attribute_Values__c = 'Test');
                ProductAttributeValueList.add(ProductAttributeValue);
            }
        }
        insert ProductAttributeValueList;
    }
    @isTest
    private static void dataTest(){
        List<Product2> parentList = [SELECT Id FROM Product2 WHERE Parent_Product__c = ''];
        EcommerceData.ProductWrapper wrap = EcommerceData.getData(parentList[0].id);
        System.assertNotEquals(wrap, null);

    }
    
}