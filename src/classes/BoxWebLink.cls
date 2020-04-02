/**
 * Represents a web link (bookmark) on Box. This class can be used to create, read, update, and
 * delete a bookmark.
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

    private static String WEB_LINK_INFO_URL = 'web_links/{0}';
    private static String WEB_LINK_TRASH_URL = 'web_links/{0}/trash';

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
     * Gets information of BoxWebLink.
     *
     * @return information about BoxWebLink
     */
    public BoxWebLink.Info getWebLinkInfo() {
        String url =
            this.api.baseUrl +
            String.format(WEB_LINK_INFO_URL, new List<String>{ this.getId() });
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
     * Updates the information about this web link with any info fields passed in info object.
     *
     * @param info with info fields to be updated.
     *
     * @return updated information of BoxWebLink
     */
    public BoxWebLink.Info updateWebLinkInfo(BoxWebLink.Info info) {
        String url =
            this.api.baseUrl +
            String.format(WEB_LINK_INFO_URL, new List<String>{ this.getId() });
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
            'BoxWebLink.Info'
        );
        BoxWebLink.Info webLinkInfo = new BoxWebLink.Info(responseBody);
        this.setInfo(webLinkInfo);
        return webLinkInfo;
    }

    /**
     * Creates a shared link for this particular web link.
     *
     * This method gets default shared link status, set it to an empty access level. Please see https://support.box.com/hc/en-us/articles/200520888?
     * for more information on the permissions available for shared links.
     *
     * @return A full web link object containing the updated shared link is returned if the ID is valid and if the update is successful.
     */
    public BoxSharedLink.Info createSharedLink() {
        return createSharedLink(new BoxSharedLink.Info());
    }

    /**
     * Creates a shared link for this particular web link.
     *
     * In order to get default shared link status, set it to an empty access level, i.e. {"shared_link": {}}.
     * In order to disable a shared link, send this same type of PUT request with the value of shared_link set to null, i.e. {"shared_link": null}
     * Please see https://support.box.com/hc/en-us/articles/200520888? for more information on the permissions available for shared links.
     *
     * @param  BoxSharedLink.Info object.
     * @return A full web link object containing the updated shared link is returned if the ID is valid and if the update is successful.
     */
    public BoxSharedLink.Info createSharedLink(
        BoxSharedLink.Info sharedLinkParams
    ) {
        String url =
            this.api.baseUrl +
            String.format(WEB_LINK_INFO_URL, new List<String>{ this.getId() });
        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_PUT
        );

        request.setBody(sharedLinkParams.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(
            response,
            'BoxWebLink.createSharedLink'
        );
        BoxWebLink.Info webLink = new BoxWebLink.Info(responseBody);
        return webLink.sharedLink;
    }

    public override BoxItem.Info copy(BoxFolder destination) {
        throw new BoxWebLink.BoxWebLinkException(
            'Copy operation not available for web links'
        );
    }

    public override BoxItem.Info copy(BoxFolder destination, String newName) {
        throw new BoxWebLink.BoxWebLinkException(
            'Copy operation not available for web links'
        );
    }

    public override BoxItem.Info move(BoxFolder destination) {
        throw new BoxWebLink.BoxWebLinkException(
            'Move operation not available for web links'
        );
    }

    public override BoxItem.Info move(BoxFolder destination, String newName) {
        throw new BoxWebLink.BoxWebLinkException(
            'Move operation not available for web links'
        );
    }

    /**
     * Deletes this web link, discards a web link to the trash.
     *
     * @return true if web link is deleted succesfully, false otherwise.
     */
    public Boolean deleteWebLink() {
        return this.deleteWebLink(null);
    }

    /**
     * Deletes this web link, discards a web link to the trash.
     *
     * @param  eTag the etag of the web link can be included as an ‘If-Match’ header to prevent race conditions.
     * @return      true if web link is deleted succesfully, false otherwise.
     */
    public Boolean deleteWebLink(string eTag) {
        String url =
            this.api.baseUrl +
            String.format(WEB_LINK_INFO_URL, new List<String>{ this.getId() });
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
     * Gets web link from trash, with the Box web link id passed in
     *
     * @return  a Box web link that has been retrieved from trash
     */
    public BoxWebLink.Info getTrashedWebLink() {
        String url =
            this.api.baseUrl +
            String.format(WEB_LINK_TRASH_URL, new List<String>{ this.getId() });

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
            'BoxWebLink.getTrashedWebLink'
        );

        return new BoxWebLink.Info(responseBody);
    }

    /**
     * Renames this web link.
     *
     * @param newName the new name of the web link.
     * @return        true if web link is renamed succesfully, false otherwise.
     */
    public Boolean rename(string newName) {
        String url =
            this.api.baseUrl +
            String.format(WEB_LINK_INFO_URL, new List<String>{ this.getId() });
        BoxApiRequest request = new BoxApiRequest(
            this.api,
            url,
            BoxApiRequest.METHOD_PUT
        );

        BoxWebLink.Info webLinkInfo = new BoxWebLink.Info();
        webLinkInfo.addValue('id', this.getId());
        if (newName != null) {
            webLinkInfo.addValue('name', newName);
        }

        request.setBody(webLinkInfo.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();

        return BoxApiRequest.ensureBoxResourceResponseCode(
            response,
            'BoxWebLink.rename',
            new Set<Integer>{ 200 }
        );
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
