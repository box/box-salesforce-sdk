Folders
=======

Folder objects represent a folder from a user's account. They can be used to
iterate through a folder's contents, collaborate a folder with another user or
group, and perform other common folder operations (move, copy, delete, etc.).

* [Get the User's Root Folder](#get-the-users-root-folder)
* [Get a Folder's Items](#get-a-folders-items)
* [Get a Folder's Information](#get-a-folders-information)
* [Update a Folder's Information](#update-a-folders-information)
* [Create a Folder](#create-a-folder)
* [Copy a Folder](#copy-a-folder)
* [Move a Folder](#move-a-folder)
* [Rename a Folder](#rename-a-folder)
* [Delete a Folder](#delete-a-folder)
* [Created a Shared Link for a Folder](#created-a-shared-link-for-a-folder)
* [Share a Folder](#share-a-folder)
* [Get All Collaborations for a Folder](#get-all-collaborations-for-a-folder)

Get the User's Root Folder
--------------------------

The user's root folder can be accessed with the static
`getRootFolder(BoxAPIConnection)` method.

```java
BoxFolder rootFolder = BoxFolder.getRootFolder(api);
```

Get a Folder's Items
--------------------

A call to `getChildren()` will return the contents of a `BoxFolder`.  Optionally, an offset and limit
can be set to iterate over a large folder. Large folder operations will likely
fail due to governor limits on callouts or heap size.  This method could be detrimental depending
on your use case.

```java
BoxFolder folder = new BoxFolder(api, 'folder-id');
list<BoxItem.Info> children = folder.getChildren();
for (BoxItem.Info itemInfo : children) {
    if (itemInfo.getObjectType() == 'folder') {
        // Do something with the folder
    } else if (itemInfo.getObjectType() == 'file') {
        // Do something with the file
    }
}
```

Get a Folder's Information
--------------------------

Calling `getFolderInfo()` on a folder returns a snapshot of the folder's
info.

```java
BoxFolder folder = new BoxFolder(api, 'folder-id');
BoxFolder.Info info = folder.getFolderInfo();
```

Update a Folder's Information
-----------------------------

Updating a folder's information is done by creating a new `BoxFolder.Info`
object or updating an existing one, and then calling
`updateFolderInfo(BoxFolder.Info)`.

```java
BoxFolder folder = new BoxFolder(api, 'folder-id');
BoxFolder.Info info = folder.new Info();
info.addValue('description', 'Some folder I made');
folder.updateFolderInfo(info);
```

Create a Folder
---------------

Create a child folder by calling `createFolder(String)` on the
parent folder.

```java
BoxFolder parentFolder = new BoxFolder(api, 'parent-folder-id');
BoxFolder.Info childFolderInfo = parentFolder.createFolder('Child Folder Name');
```

Copy a Folder
-------------

Call the `copy(BoxFolder)` method to copy a folder to another folder.

```java
BoxFolder folder = new BoxFolder(api, 'folder-id');
BoxFolder destination = new BoxFolder(api, 'destination-folder-id');
folder.copy(destination);
```

You can also use the `copy(BoxFolder, String)` method to rename the
folder while copying it. This allows you to make a copy of the folder in the
same parent folder, but with a different name.

```java
BoxFolder folder = new BoxFolder(api, 'folder-id');
BoxFolder destination = new BoxFolder(api, 'destination-folder-id');
folder.copy(destination, 'New Folder Name');
```

Move a Folder
-------------

Call the `move(BoxFolder)` method with the destination you want the folder moved
to.

```java
BoxFolder folder = new BoxFolder(api, 'folder-id');
BoxFolder destination = new BoxFolder(api, 'destination-folder-id');
folder.move(destination);
```

Similar to the `copy` method, the folder can be renamed by calling `move(BoxFolder, String)`.

Rename a Folder
---------------

Call the `rename(String)` method with a new name for the folder.

```java
BoxFolder folder = new BoxFolder(api, 'folder-id');
folder.rename('New Name');
```

A folder can also be renamed by updating the folder's information. This is
useful if you want to perform more than one change to the folder in a single API
request.

```java
BoxFolder folder = new BoxFolder(api, 'folder-id');
BoxFolder.Info info = folder.new Info();
info.addValue('description', 'Some folder I made');
info.addValue('name', 'New Folder Name');
folder.updateFolderInfo(info);
```

Delete a Folder
---------------

A folder can be deleted with the `deleteFolder(boolean)` method. Passing
true to this method indicates that the folder and its contents should be
recursively deleted.

```java
BoxFolder folder = new BoxFolder(api, 'folder-id');
folder.deleteFolder(true);
```

Created a Shared Link for a Folder
----------------------------------

You can get a shared link for a folder by calling the
`createSharedLink(BoxSharedLink.Access, DateTime, BoxSharedLink.Permissions)` method.

```java
BoxFolder folder = new BoxFolder(api, 'folder-id');
SharedLink link = folder.createSharedLink(BoxSharedLink.Access.OPEN, null, permissions);
```

Share a Folder
--------------

You can invite another person to collaborate on a folder with the
[collaborate(String, BoxCollaboration.Role)` method. The Box user with the email address
specified will receive a collaboration request.  If the email is not associated with a Box
account, an invitation to create a Box account will be sent.

```java
BoxFolder folder = new BoxFolder(api, 'folder-id');
BoxCollaboration.Info collabInfo = folder.collaborate('dlansing@box.com', BoxCollaboration.Role.EDITOR);
```

If you already know the user's ID, you can invite them directly without needing
to know their email address with the
`collaborate(BoxCollaborator, BoxCollaboration.Role)` method.

```java
BoxUser collaborator = new User(api, 'user-id');
BoxFolder folder = new BoxFolder(api, 'folder-id');
BoxCollaboration.Info collabInfo = folder.collaborate(collaborator, BoxCollaboration.Role.EDITOR);
```

Get All Collaborations for a Folder
-----------------------------------

The `getCollaborations()` method will return a list
of `BoxCollaboration.Info` objects for a folder.

```java
BoxFolder folder = new BoxFolder(api, 'folder-id');
list<BoxCollaboration.Info> collaborations = folder.getCollaborations();
```
