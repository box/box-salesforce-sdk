/**
 * Represents an event that was fired off by the Box events API.
 */

public class BoxEvent extends BoxResource {

    /**
     * Constructs a BoxEvent with a given ID.
     *
     * @param  api the API connection to be used by the event.
     * @param  id  the ID of the event.
     */
    public BoxEvent(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'event';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxEvent.Info) jsonObject;
    }

    /**
     * Contains information about a BoxEvent.
     */
    public class Info extends BoxResource.Info {

        public BoxResource.Info sourceInfo;
        public BoxEvent.Type eventType;
        public BoxJsonObject sourceJSON;
        public DateTime createdAt;
        public String ipAddress;
        public BoxJsonObject additionalDetails;
        public BoxCollaborator.Info accessibleBy;
        public BoxUser.Info createdBy;
        public String sessionID;

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

        @testvisible
        private void parseMember(String key, String value) {
                if (key != null) {
                    if (key == 'source_info') {
                           this.sourceInfo = BoxResource.parseBoxResource(value);
                    } else if (key == 'event_type') {
                        this.eventType = this.parseEventType(value);
                    } else if (key == 'source_json') {
                        this.sourceJSON = new BoxGenericJsonObject(value);
                    } else if (key == 'created_at') {
                        this.createdAt = BoxDateFormat.parseBoxDateTimeString(value);
                    } else if (key == 'ip_address') {
                        this.ipAddress = value;
                    } else if (key == 'additional_details') {
                        this.additionalDetails = new BoxGenericJsonObject(value);
                    } else if (key == 'accessible_by') {
                        this.accessibleBy = (BoxCollaborator.Info) BoxResource.parseBoxResource(value);
                    } else if (key == 'created_by') {
                        this.createdBy = new BoxUser.Info(value);
                    } else if (key == 'session_id') {
                        this.sessionID = value;
                    }
                }
        }

        @testvisible 
        private BoxEvent.Type parseEventType(String value) {
               if (value != null) {
                   if (value == 'item_create') {
                       return BoxEvent.Type.ITEM_CREATE;
                   } else if (value == 'item_upload') {
                       return BoxEvent.Type.ITEM_UPLOAD;
                   } else if (value == 'comment_create') {
                       return BoxEvent.Type.COMMENT_CREATE;
                   } else if (value == 'item_download') {
                       return BoxEvent.Type.ITEM_DOWNLOAD;
                   } else if (value == 'item_preview') {
                       return BoxEvent.Type.ITEM_PREVIEW;
                   } else if (value == 'item_move') {
                       return BoxEvent.Type.ITEM_MOVE;
                   } else if (value == 'item_copy') {
                       return BoxEvent.Type.ITEM_COPY;
                   } else if (value == 'task_assignment_create') {
                       return BoxEvent.Type.TASK_ASSIGNMENT_CREATE;
                   } else if (value == 'lock_create') {
                       return BoxEvent.Type.LOCK_CREATE;
                   } else if (value == 'lock_destroy') {
                       return BoxEvent.Type.LOCK_DESTROY;
                   } else if (value == 'item_trash') {
                       return BoxEvent.Type.ITEM_TRASH;
                   } else if (value == 'item_undelete_via_trash') {
                       return BoxEvent.Type.ITEM_UNDELETE_VIA_TRASH;
                   } else if (value == 'collab_add_collaborator') {
                       return BoxEvent.Type.COLLAB_ADD_COLLABORATOR;
                   } else if (value == 'collab_remove_collaborator') {
                       return BoxEvent.Type.COLLAB_REMOVE_COLLABORATOR;
                   } else if (value == 'collab_invite_collaborator') {
                       return BoxEvent.Type.COLLAB_INVITE_COLLABORATOR;
                   } else if (value == 'collab_role_change') {
                       return BoxEvent.Type.COLLAB_ROLE_CHANGE;
                   } else if (value == 'item_sync') {
                       return BoxEvent.Type.ITEM_SYNC;
                   } else if (value == 'item_unsync') {
                       return BoxEvent.Type.ITEM_UNSYNC;
                   } else if (value == 'item_rename') {
                      return BoxEvent.Type.ITEM_RENAME;
                   } else if (value == 'item_shared_create') {
                      return BoxEvent.Type.ITEM_SHARED_CREATE;
                   } else if (value == 'item_shared_unshare') {
                      return BoxEvent.Type.ITEM_SHARED_UNSHARE;
                   } else if (value == 'item_shared') {
                      return BoxEvent.Type.ITEM_SHARED;
                   } else if (value == 'add_login_activity_device') {
                      return BoxEvent.Type.ADD_LOGIN_ACTIVITY_DEVICE;
                   } else if (value == 'remove_login_activity_device') {
                      return BoxEvent.Type.REMOVE_LOGIN_ACTIVITY_DEVICE;
                   } else if (value == 'change_admin_role') {
                      return BoxEvent.Type.CHANGE_ADMIN_ROLE;
                   } else if (value == 'group_add_user') {
                      return BoxEvent.Type.GROUP_ADD_USER;
                   } else if (value == 'new_user') {
                      return BoxEvent.Type.NEW_USER;
                   } else if (value == 'group_creation') {
                      return BoxEvent.Type.GROUP_CREATION;
                   } else if (value == 'group_deletion') {
                      return BoxEvent.Type.GROUP_DELETION;
                   } else if (value == 'delete_user') {
                      return BoxEvent.Type.DELETE_USER;
                   } else if (value == 'group_edited') {
                      return BoxEvent.Type.GROUP_EDITED;
                   } else if (value == 'edit_user') {
                      return BoxEvent.Type.EDIT_USER;
                   } else if (value == 'group_add_folder') {
                      return BoxEvent.Type.GROUP_ADD_FOLDER;
                   } else if (value == 'group_remove_user') {
                      return BoxEvent.Type.GROUP_REMOVE_USER;
                   } else if (value == 'group_remove_folder') {
                      return BoxEvent.Type.GROUP_REMOVE_FOLDER;
                   } else if (value == 'admin_login') {
                      return BoxEvent.Type.ADMIN_LOGIN;
                   } else if (value == 'add_device_association') {
                      return BoxEvent.Type.ADD_DEVICE_ASSOCIATION;
                   } else if (value == 'failed_login') {
                      return BoxEvent.Type.FAILED_LOGIN;
                   } else if (value == 'login') {
                      return BoxEvent.Type.LOGIN;
                   } else if (value == 'user_authenticate_oauth2_token_refresh') {
                      return BoxEvent.Type.USER_AUTHENTICATE_OAUTH2_TOKEN_REFRESH;
                   } else if (value == 'remove_device_association') {
                      return BoxEvent.Type.REMOVE_DEVICE_ASSOCIATION;
                   } else if (value == 'terms_of_service_agree') {
                      return BoxEvent.Type.TERMS_OF_SERVICE_AGREE;
                   } else if (value == 'terms_of_service_reject') {
                      return BoxEvent.Type.TERMS_OF_SERVICE_REJECT;
                   } else if (value == 'copy') {
                      return BoxEvent.Type.COPY;
                   } else if (value == 'delete') {
                      return BoxEvent.Type.ITEM_DELETE;
                   } else if (value == 'download') {
                      return BoxEvent.Type.DOWNLOAD;
                   } else if (value == 'edit') {
                      return BoxEvent.Type.EDIT;
                   } else if (value == 'lock') {
                      return BoxEvent.Type.LOCK;
                   } else if (value == 'move') {
                      return BoxEvent.Type.MOVE;
                   } else if (value == 'preview') {
                      return BoxEvent.Type.PREVIEW;
                   } else if (value == 'rename') {
                      return BoxEvent.Type.RENAME;
                   } else if (value == 'storage_expiration') {
                      return BoxEvent.Type.STORAGE_EXPIRATION;
                   } else if (value == 'undelete') {
                      return BoxEvent.Type.ITEM_UNDELETE;
                   } else if (value == 'unlock') {
                      return BoxEvent.Type.UNLOCK;
                   } else if (value == 'upload') {
                      return BoxEvent.Type.UPLOAD;
                   } else if (value == 'share') {
                      return BoxEvent.Type.SHARE;
                   } else if (value == 'item_shared_update') {
                      return BoxEvent.Type.ITEM_SHARED_UPDATE;
                   } else if (value == 'update_share_expiration') {
                      return BoxEvent.Type.UPDATE_SHARE_EXPIRATION;
                   } else if (value == 'share_expiration') {
                      return BoxEvent.Type.SHARE_EXPIRATION;
                   } else if (value == 'unshare') {
                      return BoxEvent.Type.UNSHARE;
                   } else if (value == 'collaboration_accept') {
                      return BoxEvent.Type.COLLABORATION_ACCEPT;
                   } else if (value == 'collaboration_role_change') {
                      return BoxEvent.Type.COLLABORATION_ROLE_CHANGE;
                   } else if (value == 'update_collaboration_expiration') {
                      return BoxEvent.Type.UPDATE_COLLABORATION_EXPIRATION;
                   } else if (value == 'collaboration_remove') {
                      return BoxEvent.Type.COLLABORATION_REMOVE;
                   } else if (value == 'collaboration_invite') {
                      return BoxEvent.Type.COLLABORATION_INVITE;
                   } else if (value == 'collaboration_expiration') {
                      return BoxEvent.Type.COLLABORATION_EXPIRATION;
                   }
               }
               return BoxEvent.Type.UNKNOWN;
        }
    }

    /**
     * Enumerates the possible types for an event.
     */
    public enum Type {
        /**
         * The type of the event is unknown.
         */
        UNKNOWN,

        /**
         * An file or folder was created.
         */
        ITEM_CREATE,

        /**
         * An file or folder was uploaded.
         */
        ITEM_UPLOAD,

        /**
         * A comment was created on a folder, file, or other comment.
         */
        COMMENT_CREATE,

        /**
         * An file or folder was downloaded.
         */
        ITEM_DOWNLOAD,

        /**
         * A file was previewed.
         */
        ITEM_PREVIEW,

        /**
         * A file or folder was moved.
         */
        ITEM_MOVE,

        /**
         * A file or folder was copied.
         */
        ITEM_COPY,

        /**
         * A task was assigned.
         */
        TASK_ASSIGNMENT_CREATE,

        /**
         * A file was locked.
         */
        LOCK_CREATE,

        /**
         * A file was unlocked.
         */
        LOCK_DESTROY,

        /**
         * A file or folder was deleted.
         */
        ITEM_TRASH,

        /**
         * A file or folder was recovered from the trash.
         */
        ITEM_UNDELETE_VIA_TRASH,

        /**
         * A collaborator was added to a folder.
         */
        COLLAB_ADD_COLLABORATOR,

        /**
         * A collaborator was removed from a folder.
         */
        COLLAB_REMOVE_COLLABORATOR,

        /**
         * A collaborator was invited to a folder.
         */
        COLLAB_INVITE_COLLABORATOR,

        /**
         * A collaborator's role was change in a folder.
         */
        COLLAB_ROLE_CHANGE,

        /**
         * A folder was marked for sync.
         */
        ITEM_SYNC,

        /**
         * A folder was un-marked for sync.
         */
        ITEM_UNSYNC,

        /**
         * A file or folder was renamed.
         */
        ITEM_RENAME,

        /**
         * A file or folder was enabled for sharing.
         */
        ITEM_SHARED_CREATE,

        /**
         * A file or folder was disabled for sharing.
         */
        ITEM_SHARED_UNSHARE,

        /**
         * A folder was shared.
         */
        ITEM_SHARED,

        /**
         * A user logged in from a new device.
         */
        ADD_LOGIN_ACTIVITY_DEVICE,

        /**
         * A user session associated with an app was invalidated.
         */
        REMOVE_LOGIN_ACTIVITY_DEVICE,

        /**
         * An admin role changed for a user.
         */
        CHANGE_ADMIN_ROLE,

        /**
         * A user was added to a group. This is an enterprise-only event.
         */
        GROUP_ADD_USER,

        /**
         * A user was created. This is an enterprise-only event.
         */
        NEW_USER,

        /**
         * A group was created. This is an enterprise-only event.
         */
        GROUP_CREATION,

        /**
         * A group was deleted. This is an enterprise-only event.
         */
        GROUP_DELETION,

        /**
         * A user was deleted. This is an enterprise-only event.
         */
        DELETE_USER,

        /**
         * A group was edited. This is an enterprise-only event.
         */
        GROUP_EDITED,

        /**
         * A user was edited. This is an enterprise-only event.
         */
        EDIT_USER,

        /**
         * A group was granted access to a folder. This is an enterprise-only event.
         */
        GROUP_ADD_FOLDER,

        /**
         * A user was removed from a group. This is an enterprise-only event.
         */
        GROUP_REMOVE_USER,

        /**
         * A group had its access to a folder removed. This is an enterprise-only event.
         */
        GROUP_REMOVE_FOLDER,

        /**
         * An administrator logged in. This is an enterprise-only event.
         */
        ADMIN_LOGIN,

        /**
         * A device was associated with a user. This is an enterprise-only event.
         */
        ADD_DEVICE_ASSOCIATION,

        /**
         * There was a failed login attempt. This is an enterprise-only event.
         */
        FAILED_LOGIN,

        /**
         * There was a successful login. This is an enterprise-only event.
         */
        LOGIN,

        /**
         * A user's OAuth2 access token was refreshed. This is an enterprise-only event.
         */
        USER_AUTHENTICATE_OAUTH2_TOKEN_REFRESH,

        /**
         * A device was disassociated with a user. This is an enterprise-only event.
         */
        REMOVE_DEVICE_ASSOCIATION,

        /**
         * A user agreed to the terms of service. This is an enterprise-only event.
         */
        TERMS_OF_SERVICE_AGREE,

        /**
         * A user rejected the terms of service. This is an enterprise-only event.
         */
        TERMS_OF_SERVICE_REJECT,

        /**
         * An item was copied. This is an enterprise-only event.
         */
        COPY,

        /**
         * An item was deleted. This is an enterprise-only event. Event with name 'delete' will be mapped to ITEM_DELETE
         */
        ITEM_DELETE,

        /**
         * An item was downloaded. This is an enterprise-only event.
         */
        DOWNLOAD,

        /**
         * An item was edited. This is an enterprise-only event.
         */
        EDIT,

        /**
         * An item was locked. This is an enterprise-only event.
         */
        LOCK,

        /**
         * An item was moved. This is an enterprise-only event.
         */
        MOVE,

        /**
         * An item was previewed. This is an enterprise-only event.
         */
        PREVIEW,

        /**
         * An item was renamed. This is an enterprise-only event.
         */
        RENAME,

        /**
         * An item was set to be auto-deleted. This is an enterprise-only event.
         */
        STORAGE_EXPIRATION,

        /**
         * An item was undeleted. This is an enterprise-only event. NOTE: Event with name 'undelete' will be mapped to ITEM_UNDELETE
         */
        ITEM_UNDELETE,

        /**
         * An item was unlocked. This is an enterprise-only event.
         */
        UNLOCK,

        /**
         * An item was uploaded. This is an enterprise-only event.
         */
        UPLOAD,

        /**
         * An shared link was created for an item. This is an enterprise-only event.
         */
        SHARE,

        /**
         * The shared link for an item was updated. This is an enterprise-only event.
         */
        ITEM_SHARED_UPDATE,

        /**
         * The expiration time for a shared link was extended. This is an enterprise-only event.
         */
        UPDATE_SHARE_EXPIRATION,

        /**
         * The expiration time was set for a shared link. This is an enterprise-only event.
         */
        SHARE_EXPIRATION,

        /**
         * The shared link for an item was REMOVE_DEVICE_ASSOCIATION. This is an enterprise-only event.
         */
        UNSHARE,

        /**
         * A user accepted a collaboration invite. This is an enterprise-only event.
         */
        COLLABORATION_ACCEPT,

        /**
         * A user's collaboration role was changed. This is an enterprise-only event.
         */
        COLLABORATION_ROLE_CHANGE,

        /**
         * The expiration time for a collaboration was extended. This is an enterprise-only event.
         */
        UPDATE_COLLABORATION_EXPIRATION,

        /**
         * A collaboration was removed from a folder. This is an enterprise-only event.
         */
        COLLABORATION_REMOVE,

        /**
         * A user was invited to collaborate on a folder. This is an enterprise-only event.
         */
        COLLABORATION_INVITE,

        /**
         * An expiration time was set for a collaboration. This is an enterprise-only event.
         */
        COLLABORATION_EXPIRATION
    }
}