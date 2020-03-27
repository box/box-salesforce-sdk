@isTest
public class BoxBase64Tests {
    // These test strings when EncodingUtil.Base64Encode(Blob.valueOf(String)) end with '==', '=', and neither (respectively).
    public static String[] testStrings = new List<String>{
        'abcdefg',
        'abcdefg*',
        'abcdefg**'
    };

    public static testMethod void testBuildMultipartFileBody() {
        for (String fileBodyAsString : testStrings) {
            Blob fileBody = Blob.valueOf(fileBodyAsString);
            String fileName = 'testFile.txt';
            String boundary = 'awo4etbnaporiuvbhaet4';
            Blob multipartBody = BoxBase64.buildMultipartFileBody(
                fileBody,
                fileName,
                boundary
            );
        }
    }

    public static testMethod void testPrepareStringForBase64Decoding() {
        for (String testString : testStrings) {
            Blob testStringAsBlob = Blob.valueOf(testString);
            String encodedTestString = EncodingUtil.base64Encode(
                testStringAsBlob
            );
            String preparedString = BoxBase64.prepareStringForBase64Decoding(
                encodedTestString
            );
        }
    }
}
