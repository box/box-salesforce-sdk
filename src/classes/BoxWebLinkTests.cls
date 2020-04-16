@isTest
public class BoxWebLinkTests {
    @isTest
    static void getWebLinkInfoTest() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockGetWebLinkResponse');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxWebLink webLink = new BoxWebLink(api, '12398550180');
        BoxWebLink.Info info = webLink.getWebLinkInfo();
        Test.stopTest();

        System.assertEquals('My Bookmark', info.getValue('name'));
    }

    @isTest
    static void createWebLinkTest() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockCreateWebLinkResponse');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxWebLink webLink = new BoxWebLink(api, null);
        BoxWebLink.Info info = new BoxWebLink.Info(
            '{"url":"https://www.example.com/example/1234", "parent": {"id": "12345"}, "name": "My Bookmark", "description": "Example page"}'
        );
        BoxWebLink.Info created = webLink.createWebLink(info);
        Test.stopTest();

        System.assertEquals(
            'https://www.example.com/example/1234',
            created.getValue('url')
        );
    }

    @isTest
    static void updateWebLinkInfoTest() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockUpdateWebLinkResponse');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxWebLink webLink = new BoxWebLink(api, '12398550180');
        BoxWebLink.Info info = webLink.getWebLinkInfo();
        info.addValue('description', 'Example page');
        BoxWebLink.Info updated = webLink.updateWebLinkInfo(info);
        Test.stopTest();

        System.assertEquals('Example page', updated.getValue('description'));
    }

    @isTest
    static void deleteWebLinkTest() {
        Test.setMock(
            HttpCalloutMock.class,
            new BoxTestMockCallout('', 'No Content', 204)
        );

        Test.startTest();
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxWebLink webLink = new BoxWebLink(api, '12398550180');
        Boolean deleteWebLinkResult = webLink.deleteWebLink();
        Test.stopTest();

        System.assertEquals(true, deleteWebLinkResult);
    }

    @isTest
    static void getTrashedWebLinkInfoTest() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockGetTrashedWebLinkResponse');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxWebLink webLink = new BoxWebLink(api, '12398550180');
        BoxWebLink.Info info = webLink.getTrashedWebLinkInfo();
        Test.stopTest();

        System.assertEquals('trashed', info.getValue('item_status'));
        System.assert(String.isNotBlank(info.getValue('trashed_at')));
    }

    @isTest
    static void restoreTrashedWebLinkTest() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockRestoreWebLinkResponse');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxWebLink webLink = new BoxWebLink(api, '12398550180');
        BoxWebLink.Info info = webLink.restoreTrashedWebLink();
        Test.stopTest();

        System.assertEquals('active', info.getValue('item_status'));
    }

    @isTest
    static void permanentlyDeleteWebLinkTest() {
        Test.setMock(
            HttpCalloutMock.class,
            new BoxTestMockCallout('', 'No Content', 204)
        );

        Test.startTest();
        BoxApiConnection api = new BoxApiConnection('accesstoken');
        BoxWebLink webLink = new BoxWebLink(api, '12398550180');
        Boolean permanentlyDeleteWebLinkResult = webLink.permanentlyDeleteWebLink();
        Test.stopTest();

        System.assertEquals(true, permanentlyDeleteWebLinkResult);
    }
}
