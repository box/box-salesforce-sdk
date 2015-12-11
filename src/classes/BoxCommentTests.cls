@isTest
public class BoxCommentTests {
	public static testmethod void testUpdateComment() {
    	String mockResponseBody = '{"type": "comment","id": "191969","is_reply_comment": false,"message": "These tigers are cool!","created_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"created_at": "2012-12-12T11:25:01-08:00","item": {"id": "5000948880","type": "file"},"modified_at": "2012-12-12T11:25:01-08:00"}';
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));
    	
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
    	BoxComment comment = new BoxComment(api, '5000948880');
    	
    	Test.startTest();
    	BoxComment.Info updatedComment = comment.updateComment('These tigers are cool!');
    	Test.stopTest();
    	
		System.assertEquals('These tigers are cool!', updatedComment.getValue('message'));    
	}

	public static testmethod void testDeleteComment() {
    	String mockResponseBody = '{}';
    	Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'No Content', 204));
    	
    	BoxApiConnection api = new BoxApiConnection('accesstoken');
		BoxComment comment = new BoxComment(api, '5000948880');    	
    	
    	Test.startTest();
    	Boolean deleteCommentResult = comment.deleteComment();
    	Test.stopTest();
    	
    	System.assertEquals(true, deleteCommentResult);
    }
}