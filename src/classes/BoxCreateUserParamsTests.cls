@isTest
public class BoxCreateUserParamsTests {
	public static testmethod void testGettersAndSetters() {
		Boolean canSeeManagedUsers = true;
		Boolean isExemptFromDeviceLimits = true;
		Boolean isExemptFromLoginVerification = false;
		Boolean isPlatformAccessOnly = false;
		Boolean isSyncEnabled = true;
		BoxUser.Role role = BoxUser.Role.USER;
		BoxUser.Status status = BoxUser.Status.ACTIVE;
		Long spaceAmount = 500;
		String address = 'address';
		String jobTitle = 'no title';
		String language = 'spanish';
		String phone = '1234567';
		String timezone = 'America/Los_Angeles';
		
		
		BoxCreateUserParams params = new BoxCreateUserParams();
		params.canSeeManagedUsers = canSeeManagedUsers;
		params.isExemptFromDeviceLimits = isExemptFromDeviceLimits;
		params.isExemptFromLoginVerification = isExemptFromLoginVerification;
		params.isPlatformAccessOnly = isPlatformAccessOnly;
		params.isSyncEnabled = isSyncEnabled;
		params.role = role;
		params.status = status;
		params.spaceAmount = spaceAmount;
		params.address = address;
		params.jobTitle = jobTitle;
		params.language = language;
		params.phone = phone;
		params.timezone = timezone;
		
		System.assertEquals(canSeeManagedUsers, params.canSeeManagedUsers);
		System.assertEquals(isExemptFromDeviceLimits, params.isExemptFromDeviceLimits);
		System.assertEquals(isExemptFromLoginVerification, params.isExemptFromLoginVerification);
		System.assertEquals(isPlatformAccessOnly, params.isPlatformAccessOnly);
		System.assertEquals(isSyncEnabled, params.isSyncEnabled);
		System.assertEquals(role, params.role);
		System.assertEquals(status, params.status);
		System.assertEquals(spaceAmount, params.spaceAmount);
		System.assertEquals(address, params.address);
		System.assertEquals(jobTitle, params.jobTitle);
		System.assertEquals(language, params.language);
		System.assertEquals(phone, params.phone);
		System.assertEquals(timezone, params.timezone);
	}
}