# AppHub - Modular App Architecture

AppHub provides a robust and efficient modular app architecture designed to break down monolithic applications into independent feature modules. This approach allows for seamless integration and removal of features, promoting a more maintainable and scalable codebase.

---

## Core Principles

Our modular architecture is built upon the following principles:

* **Framework Type:** Dynamic Frameworks
* **Internal Design Pattern:** Model-View-Controller (MVC)
* **Package Manager:** CocoaPods
* **Dependency Management:** Flat Dependency Structure
* **Repository Strategy:** Monorepo Approach
* **Inversion of Control:** Dependency Injection

---

## Setting Up Your Modular App Architecture (MAA)

This section guides you through setting up your workspace and integrating feature modules.

### 1. Workspace and Main App Setup

To begin, create a central workspace that will house all your applications and modules.

1.  **Create Workspace:** Set up a general Xcode workspace where all your apps and modules will reside.
2.  **Main App Project:** Create a new Xcode project for your main application and select the previously created workspace.
3.  **Initialize CocoaPods:** Navigate to the root of your workspace in the terminal and run `pod init`. Ensure the `Podfile` is located at the same level as your `.xcworkspace` file.
4.  **Add Module Dependencies:** Add your module's external dependencies to the `Podfile` and specify the workspace.
5.  **Install Pods:** Run `pod install` in your terminal.
6.  **Compile Module:** Build your module to confirm it can correctly utilize the external dependencies.

### 2. Creating and Integrating Frameworks

Feature modules are developed as dynamic frameworks and then added as dependencies to your main application.

1.  **Create Framework Project:** Create a new Xcode project as a `Framework` and associate it with your workspace.
2.  **Organize Dependencies:** Inside your main app project, create a new group (without a folder) named "Dependencies" (or a name of your choice).
3.  **Add Framework Project:** Drag the newly created framework project into the "Dependencies" group.
4.  **Copy Files Build Phase (First Time Only):** For the first time you integrate a framework, you'll need to create a "Copy Files Build Phase" for `Frameworks` in your main application's target settings.
5.  **Add Framework Product:** Add your framework's product (the `.framework` file) to this "Copy Files Build Phase."

*Note: When integrating frameworks directly into your workspace this way, any changes within the framework will immediately reflect in the main application upon recompilation.*

### 3. Managing Inter-Module Dependencies

When one internal module depends on another (e.g., `Login` depends on `Core`), follow these steps:

1.  **Add Dependent Framework:** In the target module (e.g., `Login`), create a group (without a folder) named "Dependencies" and drag the dependent framework (e.g., `Core.framework`) into it.
2.  **Add to Build Phase:** Add the dependent framework product to the "Copy Frameworks Build Phase" of the target module.
3.  **Update Podfile:** Add the dependencies module to the target module's `Podfile` and run `pod install`.

---

## Distribution and Publishing

This section covers how to distribute your modules as binary frameworks (XCFrameworks) and publish them as third-party libraries using CocoaPods.

### 1. Creating Binary Frameworks (XCFrameworks)

XCFrameworks allow you to distribute your modules as pre-compiled binaries, which can improve build times for consuming applications.

1.  **Enable Distribution Builds:** For each framework target, ensure "Build Libraries for Distribution" is enabled in its build settings. Also, enable "Validate Workspace" for target integrity.
2.  **Create Identifier Certificates:** Generate necessary identifier certificates for each framework.
3.  **Run Build Scripts:** Utilize the provided `xcodebuild` scripts to archive your frameworks for both iOS devices and simulators, then combine them into a single XCFramework bundle.

    ```bash
    # Example for 'Registration' framework
    xcodebuild archive \
    -scheme Registration \
    -configuration Release \
    -destination 'generic/platform=iOS' \
    -archivePath './build/Registration.framework-iphoneos.xcarchive' \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

    xcodebuild archive \
    -scheme Registration \
    -configuration Release \
    -destination 'generic/platform=iOS Simulator' \
    -archivePath './build/Registration.framework-iphonesimulator.xcarchive' \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

    xcodebuild -create-xcframework \
    -framework './build/Registration.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/Registration.framework' \
    -framework './build/Registration.framework-iphoneos.xcarchive/Products/Library/Frameworks/Registration.framework' \
    -output './build/Registration.xcframework'

    # Example for 'Core' framework (repeat similar process)
    xcodebuild archive \
    -scheme Core \
    -configuration Release \
    -destination 'generic/platform=iOS' \
    -archivePath './build/Core.framework-iphoneos.xcarchive' \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

    xcodebuild archive \
    -scheme Core \
    -configuration Release \
    -destination 'generic/platform=iOS Simulator' \
    -archivePath './build/Core.framework-iphonesimulator.xcarchive' \
    SKIP_INSTALL=NO \
    BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

    xcodebuild -create-xcframework \
    -framework './build/Core.framework-iphonesimulator.xcarchive/Products/Library/Frameworks/Core.framework' \
    -framework './build/Core.framework-iphoneos.xcarchive/Products/Library/Frameworks/Core.framework' \
    -output './build/Core.xcframework'
    ```

