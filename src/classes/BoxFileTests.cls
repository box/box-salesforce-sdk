@isTest
public class BoxFileTests {
 public static testmethod void testMoveWithRename() {
        String mockResponseBody = '{"type":"file","id":"5000948880","sequence_id":"3","etag":"3","sha1":"134b65991ed521fcfe4724b7d814ab8ded5185dc","name":"tigers.jpeg","description":"apictureoftigers","size":629644,"path_collection":{"total_count":2,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"AllFiles"},{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures"}]},"created_at":"2012-12-12T10:55:30-08:00","modified_at":"2012-12-12T11:04:26-08:00","created_by":{"type":"user","id":"17738362","name":"seanrose","login":"sean@box.com"},"modified_by":{"type":"user","id":"17738362","name":"seanrose","login":"sean@box.com"},"owned_by":{"type":"user","id":"17738362","name":"seanrose","login":"sean@box.com"},"shared_link":{"url":"https://www.box.com/s/rh935iit6ewrmw0unyul","download_url":"https://www.box.com/shared/static/rh935iit6ewrmw0unyul.jpeg","vanity_url":null,"is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_download":true,"can_preview":true}},"parent":{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures"},"item_status":"active"}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile fileToMove = new BoxFile(api, '5000948880');
        BoxFolder destination = new BoxFolder(api, '11446498');

        Test.startTest();
        BoxFile.Info movedFileInfo = (BoxFile.Info) fileToMove.move(destination, 'tigers.jpeg');
        BoxFolder.Info newParent = new BoxFolder.Info(movedFileInfo.getValue('parent'));
        Test.stopTest();

        System.assertEquals('tigers.jpeg', movedFileInfo.getValue('name'));
        System.assertEquals('11446498', newParent.getValue('id'));
    }

    public static testmethod void testMoveWithoutRename() {
        String mockResponseBody = '{"type":"file","id":"5000948880","sequence_id":"3","etag":"3","sha1":"134b65991ed521fcfe4724b7d814ab8ded5185dc","name":"tigers.jpeg","description":"apictureoftigers","size":629644,"path_collection":{"total_count":2,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"AllFiles"},{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures"}]},"created_at":"2012-12-12T10:55:30-08:00","modified_at":"2012-12-12T11:04:26-08:00","created_by":{"type":"user","id":"17738362","name":"seanrose","login":"sean@box.com"},"modified_by":{"type":"user","id":"17738362","name":"seanrose","login":"sean@box.com"},"owned_by":{"type":"user","id":"17738362","name":"seanrose","login":"sean@box.com"},"shared_link":{"url":"https://www.box.com/s/rh935iit6ewrmw0unyul","download_url":"https://www.box.com/shared/static/rh935iit6ewrmw0unyul.jpeg","vanity_url":null,"is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_download":true,"can_preview":true}},"parent":{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures"},"item_status":"active"}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile fileToMove = new BoxFile(api, '5000948880');
        BoxFolder destination = new BoxFolder(api, '11446498');

        Test.startTest();
        BoxFile.Info movedFileInfo = (BoxFile.Info) fileToMove.move(destination);
        BoxFolder.Info newParent = new BoxFolder.Info(movedFileInfo.getValue('parent'));
        Test.stopTest();

        System.assertEquals('11446498', newParent.getValue('id'));
    }

    public static testmethod void testCopyWithRename() {
        String mockResponseBody = '{"type":"file","id":"5000948880","sequence_id":"3","etag":"3","sha1":"134b65991ed521fcfe4724b7d814ab8ded5185dc","name":"tigers.jpeg","description":"apictureoftigers","size":629644,"path_collection":{"total_count":2,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"AllFiles"},{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures"}]},"created_at":"2012-12-12T10:55:30-08:00","modified_at":"2012-12-12T11:04:26-08:00","created_by":{"type":"user","id":"17738362","name":"seanrose","login":"sean@box.com"},"modified_by":{"type":"user","id":"17738362","name":"seanrose","login":"sean@box.com"},"owned_by":{"type":"user","id":"17738362","name":"seanrose","login":"sean@box.com"},"shared_link":{"url":"https://www.box.com/s/rh935iit6ewrmw0unyul","download_url":"https://www.box.com/shared/static/rh935iit6ewrmw0unyul.jpeg","vanity_url":null,"is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_download":true,"can_preview":true}},"parent":{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures"},"item_status":"active"}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'Created', 201));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile fileToCopy = new BoxFile(api, '5000948880');
        BoxFolder destination = new BoxFolder(api, '11446498');

        Test.startTest();
        BoxFile.Info copiedFileInfo = (BoxFile.Info) fileToCopy.copy(destination, 'tigers.jpeg');
        BoxFolder.Info newParent = new BoxFolder.Info(copiedFileInfo.getValue('parent'));
        Test.stopTest();

        System.assertEquals('tigers.jpeg', copiedFileInfo.getValue('name'));
        System.assertEquals('11446498', newParent.getValue('id'));
    }

