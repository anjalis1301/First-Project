/*************************************************************************************@@
Class Name     :  BoxIntegrationConstants
Purpose        :  Constants class for BoxIntegration
DATE           :  22/04/2021
Author         :  Anjali Sharma
*********************************************************************************************************/
public class BoxIntegrationConstants {
	public static final String GETFILESANDFOLDERS = 'https://api.box.com/2.0/folders';
    public static final String ACCESSTOKENURL = 'https://api.box.com/oauth2/token';
    public static final String GETFILE= 'https://api.box.com/2.0/files/';
    public static final String UPLOADFILE = 'https://upload.box.com/api/2.0/files/content?parent_id=';
    public static final String AUTHURL = 'https://account.box.com/api/oauth2/authorize?response_type=code&client_id=';
    public static final List<String> HEADERS = new List<String>();
    static {   
        HEADERS.add('Content-Type');
        HEADERS.add('Application/json');
        HEADERS.add('Authorization');
        HEADERS.add('Bearer ');
    }
}