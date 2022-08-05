/*************************************************************************************@@
Class Name     :  DropBoxIntegrationConstants
Purpose        :  Test class for DropBoxIntegrationConstants
DATE           :  05/04/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
public class DropBoxIntegrationConstants {
	public static final String LISTFOLDERS = 'https://api.dropboxapi.com/2/files/list_folder';
    public static final String CREATESHAREDLINK = 'https://api.dropboxapi.com/2/sharing/create_shared_link';
    public static final String CREATEFOLDER = 'https://api.dropboxapi.com/2/files/create_folder';
    public static final String DELETEV2 = 'https://api.dropboxapi.com/2/files/delete_v2';
    public static final String TEMPLINK = 'https://api.dropboxapi.com/2/files/get_temporary_link';
    public static final String UPLOADFILES = 'https://content.dropboxapi.com/2/files/upload';
    public static final List<String> HEADERS = new List<String>();
    static {   
        HEADERS.add('Content-Type');
        HEADERS.add('Application/json');
        HEADERS.add('Authorization');
        HEADERS.add('Bearer ');
    }
}