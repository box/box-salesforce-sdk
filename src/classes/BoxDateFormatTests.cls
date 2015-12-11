@IsTest
public class BoxDateFormatTests {
    public static testmethod void testParseBoxDateTimeString() {
        String dateTimeString = '2012-12-12T10:55:30-07:00';
        DateTime parsedDateTime = BoxDateFormat.parseBoxDateTimeString(dateTimeString);
        DateTime generatedDateTime = DateTime.newInstanceGMT(2012, 12, 12, 17, 55, 30);
        System.assertEquals(generatedDateTime, parsedDateTime);
    }
    
    public static testmethod void testGetBoxDateTimeString() {
        DateTime generatedDateTime = DateTime.newInstanceGMT(2012, 12, 12, 17, 55, 30);
        String parsedDateTimeString = BoxDateFormat.getBoxDateTimeString(generatedDateTime);
        DateTime parsedDateTime = BoxDateFormat.parseBoxDateTimeString(parsedDateTimeString);
        System.assertEquals(generatedDateTime, parsedDateTime);
    }
    
    public static testmethod void testGetBoxDateTimeStringNull() {
    	System.assertEquals(null, BoxDateFormat.getBoxDateTimeString(null));
    }
}