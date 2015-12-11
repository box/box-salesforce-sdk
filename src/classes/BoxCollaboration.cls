/**
 * Represents a collaboration between a user and another user or group. Collaborations are Box's equivalent of access
 * control lists. They can be used to set and apply permissions for users or groups to folders.
 *
 */

public class BoxCollaboration extends BoxResource {

    private static final String COLLABORATIONS_URL_TEMPLATE = 'collaborations';
    private static final String PENDING_COLLABORATIONS_URL = 'collaborations?status=pending';
    private static final String COLLABORATION_URL_TEMPLATE = 'collaborations/{0}';

    /**
     * Constructs a BoxCollaboration for a collaboration with a given ID.
     *
     * @param  api the API connection to be used by the collaboration.
     * @param  id  the ID of the collaboration.
     */
    public BoxCollaboration(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'collaboration';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxCollaboration.Info) jsonObject;
    }

    /**
     * Gets all pending collaboration invites for the current user.
     *
     * @param  api the API connection to use.
     * @return     a collection of pending collaboration infos.
     */
    public static list<BoxCollaboration.Info> getPendingCollaborations(BoxApiConnection api) {
        list<BoxCollaboration.Info> pendingCollabs = new list<BoxCollaboration.Info>();
        String url = api.baseUrl + PENDING_COLLABORATIONS_URL;

        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_GET);
        request.addJsonContentTypeHeader();
        request.setTimeout(api.timeout);

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxCollaboration.getPendingCollaborations');

        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(response.getBody());
        if (responseObject.getValue('total_count') != null) {
            Integer totalCount = Integer.valueOf(responseObject.getValue('total_count'));
            list<String> pendingCollabStrings = BoxJsonObject.parseJsonObjectArray(responseObject.getValue('entries'));
            for (String collabString : pendingCollabStrings) {
                BoxCollaboration.Info collab = new BoxCollaboration.Info(collabString);
                pendingCollabs.add(collab);
            }
            System.assertEquals(totalCount, pendingCollabs.size());
        }
        return pendingCollabs;
    }

    /**
     * Gets information about this collaboration.
     * 
     * @return info about this collaboration.
     */
    public BoxCollaboration.Info getCollaboration() {
        String url = this.api.baseURl + String.format(COLLABORATION_URL_TEMPLATE, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxCollaboration.getCollaboration');
        return new BoxCollaboration.Info(responseBody);
    }

    /**
     * Updates the information about this collaboration with any info fields that have been modified locally.
     *
     * @param role BoxCollaboration.Role which needs to be updated.
     */
    public BoxCollaboration.Info updateCollaboration(BoxCollaboration.Role role) {
        String roleString = BoxCollaboration.getRoleAsString(role);
        if (roleString == null) {
            throw new BoxResource.BoxResourceException('BoxCollaboration.Role passed to BoxCollaboration.updateCollaboration was null or invalid.');
        }

        String url = this.api.baseURl + String.format(COLLABORATION_URL_TEMPLATE, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        BoxGenericJsonObject newAccess = new BoxGenericJsonObject();
        newAccess.addValue('role', roleString);
        request.setBody(newAccess.getJsonString());
        
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxCollaboration.updateCollaboration');
        return new BoxCollaboration.Info(responseBody);
    }

    /**
     * Deletes this collaboration.
     */
    public Boolean deleteCollaboration() {
        String url = this.api.baseURl + String.format(COLLABORATION_URL_TEMPLATE, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_DELETE);
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        return BoxApiRequest.ensureBoxResourceResponseCode(response, 'BoxCollaboration.deleteCollaboration', new set<Integer> {204});
    }

    /**
     * Contains information about a BoxCollaboration.
     */
    public class Info extends BoxResource.Info {

        public BoxUser.Info createdBy {get; private set;}
        public DateTime createdAt {get; private set;}
        public DateTime modifiedAt {get; private set;}
        public DateTime expiresAt {get; private set;}
        public Status status {get; private set;}
        public BoxCollaborator.Info accessibleBy {get; private set;}
        public Role role {get; private set;}
        public DateTime acknowledgedAt {get; private set;}
        public BoxFolder.Info item {get; private set;}

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
                this.rebuildJsonString = true;
            }
        }

        public override void addValue(String key, BoxJsonObject value) {
            this.addValue(key, value.getJsonString());
        }

        private void parseMember(String key, String value) {
            super.parseResourceMember(key, value);
            if (key != null) {
                if (key == 'created_by') {
                    this.createdBy = new BoxUser.Info(value);
                } else if (key == 'created_at') {
                    this.createdAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'modified_at') {
                    this.modifiedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'expires_at') {
                    this.expiresAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if ( key == 'status') {
                    this.status = BoxCollaboration.parseStatus(value.toLowerCase());
                } else if (key == 'accessible_by') {
                    this.accessibleBy = (BoxCollaborator.Info) BoxResource.parseBoxResource(value);
                } else if (key == 'role') {
                    this.role = BoxCollaboration.parseRole(value);
                } else if (key == 'acknowledged_at') {
                    this.acknowledgedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if ( key == 'item') {
                    this.item = new BoxFolder.Info(value);
                }
            }
        }
     }

      /**
       * Enumerates the possible statuses that a collaboration can have.
       */
      public enum Status {
        /**
         * The collaboration has been accepted.
         */
        ACCEPTED,

        /**
         * The collaboration is waiting to be accepted or rejected.
         */
        PENDING,

        /**
         * The collaboration has been rejected.
         */
        REJECTED
    }

    /**
     * Enumerates the possible access levels that a collaborator can have.
     */
    public enum Role {
        /**
         * An Editor has full read/write access to a folder. Once invited to a folder, they will be able to view,
         * download, upload, edit, delete, copy, move, rename, generate shared links, make comments, assign tasks,
         * and invite/remove collaborators. They will not be able to delete or move root level folders.
         */
        EDITOR,

        /**
         * The viewer role has full read access to a folder. Once invited to a folder, they will be able to preview,
         * download, make comments, and generate shared links.  They will not be able to invite new
         * collaborators, upload, edit, or delete items in the folder.
         */
        VIEWER,

        /**
         * The previewer role has limited read access to a folder. They will only be able to preview the items in the
         * folder using the integrated content viewer. They will not be able to share, upload, edit, or delete any
         * content. This role is only available to enterprise accounts.
         */
        PREVIEWER,

        /**
         * The uploader has limited write access to a folder. They will only be able to upload and see the names of the
         * items in a folder. They will not able to download or view any content. This role is only available to
         * enterprise accounts.
         */
        UPLOADER,

        /**
         * The previewer-uploader role is a combination of previewer and uploader. A user with this access level will be
         * able to preview files using the integrated content viewer as well as upload items into the folder. They will
         * not be able to download, edit, or share, items in the folder. This role is only available to enterprise
         * accounts.
         */
        PREVIEWER_UPLOADER,

        /**
         * The viewer-uploader role is a combination of viewer and uploader. A viewer-uploader has full read access to a
         * folder and limited write access. They are able to preview, download, add comments, generate shared links, and
         * upload content to the folder. They will not be able to invite new collaborators, edit, or delete
         * items in the folder. This role is only available to enterprise accounts.
         */
        VIEWER_UPLOADER,

        /**
         * The co-owner role has all of the functional read/write access that an editor does. This permission level has
         * the added ability of being able to manage users in the folder. A co-owner can add new collaborators, change
         * access levels of existing collaborators, and remove collaborators. However, they will not be able to
         * manipulate the owner of the folder or transfer ownership to another user. This role is only available to
         * enterprise accounts.
         */
        CO_OWNER,

        /**
         * The owner role has all of the functional capabilities of a co-owner. However, they will be able to manipulate
         * the owner of the folder or transfer ownership to another user. This role is only available to enterprise
         * accounts.
         */
        OWNER
    }

    public static String getRoleAsString(BoxCollaboration.Role role) {
        if (role == BoxCollaboration.Role.EDITOR) {
            return 'editor';
        } else if (role == BoxCollaboration.Role.VIEWER) {
            return 'viewer';
        } else if (role == BoxCollaboration.Role.PREVIEWER) {
            return 'previewer';
        } else if (role == BoxCollaboration.Role.UPLOADER) {
            return 'uploader';
        } else if (role == BoxCollaboration.Role.PREVIEWER_UPLOADER) {
            return 'previewer uploader';
        } else if (role == BoxCollaboration.Role.VIEWER_UPLOADER) {
            return 'viewer uploader';
        } else if (role == BoxCollaboration.Role.CO_OWNER) {
            return 'co-owner';
        } else if (role == BoxCollaboration.Role.OWNER) {
            return 'owner';
        }
        return null;
    }

    public static BoxCollaboration.Role parseRole(String value) {
        if (value == 'editor') {
            return BoxCollaboration.Role.EDITOR;
        } else if (value == 'viewer') {
            return BoxCollaboration.Role.VIEWER;
        } else if (value == 'previewer') {
            return BoxCollaboration.Role.PREVIEWER;
        } else if (value == 'uploader') {
            return BoxCollaboration.Role.UPLOADER;
        } else if (value == 'previewer uploader') {
            return BoxCollaboration.Role.PREVIEWER_UPLOADER;
        } else if (value == 'viewer uploader') {
            return BoxCollaboration.Role.VIEWER_UPLOADER;
        } else if (value == 'co-owner') {
            return BoxCollaboration.Role.CO_OWNER;
        } else if (value == 'owner') {
            return BoxCollaboration.Role.OWNER;
        }
        return null;
    }

    public static BoxCollaboration.Status parseStatus(String value) {
        if (value == 'accepted') {
            return BoxCollaboration.Status.ACCEPTED;
        } else if (value == 'pending') {
            return BoxCollaboration.Status.PENDING;
        } else if (value == 'rejected') {
            return BoxCollaboration.Status.REJECTED;
        }
         return null;
    }
}