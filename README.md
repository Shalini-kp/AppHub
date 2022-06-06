# AppHub - Modular App Architecture
Breaking Monolith into feature modules to acheive a robust application which allows to plugin-out apps/features efficiently.

Prerequisites:
Framework Type - Dynamic framework

Internal Design Pattern - MVC

Package Manager - cocoa pods

Dependency Management - flat dependency

Monorepo approach

Dependency Injection

(Set standards).

Set up MAA: 
Setting up the workspace and Creating a module
Create and set up a general workspace for all apps to integrate.

Create a project for the main app and choose the Workspace.

Initialize Cocoapods and place the Podfile at the Root level of the workspace, where the workspace file is located.

Add the module’s dependencies to the Podfile and mention the workspace.

Run pod install and compile the module to make sure it can use the external dependencies.

Creating a framework and Adding them as a dependency of the App.
Create a project as a framework and choose the Workspace.

Create a group without a folder and name it “Dependencies” or whatever you like.

Drag the project you want to depend upon into the group created in the previous step.

(Only the first time) Create a Copy Files Build Phase to Frameworks.

Add the framework product to the copy frameworks build phase.

In this case, whatever changes in the framework ll reflect on the main app

Adding inter-module dependencies.
Do this when a module depends on another internal module. For example, Login depends on Core.

In the target module (Log in), create a group without a folder and name it “Dependencies” and add the dependent framework.

Add the framework product to the copy frameworks build phase.

Add the dependencies module in the Podfile and pod install.

Distribution (creating binary framework - XCFramework)
Create XCFramework and add them to copy frameworks.

Enable Build Libraries for Distribution. Enable Validate workspace for target integrity.

Create Identifier Certificates for each framework.

Run scripts to achieve (simulator + phone) each framework and create the bundle.

Add it to the frameworks to import into the project.

In this case, whatever is changed in the framework ll not be reflected in the main app.

Publishing (creating it as third party library/framework or SDK)
Install Cocoapods

Retrieve an Xcode project containing a framework target

Create a local git repository to host our framework project

Create a local specification repository

Publish our framework specification to our specification repository

Install our framework into an app

Scripts to achieve and Create XCFramework
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

Commands to host the framework in the repo
pod spec create  Core

git tag 1.0.0

git push --tags

open Core.podspec -a Xcode


Pod::Spec.new do |spec|

 

  SPEC.NAME          = "CoreFramework"

  spec.version      = "1.0.0"

  spec.summary      = "This is Core Framework!"

  spec.description  = "CoreFramework consists of extensions, resuable views, API and firebase managers"

 

  spec.homepage     = "https://Shalini_KP@bitbucket.org/tracmobility/core-framework"

  spec.license      = "MIT"

  spec.author       = { "Shalini" => "shalini@tracmobility.co.uk" }

  spec.platform     = :ios

  spec.swift_version = "5.0"

  spec.ios.deployment_target  = '13.0'

    

  spec.source       = { :git => "https://Shalini_KP@bitbucket.org/tracmobility/core-framework.git", :tag => "1.0.0" }

 

  spec.source_files  = "Core", "Core/**/*"

 

  # spec.requires_arc = true

 

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  

  spec.pod_target_xcconfig = {

    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'

  }

  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  

  spec.dependency "Moya"

  spec.dependency "Firebase/Auth"

 

end

pod spec lint 

touch .swift-version

pod spec lint Core.podspec --allow-warnings

Private Spec Repo for making framework live
CocoaPods.org 

pod repo add Core https://Shalini_KP@bitbucket.org/tracmobility/core-framework.git (For the first time)

cd ~/.cocoapods/repos/Core (For the first time)

pod repo lint Core.podspec

cd ~/Desktop/Office_TracMobility/core-framework

pod repo push Core Core.podspec --allow-warnings

On other times to update 

pod spec lint Core.podspec --allow-warnings

pod repo lint Core.podspec

pod repo push Core Core.podspec --allow-warnings

If the framework has dependency then it will ask for specifications

pod spec lint --sources='https://Shalini_KP@bitbucket.org/tracmobility/core-framework.git,https://github.com/CocoaPods/Specs'

Note:
While using custom frameworks I found these ways as per the trials I did!

Locally integrating the custom frameworks where If we change something in frameworks that will reflect in the main app (when we are importing that framework.)

Generating binary frameworks from custom! In this,  If we change something in frameworks that will not reflect in the main app (when we are importing that framework.)

Make the frameworks as third-party or small SDK and install them from Pod!  (the framework will be pushed separately to our repository). In the future, we can reuse this for other Apps just using as third-party libraries we use!
