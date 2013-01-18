---
title : Ruboto core 0.2.0
---
New in version 0.2.0:

Features:

* Support for Android 3.1 api level 12
* Automatically add generated Activity or Service to AndroidManifest.xml
* Support for running the ruboto-core tests on Android 3.2
  Support for developing Android 3.2 apps is planned for ruboto-core 0.3.0.
* Full support for developing ruboto apps with MRI.
* New app icon by RedNifre.
* "ruboto gen class" now lists the actions performed.
* "rake update_scripts" made a lot smarter and will do a full build if needed.
* Support for splash screen instead of progress dialog at startup.

Bugfixes:

* Using Button and ImageButton in the same Activity failed
* Starting a service from an activity broken on 0.1.0
* "ruboto update app" now generates the test project if it does not exist.
* "android" top level package now works.

You can find a complete list of issues here:

https://github.com/ruboto/ruboto/issues?state=closed&milestone=1
