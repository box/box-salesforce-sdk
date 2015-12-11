public class BoxPlatformApiConnection extends BoxApiConnection {

    private static final String JWT_AUDIENCE = 'https://api.box.com/oauth2/token';

    public final String entityId {get; private set;}
    public final BoxPlatform.PlatformEntityType entityType {get; private set;}
    public final BoxJwtEncryptionPreferences.EncryptionAlgorithm encryptionAlgorithm {get; private set;}
    public final String publicKeyId {get; private set;}
    public final String privateKey {get; private set;}
    public final String privateKeyPassword {get; private set;}

    /**
     * Disabling an invalid constructor for Box Platform Edition.
     * @param  accessToken  an initial access token to use for authenticating with the API.
     */
    public BoxPlatformApiConnection(String accessToken) {
        super(null);
        throw new BoxApiConnectionException('This constructor is not available for BoxPlatformApiConnection.');
    }

    /**
     * Disabling an invalid constructor for Box Platform Edition.
     * @param  clientID     the client ID to use when requesting an access token.
     * @param  clientSecret the client secret to use when requesting an access token.
     */
    public BoxPlatformApiConnection(String clientID, String clientSecret) {
        super(null);
        throw new BoxApiConnectionException('This constructor is not available for BoxPlatformApiConnection.');
    }

    /**
     * Disabling an invalid constructor for Box Platform Edition.
     * @param  clientID     the client ID to use when exchanging the auth code for an access token.
     * @param  clientSecret the client secret to use when exchanging the auth code for an access token.
     * @param  authCode     an auth code obtained from the first half of the OAuth process.
     */
    public BoxPlatformApiConnection(String clientID, String clientSecret, String authCode) {
        super(null);
        throw new BoxApiConnectionException('This constructor is not available for BoxPlatformApiConnection.');
    }

    /**
     * Disabling an invalid constructor for Box Platform Edition.
     * @param  clientID     the client ID to use when refreshing the access token.
     * @param  clientSecret the client secret to use when refreshing the access token.
     * @param  accessToken  an initial access token to use for authenticating with the API.
     * @param  refreshToken an initial refresh token to use when refreshing the access token.
     */
    public BoxPlatformApiConnection(String clientID, String clientSecret, String accessToken, String refreshToken) {
        super(null);
        throw new BoxApiConnectionException('This constructor is not available for BoxPlatformApiConnection.');
    }

    /**
     * Constructs a new BoxPlatformAPIConnection.
     * @param entityId             enterprise ID or a user ID.
     * @param entityType           the type of entityId.
     * @param clientID             the client ID to use when exchanging the JWT assertion for an access token.
     * @param clientSecret         the client secret to use when exchanging the JWT assertion for an access token.
     * @param encryptionPref       the encryption preferences for signing the JWT.
     */
    public BoxPlatformApiConnection(String entityId, 
                                            BoxPlatform.PlatformEntityType entityType, 
                                            String clientId, 
                                            String clientSecret, 
                                            BoxJwtEncryptionPreferences encryptionPref) {
        super(clientId, clientSecret);
        this.entityId = entityId;
        this.entityType = entityType;
        this.publicKeyId = encryptionPref.getPublicKeyId();
        this.privateKey = encryptionPref.getPrivateKey();
        this.privateKeyPassword = encryptionPref.getPrivateKeyPassword();
        this.encryptionAlgorithm = encryptionPref.getEncryptionAlgorithm();
    }

    /**
     * Creates a new Box Platform Edition connection with enterprise token.
     * @param enterpriseId          the enterprise ID to use for requesting access token.
     * @param clientId              the client ID to use when exchanging the JWT assertion for an access token.
     * @param clientSecret          the client secret to use when exchanging the JWT assertion for an access token.
     * @param encryptionPref        the encryption preferences for signing the JWT.
     * @return a new instance of BoxAPIConnection.
     */
    public static BoxPlatformApiConnection getAppEnterpriseConnection(
                      String enterpriseId,
                      String clientId,
                      String clientSecret,
                      BoxJwtEncryptionPreferences encryptionPref) {
        BoxPlatformApiConnection connection = new BoxPlatformApiConnection(
            enterpriseId,
            BoxPlatform.PlatformEntityType.ENTERPRISE,
            clientId,
            clientSecret,
            encryptionPref);
        connection.authenticate();
        return connection;
    }

    /**
     * Creates a new Box Platform Edition connection with enterprise token.
     * @param enterpriseId          the user ID to use for an App User.
     * @param clientId              the client ID to use when exchanging the JWT assertion for an access token.
     * @param clientSecret          the client secret to use when exchanging the JWT assertion for an access token.
     * @param encryptionPref        the encryption preferences for signing the JWT.
     * @return a new instance of BoxAPIConnection.
     */
    public static BoxPlatformApiConnection getAppUserConnection(
                      String userId,
                      String clientId,
                      String clientSecret,
                      BoxJwtEncryptionPreferences encryptionPref) {
        BoxPlatformApiConnection connection = new BoxPlatformApiConnection(
            userId,
            BoxPlatform.PlatformEntityType.USER,
            clientId,
            clientSecret,
            encryptionPref);
        connection.authenticate();
        return connection;
    }

    /**
     * Disabling the non-Box Platform Edition authenticate method.
     * @param authCode an auth code obtained from the first half of the OAuth process.
     */
    public override void authenticate(String authCode) {
        throw new BoxApiConnectionException('BoxPlatformApiConnection does not allow authenticating with an auth code.');
    }

    /**
     * Authenticates the API connection for Box Platform Edition.
     */
    public void authenticate() {
        String jwtAssertion = this.constructJwtAssertion();
        String urlParameters = String.format('grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer'
                                           + '&client_id={0}&client_secret={1}&assertion={2}',
            new String[] {this.getClientId(), this.getClientSecret(), jwtAssertion});
        BoxApiRequest request = new BoxApiRequest(this, this.getTokenUrl(), BoxApiRequest.METHOD_POST);
        request.shouldAuthenticate = false;
        request.setBody(urlParameters);
        request.addHeader(HEADER_CONTENT_TYPE, HEADER_APPLICATION_ENCODED);
        request.setTimeout(this.getTimeout());
        HttpResponse response = request.send();
        if (response.getStatus() == 'OK') {
            BoxGenericJsonObject authResponse = new BoxGenericJsonObject(response.getBody());
            this.setAccessToken(authResponse.getValue('access_token'));
            this.setLastRefresh(DateTime.now().getTime());
            this.setExpires(Long.valueOf(authResponse.getValue('expires_in')) * 1000);
        } else {
            throw new BoxApiConnectionException('BoxPlatformApiConnection unable to authenticate to generate tokens');
        }
    }

    /**
     * BoxPlatformApiConnection can always refresh, but this method is required elsewhere.
     * @return true always.
     */
    public override Boolean canRefresh() {
        return true;
    }

    /**
     * Refresh's this connection's access token using Box Platform Edition.
     */
    public override void refresh() {
        this.authenticate();
    }
    /**
     * Generates the JWT Assertion to send to Box
     */
    private String constructJwtAssertion() {
        String jwtHeader = constructJwtHeader();
        String jwtClaims = constructJwtClaims();
        String jwtSignature = constructJwtSignature(jwtHeader, jwtClaims);
        return jwtHeader + '.' + jwtClaims + '.' + jwtSignature;
    }

    /**
     * Generates the JWT Header
     */
    private String constructJwtHeader() {
        BoxGenericJsonObject headerObject = new BoxGenericJsonObject();
        // Currently, only RS256 is implemented.
        headerObject.addValue('alg', 'RS256');
        headerObject.addValue('typ', 'JWT');
        headerObject.addValue('kid', this.publicKeyId);
        return this.base64UrlSafe(Blob.valueOf(headerObject.getJsonString()));
    }

    /**
     * Generates the JWT claims
     */
    private String constructJwtClaims() {
        BoxGenericJsonObject claimsObject = new BoxGenericJsonObject();
        claimsObject.addValue('iss', this.getClientId());
        claimsObject.addValue('sub', this.entityId);
        claimsObject.addValue('box_sub_type', BoxPlatform.getPlatformEntityTypeAsString(this.entityType));
        claimsObject.addValue('aud', JWT_AUDIENCE);
        claimsObject.addValue('jti', this.createJti());
        //Token will be good for the next 10 seconds
        claimsObject.addValue('exp', String.valueOf((DateTime.now().getTime() / 1000) + 10));
        return this.base64UrlSafe(Blob.valueOf(claimsObject.getJsonString()));
    }

    /**
     * Generates the JWT Signature
     */
    private String constructJwtSignature(String jwtHeader, String jwtClaims) {
        String algorithmName = 'RSA-SHA256';
        Blob input = Blob.valueOf(jwtHeader + '.' + jwtClaims);
        
        String modifiedPrivateKey = BoxBase64.prepareStringForBase64Decoding(this.privateKey);
        Blob privateKeyBlob = EncodingUtil.base64Decode(modifiedPrivateKey);
        Blob signed = Crypto.sign(algorithmName, input, privateKeyBlob);
        return this.base64UrlSafe(signed);
    }

    /**
     * Makes base64Encoded strings URL safe
     */
    private String base64UrlSafe(Blob b) {
        return EncodingUtil.base64Encode(b).replace('+', '-').replace('/', '_');
    }

    /**
     * Generates a random string 32 characters long
     */
    private String createJti() {
        String validChars = '1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        Integer len = validChars.length();
        String randomString = '';

        for(Integer i=0; i<32; i++) {
            Integer rInt = Integer.valueOf(Math.rint(Math.random()*(len-1)));
            randomString += validChars.substring(rInt, rInt+1);
        }
        return randomString;
    }

    public override String getClientId() {
        return this.clientId;
    }

    public override String getClientSecret() {
        return this.clientSecret;
    }

    public override String getUserAgent() {
        return this.userAgent;
    }

    public override void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public override void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public override String getRefreshToken() {
        return this.refreshToken;
    }

    public override void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }

    public override String getTokenUrl() {
        return this.tokenUrl;
    }

    public override void setTokenUrl(String tokenUrl) {
        this.tokenUrl = tokenUrl;
    }

    public override String getBaseUrl() {
        return this.baseUrl;
    }

    public override void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    public override String getBaseUploadUrl() {
        return this.baseUploadUrl;
    }

    public override void setBaseUploadUrl(String baseUploadUrl) {
        this.baseUploadUrl = baseUploadUrl;
    }

    public override Boolean getAutoRefresh() {
        return this.autoRefresh;
    }

    public override void setAutoRefresh(Boolean autoRefresh) {
        this.autoRefresh = autoRefresh;
    }

    public override Integer getMaxRequestAttempts() {
        return this.maxRequestAttempts;
    }

    public override void setMaxRequestAttempts(Integer maxRequestAttempts) {
        this.maxRequestAttempts = maxRequestAttempts;
    }

    public override Integer getTimeout() {
        return this.timeout;
    }

    public override void setTimeout(Integer timeout) {
        this.timeout = timeout;
    }

    public override Long getLastRefresh() {
        return this.lastRefresh;
    }

    public override void setLastRefresh(Long lastRefresh) {
        this.lastRefresh = lastRefresh;
    }

    public override Long getExpires() {
        return this.expires;
    }

    public override void setExpires(Long expires) {
        this.expires = expires;
    }
}