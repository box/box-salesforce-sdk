Files
=====

File objects represent individual files in Box. They can be used to download a
file's contents, upload new versions, and perform other common file operations
(move, copy, delete, etc.).

* [Get a File's Information](#get-a-files-information)
* [Update a File's Information](#update-a-files-information)
* [Upload a File](#upload-a-file)
* [Copy a File](#copy-a-file)
* [Delete a File](#delete-a-file)
* [Get Previous Versions of a File](#get-previous-versions-of-a-file)
* [Promote a Previous Version of a File](#promote-a-previous-version-of-a-file)
* [Delete a Previous Version of a File](#delete-a-previous-version-of-a-file)

Get a File's Information
------------------------

Calling `getFileInfo()` on a file returns a snapshot of the file's info.

```java
BoxFile file = new BoxFile(api, 'file-id');
BoxFile.Info info = file.getFileInfo();
```

Update a File's Information
---------------------------

Updating a file's information is done by creating a new `BoxFile.Info`
object or updating an existing one, and then calling `updateFileInfo(BoxFile.Info)`.

```java
BoxFile file = new BoxFile(api, 'file-id');
BoxFile.Info info = new BoxFile.Info();
info.addValue('name', 'New_File_Name.jpg');
BoxFile.Info newFileInfo = file.updateFileInfo(info);
```

Upload a File
-------------

Files are uploaded to a folder by calling either the `uploadFile(Attachment, String)`
or `uploadFile(Document, String)` method.  If the `newName` String parameter is blank,
the name of the Attachment or Document is used.

```java
BoxFolder rootFolder = BoxFolder.getRootFolder(api);
BoxFile.Info fileInfo = rootFolder.uploadFile(myAttachment, 'New_File_Name.jpg');
```

Upload progress can be tracked by providing the size of the file and a
`ProgressListener` to
[`uploadFile(InputStream, String, long, ProgressListener)`][upload2]. The
`ProgressListener` will then receive progress updates as the upload completes.

Copy a File
-----------

A file can be copied to a new folder and optionally be renamed with the
`copy(BoxFolder)` and `copy(BoxFolder, String)` methods.

```java
BoxFolder rootFolder = BoxFolder.getRootFolder(api);
BoxFile file = new BoxFile(api, 'file-id');
BoxFile.Info copiedFileInfo = file.copy(rootFolder, 'New Name');
```

Delete a File
-------------

Calling the `deleteFile()` method will move the file to the user's trash.

```java
BoxFile file = new BoxFile(api, 'file-id');
file.deleteFile();
```

Get a trashed File
------------------

Calling the `getTrashedFile()` method will retrieve a trashed file to the user including
information about when the file was moved to the trash.

```java
BoxFile file = new BoxFile(api, 'file-id');
file.getTrashedFile();
```

Get Previous Versions of a File
-------------------------------

For users with premium accounts, versions of a file can be retrieved with the
`getVersions()` method.

```java
BoxFile file = new BoxFile(api, 'file-id');
list<BoxFileVersion.Info> versions = file.getVersions();
```

Promote a Previous Version of a File
------------------------------------

A previous version of a file can be promoted with the `promoteFileVersion()`
method to become the current version of the file.  Since the `file_version` object returned
from the Box API doesn't include the File Id, you must set it manually before promoting a
file version.

```java
BoxFile file = new BoxFile(api, 'file-id');
list<BoxFileVersion.Info> versions = file.getVersions();
BoxFileVersion firstVersion = new BoxFileVersion(api, versions[0].versionId);
firstVersion.setFileId('file-id');
firstVersion.promoteFileVersion();
```

Delete a Previous Version of a File
-----------------------------------

A version of a file can be deleted and moved to the trash by calling
`deleteFileVersion()`. Since the `file_version` object returned
from the Box API doesn't include the File Id, you must set it manually
before deleting a file version.

```java
BoxFile file = new BoxFile(api, 'file-id');
list<BoxFileVersion.Info> versions = file.getVersions();
BoxFileVersion firstVersion = new BoxFileVersion(api, versions[0].versionId);
firstVersion.setFileId('file-id');
firstVersion.deleteFileVersion();
```
