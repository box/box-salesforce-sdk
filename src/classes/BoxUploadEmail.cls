/**
 * Represents an email address that can be used to upload files to a folder on Box.
 */

public class BoxUploadEmail extends BoxResource {

    /**
     * Constructs a BoxUploadEmail for an item with a given ID.
     *
     * @param  api the API connection to be used by the item.
     * @param  id  the ID of the item.
     */
    public BoxUploadEmail(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'uploademail';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxUploadEmail.Info) jsonObject;
    }

    /**
     * Info about BoxUploadEmail
     */
    public class Info extends BoxResource.Info {

        public BoxUploadEmail.Access access {get; private set;}
        public String email {get; private set;}

        /**
         * Constructs an empty Info object.
         */
        public Info() {
            super();
        }

        /**
         * Constructs an Info object by parsing information from a JSON string.
         *
         * @param  json the JSON string to parse.
         */
        public Info(String jsonString) {
            super(jsonString);
            for (String key : this.children.keySet()) {
                this.parseMember(key, this.children.get(key));
            }
        }

        /**
         * Constructs an Info object using an already parsed JSON object.
         *
         * @param  jsonObject the parsed JSON object.
         */
        public Info(BoxJsonObject jsonObject) {
            super(jsonObject);
            for (String key : this.children.keySet()) {
                this.parseMember(key, this.children.get(key));
            }
        }

        public override void addValue(String key, String value) {
            super.addValue(key, value);
            if (key != null) {
                this.parseMember(key, value);
            }
        }

        public override void addValue(String key, BoxJsonObject value) {
            this.addValue(key, value.getJsonString());
        }

        @testvisible
        private void parseMember(String key, String value) {
            super.parseResourceMember(key, value);
            if (key != null) {
                if (key == 'access') {
                    this.access = BoxUploadEmail.parseAccess(value);
                } else if (key == 'email') {
                    this.email = value;
                }
            }
        }
    }

    /**
     * Enumerates the possible access levels that can be set on an upload email.
     */
    public enum Access {
        /**
         * Anyone can send an upload to this email address.
         */
        OPEN,

        /**
         * Only collaborators can send an upload to this email address.
         */
        COLLABORATORS
    }

    public static BoxUploadEmail.Access parseAccess(String value) {
        if (value == 'open') {
            return BoxUploadEmail.Access.OPEN;
        } else if (value == 'collaborators') {
            return BoxUploadEmail.Access.COLLABORATORS;
        }
        return null;
    }

    public static String getAccessAsString(BoxUploadEmail.Access value) {
        if (value == BoxUploadEmail.Access.OPEN) {
            return 'open';
        } else if (value == BoxUploadEmail.Access.COLLABORATORS) {
            return 'collaborators';
        }
        return null;
    }
}