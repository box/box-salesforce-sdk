@isTest
public class BoxSharedLinkTests {
	public static testmethod void testSetInfo() {
		BoxApiConnection api = new BoxApiConnection('accesstoken');
		BoxSharedLink.Info linkInfo = new BoxSharedLink.Info(BoxTestJsonResponseFactory.BOXSHAREDLINK_GET_LINK);
		
		Test.startTest();
		BoxSharedLink link = new BoxSharedLink(api, null);
		link.setINfo(linkInfo);
		Test.stopTest();
		
		System.assertEquals('https://www.box.com/s/vspke7y05sb214wjokpk', link.getInfo().getValue('url'));
	}
	
	public static testmethod void testInfoConstructors() {
    	String mockResponseBody = BoxTestJsonResponseFactory.BOXSHAREDLINK_GET_LINK;
		BoxApiConnection api = new BoxApiConnection('accesstoken');
		
		Test.startTest();
		BoxSharedLink.Info responseFromJsonString = new BoxSharedLink.Info(mockResponseBody);
		BoxSharedLink.Info responseFromNoParams = new BoxSharedLink.Info();
    	BoxSharedLink.Info responseFromJsonObject = new BoxSharedLink.Info(responseFromJsonString);
    	Test.stopTest();
    	
        BoxSharedLink linkFromJsonString = new BoxSharedLink(api, null);
        linkFromJsonString.setInfo(responseFromJsonString);
        BoxSharedLink linkFromJsonObject = new BoxSharedLink(api, null);
        linkFromJsonObject.setInfo(responseFromJsonObject);
        
        System.assertEquals(responseFromJsonString.getValue('url'), responseFromJsonObject.getValue('url'));
        System.assert(responseFromNoParams.children.size() == 0);
	}
	
	public static testmethod void testAddValue() {
		String mockResponseBody = BoxTestJsonResponseFactory.BOXSHAREDLINK_GET_LINK;
		BoxSharedLink.Info linkInfo = new BoxSharedLink.Info();
		BoxSharedLink.Permissions perm = new BoxSharedLink.Permissions();
		perm.addValue('can_download', 'false');
		perm.addValue('can_preview', 'true');
		linkInfo.addValue('permissions', perm);
	}
	
	public static testmethod void testGetObjectType() {
		BoxApiConnection api = new BoxApiConnection('accesstoken');
		
		Test.startTest();
		BoxSharedLink link = new BoxSharedLink(api, null);
		String objectType = link.getObjectType();
		Test.stopTest();
		
		System.assertEquals('shared_link', objectType);
	}
	
	public static testmethod void testParseAccess() {
		System.assertEquals(BoxSharedLink.Access.DEFAULT_ACCESS, BoxSharedLink.parseAccess('default'));
		System.assertEquals(BoxSharedLink.Access.OPEN, BoxSharedLink.parseAccess('open'));
		System.assertEquals(BoxSharedLink.Access.COMPANY, BoxSharedLink.parseAccess('company'));
		System.assertEquals(BoxSharedLink.Access.COLLABORATORS, BoxSharedLink.parseAccess('collaborators'));
		System.assertEquals(null, BoxSharedLink.parseAccess('invalid_value'));
	}
	
	public static testmethod void testGetAccessAsString() {
		System.assertEquals('default', BoxSharedLink.getAccessAsString(BoxSharedLink.Access.DEFAULT_ACCESS));
		System.assertEquals('open', BoxSharedLink.getAccessAsString(BoxSharedLink.Access.OPEN));
		System.assertEquals('company', BoxSharedLink.getAccessAsString(BoxSharedLink.Access.COMPANY));
		System.assertEquals('collaborators', BoxSharedLink.getAccessAsString(BoxSharedLink.Access.COLLABORATORS));
		System.assertEquals(null, BoxSharedLink.getAccessAsString(null));
	}
}