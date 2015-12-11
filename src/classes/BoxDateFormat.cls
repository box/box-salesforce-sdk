/*
 * Contains methods for parsing and formatting DateTimes for use with the Box API
 * format of Box DateTime returned from the API is "yyyy-MM-dd'T'hh:mm:ss'Z'"
 */

public class BoxDateFormat {

    public static DateTime parseBoxDateTimeString(String dateString) {
        if (dateString == null || dateString == '' || dateString == 'null') {
            return null;
        }
        return (DateTime) json.deserialize('"' + dateString + '"', DateTime.class);
    }

    public static String getBoxDateTimeString(DateTime dateTimeValue) {
        if (dateTimeValue == null) {
            return null;
        }
        return dateTimeValue.format('yyyy-MM-dd\'T\'HH:mm:ssZ');
    }
}