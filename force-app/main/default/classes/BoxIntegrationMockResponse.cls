/*************************************************************************************@@
ClassName	: BoxIntegrationMockResponse
Author		: Anjali Sharma
CreateDate	: 26/03/2021
Purpose		: To return the response of each callout made by to BoxIntegrationTest class
******************************************************************************************************/

public class BoxIntegrationMockResponse implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            //mock response for accessToken callOut
            if(req.getEndpoint().contains('/oauth2/token') && req.getBody().contains('grant_type=authorization_code&code')) {
                String responseJSON = '{"access_token":"pees3c2Kjhmai7lAdzC9qQNnikACWiDO","expires_in":3638,"restricted_to":[],"refresh_token":"v2XILxJ2gbEhtRyBHIDcJcLUhkLfjQ9BYYZeoTu33YUdXswf3mG1YAo331LRFMeh","token_type":"bearer"}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;                
            }
            //mock response for accessToken through refresh token callOut
            else if(req.getEndpoint().contains('/oauth2/token') && req.getBody().contains('grant_type=refresh_token&refresh_token') && !(req.getBody().contains('refresh_token=wrongRefreshToken'))) {
                String responseJSON = '{"access_token":"FY1vXuIsmARJxCfxn0fL8OlWteO9cZDY","expires_in":3868,"restricted_to":[],"refresh_token":"6nP3YX4hQgKP0T54CKwIOQoLlAcMtZOxfGIPbay58Fk43K2UdiCbQbVCA72yIgoD","token_type":"bearer"}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;                
            }            
            //mock response for accessToken through refresh token callOut
            else if(req.getEndpoint().contains('/oauth2/token') && req.getBody().contains('grant_type=refresh_token&refresh_token') && req.getBody().contains('refresh_token=wrongRefreshToken')) {
                String responseJSON = '{"access_token":"FY1vXuIsmARJxCfxn0fL8OlWteO9cZDY","expires_in":3868,"restricted_to":[],"refresh_token":"6nP3YX4hQgKP0T54CKwIOQoLlAcMtZOxfGIPbay58Fk43K2UdiCbQbVCA72yIgoD","token_type":"bearer"}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;                
            }
            //mock response for getting all files and folders data callOut
            else if((req.getEndpoint().contains('/folders/'))&&!(req.getEndpoint().contains('recursive')) && !(req.getHeader('Authorization') == 'Bearer wrongAccessToken')) {
                String responseJson = '{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files","created_at":null,"modified_at":null,"description":"","size":24939753,"path_collection":{"total_count":0,"entries":[]},"created_by":{"type":"user","id":"","name":"","login":""},"modified_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"trashed_at":null,"purged_at":null,"content_created_at":null,"content_modified_at":null,"owned_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"shared_link":null,"folder_upload_email":null,"parent":null,"item_status":"active","item_collection":{"total_count":10,"entries":[{"type":"folder","id":"136037671005","sequence_id":"0","etag":"0","name":"asd"},{"type":"folder","id":"136033920170","sequence_id":"0","etag":"0","name":"Check"},{"type":"folder","id":"136039715687","sequence_id":"0","etag":"0","name":"parent"},{"type":"folder","id":"131110447786","sequence_id":"0","etag":"0","name":"test"},{"type":"folder","id":"131110859057","sequence_id":"0","etag":"0","name":"test1"},{"type":"folder","id":"136071501549","sequence_id":"0","etag":"0","name":"testing"},{"type":"folder","id":"136040734648","sequence_id":"0","etag":"0","name":"Testing123"},{"type":"file","id":"802570035549","file_version":{"type":"file_version","id":"858573635949","sha1":"9415e5b12325e03846c24e08ca1d92f0a9ed5b7c"},"sequence_id":"0","etag":"0","sha1":"9415e5b12325e03846c24e08ca1d92f0a9ed5b7c","name":"7 (1).jpg"},{"type":"file","id":"802546854120","file_version":{"type":"file_version","id":"858546552120","sha1":"b39c089a850dee2a6caa907436b560e158e3d1fa"},"sequence_id":"0","etag":"0","sha1":"b39c089a850dee2a6caa907436b560e158e3d1fa","name":"bm (1).png"},{"type":"file","id":"772908031462","file_version":{"type":"file_version","id":"825048303862","sha1":"43aa9df6b6e41a351ffdfdf17a70e3fc768ce891"},"sequence_id":"1","etag":"1","sha1":"43aa9df6b6e41a351ffdfdf17a70e3fc768ce891","name":"Get Started with Box.pdf"}],"offset":0,"limit":100,"order":[{"by":"type","direction":"ASC"},{"by":"name","direction":"ASC"}]}}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;
            }
            //mock error response for getting all files and folders data callOut
            else if((req.getEndpoint().contains('/folders/'))&&!(req.getEndpoint().contains('recursive')) && (req.getHeader('Authorization') == 'Bearer wrongAccessToken')) {
                String responseJson = '{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files","created_at":null,"modified_at":null,"description":"","size":24939753,"path_collection":{"total_count":0,"entries":[]},"created_by":{"type":"user","id":"","name":"","login":""},"modified_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"trashed_at":null,"purged_at":null,"content_created_at":null,"content_modified_at":null,"owned_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"shared_link":null,"folder_upload_email":null,"parent":null,"item_status":"active","item_collection":{"total_count":10,"entries":[{"type":"folder","id":"136037671005","sequence_id":"0","etag":"0","name":"asd"},{"type":"folder","id":"136033920170","sequence_id":"0","etag":"0","name":"Check"},{"type":"folder","id":"136039715687","sequence_id":"0","etag":"0","name":"parent"},{"type":"folder","id":"131110447786","sequence_id":"0","etag":"0","name":"test"},{"type":"folder","id":"131110859057","sequence_id":"0","etag":"0","name":"test1"},{"type":"folder","id":"136071501549","sequence_id":"0","etag":"0","name":"testing"},{"type":"folder","id":"136040734648","sequence_id":"0","etag":"0","name":"Testing123"},{"type":"file","id":"802570035549","file_version":{"type":"file_version","id":"858573635949","sha1":"9415e5b12325e03846c24e08ca1d92f0a9ed5b7c"},"sequence_id":"0","etag":"0","sha1":"9415e5b12325e03846c24e08ca1d92f0a9ed5b7c","name":"7 (1).jpg"},{"type":"file","id":"802546854120","file_version":{"type":"file_version","id":"858546552120","sha1":"b39c089a850dee2a6caa907436b560e158e3d1fa"},"sequence_id":"0","etag":"0","sha1":"b39c089a850dee2a6caa907436b560e158e3d1fa","name":"bm (1).png"},{"type":"file","id":"772908031462","file_version":{"type":"file_version","id":"825048303862","sha1":"43aa9df6b6e41a351ffdfdf17a70e3fc768ce891"},"sequence_id":"1","etag":"1","sha1":"43aa9df6b6e41a351ffdfdf17a70e3fc768ce891","name":"Get Started with Box.pdf"}],"offset":0,"limit":100,"order":[{"by":"type","direction":"ASC"},{"by":"name","direction":"ASC"}]}}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(401);
                return res;
            }
			            
            //mock response for viewing a file callOut
            else if(req.getEndpoint().contains('fields=shared_link')&& !(req.getHeader('Authorization') == 'Bearer wrongAccessToken')) {
                String responseJSON = '{"type":"file","id":"772908031462","etag":"1","shared_link":{"url":"https:/app.box.com/s/q0pg6rtdq2ifn263e82c1q78lt81flme","download_url":"https:/app.box.com/shared/static/q0pg6rtdq2ifn263e82c1q78lt81flme.pdf","vanity_url":null,"vanity_name":null,"effective_access":"open","effective_permission":"can_download","is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_preview":true,"can_download":true}}}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(200);
                return res;
            }
            
            //mock error response for viewing a file callOut
            else if(req.getEndpoint().contains('fields=shared_link')&& (req.getHeader('Authorization') == 'Bearer wrongAccessToken')) {
                String responseJSON = '{"type":"file","id":"772908031462","etag":"1","shared_link":{"url":"https:/app.box.com/s/q0pg6rtdq2ifn263e82c1q78lt81flme","download_url":"https:/app.box.com/shared/static/q0pg6rtdq2ifn263e82c1q78lt81flme.pdf","vanity_url":null,"vanity_name":null,"effective_access":"open","effective_permission":"can_download","is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_preview":true,"can_download":true}}}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(401);
                return res;
            }
            // mock response for create a new folder callOut
            else if(req.getBody().contains('"parent": {"id":')&&req.getEndpoint().contains('folders') && !(req.getHeader('Authorization') == 'Bearer wrongAccessToken')) {
                String responseJSON = '{"type":"folder","id":"136123375760","sequence_id":"0","etag":"0","name":"TestData","created_at":"2021-04-22T23:08:00-07:00","modified_at":"2021-04-22T23:08:00-07:00","description":"","size":0,"path_collection":{"total_count":1,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"}]},"created_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"modified_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"trashed_at":null,"purged_at":null,"content_created_at":"2021-04-22T23:08:00-07:00","content_modified_at":"2021-04-22T23:08:00-07:00","owned_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"shared_link":null,"folder_upload_email":null,"parent":{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},"item_status":"active","item_collection":{"total_count":0,"entries":[],"offset":0,"limit":100,"order":[{"by":"type","direction":"ASC"},{"by":"name","direction":"ASC"}]}}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody(responseJson);
                res.setStatusCode(201);
                return res;                
            }
            
            // mock error response for create a new folder callOut
            else if(req.getBody().contains('"parent": {"id":')&&req.getEndpoint().contains('folders') && (req.getHeader('Authorization') == 'Bearer wrongAccessToken')) {
                String responseJSON = '{"type":"folder","id":"136123375760","sequence_id":"0","etag":"0","name":"TestData","created_at":"2021-04-22T23:08:00-07:00","modified_at":"2021-04-22T23:08:00-07:00","description":"","size":0,"path_collection":{"total_count":1,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"}]},"created_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"modified_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"trashed_at":null,"purged_at":null,"content_created_at":"2021-04-22T23:08:00-07:00","content_modified_at":"2021-04-22T23:08:00-07:00","owned_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"shared_link":null,"folder_upload_email":null,"parent":{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},"item_status":"active","item_collection":{"total_count":0,"entries":[],"offset":0,"limit":100,"order":[{"by":"type","direction":"ASC"},{"by":"name","direction":"ASC"}]}}';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody(responseJson);
                res.setStatusCode(401);
                return res;                
            }
            
            // mock response for delete data callOut
            else if(req.getMethod()=='DELETE' && !(req.getHeader('Authorization') == 'Bearer wrongAccessToken')) {
                String responseJSON = '';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(204);
                return res;
            }
            
            // mock error response for delete data callOut
            else if(req.getMethod()=='DELETE'&& (req.getHeader('Authorization') == 'Bearer wrongAccessToken')) {
                String responseJSON = '';
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setStatusCode(401);
                return res;
            }
            
            // mock response for uploading a file callOut
            else if(req.getEndpoint().contains('files/content?parent_id=') && !(req.getHeader('Authorization') == 'Bearer wrongAccessToken')) {
                String responseJSON = '{"total_count":1,"entries":[{"type":"file","id":"802939718167","file_version":{"type":"file_version","id":"859002488167","sha1":"af542336022d81f0510c37920fd4461c6f754554"},"sequence_id":"0","etag":"0","sha1":"af542336022d81f0510c37920fd4461c6f754554","name":"test.txt","description":"","size":11,"path_collection":{"total_count":1,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"}]},"created_at":"2021-04-23T00:37:28-07:00","modified_at":"2021-04-23T00:37:28-07:00","trashed_at":null,"purged_at":null,"content_created_at":"2021-04-23T00:37:28-07:00","content_modified_at":"2021-04-23T00:37:28-07:00","created_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"modified_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"owned_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"shared_link":null,"parent":{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},"item_status":"active"}]}';
                HTTPResponse res = new HTTPResponse();
                res.setBody(responseJson);
                res.setStatusCode(201);
                return res;
            }
            
            // mock error response for uploading a file callOut
            else if(req.getEndpoint().contains('files/content?parent_id=') && (req.getHeader('Authorization') == 'Bearer wrongAccessToken')) {
                String responseJSON = '{"total_count":1,"entries":[{"type":"file","id":"802939718167","file_version":{"type":"file_version","id":"859002488167","sha1":"af542336022d81f0510c37920fd4461c6f754554"},"sequence_id":"0","etag":"0","sha1":"af542336022d81f0510c37920fd4461c6f754554","name":"test.txt","description":"","size":11,"path_collection":{"total_count":1,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"}]},"created_at":"2021-04-23T00:37:28-07:00","modified_at":"2021-04-23T00:37:28-07:00","trashed_at":null,"purged_at":null,"content_created_at":"2021-04-23T00:37:28-07:00","content_modified_at":"2021-04-23T00:37:28-07:00","created_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"modified_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"owned_by":{"type":"user","id":"15163312161","name":"Anjali Sharma","login":"anjali@briskminds.com"},"shared_link":null,"parent":{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},"item_status":"active"}]}';
                HTTPResponse res = new HTTPResponse();
                res.setBody(responseJson);
                res.setStatusCode(401);
                return res;
            }
            // mock response for download a file callOut
            else if(req.getEndpoint().contains('content') && req.getMethod() == 'GET' && !(req.getHeader('Authorization') == 'Bearer wrongAccessToken')) {
                String responseJSON = '';                    
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setHeader('Location','https://public.boxcloud.com/d/1/b1!qQ08ryOZEN1Iq7J3diLk6lmOB70p8iBmrJg-e3u_MHlBuFl7m6UQ0XH97JwZLaAW1RTmt9uHH490MVJ8sZgWg5dHkEbMlVIFt1GcMoLVWRncJTWv9_o5EOxOF_8liX_x0-BeCuwJQiuu-hjPAQSrYPCgsdFnDyJtLHFb7Zx8Llus0ncrKWUP9x4S4Mkshflt5sAv1bCH4Bowma47Y9tLMWnYNGkYlKHmfWdfeF1IUDTkmuCuSOX2tqzGWvL5h2xIzWVqK6-cLCakmA_iDdl6JiYAUqqEBNsSPvTaYn5F2ig_PxHhXNucUG_WyIx-owcvIaaelGCuA6Hy8i4joVxEuqLvX7jPc5qF3Q9ZVLnpoN7fIjwnfPhZWX9MYjBu7t9mnNrNdLz5O1i4FbWwiw_LJ2kFwRsrxctaXiCyGXPz1EQu8IvrwV548DJ0-uwzb3jm6iGAj_sA7iNZ-2qlY5OnM3Yea2vHqpDbFPorU44iRIvBxbF30VI-kibd5i4C8AxmNGJeeMswd-OX8HtFF-OSjmFAa1-Ugbel-1o_q9e0hFQBLB6jpjekuh0ycTtnFik1S0lKxZIiNNHN5dod2NhKMJPmhQ1booJePTwFFOaaIJ2t1v4XfS_Z-L4nSK5ShXiKTVjkz0TPLHqb-S0-XTJxz-jtZZvwjX3g40OgT1F-mc9udwDHbiXZ3MLSWiEhiVVskPOYepOjuDobS8-9iTlmEGCDq2KD4dvbI2vi-xH2jRidZkEgFD5EXvGo4CQyiKXTt9_q6C2erX1aoOqCAX8wTviPf8drKSX4ilIzoBWRAQJooefFDTqQtWjos0ILZFEEtKvdrl8AZ75jkSRDZGMAGOIFb-ti_X_qLAi3rEeA8dq8Tsg5hwqCnAV1n89wmHZ7f_IRH_TiEJ475CR42Ef3XWx_ukX03zSSaDgmhMVVFhwfDZmnwNdYm61NC390Dw1nFB4YSROQ5_wXzXCp1bgOCQhM7bF6NbE2mbXHC-hIWzdLlLDiGPaKtaEEroBc7XoDMAi5fHHXUxTO3XTShP3f4pbc2NNz80X6kR03K6B2NmXsd8O01tu21tCt3ISNBjXw58rn1DYoX06luqpMjCrh3xGOkc5KL-I5Wzfx07LF49TvqCdSyFedxdKrzFlb3f9i3VidyCdFTVoqjsr3NT5atL4YsSCARBTytTYnXsuhD9K0yfxTcAjTripT05HItfm8r4Fh8z9GvGFfCrNz5s18Qz28VzZUgizPKh6HsLhMaTLrRMr7nndaDMoCAMEG-2ZoYSu3llOYPPVrlnyeEHaZWJSb33pGFsz2UQgJoYKs9nQSHNNJteodX2HpvwkWrSai/download ');
                res.setStatusCode(302);
                return res;
            }
            // mock error response for download a file callOut
            else if(req.getEndpoint().contains('content') && req.getMethod() == 'GET'&& (req.getHeader('Authorization') == 'Bearer wrongAccessToken')) {
                String responseJSON = '';                    
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'Application/json');
                res.setBody(responseJson);
                res.setHeader('Location','https://public.boxcloud.com/d/1/b1!qQ08ryOZEN1Iq7J3diLk6lmOB70p8iBmrJg-e3u_MHlBuFl7m6UQ0XH97JwZLaAW1RTmt9uHH490MVJ8sZgWg5dHkEbMlVIFt1GcMoLVWRncJTWv9_o5EOxOF_8liX_x0-BeCuwJQiuu-hjPAQSrYPCgsdFnDyJtLHFb7Zx8Llus0ncrKWUP9x4S4Mkshflt5sAv1bCH4Bowma47Y9tLMWnYNGkYlKHmfWdfeF1IUDTkmuCuSOX2tqzGWvL5h2xIzWVqK6-cLCakmA_iDdl6JiYAUqqEBNsSPvTaYn5F2ig_PxHhXNucUG_WyIx-owcvIaaelGCuA6Hy8i4joVxEuqLvX7jPc5qF3Q9ZVLnpoN7fIjwnfPhZWX9MYjBu7t9mnNrNdLz5O1i4FbWwiw_LJ2kFwRsrxctaXiCyGXPz1EQu8IvrwV548DJ0-uwzb3jm6iGAj_sA7iNZ-2qlY5OnM3Yea2vHqpDbFPorU44iRIvBxbF30VI-kibd5i4C8AxmNGJeeMswd-OX8HtFF-OSjmFAa1-Ugbel-1o_q9e0hFQBLB6jpjekuh0ycTtnFik1S0lKxZIiNNHN5dod2NhKMJPmhQ1booJePTwFFOaaIJ2t1v4XfS_Z-L4nSK5ShXiKTVjkz0TPLHqb-S0-XTJxz-jtZZvwjX3g40OgT1F-mc9udwDHbiXZ3MLSWiEhiVVskPOYepOjuDobS8-9iTlmEGCDq2KD4dvbI2vi-xH2jRidZkEgFD5EXvGo4CQyiKXTt9_q6C2erX1aoOqCAX8wTviPf8drKSX4ilIzoBWRAQJooefFDTqQtWjos0ILZFEEtKvdrl8AZ75jkSRDZGMAGOIFb-ti_X_qLAi3rEeA8dq8Tsg5hwqCnAV1n89wmHZ7f_IRH_TiEJ475CR42Ef3XWx_ukX03zSSaDgmhMVVFhwfDZmnwNdYm61NC390Dw1nFB4YSROQ5_wXzXCp1bgOCQhM7bF6NbE2mbXHC-hIWzdLlLDiGPaKtaEEroBc7XoDMAi5fHHXUxTO3XTShP3f4pbc2NNz80X6kR03K6B2NmXsd8O01tu21tCt3ISNBjXw58rn1DYoX06luqpMjCrh3xGOkc5KL-I5Wzfx07LF49TvqCdSyFedxdKrzFlb3f9i3VidyCdFTVoqjsr3NT5atL4YsSCARBTytTYnXsuhD9K0yfxTcAjTripT05HItfm8r4Fh8z9GvGFfCrNz5s18Qz28VzZUgizPKh6HsLhMaTLrRMr7nndaDMoCAMEG-2ZoYSu3llOYPPVrlnyeEHaZWJSb33pGFsz2UQgJoYKs9nQSHNNJteodX2HpvwkWrSai/download ');
                res.setStatusCode(401);
                return res;
            }
            return null;
        }
    
   
}