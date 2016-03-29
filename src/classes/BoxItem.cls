/**
 * The abstract base class for items in a user's file tree (files, folders, etc.).
 */

public abstract class BoxItem extends BoxResource {

    /**
     * An array of all possible file fields.
     */
    public static final list<String> ALL_FIELDS = new list<String> 
        {'type', 'id', 'sequence_id', 'etag', 'sha1', 'name', 'description',
        'size', 'path_collection', 'created_at', 'modified_at', 'trashed_at', 'purged_at', 'content_created_at',
        'content_modified_at', 'created_by', 'modified_by', 'owned_by', 'shared_link', 'parent', 'item_status',
        'version_number', 'comment_count', 'permissions', 'lock', 'extension', 'is_package',
        'folder_upload_email', 'item_collection', 'sync_state', 'has_collaborations', 'can_non_owners_invite',
        'file_version'};

    /**
     * Constructs a BoxItem for an item with a given ID.
     *
     * @param  api the API connection to be used by the item.
     * @param  id  the ID of the item.
     */
    public BoxItem(BoxApiConnection api, String id) {
        super(api, id);
    }

    public static BoxItem.Info getSharedItem(BoxApiConnection api, String sharedLink) {
        return getSharedItem(api, sharedLink, null);
    }

    public static BoxItem.Info getSharedItem(BoxApiConnection api, String sharedLink, String password) {
        return null;
    }

    /**
     * Copies this item to another folder.
     *
     * @param  destination the destination folder.
     * @return             info about the copied item.
     */
    public abstract BoxItem.Info copy(BoxFolder destination);

    /**
     * Copies this item to another folder and gives it a new name. If the destination is the same folder as the item's
     * current parent, then newName must be a new, unique name.
     *
     * @param  destination the destination folder.
     * @param  newName     a new name for the copied item.
     * @return             info about the copied item.
     */
    public abstract BoxItem.Info copy(BoxFolder destination, String newName);

    /**
     * Moves this item to another folder.
     *
     * @param  destination the destination folder.
     * @return             info about the moved item.
     */
    public abstract BoxItem.Info move(BoxFolder destination);

    /**
     * Moves this item to another folder and gives it a new name.
     *
     * @param  destination the destination folder.
     * @param  newName     a new name for the moved item.
     * @return             info about the moved item.
     */
    public abstract BoxItem.Info move(BoxFolder destination, String newName);

    /**
     * Information about BoxItem
     */
    public abstract class Info extends BoxResource.Info {

        public String sequenceID;
        public String etag;
        public String name;
        public String description;
        public String itemStatus;
        public long size;
        public DateTime createdAt;
        public DateTime modifiedAt;
        public DateTime trashedAt;
        public DateTime purgedAt;
        public DateTime contentCreatedAt;
        public DateTime contentModifiedAt;
        public BoxUser.Info createdBy;
        public BoxUser.Info modifiedBy;
        public BoxUser.Info ownedBy;
        public list<BoxFolder.Info> pathCollection;
        public BoxSharedLink.Info sharedLink;
        public BoxFolder.Info parent;

        public Info() {
            super();
        }

        public Info(String jsonString) {
            super(jsonString);
        }

        public Info(BoxJsonObject jsonObject) {
            super(jsonObject);
        }

        public String getName() {
            return this.name;
        }

        protected void parseItemMember(String key, String value) {
            super.parseResourceMember(key, value);
            if (key != null) {
                if (key == 'sequence_id') {
                    this.sequenceId = value;
                }else if (key == 'etag') {
                    this.etag = value;
                } else if (key == 'name') {
                    this.name = value;
                } else if (key == 'description') {
                    this.description = value;
                } else if (key == 'item_status') {
                    this.itemStatus = value;
                } else if (key == 'size') {
                    this.size = Double.valueOf(value).longValue();
                } else if (key == 'created_at') {
                    this.createdAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'modified_at') {
                    this.modifiedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'trashed_at') {
                    this.trashedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'purged_at') {
                    this.purgedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'content_created_at') {
                    this.contentCreatedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'content_modified_at') {
                    this.contentModifiedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'shared_link') {
                    this.sharedLink = new BoxSharedLink.Info(value);
                } else if (key == 'parent') {
                    this.parent = new BoxFolder.Info(value);
                } else if (key == 'path_collection') {
                    this.pathCollection = this.parsePathCollection(value);
                }
            }
        }

        private list<BoxFolder.Info> parsePathCollection(String value) {
            BoxGenericJsonObject valueObject = new BoxGenericJsonObject(value);
            list<String> pathStrings = BoxJsonObject.parseJsonObjectArray(valueObject.getValue('entries'));
            list<BoxFolder.Info> paths = new list<BoxFolder.Info>();
            for (String path : pathStrings) {
                paths.add(new BoxFolder.Info(path));
            }
            return paths;
        }
    }
}