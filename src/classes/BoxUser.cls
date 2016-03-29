/**
 * Represents a Box user account.
 */

public class BoxUser extends BoxCollaborator {

    private static final String USER_URL_TEMPLATE = 'users/{0}';
    private static final String GET_ME_URL = 'users/me';
    private static final String USERS_URL_TEMPLATE = 'users';
    private static final String USER_MEMBERSHIPS_URL_TEMPLATE ='users/{0}/memberships';
    private static final String EMAIL_ALIAS_URL_TEMPLATE = 'users/{0}/email_aliases/{1}';
    private static final String EMAIL_ALIASES_URL_TEMPLATE = 'users/{0}/email_aliases';
    private static final String MOVE_FOLDER_TO_USER_TEMPLATE = 'users/{0}/folders/{1}';
    private static string GET_USER_EVENTS_URL =  '/events?stream_position={0}&stream_type={1}&limit={2}';

    /**
     * An array of all possible file fields.
     */
    public static final String[] ALL_FIELDS = new String[] {'type', 'id', 'name', 'login', 'created_at', 'modified_at', 'role',
        'language', 'timezone', 'space_amount', 'space_used', 'max_upload_size', 'tracking_codes',
        'can_see_managed_users', 'is_sync_enabled', 'is_external_collab_restricted', 'status', 'job_title', 'phone',
        'address', 'avatar_url', 'is_exempt_from_device_limits', 'is_exempt_from_login_verification', 'enterprise',
        'hostname', 'is_platform_access_only'};

    /**
     * Constructs a BoxUser with a given ID.
     *
     * @param  api the API connection to be used by the item.
     * @param  id  the ID of the item.
     */
    public BoxUser(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'user';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = new BoxUser.Info(jsonObject);
    }

    /**
     * Provisions a new app user in an enterprise using Box Developer Edition.
     * @param  api   the API connection to be used by the created user.
     * @param  name  the name of the user.
     * @return       the created user's info.
     */
    public static BoxUser.Info createAppUser(BoxApiConnection api, String name) {
        return createAppUser(api, name, new BoxCreateUserParams());
    }

    /**
     * Provisions a new app user in an enterprise with additional user information using Box Developer Edition.
     * @param  api    the API connection to be used by the created user.
     * @param  name   the name of the user.
     * @param  params additional user information.
     * @return        the created user's info.
     */
    public static BoxUser.Info createAppUser(BoxApiConnection api, String name, BoxCreateUserParams params) {
        params.isPlatformAccessOnly = true;
        return createEnterpriseUser(api, null, name, params);
    }

    /**
     * Provisions a new user in an enterprise.
     * @param  api   the API connection to be used by the created user.
     * @param  login the email address the user will use to login.
     * @param  name  the name of the user.
     * @return       the created user's info.
     */
    public static BoxUser.Info createEnterpriseUser(BoxApiConnection api, String login, String name) {
        return createEnterpriseUser(api, login, name, null);
    }

    /**
     * Provisions a new user in an enterprise with additional user information.
     * @param  api    the API connection to be used by the created user.
     * @param  login  the email address the user will use to login.
     * @param  name   the name of the user.
     * @param  params additional user information.
     * @return        the created user's info.
     */
    public static BoxUser.Info createEnterpriseUser(BoxApiConnection api, String login, String name, BoxCreateUserParams params) {
        BoxGenericJsonObject requestJson = new BoxGenericJsonObject();
        requestJson.addValue('login', login);
        requestJson.addValue('name', name);

        if (params != null) {
            if (params.role != null) {
                requestJson.addValue('role', BoxUser.getRoleAsString(params.role));
            }
            if (params.status != null) {
                requestJson.addValue('status', BoxUser.getStatusAsString(params.status));
            }
            requestJson.addValue('language', params.language);
            requestJson.addValue('is_sync_enabled', String.valueOf(params.isSyncEnabled));
            requestJson.addValue('job_title', params.jobTitle);
            requestJson.addValue('phone', params.phone);
            requestJson.addValue('address', params.address);
            requestJson.addValue('space_amount', String.valueOf(params.spaceAmount));
            requestJson.addValue('can_see_managed_users', String.valueOf(params.canSeeManagedUsers));
            requestJson.addValue('timezone', params.timezone);
            requestJson.addValue('is_exempt_from_device_limits', String.valueOf(params.isExemptFromDeviceLimits));
            requestJson.addValue('is_exempt_from_login_verification', String.valueOf(params.isExemptFromLoginVerification));
            requestJson.addValue('is_platform_access_only', String.valueOf(params.isPlatformAccessOnly));
        }

        String url = api.baseUrl + USERS_URL_TEMPLATE;
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_POST);
        request.setBody(requestJson.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxUser.createEnterpriseUser');
        return new BoxUser.Info(responseBody);
    }

