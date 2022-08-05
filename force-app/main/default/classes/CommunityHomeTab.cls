/*************************************************************************************@@
ClassName	: CommunityHomeTab
Author		: Anjali Sharma
CreateDate	: 24/03/2021
Purpose		: To fetch user information and send to CommunityHome component 
*************************************************************************************/
public with sharing class CommunityHomeTab {
    @AuraEnabled
    public static User getUserData() {
        User communityUser = [SELECT Id,Username,FullPhotoUrl,SmallPhotoUrl,Phone,MobilePhone,CompanyName,Email,Name FROM USER WHERE id = :userInfo.getUserId()];
         return  communityUser;
    }
}