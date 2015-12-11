/**
 * Represents an enterprise organization on Box.
 */

public class BoxEnterprise extends BoxResource {

    private static final String GET_ENTERPRISE_EVENTS_URL = '/events?stream_type=admin_logs&limit={0}&stream_position={1}';

    /**
     * Constructs a BoxEnterprise with a given ID.
     *
     * @param  api the API connection to be used by the enterprise.
     * @param  id  the ID of the enterprise.
     */
    public BoxEnterprise(BoxApiConnection api, String id) {
        super(api, id);
    }

    public override String getObjectType() {
        return 'enterprise';
    }

    public override void setInfo(BoxJsonObject jsonObject) {
        this.information = (BoxEnterprise.Info) jsonObject;
    }

    /**
     * Retrieves up to a year' events for all users in an enterprise. Upper and lower bounds as well as filters can be applied to the results. 
     * 
     * Get enterprise event with default values stream_type=admin_logs, limit=100, stream_position=0
     *
     * @param stream_type (required) String URL Parameter, must be 'admin_logs'
     * @param limit Integer URL Parameter (default=100 max=500),limits the number of events returned
     * @param stream_position String URL Parameter (default=0), the starting position for fetching the events. This is used in combination with the limit to determine which events to return to the caller. 
     *           Use the results from the next_stream_position of your last call to get the next set of events.
     */
    public list<BoxEvent.Info> getEnterpriseEvents() {
        return getEnterpriseEvents(100, '0', null, null, null);
    }

    /**
     * Retrieves up to a year' events for all users in an enterprise. Upper and lower bounds as well as filters can be applied to the results. 
     * A list of valid values for event_type can be found at https://box-content.readme.io/reference#page-events.
     * 
     * @param streamType (required) String URL Parameter, must be 'admin_logs'
     * @param limit Integer URL Parameter (default=100 max=500),limits the number of events returned
     * @param streamPosition String URL Parameter (default=0), the starting position for fetching the events. This is used in combination with the limit to determine which events to return to the caller. 
     *           Use the results from the next_stream_position of your last call to get the next set of events.
     * @param eventType String URL Parameter, a comma-separated list of events to filter by
     * @param createdAfter Timestamp URL Parameter, a lower bound on the timestamp of the events returned
     * @param createdBefore Timestamp URL Parameter, an upper bound on the timestamp of the events returned
     * @return a collection of events for all users in an enterprise
     *
     */
    public list<BoxEvent.Info> getEnterpriseEvents(Integer numberOfEventsLimit, String streamPosition, String eventType, String createdAfter, String createdBefore) {
        String url = this.api.baseUrl + String.format(GET_ENTERPRISE_EVENTS_URL, new String[] {streamPosition,String.valueOf(numberOfEventsLimit)});

        if (eventType != null) {
            url = String.format( url + '&event_type={0}', new String[]{eventType});
        }
        if (createdAfter != null) {
            url = String.format( url + '&created_after={0}', new String[]{createdAfter});
        }
        if (createdBefore != null) {
            url = String.format( url + '&created_before={0}', new String[]{createdBefore});
        }

        BoxApiRequest request = new BoxApiRequest(this.api, url, BoxApiRequest.METHOD_GET);

        request.setTimeout(this.api.timeout);
        request.addJsonContentTypeHeader();

        HttpResponse response = request.send();
        String responseBody = BoxApiRequest.getBoxResourceResponseBody(response, 'BoxEnterprise.getEnterpriseEvents');

        BoxGenericJsonObject responseObject = new BoxGenericJsonObject(responseBody);
        list<String> eventEntries = BoxJsonObject.parseJsonObjectArray(responseObject.getValue('entries'));
        list<BoxEvent.Info> events = new list<BoxEvent.Info>();
        for (String eventEntry : eventEntries) {
            events.add(new BoxEvent.Info(eventEntry));
        }
        return events;
    }

    /**
     * Contains information about a BoxEnterprise.
     */
    public class Info extends BoxResource.Info {

        public String name {get; private set;}

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
            super.parseResourceMember(key, value);
            if (key != null) {
                if (key == 'name') {
                    this.name = value;
                }
            }
        }
    }
}