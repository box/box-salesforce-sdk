/**
 * Represents an individual file on Box. This class can be used to download a file's contents, upload new versions, and
 * perform other common file operations (move, copy, delete, etc.).
 */

public class BoxFile extends BoxItem {

    /**
     * An array of all possible file fields.
     */
    public static final list<String> ALL_FIELDS = new list<String> {'type', 'id', 'sequence_id', 'etag', 'sha1', 'name', 'description',
        'size', 'path_collection', 'created_at', 'modified_at', 'trashed_at', 'purged_at', 'content_created_at',
        'content_modified_at', 'created_by', 'modified_by', 'owned_by', 'shared_link', 'parent', 'item_status',
        'version_number', 'comment_count', 'permissions', 'lock', 'extension', 'is_package', 'file_version'};

    private static String COPY_FILE_URL = 'files/{0}/copy';
    private static String FILE_INFO_URL = 'files/{0}';
    private static String GET_COMMENTS_URL = 'files/{0}/comments';
    private static String GET_VERSIONS_URL = 'files/{0}/versions';
    private static String FILE_TRASH_URL = 'files/{0}/trash';
    private static string ADD_COMMENT_URL =  'comments';
    private static string PREVIEW_LINK_URL = '/files/{0}?fields=expiring_embed_link';

    /**
     * Constructs a BoxFile for a file with a given ID.
     *
     * @param  api the API connection to be used by the file.
     * @param  id  the ID of the file.
     */
    public BoxFile(BoxApiConnection api, String id) {
        super(api, id);
        this.information = new BoxFile.Info();
    }

    public override String getObjectType() {
        return 'file';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = new BoxFile.Info(jsonObject);
    }

