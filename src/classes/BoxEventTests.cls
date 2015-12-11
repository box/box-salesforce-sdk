@isTest
public class BoxEventTests {
	public static testmethod void testParseEventType() {
      String eventType = 'item_create';
      BoxEvent.Info eventInfo = new BoxEvent.Info();
      BoxEvent.Type boxEventType = eventInfo.parseEventType(eventType);
      System.assertEquals(boxEventType, BoxEvent.Type.ITEM_CREATE);
    }
    
    public static testmethod void testParseEventTypes() {
      list<String> eventNames = new list<String> {'wrong','ITEM_CREATE','ITEM_UPLOAD','COMMENT_CREATE','ITEM_DOWNLOAD','ITEM_PREVIEW','ITEM_MOVE','ITEM_COPY','TASK_ASSIGNMENT_CREATE','LOCK_CREATE','LOCK_DESTROY','ITEM_TRASH','ITEM_UNDELETE_VIA_TRASH','COLLAB_ADD_COLLABORATOR','COLLAB_REMOVE_COLLABORATOR','COLLAB_INVITE_COLLABORATOR','COLLAB_ROLE_CHANGE','ITEM_SYNC','ITEM_UNSYNC','ITEM_RENAME','ITEM_SHARED_CREATE','ITEM_SHARED_UNSHARE','ITEM_SHARED','ADD_LOGIN_ACTIVITY_DEVICE','REMOVE_LOGIN_ACTIVITY_DEVICE','CHANGE_ADMIN_ROLE','GROUP_ADD_USER','NEW_USER','GROUP_CREATION','GROUP_DELETION','DELETE_USER','GROUP_EDITED','EDIT_USER','GROUP_ADD_FOLDER','GROUP_REMOVE_USER','GROUP_REMOVE_FOLDER','ADMIN_LOGIN','ADD_DEVICE_ASSOCIATION','FAILED_LOGIN','LOGIN','USER_AUTHENTICATE_OAUTH2_TOKEN_REFRESH','REMOVE_DEVICE_ASSOCIATION','TERMS_OF_SERVICE_AGREE','TERMS_OF_SERVICE_REJECT','COPY','DELETE','DOWNLOAD','EDIT','LOCK','MOVE','PREVIEW','RENAME','STORAGE_EXPIRATION','UNDELETE','UNLOCK','UPLOAD','SHARE','ITEM_SHARED_UPDATE','UPDATE_SHARE_EXPIRATION','SHARE_EXPIRATION','UNSHARE','COLLABORATION_ACCEPT','COLLABORATION_ROLE_CHANGE','UPDATE_COLLABORATION_EXPIRATION','COLLABORATION_REMOVE','COLLABORATION_INVITE','COLLABORATION_EXPIRATION'};
      BoxEvent.Info eventInfo = new BoxEvent.Info();
      list<BoxEvent.Type> eventTypes = new list<BoxEvent.Type>();
      for(String eventName: eventNames) {
      	 eventTypes.add(eventInfo.parseEventType(eventName));
      } 
      
      list<BoxEvent.Type> expectedEventNames = BoxEvent.Type.values();
      
      System.assertEquals(eventTypes, expectedEventNames);           
    }
    
    public static testmethod void testParseMember() {
        BoxApiConnection api = new BoxApiConnection('accesstoken');
		BoxEvent event = new BoxEvent(api,'10543463');
		BoxEvent.Info eventInfo = new BoxEvent.Info();
		
		BoxUser user = new BoxUser(api,'10543463');        
		BoxUser.Info userInfo = new BoxUser.Info();
        userInfo.addValue('name', 'Arielle Frey');
        userInfo.addValue('id', '10543463');
        userInfo.addValue('type', 'user');
        
		Test.startTest();
		eventInfo.parseMember('event_type', 'item_upload');
		eventInfo.parseMember('created_at', '2013-11-20T13:20:50-08:00');
		eventInfo.parseMember('ip_address', '10.0.0.1');
		eventInfo.parseMember('accessible_by', userInfo.getJsonString());
		eventInfo.parseMember('created_by', userInfo.getJsonString());
		eventInfo.parseMember('session_id', 'non-empty session ID');
        Test.stopTest();

		System.assertEquals(BoxEvent.Type.ITEM_UPLOAD, eventInfo.eventType);
		System.assertEquals(BoxDateFormat.parseBoxDateTimeString('2013-11-20T13:20:50-08:00'), eventInfo.createdAt);
		System.assertEquals('10.0.0.1', eventInfo.ipAddress);
		System.assertEquals(userInfo.getJsonString(), eventInfo.accessibleBy.getJsonString());	
		System.assertEquals(userInfo.getJsonString(), eventInfo.createdBy.getJsonString());
		System.assertEquals('non-empty session ID', eventInfo.sessionId);		
     }
     
     public static testmethod void testGetUserEvents() {
    	String mockResponseBody = '{"chunk_size": 1,"next_stream_position": 1348790499819,"entries": [{"type": "event","event_id": "f82c3ba03e41f7e8a7608363cc6c0390183c3f83","created_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"created_at": "2012-12-12T10:53:43-08:00","recorded_at": "2012-12-12T10:53:48-08:00","event_type": "ITEM_CREATE","session_id": "70090280850c8d2a1933c1","source": {"type": "folder","id": "11446498","sequence_id": "0","etag": "0","name": "Pictures","created_at": "2012-12-12T10:53:43-08:00","modified_at": "2012-12-12T10:53:43-08:00","description": null,"size": 0,"created_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"modified_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"owned_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"shared_link": null,"parent": {"type": "folder","id": "0","sequence_id": null,"etag": null,"name": "All Files"},"item_status": "active","synced": false}}]}';
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
    	
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	
    	BoxUser user = new BoxUser(api,'10543463');        
		BoxUser.Info userInfo = new BoxUser.Info();
        userInfo.addValue('name', 'Arielle Frey');
        userInfo.addValue('id', '10543463');   
    		
    	Test.startTest();
    	list<BoxEvent.Info> events = user.getUserEvents();
    	Test.stopTest();
    	
		System.assertEquals(1, events.size());
		System.assertEquals('f82c3ba03e41f7e8a7608363cc6c0390183c3f83', events[0].getValue('event_id'));    
	}
}