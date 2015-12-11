@isTest
public class BoxGenericJsonObjectTests {
    public static testmethod void testBoxGenericJsonObjectConstructors() {
        String jsonResponse = '{"access_token":"T9cE5asGnuyYCCqIZFoWjFHvNbvVqHjl","expires_in":3600,"restricted_to":[],"token_type":"bearer","refresh_token":"J7rxTiWOHMoSC1isKZKBZWizoRXjkQzig5C6jFgCVJ9bUnsUfGMinKBDLZWP9BgR"}';
        Test.startTest();
        BoxGenericJsonObject responseFromJsonString = new BoxGenericJsonObject(jsonResponse);
        BoxGenericJsonObject responseFromNoParams = new BoxGenericJsonObject();
        BoxGenericJsonObject responseFromJsonObject = new BoxGenericJsonObject(responseFromJsonString);
        Test.stopTest();
        
        System.assertEquals(responseFromJsonString.getValue('access_token'), responseFromJsonObject.getValue('access_token'));
        System.assert(responseFromNoParams.children.size() == 0);
    }
}