    public static testmethod void testCopyWithoutRename() {
        String mockResponseBody = '{"type":"file","id":"5000948880","sequence_id":"3","etag":"3","sha1":"134b65991ed521fcfe4724b7d814ab8ded5185dc","name":"tigers.jpeg","description":"apictureoftigers","size":629644,"path_collection":{"total_count":2,"entries":[{"type":"folder","id":"0","sequence_id":null,"etag":null,"name":"AllFiles"},{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures"}]},"created_at":"2012-12-12T10:55:30-08:00","modified_at":"2012-12-12T11:04:26-08:00","created_by":{"type":"user","id":"17738362","name":"seanrose","login":"sean@box.com"},"modified_by":{"type":"user","id":"17738362","name":"seanrose","login":"sean@box.com"},"owned_by":{"type":"user","id":"17738362","name":"seanrose","login":"sean@box.com"},"shared_link":{"url":"https://www.box.com/s/rh935iit6ewrmw0unyul","download_url":"https://www.box.com/shared/static/rh935iit6ewrmw0unyul.jpeg","vanity_url":null,"is_password_enabled":false,"unshared_at":null,"download_count":0,"preview_count":0,"access":"open","permissions":{"can_download":true,"can_preview":true}},"parent":{"type":"folder","id":"11446498","sequence_id":"1","etag":"1","name":"Pictures"},"item_status":"active"}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'Created', 201));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile fileToCopy = new BoxFile(api, '5000948880');
        BoxFolder destination = new BoxFolder(api, '11446498');

        Test.startTest();
        BoxFile.Info copiedFileInfo = (BoxFile.Info) fileToCopy.copy(destination);
        BoxFolder.Info newParent = new BoxFolder.Info(copiedFileInfo.getValue('parent'));
        Test.stopTest();

        System.assertEquals('11446498', newParent.getValue('id'));
    }

     public static testmethod void testDeleteFile() {
        String mockResponseBody = '{}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'No Content', 204));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile fileToDelete = new BoxFile(api, '5000948880');

        Test.startTest();
        Boolean deleteFileResult = fileToDelete.deleteFile();
        Test.stopTest();

        System.assertEquals(true, deleteFileResult);
    }

    public static testmethod void testRename() {
        String mockResponseBody = '{}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile file = new BoxFile(api, '5000948880');

        Test.startTest();
        Boolean renameFileResult = file.rename('newFileName');
        Test.stopTest();

        System.assertEquals(true, renameFileResult);
    }

     public static testmethod void testGetComments() {
        String mockResponseBody = '{"total_count": 1,"entries": [{"type": "comment","id": "191969","is_reply_comment": false,"message": "These tigers are cool!","created_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"created_at": "2012-12-12T11:25:01-08:00","item": {"id": "5000948880","type": "file"},"modified_at": "2012-12-12T11:25:01-08:00"}]}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile file = new BoxFile(api, '5000948880');

        Test.startTest();
        list<BoxComment.Info> comments = file.getComments();
        Test.stopTest();

        System.assertEquals(1, comments.size());
        System.assertEquals('191969', comments[0].getValue('id'));
    }

    public static testmethod void testGetVersions() {
        String mockResponseBody = '{"total_count": 1,"entries": [{"type": "file_version","id": "672259576","sha1": "359c6c1ed98081b9a69eb3513b9deced59c957f9","name": "Dragons.js","size": 92556,"created_at": "2012-08-20T10:20:30-07:00","modified_at": "2012-11-28T13:14:58-08:00","modified_by": {"type": "user","id": "183732129","name": "sean rose","login": "sean+apitest@box.com"}}]}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile file = new BoxFile(api, '5000948880');

        Test.startTest();
        list<BoxFileVersion.Info> versions = file.getVersions();
        Test.stopTest();

        System.assertEquals(1, versions.size());
        System.assertEquals('672259576', versions[0].getValue('id'));
    }

