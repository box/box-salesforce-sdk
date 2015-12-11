@isTest
public class BoxJwtEncryptionPreferencesTests {
	public static testmethod void testGettersAndSetters() {
		String publicKeyId = 'publickeyid';
		String privateKey = 'privatekey';
		String privateKeyPassword = 'privatekeypassword';
		BoxJwtEncryptionPreferences.EncryptionAlgorithm algorithm = BoxJwtEncryptionPreferences.EncryptionAlgorithm.RSA_SHA_256;
		BoxJwtEncryptionPreferences prefs = new BoxJwtEncryptionPreferences();
		prefs.setEncryptionAlgorithm(algorithm);
		prefs.setPrivateKey(privateKey);
		prefs.setPrivateKeyPassword(privateKeyPassword);
		prefs.setPublicKeyId(publicKeyId);
		
		System.assertEquals(algorithm, prefs.getEncryptionAlgorithm());
		System.assertEquals(privateKey, prefs.getPrivateKey());
		System.assertEquals(privateKeyPassword, prefs.getPrivateKeyPassword());
		System.assertEquals(publicKeyId, prefs.getPublicKeyId());
	}
}