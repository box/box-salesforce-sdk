@isTest
public class BoxUserTests {

	public static testmethod void testCreateAppUser() {
	    String mockResponseBody = '{"type": "user","id": "187273718","name": "Ned Stark","login": "eddard@box.com","created_at": "2012-11-15T16:34:28-08:00","modified_at": "2012-11-15T16:34:29-08:00","role": "user","language": "en","space_amount": 5368709120,"space_used": 0,"max_upload_size": 2147483648,"tracking_codes": [],"can_see_managed_users": true,"is_sync_enabled": true,"status": "active","job_title": "","phone": "555-555-5555","address": "555 Box Lane","avatar_url": "https://www.box.com/api/avatar/large/187273718","is_exempt_from_device_limits": false,"is_exempt_from_login_verification": false}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
        
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        
        Test.startTest();
        BoxUser.Info newUser = BoxUser.createAppUser(api, 'Ned Stark');
        Test.stopTest();
        
        System.assertEquals('Ned Stark', newUser.getValue('name'));
    }	
    
    public static testmethod void testGetCurrentUser() {
	    String mockResponseBody = '{"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com","created_at": "2012-03-26T15:43:07-07:00","modified_at": "2012-12-12T11:34:29-08:00","language": "en","space_amount": 5368709120,"space_used": 2377016,"max_upload_size": 262144000,"status": "active","job_title": "Employee","phone": "5555555555","address": "555 Office Drive","avatar_url": "https://app.box.com/api/avatar/large/17738362"}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
        
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        
        Test.startTest();
        BoxUser.Info currentUser = BoxUser.getCurrentUser(api);
        Test.stopTest();
        
        System.assertEquals('sean rose', currentUser.getValue('name'));
        System.assertEquals('17738362', currentUser.getValue('id'));
    }
    
     public static testmethod void testGetAllEnterpriseUsers() {
	    String mockResponseBody = '{"total_count": 1,"entries": [{"type": "user","id": "181216415","name": "sean rose","login": "sean+awesome@box.com","created_at": "2012-05-03T21:39:11-07:00","modified_at": "2012-08-23T14:57:48-07:00","language": "en","space_amount": 5368709120,"space_used": 52947,"max_upload_size": 104857600,"status": "active","job_title": "","phone": "5555551374","address": "10 Cloud Way Los Altos CA","avatar_url": "https://app.box.com/api/avatar/large/181216415"}]}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
        
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        
        Test.startTest();
        list<BoxUser.Info> allUsers = BoxUser.getAllEnterpriseUsers(api);
        Test.stopTest();
        
        System.assertEquals( 1, allUsers.size());
        System.assertEquals('181216415', allUsers[0].getValue('id'));
    }	
    
    public static testmethod void testGetUser() {
	    String mockResponseBody = '{"type": "user","id": "10543463","name": "Arielle Frey","login": "ariellefrey@box.com","created_at": "2011-01-07T12:37:09-08:00","modified_at": "2014-05-30T10:39:47-07:00","language": "en","timezone": "America/Los_Angeles","space_amount": 10737418240,"space_used": 558732,"max_upload_size": 5368709120,"status": "active","job_title": "","phone": "","address": "","avatar_url": "https://blosserdemoaccount.app.box.com/api/avatar/large/10543465"}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
        
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxUser user = new BoxUser(api,'10543463');
        Test.startTest();
        BoxUser.Info userInfo = user.getUser(null);
        Test.stopTest();
        
        System.assertEquals('10543463', userInfo.getValue('id'));
        System.assertEquals('Arielle Frey', userInfo.getValue('name'));
    }
    
     public static testmethod void testGetMemberships() {
	    String mockResponseBody = '{"total_count": 1,"entries": [{"type": "group_membership","id": "1560354","user": {"type": "user","id": "13130406","name": "Alison Wonderland","login": "alice@gmail.com"},"group": {"type": "group","id": "119720","name": "family"},"role": "member"}],"limit": 100,"offset": 0}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
        
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxUser user = new BoxUser(api,'10543463');
        
        BoxGroupMembership.Role membershipRole = BoxGroupMembership.Role.ADMIN;
        BoxGroup boxGroup = new BoxGroup(api, '1201929');
        // ToDo : uncomment below after implementation
        // boxGroup.addMembership(user, membershipRole);
        
        Test.startTest();
        list<BoxGroupMembership.Info> memberships = user.getMemberships();
        Test.stopTest();
        
        System.assertEquals( 1, memberships.size());
        System.assertEquals('1560354', memberships[0].getValue('id'));
    }	
    
    public static testmethod void testAddEmailAlias() {
	    String mockResponseBody = '{"type": "email_alias","id": "1234","is_confirmed": true,"email": "dglover2@box.com"}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
        
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxUser user = new BoxUser(api,'10543463');
        
        Test.startTest();
        BoxEmailAlias.Info emailAlias = user.addEmailAlias('dglover2@box.com');
        Test.stopTest();
        
        System.assertEquals('dglover2@box.com', emailAlias.getValue('email'));
    }
    
