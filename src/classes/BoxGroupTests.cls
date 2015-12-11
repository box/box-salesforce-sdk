@isTest
public class BoxGroupTests {
	public static testmethod void testDeleteGroup() {
    	String mockResponseBody = '{}';
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'No Content', 204));
    	
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	BoxGroup groupToDelete = new BoxGroup(api, '5000948880');
    	
    	Test.startTest();
    	Boolean deleteGroupResult = groupToDelete.deleteGroup();
    	Test.stopTest();
    	
    	System.assertEquals(true, deleteGroupResult);
    }
    
    public static testmethod void testGetGroup() {
    	String mockResponseBody = '{ "type": "group", "id": "255224", "name": "Everyone","created_at": "2014-09-15T13:15:35-07:00","modified_at": "2014-09-15T13:15:35-07:00"}';
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
    	
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	BoxGroup groupToGet = new BoxGroup(api, '5000948880');
    	
    	Test.startTest();
    	BoxGroup.Info groupInfo = groupToGet.getGroup();
    	Test.stopTest();
    	
    	System.assertEquals('Everyone', groupInfo.getValue('name'));
    }
    
    public static testmethod void testCreate() {
    	String mockResponseBody = '{ "type": "group", "id": "255224", "name": "Everyone","created_at": "2014-09-15T13:15:35-07:00","modified_at": "2014-09-15T13:15:35-07:00"}';
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
    	
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	
    	Test.startTest();
    	BoxGroup.Info groupInfo = BoxGroup.createGroup(api, 'Everyone');
    	Test.stopTest();
    	
    	System.assertEquals('Everyone', groupInfo.getValue('name'));
    }
    
    public static testmethod void testUpdate() {
    	String mockResponseBody = '{ "type": "group", "id": "255224", "name": "New Group Name","created_at": "2014-09-15T13:15:35-07:00","modified_at": "2014-09-15T13:15:35-07:00"}';
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
    	
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	
    	Test.startTest();
    	BoxGroup.Info groupInfo = BoxGroup.updateGroup(api, 'New Group Name');
    	Test.stopTest();
    	
    	System.assertEquals('New Group Name', groupInfo.getValue('name'));
    }
}