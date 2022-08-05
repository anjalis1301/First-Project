/*************************************************************************************@@
Class Name     :  GoogleDrive_Test
Purpose        :  Test class for GoogleDriveController
DATE           :  14/02/2021
Author         :  Anjali Sharma
*********************************************************************************************************/


@isTest
private class GoogleDrive_Test {
    /*@TestSetup
    static void makeData() {
        GoogleDrive__c gCS = new GoogleDrive__c();
        gCS.Refresh_Token__c = '1//0ekh5KMx_HOiFCgYIARAAGA4SNwF-L9IrI99TFSmqeazL4oP0cSl-cUukuuIPDaQYL3DWOPk1rVA7kBWe0ikUqX7puX0aLzRCuV8';
        gCS.Access_Token__c = 'ya29.A0AfH6SMAzNdWxS8-f8MI6WgI6ElrcGo9FJn4KwJkH96xB0g0Tcrxba1TGrp-6HjpLHPKVzydlE2DPG7of4O8aLgitQuhlk1mIYapiS_sJL_Nu8JfCQiECIoCq5qjfWvkfnR2QGBGciX09LeCKclkkwHde8Slyug';
        gCS.Expire_In__c = dateTime.valueOf('2021-01-03 04:55:23');
        insert gCS;
    }*/
    /**
    *   @innerClass 
    *   Mock Class for getting response of callout request from test class
    *   contains mock response of all HTTPrequest 
    */
    private class RestMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            if(req.getEndpoint().contains('token')) {
                String responseJson = '{"access_token":"ya.24.ui-yhuui-8967-90ik-993-58iik","refresh_token":"234tgyuuji45666","expires_in":"2563"}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'text/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;
            } else if(req.getEndpoint().contains('q=')) {
                String responseJSON = '{"kind": "drive#fileList","etag": "-9dbh1yIrFeteDencMNsWAKNVTg","selfLink": "https://www.googleapis.com/drive/v2/files?q=\'root\'+in+parents+and+trashed+%3D+false","incompleteSearch": false,"items": [{"kind": "drive#file","id": "1K91OGukCBm_8R3L25S9hWdiU3UXFhLAY","etag": "-MTYxMzM0OTkxNDgyMA","selfLink": "https://www.googleapis.com/drive/v2/files/1K91OGukCBm_8R3L25S9hWdiU3UXFhLAY","alternateLink": "https://drive.google.com/drive/folders/1K91OGukCBm_8R3L25S9hWdiU3UXFhLAY","embedLink": "https://drive.google.com/embeddedfolderview?id=1K91OGukCBm_8R3L25S9hWdiU3UXFhLAY","iconLink": "https://drive-thirdparty.googleusercontent.com/16/type/application/vnd.google-apps.folder","title": "hii","mimeType": "application/vnd.google-apps.folder","labels": {"starred": false,"hidden": false,"trashed": false,"restricted": false,"viewed": true},"copyRequiresWriterPermission": false,"createdDate": "2021-02-15T00:45:14.820Z","modifiedDate": "2021-02-15T00:45:14.820Z","modifiedByMeDate": "2021-02-15T00:45:14.820Z","lastViewedByMeDate": "2021-02-15T11:49:20.561Z","markedViewedByMeDate": "1970-01-01T00:00:00.000Z","version": "4","parents": [{"kind": "drive#parentReference","id": "0ACyMyHaHVdGbUk9PVA","selfLink": "https://www.googleapis.com/drive/v2/files/1K91OGukCBm_8R3L25S9hWdiU3UXFhLAY/parents/0ACyMyHaHVdGbUk9PVA","parentLink": "https://www.googleapis.com/drive/v2/files/0ACyMyHaHVdGbUk9PVA","isRoot": true}],"userPermission": {"kind": "drive#permission","etag": "-5Js5tIPYT8z8wIJfsfpURER8vZ0","id": "me","selfLink": "https://www.googleapis.com/drive/v2/files/1K91OGukCBm_8R3L25S9hWdiU3UXFhLAY/permissions/me","role": "owner","type": "user"},"quotaBytesUsed": "0","ownerNames": ["Anjali Sharma"],"owners": [{"kind": "drive#user","displayName": "Anjali Sharma","isAuthenticatedUser": true,"permissionId": "03598245135158450573","emailAddress": "anjali@briskminds.com"}],"lastModifyingUserName": "Anjali Sharma","lastModifyingUser": {"kind": "drive#user","displayName": "Anjali Sharma","isAuthenticatedUser": true,"permissionId": "03598245135158450573","emailAddress": "anjali@briskminds.com"},"capabilities": {"canCopy": false,"canEdit": true},"editable": true,"copyable": false,"writersCanShare": true,"shared": false,"explicitlyTrashed": false,"appDataContents": false,"spaces": ["drive"]},{"kind": "drive#file","id": "1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9","etag": "-MTYxMjg2MDMwODIwOA","selfLink": "https://www.googleapis.com/drive/v2/files/1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9","alternateLink": "https://drive.google.com/drive/folders/1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9","embedLink": "https://drive.google.com/embeddedfolderview?id=1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9","iconLink": "https://drive-thirdparty.googleusercontent.com/16/type/application/vnd.google-apps.folder","title": "Test","mimeType": "application/vnd.google-apps.folder","labels": {"starred": false,"hidden": false,"trashed": false,"restricted": false,"viewed": true},"copyRequiresWriterPermission": false,"createdDate": "2021-02-09T08:45:08.208Z","modifiedDate": "2021-02-09T08:45:08.208Z","modifiedByMeDate": "2021-02-09T08:45:08.208Z","lastViewedByMeDate": "2021-02-15T06:20:30.723Z","markedViewedByMeDate": "1970-01-01T00:00:00.000Z","version": "25","parents": [{"kind": "drive#parentReference","id": "0ACyMyHaHVdGbUk9PVA","selfLink": "https://www.googleapis.com/drive/v2/files/1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9/parents/0ACyMyHaHVdGbUk9PVA","parentLink": "https://www.googleapis.com/drive/v2/files/0ACyMyHaHVdGbUk9PVA","isRoot": true}],"userPermission": {"kind": "drive#permission","etag": "-4_invnrsNy6JK_dd-CRVoF7AJzI","id": "me","selfLink": "https://www.googleapis.com/drive/v2/files/1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9/permissions/me","role": "owner","type": "user"},"quotaBytesUsed": "0","ownerNames": ["Anjali Sharma"],"owners": [{"kind": "drive#user","displayName": "Anjali Sharma","isAuthenticatedUser": true,"permissionId": "03598245135158450573","emailAddress": "anjali@briskminds.com"}],"lastModifyingUserName": "Anjali Sharma","lastModifyingUser": {"kind": "drive#user","displayName": "Anjali Sharma","isAuthenticatedUser": true,"permissionId": "03598245135158450573","emailAddress": "anjali@briskminds.com"},"capabilities": {"canCopy": false,"canEdit": true},"editable": true,"copyable": false,"writersCanShare": true,"shared": false,"explicitlyTrashed": false,"appDataContents": false,"spaces": ["drive"]},{"kind": "drive#file","id": "1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs","etag": "-MTYxMjE2NTU2NDM0OA","selfLink": "https://www.googleapis.com/drive/v2/files/1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs","alternateLink": "https://docs.google.com/spreadsheets/d/1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs/edit?usp=drivesdk","embedLink": "https://docs.google.com/spreadsheets/d/1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs/htmlembed?ouid=115145367759312173872","iconLink": "https://drive-thirdparty.googleusercontent.com/16/type/application/vnd.google-apps.spreadsheet","thumbnailLink": "https://docs.google.com/feeds/vt?gd=true&id=1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs&v=58&s=AMedNnoAAAAAYCp9vonJTWBWw-CC30O6o8opMycK7te3&sz=s220","title": "Assignment Test Sheet","mimeType": "application/vnd.google-apps.spreadsheet","labels": {"starred": false,"hidden": false,"trashed": false,"restricted": false,"viewed": true},"copyRequiresWriterPermission": false,"createdDate": "2021-01-11T04:24:45.786Z","modifiedDate": "2021-02-01T07:46:04.348Z","modifiedByMeDate": "2021-02-01T07:46:04.348Z","lastViewedByMeDate": "2021-02-15T06:31:43.251Z","markedViewedByMeDate": "1970-01-01T00:00:00.000Z","version": "92","parents": [{"kind": "drive#parentReference","id": "0ACyMyHaHVdGbUk9PVA","selfLink": "https://www.googleapis.com/drive/v2/files/1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs/parents/0ACyMyHaHVdGbUk9PVA","parentLink": "https://www.googleapis.com/drive/v2/files/0ACyMyHaHVdGbUk9PVA","isRoot": true}],"exportLinks": {"application/x-vnd.oasis.opendocument.spreadsheet": "https://docs.google.com/spreadsheets/export?id=1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs&exportFormat=ods","text/tab-separated-values": "https://docs.google.com/spreadsheets/export?id=1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs&exportFormat=tsv","application/pdf": "https://docs.google.com/spreadsheets/export?id=1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs&exportFormat=pdf","application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": "https://docs.google.com/spreadsheets/export?id=1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs&exportFormat=xlsx","text/csv": "https://docs.google.com/spreadsheets/export?id=1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs&exportFormat=csv","application/zip": "https://docs.google.com/spreadsheets/export?id=1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs&exportFormat=zip","application/vnd.oasis.opendocument.spreadsheet": "https://docs.google.com/spreadsheets/export?id=1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs&exportFormat=ods"},"userPermission": {"kind": "drive#permission","etag": "-Mniy7Waho7M5-9tKHpBd4y2GCpI","id": "me","selfLink": "https://www.googleapis.com/drive/v2/files/1S5RRTCN2webVzC400fFIibCndSWVyoCPep0zFI9ltqs/permissions/me","role": "owner","type": "user"},"quotaBytesUsed": "0","ownerNames": ["Anjali Sharma"],"owners": [{"kind": "drive#user","displayName": "Anjali Sharma","isAuthenticatedUser": true,"permissionId": "03598245135158450573","emailAddress": "anjali@briskminds.com"}],"lastModifyingUserName": "Anjali Sharma","lastModifyingUser": {"kind": "drive#user","displayName": "Anjali Sharma","isAuthenticatedUser": true,"permissionId": "03598245135158450573","emailAddress": "anjali@briskminds.com"},"capabilities": {"canCopy": true,"canEdit": true},"editable": true,"copyable": true,"writersCanShare": true,"shared": true,"explicitlyTrashed": false,"appDataContents": false,"spaces": ["drive"]}]}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'text/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;
            } else if(req.getMethod()=='DELETE') {
                String responseJSON ='';
                HttpResponse res = new HttpResponse();
                res.setBody(responseJSON);
                res.setStatusCode(200);
                return res;
            } else if(req.getMethod()=='POST' && req.getEndpoint()=='https://www.googleapis.com/drive/v2/files') {
                String responseJSON = '{"kind": "drive#file","id": "1bITJm6IqndoDVbRoQ2YZdNDgTBwGXGxr","etag": "MTYxMzQ1NzA1NTcwNA","selfLink": "https://www.googleapis.com/drive/v2/files/1bITJm6IqndoDVbRoQ2YZdNDgTBwGXGxr","alternateLink": "https://drive.google.com/drive/folders/1bITJm6IqndoDVbRoQ2YZdNDgTBwGXGxr","embedLink": "https://drive.google.com/embeddedfolderview?id=1bITJm6IqndoDVbRoQ2YZdNDgTBwGXGxr","iconLink": "https://drive-thirdparty.googleusercontent.com/16/type/application/vnd.google-apps.folder+48","title": "folderCheck","mimeType": "application/vnd.google-apps.folder","labels": {"starred": false,"hidden": false,"trashed": false,"restricted": false,"viewed": true},"copyRequiresWriterPermission": false,"createdDate": "2021-02-16T06:30:55.704Z","modifiedDate": "2021-02-16T06:30:55.704Z","modifiedByMeDate": "2021-02-16T06:30:55.704Z","lastViewedByMeDate": "2021-02-16T06:30:55.704Z","markedViewedByMeDate": "1970-01-01T00:00:00.000Z","version": "1","parents": ["kind": "drive#parentReference","id": "1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9","selfLink": "https://www.googleapis.com/drive/v2/files/1bITJm6IqndoDVbRoQ2YZdNDgTBwGXGxr/parents/1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9","parentLink": "https://www.googleapis.com/drive/v2/files/1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9","isRoot": false}],"userPermission": {"kind": "drive#permission","etag": "LkBC0ax8z5pDmeASMY7TAMrpsPs","id": "me","selfLink": "https://www.googleapis.com/drive/v2/files/1bITJm6IqndoDVbRoQ2YZdNDgTBwGXGxr/permissions/me","role": "owner","type": "user"},"quotaBytesUsed": "0","ownerNames": ["Anjali Sharma"],"owners": [{"kind": "drive#user","displayName": "Anjali Sharma","isAuthenticatedUser": true,"permissionId": "03598245135158450573","emailAddress": "anjali@briskminds.com"}],"lastModifyingUserName": "Anjali Sharma","lastModifyingUser": {"kind": "drive#user","displayName": "Anjali Sharma","isAuthenticatedUser": true,"permissionId": "03598245135158450573","emailAddress": "anjali@briskminds.com"},"capabilities": {"canCopy": false,"canEdit": true},"editable": true,"copyable": false,"writersCanShare": true,"shared": false,"explicitlyTrashed": false,"appDataContents": false,"spaces": ["drive"]}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'text/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;
            } else if(req.getEndpoint().contains('upload')) {
                String responseJSON = '{"kind": "drive#file","id": "1b3TJRwhSMF8cbHJ9Uz2Wk5ZBA9uCOzuI","etag": "MTYxMzQ1ODMxMTg3OQ","selfLink": "https://www.googleapis.com/drive/v2/files/1b3TJRwhSMF8cbHJ9Uz2Wk5ZBA9uCOzuI","webContentLink": "https://drive.google.com/uc?id=1b3TJRwhSMF8cbHJ9Uz2Wk5ZBA9uCOzuI&export=download","alternateLink": "https://drive.google.com/file/d/1b3TJRwhSMF8cbHJ9Uz2Wk5ZBA9uCOzuI/view?usp=drivesdk","embedLink": "https://drive.google.com/file/d/1b3TJRwhSMF8cbHJ9Uz2Wk5ZBA9uCOzuI/preview?usp=drivesdk","iconLink": "https://drive-thirdparty.googleusercontent.com/16/type/text/plain","title": "dummy.txt","mimeType": "text/plain","labels": {"starred": false,"hidden": false,"trashed": false,"restricted": false,"viewed": true},"copyRequiresWriterPermission": false,"createdDate": "2021-02-16T06:51:51.879Z","modifiedDate": "2021-02-16T06:51:51.879Z","modifiedByMeDate": "2021-02-16T06:51:51.879Z","lastViewedByMeDate": "2021-02-16T06:51:51.879Z","markedViewedByMeDate": "1970-01-01T00:00:00.000Z","version": "1","parents": [{"kind": "drive#parentReference","id": "0ACyMyHaHVdGbUk9PVA","selfLink": "https://www.googleapis.com/drive/v2/files/1b3TJRwhSMF8cbHJ9Uz2Wk5ZBA9uCOzuI/parents/0ACyMyHaHVdGbUk9PVA","parentLink": "https://www.googleapis.com/drive/v2/files/0ACyMyHaHVdGbUk9PVA","isRoot": true}],"downloadUrl": "https://www.googleapis.com/drive/v2/files/1b3TJRwhSMF8cbHJ9Uz2Wk5ZBA9uCOzuI?alt=media&source=downloadUrl","userPermission": {"kind": "drive#permission","etag": "FJVpPIcJR8-uU9fliDrhq1yyT8s","id": "me","selfLink": "https://www.googleapis.com/drive/v2/files/1b3TJRwhSMF8cbHJ9Uz2Wk5ZBA9uCOzuI/permissions/me","role": "owner","type": "user"},"originalFilename": "dummy.txt","fileExtension": "txt","md5Checksum": "eb5ca61d6f9dd5ad8c52002ffedeafd5","fileSize": "51","quotaBytesUsed": "51","ownerNames": ["Anjali Sharma"],"owners": [{"kind": "drive#user","displayName": "Anjali Sharma","isAuthenticatedUser": true,"permissionId": "03598245135158450573","emailAddress": "anjali@briskminds.com"}],"lastModifyingUserName": "Anjali Sharma","lastModifyingUser": {"kind": "drive#user","displayName": "Anjali Sharma","isAuthenticatedUser": true,"permissionId": "03598245135158450573","emailAddress": "anjali@briskminds.com"},"capabilities": {"canCopy": true,"canEdit": true},"editable": true,"copyable": true,"writersCanShare": true,"shared": false,"explicitlyTrashed": false,"appDataContents": false,"headRevisionId": "0ByyMyHaHVdGbZ1d2UHBKc1U2WEdQeGJ0bm5yVVhoNytqcjRBPQ","spaces": ["drive"]}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'text/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;
            }
            return null;
        }
    }
   
    /**
    *   @method testAuth
    *   method to test authorization and get the access token
    */
    @isTest static void testAuth() {
       // GoogleDrive__c refresh = [SELECT id,Refresh_Token__c,Access_Token__c FROM GoogleDrive__c Limit 1];
        
        Test.setMock(HttpCalloutMock.class, new RestMock());
        GoogleDriveController gDC = new GoogleDriveController();
        gDC.accessThroughCode= true;
        gDC.accessToken='';
        gDC.DriveAuth();
        apexPages.currentPage().getParameters().put('code','4567yhhui9866');
        gDC.DriveAuth();
       /* gDC.accessThroughCode = false;
        gDC.DriveAuth();*/
        Test.startTest();
       GoogleDrive__c driveToken = [SELECT id, Access_token__c,Refresh_Token__c,Expire_In__c FROM GoogleDrive__c];
		driveToken.Expire_In__c = DateTime.now().addSeconds(-4000);
        update driveToken; 
        Test.stopTest();
        gDc.accessThroughCode=false;
        gDc.refreshFlag=false;
        gDC.DriveAuth();
    }
    
    @isTest static void testDelete() {
        //GoogleDrive__c refresh = [SELECT id,Refresh_Token__c,Access_Token__c FROM GoogleDrive__c Limit 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestMock());
        GoogleDriveController gDC = new GoogleDriveController();
        gDC.delSelectId = '45233652145';
        gDC.deleteData();
        Test.stopTest();
    }
    
    @isTest static void testCreate() {
    //   GoogleDrive__c refresh = [SELECT id,Refresh_Token__c,Access_Token__c FROM GoogleDrive__c Limit 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestMock());
        GoogleDriveController gDC = new GoogleDriveController();
        gDC.newFolderName='folderCheck';
        gDC.selectId = '1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9';
        gDC.createFolder( );
        Test.stopTest();
    }
    
    @isTest static void testUpload() {
      //  GoogleDrive__c refresh = [SELECT id,Refresh_Token__c,Access_Token__c FROM GoogleDrive__c Limit 1];
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new RestMock());
        GoogleDriveController gDC = new GoogleDriveController();
        gDC.displayUpload();
        gDC.file = Blob.valueOf('Hello All this is just a dummy file to check code\n');
        gDC.filetype = 'text/plain';
        gDC.uFileSize = 5000;
        gDC.upload();
        Test.stopTest();
    }  
    
}