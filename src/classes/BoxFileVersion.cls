/**
 * Represents a particular version of a file on Box.
 */

public class BoxFileVersion extends BoxResource {

    private static String VIEW_FILE_VERSIONS_URL = 'files/{0}/versions';
    private static String FILE_VERSIONS_URL = 'files/{0}/versions/{1}';
    private static String FILE_PROMOTE_VERSION_URL = 'files/{0}/versions/current';

    /**
     * Constructs a BoxFileVersion from a JSON string.
     *
     * @param  api    the API connection to be used by the file.
     * @param  fileID the ID of the file.
     */
    public BoxFileVersion(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'fileversion';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxFileVersion.Info) jsonObject;
    }
    
    public void setFileId(String fileId) {
    	if (this.information == null) {
    		this.information = new BoxFileVersion.Info();
    	}
    	this.information.addValue('file_id', fileId);
    }

    /**
     * Deletes this version of the file.
     *
     * @return Boolean, true if version is deleted succesfully, false otherwise.
     */
    public Boolean deleteVersion() {
        return this.deleteVersion(null);
    }

    /**
     * Deletes this version of the file.
     *
     * @param  version
     * @param  eTag the etag of the file can be included as an ‘If-Match’ header.
     * @return      true if version is deleted succesfully, false otherwise.
     */
    public Boolean deleteVersion(String eTag) {
    	BoxFileVersion.Info currentInfo = (BoxFileVersion.Info) this.getInfo();
        String url = this.api.baseUrl + String.format(FILE_VERSIONS_URL, new String[] {currentInfo.fileId, this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_DELETE);

        if(eTag != null) {
            BoxGenericJsonObject jsonObject = new BoxGenericJsonObject();
            jsonObject.addValue('eTag', eTag);
            request.setBody(jsonObject.getJsonString());
        }

        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        return BoxApiRequest.ensureBoxResourceResponseCode(response, 'BoxFile.deleteVersion', new set<Integer> {204});
    }

      /**
       * Promotes this version of the file to be the latest version.
       * 
       * @param  versionId file version id
       * @return           information about new file version
       */
      public BoxFileVersion.Info promoteFileVersion() {
          return this.promoteVersion('file_version');
      }

      /**
       * Promotes this version of the file to be the latest version.
       * 
       * @param  itemType  must be ‘file_version’ for this request
       * @param  versionId file version id
       * @return           information about new file version
       */
      public BoxFileVersion.Info promoteVersion(String itemType) {
      	BoxFileVersion.Info currentInfo = (BoxFileVersion.Info) this.getInfo();
        String url = this.api.baseUrl + String.format(FILE_PROMOTE_VERSION_URL, new String[] {currentInfo.fileId});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_POST);

        BoxGenericJsonObject jsonObject = new BoxGenericJsonObject();
        jsonObject.addValue('type', itemType);
        jsonObject.addValue('id', this.getId());
        request.setBody(jsonObject.getJsonString());

        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxFileVersion.promoteVersion');
        return new BoxFileVersion.Info(responseBody);
    }

    /**
     * Information about BoxFileVersion
     */
    public class Info extends BoxResource.Info {

        public String fileID;
        public String versionID;
        public String sha1;
        public String name;
        public long size;
        public DateTime createdAt;
        public DateTime modifiedAt;
        public BoxUser.Info modifiedBy;

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
                if (key == 'id') {
                    this.versionID = value;
                } else if (key == 'sha1') {
                    this.sha1 = value;
                } else if (key == 'name') {
                    this.name = value;
                } else if (key == 'size') {
                    this.size = Double.valueOf(value).longValue();
                } else if (key == 'created_at') {
                    this.createdAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'modified_at') {
                    this.modifiedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'modified_by') {
                    this.modifiedBy = new BoxUser.Info(value);
                } else if (key == 'file_id') {
                    this.fileId = value;
                }
            }
        }
    }
}