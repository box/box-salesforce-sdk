@IsTest
public class BoxFileVersionTests {
	public static testmethod void testDeleteFileVersion() {
    	String mockResponseBody = '{}';
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'No Content', 204));
    	
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	BoxFileVersion fileVersionToDelete = new BoxFileVersion(api, '871399');
    	fileVersionToDelete.setFileId('123456');
    	
    	Test.startTest();
    	Boolean deleteFileVersionResult = fileVersionToDelete.deleteVersion();
    	Test.stopTest();
    	
    	System.assertEquals(true, deleteFileVersionResult);
    }
    
    public static testmethod void testPromoteFileVersion() {
        String mockResponseBody = '{"type": "file_version","id": "871399","sha1": "12039d6dd9a7e6eefc78846802e","name": "Stark Family Lineage.doc","size": 11,"created_at": "2013-11-20T13:20:50-08:00","modified_at": "2013-11-20T13:26:48-08:00","modified_by": {"type": "user","id": "13711334","name": "Eddard Stark","login": "ned@winterfell.com"}}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
        
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFileVersion fileVersion = new BoxFileVersion(api, '871399');
        fileVersion.setFileId('123456');
        
        Test.startTest();
        BoxFileVersion.Info fileVersionInfo = fileVersion.promoteFileVersion();
        Test.stopTest();
        
        System.assertEquals('871399', fileVersionInfo.getValue('id'));
    }
    
    public static testmethod void testParseMember() {
        BoxApiConnection api = new BoxApiConnection('accesstoken');
		BoxFileVersion fileVersion = new BoxFileVersion(api,'871399');
		BoxFileVersion.Info fileVersionInfo = new BoxFileVersion.Info();
		fileVersionInfo.addValue('id', '871399');
		
		BoxUser.Info userInfo = new BoxUser.Info();
        userInfo.addValue('name', 'Arielle Frey');
        userInfo.addValue('id', '10543463');
       
		Test.startTest();
		fileVersionInfo.parseMember('id', '871399');
		fileVersionInfo.parseMember('sha1', '12039d6dd9a7e6eefc78846802e');
		fileVersionInfo.parseMember('name', 'Stark Family Lineage.doc');
		fileVersionInfo.parseMember('created_at', '2013-11-20T13:20:50-08:00');
		fileVersionInfo.parseMember('modified_at', '2013-11-20T13:20:50-08:00');
		fileVersionInfo.parseMember('modified_by', userInfo.getJsonString());
        Test.stopTest();

		System.assertEquals('871399', fileVersionInfo.versionId);
		System.assertEquals('12039d6dd9a7e6eefc78846802e', fileVersionInfo.sha1);
		System.assertEquals('Stark Family Lineage.doc', fileVersionInfo.name);
		System.assertEquals(BoxDateFormat.parseBoxDateTimeString('2013-11-20T13:20:50-08:00'), fileVersionInfo.createdAt);
		System.assertEquals(BoxDateFormat.parseBoxDateTimeString('2013-11-20T13:20:50-08:00'), fileVersionInfo.modifiedAt);
		System.assertEquals(userInfo.getJsonString(), fileVersionInfo.modifiedBy.getJsonString());	
     }
}