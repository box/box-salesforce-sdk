Comments
========

Comment objects represent a user-created comment on a file. They can be added
directly to a file or they can be a reply to another comment.

* [Get the Comments on a File](#get-the-comments-on-a-file)
* [Add a Comment to a File](#add-a-comment-to-a-file)
* [Change a Comment's Message](#change-a-comments-message)
* [Delete a Comment](#delete-a-comment)

Get the Comments on a File
--------------------------

You can get all of the comments on a file by calling the
`getComments()` method.

```java
BoxFile file = new BoxFile(api, 'file-id');
list<BoxComment.Info> comments = file.getComments();
```

Add a Comment to a File
-----------------------

A comment can be added to a file with the `addComment(String)` method.

```java
BoxFile file = new BoxFile(api, 'file-id');
file.addComment('This file is pretty cool.'');
```

Change a Comment's Message
--------------------------

The message of a comment can be changed with the `updateComment(String)` method.

```java
BoxComment comment = new BoxComment(api, 'comment-id');
comment.updateComment('An edited message.');
```

Delete a Comment
----------------

A comment can be deleted with the `deleteComment()` method.

```java
BoxComment comment = new BoxComment(api, 'comment-id');
comment.deleteComment();
```
