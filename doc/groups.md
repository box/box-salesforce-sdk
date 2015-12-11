Groups
======

Groups are sets of users that can be used in collaborations.

* [Create a Group](#create-a-group)
* [Delete a Group](#delete-a-group)

Create a Group
--------------

The static `createGroup(BoxAPIConnection, String)` method will
let you create a new group with a specified name.

```java
BoxGroup.Info groupInfo = BoxGroup.createGroup(api, 'My Group');
```

Delete a Group
--------------

A group can be deleted by calling the `deleteGroup()` method.

```java
BoxGroup group = new BoxGroup(api, 'group-id');
group.deleteGroup();
```
