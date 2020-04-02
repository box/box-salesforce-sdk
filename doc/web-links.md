# Web Links

Web link objects represent a web link (bookmark) from a user's account. They can perform common web link operations, like create, read, update, and delete.

## Get a Web Link's Information

Calling `getWebLinkInfo()` on a web link returns a snapshot of the web link's info.

```java
BoxWebLink webLink = new BoxWebLink(api, 'web-link-id');
BoxWebLink.Info info = webLink.getWebLinkInfo();
```

## Update a Web Link's Information

Updating a web link's information is done by creating a new `BoxWebLink.Info` object or updating an existing one, and then calling `updateWebLinkInfo(BoxWebLink.Info)`.

```java
BoxWebLink webLink = new BoxWebLink(api, '12303730068');
BoxWebLink.Info info = webLink.getWebLinkInfo();
info.addValue('description', 'Some web link I made');
BoxWebLink.Info updated = webLink.updateWebLinkInfo(info);
```

## Delete a Web Link

A web link can be deleted with the `deleteWebLink()` method.

```java
BoxWebLink webLink = new BoxWebLink(api, 'web-link-id');
webLink.deleteWebLink();
```
