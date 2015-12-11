Collaborations
==============

Collaborations are used to share folders between users or groups. They also
define what permissions a user has for a folder.

* [Add a Collaboration](#add-a-collaboration)
* [Edit a Collaboration](#edit-a-collaboration)
* [Remove a Collaboration](#remove-a-collaboration)
* [Get a Collaboration's Information](#get-a-collaborations-information)
* [Get the Collaborations on a Folder](#get-the-collaborations-on-a-folder)
* [Get Pending Collaborations](#get-pending-collaborations)

Add a Collaboration
-------------------

A collaboration can be added for an existing user or group with
`collaborate(BoxCollaborator, BoxCollaboration.Role)`. The
`role` parameter determines what permissions the collaborator will have on the
folder.

```java
BoxCollaborator user = new BoxUser(api, 'user-id')
BoxFolder folder = new BoxFile(api, 'folder-id');
folder.collaborate(user, BoxCollaboration.Role.EDITOR);
```

You can also add a collaboration by providing an email address with
`collaborate(String, BoxCollaboration.Role)`. If the receipient
doesn't have a Box account, they will be asked create one.

```java
BoxFolder folder = new BoxFile(api, "id");
folder.collaborate("gcurtis@box.com", BoxCollaboration.Role.EDITOR);
```

Edit a Collaboration
--------------------

A collaboration can be edited by calling `updateCollaboration(BoxCollaboration.Role)` 
on a `BoxCollaboration` object.  Pass the `BoxCollaboration.Role` you want the 
collaboration type to be updated to.

```java
BoxCollaboration collaboration = new BoxCollaboration(api, 'collab-id');
collaboration.updateCollaboration(BoxCollaboration.Role.VIEWER);
```

Remove a Collaboration
----------------------

A collaboration can be removed by calling `deleteCollaboration()`.

```java
BoxCollaboration collaboration = new BoxCollaboration(api, 'collab-id');
collaboration.deleteCollaboration();
```

Get a Collaboration's Information
---------------------------------

Calling `getCollaboration()` on a collaboration returns a snapshot of the
collaboration's info.

```java
BoxCollaboration collaboration = new BoxCollaboration(api, 'collab-id');
BoxCollaboration.Info info = collaboration.getCollaboration();
```

Get the Collaborations on a Folder
----------------------------------

You can get all of the collaborations on a folder by calling
`getCollaborations()` on the folder.

```java
BoxFolder folder = new BoxFolder(api, 'folder-id');
list<BoxCollaboration.Info> collaborations = folder.getCollaborations();
```

Get Pending Collaborations
--------------------------

A collection of all the user's pending collaborations can be retrieved with
`getPendingCollaborations(BoxAPIConnection)`.

```java
list<BoxCollaboration.Info> pendingCollaborations = BoxCollaboration.getPendingCollaborations(api);
```
