/**
 * Represents a Box user's email alias.
 */

public class BoxEmailAlias extends BoxResource {

    /**
     * Constructs a BoxEmailAlias with a given ID.
     *
     * @param  api the API connection to be used by the email alias.
     * @param  id  the ID of the email alias.
     */
    public BoxEmailAlias(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'emailalias';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxEmailAlias.Info) jsonObject;
    }

    /**
     * Contains information about a BoxEmailAlias.
     */
    public class Info extends BoxResource.Info {

        public Boolean isConfirmed {get; private set;}
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

        public void parseMember(String key, String value) {
            super.parseResourceMember(key, value);
            if (key != null) {
                if (key == 'is_confirmed') {
                    this.isConfirmed = Boolean.valueOf(value);
                } else if (key == 'email') {
                    this.email = value;
                }
            }
        }
    }
}