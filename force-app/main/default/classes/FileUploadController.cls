/*************************************************************************************@@
ClassName	: FileUploadController
Author		: Anjali Sharma
CreateDate	: 22/01/2021
Purpose		: To insert attachments comming from vfpage to a specific Account record 
*************************************************************************************/

global with sharing class FileUploadController {
    public FileUploadController(ApexPages.StandardController ctlr) {   
    }
     /**
    *   @method attachBlob
    *   Remote method to insert attachments
    *   parentId: The sfdc object Id this file will be attached to
    *	objec: javascript object converted as string     
    */
    @RemoteAction
    global static String attachBlob(String parentId, String file){
        id aId;
      		Map<String,String> ob = (Map<String,String>)JSON.deserialize(file, Map<String,String>.class);
        	for(String s : ob.keySet()){
                Attachment att = new Attachment(
                    ParentId = parentId,
                    Name = s,
                    Body = EncodingUtil.Base64Decode(ob.get(s))
                );
                try{
          			insert att;
                }
                catch(Exception e){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Cannot Upload File Because '+e.getMessage()));
                }
                
       			aId = att.Id;
            }
        return aId;
    }
}