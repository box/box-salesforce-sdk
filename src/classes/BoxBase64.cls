public class BoxBase64 {

    /**
     * Appends the proper chars to the end of a string to base64Decode it
     */
    public static String prepareStringForBase64Decoding(String stringToPrepare) {
        String last4Bytes = stringToPrepare.substring(stringToPrepare.length() - 4, stringToPrepare.length());
        if (last4Bytes.endsWith('==')) {
            last4Bytes = last4Bytes.substring(0, 2) + '0K';
            stringToPrepare = stringToPrepare.substring(0, stringToPrepare.length() - 4) + last4Bytes;
        } else if (last4Bytes.endsWith('=')) {
            last4Bytes = last4Bytes.substring(0, 3) + 'N';
            stringToPrepare = stringToPrepare.substring(0, stringToPrepare.length() - 4) + last4Bytes;
        }
        return stringToPrepare;
    }

    /**
     * Appends the proper chars to a file body to create a multipart request body and base64Decode it
     */
    public static Blob buildMultipartFileBody(Blob fileBody, String fileName, String boundary) {
        String header = '--' + boundary + '\nContent-Disposition: form-data; name="file"; filename="' + fileName +
                        '";\nContent-Type: application/octet-stream';
        String footer = '--'+boundary+'--';
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        String footerEncoded;
        while (headerEncoded.endsWith('=')){
            header += ' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        String bodyEncoded = EncodingUtil.base64Encode(fileBody);
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length() - 4, bodyEncoded.length());
        if (last4Bytes.endsWith('==')) {
            last4Bytes = last4Bytes.substring(0, 2) + '0K';
            bodyEncoded = bodyEncoded.substring(0, bodyEncoded.length() - 4) + last4Bytes;
            footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        } else if (last4Bytes.endsWith('=')) {
            last4Bytes = last4Bytes.substring(0, 3) + 'N';
            bodyEncoded = bodyEncoded.substring(0, bodyEncoded.length() - 4) + last4Bytes;
            footer = '\n' + footer;
            footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        } else {
            footer = '\r\n' + footer;
            footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
        }
        Blob bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded + footerEncoded);
        return bodyBlob;
    }
}