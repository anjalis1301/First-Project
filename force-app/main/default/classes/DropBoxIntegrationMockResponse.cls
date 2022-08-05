/*************************************************************************************@@
ClassName	: DropBoxIntegrationMockResponse
Author		: Anjali Sharma
CreateDate	: 26/03/2021
Purpose		: To return the response of each callout made by to DropBoxIntegrationTest class
******************************************************************************************************/

public class DropBoxIntegrationMockResponse implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            //mock response for accessToken callOut
            if(req.getEndpoint().contains('code=')) {
                String responseJson = '{"access_token": "KF-Ypm1Sna4AAAAAAAAAAfXyMrISCWD-97nbTwT80tssJxwXfoBjcu_fu08LcV1g", "token_type": "bearer", "uid": "4005266064", "account_id": "dbid:AADqClDrzqJ-DFOO1W2biadoxjuhjFsvmlw", "scope": "account_info.read account_info.write file_requests.read file_requests.write files.content.read files.content.write files.metadata.read files.metadata.write sharing.read sharing.write"}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;
            }
            //mock response for getting all files and folders data callOut
            else if(req.getEndpoint().contains('list_folder')) {
                String responseJSON = ' {"entries": [{".tag": "folder", "name": "try", "path_lower": "/try", "path_display": "/try", "id": "id:Afwta0crtesAAAAAAAAACQ"}, {".tag": "file", "name": "Get Started with Dropbox Paper.url", "path_lower": "/get started with dropbox paper.url", "path_display": "/Get Started with Dropbox Paper.url", "id": "id:Afwta0crtesAAAAAAAAABg", "client_modified": "2021-03-25T23:59:58Z", "server_modified": "2021-03-25T23:59:59Z", "rev": "015be653683b368000000022cee9530", "size": 240, "is_downloadable": true, "content_hash": "f40c1228343d7e2a632281c986dbb7af3491b9b63ddfd0eb10fee2c913f6cfa7"}, {".tag": "file", "name": "Get Started with Dropbox.pdf", "path_lower": "/get started with dropbox.pdf", "path_display": "/Get Started with Dropbox.pdf", "id": "id:Afwta0crtesAAAAAAAAABw", "client_modified": "2021-03-25T23:59:58Z", "server_modified": "2021-03-25T23:59:59Z", "rev": "015be653683b369000000022cee9530", "size": 1102331, "is_downloadable": true, "content_hash": "f7ad488deb7d81790340ecd676fe6e47f0a6064fb99b982685b752d58611c1cb"}, {".tag": "file", "name": "download.png", "path_lower": "/download.png", "path_display": "/download.png", "id": "id:Afwta0crtesAAAAAAAAACA", "client_modified": "2021-03-29T11:14:16Z", "server_modified": "2021-03-29T11:14:16Z", "rev": "015beaafb832d0a000000022cee9530", "size": 4590, "is_downloadable": true, "content_hash": "64f361f38d5637099eda75b2548cd753ce72c51ba5a3969716bdd8ccfb5aa0db"}, {".tag": "file", "name": "c2.csv", "path_lower": "/c2.csv", "path_display": "/c2.csv", "id": "id:Afwta0crtesAAAAAAAAAHA", "client_modified": "2021-04-02T07:39:31Z", "server_modified": "2021-04-02T07:39:32Z", "rev": "015bef872e16835000000022cee9530", "size": 178, "is_downloadable": true, "content_hash": "ecbd574d9c5d04ebf7379e74273b821068c356a21d4a53a73c718d12da465d56"}, {".tag": "file", "name": "Matrix.java", "path_lower": "/matrix.java", "path_display": "/Matrix.java", "id": "id:Afwta0crtesAAAAAAAAAHQ", "client_modified": "2021-04-02T11:05:57Z", "server_modified": "2021-04-02T11:05:58Z", "rev": "015befb552689db000000022cee9530", "size": 962, "is_downloadable": true, "content_hash": "3057cc1b17c41ef50e11f7a8a639f93fd259159376f3bdbdea8a7e4f6a2ceed9"}], "cursor": "AAF9C6vWZN9t5ajJSIuPz7AY8bOFVzzN_trykJdGzOFrPdoHTXhY8YJIHGM8QfqyZXpe_2q1RZLqD5q9saOKRRm7YhxI6TLzwcdmrpQswcY26eIXz6v-llI4o9dq1b_8-4icDAFkyUB4rs-hFBzi-GG8ZqvZfk-kCMMiFDjb-EvAX80vdpKHw0hKeIbK-N5HveI", "has_more": false}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;
            }
            // mock response for viewing a file callOut
            else if(req.getEndpoint().contains('create_shared_link')) {
                String responseJSON = '{"url": "https://www.dropbox.com/s/madqvxgnynuvacs/download.png?dl=0", "visibility": {".tag": "public"}, "path": "/download.png"}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;                
            }
            //mock response for create a new folder callOut
            else if(req.getEndpoint().contains('create_folder')) {
                String responseJSON = '{"name": "TestData", "path_lower": "/testdata", "path_display": "/TestData", "id": "id:Afwta0crtesAAAAAAAAAKA"}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;
            }
            // mock response for delete data callOut
            else if(req.getEndpoint().contains('delete_v2')) {
                String responseJSON = '{"metadata": {".tag": "folder", "name": "TestData", "path_lower": "/testdata", "path_display": "/TestData", "id": "id:Afwta0crtesAAAAAAAAAKA"}}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;
            }
            // mock response for download a file callOut
            else if(req.getEndpoint().contains('get_temporary_link')) {
                String responseJSON = '{"metadata": {"name": "download.png", "path_lower": "/download.png", "path_display": "/download.png", "id": "id:Afwta0crtesAAAAAAAAACA", "client_modified": "2021-03-29T11:14:16Z", "server_modified": "2021-03-29T11:14:16Z", "rev": "015beaafb832d0a000000022cee9530", "size": 4590, "is_downloadable": true, "content_hash": "64f361f38d5637099eda75b2548cd753ce72c51ba5a3969716bdd8ccfb5aa0db"}, "link": "https://content.dropboxapi.com/apitl/1/AuP5YIQ9mfO6V-fHhIDj5owJXuAZX0UPZEKkNOBIGS4r4ughcp26sVtOEp2jH5sIMlXtRkqa1pSXPhmniB2d6ZNv9r4jJ4y_V2-DPfCGFNnNV-djzG4pecwtrsKLK2wTFKx0paQ1_8l-lBaiOPq6Wx7qMz3DBDRgRxaQHs3sP7jIf8qdJFAjqCP6s4m60zU_joLocvqjkpKSkjMy90K4VF0htQayJC2NUnVhIDYKne_6Pmn2aqSqQomNZhlEj_P7OhnvXxjtJtMYRRsJhXcLo_0UbD8DIH_QNjSoseQYpW6xC-GxrzP2-AoYd0_tbbAVmtUFtU3MsGP9xURzXlmPBWPx"}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;
            } 
            // mock response for uploading a file callOut
            else if(req.getEndpoint().contains('upload')) {
                String responseJSON = '{"name": "chullu bhr pani.jpg", "path_lower": "/chullu bhr pani.jpg", "path_display": "/chullu bhr pani.jpg", "id": "id:Afwta0crtesAAAAAAAAAKg", "client_modified": "2021-04-06T01:37:40Z", "server_modified": "2021-04-06T01:37:40Z", "rev": "015bf43dc20fe50000000022cee9530", "size": 5394, "is_downloadable": true, "content_hash": "27fa0f2dbd82920d15813dd2581b53c7e7849bab436ea261e6bc915f447ddadc"}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;
            }
            return null;
        }
    
   
}