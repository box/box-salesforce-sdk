@isTest
public class BoxApiRequestTests {
    private static String url = 'https://example.com';
    private static String method = 'GET';
    private static String accessToken = 'accesstoken';
    private static String refreshToken = 'refreshtoken';
    private static String clientId = 'clientid';
    private static String clientSecret = 'clientsecret';

    public static testMethod void testConstructors() {
        BoxApiConnection api = new BoxApiConnection(accessToken);

        Test.startTest();
        BoxApiRequest request1 = new BoxApiRequest(url, method);
        BoxApiRequest request2 = new BoxApiRequest(api, url, method);

        BoxApiConnection api2 = new BoxApiConnection(accessToken);
        api2.setAsUserId('1234');
        BoxApiRequest request3 = new BoxApiRequest(api2, url, method);
        Test.stopTest();
    }

    public static testMethod void testRetry() {
        list<BoxTestMockCallout.MockResponse> responses = new List<BoxTestMockCallout.MockResponse>();
        BoxTestMockCallout.MockResponse retryResponse = new BoxTestMockCallout.MockResponse(
            '{"status":"retry"}',
            'ERROR',
            500
        );
        responses.add(retryResponse);
        BoxTestMockCallout.MockResponse successResponse = new BoxTestMockCallout.MockResponse(
            '{"status":"success"}',
            'OK',
            200
        );
        responses.add(successResponse);
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(responses));

        Test.startTest();
        BoxApiConnection api = new BoxApiConnection(
            clientId,
            clientSecret,
            accessToken,
            refreshToken
        );
        api.lastRefresh = DateTime.now().getTime() - 5;
        api.expires = api.lastRefresh + 60000;
        BoxApiRequest request = new BoxApiRequest(api, url, method);
        request.setBody('request body', 12);
        request.setTimeout(500);
        HttpResponse finalResponse = request.send();
        Test.stopTest();

        System.assertEquals(200, finalResponse.getStatusCode());
    }

    public static testMethod void testRedirect() {
        list<BoxTestMockCallout.MockResponse> responses = new List<BoxTestMockCallout.MockResponse>();
        BoxTestMockCallout.MockResponse redirectResponse = new BoxTestMockCallout.MockResponse(
            '{"status":"redirect"}',
            'REDIRECT',
            301
        );
        responses.add(redirectResponse);
        BoxTestMockCallout.MockResponse successResponse = new BoxTestMockCallout.MockResponse(
            '{"Status":"success"}',
            'OK',
            200
        );
        responses.add(successResponse);
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(responses));

        Test.startTest();
        BoxApiConnection api = new BoxApiConnection(
            clientId,
            clientSecret,
            accessToken,
            refreshToken
        );
        api.lastRefresh = DateTime.now().getTime() - 5;
        api.expires = api.lastRefresh + 60000;
        BoxApiRequest request = new BoxApiRequest(api, url, method);
        request.setBody('request body');
        request.setTimeout(500);
        HttpResponse finalResponse = request.send();
        Test.stopTest();

        System.assertEquals(200, finalResponse.getStatusCode());
    }

    @isTest
    static void handleRedirectTest() {
        list<BoxTestMockCallout.MockResponse> responses = new List<BoxTestMockCallout.MockResponse>();
        BoxTestMockCallout.MockResponse redirectResponse = new BoxTestMockCallout.MockResponse(
            '{"status":"redirect"}',
            'REDIRECT',
            301
        );
        responses.add(redirectResponse);
        BoxTestMockCallout.MockResponse successResponse = new BoxTestMockCallout.MockResponse(
            '{"Status":"success"}',
            'OK',
            200
        );
        responses.add(successResponse);
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(responses));

        BoxApiConnection api = new BoxApiConnection(
            clientId,
            clientSecret,
            accessToken,
            refreshToken
        );
        api.lastRefresh = DateTime.now().getTime() - 5;
        api.expires = api.lastRefresh + 60000;

        BoxApiRequest request = new BoxApiRequest(api, url, method);
        request.numberOfRedirects = 1;
        request.setTimeout(500);

        HttpResponse responseMock = new HttpResponse();
        responseMock.setHeader(
            BoxApiRequest.HEADER_LOCATION_LOWER_CASE,
            BoxTestMockCallout.MOCK_REDIRECT_URL
        );

        Test.startTest();

        request.handleRedirect(responseMock);

        Test.stopTest();

        System.assertEquals(
            BoxTestMockCallout.MOCK_REDIRECT_URL,
            request.url,
            'Expected request url to be assigned value from response location header'
        );
    }

    @isTest
    static void handleRedirectLegacyTest() {
        list<BoxTestMockCallout.MockResponse> responses = new List<BoxTestMockCallout.MockResponse>();
        BoxTestMockCallout.MockResponse redirectResponse = new BoxTestMockCallout.MockResponse(
            '{"status":"redirect"}',
            'REDIRECT',
            302
        );
        responses.add(redirectResponse);
        BoxTestMockCallout.MockResponse successResponse = new BoxTestMockCallout.MockResponse(
            '{"Status":"success"}',
            'OK',
            200
        );
        responses.add(successResponse);
        Test.setMock(HttpCalloutMock.class, new BoxTestMockCallout(responses));

        BoxApiConnection api = new BoxApiConnection(
            clientId,
            clientSecret,
            accessToken,
            refreshToken
        );
        api.lastRefresh = DateTime.now().getTime() - 5;
        api.expires = api.lastRefresh + 60000;

        BoxApiRequest request = new BoxApiRequest(api, url, method);
        request.numberOfRedirects = 1;
        request.setTimeout(500);

        HttpResponse responseMock = new HttpResponse();
        responseMock.setHeader(
            BoxApiRequest.HEADER_LOCATION_CAPITALIZED,
            BoxTestMockCallout.MOCK_REDIRECT_URL
        );

        Test.startTest();

        request.handleRedirect(responseMock);

        Test.stopTest();

        System.assertEquals(
            BoxTestMockCallout.MOCK_REDIRECT_URL,
            request.url,
            'Expected request url to be assigned value from response location header'
        );
    }
}
