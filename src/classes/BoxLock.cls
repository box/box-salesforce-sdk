/**
 * Represents a lock placed on a Box File
 */

public class BoxLock extends BoxResource {

    /**
     * Constructs a BoxLock
     *
     * @param  api the API connection to be used to create the Box Lock
     * @param  id of the Box Lock
     */
    public BoxLock(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'boxlock';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxEmailAlias.Info) jsonObject;
    }

    /**
     * Contains information about a BoxLock
     */
    public class Info extends BoxResource.Info {

		public DateTime expiresAt {get; private set;}
		public DateTime createdAt {get; private set;}
		public String lockedType {get; private set;}
		public Boolean isDownloadPrevented {get; private set;}
		public BoxUser.Info createdBy {get; private set;}

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

		public Info(DateTime expiresAt, Boolean isDownloadPrevented, String lockedType){
			this.expiresAt = expiresAt;
			this.isDownloadPrevented = isDownloadPrevented;
			this.lockedType = lockedType;

			this.addValue('expires_at', BoxDateFormat.getBoxDateTimeString(expiresAt));
			this.addValue('is_download_prevented', isDownloadPrevented);
			this.addValue('type', lockedType);
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

        public void parseMember(String key, String value) {
            super.parseResourceMember(key, value);
            if (key != null) {
                if (key == 'expires_at') {
                    this.expiresAt = BoxDateFormat.getBoxDateTimeString(value);
                } else if (key == 'created_at') {
                    this.createdAt = BoxDateFormat.getBoxDateTimeString(value);
                } else if (key == 'type'){
					this.lockedType = value;
				} else if (key == 'is_download_prevented'){
					this.isDownloadPrevented = Boolean.valueOf(value);
				} else if (key == 'created_by'){
					this.createdBy = new BoxUser.Info(value);
				}
            }
        }
    }
}
