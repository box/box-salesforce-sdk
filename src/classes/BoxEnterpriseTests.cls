@IsTest
public class BoxEnterpriseTests {
	public static testmethod void testParseMember() {
        BoxApiConnection api = new BoxApiConnection('accesstoken');
		BoxEnterprise enterprise = new BoxEnterprise(api,'10543463');
		BoxEnterprise.Info enterpriseInfo = new BoxEnterprise.Info();
		enterpriseInfo.addValue('name', 'test enterprise');
		
		Test.startTest();
		enterpriseInfo.parseMember('name', 'test enterprise');
        Test.stopTest();

		System.assertEquals('test enterprise', enterpriseInfo.name);
     }
     
     public static testmethod void testGetEnterpriseEvents() {
    	String mockResponseBody = '{"chunk_size": 3,"next_stream_position": "28893355","entries": [{"source": null,"created_by": {"type": "user","id": "181216415","name": "sean rose","login": "sean+awesome@box.com"},"created_at": "2012-12-12T10:53:43-08:00","event_id": "28893270","event_type": "ADD_LOGIN_ACTIVITY_DEVICE","ip_address": "67.218.117.3","type": "event","session_id": null},{"source": null,"created_by": {"type": "user","id": "181216415","name": "sean rose","login": "sean+awesome@box.com"},"created_at": "2012-12-12T10:53:43-08:00","event_id": "28893272","event_type": "LOGIN","ip_address": "67.218.117.3","type": "event","session_id": null},{"source": {"type": "folder","id": "387630341","sequence_id": "0","name": "A BNE"},"created_by": {"type": "user","id": "181216415","name": "sean rose","login": "sean+awesome@box.com"},"created_at": "2012-12-12T10:53:43-08:00","event_id": "28893354","event_type": "UPLOAD","ip_address": "67.218.117.3","type": "event","session_id": null}]}';
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
    	
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	
    	BoxEnterprise enterprise = new BoxEnterprise(api,'10543463');        
		BoxEnterprise.Info enterpriseInfo = new BoxEnterprise.Info();
        enterpriseInfo.addValue('name', 'Tv Enterprise');
    		
    	Test.startTest();
    	list<BoxEvent.Info> events = enterprise.getEnterpriseEvents();
    	Test.stopTest();
    	
		System.assertEquals(3, events.size());
	}
}