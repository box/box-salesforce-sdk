/**
 * The abstract base class for all resource types (files, folders, comments, collaborations, etc.) used by the Box API
 *
 * Every API resource has an ID and a BoxApiConnection that it uses to communicate with the Box API.
 * Some resources also have an associated Info class that contains information about the resource
 */

public abstract class BoxResource {
    public final BoxApiConnection api {get; private set;}
    public final String id {get; private set;}
    protected Info information;

    public final static String NULL_RESPONSE_EXCEPTION_TEMPLATE = 'HttpResponse from Box API for {0} was null.';
    public final static String NULL_BODY_EXCEPTION_TEMPLATE = 'HttpResponse from Box API for {0} had no body.';

    /**
     * Constructs a BoxResource for a resource with a given ID.
     *
     * @param  api the API connection to be used by the resource.
     * @param  id  the ID of the resource.
     */
    public BoxResource(BoxApiConnection api, String id) {
        this.api = api;
        this.id = id;
    }

    public static BoxResource parseInfo(BoxApiConnection api, BoxJsonObject jsonObject) {
        String type = jsonObject.getValue('type');
        String id = jsonObject.getValue('id');
        // ToDo update the implementation to return .Info objects 
        //      don't do this.  this method should return BoxResource top level objects.
        //      This method takes a .Info object and determines what type of object it can become.
        // TODO - add all possible values here after implementations are done.
        //        Having this uncommented during development causes compilation issues
        if (type == 'folder') {
            BoxFolder folder = new BoxFolder(api, id);
            folder.setInfo(jsonObject);
            return folder;
        } else if (type == 'file') {
            BoxFile file = new BoxFile(api, id);
            file.setInfo(jsonObject);
            return file;
        }
        return null;
    }

    /**
     * Parses string into BoxResource.Info object.
     *
     * @param  value string to be parsed.
     * @return information about the BoxResource based on the resourceType.
     */
    public static BoxResource.Info parseBoxResource(String value) {
        BoxGenericJsonObject jsonObject = new BoxGenericJsonObject(value);
        String resouceType = jsonObject.getValue('type');
        String id = jsonObject.getValue('id');

        if (resouceType == 'folder') {
            return new BoxFolder.Info(jsonObject);
        } else if (resouceType == 'file') {
            return new BoxFile.Info(jsonObject);
        } else if(resouceType == 'comment') {
            return new BoxComment.Info(jsonObject);
        } else if(resouceType == 'collaboration') {
            return new BoxCollaboration.Info(jsonObject);
        } else if(resouceType == 'user') {
            return new BoxUser.Info(jsonObject);
        } else if(resouceType == 'group') {
            return new BoxGroup.Info(jsonObject);
        }
        return null;
    }

    /**
     * Gets the API connection used by this resource.
     *
     * @return the API connection used by this resource.
     */
    public BoxApiConnection getApi() {
        return this.api;
    }

    /**
     * Gets the ID of this resource.
     *
     * @return the ID of this resource.
     */
    public String getId() {
        return this.id;
    }

    public BoxJsonObject getInfo() {
        return (BoxResource.Info) information;
    }

    public abstract void setInfo(BoxJsonObject jsonObject);

    public abstract String getObjectType();

    /**
     * Indicates whether this BoxResource is equal to another BoxResource. Two BoxResources are equal if they have the
     * same type and ID.
     *
     * @param  other the other BoxResource to compare.
     * @return       true if the type and IDs of the two resources are equal; otherwise false.
     */
    public Boolean equalTo(BoxResource other) {
        if (other == null) {
            return false;
        }
        return (other.getObjectType() == this.getObjectType() && other.getId() == this.getId());
    }

    /**
     * Information about BoxRsource.
     */
    public abstract class Info extends BoxJsonObject {

        public String id {get; protected set;}
        public String type {get; protected set;}

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

        protected void parseResourceMember(String key, String value) {
            if (key != null) {
                if (key == 'id') {
                    this.id = value;
                } else if (key == 'type') {
                    this.type = value;
                }
            }
        }
    }

    public class BoxResourceException extends Exception {}
    public class BoxResourceNullResponseException extends Exception {}
    public class BoxResourceNullBodyException extends Exception {}
}