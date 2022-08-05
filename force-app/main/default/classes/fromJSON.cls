//
//

public class fromJSON{
	public String kind;	//drive#fileList
	public String etag;	//"PZa0KUbNFnOu1jLBUQX2qvtr5Fs"
	public String selfLink;	//https://www.googleapis.com/drive/v2/files?q='root'+in+parents
	public boolean incompleteSearch;
	public Items[] items;
	public class Items {
		public String kind;	//drive#file
		public String id;	//1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9
		public String etag;	//"MTYxMjg2MDMwODIwOA"
		public String selfLink;	//https://www.googleapis.com/drive/v2/files/1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9
		public String alternateLink;	//https://drive.google.com/drive/folders/1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9
		public String embedLink;	//https://drive.google.com/embeddedfolderview?id=1j3XmEBt1Q1H3A-FJCPs-BRNvx4r2KCS9
		public String iconLink;	//https://drive-thirdparty.googleusercontent.com/16/type/application/vnd.google-apps.folder
		public String title;	//Test
        public String webContentLink;
        public String downloadUrl;
		public String mimeType;	//application/vnd.google-apps.folder
	}
	
	public static fromJSON parse(String json){
		return (fromJSON) System.JSON.deserialize(json, fromJSON.class);
	}
}