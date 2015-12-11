@isTest
public class BoxCollaborationTests {
	public static testmethod void testGetPendingCollaborations() {
		String mockResponseBody = BoxTestJsonResponseFactory.BOXCOLLABORATION_GET_PENDING_COLLABS;
		Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
		
		BoxApiConnection api = new BoxApiConnection('accesstoken');
		
		Test.startTest();
		list<BoxCollaboration.Info> pendingCollabs = BoxCollaboration.getPendingCollaborations(api);
		Test.stopTest();
		
		System.assertEquals(1, pendingCollabs.size());
	}
	
	public static testmethod void testGetCollaboration() {
		String mockResponseBody = BoxTestJsonResponseFactory.BOXCOLLABORATION_GET_COLLAB;
		Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
		BoxApiConnection api = new BoxApiConnection('accesstoken');
		
		Test.startTest();
		BoxCollaboration collab = new BoxCollaboration(api, '791293');
		BoxCollaboration.Info collabInfo = collab.getCollaboration();
		Test.stopTest();
		
		System.assertEquals('viewer', collabInfo.getValue('role'));
		
	}
	
	public static testmethod void testUpdateCollaboration() {
		map<String, String> updatedFields = new map<String, String>();
		updatedFields.put('role', 'editor');
		String mockResponseBody = BoxTestJsonResponseFactory.getModifiedResponse(BoxTestJsonResponseFactory.BOXCOLLABORATION_GET_COLLAB, updatedFields);
		Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
		BoxApiConnection api = new BoxApiConnection('accesstoken');
		
		Test.startTest();
		BoxCollaboration collab = new BoxCollaboration(api, '791293');
		BoxCollaboration.Info updatedCollabInfo = collab.updateCollaboration(BoxCollaboration.Role.EDITOR);
		Test.stopTest();
		
		System.assertEquals('editor', BoxCollaboration.getRoleAsString(updatedCollabInfo.role));
	}
	
	public static testmethod void testDeleteCollaboration() {
		Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(null, 'No Content', 204));
		BoxApiConnection api = new BoxApiConnection('accesstoken');
		
		Test.startTest();
		BoxCollaboration collab = new BoxCollaboration(api, '123456');
		Boolean deleted = collab.deleteCollaboration();
		Test.stopTest();
		
		System.assertEquals(true, deleted);
	}
	
	public static testmethod void testGetRoleAsString() {
		System.assertEquals('editor', BoxCollaboration.getRoleAsString(BoxCollaboration.Role.EDITOR));
		System.assertEquals('viewer', BoxCollaboration.getRoleAsString(BoxCollaboration.Role.VIEWER));
		System.assertEquals('previewer', BoxCollaboration.getRoleAsString(BoxCollaboration.Role.PREVIEWER));
		System.assertEquals('uploader', BoxCollaboration.getRoleAsString(BoxCollaboration.Role.UPLOADER));
		System.assertEquals('previewer uploader', BoxCollaboration.getRoleAsString(BoxCollaboration.Role.PREVIEWER_UPLOADER));
		System.assertEquals('viewer uploader', BoxCollaboration.getRoleAsString(BoxCollaboration.Role.VIEWER_UPLOADER));
		System.assertEquals('co-owner', BoxCollaboration.getRoleAsString(BoxCollaboration.Role.CO_OWNER));
		System.assertEquals('owner', BoxCollaboration.getRoleAsString(BoxCollaboration.Role.OWNER));
		System.assertEquals(null, BoxCollaboration.getRoleAsString(null));
	}
	
	public static testmethod void testParseRole() {
		System.assertEquals(BoxCollaboration.Role.EDITOR, BoxCollaboration.parseRole('editor'));
		System.assertEquals(BoxCollaboration.Role.VIEWER, BoxCollaboration.parseRole('viewer'));
		System.assertEquals(BoxCollaboration.Role.PREVIEWER, BoxCollaboration.parseRole('previewer'));
		System.assertEquals(BoxCollaboration.Role.UPLOADER, BoxCollaboration.parseRole('uploader'));
		System.assertEquals(BoxCollaboration.Role.PREVIEWER_UPLOADER, BoxCollaboration.parseRole('previewer uploader'));
		System.assertEquals(BoxCollaboration.Role.VIEWER_UPLOADER, BoxCollaboration.parseRole('viewer uploader'));
		System.assertEquals(BoxCollaboration.Role.CO_OWNER, BoxCollaboration.parseRole('co-owner'));
		System.assertEquals(BoxCollaboration.Role.OWNER, BoxCollaboration.parseRole('owner'));
		System.assertEquals(null, BoxCollaboration.parseRole('invalid value'));
	}
	
	public static testmethod void testParseStatus() {
		System.assertEquals(BoxCollaboration.Status.ACCEPTED, BoxCollaboration.parseStatus('accepted'));
		System.assertEquals(BoxCollaboration.Status.PENDING, BoxCollaboration.parseStatus('pending'));
		System.assertEquals(BoxCollaboration.Status.REJECTED, BoxCollaboration.parseStatus('rejected'));
		System.assertEquals(null, BoxCollaboration.parseStatus('invalid value'));
	}
	
	public static testmethod void testGetObjectType() {
		BoxApiConnection api = new BoxApiConnection('accesstoken');
		BoxCollaboration collab = new BoxCollaboration(api, '123456');
		
		System.assertEquals('collaboration', collab.getObjectType());
	}
	
	public static testmethod void testSetInfo() {
		String mockResponseBody = BoxTestJsonResponseFactory.BOXCOLLABORATION_GET_COLLAB;
		BoxApiConnection api = new BoxApiConnection('accesstoken');
		BoxCollaboration collab = new BoxCollaboration(api, '791293');
		BoxCollaboration.Info collabInfo = new BoxCollaboration.Info(mockResponseBody);
		collab.setInfo(collabInfo);
		
		System.assertEquals(collab.getId(), collabInfo.id);
	}
	
	public static testmethod void testInfoConstructors() {
    	String mockResponseBody = BoxTestJsonResponseFactory.BOXCOLLABORATION_GET_COLLAB;
		BoxApiConnection api = new BoxApiConnection('accesstoken');
		
		Test.startTest();
		BoxCollaboration.Info responseFromJsonString = new BoxCollaboration.Info(mockResponseBody);
		BoxCollaboration.Info responseFromNoParams = new BoxCollaboration.Info();
    	BoxCollaboration.Info responseFromJsonObject = new BoxCollaboration.Info(responseFromJsonString);
    	Test.stopTest();
    	
        BoxCollaboration collabFromJsonString = new BoxCollaboration(api, '791293');
        collabFromJsonString.setInfo(responseFromJsonString);
        BoxCollaboration collabFromJsonObject = new BoxCollaboration(api, '791293');
        collabFromJsonObject.setInfo(responseFromJsonObject);
        System.assert(collabFromJsonString.equalTo(collabFromJsonObject));
        System.assertEquals(responseFromJsonString.getValue('id'), responseFromJsonObject.getValue('id'));
        System.assert(responseFromNoParams.children.size() == 0);
	}
	
	public static testmethod void testAddValue() {
		String mockResponseBody = BoxTestJsonResponseFactory.BOXCOLLABORATION_GET_COLLAB;
		BoxCollaboration.Info collabInfo = new BoxCollaboration.Info(mockResponseBody);
		BoxCollaboration.Info collabCopy = new BoxCollaboration.Info(collabInfo.getJsonString());
		collabInfo.addValue('self', collabCopy);
	}
}