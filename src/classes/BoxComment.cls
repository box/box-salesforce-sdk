/**
 * Represents a comment on a file. Comments can be added directly to a file or they can be created as replies to other
 * comments.
 */

public class BoxComment extends BoxResource {

    private static Pattern MENTION_REGEX = Pattern.compile('@\\[.+:.+\\]');
    private static string UPDATE_COMMENT_URL =  'comments/{0}';

    /**
     * Constructs a BoxComment with api and given ID.
     *
     * @param  api the API connection to be used by the comment.
     * @param  id  the ID of the comment.
     */
    public BoxComment(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'comment';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxComment.Info) jsonObject;
    }

    /**
     * Determines if a comment message contains an @mention.
     * @param  message the comment message.
     * @return true if the message contains an @mention; otherwise false.
     */
    public static boolean messageContainsMention(String message) {
        return MENTION_REGEX.matcher(message).find();
    }

    /**
     * Gets a list of comments BoxItem.
     * @return a list of comments on BoxItem.
     */
    public static list<BoxComment.Info> getComments(BoxApiConnection api, String url) {
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_GET);

        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'getComments');

        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        list<String> commentEntries = BoxJsonObject.parseJsonObjectArray(responseObject.getValue('entries'));
        list<BoxComment.Info> comments = new list<BoxComment.Info>();
        for (String commentEntry : commentEntries) {
            comments.add(new BoxComment.Info(commentEntry));
        }
        return comments;
    }

    /**
     * Adds a comment to BoxItem. The message can contain @mentions by using the string @[userid:username] anywhere
     * within the message, where userid and username are the ID and username of the person being mentioned.
     * @see    <a href="https://developers.box.com/docs/#comments-add-a-comment-to-an-item">the tagged_message field
     *         for including @mentions.</a>
     * @param  message the comment's message.
     * @return information about the newly added comment.
     */
    public static BoxComment.Info addComment(BoxApiConnection api, String url, BoxComment.Info commentInfo) {
        BoxApiRequest request = new BoxApiRequest(api, url, BoxApiRequest.METHOD_POST);

        request.setBody(commentInfo.getJsonString());
        request.setTimeout(api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'addComment');
        return new BoxComment.Info(responseBody);
    }

    /**
     * Updates the message of the comment. 
     * @see    https://box-content.readme.io/reference#change-a-comments-message
     * @param  message required, The desired text for the comment message.
     * @return The full updated comment object is returned if the ID is valid and if the user has access to the comment.
     */
    public BoxComment.Info updateComment(String message) {
        String url = this.api.baseUrl + String.format(UPDATE_COMMENT_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_PUT);

        BoxGenericJsonObject updateParams = new BoxGenericJsonObject();
        updateParams.addValue('message', message);

        request.setBody(updateParams.getJsonString());
        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxComment.UpdateComment');
        return new BoxComment.Info(responseBody);
    }

    /**
     * Deletes this comment.
     */
    public Boolean deleteComment() {
        String url = this.api.baseUrl + String.format(UPDATE_COMMENT_URL, new String[] {this.getId()});
        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_DELETE);

        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        return BoxApiRequest.ensureBoxResourceResponseCode(response, 'BoxComment.deleteComment', new set<Integer> {204});
    }

    /**
     * Contains information about a BoxComment.
     */
    public class Info extends BoxResource.Info {

        public String id;
        public boolean isReplyComment;
        public String message;
        public String taggedMessage;
        public BoxUser.Info createdBy;
        public DateTime createdAt;
        public DateTime modifiedAt;
        public BoxResource.Info item;
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

        private void parseMember(String key, String value) {
            if (key != null) {
                if (key == 'is_reply_comment') {
                    this.isReplyComment = Boolean.valueOf(value);
                } else if (key == 'message') {
                    this.message = value;
                } else if (key == 'tagged_message') {
                    this.taggedMessage = value;
                } else if (key == 'created_by') {
                    this.createdBy = new BoxUser.Info(value);
                } else if (key == 'created_at') {
                    this.createdAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'modified_at') {
                    this.modifiedAt = BoxDateFormat.parseBoxDateTimeString(value);
                } else if (key == 'item') {
                    // If type == file parse item as BoxFile.Info
                    // else if type == comment parse item as BoxComment.Info
                    this.item = BoxResource.parseBoxResource(value);
                } else if (key == 'modified_by') {
                    this.modifiedBy = new BoxUser.Info(value);
                }
            } 
         }
    }
}