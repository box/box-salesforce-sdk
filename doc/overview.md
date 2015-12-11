SDK Overview
============

This guide covers the basics behind the various components of the Box Apex SDK.
It's also recommended that you take a look at [the
documentation](https://developers.box.com/docs/) for the Box API.

* [Authentication](#authentication)
* [Resource Types](#resource-types)
* [Requests and Responses](#requests-and-responses)
* [Error Handling](#error-handling)

Authentication
--------------

The first step in using the SDK is always authenticating and connecting to the
API. The SDK does this through the `BoxAPIConnection` class. This class
represents an authenticated connection to a specific version of the Box API. It
is responsible for things such as:

* Storing authentication information.
* Automatically refreshing tokens.
* Configuring rate-limiting, number of retry attempts and other connection
  settings.

You can also create more than one `BoxAPIConnection`. For example, you can have
a connection for each user if your application supports multiple user accounts.

See the [Authentication guide](authentication.md) for details on how to create
and use `BoxAPIConnection`.

Resource Types
--------------

Resources types are the classes you'll use the most. Things like `BoxFile`,
`BoxFolder`, `BoxUser`, etc. are all resource types. A resource always has an ID
and an associated API connection. Instantiating and using a resource type is
simple:

```java
// Output the name of the folder with ID "1234".
BoxFolder folder = new BoxFolder(api, '1234')
BoxFolder.Info info = folder.getFolderInfo();
System.debug(info.name);
```

`BoxGenericJsonObject` is a very flexible JSON parsing object that only parses one level
down and keeps all original JSON intact.  A key-value map is maintained for easy 
field access.

Requests and Responses
----------------------

All communication with Box's API is done through `BoxAPIRequest` (or its subclasses)
and the built-in `HttpResponse`. These classes handle all the dirty work
of setting appropriate headers, handling errors, and sending/receiving data.

You generally won't need to use these classes directly, as the resource types
are easier and cover most use-cases. However, these classes are extremely
flexible and can be used if you need to make custom API calls.

Here's an example using `BoxAPIRequest` and `BoxGenericJsonObject` that gets a list
of items with some custom fields:

```java
BoxAPIConnection api = new BoxAPIConnection('accesstoken');
URL url = new URL('https://api.box.com/2.0/folders/0/items?fields=name,created_at')
BoxAPIRequest request = new BoxAPIRequest(api, url, "GET");
HttpResponse response = request.send();
BoxGenericJsonObject responseObject = new BoxGenericJsonObject(response.getBody());
```

Error Handling
--------------

Most system-level exceptions are not handled and will need to be caught manually.
More specific exceptions are thrown.  Most notably:
* `BoxApiRequestException` - Thrown whenever something is obviously wrong (no more callouts allowed, 400/404 returned, redirect returned but no redirect location was found, too many redirects, etc.)
* `BoxResourceNullResponseException` - Thrown when an HttpResponse was null
* `BoxResourceNullBodyException` - Thrown when an HttpResponse's body was null but shouldn't have been

Most exceptions are not recoverable. It is important to catch any exceptions to keep
track of where you were in your progress so you can continue on with your actions in
your next execution context.  

If a general exception is caught when making an API call, that is wrapped in a 
`BoxApiRequestException`.  This may not include any preparation to make an API call such as
assigning an invalid value to the request header or body.  Those will bubble up as general
exceptions.
