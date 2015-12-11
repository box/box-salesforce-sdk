/**
 * The abstract base class for all types that contain JSON data returned by the Box API. 
 *
 * The most common implementation of BoxJsonObject is BoxResource.Info and its subclasses.
 */
public abstract class BoxJsonObject {

    /** A set of valid JSONToken values */
    private static final set<JSONToken> VALID_TOKEN_VALUES = new set<JSONToken> 
        {
            JSONToken.VALUE_FALSE, 
            JSONToken.VALUE_TRUE, 
            JSONToken.VALUE_NULL, 
            JSONToken.VALUE_NUMBER_FLOAT, 
            JSONToken.VALUE_NUMBER_INT, 
            JSONToken.VALUE_STRING
        };

    /** A set of token names that are always Integers */
    private static final set<String> INTEGER_TOKEN_NAMES = new set<String>
        {
            'total_count',
            'size',
            'download_count',
            'preview_count',
            'offset',
            'limit',
            'space_amount',
            'space_used',
            'max_upload_size',
            'expires_in',
            'exp'
        };

    /** A set of token values that indicate a boolean value */
    private static final set<String> BOOLEAN_TOKEN_VALUES = new set<String> 
        {
            'true',
            'false'
        };

    /** The raw json string associated with this BoxJsonObject */
    protected String jsonString;

    /** A map of the child objects of this BoxJsonObject */
    public map<String, String> children {get; protected set;}

    /** A flag to indicate whether the json string representation of this object needs to be re-created */
    protected Boolean rebuildJsonString;

    /**
     * Constructs an empty BoxJsonObject.
     */
    public BoxJsonObject() {
        this('');
    }

    /**
     * Constructs a BoxJsonObject by decoding it from a JSON string.
     *
     * @param String jsonString The JSON string to decode.
     */
    public BoxJsonObject(String jsonString) {
        this.rebuildJsonString = true;
        this.jsonString = jsonString;
        this.children = new map<String, String>();
        if (jsonString != null && jsonString != '') {
            readFrom(jsonString);
        }
    }

    /**
     * Constructs a BoxJsonObject using an already parsed JSON object.
     *
     * @param BoxJsonObject jsonObject The parsed JSON object.
     */
    public BoxJsonObject(BoxJsonObject jsonObject) {
        this.rebuildJsonString = true;
        this.jsonString = jsonObject.jsonString;
        this.children = jsonObject.children;
    }

    /**
     * Gets a current value in the children map
     *
     * @param String key The key value of the children map to look up.
     */
    public String getValue(String key) {
        return this.children.get(key);
    }

    /**
     * Adds a value to the children map
     *
     * @param String key The key to be added to the map.
     * @param String value The value to be added to the map.
     */
    public virtual void addValue(String key, String value) {
        if (key != null) {
            this.children.put(key, value);
            this.rebuildJsonString = true;
        }
    }

    /**
     * Adds a value to the children map from an existing BoxJsonObject (adding a folder to the "parent", for example)
     *
     * @param String key The key to be added to the map.
     * @param BoxJsonObject value The value to be added to the map after converting to a raw json string.
     */
    public virtual void addValue(String key, BoxJsonObject value) {
        addValue(key, value.getJsonString());
    }

    /**
     * Updates and returns the raw json string for this BoxJsonObject
     */
    public String getJsonString() {
        if (rebuildJsonString) {
            updateJsonString();
        }
        return this.jsonString;
    }

    /**
     * Recreates the raw json string for this BoxJsonObject based on the children that are present in the children map
     */
    private void updateJsonString() {
        String jsonStringValue = '{';
        for (String key : this.children.keySet()) {
            String value = this.children.get(key);
            jsonStringValue += '"' + key + '":';
            if (value == null) {
                jsonStringValue += 'null,';
            } else if (value.startsWith('{') || value.startsWith('[') ||
                         INTEGER_TOKEN_NAMES.contains(key) || BOOLEAN_TOKEN_VALUES.contains(value)) {
                jsonStringValue += value + ',';
            } else {
                jsonStringValue += '"' + value + '",';
            }
        }
        if (jsonStringValue.endsWith(',')) {
            jsonStringValue = jsonStringValue.substring(0, jsonStringValue.length() - 1);
        }
        jsonStringValue += '}';
        this.rebuildJsonString = false;
        this.jsonString = jsonStringValue;
    }

    /**
     * Creates a JSONParser from raw json and passes that to parse() to get key/value pairs
     *
     * @param String jsonString The raw json to parse.
     */
    private void readFrom(String jsonString) {
        JSONParser parser;
        try {
            parser = JSON.createParser(jsonString);
        } catch (Exception ex) {
            throw new BoxJsonObjectException('Json string passed to BoxJsonObject was not valid json.');
        }
        parse(parser);
    }

