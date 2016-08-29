@isTest 
public class BoxFolderTests {
    public static testmethod void testMoveWithRename() {
        String mockResponseBody = '{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"New Folder Name!","created_at":"2012-12-12T10:53:43-08:00","modified_at":"2012-12-12T11:15:04-08:00","description":"Some pictures I took","size":629644,"path_collection":{"total_count":1,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"}]},"created_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"modified_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"owned_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"shared_link":{"url":"https://www.box.com/s/vspke7y05sb214wjokpk","download_url":null,"vanity_url":null,"is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_download":true,"can_preview":true}},"folder_upload_email":{"access":"open","email":"upload.Picture.k13sdz1@u.box.com"},"parent":{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},"item_status":"active","item_collection":{"total_count":1,"entries":[{"type":"file","id":"5000948880","sequence_id":"3","etag":"3","sha1":"134b65991ed521fcfe4724b7d814ab8ded5185dc","name":"tigers.jpeg"}],"offset":0,"limit":100}, "tags":["super", "happy"]}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
        
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFolder folderToMove = new BoxFolder(api, '11446498');
        BoxFolder destination = new BoxFolder(api, '0');
        
        Test.startTest();
        BoxFolder.Info movedFolderInfo = (BoxFolder.Info) folderToMove.move(destination, 'New Folder Name!');
        BoxFolder.Info newParent = new BoxFolder.Info(movedFolderInfo.getValue('parent'));
        Test.stopTest();
        
        System.assertEquals('New Folder Name!', movedFolderInfo.getValue('name'));
        System.assertEquals('0', newParent.getValue('id'));
    }
    
    public static testmethod void testMoveWithoutRename() {
        String mockResponseBody = '{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Old folder name","created_at":"2012-12-12T10:53:43-08:00","modified_at":"2012-12-12T11:15:04-08:00","description":"Some pictures I took","size":629644,"path_collection":{"total_count":1,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"}]},"created_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"modified_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"owned_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"shared_link":{"url":"https://www.box.com/s/vspke7y05sb214wjokpk","download_url":null,"vanity_url":null,"is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_download":true,"can_preview":true}},"folder_upload_email":{"access":"open","email":"upload.Picture.k13sdz1@u.box.com"},"parent":{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},"item_status":"active","item_collection":{"total_count":1,"entries":[{"type":"file","id":"5000948880","sequence_id":"3","etag":"3","sha1":"134b65991ed521fcfe4724b7d814ab8ded5185dc","name":"tigers.jpeg"}],"offset":0,"limit":100}}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
        
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFolder folderToMove = new BoxFolder(api, '11446498');
        BoxFolder destination = new BoxFolder(api, '0');
        
        Test.startTest();
        BoxFolder.Info movedFolderInfo = (BoxFolder.Info) folderToMove.move(destination);
        BoxFolder.Info newParent = new BoxFolder.Info(movedFolderInfo.getValue('parent'));
        Test.stopTest();
        
        System.assertEquals('0', newParent.getValue('id'));
    }
    
