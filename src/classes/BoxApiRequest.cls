public class BoxApiRequest {
    public final static String METHOD_POST = 'POST';
    public final static String METHOD_GET = 'GET';
    public final static String METHOD_PUT = 'PUT';
    public final static String METHOD_DELETE = 'DELETE';
    
    private static final Integer MAX_REDIRECTS = 3;
    private static final Integer DEFAULT_CALLOUT_TIMEOUT = 20000;
    private static final Integer MAX_CALLOUT_FILE_SIZE = 6000000;
    private static final String BOUNDARY = 'BoxApexSDKcjhJ$vXxPaCKo=83up1oadb0undary';
    
    public final BoxApiConnection api;
    public final list<RequestHeader> headers;
    public final String method;
    
    public String url {get; set;}
    public Integer maxRequestAttempts {get; set;}
    public Integer timeout {get; set;}
    public String body {get; set;}
    public Blob bodyAsBlob {get; set;}
    public long bodyLength {get; set;}
    private Integer numberOfRedirects {get; set;}
    private Integer numberOfRetries {get; set;}
    public Boolean shouldAuthenticate {get; set;}
    
    public BoxApiRequest(String url, String method) {
        this(null, url, method);
    }
    
    public BoxApiRequest(BoxApiConnection api, String url, String method) {
        this.api = api;
        this.url = url;
        this.method = method;
        this.shouldAuthenticate = true;
        this.headers = new list<RequestHeader>();
        
        if(api != null && api.getAsUserId() != null && api.getAsUserId() != '')
        {
            this.addHeader('As-User', api.getAsUserId());
        }
    	
        this.addHeader('Accept-Encoding', 'gzip');
        this.addHeader('Accept-Charset', 'utf-8');
    }
    
    public void addHeader(String key, String value) {
        this.headers.add(new RequestHeader(key, value));
    }
    
    public void setBody(String body) {
        this.body = body;
    }
    
    public void setBody(String body, Long length) {
        this.body = body;
        this.bodyLength = length;
    }
    
    public void setTimeout(Integer timeout) {
        this.timeout = timeout;
    }
    
    public void setMultipartFormBody(Blob fileBody, String fileName) {
        if (fileBody.size() > MAX_CALLOUT_FILE_SIZE) {
            throw new BoxApiRequestException('File size is too large (' + String.valueOf(fileBody.size()) + ' bytes). The maximum file size is ' + String.valueOf(MAX_CALLOUT_FILE_SIZE) + ' bytes.');
        }
        try {
            Blob bodyBlob = BoxBase64.buildMultipartFileBody(fileBody, fileName, BOUNDARY);
            this.bodyAsBlob = bodyBlob;
            this.addHeader('Content-Type', 'multipart/form-data; boundary=' + BOUNDARY);
        } catch (Exception ex) {
            throw new BoxApiRequestException('Exception thrown when Base64 Decoding the http request body. ' + ex.getMessage());
        }
    }
    
    public HttpResponse send() {
        this.numberOfRetries = 0;
        this.numberOfRedirects = 0;
        
        if (this.api == null) {
            this.maxRequestAttempts = BoxAPIConnection.DEFAULT_MAX_ATTEMPTS;
        } else {
            this.maxRequestAttempts = this.api.getMaxRequestAttempts();
        }
        while (this.numberOfRetries < this.maxRequestAttempts) {
            try {
                HttpResponse response = this.trySend();
                if (isResponseRetryable(response.getStatusCode())) {
                    this.numberOfRetries++;
                } else {
                    return response;
                }
            } catch (BoxApiRequestException bex) {
                throw bex;
            } catch (Exception ex) {
                throw new BoxApiRequestException('An unexpected error occurred when trying to make a callout to the Box API. ' + ex.getMessage());
            }
        }
        
        return null;
    }
    
    private HttpResponse trySend() {
        this.checkContextForCallout();
        
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod(this.method);
        request.setEndpoint(this.url);
        request.setTimeout(this.timeout);
        if (this.api != null) {
            if (this.shouldAuthenticate) {
                request.setHeader('Authorization', 'Bearer ' + this.api.getAccessToken());
            }
            request.setHeader('User-Agent', this.api.getUserAgent());
        }
        if (this.bodyAsBlob != null) {
            request.setBodyAsBlob(this.bodyAsBlob);
            this.addHeader('Content-Length', String.valueof(request.getBodyAsBlob().size()));
        } else if (this.body != null) {
            request.setBody(this.body);
        }
        for (RequestHeader header : this.headers) {
            request.setHeader(header.getKey(), header.getValue());
        }
        System.debug('httprequest = ' + request);
        System.debug('request body = ' + request.getBody());
        HttpResponse response = h.send(request);
        System.debug('response body: ' + response.getBody());
        
        if (isResponseRedirect(response.getStatusCode())) {
            return this.handleRedirect(response);
        } else if (isResponseBadRequest(response.getStatusCode())) {
            throw new BoxApiRequestException('The Box API responded with a 400 : Bad Request');
        } else if (isResponseNotFound(response.getStatusCode())) {
            throw new BoxApiRequestException('The Box API responded with a 404 : Not Found');
        }
        
        return response;
    }
    
    private HttpResponse handleRedirect(HttpResponse response) {
        if (this.numberOfRedirects >= MAX_REDIRECTS) {
            throw new BoxApiRequestException('The Box API responded with too many redirects.');
        }
        this.numberOfRedirects++;
        
        String redirect;
        try {
            redirect = response.getHeader('Location');
        } catch (Exception ex) {
            throw new BoxApiRequestException('Exception occurred when getting redirect Location. ' + ex.getMessage());
        }
        
        if (redirect != null) {
            this.url = redirect;
            return this.trySend();
        } else {
            throw new BoxApiRequestException('Redirect Location was null but the response code from the Box API indicated a redirect.');
        }
    }
    
    private static Boolean isResponseRetryable(Integer responseCode) {
        return (responseCode >= 500 || responseCode == 429);
    }
    
    private static Boolean isResponseRedirect(Integer responseCode) {
        return (responseCode == 301 || responseCode == 302);
    }
    
    private static Boolean isResponseBadRequest(Integer responseCode) {
        return (responseCode == 400);
    }
    
    private static Boolean isResponseNotFound(Integer responseCode) {
        return (responseCode == 404);
    }
    
    private class RequestHeader {
        private final String key;
        private final String value;
        
        public RequestHeader(String key, String value) {
            this.key = key;
            this.value = value;
        }
        
        public String getKey() {
            return this.key;
        }
        
        public String getValue() {
            return this.value;
        }
    }
    
    private void checkContextForCallout() {
        if (Limits.getLimitCallouts() < 1) {
            throw new BoxApiRequestException('BoxApiRequest unable to make a callout due to no remaining callouts allowed (Limits.getLimitCallouts() == 0).');
        }
    }
    
    public static String getBoxResourceResponseBody(HttpResponse response, String methodName) {
        if (response == null) {
            throw new BoxResource.BoxResourceNullResponseException(String.format(BoxResource.NULL_RESPONSE_EXCEPTION_TEMPLATE, new String[] {methodName}));
        }
        if (response.getBody() != null) {
            return response.getBody();
        } else {
            throw new BoxResource.BoxResourceNullBodyException(String.format(BoxResource.NULL_BODY_EXCEPTION_TEMPLATE, new String[] {methodName}));
        }
    }
    
    public static Boolean ensureBoxResourceResponseCode(HttpResponse response, String methodName, set<Integer> statusCodes) {
        if (response == null) {
            throw new BoxResource.BoxResourceNullResponseException(String.format(BoxResource.NULL_RESPONSE_EXCEPTION_TEMPLATE, new String[] {methodName}));
        } else if(statusCodes.contains(response.getStatusCode())) { 
            return true;
        }
        return false;
    }
    
    public void addJsonContentTypeHeader() {
        this.addHeader('Content-Type', 'application/json');
    }
    
    public class BoxApiRequestException extends Exception {}
}