     public static testmethod void testDeleteEmailAlias() {
	    String mockResponseBody = '';
   		Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'No Content', 204));
         
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxUser user = new BoxUser(api,'10543463');
        
        Test.startTest();
        Boolean deleteEmailAliasResult = user.deleteEmailAlias('1234');
        Test.stopTest();
        
    	System.assertEquals(true, deleteEmailAliasResult);
     }
     
       
    public static testmethod void testGetEmailAlias() {
	    String mockResponseBody = '{"total_count": 2,"entries": [{"type": "email_alias","id": "1234","is_confirmed": true,"email": "dglover2@box.com"},{"type": "email_alias","id": "1235","is_confirmed": true,"email": "dglover3@box.com"}]}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
        
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxUser user = new BoxUser(api,'10543463');
        
        Test.startTest();
        list<BoxEmailAlias.Info> emailAliases = user.getEmailAliases();
        Test.stopTest();
        
        System.assertEquals(2, emailAliases.size());
        System.assertEquals('dglover2@box.com', emailAliases[0].getValue('email'));
        System.assertEquals('dglover3@box.com', emailAliases[1].getValue('email'));
    }
    
     public static testmethod void testDeleteUser() {
	    String mockResponseBody = '';
   		Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'No Content', 204));
         
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxUser user = new BoxUser(api,'10543463');
        
        Test.startTest();
        Boolean deleteUserResult = user.deleteUser(true, true);
        Test.stopTest();
        
    	System.assertEquals(true, deleteUserResult);
     }
     
     public static testmethod void testUpdateInfo() {
	    String mockResponseBody = '{"type": "user","id": "10543463","name": "Arielle Frey","login": "ariellefrey@box.com","created_at": "2011-01-07T12:37:09-08:00","modified_at": "2014-05-30T10:39:47-07:00","language": "en","timezone": "America/Los_Angeles","space_amount": 10737418240,"space_used": 558732,"max_upload_size": 5368709120,"status": "active","job_title": "","phone": "","address": "","avatar_url": "https://blosserdemoaccount.app.box.com/api/avatar/large/10543465"}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
         
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxUser user = new BoxUser(api,'10543463');
        BoxUser.Info userInfo = new BoxUser.Info();
        userInfo.addValue('name', 'Arielle Frey');
        
        Test.startTest();
        BoxUser.Info updatedUserInfo = user.updateInfo(userInfo);
        Test.stopTest();
        
    	System.assertEquals('Arielle Frey', updatedUserInfo.getValue('name'));
     }
     
     public static testmethod void testMoveFolderToUser() {
	    String mockResponseBody = '{"type": "folder","id": "11446498","sequence_id": "1","etag": "1","name": "Pictures","created_at": "2012-12-12T10:53:43-08:00","modified_at": "2012-12-12T11:15:04-08:00","description": "Some pictures I took","size": 629644,"path_collection": {"total_count": 1,"entries": [{"type": "folder","id": "0","sequence_id": null,"etag": null,"name": "All Files"}]},"created_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"modified_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"owned_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"shared_link": {"url": "https://www.box.com/s/vspke7y05sb214wjokpk","download_url": null,"vanity_url": null,"is_password_enabled": false,"unshared_at": null,"download_count": 0,"preview_count": 0,"access": "open","permissions": {"can_download": true,"can_preview": true}},"folder_upload_email": {"access": "open","email": "upload.Picture.k13sdz1@u.box.com"},"parent": {"type": "folder","id": "0","sequence_id": null,"etag": null,"name": "All Files"},"item_status": "active","item_collection": {"total_count": 1,"entries": [{"type": "file","id": "5000948880","sequence_id": "3","etag": "3","sha1": "134b65991ed521fcfe4724b7d814ab8ded5185dc","name": "tigers.jpeg"}],"offset": 0,"limit": 100}}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
         
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxUser user = new BoxUser(api,'10543463');
        
        Test.startTest();
        BoxFolder.Info folderInfo = user.moveFolderToUser('17738362');
        Test.stopTest();
        
    	System.assertEquals('11446498', folderInfo.getValue('id'));
     }
     
     public static testmethod void testParseRole() {
		System.assertEquals(BoxUser.Role.ADMIN, BoxUser.parseRole('admin'));
		System.assertEquals(BoxUser.Role.COADMIN, BoxUser.parseRole('coadmin'));
		System.assertEquals(BoxUser.Role.USER, BoxUser.parseRole('user'));
     }
     
     public static testmethod void testGetRoleAsString() {
		System.assertEquals('admin', BoxUser.getRoleAsString(BoxUser.Role.ADMIN));
		System.assertEquals('coadmin', BoxUser.getRoleAsString(BoxUser.Role.COADMIN));
		System.assertEquals('user', BoxUser.getRoleAsString(BoxUser.Role.USER));
     }
     
     public static testmethod void testParseStatus() {
		System.assertEquals(BoxUser.Status.ACTIVE, BoxUser.parseStatus('active'));
		System.assertEquals(BoxUser.Status.INACTIVE, BoxUser.parseStatus('inactive'));
		System.assertEquals(BoxUser.Status.CANNOT_DELETE_EDIT, BoxUser.parseStatus('cannot_delete_edit'));
		System.assertEquals(BoxUser.Status.CANNOT_DELETE_EDIT_UPLOAD, BoxUser.parseStatus('cannot_delete_edit_upload'));
     }
     
     public static testmethod void testGetStatusAsString() {
		System.assertEquals('active', BoxUser.getStatusAsString(BoxUser.Status.ACTIVE));
		System.assertEquals('inactive', BoxUser.getStatusAsString(BoxUser.Status.INACTIVE));
		System.assertEquals('cannot_delete_edit', BoxUser.getStatusAsString(BoxUser.Status.CANNOT_DELETE_EDIT));
		System.assertEquals('cannot_delete_edit_upload', BoxUser.getStatusAsString(BoxUser.Status.CANNOT_DELETE_EDIT_UPLOAD));
     }
    
}