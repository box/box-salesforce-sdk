@isTest
public class BoxPlatformTests {
	public static testmethod void testParsePlatformEntityType() {
		System.assertEquals(BoxPlatform.PlatformEntityType.ENTERPRISE, BoxPlatform.parsePlatformEntityType('enterprise'));
		System.assertEquals(BoxPlatform.PlatformEntityType.USER, BoxPlatform.parsePlatformEntityType('user'));
		System.assertEquals(null, BoxPlatform.parsePlatformEntityType('invalid_value'));
	}
	
	public static testmethod void testGetPlatformEntityTypeAsString() {
		System.assertEquals('enterprise', BoxPlatform.getPlatformEntityTypeAsString(BoxPlatform.PlatformEntityType.ENTERPRISE));
		System.assertEquals('user', BoxPlatform.getPlatformEntityTypeAsString(BoxPlatform.PlatformEntityType.USER));
		System.assertEquals(null, BoxPlatform.getPlatformEntityTypeAsString(null));
	}
}