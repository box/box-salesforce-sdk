# Web Links

Represents a web link (bookmark) on Box

## Get a Web Link's Information

```java
BoxWebLink webLink = new BoxWebLink(api, 'web-link-id');
BoxWebLink.Info info = webLink.getWebLinkInfo();
```

## Create a Web Link

```java
BoxWebLink webLink = new BoxWebLink(api, null);
BoxWebLink.Info info = new BoxWebLink.Info('{"url":"https://www.salesforce.com/", "parent": {"id": "0"}, "name": "Salesforce", "description": "Link to Salesforce"}');
BoxWebLink.Info created = webLink.createWebLink(info);
```

## Update a Web Link's Information

```java
BoxWebLink webLink = new BoxWebLink(api, 'web-link-id');
BoxWebLink.Info info = webLink.getWebLinkInfo();
info.addValue('description', 'a descriptive description');
BoxWebLink.Info updated = webLink.updateWebLinkInfo(info);
```

## Delete a Web Link

```java
BoxWebLink webLink = new BoxWebLink(api, 'web-link-id');
webLink.deleteWebLink();
```

## Get a Trashed Web Link's Information

```java
BoxWebLink webLink = new BoxWebLink(api, 'web-link-id');
BoxWebLink.Info info = webLink.getTrashedWebLinkInfo();
```

## Restore a Trashed Web Link

```java
BoxWebLink webLink = new BoxWebLink(api, 'web-link-id');
BoxWebLink.Info info = webLink.restoreTrashedWebLink();
```

## Permanently Delete a Web Link

```java
BoxWebLink webLink = new BoxWebLink(api, 'web-link-id');
webLink.permanentlyDeleteWebLink();
```
