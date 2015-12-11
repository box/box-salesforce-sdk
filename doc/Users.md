Users
=====

Users represent an individual's account on Box.

* [Get the Current User's Information](#get-the-current-users-information)
* [Create App User](#create-app-user)
* [Create Enterprise User](#create-enterprise-user)
* [Get All Enterpise Users](#get-all-enterprise-users)
* [Get User](#get-user)
* [Get Memberships](#get-memberships)
* [Add Email Alias](#add-email-alias)
* [Delete Email Alias](#delete-email-alias)
* [Get Email Alias](#get-email-alias)
* [Delete User](#delete-user)
* [Update User Information](#update-user-info)
* [Move Folder to User](#move-folder-to-user)
* [Get User Events](#get-user-events)

Get the Current User's Information
----------------------------------
To get the current user, call the static getCurrentUser(BoxAPIConnection) method.

```apex
BoxApiConnection api = new BoxApiConnection('accesstoken');
BoxUser.Info currentUser = BoxUser.getCurrentUser(api);
```

Create App User
---------------
To create app user call createAppUser(BoxApiConnection api, String name).
It provisions a new app user in an enterprise using Box Developer Edition

```apex
BoxApiConnection api = new BoxApiConnection('accesstoken');
BoxUser.Info newUser = BoxUser.createAppUser(api, 'Ned Stark');
```
App user can also be created by calling (BoxApiConnection api, String name, BoxCreateUserParams params).
It Provisions a new app user in an enterprise with additional user information using Box Developer Edition.

Create Enterprise User
----------------------
To create an new Enterprise User call createEnterpriseUser(BoxApiConnection api, String login, String name) 
It provisions a new user in an enterprise.

```apex
BoxUser.Info newUser = BoxUser.createEnterpriseUser(api, 'sean+test@box.com', 'Ned Stark');
```
Enterprise user can also be created by calling createEnterpriseUser(BoxApiConnection api, String login, String name, BoxCreateUserParams params)
It provisions a new user in an enterprise with additional user information.

Get All Enterpise Users
-----------------------
To get a list of all the enterprise users that match the filter and
specifies which child fieldto retrieve from the API call getAllEnterpriseUsers(BoxApiConnection api, String filterTerm, list<String> fields)

```apex
list<BoxUser.Info> allUsers = BoxUser.getAllEnterpriseUsers(api);
```

Get User
--------
To get information about this user call getUser(list<String> fields) where fields is optional.

```apex
BoxUser.Info userInfo = user.getUser(null);
```
Get Memberships
---------------
Call getMemberships() to get information about all of the group memberships for this user.

```apex
BoxUser user = new BoxUser(api,'id');
list<BoxGroupMembership.Info> memberships = user.getMemberships();
```

Add Email Alias
---------------
Call addEmailAlias(String) to add a new email alias to this user's account.

```apex
BoxUser user = new BoxUser(api,'id');
BoxEmailAlias.Info emailAlias = user.addEmailAlias('sea@box.com');
```

Delete Email Alias
------------------
To delete an email alias from this user's account call deleteEmailAlias(String)

```apex
BoxUser user = new BoxUser(api,'id');
Boolean deleteEmailAliasResult = user.deleteEmailAlias('sea@box.com');
```
Get Email Aliases
------------------
To get an email aliased from this user's account call getEmailAliases()

```apex
BoxUser user = new BoxUser(api,'id');
list<BoxEmailAlias.Info> emailAliases = user.getEmailAliases();
```

Delete User
-----------
To delete a user from enterprise account call static method deleteUser(Boolean notifyUser, Boolean force) where
notifyUser decides whether or not to send an email notification to the user that their account has been deleted
and force decides whether or not this user should be deleted even if they still own files.

```apex
BoxUser user = new BoxUser(api,'id');
Boolean deleteUserResult = user.deleteUser(true, true);
```

Update User Info
----------------
Call updateInfo(BoxUser.Info) to update the information about this user
with info fields passed.
Note: This method is only available to enterprise admins.

```apex
BoxUser user = new BoxUser(api,'id');
BoxUser.Info userInfo = new BoxUser.Info();
userInfo.addValue('name', 'Arielle Frey');
BoxUser.Info updatedUserInfo = user.updateInfo(userInfo);
```

Move Folder to User
-------------------
To move the folders to other user call moveFolderToUser(String) this method moves all of the owned content from within one user’s folder into a new folder in another user's account.
You can move folders across users as long as the you have administrative permissions and the 'source'
user owns the folders. Per the documentation at the link below, this will move everything from the root
folder, as this is currently the only mode of operation supported.

```apex
BoxUser user = new BoxUser(api,'id#1');
BoxFolder.Info folderInfo = user.moveFolderToUser('id#2');
```

Get User Events
---------------
Use getUserEvents() to get events for a given user. 

```apex
BoxUser user = new BoxUser(api,'id');
list<BoxEvent.Info> events = user.getUserEvents();
```
Method getUserEvents(String streamPosition, String streamType, Integer numberOfEventsLimit) can also be used to get the events.
Where 
  streamPosition (default=0) is the location in the event stream at which you want to start receiving events. 
  streamType (default=all), limits the type of events returned: all: returns everything, changes: returns tree changes, sync:    returns tree changes only for sync folders
  limit (default=100 max=800), limits the number of events returned.