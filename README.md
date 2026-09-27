# Latest

[![Translation status][image-1]][1]

This is Latest, a small utility app for the Mac. Latest is a free and open-source app for macOS that checks if your apps are up to date. Get a quick overview of which apps changed and what changed and update them right away. Latest currently supports apps downloaded from the Mac App Store and those that use Sparkle for updates.

Latest is developed in my free time, so occasional updates may happen. Take a look at the [Issues][2] section to see what's coming. If you have an idea for a new feature, or encounter any bugs, feel free to open a new issue.
I am thankful for contributions. Check out the section below for more information.

![Latest][image-2]

## Installation

There are multiple ways to install the app.

### Download the App

The easiest way to install Latest is to [download][3] the latest release as an app. You unzip the download by double-clicking on it (if that does not happen automatically) and then move the `Latest.app` into the `Applications` folder.

If you would like to check out earlier versions, head over to the [Releases][4] page to browse the history of Latest.

### Homebrew Cask

Latest can also be installed via [Homebrew Cask][5]. If you have not installed Homebrew, follow the simple instructions [here][6].
After that, run `brew install --cask latest` to install the current version of Latest.

### Build from Source

#### Prerequisites

- A Mac running macOS 15.6 or later (the project's deployment target).
- Full Xcode with a macOS SDK that supports this deployment target. The standalone Command Line Tools are not sufficient.
- Git and an internet connection to download package dependencies.

Open Xcode once to accept its license and install any required components. If your command-line tools point to a different installation, select Xcode and verify it:

```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
xcodebuild -version
```

#### Clone the repository

```bash
git clone --recurse-submodules https://github.com/rfoerthe/Latest.git
cd Latest
```

Run all remaining commands from this repository root, which contains `Latest.xcodeproj`. The `Sparkle/` directory only contains private headers; it is not a standalone Xcode project. Xcode obtains Sparkle through the project's Swift package dependency.

#### Resolve package dependencies

```bash
xcodebuild \
  -resolvePackageDependencies \
  -project Latest.xcodeproj \
  -scheme Latest \
  -derivedDataPath /tmp/Latest-DerivedData
```

This downloads the dependencies without compiling the app. Xcode also resolves dependencies automatically when building. The checked-in `Package.resolved` records the resolved versions.

#### Build locally

```bash
xcodebuild \
  -project Latest.xcodeproj \
  -scheme Latest \
  -configuration Debug \
  -destination 'platform=macOS' \
  -derivedDataPath /tmp/Latest-DerivedData \
  build \
  CODE_SIGN_STYLE=Manual \
  CODE_SIGN_IDENTITY=- \
  DEVELOPMENT_TEAM= \
  ENABLE_HARDENED_RUNTIME=NO
```

These command-line overrides use ad hoc signing and disable the hardened runtime for local development, avoiding the developer team configured in the project. They do not change the project settings and are not intended for distribution builds.

The built app is at `/tmp/Latest-DerivedData/Build/Products/Debug/Latest.app`. Launch it with:

```bash
open /tmp/Latest-DerivedData/Build/Products/Debug/Latest.app
```

#### Run tests

```bash
xcodebuild \
  -project Latest.xcodeproj \
  -scheme Latest \
  -configuration Debug \
  -destination 'platform=macOS' \
  -derivedDataPath /tmp/Latest-DerivedData \
  test \
  CODE_SIGN_STYLE=Manual \
  CODE_SIGN_IDENTITY=- \
  DEVELOPMENT_TEAM= \
  ENABLE_HARDENED_RUNTIME=NO
```

The `test` action builds the app and test bundle before running the tests. If Xcode reports that the scheme is not configured for testing, open `Latest.xcodeproj`, select **Product > Scheme > Edit Scheme**, and add the **Latest Tests** target under **Test**. The repository does not currently include a shared scheme, so test configuration may need to be set up on a fresh checkout.

You can also build and test in Xcode: open `Latest.xcodeproj`, select the **Latest** scheme and **My Mac** destination, and select your own development team (or **Sign to Run Locally**) in the app and test targets' signing settings. Use **Product > Run** to launch the app or **Product > Test** to run the tests.

### Swift Package Manager

The package mirrors the Xcode app target's macOS 15.6 minimum and pins Sparkle
at 2.5.1. With Xcode selected as the active developer directory, build and run
the existing unit tests from the repository root:

```sh
swift build
swift test
```

The package includes the local CommerceKit and StoreFoundation headers and links
the corresponding private macOS frameworks. These are only available on macOS.
Use `Latest.xcodeproj` to build and run the GUI app: SwiftPM's executable and
resource bundle do not replace the app bundle, Info.plist, signing, and main-bundle
resource lookups used by Latest.

## Contribution

I am thankful for all contributions to the project. You can contribute typo-fixes, translations, code and of course suggestions, wishes, and bug reports.

### Translations

The text used in Latest is hosted by the kind people over at [Weblate][7]. If you would like to add a new language, or improve an existing one, [here][8] is your starting point.

[![Translation status][image-3]][9]

### Code

Take a look at the [Issues][10] section to see what you can do. If you have your own idea, and it does not appear in the issues list, please add it first. I don't think that I would reject any pull request, but it is useful to know about your idea earlier. Imagine two people have the same idea at the same time and both put a lot of work into that just to find out that someone else has made the same when it's too late.  

I would like to assign every issue to the person working on that particular thing, so if you would like to implement something, leave a small note in the issue. I will assign the issue to you and it's yours.

## Donation

As mentioned above, Latest is free for you to use. I work on the app in my spare time. If you would like to support the development by donating, you can do so [here][11].

[1]:	https://hosted.weblate.org/engage/latest/
[2]:	https://github.com/mangerlahn/latest/issues
[3]:	https://max.codes/latest/Latest.zip
[4]:	https://github.com/mangerlahn/Latest/releases
[5]:	https://github.com/Homebrew/homebrew-cask
[6]:	https://brew.sh
[7]:	https://weblate.org/
[8]:	https://hosted.weblate.org/engage/latest/
[9]:	https://hosted.weblate.org/engage/latest/
[10]:	https://github.com/mangerlahn/latest/issues
[11]:	https://max.codes/latest/donate

[image-1]:	https://hosted.weblate.org/widgets/latest/-/svg-badge.svg
[image-2]:	./latest.png
[image-3]:	https://hosted.weblate.org/widgets/latest/-/multi-auto.svg