    /**
     * Parses a JSONParser to create key/value pairs of the child elements of the json.
     *
     * @param JSONParser parser The JSONParser to parse.
     */
    private void parse (JSONParser parser) {
        String currentTokenName;
        String currentTokenValue;
        JSONToken currentToken;

        parser.nextToken();
        currentToken = parser.getCurrentToken();
        if (currentToken != JSONToken.START_OBJECT) {
            throw new BoxJsonObjectException('Json passed to BoxJsonObject.parse must start with JSONToken.START_OBJECT');
        }

        while (parser.nextToken() != null) {
            currentToken = parser.getCurrentToken();
            if (currentToken == JSONToken.FIELD_NAME) {
                currentTokenName = parser.getCurrentName();
            } else if (VALID_TOKEN_VALUES.contains(currentToken)) {
                currentTokenValue = parser.getText();
                if (currentToken == JSONToken.VALUE_NULL) {
                    currentTokenValue = null;
                }
                this.children.put(currentTokenName, currentTokenValue);
            } else if (currentToken == JSONToken.START_OBJECT) {
                String prepend = parser.getText();
                currentTokenValue = BoxJsonObject.getStringUntilTokenValue(parser, JSONToken.END_OBJECT);
                this.children.put(currentTokenName, prepend + currentTokenValue);
            } else if (currentToken == JSONToken.START_ARRAY) {
                String prepend = parser.getText();
                currentTokenValue = BoxJsonObject.getStringUntilTokenValue(parser, JSONToken.END_ARRAY);
                this.children.put(currentTokenName, prepend + currentTokenValue);
            } else  if (currentToken == JSONToken.END_OBJECT) {// || currentToken == JSONToken.END_ARRAY){
                if (parser.nextToken() != null) {
                    throw new BoxJsonObjectException('BoxJsonObject expected this JSONToken.END_OBJECT to be the last token in the json string but wasn\'t. This indicates a bug in the SDK.');
                }
            } else {
                throw new BoxJsonObjectException('There was an error parsing the json passed to BoxJsonObject. This indicates a bug in the SDK.');
            }
        }
    }

    /**
     * Returns the string value of the json contained within a child element.
     * This is useful for child objects or arrays.
     *
     * @param JSONParser parser The JSONParser that is currently being parsed.
     * @param JSONToken expectedToken The JSONToken that signals the end of this child object.
     */
    private static String getStringUntilTokenValue(JSONParser parser, JSONToken expectedToken) {
        String value = '';
        Integer arraysDeep = 0;
        Integer objectsDeep = 0;
        JSONToken currentToken;
        String currentValue;
        while (parser.nextToken() != null) {
            currentToken = parser.getCurrentToken();
            currentValue = parser.getText();
            if (currentToken == expectedToken && arraysDeep == 0 && objectsDeep == 0) {
                value = BoxJsonObject.removeCommaAndAddToken(value, currentValue);
                break;
            } else {
                if (currentToken == JSONToken.START_OBJECT) {
                    value = BoxJsonObject.removeCommaAndAddToken(value, currentValue);
                    objectsDeep++;
                } else if (currentToken == JSONToken.END_OBJECT) {
                    value = BoxJsonObject.removeCommaAndAddToken(value, currentValue);
                    objectsDeep--;
                } else if (currentToken == JSONToken.START_ARRAY) {
                    value = BoxJsonObject.removeCommaAndAddToken(value, currentValue);
                    arraysDeep++;
                } else if (currentToken == JSONToken.END_ARRAY) {
                    value = BoxJsonObject.removeCommaAndAddToken(value, currentValue);
                    arraysDeep--;
                } else if (currentToken == JSONToken.VALUE_NULL) {
                    value += 'null,';
                } else {
                    if (currentToken == JSONToken.FIELD_NAME) {
                        if (value.endsWith('}')) {
                            value += ',';
                        }
                        value += '"' + parser.getText() + '"' + ' : ';
                    } else {
                        value += '"' + parser.getText() + '",';
                    }
                }
            }
        }
        return value;
    }

    /**
     * Handles json string building from JSONTokens
     *
     * @param String value The in-progress string of the value for the current child element.
     * @param String currentValue The value being appended to the value for the current child element.
     */
    private static string removeCommaAndAddToken(String value, String currentValue) {
        if (value.endsWith(',')) {
            return value.substring(0, value.length()-1) + currentValue;
        } else if (value.endsWith('}') && currentValue == '{') {
            return value + ',' + currentValue;
        } else {
            return value + currentValue;
        }
    }

    /**
     * Constructs a collection of Strings by decoding it from an String containing JSON string array.
     *
     * @param  jsonStringArray The JSON string to decode.
     * @return collection of Strings.
     */
    public static list<String> parseJsonStringArray(String jsonStringArray) {
        list<String> strings = new list<String>();
        JsonParser parser;
        try {
            parser = JSON.createParser(jsonStringArray);
        } catch (Exception e) {
            throw new BoxJsonObjectException('Json string passed to BoxJsonObject.parseJsonStringArray was not valid json.');
        }

        parser.nextToken();
        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.VALUE_STRING) {
                    strings.add(parser.getText());
                }
            }
        } else {
            throw new BoxJsonObjectException('Json passed to BoxJsonObject.parseJsonStringArray must start with JSONToken.START_ARRAY');
        }
        return strings;
    }

    /**
     * Constructs a collection of Strings by decoding it from an String containing JSON object array.
     *
     * @param  jsonString The JSON string to decode.
     * @return collection of Strings.
     */
    public static list<String> parseJsonObjectArray(String jsonString) {
        list<String> strings = new list<String>();
        JsonParser parser;
        try {
            parser = JSON.createParser(jsonString);
        } catch (Exception e) {
            throw new BoxJsonObjectException('Json string passed to BoxJsonObject.parseJsonObjectArray was not valid json.');
        }

        parser.nextToken();
        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
            while (parser.nextToken() != null) {
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    strings.add(parser.getText() + BoxJsonObject.getStringUntilTokenValue(parser, JSONToken.END_OBJECT));
                }
            }
        } else {
            throw new BoxJsonObjectException('Json passed to BoxJsonObject.parseJsonObjectArray must start with JSONToken.START_ARRAY');
        }
        return strings;
    }

    public class BoxJsonObjectException extends Exception {}
}