4.  **Add to Project:** Once created, add the generated `.xcframework` bundles to your project's "Frameworks, Libraries, and Embedded Content."

*Note: When using binary frameworks, changes within the framework will **not** automatically reflect in the main app. You'll need to regenerate and update the XCFrameworks.*

### 2. Publishing as a Third-Party Library/SDK (via CocoaPods)

To make your modules easily consumable across different projects or by other teams, you can publish them as CocoaPods.

1.  **Install CocoaPods:** Ensure you have CocoaPods installed.
2.  **Retrieve Xcode Project:** Have your framework's Xcode project readily available.
3.  **Initialize Git Repository:** Create a local Git repository to host your framework project.
4.  **Create Local Specification Repository:** Set up a local CocoaPods specification repository if you don't have one.
5.  **Create Podspec:** Use `pod spec create YourModuleName` to generate a new podspec file.
6.  **Edit Podspec:** Open the generated `.podspec` file and fill in the necessary details. Here's an example for the `Core` framework:

    ```ruby
    # Core.podspec example
    Pod::Spec.new do |spec|
      spec.name                  = "CoreFramework" # Corrected from your draft
      spec.version               = "1.0.0"
      spec.summary               = "This is Core Framework!"
      spec.description           = "CoreFramework consists of extensions, reusable views, API and firebase managers"
      spec.homepage              = "[https://Shalini_KP@bitbucket.org/tracmobility/core-framework](https://Shalini_KP@bitbucket.org/tracmobility/core-framework)"
      spec.license               = "MIT"
      spec.author                = { "Shalini" => "shalini@tracmobility.co.uk" }
      spec.platform              = :ios
      spec.swift_version         = "5.0"
      spec.ios.deployment_target = '13.0'

      spec.source                = { :git => "[https://Shalini_KP@bitbucket.org/tracmobility/core-framework.git](https://Shalini_KP@bitbucket.org/tracmobility/core-framework.git)", :tag => "1.0.0" }
      spec.source_files          = "Core", "Core/**/*"

      spec.pod_target_xcconfig   = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
      spec.user_target_xcconfig  = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

      spec.dependency "Moya"
      spec.dependency "Firebase/Auth"
    end
    ```

7.  **Tag Your Release:** Tag your Git repository with the version specified in your podspec.
    ```bash
    git tag 1.0.0
    git push --tags
    ```
8.  **Lint Podspec:** Validate your podspec file.
    ```bash
    pod spec lint Core.podspec --allow-warnings
    ```
    *If your framework has external dependencies, you might need to specify sources:*
    ```bash
    pod spec lint --sources='[https://Shalini_KP@bitbucket.org/tracmobility/core-framework.git,https://github.com/CocoaPods/Specs](https://Shalini_KP@bitbucket.org/tracmobility/core-framework.git,https://github.com/CocoaPods/Specs)'
    ```
9.  **Set Swift Version (if needed):** Create a `.swift-version` file at the root of your framework project if you haven't already.
    ```bash
    touch .swift-version
    echo "5.0" > .swift-version # Replace 5.0 with your Swift version
    ```
10. **Add Private Spec Repo (First Time):** If you're using a private spec repository, add it:
    ```bash
    pod repo add Core [https://Shalini_KP@bitbucket.org/tracmobility/core-framework.git](https://Shalini_KP@bitbucket.org/tracmobility/core-framework.git)
    cd ~/.cocoapods/repos/Core
    ```
11. **Lint Repo:**
    ```bash
    pod repo lint Core.podspec
    ```
12. **Push to Spec Repo:** Publish your framework specification to your repository.
    ```bash
    pod repo push Core Core.podspec --allow-warnings
    ```

    *To update an existing podspec:*
    ```bash
    pod spec lint Core.podspec --allow-warnings
    pod repo lint Core.podspec
    pod repo push Core Core.podspec --allow-warnings
    ```
13. **Install into App:** Once published, you can install your framework into any app by adding it to the `Podfile` and running `pod install`.

---

## Important Notes

* **Local Framework Integration:** Directly integrating custom frameworks into your workspace allows for immediate reflection of changes in the main app during development.
* **Binary Frameworks:** Generating binary frameworks (XCFrameworks) is ideal for distribution, as changes within the framework won't automatically affect the consuming app. This requires explicit updates of the XCFramework.
* **CocoaPods Distribution:** Publishing frameworks as CocoaPods (third-party libraries/SDKs) provides the most flexible and reusable approach for module distribution across multiple applications or teams.

---
