@IsTest
public class BoxEmailAliasTests {
	public static testmethod void testParseMember() {
        BoxApiConnection api = new BoxApiConnection('accesstoken');
		BoxEmailAlias boxEmailAlias = new BoxEmailAlias(api,'10543463');
		BoxEmailAlias.Info emailAliasInfo = new BoxEmailAlias.Info();
		emailAliasInfo.addValue('email', 'test@box.com');
		
		Test.startTest();
		emailAliasInfo.parseMember('is_confirmed', 'true');
		emailAliasInfo.parseMember('email','testEmail@box.com');
        Test.stopTest();

		System.assertEquals(true, emailAliasInfo.isConfirmed);
		System.assertEquals('testEmail@box.com', emailAliasInfo.email);
     }
}