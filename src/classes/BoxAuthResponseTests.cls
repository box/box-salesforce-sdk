@isTest
public class BoxAuthResponseTests {
    public static testmethod void testBoxAuthResponseConstructors() {
        String jsonResponse = '{"access_token":"T9cE5asGnuyYCCqIZFoWjFHvNbvVqHjl","expires_in":3600,"restricted_to":[],"token_type":"bearer","refresh_token":"J7rxTiWOHMoSC1isKZKBZWizoRXjkQzig5C6jFgCVJ9bUnsUfGMinKBDLZWP9BgR"}';
        Test.startTest();
        BoxAuthResponse responseFromJsonString = new BoxAuthResponse(jsonResponse);
        BoxAuthResponse responseFromNoParams = new BoxAuthResponse();
        BoxAuthResponse responseFromJsonObject = new BoxAuthResponse(responseFromJsonString);
        Test.stopTest();
        
        System.assertEquals(responseFromJsonString.getValue('access_token'), responseFromJsonObject.getValue('access_token'));
        System.assert(responseFromNoParams.children.size() == 0);
    }
}