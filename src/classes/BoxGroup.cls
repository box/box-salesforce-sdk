/**
 * Represents a set of Box users.
 */

public class BoxGroup extends BoxCollaborator {

    private static final String CREATE_GROUP_URL = 'groups';
    private static final String GROUP_INFO_URL = 'groups/{0}';

    /**
     * Constructs a BoxGroup for a group with a given ID.
     *
     * @param  api the API connection to be used by the group.
     * @param  id  the ID of the group.
     */
    public BoxGroup(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'group';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxGroup.Info) jsonObject;
    }

    public static BoxGroup.Info createGroup(BoxApiConnection api, String groupName) {
        return createGroup(api, groupName, null, null, null, null, null);
    }

    /**
     * Creates a new group with a specified name.
     *
     * @param  api  the API connection to be used by the group.
     * @param  name the name of the new group.
     * @return      info about the created group.
     */
    public static BoxGroup.Info createGroup(BoxApiConnection api, String groupName, String provenance, String externalSyncIdentifier, String description, String invitabilityLevel, String memberViewabilityLevel) {
        BoxApiRequest request = new BoxApiRequest(api, api.baseUrl + CREATE_GROUP_URL, BoxApiRequest.METHOD_POST);
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        BoxGenericJsonObject params = new BoxGenericJsonObject();
        params.addValue('name', groupName);
        if(provenance !=null) {
            params.addValue('provenance', provenance);
        }
        if(externalSyncIdentifier !=null) {
            params.addValue('external_sync_identifier', externalSyncIdentifier);
        }
        if(description !=null) {
            params.addValue('description', description);
        }
        if(invitabilityLevel !=null) {
            params.addValue('invitability_level', invitabilityLevel);
        }
        if(memberViewabilityLevel !=null) {
            params.addValue('member_viewability_level', memberViewabilityLevel);
        }

        request.setBody(params.getJsonString());
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxGroup.create');
        return new BoxGroup.Info(responseBody);
    }

    /**
     * Gets the information about this group.
     *
     * @return     information about group.
     */
    public BoxGroup.Info getGroup() {
        String url = this.api.baseUrl + String.format(GROUP_INFO_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxGroup.getGroup');
        return new BoxGroup.Info(responseBody);
    }

    /**
     * Updates the information about this group.
     *
     * @param api       the API connection to be used by the group.
     * @param groupName name of the group
     * @return          information about group.
     */
    public static BoxGroup.Info updateGroup(BoxApiConnection api, String groupName) {
        return updateGroup(api, groupName, null, null, null, null, null);
    }

    /**
     * Updates the information about this group.
     *
     * @param groupName              name of the group
     * @param provenance             used to track the external source where the group is coming from.
     * @param externalSyncIdentifier used as a group identifier for groups coming from an external source.
     * @param description            description of the group.
     * @param invitabilityLevel      all_managed_users, specifies who can invite this group to folders.
     * @param memberViewabilityLevel all_managed_users, specifies who can view the members of this group.
     * @return                       information about group.
     */
    public static BoxGroup.Info updateGroup(BoxApiConnection api, String groupName, String provenance, String externalSyncIdentifier, String description, String invitabilityLevel, String memberViewabilityLevel) {
        BoxApiRequest request = new BoxApiRequest(api, api.baseUrl + GROUP_INFO_URL, BoxApiRequest.METHOD_PUT);
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        BoxGenericJsonObject params = new BoxGenericJsonObject();
        params.addValue('name', groupName);
            if(provenance !=null) {
            params.addValue('provenance', provenance);
        }
        if(externalSyncIdentifier !=null) {
            params.addValue('external_sync_identifier', externalSyncIdentifier);
        }
        if(description !=null) {
            params.addValue('description', description);
        }
        if(invitabilityLevel !=null) {
            params.addValue('invitability_level', invitabilityLevel);
        }
        if(memberViewabilityLevel !=null) {
            params.addValue('member_viewability_level', memberViewabilityLevel);
        }

        request.setBody(params.getJsonString());
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxGroup.updateGroup');
        return new BoxGroup.Info(responseBody);
    }

    /**
     * Deletes this group.
     *
     * @return true if group is deleted succesfully, false otherwise.
     */
    public Boolean deleteGroup() {
        String url = this.api.baseUrl + String.format(GROUP_INFO_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_DELETE);

        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        return BoxApiRequest.ensureBoxResourceResponseCode(response, 'BoxFile.deleteGroup', new set<Integer> {204});
    }

    /**
     * Informationa about BoxGroup
     */
    public class Info extends BoxCollaborator.Info {

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
    }
}