    public static testmethod void testCopyWithRename() {
    	String mockResponseBody = '{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures","created_at":"2012-12-12T10:53:43-08:00","modified_at":"2012-12-12T11:15:04-08:00","description":"Some pictures I took","size":629644,"path_collection":{"total_count":1,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"}]},"created_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"modified_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"owned_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"shared_link":{"url":"https://www.box.com/s/vspke7y05sb214wjokpk","download_url":null,"vanity_url":null,"is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_download":true,"can_preview":true}},"folder_upload_email":{"access":"open","email":"upload.Picture.k13sdz1@u.box.com"},"parent":{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},"item_status":"active","item_collection":{"total_count":1,"entries":[{"type":"file","id":"5000948880","sequence_id":"3","etag":"3","sha1":"134b65991ed521fcfe4724b7d814ab8ded5185dc","name":"tigers.jpeg"}],"offset":0,"limit":100}}';
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'Created', 201));
    	
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	BoxFolder folderToCopy = new BoxFolder(api, '11446498');
    	BoxFolder destination = new BoxFolder(api, '0');
    	
    	Test.startTest();
    	BoxFolder.Info copiedFolderInfo = (BoxFolder.Info) folderToCopy.copy(destination, 'Pictures');
    	BoxFolder.Info newParent = new BoxFolder.Info(copiedFolderInfo.getValue('parent'));    	
    	Test.stopTest();
    	
    	System.assertEquals('Pictures', copiedFolderInfo.getValue('name'));
    	System.assertEquals('0', newParent.getValue('id'));
    }
    
    public static testmethod void testCopyWithoutRename() {
    	String mockResponseBody = '{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures","created_at":"2012-12-12T10:53:43-08:00","modified_at":"2012-12-12T11:15:04-08:00","description":"Some pictures I took","size":629644,"path_collection":{"total_count":1,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"}]},"created_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"modified_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"owned_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"shared_link":{"url":"https://www.box.com/s/vspke7y05sb214wjokpk","download_url":null,"vanity_url":null,"is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_download":true,"can_preview":true}},"folder_upload_email":{"access":"open","email":"upload.Picture.k13sdz1@u.box.com"},"parent":{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},"item_status":"active","item_collection":{"total_count":1,"entries":[{"type":"file","id":"5000948880","sequence_id":"3","etag":"3","sha1":"134b65991ed521fcfe4724b7d814ab8ded5185dc","name":"tigers.jpeg"}],"offset":0,"limit":100}}';
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'Created', 201));
    	
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	BoxFolder folderToCopy = new BoxFolder(api, '11446498');
    	BoxFolder destination = new BoxFolder(api, '0');
    	
    	Test.startTest();
    	BoxFolder.Info copiedFolderInfo = (BoxFolder.Info) folderToCopy.copy(destination);
    	BoxFolder.Info newParent = new BoxFolder.Info(copiedFolderInfo.getValue('parent'));    	
    	Test.stopTest();
    	
    	System.assertEquals('0', newParent.getValue('id'));
    }
    
    public static testmethod void testGetObjectType() {
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	BoxFolder folder = new BoxFolder(api, 'folderid');
    	System.assertEquals('folder', folder.getObjectType());
    }
    
    public static testmethod void testSetInfo() {
    	String mockResponseBody = '{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures","created_at":"2012-12-12T10:53:43-08:00","modified_at":"2012-12-12T11:15:04-08:00","description":"Some pictures I took","size":629644,"path_collection":{"total_count":1,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"}]},"created_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"modified_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"owned_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"shared_link":{"url":"https://www.box.com/s/vspke7y05sb214wjokpk","download_url":null,"vanity_url":null,"is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_download":true,"can_preview":true}},"folder_upload_email":{"access":"open","email":"upload.Picture.k13sdz1@u.box.com"},"parent":{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},"item_status":"active","item_collection":{"total_count":1,"entries":[{"type":"file","id":"5000948880","sequence_id":"3","etag":"3","sha1":"134b65991ed521fcfe4724b7d814ab8ded5185dc","name":"tigers.jpeg"}],"offset":0,"limit":100}}';
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	BoxFolder folder = new BoxFolder(api, 'All Files');
    	BoxFolder.Info subfolderInfo = new BoxFolder.Info(mockResponseBody);
    	BoxFolder.Info parentFolderInfo = new BoxFolder.Info(subfolderInfo.getValue('parent'));
    	folder.setInfo(parentFolderInfo);
    	System.assertEquals('0', folder.getInfo().getValue('id'));
    }
    
    public static testmethod void testGetRootFolder() {
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	BoxFolder rootFolder = BoxFolder.getRootFolder(api);
    	System.assertEquals('0', rootFolder.getId());
    }
    
    public static testmethod void testCreateFolder() {
    	String mockResponseBody = '{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures","created_at":"2012-12-12T10:53:43-08:00","modified_at":"2012-12-12T11:15:04-08:00","description":"Some pictures I took","size":629644,"path_collection":{"total_count":1,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"}]},"created_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"modified_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"owned_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"shared_link":{"url":"https://www.box.com/s/vspke7y05sb214wjokpk","download_url":null,"vanity_url":null,"is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_download":true,"can_preview":true}},"folder_upload_email":{"access":"open","email":"upload.Picture.k13sdz1@u.box.com"},"parent":{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},"item_status":"active","item_collection":{"total_count":0,"entries":[],"offset":0,"limit":100}}';
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'Created', 201));
    	
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	BoxFolder rootFolder = BoxFolder.getRootFolder(api);
    	
    	Test.startTest();
    	BoxFolder.Info createdFolderInfo = rootFolder.createFolder('Pictures');
    	BoxFolder.Info parentFolder = new BoxFolder.Info(createdFolderInfo.getValue('parent'));
    	Test.stopTest();
    	
    	System.assertEquals(rootFolder.getId(), parentFolder.getValue('id'));
    }
    
    public static testmethod void testInfoConstructors() {
    	String mockResponseBody = '{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures","created_at":"2012-12-12T10:53:43-08:00","modified_at":"2012-12-12T11:15:04-08:00","description":"Some pictures I took","size":629644,"path_collection":{"total_count":1,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"}]},"created_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"modified_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"owned_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"shared_link":{"url":"https://www.box.com/s/vspke7y05sb214wjokpk","download_url":null,"vanity_url":null,"is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_download":true,"can_preview":true}},"folder_upload_email":{"access":"open","email":"upload.Picture.k13sdz1@u.box.com"},"parent":{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},"item_status":"active","item_collection":{"total_count":0,"entries":[],"offset":0,"limit":100}}';
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	Test.startTest();
        BoxFolder.Info responseFromJsonString = new BoxFolder.Info(mockResponseBody);
        BoxFolder.Info responseFromNoParams = new BoxFolder.Info();
        BoxFolder.Info responseFromJsonObject = new BoxFolder.Info(responseFromJsonString);
        Test.stopTest(); 
        
        BoxFolder folderFromJsonString = new BoxFolder(api, '11446498');
        folderFromJsonString.setInfo(responseFromJsonString);
        BoxFolder folderFromJsonObject = new BoxFolder(api, '11446498');
        folderFromJsonObject.setInfo(responseFromJsonObject);
        System.assert(folderFromJsonString.equalTo(folderFromJsonObject));
        System.assertEquals(responseFromJsonString.getValue('id'), responseFromJsonObject.getValue('id'));
        System.assert(responseFromNoParams.children.size() == 0);
    }
    
    public static testmethod void testParseInfo() {
    	String mockResponseBody = '{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures","created_at":"2012-12-12T10:53:43-08:00","modified_at":"2012-12-12T11:15:04-08:00","description":"Some pictures I took","size":629644,"path_collection":{"total_count":1,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"}]},"created_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"modified_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"owned_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"shared_link":{"url":"https://www.box.com/s/vspke7y05sb214wjokpk","download_url":null,"vanity_url":null,"is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_download":true,"can_preview":true}},"folder_upload_email":{"access":"open","email":"upload.Picture.k13sdz1@u.box.com"},"parent":{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"All Files"},"item_status":"active","item_collection":{"total_count":1,"entries":[{"type":"file","id":"5000948880","sequence_id":"3","etag":"3","sha1":"134b65991ed521fcfe4724b7d814ab8ded5185dc","name":"tigers.jpeg"}],"offset":0,"limit":100}}';
    	BoxFolder.Info folderInfo = new BoxFolder.Info(mockResponseBody);
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	
    	Test.startTest();
    	BoxFolder folder = (BoxFolder) BoxResource.parseInfo(api, folderInfo);
    	Test.stopTest();
    	
    	System.assertEquals(folderInfo.getValue('id'), folder.getId());
    	System.assertEquals(folderInfo.getValue('id'), folder.getInfo().getValue('id'));
    	System.assertNotEquals(null, folderInfo.uploadEmail);
    	System.assertEquals('upload.Picture.k13sdz1@u.box.com', folderinfo.uploadEmail.email);
    }
    
    public static testmethod void testGetApi() {
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	BoxFolder folder = BoxFolder.getRootFolder(api);
    	Test.startTest();
    	BoxApiConnection apiFromFolder = folder.getApi();
    	Test.stopTest();
    	
    	System.assertEquals(api.getAccessToken(), apiFromFolder.getAccessToken());
    }
    
    public static testmethod void testCollaborate() {
    	String mockResponseBody = '{"type":"collaboration","id":"791293","created_by":{"type":"user","id":"17738362","name":"sean rose","login":"sean@box.com"},"created_at":"2012-12-12T10:54:37-08:00","modified_at":"2012-12-12T11:30:43-08:00","expires_at":null,"status":"accepted","accessible_by":{"type":"user","id":"18203124","name":"sean","login":"sean+test@box.com"},"role":"editor","acknowledged_at":"2012-12-12T11:30:43-08:00","item":{"type":"folder","id":"11446500","sequence_id":"0","etag":"0","name":"Shared Pictures"}}';
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'Created', 201));
    	
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	BoxFolder folder = new BoxFolder(api, '11446500');
    	
    	Test.startTest();
    	BoxCollaboration.Role collabRole = BoxCollaboration.Role.EDITOR; 
    	BoxCollaboration.Info newCollab = folder.collaborate('sean+test@box.com', collabRole);
    	Test.stopTest();
    	
    	System.assertEquals('791293', newCollab.id);
    }
    
    public static testmethod void testParseMember() {
        BoxApiConnection api = new BoxApiConnection('accesstoken');
		BoxFolder folder = new BoxFolder(api,'10543463');
		BoxFolder.Info folderInfo = new BoxFolder.Info();
		 
		Test.startTest();
		folderInfo.parseMember('has_collaborations', 'true');
		folderInfo.parseMember('sync_state', 'synced');		
		folderInfo.parseMember('permissions', 'can_download');
		folderInfo.parseMember('can_non_owners_invite', 'false');		
        Test.stopTest();

		System.assertEquals(true, folderInfo.hasCollaborations);
		System.assertEquals(BoxFolder.SyncState.SYNCED, folderInfo.syncState);
		System.assertEquals(BoxFolder.Permission.CAN_DOWNLOAD, folderInfo.permissions);
		System.assertEquals(false, folderInfo.canNonOwnersInvite);
		
     }
     
     public static testmethod void testParseSyncState() {
   		System.assertEquals(BoxFolder.SyncState.SYNCED, BoxFolder.parseSyncState('synced'));
    	System.assertEquals(BoxFolder.SyncState.NOT_SYNCED, BoxFolder.parseSyncState('not_synced'));
    	System.assertEquals(BoxFolder.SyncState.PARTIALLY_SYNCED, BoxFolder.parseSyncState('partially_synced'));
   	 }
   	 
   	 public static testmethod void testParsePermissions() {
   		System.assertEquals(BoxFolder.Permission.CAN_DOWNLOAD, BoxFolder.parsePermission('can_download'));
   		System.assertEquals(BoxFolder.Permission.CAN_UPLOAD, BoxFolder.parsePermission('can_upload'));
   		System.assertEquals(BoxFolder.Permission.CAN_RENAME, BoxFolder.parsePermission('can_rename'));
   		System.assertEquals(BoxFolder.Permission.CAN_DELETE, BoxFolder.parsePermission('can_delete'));
   		System.assertEquals(BoxFolder.Permission.CAN_SHARE, BoxFolder.parsePermission('can_share'));
   		System.assertEquals(BoxFolder.Permission.CAN_INVITE_COLLABORATOR, BoxFolder.parsePermission('can_invite_collaborator'));
   		System.assertEquals(BoxFolder.Permission.CAN_SET_SHARE_ACCESS, BoxFolder.parsePermission('can_set_share_access'));  	
   	 }
   	 
   	 public static testmethod void testGetPermissionAsString() {
   	  	System.assertEquals(BoxFolder.getPermissionAsString(BoxFolder.Permission.CAN_DOWNLOAD), 'can_download');
   		System.assertEquals(BoxFolder.getPermissionAsString(BoxFolder.Permission.CAN_UPLOAD), 'can_upload');
   		System.assertEquals(BoxFolder.getPermissionAsString(BoxFolder.Permission.CAN_RENAME), 'can_rename');
   		System.assertEquals(BoxFolder.getPermissionAsString(BoxFolder.Permission.CAN_DELETE), 'can_delete');
   		System.assertEquals(BoxFolder.getPermissionAsString(BoxFolder.Permission.CAN_SHARE), 'can_share');
   		System.assertEquals(BoxFolder.getPermissionAsString(BoxFolder.Permission.CAN_INVITE_COLLABORATOR), 'can_invite_collaborator');
   		System.assertEquals(BoxFolder.getPermissionAsString(BoxFolder.Permission.CAN_SET_SHARE_ACCESS), 'can_set_share_access');  	
   	
   	 }
   	 
}