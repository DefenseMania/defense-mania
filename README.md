# defense mania

> A crossplatform tower defense game built with processing.

## Contribute

### Game

##### prerequisites

* [Processing 2.03b](https://github.com/processing/processing/releases/tag/processing-2.0b3)
* [Android SDK](https://developer.android.com/sdk/index.html#Other)
* [JDK 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)
* [Apache Ant](https://ant.apache.org/manual/install.html)
* [GIT](https://git-scm.com/downloads)
* [UglifyJs](https://github.com/mishoo/UglifyJS#install-npm)
* [PhantomJs](http://phantomjs.org/download.html)

##### getting started

* Download and install everything above
* Install Android SDK **API Level 10** Platform & Build-tools **Rev. 19.1**
* **The game was built on Processing 2.03b and won't run on the current version of Processing. We will hopefully fix that soon.**
* Get the source: `git clone https://github.com/kriskbx/defensemania.git`

##### directory structure

DefenseMania is splitted into 3 parts: desktop application and android application, browser/web application. They share most of the code. The shared code is located in `src/shared` as well as all the assets. Everything is symlinked (relatively) into the 3 parts of DefenseMania. If you want to recreate the symlinks, run `./src/symlinks.sh`.

##### build it

1. Desktop: open the desktop project in processing and export the application.
2. Android: open processing, export the android project from the file menu, run `cd src/android && ant`, this will create the file `src/android/application.android/DefenseMania-unsigned.apk`.
3. Browser: run `cd src/browser && ant`, this will create the compiled and minified project in `src/browser/application.web`.

### Maps & Map Editor

1. Download the DM Map Editor from [here](https://github.com/DefenseMania/defense-mania-map-editor/releases) and read [how to use it](https://github.com/DefenseMania/defense-mania-map-editor#how-to-use-the-editor).
2. You can submit new maps via pull-requests in **this** repository.

### Graphics

Take a look [here](https://github.com/DefenseMania/defense-mania-graphics).


## Roadmap

##### 0.9.3

* Optimize build scripts for continuos integration

##### 1.0.0

* Port everything to Processing 2.2.1 (and maybe 3.0a)
* Rebuild updater to work with GitHub
* Move the website to GitHub pages

##### 1.1.0

* Dragons <3
* Lovely sounds and music

##### 1.2.0

* Highscores


## Contributors

* Kris Siepert [everything]
* John Brüggemann [logo]
* Lars Meyer [beta tester]
* Alexander Spennesberger [beta tester]
* Dieter Meiller [beta tester]
* Christoph Eichhammer [beta tester]