/**
 * Represents a folder on Box. This class can be used to iterate through a folder's contents, collaborate a folder with
 * another user or group, and perform other common folder operations (move, copy, delete, etc.).
 */
 
public class BoxFolder extends BoxItem{

    public static final list<String> ALL_FIELDS = new list<String> {'type', 'id', 'sequence_id', 'etag', 'name', 'created_at', 'modified_at',
        'description', 'size', 'path_collection', 'created_by', 'modified_by', 'trashed_at', 'purged_at',
        'content_created_at', 'content_modified_at', 'owned_by', 'shared_link', 'folder_upload_email', 'parent',
        'item_status', 'item_collection', 'sync_state', 'has_collaborations', 'permissions',
        'can_non_owners_invite'};

    private static final String CREATE_FOLDER_URL = 'folders';
    private static final String COPY_FOLDER_URL = 'folders/{0}/copy';
    private static final String FOLDER_INFO_URL = 'folders/{0}';
    private static final String DELETE_FOLDER_URL = 'folders/{0}?recursive={1}';
    private static final String ADD_COLLABORATION_URL = 'collaborations';
    private static final String GET_COLLABORATIONS_URL = 'folders/{0}/collaborations';
    private static final String UPLOAD_FILE_URL = 'files/content?parent_id={0}';
    private static final String GET_CHILDREN_URL = 'folders/{0}/items';

    /**
     * Constructs a BoxFolder for a folder with a given ID.
     *
     * @param  api the API connection to be used by the folder.
     * @param  id  the ID of the folder.
     */
    public BoxFolder(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'folder';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = new BoxFolder.Info(jsonobject);
    }

    /**
     * Gets the current user's root folder
     *
     * @param BoxApiConnection api The API connection to be used for the folder
     * @return BoxFolder The user's root folder
     */
    public static BoxFolder getRootFolder(BoxApiConnection api) {
        return new BoxFolder(api, '0');
    }

    /**
     * Copies this folder to another folder.
     *
     * @param  destination the destination folder.
     * @return             info about the copied folder.
     */
    public override BoxItem.Info copy(BoxFolder destination) {
        return this.copy(destination, null);
    }

