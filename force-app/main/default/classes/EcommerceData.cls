/*************************************************************************************@@
ClassName	: EcommerceData
Author		: Anjali Sharma
CreateDate	: 25/05/2021
Purpose		: To fetch data and return to js
Test Suite  : EcommerceDataTest
******************************************************************************************************/

public class EcommerceData {
    //this is the method that retrives the products and its attribute and store them in the wrapper class 
    @AuraEnabled
    public static ProductWrapper getData(String parentProduct) { 
        Map<String,Map<String,AttributeValues>> tempDisplayMap = new Map<String,Map<String,AttributeValues>>();
        ProductWrapper productWrap = new ProductWrapper();
        List<Product2> childProductList = [SELECT id, Parent_Product__r.Name, ProductCode, Name, 
                                           (SELECT Product_Attribute__r.Name, Attribute_Values__c FROM Product_Attribute_Values__r ORDER BY Product_Attribute__r.Name)
                                           FROM Product2 WHERE Parent_Product__r.Id = :parentProduct];

        for(Product2 product : childProductList) {
            productWrap.parentProductName = product.Parent_Product__r.Name;
            for(Product_Attribute_Value__c prodAttVal : product.Product_Attribute_Values__r) {
                AttributeValues attributeVal = new AttributeValues(prodAttVal.Attribute_Values__c, product.Id);
                if(tempDisplayMap.get(prodAttVal.Product_Attribute__r.Name) == null) {
                    tempDisplayMap.put(prodAttVal.Product_Attribute__r.Name,new Map<String,AttributeValues>());
                }
                if(tempDisplayMap.get(prodAttVal.Product_Attribute__r.Name).get(attributeVal.value) != null) {
                    tempDisplayMap.get(prodAttVal.Product_Attribute__r.Name).get(attributeVal.value).combinationName += ',' + product.Id;
                } else {
                    tempDisplayMap.get(prodAttVal.Product_Attribute__r.Name).put(attributeVal.value,attributeVal);
                }
            }
        }
        productWrap.cProductList = childProductList;
        productWrap.displayList = tempDisplayMap;
        return productWrap;
    }

    public class ProductWrapper {
        @AuraEnabled public String parentProductName;
        @AuraEnabled public List<Product2> cProductList;
        @AuraEnabled public Map<String,Map<String,AttributeValues>> displayList;
    }

    public class AttributeValues {
        @AuraEnabled public String value;
        @AuraEnabled public Boolean disable = false;
        @AuraEnabled public Boolean selected = false;
        @AuraEnabled public String variant = 'brand-outline';
        @AuraEnabled public String combinationName;
        
        public AttributeValues(String value, String combinationName) {
            this.value = value;
            this.combinationName = combinationName;
        }
    }
}