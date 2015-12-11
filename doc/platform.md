Box Platform
============

The SDK implements the JWT authentication that is required for making [Box Platform][box-platform]
requests.  Simply instantiate the `BoxPlatformApiConnection` class to 
use as your API connection.
These requests can be made on behalf of an enterprise or a specific
app user.  Once authenticated, any API calls are called the same way they would
be for an enterprise user.

How to Authenticate
-------------------
* [Create your API key.][box-platform]
* [Generate your RSA Keypair][rsa-generation] (take note of your Key ID that Box generates for you)
* Salesforce doesn't handle encrypted private keys so you have to run `openssl pkcs8 -topk8 -nocrypt -in your_private_key.pem -outform PEM` in your terminal.
* Remove all whitespace (new lines), the `-----BEGIN PRIVATE KEY-----`, and the `-----END PRIVATE KEY-----`.  This final value will be the private key you use to authenticate.

The following example creates an enterprise Platform API connection:

```java
String enterpriseId = 'YOUR_ENTERPRISE_ID';
String publicKeyId = 'YOUR_PUBLIC_KEY_ID';
String privateKey = 'YOUR_PRIVATE_KEY';
String clientId = 'YOUR_CLIENT_ID';
String clientSecret = 'YOUR_CLIENT_SECRET';

BoxJwtEncryptionPreferences preferences = new BoxJwtEncryptionPreferences();
preferences.setPublicKeyId(publicKeyId);
preferences.setPrivateKey(privateKey);
BoxPlatformApiConnection api = BoxPlatformApiConnection.getAppEnterpriseConnection(enterpriseId, clientId, clientSecret, preferences);
```


Alternatively, you can create a user Platform API connection with the following:

```java
String userId = 'YOUR_USER_ID';
String publicKeyId = 'YOUR_PUBLIC_KEY_ID';
String privateKey = 'YOUR_PRIVATE_KEY';
String clientId = 'YOUR_CLIENT_ID';
String clientSecret = 'YOUR_CLIENT_SECRET';

BoxJwtEncryptionPreferences preferences = new BoxJwtEncryptionPreferences();
preferences.setPublicKeyId(publicKeyId);
preferences.setPrivateKey(privateKey);
BoxPlatformApiConnection api = BoxPlatformApiConnection.getAppUserConnection(userId, clientId, clientSecret, preferences);
```


Auto-Refresh
------------

`BoxPlatformApiConnection` will always automatically refresh the access token if
it has expired.  There is no way to disable the auto-refresh functionality.



[box-platform]:https://box-content.readme.io/docs/box-platform
[rsa-generation]:https://box-content.readme.io/docs/app-auth