    /**
     * Copies this folder to another folder and gives it a new name. If the destination is the same folder as the folder's
     * current parent, then newName must be a new, unique name.
     *
     * @param  destination the destination folder.
     * @param  newName     a new name for the copied folder.
     * @return             info about the copied folder.
     */
    public override BoxItem.Info copy(BoxFolder destination, String newName) {
        String url = this.api.baseUrl + String.format(COPY_FOLDER_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_POST);

        BoxFolder.Info parent = new BoxFolder.Info();
        parent.addValue('id', destination.getId());

        BoxFolder.Info copyInfo = new BoxFolder.Info();
        copyInfo.addValue('parent', parent.getJsonString());
        if (newName != null) {
            copyInfo.addValue('name', newName);
        }

        request.setBody(copyInfo.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFolder.copy');
        return new BoxFolder.Info(responseBody);
    }

    /**
     * Moves this folder to another folder.
     *
     * @param  destination the destination folder.
     * @return             info about the moved folder.
     */
    public override BoxItem.Info move(BoxFolder destination) {
        return this.move(destination, null);
    }

    /**
     * Moves this folder to another folder and gives it a new name.
     *
     * @param  destination the destination folder.
     * @param  newName     a new name for the moved folder.
     * @return             info about the moved folder.
     */
    public override BoxItem.Info move(BoxFolder destination, String newName) {
        String url = this.api.baseUrl + String.format(FOLDER_INFO_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);

        BoxFolder.Info parent = new BoxFolder.Info();
        parent.addValue('id', destination.getId());

        BoxFolder.Info moveInfo = new BoxFolder.Info();
        moveInfo.addValue('parent', parent.getJsonString());
        if (newName != null) {
            moveInfo.addValue('name', newName);
        }

        request.setBody(moveInfo.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFolder.move');
        return new BoxFolder.Info(responseBody);
    }

    /**
     * Creates a new child folder inside this folder.
     *
     * @param  name the new folder's name.
     * @return      the created folder's info.
     */
    public BoxFolder.Info createFolder(String name) {
        BoxFolder.Info parent = new BoxFolder.info();
        parent.addValue('id', this.getId());

        BoxFolder.Info newFolder = new BoxFolder.Info();
        newFolder.addValue('name', name);
        newFolder.addValue('parent', parent.getJsonString());

        BoxApiRequest request = new BoxApiRequest(this.api, this.api.baseUrl + CREATE_FOLDER_URL, BoxApiRequest.METHOD_POST);
        request.setBody(newFolder.getJsonString());
        request.addJsonContentTypeHeader();
        request.setTimeout(this.api.timeout);

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFolder.createFolder');
        return new BoxFolder.Info(responseBody);
    }

    /**
     * Adds a collaborator to this folder. An email will be sent to the collaborator if they don't already have a Box
     * account.
     *
     * @param  email the email address of the collaborator to add.
     * @param  role  the role of the collaborator.
     * @return       info about the new collaboration.
     */
    public BoxCollaboration.Info collaborate(String email, BoxCollaboration.Role role) {
        BoxGenericJsonObject accessibleByField = new BoxGenericJsonObject();
        accessibleByField.addValue('login', email);
        accessibleByField.addValue('type', 'user');

        return this.collaborate(accessibleByField, role);
    }

    /**
     * Adds a collaborator to this folder.
     *
     * @param  collaborator the collaborator to add.
     * @param  role         the role of the collaborator.
     * @return              info about the new collaboration.
     */
    public BoxCollaboration.Info collaborate(BoxCollaborator collaborator, BoxCollaboration.Role role) {
        BoxGenericJsonObject accessibleByField = new BoxGenericJsonObject();
        accessibleByField.addValue('id', collaborator.getId());
        if (collaborator.getObjectType() == 'group') {
            accessibleByField.addValue('type', 'group');
        } else if (collaborator.getObjectType() == 'user') {
            accessibleByField.addValue('type', 'user');
        } else {
            throw new BoxResource.BoxResourceException('collaborator argument in BoxFolder.collaborate must be a user or group.');
        }
        return this.collaborate(accessibleByField, role);
    }

    /**
     * Adds a collaborator to this folder.
     *
     * @param  accessibleByField the collaborator to add.
     * @param  role              the role of the collaborator.
     * @return                   info about the new collaboration.
     */
    public BoxCollaboration.Info collaborate(BoxJsonObject accessibleByField, BoxCollaboration.Role role) {
        String collabUrl = this.api.baseUrl + ADD_COLLABORATION_URL;

        BoxFolder.Info thisFolder = new BoxFolder.Info();
        thisFolder.addValue('id', this.getId());
        thisFolder.addValue('type', 'folder');

        BoxGenericJsonObject requestJson = new BoxGenericJsonObject();
        requestJson.addValue('item', thisFolder);
        requestJson.addValue('accessible_by', accessibleByField);
        requestJson.addValue('role', BoxCollaboration.getRoleAsString(role));

        BoxApiRequest request = new BoxApiRequest(this.api, collabUrl, BoxApiRequest.METHOD_POST);
        request.setBody(requestJson.getJsonString());
        System.debug('request json string: ' + requestJson.getJsonString());
        request.addJsonContentTypeHeader();
        request.setTimeout(this.api.timeout);

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFolder.collaborate');
        return new BoxCollaboration.Info(responseBody);
    }

    /**
     * Gets information about all of the collaborations for this folder.
     *
     * @return a collection of information about the collaborations for this folder.
     */
    public list<BoxCollaboration.Info> getCollaborations() {
        String url = this.api.getBaseUrl() + String.format(GET_COLLABORATIONS_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        request.setTimeout(this.api.getTimeout());
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFolder.getCollaborations');

        list<BoxCollaboration.Info> collabs = new list<BoxCollaboration.Info>();
        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        if (responseObject.getValue('total_count') != null) {
            Integer totalCount = Integer.valueOf(responseObject.getValue('total_count'));
            list<String> collabEntries = BoxJsonObject.parseJsonObjectArray(responseObject.getValue('entries'));
            for (String entry : collabEntries) {
                collabs.add(new BoxCollaboration.Info(entry));
            }
            System.assertEquals(totalCount, collabs.size());
        }
        return collabs;
    }

    /**
     * Creates a shared link on this folder
     *
     * @param access  the access the shared link should have
     * @param unshareDate  the datetime the shared link should expire
     * @param permissions  the permissions the shared link should have
     * @return the shared link's information
     */
    public BoxSharedLink.Info createSharedLink(BoxSharedLink.Access access, DateTime unshareDate, BoxSharedLink.Permissions permissions) {
        BoxSharedLink.Info linkInfo = new BoxSharedLink.Info();
        linkInfo.addValue('access', BoxSharedLink.getAccessAsString(access));
        linkInfo.addValue('unshare_at', BoxDateFormat.getBoxDateTimeString(unshareDate));
        linkInfo.addValue('permissions', permissions.getJsonString());

        BoxFolder.Info folderInfoToUpdate = new BoxFolder.Info();
        folderInfoToUpdate.addValue('shared_link', linkInfo.getJsonString());

        BoxFolder.Info updatedFolderInfo = this.updateFolderInfo(folderInfoToUpdate);
        return new BoxSharedLink.Info(updatedFolderInfo.getValue('shared_link'));
    }

    /**
     * Gets information about this folder
     *
     * @return this folder's information
     */
    public BoxFolder.Info getFolderInfo() {
        String url = this.api.getBaseUrl() + String.format(FOLDER_INFO_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        request.setTimeout(this.api.getTimeout());
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFolder.getFolderInfo');
        return new BoxFolder.Info(responseBody);
    }

    /**
     * Updates the information about this folder with any info fields included in the info parameter.
     *
     * @param info the updated info.
     * @return this folder's information
     */
    public BoxFolder.Info updateFolderInfo(BoxFolder.Info info) {
        String url = this.api.getBaseUrl() + String.format(FOLDER_INFO_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);
        request.setTimeout(this.api.getTimeout());
        request.addJsonContentTypeHeader();
        info.addValue('id', this.getId());
        request.setBody(info.getJsonString());

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFolder.updateFolderInfo');
        BoxFolder.Info folderInfo = new BoxFolder.Info(responseBody);
        this.setInfo(folderInfo);
        return folderInfo;
    }

    /**
     * Deletes this folder, optionally recursively deleting all of its contents.
     *
     * @param recursive true to recursively delete this folder's contents; otherwise false.
     * @return true if folder is deleted succesfully, false otherwise.
     */
    public Boolean deleteFolder(Boolean recursive) {
        String url = this.api.getBaseUrl() + String.format(DELETE_FOLDER_URL, new String[] {this.getId(), String.valueOf(recursive)});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_DELETE);
        request.addJsonContentTypeHeader();
        request.setTimeout(this.api.getTimeout());

        HttpResponse response = request.send();
        return BoxApiRequest.ensureBoxResourceResponseCode(response, 'BoxFolder.deleteFolder', new set<Integer> {204}); 
    }

    /**
     * Renames this folder.
     *
     * @param newName the new name of the folder.
     * @return true if folder is renamed succesfully, false otherwise.
     */
    public BoxFolder.Info rename(String newName) {
        String url = this.api.getBaseUrl() + String.format(FOLDER_INFO_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);
        request.addJsonContentTypeheader();
        request.setTimeout(this.api.getTimeout());
        BoxFolder.Info updateInfo = new BoxFolder.Info();
        updateInfo.addValue('name', newName);
        request.setBody(updateInfo.getJsonString());

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFolder.rename');
        return new BoxFolder.Info(responseBody);
    }
    
    public BoxFile.Info uploadFile(Attachment att, String newName) {
    	String fileName = null;
    	if (!String.isEmpty(newName)) {
    		fileName = newName;
    	} else {
    		fileName = att.Name;
    	}
    	return this.uploadFile(att.Body, fileName);
    }
    
    public BoxFile.Info uploadFile(Document doc, String newName) {
    	String fileName = null;
    	if (!String.isEmpty(newName)) {
    		fileName = newName;
    	} else {
    		fileName = doc.Name;
    	}
    	return this.uploadFile(doc.Body, fileName);
    }
    
    public BoxFile.Info uploadFile(Blob fileBody, String fileName) {
    	if (String.isEmpty(fileName)) {
    		throw new BoxResource.BoxResourceException('fileName must not be null or empty when calling BoxFolder.uploadFile.');
    	}
    	if (fileBody == null || fileBody.size() == 0) {
    		throw new BoxResource.BoxResourceException('fileBody must not be null or empty when calling BoxFolder.uploadFile.');
    	}
    	
    	String url = this.api.getBaseUploadUrl() + String.format(UPLOAD_FILE_URL, new String[] {this.getId()});
    	BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_POST);
    	request.setTimeout(this.api.getTimeout());
    	request.setMultipartFormBody(fileBody, fileName);
    	
    	HttpResponse response = request.send();
    	String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFolder.uploadFile');
    	BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
    	if (responseObject.getValue('total_count') != null) {
    		list<String> fileEntries = BoxJsonObject.parseJsonObjectArray(responseObject.getValue('entries'));
    		if (fileEntries.size() > 0) {
    			return new BoxFile.Info(fileEntries[0]);
    		}
    	}
    	return null;
    }
    
    public list<BoxItem.Info> getChildren() {
    	return this.getChildren(null, null);
    }
    
    public list<BoxItem.Info> getChildren(Integer offset, Integer limitCount) {
    	String urlParams = '';
    	if (offset != null && offset >= 0) {
    		urlParams = '?offset=' + offset;
    	}
    	if (limitCount != null && limitCount > 0) {
    		if (urlParams == '') {
    			urlParams = '?limit=' + limitCount;
    		} else {
    			urlParams += '&limit=' + limitCount;
    		}
    	}
    	String url = this.api.getBaseUrl() + String.format(GET_CHILDREN_URL, new String[] {this.getId()}) + urlParams;
    	BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
    	request.setTimeout(this.api.getTimeout());
    	request.addJsonContentTypeHeader();
    	
    	HttpResponse response = request.send();
    	String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFolder.getChildren');
    	
    	list<BoxItem.Info> children = new list<BoxItem.Info>();
    	BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
    	if (responseObject.getValue('total_count') != null) {
    		Integer totalCount = Integer.valueOf(responseObject.getValue('total_count'));
    		list<String> childEntries = BoxJsonObject.parseJsonObjectArray(responseObject.getValue('entries'));
    		for (String entry : childEntries) {
    			BoxGenericJsonObject entryObject = new BoxGenericJsonObject(entry);
    			String objectType = entryObject.getValue('type');
    			if (objectType == 'file') {
    				children.add(new BoxFile.Info(entryObject));
    			} else if (objectType == 'folder') {
    				children.add(new BoxFolder.Info(entryObject));
    			}
    		}
    		System.assertEquals(totalCount, children.size());
    	}
    	return children;
    }

    /**
     * Information about BoxFolder
     */
    public class Info extends BoxItem.Info {

        public Boolean hasCollaborations {get; private set;}
        public BoxFolder.SyncState syncState {get; private set;}
        public BoxFolder.Permission permissions {get; private set;}
        public Boolean canNonOwnersInvite {get; private set;}
        public BoxUploadEmail.Info uploadEmail {get; private set;}

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

        public override void addValue(String key, BoxJsonObject value) {
            this.addValue(key, value.getJsonString());
        }

        @testvisible
        private void parseMember(String key, String value) {
            super.parseItemMember(key, value);
            if (key != null) {
                if (key == 'has_collaborations') {
                    this.hasCollaborations = Boolean.valueOf(value);
                } else if (key == 'sync_state') {
                    this.syncState = BoxFolder.parseSyncState(value);
                } else if (key == 'permissions') {
                    this.permissions = BoxFolder.parsePermission(value);
                } else if (key == 'can_non_owners_invite') {
                    this.canNonOwnersInvite = Boolean.valueOf(value);
                } else if (key == 'folder_upload_email') {
                    this.uploadEmail = new BoxUploadEmail.Info(value);
                }
            }
        }
    }

    public enum SyncState {
        /**
         * The folder is synced
         */
        SYNCED,

        /**
         * The folder is not synced
         */
        NOT_SYNCED,

        /**
         * The folder is partially synced
         */
        PARTIALLY_SYNCED
    }

    public enum Permission {
        /**
         * The user can download the folder.
         */
        CAN_DOWNLOAD,

        /**
         * The user can upload to the folder.
         */
        CAN_UPLOAD,

        /**
         * The user can rename the folder.
         */
        CAN_RENAME,

        /**
         * The user can delete the folder.
         */
        CAN_DELETE,

        /**
         * The user can share the folder.
         */
        CAN_SHARE,

        /**
         * The user can invite collaborators to the folder.
         */
        CAN_INVITE_COLLABORATOR,

        /**
         * The user can set the access level for shared links to the folder.
         */
        CAN_SET_SHARE_ACCESS
    }

    public static BoxFolder.SyncState parseSyncState(String value) {
        if (value == 'synced') {
            return BoxFolder.SyncState.SYNCED;
        } else if (value == 'not_synced') {
            return BoxFolder.SyncState.NOT_SYNCED;
        } else if (value == 'partially_synced') {
            return BoxFolder.SyncState.PARTIALLY_SYNCED;
        }
        return null;
    }

    public static String getSyncStateAsString(BoxFolder.SyncState value) {
        if (value == BoxFolder.SyncState.SYNCED) {
            return 'synced';
        } else if (value == BoxFolder.SyncState.NOT_SYNCED) {
            return 'not_synced';
        } else if (value == BoxFolder.SyncState.PARTIALLY_SYNCED) {
            return 'partially_synced';
        }
        return null;
    }

    public static BoxFolder.Permission parsePermission(String value) {
        if (value == 'can_download') {
            return BoxFolder.Permission.CAN_DOWNLOAD;
        } else if (value == 'can_upload') {
            return BoxFolder.Permission.CAN_UPLOAD;
        } else if (value == 'can_rename') {
            return BoxFolder.Permission.CAN_RENAME;
        } else if (value == 'can_delete') {
            return BoxFolder.Permission.CAN_DELETE;
        } else if (value == 'can_share') {
            return BoxFolder.Permission.CAN_SHARE;
        } else if (value == 'can_invite_collaborator') {
            return BoxFolder.Permission.CAN_INVITE_COLLABORATOR;
        } else if (value == 'can_set_share_access') {
            return BoxFolder.Permission.CAN_SET_SHARE_ACCESS;
        }
        return null;
    }

    public static String getPermissionAsString(BoxFolder.Permission value) {
        if (value == BoxFolder.Permission.CAN_DOWNLOAD) {
            return 'can_download';
        } else if (value == BoxFolder.Permission.CAN_UPLOAD) {
            return 'can_upload';
        } else if (value == BoxFolder.Permission.CAN_RENAME) {
            return 'can_rename';
        } else if (value == BoxFolder.Permission.CAN_DELETE) {
            return 'can_delete';
        } else if (value == BoxFolder.Permission.CAN_SHARE) {
            return 'can_share';
        } else if (value == BoxFolder.Permission.CAN_INVITE_COLLABORATOR) {
            return 'can_invite_collaborator';
        } else if (value == BoxFolder.Permission.CAN_SET_SHARE_ACCESS) {
            return 'can_set_share_access';
        }
        return null;
    }
}