    public static testmethod void testAddComment() {
        String mockResponseBody = '{"type": "comment","id": "191969","is_reply_comment": false,"message": "These tigers are cool!","created_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"created_at": "2012-12-12T11:25:01-08:00","item": {"id": "5000948880","type": "file"},"modified_at": "2012-12-12T11:25:01-08:00"}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile file = new BoxFile(api, '5000948880');

        Test.startTest();
        BoxComment.Info comment = file.addComment('These tigers are cool!');
        Test.stopTest();

        System.assertEquals('These tigers are cool!', comment.getValue('message'));
    }

    public static testmethod void testAddCommentWithMention() {
        String mockResponseBody = '{"type": "comment","id": "191969","is_reply_comment": false,"tagged_message": "@sean Check this!","created_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"created_at": "2012-12-12T11:25:01-08:00","item": {"id": "5000948880","type": "file"},"modified_at": "2012-12-12T11:25:01-08:00"}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile file = new BoxFile(api, '5000948880');

        Test.startTest();
        BoxComment.Info comment = file.addComment('@[17738362:sean] Check this!');
        Test.stopTest();

        System.assertEquals('@sean Check this!', comment.getValue('tagged_message'));
    }

    public static testmethod void testGetFileInfo() {
        String mockResponseBody = '{"type": "file","id": "5000948880","file_version": {"type": "file_version","id": "26261748416","sha1": "134b65991ed521fcfe4724b7d814ab8ded5185dc"},"sequence_id": "3","etag": "3","sha1": "134b65991ed521fcfe4724b7d814ab8ded5185dc","name": "tigers.jpeg","description": "a picture of tigers","size": 629644,"path_collection": {"total_count": 2,"entries": [{"type": "folder","id": "0","sequence_id": null,"etag": null,"name": "All Files"},{"type": "folder","id": "11446498","sequence_id": "1","etag": "1","name": "Pictures"}]},"created_at": "2012-12-12T10:55:30-08:00","modified_at": "2012-12-12T11:04:26-08:00","created_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"modified_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"owned_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"shared_link": {"url": "https://www.box.com/s/rh935iit6ewrmw0unyul","download_url": "https://www.box.com/shared/static/rh935iit6ewrmw0unyul.jpeg","vanity_url": null,"is_password_enabled": false,"unshared_at": null,"download_count": 0,"preview_count": 0,"access": "open","permissions": {"can_download": true,"can_preview": true}},"parent": {"type": "folder","id": "11446498","sequence_id": "1","etag": "1","name": "Pictures"},"item_status": "active"}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile file = new BoxFile(api, '5000948880');

        Test.startTest();
        BoxFile.Info fileInfo = file.getFileInfo();
        Test.stopTest();

        System.assertEquals('5000948880', fileInfo.getValue('id') );
        System.assertEquals('tigers.jpeg', fileInfo.getValue('name'));
    }

    public static testmethod void testUpdateFileInfo() {
        String mockResponseBody = '{"type": "file","id": "5000948880","file_version": {"type": "file_version","id": "26261748416","sha1": "134b65991ed521fcfe4724b7d814ab8ded5185dc"},"sequence_id": "3","etag": "3","sha1": "134b65991ed521fcfe4724b7d814ab8ded5185dc","name": "tigers.jpeg","description": "a picture of tigers","size": 629644,"path_collection": {"total_count": 2,"entries": [{"type": "folder","id": "0","sequence_id": null,"etag": null,"name": "All Files"},{"type": "folder","id": "11446498","sequence_id": "1","etag": "1","name": "Pictures"}]},"created_at": "2012-12-12T10:55:30-08:00","modified_at": "2012-12-12T11:04:26-08:00","created_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"modified_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"owned_by": {"type": "user","id": "17738362","name": "sean rose","login": "sean@box.com"},"shared_link": {"url": "https://www.box.com/s/rh935iit6ewrmw0unyul","download_url": "https://www.box.com/shared/static/rh935iit6ewrmw0unyul.jpeg","vanity_url": null,"is_password_enabled": false,"unshared_at": null,"download_count": 0,"preview_count": 0,"access": "open","permissions": {"can_download": true,"can_preview": true}},"parent": {"type": "folder","id": "11446498","sequence_id": "1","etag": "1","name": "Pictures"},"item_status": "active"}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile file = new BoxFile(api, '5000948880');
        BoxFile.Info info = new BoxFile.Info();
        info.addValue('name', 'tigers.jpeg');

        Test.startTest();
        BoxFile.Info fileInfo = file.updateFileInfo(info);
        Test.stopTest();

        System.assertEquals('5000948880', fileInfo.getValue('id') );
        System.assertEquals('tigers.jpeg', fileInfo.getValue('name'));
    }

