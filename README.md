[![Project Status](http://opensource.box.com/badges/active.svg)](http://opensource.box.com/badges)

Box SDK for Salesforce
======================

This is the Box SDK for Salesforce for interacting with the 
[Box Content API](https://box-content.readme.io/).

Quickstart
----------
The SDK can be deployed directly to Sandbox or Developer Orgs by clicking
<a href="https://githubsfdeploy.herokuapp.com?owner=box&repo=box-salesforce-sdk">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>
"Deploy to Salesforce" functionality is not owned or operated by Box.

The SDK is also distributed as an umanaged package.  Unmanaged packages can't be upgraded once installed in a Salesforce org so future upgrades will have to be applied by cloning the repo locally and updating classes from your IDE.
* [Production/Developer Package Link][package-production]
* [Sandbox Package Link][package-sandbox]
Unmanaged packages can't be upgraded once installed in a Salesforce org so future upgrades will have to be applied by cloning the repo locally and updating classes from your IDE.

Running Tests
-------------
Tests are always executed when deploying code to a production salesforce org.  To manually run tests from a sandbox or developer org, go to Setup -> Develop -> Apex Classes and click the "Run All Tests" button.

Support
-------
Need to contact us directly? Email oss@box.com and be sure to include the name of this project in the subject.  For questions, please contact us directly rather than opening an issue.

Copyright and License
---------------------

Copyright 2015 Box, Inc. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[package-production]:https://cloud.box.com/Box-Apex-SDK
[package-sandbox]:https://cloud.box.com/Box-Apex-SDK-Sandbox