    /**
     * Gets information of BoxFile.
     *
     * @return information about BoxFile
     */
    public BoxFile.Info getFileInfo() {
        String url = this.api.baseUrl + String.format(FILE_INFO_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFile.getFileInfo');
        return new BoxFile.Info(responseBody);
    }

    /**
     * Updates the information about this file with any info fields passed in info object.
     *
     * @param info with info fields to be updated.
     *
     * @return updated information of BoxFile
     */
    public BoxFile.Info updateFileInfo(BoxFile.Info info) {
        String url = this.api.baseUrl + String.format(FILE_INFO_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();
        request.setBody(info.getJsonString());

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFile.Info');
        BoxFile.Info fileInfo = new BoxFile.Info(responseBody);
        this.setInfo(fileInfo);
        return fileInfo;
    }

    /**
     * Creates a shared link for this particular file.
     *
     * This method gets default shared link status, set it to an empty access level. Please see https://support.box.com/hc/en-us/articles/200520888?
     * for more information on the permissions available for shared links.
     *
     * @return A full file object containing the updated shared link is returned if the ID is valid and if the update is successful.
     */
    public BoxSharedLink.Info createSharedLink() {
        return createSharedLink(new BoxSharedLink.Info());
    }

    /**
     * Creates a shared link for this particular file.
     *
     * In order to get default shared link status, set it to an empty access level, i.e. {"shared_link": {}}.
     * In order to disable a shared link, send this same type of PUT request with the value of shared_link set to null, i.e. {"shared_link": null}
     * Please see https://support.box.com/hc/en-us/articles/200520888? for more information on the permissions available for shared links.
     *
     * @param  BoxSharedLink.Info object.
     * @return A full file object containing the updated shared link is returned if the ID is valid and if the update is successful.
     */
    public BoxSharedLink.Info createSharedLink(BoxSharedLink.Info sharedLinkParams) {
        String url = this.api.baseUrl + String.format(FILE_INFO_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);

        request.setBody(sharedLinkParams.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFile.createSharedLink');
        BoxFile.Info fileInfo = new BoxFile.Info(responseBody);
        return fileInfo.sharedLink;
    }

    /**
     * Retrieves an expiring URL for creating an embedded preview session.
     * The URL will expire after 60 seconds and the preview session will expire after 60 minutes.
     * Only the file types listed http://community.box.com/t5/Managing-Your-Content/What-file-types-are-supported-by-Box-s-Content-Preview/ta-p/327 are supported at this time.
     *
     * @return preview link url, this link can be used in an embedded iframe to provide a rendering of the file.
     */
    public String getPreviewLink() {
        String url = this.api.baseUrl + String.format(PREVIEW_LINK_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);

        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFile.getPreviewLink');

        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        BoxGenericJsonObject expiringEmbedLinkObject =  new BoxGenericJsonObject(responseObject.getValue('expiring_embed_link'));
        return expiringEmbedLinkObject.getValue('url');
    }

    /**
     * Copies this file to another folder.
     *
     * @param  destination the destination folder.
     * @return             info about the copied file.
     */
    public override BoxItem.Info copy(BoxFolder destination) {
        return this.copy(destination, null);
    }

    /**
     * Copies this file to another folder and gives it a new name. If the destination is the same folder as the file's
     * current parent, then newName must be a new, unique name.
     *
     * @param  destination the destination folder.
     * @param  newName     a new name for the copied file.
     * @return             info about the copied file.
     */
    public override BoxItem.Info copy(BoxFolder destination, String newName) {
        String url = this.api.baseUrl + String.format(COPY_FILE_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_POST);

        BoxFolder.Info parent = new BoxFolder.Info();
        parent.addValue('id', destination.getId());

        BoxFile.Info copyInfo = new BoxFile.Info();
        copyInfo.addValue('parent', parent.getJsonString());
        if (newName != null) {
            copyInfo.addValue('name', newName);
        }

        request.setBody(copyInfo.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFile.copy');
        return new BoxFile.Info(responseBody);
    }

    /**
     * Moves this file to another folder.
     *
     * @param  destination the destination folder.
     * @return             info about the moved file.
     */
    public override BoxItem.Info move(BoxFolder destination) {
        return this.move(destination, null);
    }

    /**
     * Moves this file to another folder and gives it a new name.
     *
     * @param  destination the destination folder.
     * @param  newName     a new name for the moved file.
     * @return             info about the moved file.
     */
    public override BoxItem.Info move(BoxFolder destination, String newName) {
        String url = this.api.baseUrl + String.format(FILE_INFO_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);

        BoxFolder.Info parent = new BoxFolder.Info();
        parent.addValue('id', destination.getId());

        BoxFile.Info moveInfo = new BoxFile.Info();
        moveInfo.addValue('parent', parent.getJsonString());
        if (newName != null) {
            moveInfo.addValue('name', newName);
        }

        request.setBody(moveInfo.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFile.move');
        return new BoxFile.Info(responseBody);
    }

    /**
     * Deletes this file, discards a file to the trash.
     *
     * @return true if file is deleted succesfully, false otherwise.
     */
    public Boolean deleteFile() {
        return this.deleteFile(null);
    }

    /**
     * Deletes this file, discards a file to the trash.
     *
     * @param  eTag the etag of the file can be included as an ‘If-Match’ header to prevent race conditions.
     * @return      true if file is deleted succesfully, false otherwise.
     */
    public Boolean deleteFile(string eTag) {
        String url = this.api.baseUrl + String.format(FILE_INFO_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_DELETE);

        BoxFile.Info fileInfo = new BoxFile.Info();
        fileInfo.addValue('id', this.getId());
        if(eTag != null) {
            fileInfo.addValue('eTag', eTag);
        }

        request.setBody(fileInfo.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        return BoxApiRequest.ensureBoxResourceResponseCode(response, 'BoxFile.deleteFile', new set<Integer> {204});
    }

    /**
     * Gets file from trash, with the Box file ID passed in
     *
     * @return      a Box File that has been retrieved from trash
     */
    public BoxFile.Info getTrashedFile(){
      String url = this.api.baseUrl + String.format(FILE_TRASH_URL, new String[] {this.getId()});
      BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);

      request.setTimeout(this.api.timeout);
      request.addJsonContentTypeHeader();

      HttpResponse response = request.send();
      String responseBody = BoxApiRequest.ensureBoxResourceResponseBody(response, 'BoxFile.getTrashedFile', new set<Integer>{200});
      return new BoxFile.info(responseBody);
    }

    /**
     * Renames this file.
     *
     * @param newName the new name of the file.
     * @return        true if file is renamed succesfully, false otherwise.
     */
    public Boolean rename(string newName) {
        String url = this.api.baseUrl + String.format(FILE_INFO_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);

        BoxFile.Info fileInfo = new BoxFile.Info();
        fileInfo.addValue('id', this.getId());
        if(newName != null) {
            fileInfo.addValue('name', newName);
        }

        request.setBody(fileInfo.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();

        return BoxApiRequest.ensureBoxResourceResponseCode(response, 'BoxFile.rename', new set<Integer> {200});
    }

    /**
     * Gets a list of comments on BoxFile.
     *
     * @return a list of comments on BoxFile.
     */
    public list<BoxComment.Info> getComments() {
        String url = this.api.baseUrl + String.format(GET_COMMENTS_URL, new String[] {this.getId()});
        return BoxComment.getComments(this.api, url);
    }

    /**
     * Gets any previous versions of this file.
     *
     * @return a list of previous file versions.
     */
    public list<BoxFileVersion.Info> getVersions() {
        String url = this.api.baseUrl + String.format(GET_VERSIONS_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);

        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFile.getVersions');

        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        list<String> versionEntries = BoxJsonObject.parseJsonObjectArray(responseObject.getValue('entries'));
        list<BoxFileVersion.Info> versions = new list<BoxFileVersion.Info>();
        for (String versionEntry : versionEntries) {
            versions.add(new BoxFileVersion.Info(versionEntry));
        }
        return versions;
    }

    /**
     * Adds a comment to this file. The message can contain @mentions by using the string @[userid:username] anywhere
     * within the message, where userid and username are the ID and username of the person being mentioned.
     * @see    <a href="https://developers.box.com/docs/#comments-add-a-comment-to-an-item">the tagged_message field
     *         for including @mentions.</a>
     *
     * @param  message the comment's message.
     * @return information about the newly added comment.
     */
    public BoxComment.Info addComment(String message) {
        String url = this.api.baseUrl + String.format(ADD_COMMENT_URL, new String[] {this.getId()});

        BoxGenericJsonObject itemObject = new BoxGenericJsonObject();
        itemObject.addValue('type', 'file');
        itemObject.addValue('id', this.getId());

        BoxComment.Info commentInfo = new BoxComment.Info();
        commentInfo.addValue('item', itemObject);

        if (BoxComment.messageContainsMention(message)) {
            commentInfo.addValue('tagged_message', message);
        } else {
            commentInfo.addValue('message', message);
        }

        return BoxComment.addComment(this.api, url, commentInfo);
    }

    public Box

    /**
     * Infrmation about BoxFile
     */
    public class Info extends BoxItem.Info {

        public String sha1;
        public String versionNumber;
        public long commentCount;
        public set<BoxFile.Permission> permissions;
        public String extension;
        public boolean isPackage;
        public BoxFileVersion.Info version;

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
            super.parseItemMember(key, value);
            if (key != null) {
                if (key == 'sha1') {
                    this.sha1 = value;
                }else if (key == 'version_number') {
                    this.versionNumber = value;
                } else if (key == 'comment_count') {
                    this.commentCount = long.valueOf(value);
                } else if (key == 'extension') {
                    this.extension = value;
                } else if (key == 'is_package') {
                    this.isPackage = Boolean.valueOf(value);
                } else if (key == 'file_version') {
                    this.version = new BoxFileVersion.Info(value);
                }
            }
        }

        private BoxFile.Permission parseFilePermissions(String value) {
             if (value != null) {
                if (value == 'can_download') {
                    return BoxFile.Permission.CAN_DOWNLOAD;
                } else if (value == 'can_upload') {
                    return BoxFile.Permission.CAN_UPLOAD;
                } else if (value == 'can_rename') {
                    return BoxFile.Permission.CAN_RENAME;
                } else if (value == 'can_delete') {
                    return BoxFile.Permission.CAN_DELETE;
                } else if (value == 'can_share') {
                    return BoxFile.Permission.CAN_SHARE;
                } else if (value == 'can_set_share_access') {
                    return BoxFile.Permission.CAN_SET_SHARE_ACCESS;
                } else if (value == 'can_preview') {
                    return BoxFile.Permission.CAN_PREVIEW;
                } else if (value == 'can_comment') {
                    return BoxFile.Permission.CAN_COMMENT;
                }
           }
           return null;
       }
    }

    /**
     * Enumerates the possible permissions that a user can have on a file.
     */
    public enum Permission {
        /**
         * The user can download the file.
         */
        CAN_DOWNLOAD,

        /**
         * The user can upload new versions of the file.
         */
        CAN_UPLOAD,

        /**
         * The user can rename the file.
         */
        CAN_RENAME,

        /**
         * The user can delete the file.
         */
        CAN_DELETE,

        /**
         * The user can share the file.
         */
        CAN_SHARE,

        /**
         * The user can set the access level for shared links to the file.
         */
        CAN_SET_SHARE_ACCESS,

        /**
         * The user can preview the file.
         */
        CAN_PREVIEW,

        /**
         * The user can comment on the file.
         */
        CAN_COMMENT
    }
}
