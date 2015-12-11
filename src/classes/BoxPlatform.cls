public class BoxPlatform {

    /**
     * Enum to represent the JWT entity type for BoxPlatformApiConnection.
     */
    public enum PlatformEntityType {
        /**
         * Represents the entity type enterprise.
         */
        ENTERPRISE,

        /**
         * Represents the entity type user.
         */
        USER
    }

    public static BoxPlatform.PlatformEntityType parsePlatformEntityType(String value) {
        if (value == 'enterprise') {
            return BoxPlatform.PlatformEntityType.ENTERPRISE;
        } else if (value == 'user') {
            return BoxPlatform.PlatformEntityType.USER;
        }
        return null;
    }

    public static String getPlatformEntityTypeAsString(BoxPlatform.PlatformEntityType value) {
        if (value == BoxPlatform.PlatformEntityType.ENTERPRISE) {
            return 'enterprise';
        } else if (value == BoxPlatform.PlatformEntityType.USER) {
            return 'user';
        }
        return null;
    }
}