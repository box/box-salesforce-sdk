/**
 * Represents a link to a file or folder on Box.
 */

public class BoxSharedLink extends BoxResource{

    /**
     * Constructs a BoxSharedLink for an item with a given ID.
     *
     * @param  api the API connection to be used by the item.
     * @param  id  the ID of the item.
     */
    public BoxSharedLink(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'shared_link';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxSharedLink.Info) jsonObject;
    }

    /**
     * Contains information about a shared link.
     */
    public class Info extends BoxResource.Info {

        public String url {get; private set;}
        public String downloadUrl {get; private set;}
        public String vanityUrl {get; private set;}
        public Boolean isPasswordEnabled {get; private set;}
        public DateTime unsharedAt {get; private set;}
        public long downloadCount {get; private set;}
        public long previewCount {get; private set;}
        public BoxSharedLink.Access access {get; private set;}
        public BoxSharedLink.Permissions permissions {get; private set;}

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

        /**
         * Constructs an Info object using parameters passed in.
         *
         * @param  access           the level of access required for this shared link. Can be open, company, collaborators, or null to get default share level.
         * @param  unshared_at      the day that this link should be disabled at. Timestamps are rounded off to the given day. This field can only be set if the user is not a free user.
         * @param  password         requiring a password before viewing a shared link.
         * @param  permissions      the set of permissions that apply to this link
         * @param  can_download     whether this link allows downloads.
         * @param  can_preview      whether this link allows previewing. Can only be used with open and company
         * @param  effective_access read-only attribute returned in object The access level set by the enterprise administrator.
         *                          This will override any previous access levels set for the shared link and prevent any less-restrictive access levels to be set
         */
        public Info(String access, String unsharedAt, String password, String permissions, Boolean canDownload, Boolean canPreview, String effectiveAccess)
        {
            super();
            if (access != null) {
                this.addValue('access', access);
            } 
            if (unsharedAt != null) {
                this.addValue('unshared_at', unsharedAt);
            }
            if (password != null) {
                this.addValue('password', password);
            }
            if (permissions != null) {
                this.addValue('permissions', permissions);
            }
            if (canDownload != null) {
                this.addValue('can_download', String.valueOf(canDownload));
            }
            if (canPreview != null) {
                this.addValue('password', String.valueOf(canPreview));
            }
            if (effectiveAccess != null) {
                this.addValue('effective_access', effectiveAccess);
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

        @testvisible
        private void parseMember(String key, String value) {
            super.parseResourceMember(key, value);
            if (key != null) {
                if (key == 'url') {
                    this.url = value;
                } else if (key == 'download_url') {
                    this.downloadUrl = value;
                } else if (key == 'vanity_url') {
                    this.vanityUrl = value;
                } else if (key == 'is_password_enabled') {
                    this.isPasswordEnabled = Boolean.valueOf(value);
                } else if (key == 'unshared_at') {
                    this.unsharedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'download_count') {
                    this.downloadCount = long.valueOf(value);
                } else if (key == 'preview_count') {
                    this.previewCount = long.valueOf(value);
                } else if (key == 'access') {
                    this.access = BoxSharedLink.parseAccess(value);
                } else if (key == 'permissions') {
                    this.permissions = new Permissions(value);
                }
            }
        }
    }

    /**
     * Contains permissions fields that can be set on a shared link.
     */
    public class Permissions extends BoxResource.Info {

        public Boolean canDownload {get; private set;}
        public Boolean canPreview {get; private set;}

        public Permissions() {
            super();
        }

        public Permissions(String jsonString) {
            super(jsonString);
            for (String key : this.children.keySet()) {
                   this.parseMember(key, this.children.get(key));
            }
        }

        public Permissions(BoxJsonObject jsonObject) {
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
            if (key != null) {
                if (key == 'can_download') {
                    this.canDownload = Boolean.valueOf(value);
                } else if (key == 'can_preview') {
                    this.canPreview = Boolean.valueOf(value);
                }
            }
        }
    }

    /**
     * Enumerates the possible access levels that can be set on a shared link.
     */
    public enum Access {
        /**
         * The default access level for the user or enterprise.
         */
        DEFAULT_ACCESS,

        /**
         * The link can be accessed by anyone.
         */
        OPEN,

        /**
         * The link can be accessed by other users within the company.
         */
        COMPANY,

        /**
         * The link can be accessed by other collaborators.
         */
        COLLABORATORS
    }

    public static BoxSharedLink.Access parseAccess(String value) {
        if (value != null) {
            if (value == 'default') {
                return BoxSharedLink.Access.DEFAULT_ACCESS;
            } else if (value == 'open') {
                return BoxSharedLink.Access.OPEN;
            } else if (value == 'company') {
                return BoxSharedLink.Access.COMPANY;
            } else if (value == 'collaborators') {
                return BoxSharedLink.Access.COLLABORATORS;
            }
         }
         return null;
    }

    public static String getAccessAsString(BoxSharedLink.Access value) {
        if (value == BoxSharedLink.Access.DEFAULT_ACCESS) {
            return 'default';
        } else if (value == BoxSharedLink.Access.OPEN) {
            return 'open';
        } else if (value == BoxSharedLink.Access.COMPANY) {
            return 'company';
        } else if (value == BoxSharedLink.Access.COLLABORATORS) {
            return 'collaborators';
        }
        return null;
    }
}