    public static testmethod void testGetPreviewLink() {
        String mockResponseBody = '{"type": "file", "id": "34122832467", "etag": "1", "expiring_embed_link": {"url": "https://app.box.com/preview/expiring_embed/gvoct6FE!Qz2rDey"}}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile file = new BoxFile(api, '5000948880');

        Test.startTest();
        String previewLink = file.getPreviewLink();
        Test.stopTest();

        System.assertEquals('https://app.box.com/preview/expiring_embed/gvoct6FE!Qz2rDey', previewLink);
    }

    public static testmethod void testCreateSharedLink() {
        String mockResponseBody = '{"type": "file","id": "10559150999","file_version": {"type": "file_version","id": "7326581117","sha1": "8bd844fdbcd3e143d88eaff977bb211120501e07"},"sequence_id": "1","etag": "1","sha1": "8bd844fdbcd3e143d88eaff977bb211120501e07","name": "Metadata blog image.png","description": "","size": 86680,"path_collection": {"total_count": 2,"entries": [{"type": "folder","id": "0","sequence_id": null,"etag": null,"name": "All Files"},{"type": "folder","id": "848123342","sequence_id": "0","etag": "0","name": "Test"}]},"created_at": "2013-09-22T22:59:19-07:00","modified_at": "2013-09-22T22:59:20-07:00","trashed_at": null,"purged_at": null,"content_created_at": "2013-09-22T22:59:19-07:00","content_modified_at": "2013-09-22T22:59:19-07:00","created_by": {"type": "user","id": "10523870","name": "Ted Blosser","login": "ted+demo@box.com"},"modified_by": {"type": "user","id": "10523870","name": "Ted Blosser","login": "ted+demo@box.com"},"owned_by": {"type": "user","id": "10523870","name": "Ted Blosser","login": "ted+demo@box.com"},"shared_link": {"url": "https://blosserdemoaccount.box.com/s/7mcmdlavtye5o5i0ue8xmtwh2sx5bv8p","download_url": "https://blosserdemoaccount.box.com/shared/static/7mcmdlavtye5o5i0ue8xmtwh2sx5bv8p.png","vanity_url": null,"effective_access": "open","is_password_enabled": true,"unshared_at": null,"download_count": 0,"preview_count": 0,"access": "open","permissions": {"can_download": true,"can_preview": true}},"parent": {"type": "folder","id": "848123342","sequence_id": "0","etag": "0","name": "Test"},"item_status": "active"}';
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));

        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxFile file = new BoxFile(api, '10559150999');

        Test.startTest();
        BoxSharedLink.Info sharedLinkInfo = file.createSharedLink();
        Test.stopTest();


        System.assertEquals('open', sharedLinkInfo.getValue('access') );
        System.assertEquals('https://blosserdemoaccount.box.com/s/7mcmdlavtye5o5i0ue8xmtwh2sx5bv8p', sharedLinkInfo.getValue('url'));
    }

    public static testmethod void testGetTrashedFile(){
      String mockResponseBody = BoxTestJsonResponseFactory.BOXFILE_GET_TRASHED_FILE;
      Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(mockResponseBody, 'OK', 200));

      BoxApiConnection api = new BoxApiConnection('accesstoken');
      BoxFile file = new BoxFile(api, '10559150999');

      Test.startTest();
      BoxFile.Info retrievedTrashedFile = file.getTrashedFile();
      Test.stopTest();

      System.assertEquals('10559150999', fileInfo.getValue('id') );
    }
}
