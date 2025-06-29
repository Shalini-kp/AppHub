# AppHub - Modular App Architecture

A guide to breaking the monolith into feature modules to achieve a robust, scalable application. This architecture allows apps/features to be easily plugged in or removed as needed.

---

## 🔧 Prerequisites

- **Framework Type:** Dynamic Framework
- **Design Pattern:** MVC
- **Package Manager:** CocoaPods
- **Dependency Management:** Flat Dependency Structure
- **Approach:** Monorepo
- **Dependency Injection:** (Set standards as needed)

---

## 🚀 Setting Up MAA (Modular App Architecture)

### 🧱 Create and Set Up Workspace

1. Create a general workspace to host all apps/modules.
2. Create the main app project inside this workspace.
3. Initialize CocoaPods and place the `Podfile` at the **root level** of the workspace.
4. Add required dependencies to the `Podfile` and set the workspace reference.
5. Run:

   ```bash
   pod install
Compile the project to ensure all dependencies are integrated properly.

🧩 Creating a Framework Module
Create a new framework project within the workspace.

Create a new group (without folder) named Dependencies (or as preferred).

Drag any project you want to depend on into this group.

For first-time setup:

Add a Copy Files Build Phase to "Frameworks".

Add the framework product to the Copy Frameworks build phase.

Changes in the framework will reflect in the main app.

🔗 Adding Inter-Module Dependencies
Example: Login module depends on Core.

In the dependent module (Login):

Create a group Dependencies and add the internal framework.

Add it to Copy Frameworks Build Phase.

Add the module to the Podfile and run:

bash
Copy
Edit
pod install
📦 Binary Distribution using XCFrameworks
Enable the following in build settings:

Build Libraries for Distribution

Validate Workspace

Create Identifier Certificates for each framework.

Use the following scripts to generate XCFrameworks:

bash
Copy
Edit
# Archive for iOS Device
xcodebuild archive \
-scheme Registration \
-configuration Release \
-destination 'generic/platform=iOS' \
-archivePath './build/Registration.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# Archive for iOS Simulator
xcodebuild archive \
-scheme Registration \
-configuration Release \
-destination 'generic/platform=iOS Simulator' \
-archivePath './build/Registration.framework-iphonesimulator.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

# Create XCFramework
xcodebuild -create-xcframework \
-framework './build/Registration.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/Registration.framework' \
-framework './build/Registration.framework-iphoneos.xcarchive/Products/Library/Frameworks/Registration.framework' \
-output './build/Registration.xcframework'
(Repeat similar steps for Core framework.)

In this approach, changes in the framework will not reflect in the main app unless updated.

🌐 Publishing as a Third-Party Library/SDK
✅ Steps
Install CocoaPods.

Retrieve the Xcode project containing the framework.

Create a local git repository for the framework.

Create a private podspec repo.

Create and configure .podspec file.

Run lint and publish commands.

Example .podspec for Core
ruby
Copy
Edit
Pod::Spec.new do |spec|
  spec.name             = "CoreFramework"
  spec.version          = "1.0.0"
  spec.summary          = "This is Core Framework!"
  spec.description      = "CoreFramework consists of extensions, reusable views, API and Firebase managers"
  spec.homepage         = "https://Shalini_KP@bitbucket.org/tracmobility/core-framework"
  spec.license          = "MIT"
  spec.author           = { "Shalini" => "shalini@tracmobility.co.uk" }
  spec.platform         = :ios, "13.0"
  spec.swift_version    = "5.0"
  spec.source           = { :git => "https://Shalini_KP@bitbucket.org/tracmobility/core-framework.git", :tag => "1.0.0" }
  spec.source_files     = "Core", "Core/**/*"
  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.dependency "Moya"
  spec.dependency "Firebase/Auth"
end
Publish Commands
bash
Copy
Edit
pod spec create Core
git tag 1.0.0
git push --tags
open Core.podspec -a Xcode

touch .swift-version
pod spec lint Core.podspec --allow-warnings

# For first-time private spec repo
pod repo add Core https://Shalini_KP@bitbucket.org/tracmobility/core-framework.git
cd ~/.cocoapods/repos/Core
pod repo lint Core.podspec

# Push to private repo
cd ~/Desktop/Office_TracMobility/core-framework
pod repo push Core Core.podspec --allow-warnings
Update Later
bash
Copy
Edit
pod spec lint Core.podspec --allow-warnings
pod repo lint Core.podspec
pod repo push Core Core.podspec --allow-warnings
If the framework has dependencies:

bash
Copy
Edit
pod spec lint --sources='https://Shalini_KP@bitbucket.org/tracmobility/core-framework.git,https://github.com/CocoaPods/Specs'
💡 Notes
Local Integration: Framework changes are reflected live in the app.

Binary XCFramework: Changes in framework require a rebuild and reimport.

Third-Party SDK Style: Ideal for cross-app reuse and modular publishing.