    /**
     * Gets the current user.
     * @param  api the API connection of the current user.
     * @return     the current user.
     */
    public static BoxUser.Info getCurrentUser(BoxApiConnection api) {
        String url = api.baseUrl + GET_ME_URL;
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_GET);
        request.addJsonContentTypeHeader();
        request.setTimeout(api.timeout);

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxUser.getCurrentUser');
        return new BoxUser.Info(responseBody);
    }

    /**
     * Returns a list containing all the enterprise users.
     * @param  api the API connection to be used when retrieving the users.
     * @return     a list containing all the enterprise users.
     */
    public static list<BoxUser.Info> getAllEnterpriseUsers(BoxApiConnection api) {
        return getAllEnterpriseUsers(api, null, null);
    }

    /**
     * Returns a list of all the enterprise users that matches the filter and specifies which child fields
     * to retrieve from the API.
     * @param  api        the API connection to be used when retrieving the users.
     * @param  filterTerm used to filter the results to only users starting with this string in either the name or the
     *                    login. Can be null to not filter the results.
     * @param  fields     the fields to retrieve. Leave this out for the standard fields.
     * @return            a list containing all the enterprise users that matches the filter.
     */
    public static list<BoxUser.Info> getAllEnterpriseUsers(BoxApiConnection api, String filterTerm, list<String> fields) {
        Integer recordLimit = 1000;
        Integer recordsRetrieved = 0;
        Integer recordCount = recordLimit + 1;
        String fieldsString = null;
        if (fields != null && !fields.isEmpty()) {
            fieldsString = String.join(fields, ',');
        }
        list<BoxUser.Info> enterpriseUsers = new list<BoxUser.Info>();

        while (recordsRetrieved < recordCount) {
            String url = buildGetEnterpriseUsersUrl(api.baseUrl, filterTerm, fieldsString, recordsRetrieved, recordLimit);
            BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_GET);
            request.addJsonContentTypeHeader();
            request.setTimeout(api.timeout);
            HttpResponse response = request.send();
            String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxUser.getAllEnterpriseUsers');

            BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
            Integer totalCount = Integer.valueOf(responseObject.getValue('total_count'));
            if (totalCount == null) {
                recordCount = 0;
            } else {
                recordCount = totalCount;
                list<String> userJsonStrings = BoxJsonObject.parseJsonObjectArray(responseObject.getValue('entries'));
                for (String userJsonString : userJsonStrings) {
                    BoxUser.Info userInfo = new BoxUser.Info(userJsonString);
                    enterpriseUsers.add(userInfo);
                }
                recordsRetrieved += userJsonStrings.size();
            }
        }
        return enterpriseUsers;
    }

    /**
     * Gets information about this user.
     * @param  fields the optional fields to retrieve.
     * @return        info about this user.
     */
    public BoxUser.Info getUser(list<String> fields) {
        String fieldsString = null;
        if (fields != null && !fields.isEmpty()) {
            fieldsString = String.join(fields, ',');
        }
        String url = this.api.baseUrl + String.format(USER_URL_TEMPLATE, new String[] {this.getId()});
        if (fieldsString != null) {
            url += '?fields=' + fieldsString;
        }
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_GET);
        request.addJsonContentTypeHeader();
        request.setTimeout(this.api.timeout);
        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxUser.getUser');
        return new BoxUser.Info(responseBody);
    }

    /**
     * Gets information about all of the group memberships for this user.
     *
     * Note: This method is only available to enterprise admins.
     *
     * @return a collection of information about the group memberships for this user.
     */
    public list<BoxGroupMembership.Info> getMemberships() {
        String url = this.api.baseUrl + String.format(USER_MEMBERSHIPS_URL_TEMPLATE, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        request.addJsonContentTypeHeader();
        request.setTimeout(this.api.timeout);

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxUser.getMemberships');

        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        list<BoxGroupMembership.Info> memberships = new list<BoxGroupMembership.Info>();
        Integer totalCount = Integer.valueOf(responseObject.getValue('total_count'));
        if (totalCount != null) {
            list<String> membershipEntries = BoxJsonObject.parseJsonObjectArray(responseObject.getValue('entries'));
            for (String entry : membershipEntries) {
                memberships.add(new BoxGroupMembership.Info(entry));
            }
            System.assertEquals(totalCount, memberships.size());
        }
        return memberships;
    }

    /**
     * Adds a new email alias to this user's account.
     * @param  email the email address to add as an alias.
     * @return       the newly created email alias.
     */
    public BoxEmailAlias.Info addEmailAlias(String email) {
        String url = this.api.baseUrl + String.format(EMAIL_ALIAS_URL_TEMPLATE, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_POST);
        request.addJsonContentTypeHeader();
        request.setTimeout(this.api.timeout);

        BoxEmailAlias.Info requestJson = new BoxEmailAlias.Info();
        requestJson.addValue('email', email);
        request.setBody(requestJson.getJsonString());

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxUser.addEmailAlias');
        return new BoxEmailAlias.Info(responseBody);
    }

    /**
     * Deletes an email alias from this user's account.
     *
     * The IDs of the user's email aliases can be found by calling BoxUser.getEmailAliases.
     *
     * @param emailAliasID the ID of the email alias to delete.
     * @return true if succesful, false if failed (based on expected status code of 204)
     */
    public Boolean deleteEmailAlias(String aliasId) {
        String url = this.api.baseUrl + String.format(EMAIL_ALIAS_URL_TEMPLATE, new String[] {this.getId(), aliasId});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_DELETE);
        request.addJsonContentTypeHeader();
        request.setTimeout(this.api.timeout);

        HttpResponse response = request.send();
        return BoxApiRequest.ensureBoxResourceResponseCode(response, 'BoxUser.deleteEmailAlias', new set<Integer> {204});
    }

    /**
     * Gets a collection of all the email aliases for this user.
     *
     * Note that the user's primary login email is not included in the collection of email aliases.
     *
     * @return a collection of all the email aliases for this user.
     */
    public list<BoxEmailAlias.Info> getEmailAliases() {
        String url = this.api.baseUrl + String.format(EMAIL_ALIASES_URL_TEMPLATE, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);
        request.addJsonContentTypeHeader();
        request.setTimeout(this.api.timeout);

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxUser.getEmailAliases');
        list<BoxEmailAlias.Info> aliases = new list<BoxEmailAlias.Info>();
        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        Integer totalCount = Integer.valueOf(responseObject.getValue('total_count'));
        if (totalCount != null) {
            list<String> aliasEntries = BoxJsonObject.parseJsonObjectArray(responseObject.getValue('entries'));
            for (String entry : aliasEntries) {
                aliases.add(new BoxEmailAlias.Info(entry));
            }
            System.assertEquals(totalCount, aliases.size());
        }
        return aliases;
    }

    /**
     * Deletes a user from an enterprise account.
     * 
     * @param notifyUser whether or not to send an email notification to the user that their account has been deleted.
     * @param force      whether or not this user should be deleted even if they still own files.
     * @return true if successful, false if failed (based on expected status code of 204)
     */
    public Boolean deleteUser(Boolean notifyUser, Boolean force) {
        String url = this.api.baseUrl + String.format(USER_URL_TEMPLATE, new String[] {this.getId()}) + '?notify=' + notifyUser + '&force=' + force;
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_DELETE);
        request.addJsonContentTypeHeader();
        request.setTimeout(this.api.timeout);
        HttpResponse response = request.send();
        return BoxApiRequest.ensureBoxResourceResponseCode(response, 'BoxUser.deleteUser', new set<Integer> {204});
    }

    /**
     * Updates the information about this user with any info fields that have been modified locally.
     *
     * Note: This method is only available to enterprise admins.
     *
     * @param info info the updated info.
     * @return the newly updated user's info
     */
    public BoxUser.Info updateInfo(BoxUser.Info userInfo) {
        String url = this.api.baseUrl + String.format(USER_URL_TEMPLATE, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_PUT);
        request.addJsonContentTypeHeader();
        request.setTimeout(this.api.timeout);
        request.setBody(userInfo.getJsonString());

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxUser.updateInfo');
        BoxUser.Info updatedUserInfo = new BoxUser.Info(responseBody);
        this.setInfo(updatedUserInfo);
        return updatedUserInfo;
    }

    /**
     * Moves all of the owned content from within one user’s folder into a new folder in another user's account.
     * You can move folders across users as long as the you have administrative permissions and the 'source'
     * user owns the folders. Per the documentation at the link below, this will move everything from the root
     * folder, as this is currently the only mode of operation supported.
     *
     * See also https://box-content.readme.io/reference#move-folder-into-another-users-folder
     *
     * @param sourceUserID the user id of the user whose files will be the source for this operation
     * @return info for the newly created folder
     */
    public BoxFolder.Info moveFolderToUser(String sourceUserId) {
        // Currently the API only supports moving of the root folder (0), hence the hard coded "0"
        String url = this.api.baseUrl + String.format(MOVE_FOLDER_TO_USER_TEMPLATE, new String[] {sourceUserId, '0'});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);
        request.addJsonContentTypeHeader();
        request.setTimeout(this.api.timeout);

        BoxUser.Info me = new BoxUser.Info();
        me.addValue('id', this.getId());

        BoxFolder.Info ownedBy = new BoxFolder.Info();
        ownedBy.addValue('owned_by', me.getJsonString());

        request.setBody(ownedBy.getJsonString());

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxUser.moveFolderToUser');
        return new BoxFolder.Info(responseBody);
    }

    private static String buildGetEnterpriseUsersUrl(String baseUrl, String filterTerm, String fields, Integer offset, Integer limitX) {
        String url = baseUrl + USERS_URL_TEMPLATE + '?limit=' + limitX + '&offset=' + offset;
        if (filterTerm != null && filterTerm != '') {
            url += '&filter_term=' + filterTerm;
        }
        if (fields != null && fields != '') {
            url += '&fields=' + fields;
        }
        return url;
    }

    /**
     * Use this to get events for a given user. A chunk of event objects is returned for the user based on the parameters passed in. 
     * Parameters indicating how many chunks are left as well as the next stream_position are also returned.
     * 
     * See also https://box-content.readme.io/reference#event-object
     *
     * @return a collection of events is returned. See the above table for descriptions of the event types.
     */
    public list<BoxEvent.Info> getUserEvents() {
        return getUserEvents('0', 'all', 100);
    }

    /**
     * Use this to get events for a given user. A chunk of event objects is returned for the user based on the parameters passed in. 
     * Parameters indicating how many chunks are left as well as the next stream_position are also returned.
     * 
     * See also https://box-content.readme.io/reference#event-object
     *
     * @param streamPosition (default=0), the location in the event stream at which you want to start receiving events. 
     * Can specify special case ‘now’ to get 0 events and the latest stream position for initialization.
     * @param streamType (default=all), limits the type of events returned: all: returns everything, changes: returns tree changes, sync: returns tree changes only for sync folders
     * @param limit    (default=100 max=800), limits the number of events returned
     * @return a collection of events is returned. See the above table for descriptions of the event types.
     */
    public list<BoxEvent.Info> getUserEvents(String streamPosition, String streamType, Integer numberOfEventsLimit) {
        String url = this.api.baseUrl + String.format(GET_USER_EVENTS_URL, new String[] {streamPosition, streamType, String.valueOf(numberOfEventsLimit)});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);

        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFile.getUserEvents');

        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        list<String> eventEntries = BoxJsonObject.parseJsonObjectArray(responseObject.getValue('entries'));
        list<BoxEvent.Info> events = new list<BoxEvent.Info>();
        for (String eventEntry : eventEntries) {
            events.add(new BoxEvent.Info(eventEntry));
        }
        return events;
    }

    /**
     * Info about BoxUser
     */
    public class Info extends BoxCollaborator.Info {

        public String login {get; private set;}
        public Role role {get; private set;}
        public String language {get; private set;}
        public String timezone {get; private set;}
        public long spaceAmount {get; private set;}
        public long spaceUsed {get; private set;}
        public long maxUploadSize {get; private set;}
        public Boolean canSeeManagedUsers {get; private set;}
        public Boolean isSyncEnabled {get; private set;}
        public Boolean isExternalCollabRestricted {get; private set;}
        public Status status {get; private set;}
        public String jobTitle {get; private set;}
        public String phone {get; private set;}
        public String address {get; private set;}
        public String avatarURL {get; private set;}
        public Boolean isExemptFromDeviceLimits {get; private set;}
        public Boolean isExemptFromLoginVerification {get; private set;}
        public Boolean isPasswordResetRequired {get; private set;}
        public Boolean isPlatformAccessOnly {get; private set;}
        public BoxEnterprise.Info enterprise {get; private set;}
        public String hostname {get; private set;}

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
            super.parseCollaboratorMember(key, value);
            if (key != null) {
                if (key == 'login') {
                    this.login = value;
                } else if (key == 'role') {
                    this.role = BoxUser.parseRole(value.toLowerCase());
                } else if (key == 'language') {
                    this.language = value;
                } else if (key == 'timezone') {
                    this.timezone = value;
                } else if (key == 'space_amount') {
                    this.spaceAmount = Double.valueOf(value).longValue();
                } else if (key == 'space_used') {
                    this.spaceUsed = Double.valueOf(value).longValue();
                } else if (key == 'max_upload_size') {
                    this.maxUploadSize = Double.valueOf(value).longValue();
                } else if (key == 'can_see_managed_users') {
                    this.canSeeManagedUsers = Boolean.valueOf(value);
                } else if (key == 'is_sync_enabled') {
                    this.isSyncEnabled = Boolean.valueOf(value);
                } else if (key == 'is_external_collab_restricted') {
                    this.isExternalCollabRestricted = Boolean.valueOf(value);
                } else if ( key == 'status') {
                    this.status = Boxuser.parseStatus(value.toLowerCase());
                } else if (key == 'job_title') {
                    this.jobTitle = value;
                } else if (key == 'phone') {
                    this.phone = value;
                } else if (key == 'address') {
                    this.address = value;
                } else if (key == 'avatar_url') {
                    this.avatarURL = value;
                } else if (key == 'is_exempt_from_device_limits') {
                    this.isExemptFromDeviceLimits = Boolean.valueOf(value);
                } else if (key == 'is_exempt_from_login_verification') {
                    this.isExemptFromLoginVerification = Boolean.valueOf(value);
                } else if (key == 'is_password_reset_required') {
                    this.isPasswordResetRequired = Boolean.valueOf(value);
                } else if (key == 'is_platform_access_only') {
                    this.isPlatformAccessOnly = Boolean.valueOf(value);
                } else if (key == 'enterprise') {
                    this.enterprise = new BoxEnterprise.Info(value);
                } else if (key == 'hostname') {
                    this.hostname = value;
                }
            }
         }

    }

    /**
     * Enumerates the possible roles that a user can have within an enterprise.
     */
    public enum Role {
        /**
         * The user is an administrator of their enterprise.
         */
        ADMIN,

        /**
         * The user is a co-administrator of their enterprise.
         */
        COADMIN,

        /**
         * The user is a regular user within their enterprise.
         */
        USER
    }

    /**
     * Enumerates the possible statuses that a user's account can have.
     */
    public enum Status {
        /**
         * The user's account is active.
         */
        ACTIVE,

        /**
         * The user's account is inactive.
         */
        INACTIVE,

        /**
         * The user's account cannot delete or edit content.
         */
        CANNOT_DELETE_EDIT,

        /**
         * The user's account cannot delete, edit, or upload content.
         */
        CANNOT_DELETE_EDIT_UPLOAD
    }

    public static BoxUser.Role parseRole(String value) {
        if (value == 'admin') {
            return BoxUser.Role.ADMIN;
        } else if (value == 'coadmin') {
            return BoxUser.Role.COADMIN;
        } else if (value == 'user') {
            return BoxUser.Role.USER;
        }
        return null;
    }

    public static String getRoleAsString(BoxUser.Role value) {
        if (value == BoxUser.Role.ADMIN) {
            return 'admin';
        } else if (value == BoxUser.Role.COADMIN) {
            return 'coadmin';
        } else if (value == BoxUser.Role.USER) {
            return 'user';
        }
        return null;
    }

    public static BoxUser.Status parseStatus(String value) {
        if (value == 'active') {
            return BoxUser.Status.ACTIVE;
        } else if (value == 'inactive') {
            return BoxUser.Status.INACTIVE;
        } else if (value == 'cannot_delete_edit') {
            return BoxUser.Status.CANNOT_DELETE_EDIT;
        } else if (value == 'cannot_delete_edit_upload') {
            return BoxUser.Status.CANNOT_DELETE_EDIT_UPLOAD;
        }
        return null;
    }

    public static String getStatusAsString(BoxUser.Status value) {
        if (value == BoxUser.Status.ACTIVE) {
            return 'active';
        } else if (value == BoxUser.Status.INACTIVE) {
            return 'inactive';
        } else if (value == BoxUser.Status.CANNOT_DELETE_EDIT) {
            return 'cannot_delete_edit';
        } else if (value == BoxUser.Status.CANNOT_DELETE_EDIT_UPLOAD) {
            return 'cannot_delete_edit_upload';
        }
        return null;
    }
}