public class BoxTestMockCallout implements HttpCalloutMock
{
    private HttpResponse resp;
    private list<HttpResponse> responseList;
    private Integer currentResponse;

    public BoxTestMockCallout(String testBody, String testStatus, Integer testStatusCode)
    {
        this.resp = buildHttpResponse(testBody, testStatus, testStatusCode);
    }

    public BoxTestMockCallout(list<BoxTestMockCallout.MockResponse> responses) {
        this.responseList = new list<HttpResponse>();
        for (BoxTestMockCallout.MockResponse response : responses) {
            HttpResponse res = buildHttpResponse(response.responseBody, response.responseStatus, response.responseStatusCode);
            this.responseList.add(res);
        }
        this.currentResponse = 0;
    }

    public HTTPResponse respond(HTTPRequest req) {
        if (this.resp != null) {
            return this.resp;
        } else if (this.responseList != null && !this.responseList.isEmpty()) {
            this.currentResponse++;
            return this.responseList[currentResponse - 1];
        }
        return null;
    }

    private HttpResponse buildHttpResponse(String body, String status, Integer statusCode) {
        HttpResponse response = new HttpResponse();
        if (body != null) {
            response.setBody(body);
        }
        if (status != null) {
            response.setStatus(status);
        }
        if (statusCode != null) {
            response.setStatusCode(statusCode);
            if (statusCode == 301 || statusCode == 302) {
                response.setHeader('Location', 'http://redirect.com');
            }
        }
        return response;
    }

    public class MockResponse {
        public String responseBody {get; private set;}
        public String responseStatus {get; private set;}
        public Integer responseStatusCode {get; private set;}
        public MockResponse(String testBody, String testStatus, Integer testStatusCode) {
            this.responseBody = testBody;
            this.responseStatus = testStatus;
            this.responseStatusCode = testStatusCode;
        }
    }
}