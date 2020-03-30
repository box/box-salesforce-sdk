# Contributing

All contributions are welcome to this project.

## Contributor License Agreement

Before a contribution can be merged into this project, please fill out the
Contributor License Agreement (CLA) located at:

http://opensource.box.com/cla

## How to Contribute

### File an [Issue](https://github.com/box/box-salesforce-sdk/issues/new)

Before writing any code, please file an issue stating the problem you want to solve or the feature you want to implement. This allows us to give you feedback before you spend any time writing code. There may be a known limitation that can't be addressed, or a bug that has already been fixed in a different way. The issue allows us to communicate and figure out if it's worth your time to write a bunch of code for the project.

### Fork this repository in GitHub

This will create your own copy of our repository.

### Add the upstream source

The upstream source is the project under the Box organization on GitHub. To add an upstream source for this project, type:

```
git remote add upstream git@github.com:box/box-salesforce-sdk.git
```

This will come in handy later.

### Install the development dependencies

This will help ensure your code and commits follow the same conventions as this project, among other things.

```
npm install
```

### Create a feature branch

Create a branch with a descriptive name, such as `add-search`.

### Push your feature branch to your fork

As you develop code, continue to push code to your remote feature branch. Please make sure to include the issue number you're addressing in the body of your commit message and adhere to [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/). For example:

```
feat: Add search

Introduced a new BoxSearch class that uses the /search API endpoint.

Closes #123
```

This helps us out by allowing us to track to which issue your commit relates.

Keep a separate feature branch for each issue you want to address.

### Rebase

Before sending a pull request, rebase against upstream, such as:

```
git fetch upstream
git rebase upstream/master
```

This will add your changes on top of what's already in upstream, minimizing merge issues.

### Build and test your changes

Make sure that the code builds and passes all unit tests by deploying your code to a Salesforce developer edition org and running all tests from Setup -> Develop -> Apex Classes.

### Send the pull request

Send the pull request from your feature branch to us. Be sure to include a description in your commit message (not the pull request description) that lets us know what work you did.

Keep in mind that we like to see one issue addressed per pull request, as this helps keep our git history clean and we can more easily track down issues.
