/**
 * Represents an authenticated connection to the Box API.
 *
 * This class handles storing authentication information and automatic token refresh. It can also be
 * used to configure the Box API endpoint URL in order to hit a different version of the API. Multiple instances of
 * BoxAPIConnection may be created to support multi-user login.
 */

public virtual class BoxApiConnection {

    public static final Integer DEFAULT_MAX_ATTEMPTS = 3;
    public static final Integer DEFAULT_CALLOUT_TIMEOUT = 60000;
    public static final String HEADER_CONTENT_TYPE = 'Content-Type';
    public static final String HEADER_APPLICATION_ENCODED = 'application/x-www-form-urlencoded';
    public static final String TOKEN_URL_STRING = 'https://api.box.com/oauth2/token';
    public static final String DEFAULT_BASE_URL = 'https://api.box.com/2.0/';
    public static final String DEFAULT_BASE_UPLOAD_URL = 'https://upload.box.com/api/2.0/';
    public static final String METHOD_POST = 'POST';

    public final String clientId;
    public final String clientSecret;

    public String userAgent {get; set;}
    public String accessToken {get; set;}
    public String refreshToken {get; set;}
    public String tokenUrl {get; set;}
    public String baseUrl {get; set;}
    public String baseUploadUrl {get; set;}
    public String asUserId {get; set;}
	
    public Boolean autoRefresh {get; set;}

    public Integer maxRequestAttempts {get; set;}
    public Integer timeout {get; set;}

    public Long lastRefresh {get; set;}
    public Long expires {get; set;}

    public BoxApiConnection(String accessToken) {
        this(null, null, accessToken, null);
    }

    public BoxApiConnection(String clientId, String clientSecret) {
        this(clientId, clientSecret, null, null);
    }

    public BoxApiConnection(String clientId, String clientSecret, String authCode) {
        this(clientId, clientSecret, null, null);
        this.authenticate(authCode);
    }

    public BoxApiConnection(String clientId, String clientSecret, String accessToken, String refreshToken) {
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        this.setAccessToken(accessToken);
        this.setRefreshToken(refreshToken);
        this.setTokenUrl(TOKEN_URL_STRING);
        this.setBaseUrl(DEFAULT_BASE_URL);
        this.setBaseUploadUrl(DEFAULT_BASE_UPLOAD_URL);
        this.setAutoRefresh(true);
        this.setMaxRequestAttempts(DEFAULT_MAX_ATTEMPTS);
        this.setTimeout(DEFAULT_CALLOUT_TIMEOUT);
        this.setUserAgent('Box Apex SDK v1.0.0');
        this.setLastRefresh(0);
        this.setExpires(0);
    }

    public virtual void authenticate(String authCode) {
        BoxApiRequest request = new BoxApiRequest(this, this.getTokenUrl(), BoxApiRequest.METHOD_POST);
        request.shouldAuthenticate = false;
        request.setTimeout(this.getTimeout());
        String urlParameters = String.format('grant_type=authorization_code&code={0}&client_id={1}&client_secret={2}', 
            new String[] {authCode, this.getClientId(), this.getClientSecret()});
        request.setBody(urlParameters);
        request.addHeader(HEADER_CONTENT_TYPE, HEADER_APPLICATION_ENCODED);

        HttpResponse response = request.send();
        if (response.getStatus() == 'OK') {
            BoxGenericJsonObject authResponse = new BoxGenericJsonObject(response.getBody());
            this.setAccessToken(authResponse.getValue('access_token'));
            this.setRefreshToken(authResponse.getValue('refresh_token'));
            this.setLastRefresh(DateTime.now().getTime());
            this.setExpires(Long.valueOf(authResponse.getValue('expires_in')) * 1000);
        } else {
            throw new BoxApiConnectionException('BoxApiConnection unable to use auth code to generate tokens: ' + response.toString());
        }
    }

    public String getAccessToken() {
        if (this.getAutoRefresh() && this.canRefresh() && this.needsRefresh()) {
            this.refresh();
        }
        return this.accessToken;
    }

    private Boolean needsRefresh() {
        Boolean needsRefresh;
        long now = DateTime.now().getTime();
        long tokenDuration = now - this.getLastRefresh();
        needsRefresh = (tokenDuration >= this.getExpires());
        return needsRefresh;
    }

    public virtual Boolean canRefresh() {
        return (this.getRefreshToken() != null);
    }

    public virtual void refresh() {
        if (!this.canRefresh()) {
            throw new BoxApiConnectionException('BoxApiConnection unable to refresh access token because it doesn\'t have a refresh token.');
        }

        BoxApiRequest request = new BoxApiRequest(this, this.getTokenUrl(), BoxApiRequest.METHOD_POST);
        request.shouldAuthenticate = false;
        request.setTimeout(this.getTimeout());
        String urlParameters = String.format('grant_type=refresh_token&refresh_token={0}&client_id={1}&client_secret={2}',
            new String[] {this.getRefreshToken(), this.getClientId(), this.getClientSecret()});
        request.setBody(urlParameters);
        request.addHeader(HEADER_CONTENT_TYPE, HEADER_APPLICATION_ENCODED);

        HttpResponse response = request.send();
        if (response.getStatus() == 'OK') {
            BoxGenericJsonObject authResponse = new BoxGenericJsonObject(response.getBody());
            this.setAccessToken(authResponse.getValue('access_token'));
            this.setRefreshToken(authResponse.getValue('refresh_token'));
            this.setLastRefresh(DateTime.now().getTime());
            this.setExpires(Long.valueOf(authResponse.getValue('expires_in')) * 1000);
        } else {
            throw new BoxApiConnectionException('BoxApiConnection unable to use refresh token to generate new access token: ' + response.toString());
        }
    }

    public virtual String getClientId() {
        return this.clientId;
    }

    public virtual String getClientSecret() {
        return this.clientSecret;
    }

    public virtual String getUserAgent() {
        return this.userAgent;
    }

    public virtual void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public virtual void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public virtual String getRefreshToken() {
        return this.refreshToken;
    }

    public virtual void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public virtual String getTokenUrl() {
        return this.tokenUrl;
    }

    public virtual void setTokenUrl(String tokenUrl) {
        this.tokenUrl = tokenUrl;
    }

    public virtual String getBaseUrl() {
        return this.baseUrl;
    }

    public virtual void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    public virtual String getBaseUploadUrl() {
        return this.baseUploadUrl;
    }

    public virtual void setBaseUploadUrl(String baseUploadUrl) {
        this.baseUploadUrl = baseUploadUrl;
    }
    
    public virtual String getAsUserId() {
        return this.asUserId;
    }
    
    public virtual void setAsUserId(String asUserId) {
        this.asUserId = asUserId;
    }
	
    public virtual Boolean getAutoRefresh() {
        return this.autoRefresh;
    }

    public virtual void setAutoRefresh(Boolean autoRefresh) {
        this.autoRefresh = autoRefresh;
    }

    public virtual Integer getMaxRequestAttempts() {
        return this.maxRequestAttempts;
    }

    public virtual void setMaxRequestAttempts(Integer maxRequestAttempts) {
        this.maxRequestAttempts = maxRequestAttempts;
    }

    public virtual Integer getTimeout() {
        return this.timeout;
    }

    public virtual void setTimeout(Integer timeout) {
        this.timeout = timeout;
    }

    public virtual Long getLastRefresh() {
        return this.lastRefresh;
    }

    public virtual void setLastRefresh(Long lastRefresh) {
        this.lastRefresh = lastRefresh;
    }

    public virtual Long getExpires() {
        return this.expires;
    }

    public virtual void setExpires(Long expires) {
        this.expires = expires;
    }

    public class BoxApiConnectionException extends Exception {}
}