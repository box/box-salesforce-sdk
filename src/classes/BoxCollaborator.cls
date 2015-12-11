/**
 * The abstract base class for types that can be added to collaborations.
 */

public abstract class BoxCollaborator extends BoxResource {

    /**
     * Constructs a BoxCollaborator for a collaborator with a given ID.
     *
     * @param  api the API connection to be used by the collaborator.
     * @param  id  the ID of the collaborator.
     */
    public BoxCollaborator(BoxApiConnection api, String id) {
        super(api, id);
    }

    /**
     * Contains information about a BoxCollaborator.
     */
    public abstract class Info extends BoxResource.Info {
        public String name {get; protected set;}
        public DateTime createdAt {get; protected set;}
        public DateTime modifiedAt {get; protected set;}

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
        }

       /**
        * Constructs an Info object using an already parsed JSON object.
        *
        * @param  jsonObject the parsed JSON object.
        */
        public Info(BoxJsonObject jsonObject) {
            super(jsonObject);
        }

        protected void parseCollaboratorMember(String key, String value) {
            super.parseResourceMember(key, value);
            if (key != null) {
                if (key == 'name') {
                    this.name = value;
                } else if (key == 'created_at') {
                    this.createdAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'modified_at') {
                    this.modifiedAt = BoxDateFormat.parseBoxDateTimeString(value);
                }
            }
        }
    }
}