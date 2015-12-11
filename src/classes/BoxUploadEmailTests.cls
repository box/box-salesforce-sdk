@IsTest
public class BoxUploadEmailTests {
   public static testmethod void testParseAccess() {
    System.assertEquals(BoxUploadEmail.Access.OPEN, BoxUploadEmail.parseAccess('open'));
    System.assertEquals(BoxUploadEmail.Access.COLLABORATORS, BoxUploadEmail.parseAccess('collaborators'));
   }
     
    public static testmethod void testGetAccessAsString() {
    System.assertEquals('open', BoxUploadEmail.getAccessAsString(BoxUploadEmail.Access.OPEN));
    System.assertEquals('collaborators', BoxUploadEmail.getAccessAsString(BoxUploadEmail.Access.COLLABORATORS));
    }
    
    public static testmethod void testParseMember() {
        BoxApiConnection api = new BoxApiConnection('accesstoken');
		BoxUploadEmail uploadEmail = new BoxUploadEmail(api,'10543463');
		BoxUploadEmail.Info uploadEmailInfo = new BoxUploadEmail.Info();
				
		Test.startTest();
		uploadEmailInfo.parseMember('access', 'open');
	    uploadEmailInfo.parseMember('email', 'test@box.com');
        Test.stopTest();

		System.assertEquals(BoxUploadEmail.Access.OPEN, uploadEmailInfo.access);
		System.assertEquals('test@box.com', uploadEmailInfo.email);		
    }
     
}