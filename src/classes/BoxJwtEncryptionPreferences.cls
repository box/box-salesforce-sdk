/**
 * Contains the encryption preferences for JWT assertion.
 */

public class BoxJwtEncryptionPreferences {

    private String publicKeyId {get; set;}
    private String privateKey {get; set;}
    private String privateKeyPassword {get; set;}
    private BoxJwtEncryptionPreferences.EncryptionAlgorithm algorithm {get; set;}

    public BoxJwtEncryptionPreferences() {
    }

    /**
     * Returns the ID for public key for validating the JWT signature.
     *
     * @return the publicKeyId.
     */
    public String getPublicKeyId() {
        return this.publicKeyId;
    }

    /**
     * Sets the ID for public key for validating the JWT signature.
     *
     * @param publicKeyId the publicKeyId to set.
     */
    public void setPublicKeyId(String publicKeyId) {
        this.publicKeyId = publicKeyId;
    }

    /**
     * Returns the private key for generating the JWT signature.
     *
     * @return the privateKey.
     */

    public String getPrivateKey() {
        return this.privateKey;
    }

    /**
     * Sets the private key for generating the JWT signature.
     *
     * @param privateKey the privateKey to set.
     */
    public void setPrivateKey(String privateKey) {
        this.privateKey = privateKey;
    }

    /**
     * Returns the password for the private key.
     *
     * @return the privateKeyPassword.
     */

    public String getPrivateKeyPassword() {
        return this.privateKeyPassword;
    }

    /**
     * Sets the password for the private key.
     *
     * @param privateKeyPassword the privateKeyPassword to set.
     */
    public void setPrivateKeyPassword(String privateKeyPassword) {
        this.privateKeyPassword = privateKeyPassword;
    }

    /**
     * Returns the type of encryption algorithm for JWT.
     *
     * @return the encryptionAlgorithm.
     */
    public BoxJwtEncryptionPreferences.EncryptionAlgorithm getEncryptionAlgorithm() {
        return this.algorithm;
    }

    /**
     * Sets the type of encryption algorithm for JWT.
     *
     * @param algorithm the encryptionAlgorithm to set.
     */
    public void setEncryptionAlgorithm(BoxJwtEncryptionPreferences.EncryptionAlgorithm algorithm) {
        this.algorithm = algorithm;
    }

    public enum EncryptionAlgorithm {
        /**
         * RSA with SHA 256.
         */
        RSA_SHA_256,

        /**
         * RSA with SHA 384.
         */
        RSA_SHA_384,

        /**
         * RSA with SHA 512.
         */
        RSA_SHA_512
    }
}