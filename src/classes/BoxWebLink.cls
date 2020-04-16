/**
 * Represents a web link (bookmark) on Box
 */

public class BoxWebLink extends BoxItem {
    /**
     * An array of all possible web link fields.
     */
    public static final list<String> ALL_FIELDS = new List<String>{
        'type',
        'id',
        'sequence_id',
        'etag',
        'sha1',
        'name',
        'url',
        'description',
        'size',
        'path_collection',
        'created_at',
        'modified_at',
        'trashed_at',
        'purged_at',
        'content_created_at',
        'content_modified_at',
        'created_by',
        'modified_by',
        'owned_by',
        'shared_link',
        'parent',
        'item_status'
    };

    private static final String WEB_LINK_URL_PATH = 'web_links/{0}';
    private static final String TRASH_URL_PATH_SEGMENT = '/trash';

    /**
     * Constructs a BoxWebLink for a web link with a given ID.
     *
     * @param  api the API connection to be used by the web link.
     * @param  id  the ID of the web link.
     */
    public BoxWebLink(BoxApiConnection api, String id) {
        super(api, id);
        this.information = new BoxWebLink.Info();
    }

    public override String getObjectType() {
        return 'web_link';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = new BoxWebLink.Info(jsonObject);
    }

    /**
     * Get a Web Link's Information
     *
     * @return the web link's information
     */
    public BoxWebLink.Info getWebLinkInfo() {
        String url =
            this.api.baseUrl +
            String.format(WEB_LINK_URL_PATH, new List<String>{ this.getId() });

        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_GET
        );
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();

        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxWebLink.getWebLinkInfo'
        );
        return new BoxWebLink.Info(responseBody);
    }

    /**
     * Create a Web Link
     *
     * @param  info the new web link's info
     * @return      the created web link's info
     */
    public BoxWebLink.Info createWebLink(BoxWebLink.Info info) {
        String url =
            this.api.baseUrl +
            String.format(WEB_LINK_URL_PATH, new List<String>{ '' });

        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_POST
        );
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();
        request.setBody(info.getJsonString());

        HttpResponse response = request.send();

        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxWebLink.createWebLink'
        );

        BoxWebLink.Info webLinkInfo = new BoxWebLink.Info(responseBody);
        this.setInfo(webLinkInfo);

        return webLinkInfo;
    }

    /**
     * Update a Web Link's Information
     *
     * @param info  the web link info to update
     * @return      the updated web link's info
     */
    public BoxWebLink.Info updateWebLinkInfo(BoxWebLink.Info info) {
        String url =
            this.api.baseUrl +
            String.format(WEB_LINK_URL_PATH, new List<String>{ this.getId() });

        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_PUT
        );
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();
        request.setBody(info.getJsonString());

        HttpResponse response = request.send();

        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxWebLink.updateWebLinkInfo'
        );

        BoxWebLink.Info webLinkInfo = new BoxWebLink.Info(responseBody);
        this.setInfo(webLinkInfo);

        return webLinkInfo;
    }

    /**
     * Delete a Web Link
     *
     * @return true if web link is deleted succesfully, false otherwise
     */
    public Boolean deleteWebLink() {
        return this.deleteWebLink(null);
    }

    /**
     * Delete a Web Link
     *
     * @param  eTag the etag can be included as an ‘If-Match’ header to prevent race conditions
     * @return      true if web link is deleted succesfully, false otherwise
     */
    public Boolean deleteWebLink(string eTag) {
        String url =
            this.api.baseUrl +
            String.format(WEB_LINK_URL_PATH, new List<String>{ this.getId() });

        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_DELETE
        );

        BoxWebLink.Info webLinkInfo = new BoxWebLink.Info();
        webLinkInfo.addValue('id', this.getId());
        if (eTag != null) {
            webLinkInfo.addValue('eTag', eTag);
        }

        request.setBody(webLinkInfo.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        return BoxApiRequest.ensureBoxResourceResponseCode(
            response,
            'BoxWebLink.deleteWebLink',
            new Set<Integer>{ 204 }
        );
    }

    /**
     * Get a Trashed Web Link's Information
     *
     * @return the trashed web link's info
     */
    public BoxWebLink.Info getTrashedWebLinkInfo() {
        String url =
            this.api.baseUrl +
            String.format(
                WEB_LINK_URL_PATH,
                new List<String>{ this.getId() + TRASH_URL_PATH_SEGMENT }
            );

        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_GET
        );
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();

        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxWebLink.getTrashedWebLinkInfo'
        );

        return new BoxWebLink.Info(responseBody);
    }

    /**
     * Restore a Trashed Web Link
     *
     * @return the restored web link's info
     */
    public BoxWebLink.Info restoreTrashedWebLink() {
        String url =
            this.api.baseUrl +
            String.format(WEB_LINK_URL_PATH, new List<String>{ this.getId() });

        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_POST
        );
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();

        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxWebLink.restoreTrashedWebLink'
        );

        return new BoxWebLink.Info(responseBody);
    }

    /**
     * Permanently Delete a Web Link
     *
     * @return true if web link is permanently deleted succesfully, false otherwise
     */
    public Boolean permanentlyDeleteWebLink() {
        String url =
            this.api.baseUrl +
            String.format(
                WEB_LINK_URL_PATH,
                new List<String>{ this.getId() + TRASH_URL_PATH_SEGMENT }
            );

        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_DELETE
        );
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();

        return BoxApiRequest.ensureBoxResourceResponseCode(
            response,
            'BoxWebLink.permanentlyDeleteWebLink',
            new Set<Integer>{ 204 }
        );
    }

    public override BoxItem.Info copy(BoxFolder destination) {
        throw new BoxWebLinkException('Method Not Implemented');
    }

    public override BoxItem.Info copy(BoxFolder destination, String newName) {
        throw new BoxWebLinkException('Method Not Implemented');
    }

    public override BoxItem.Info move(BoxFolder destination) {
        throw new BoxWebLinkException('Method Not Implemented');
    }

    public override BoxItem.Info move(BoxFolder destination, String newName) {
        throw new BoxWebLinkException('Method Not Implemented');
    }

    /**
     * Information about BoxWebLink
     */
    public class Info extends BoxItem.Info {
        public String sha1;

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
                }
            }
        }
    }

    public class BoxWebLinkException extends Exception {
    }
}
