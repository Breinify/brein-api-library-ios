

<p align="center">
 <img src="https://raw.githubusercontent.com/Breinify/brein-api-library-ios/master/logo.png" alt="Breinify API iOS Library" width="250">
</p>

<p align="center">
Breinify's DigitalDNA API puts dynamic behavior-based, people-driven data right at your fingertips.
</p>

# Breinify's API Library


[![Version](https://img.shields.io/cocoapods/v/BreinifyApi.svg?style=flat)](http://cocoapods.org/pods/BreinifyApi)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/BreinifyApi.svg?style=flat)](http://cocoapods.org/pods/BreinifyApi)
[![Platform](https://img.shields.io/cocoapods/p/BreinifyApi.svg?style=flat)](http://cocoapods.org/pods/BreinifyApi)

<sup>Features: **PushNotifications**, **Temporal Data**, **(Reverse) Geocoding**, **Events**, **Weather**, **Holidays**, **Analytics** </sup>


This library utilizes [Breinify's API](https://www.breinify.com) to provide tasks like `PushNotifications`, `geocoding`, `reverse geocoding`, `weather and events look up`, `holidays determination` through the API's endpoints, i.e., `/activity` and `/temporaldata`. Each endpoint provides different features, which are explained in the following paragraphs. In addition, this documentation gives detailed examples for each of the features available for the different endpoints.

**PushNotifications**: *TODO*


**Activity Endpoint**: The endpoint is used to understand the usage-patterns and the behavior of a user using, e.g., an application, a mobile app, or a web-browser. The endpoint offers analytics and insights through Breinify's dashboard.

**TemporalData Endpoint**: The endpoint offers features to resolve temporal information like a timestamp, a location (latitude and longitude or free-text), or an IP-address, to temporal information (e.g., timezone, epoch, formatted dates, day-name),  holidays at the specified time and location, city, zip-code, neighborhood, country, or county of the location, events at the specified time and location (e.g., description, size, type), weather at the specified time and location (e.g., description, temperature).



## Requirements

- iOS 9.0+ 
- Xcode 8.1+
- AppCode 2016.3+
- Swift 3.0+


## Installation

### CocoaPods
#### Step 1 - Install CocoaPods

Installing the BreinifyApi via the iOS [CocoaPods](http://cocoapods.org) automates the majority of the installation process. Before beginning this process please ensure that you are using Ruby version 2.0.0 or greater. Don’t worry, knowledge of Ruby syntax isn’t necessary to install the Library.

Simply run the following command to get started:

```bash
$ sudo gem install cocoapods
```

#####Note: If you are new to Cocopods further details can be found [here](http://guides.cocoapods.org/using/getting-started.html)

#### Step 2 - Create Podfile

To integrate BreinifyApi into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'BreinifyApi'
end
```


#### Step 3 - Install the BreinifyApi

To install the BreinifyApi, navigate to the directory where your `Podfile`resides within your terminal and run the following command:

```bash
$ pod install
```

The BreinifyApi Dependency will be added and a XCode workspace will be generated. This workspace file bundles your original Xcode project, the BreinifyApi library, and its dependencies.

At this point you should be able to open the new Xcode project workspace created by CocoaPods. From now on, you have to use <ProjectName>.xcworkspace instead of <ProjectName>.xcodeproj.

### Carthage
Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.
You can install Carthage with Homebrew using the following command:

#### Step 1 - Intall Carthage

You can install Carthage with homebrew. 

```bash
$ brew update
$ brew install carthage
```

Make sure you are running the latest version of Carthage.

```bash
$ brew upgrade carthage
```

#### Step 2 - Create Cartfile
To integrate BreinifyApi into your Xcdoe project using Carthage, specify in your `Cartfile`:

```
github "Breinify/brein-api-library-ios"

```

#### Step 3 - Install the BreinifyApi 
To install the BreinifyApi, navigate to the directory where your `Cartfile`resides within your terminal and run the following command:

```bash
$ carthage update
```
This will fetch dependencies into a Carthage/Checkouts folder. Drag `BreinifyApi.framework` into your Xcode project.


## Dependencies

BreinifyApi includes the following two libraries:

- Alamofire
- IDZSwiftCommonCrypto

## License

BreinifyApi is available under the MIT license. This applies also for Alamofire and IDZSwiftCommonCrypto. 
See the LICENSE file for more info.


## Getting Started

### Retrieving an API-Key

First of all, you need a valid API-key, which you can get for free at [https://www.breinify.com](https://www.breinify.com). In the examples, we assume you have the following api-key:


**772A-47D7-93A3-4EA9-9D73-85B9-479B-16C6**




## PushNotifications: Selected Usage Examples


Let's integrate Breinify's PushNotifications within an iOS App.


### Configuring your app for push notifications

Your app must first be configured and built with an App ID and provisioning profile configured to use the Apple Push Notifications service.

#### XCode managed signing 

You could either enable `Automatically manage signing` within XCode and XCode will create the appropriate profiles, App ID and certificate for you.

<p align="center">
  <img src="https://raw.githubusercontent.com/Breinify/brein-api-library-ios/master/Documentation/Xcode_enable.png"
	alt="Xcode" width="650">
</p>


Or you could handle it by your own. If this is your approach you have to do the following steps:


#### Set up your App ID

To begin, log in to the iOS developer center and browse to Certificates, Identifiers & Profiles.

Select "App IDs" under the "Identifiers" section of the left-hand navigation pane and click the plus icon to the top-right to create a new App ID.

<p align="center">
  <img src="https://raw.githubusercontent.com/Breinify/brein-api-library-ios/master/Documentation/app_id_setup.png" alt="App ID" width="650">
</p>

Give your App ID a descriptive name - then make sure the App ID prefix and Bundle ID are correct. Your Bundle ID should match the Bundle ID of your app in Xcode. Make sure to check "Push Notifications" under App Services, then click Continue.

<p align="center">
  <img src="https://raw.githubusercontent.com/Breinify/brein-api-library-ios/master/Documentation/app_name.png" alt="App Name" width="650">
</p>

Once created, click your new App ID and then click Edit.



### Setting up Push Certificate

Apple supports the P8 and P12 certificates. This sample assumes that you use the new
P8 certificate that can be used in development and production environment having the benefit that it won't expire.

<p align="center">
  <img src="https://raw.githubusercontent.com/Breinify/brein-api-library-ios/master/Documentation/certifcate_first_page.png" alt="Certificate" width="650">
</p>

TODO: TEXT hier

<p align="center">
  <img src="https://raw.githubusercontent.com/Breinify/brein-api-library-ios/master/Documentation/certifcate_second_page.png" alt="Certificate" width="650">
</p>


After having pressed the `Continue` button the *APNs Auth Key* will be generated. You
now have to download the key and provide it to our engine.

<p align="center">
  <img src="https://raw.githubusercontent.com/Breinify/brein-api-library-ios/master/Documentation/certifcate_third_page.png" alt="Certificate" width="650">
</p>

The certifcate has been generated and you can now download it by clicking at the `Download` button. Please provide this certificate to your Technical Support Team in order to integrate this within the Breinify environment. 


### Configuring iOS app

You have to add the `PushNotification` capabilities to the App.

<p align="center">
  <img src="https://raw.githubusercontent.com/Breinify/brein-api-library-ios/master/Documentation/capabilities.png" alt="Capabilities" width="650">
</p>

Furthermore you have to allow your app to provide location information. This is done by adding the following two
properties to the `Info.plist` file:

- Privacy - Location Always Usage Description
- Privacy - Location When In Use Usage Description

So it will look like this:

<p align="center">
  <img src="https://raw.githubusercontent.com/Breinify/brein-api-library-ios/master/Documentation/info_plist.png" alt="Info-Plist" width="650">
</p>

### Integration


Using Breinify Push Notifications in iOS apps is pretty straightforward. The Breinify SDK integrates smoothly within the iOS Application Lifecycle. Simply invoke the appropriate Breinify functions within the following lifecycle functions:

- didFinishLaunchingWithOptions
- applicationDidEnterBackground
- applicationDidBecomeActive
- applicationWillTerminate
- didRegisterForRemoteNotificationsWithDeviceToken
- didReceiveRemoteNotification

Add the following statement in your `AppDelegate.swift` file:

```Swift
import BreinifyApi
```

The entry point `didFinishLaunchingWithOptions` is used to configure the Breinify SDK. 

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {       
  let kValidApiKey = "772A-47D7-93A3-4EA9-9D73-85B9-479B-16C6"
  let kValidSecret = "lmqwj4k27hbbszzyiqamhg=="
       
  Breinify.didFinishLaunchingWithOptions(apiKey: kValidApiKey, 
            secret: kValidSecret, nil)
  return true
}
```

Perfect, the BreinifyApi is now configured, a default BreinUser is created and the communication to the Breinify Engine is now possible.

Now we need to cover the situation when the app goes into background mode. So we add the lifecycle information to the BreinifyApi as well.


```Swift
func applicationDidEnterBackground(_ application: UIApplication) { 
     Breinify.applicationDidEnterBackground()
}

```

Whenever the App is active again we need to tell this the BreinifyApi as well. So we 
simply pass this information to the Breinfy class.

```Swift
func applicationDidBecomeActive(_ application: UIApplication) {         
     Breinify.applicationDidBecomeActive()
}

```

When the App terminates we pass this information in order to do some housekeeping. 

```Swift
func applicationWillTerminate(_ application: UIApplication) {
        Breinify.applicationWillTerminate()
}

```

Now we need to provide the device token to the Breinify Engine as well. So we add the following functionality to the *didRegisterForRemoteNotificationsWithDeviceToken* within AppDelegate.swift:

```Swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  // register device Token within the API
  Breinify.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
}

```


Add the following lines to the function *didReceiveRemoteNotification*. This will
provide a short dialog within the app.

```Swift
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
   completionHandler(.newData)  
   Breinify.didReceiveRemoteNotification(userInfo, nil)
}
```




## Activity: Selected Usage Examples

The endpoint is used to track the usage of, e.g., an application, an app, or a web-site. There are several libraries available to be used for different system (e.g., [iOS](https://github.com/Breinify/brein-api-library-ios), [Android](https://github.com/Breinify/brein-api-library-android), [Java](https://github.com/Breinify/brein-api-library-java), [nodeJs](https://github.com/Breinify/brein-api-library-node), [ruby](https://github.com/Breinify/brein-api-library-ruby), [php](https://github.com/Breinify/brein-api-library-php), [python](https://github.com/Breinify/brein-api-library-python)).


### Configure the Library

If you're not following the iOS Lifecycle approach that is described in above you have to configure the BreinifyApi by creating a BreinifyConfig object and assigning it to the Breinfy class.

This would look like this:

```Swift
// this has to be a valid api key and secret
let validApiKey = "772A-47D7-93A3-4EA9-9D73-85B9-479B-16C6"
let validSecret = "iTttt=0=w2244="

// create the configuration object
let breinConfig = BreinConfig(validApiKey, secret: validSecret)
    
// set configuration
Breinify.setConfig(breinConfig)
```

*Remark:* This step is not neceessary if you have integrated the BreinifyApi with the iOS Lifecycle approach.

#### Step 3: Start using the library

##### Placing activity triggers

The engine powering the DigitalDNA API provides two endpoints. The first endpoint is used to inform the engine about the activities performed by visitors of your site. The activities are used to understand the user's current interest and infer the intent. It becomes more and more accurate across different users and verticals as more activities are collected. It should be noted, that any personal information is not stored within the engine, thus each individual's privacy is well protected. The engine understands several different activities performed by a user, e.g., landing, login, search, item selection, or logout.

The engine is informed of an activity by executing *Breinify.activity(...)*. 

```Swift
typealias apiSuccess = (_ result:BreinResult?) -> Void
typealias apiFailure = (_ error:NSDictionary?) -> Void

// create a user you are interested in 
let breinUser = BreinUser()
   .setEmail("f.firestone@me.com")
   .setFirstName("Fred")

// callback in case of success
let successBlock: apiSuccess = {
     (result: BreinResult?) -> Void in
     print("Api Success : result is:\n \(result!)")
}

// callback in case of a failure
let failureBlock: apiFailure = {
     (error: NSDictionary?) -> Void in
     print("Api Failure: error is:\n \(error)")
}

// invoke activity call
do {
    try Breinify.activity(breinUser,
         activityType: "login",
             category: "home",
          description: "Login-Description",
              success: successBlock,
              failure: failureBlock)
  } catch {
    print("Error is: \(error)")
} 
```

That's it! The call will be run asynchronously in the background and depending of the result the successBlock or failureBlock callback will be invoked.

##### Collecting and Providing UserData  
Assuming that you have an asynchronous flow of information and will collect user data at first and
will send activity requests later on. In this case you could simlpy create an instance of class BreinUser, fill the properties and assign this instance to class Breinify before you invoke the *activity* request.

This might look like this:


```Swift
// create the Breinify User
let breinUser = BreinUser(email: "f.firestone@me.com")
          .setFirstName("Fred")
          .setLastName("Firestone")
          .setSessionId("TAAD8888HHdjh")

// save it to class Breinfy
Breinify.setBreinUser(breinUser)
```

Later on, maybe on a special event, you can trigger the activity request like this:

```Swift
// invoke activity call
do {
   try Breinify.activity("firstPage",
        category: "home",
     description: "firstPage-Description",
         success: successBlock,
         failure: failureBlock)
} catch {
    dump("Error is: \(error)")
}
```

In this case the `activity` call will use the previously saved BreinUser object with all it's
properties.


## TemporalData: Selected Usage Examples

### Retrieve Client's Information (Location, Weather, Events, Timezone, Time)

The endpoint is capable to retrieve some information about the client, based on client specific information (e.g., the IP-address). 
Temporal Intelligence API provides temporal triggers and visualizes patterns
enabling you to predict a visitor’s dynamic activities. Currently this will
cover:

- Current Weather
- Upcoming Holidays
- Time Zone
- Regional Events

They can be requested like this:

```swift
let failureBlock: apiFailure = {
     (error: NSDictionary?) -> Void in
     print("Api Failure : error is:\n \(error)")
}
     
let successBlock: apiSuccess = {
    (result: BreinResult?) -> Void in
    print("Api Success : result is:\n \(result!)")

    if let holiday = result!.get("holidays") {
        print("Holiday is: \(holiday)")
    }
    if let weather = result!.get("weather") {
        print("Weather is: \(weather)")
    }
    if let location = result!.get("location") {
        print("Location is: \(location)")
    }
    if let time = result!.get("time") {
        print("Time is: \(time)")
    }
}

do {
    let user = BreinUser(email: "fred.firestone@email.com")
          .setFirstName("Fred")
          .setTimezone("America/Los_Angeles")
          .setLocalDateTime("Sun Dec 25 2016 18:15:48 GMT-0800 (PST)")

    try Breinify.temporalData(user,
              success: successBlock,
              failure: failureBlock)
     } catch {
         print("Error")
     }
 }
```


### Additional Code Snippets

The following code snippets provides addtional information how to use the *BreinifyApi* library for iOS.


#### BreinUser
Class BreinUser provides additional methods to add further data. This example shows all possible options: 


````swift
let breinUser = BreinUser(email: "user.anywhere@email.com")

breinUser.setFirstName("User")
         .setLastName("Anywhere")
         .setImei("356938035643809")
         .setDateOfBirth(6, day: 20, year: 1985)
         .setDeviceId("AAAAAAAAA-BBBB-CCCC-1111-222222220000")
         .setSessionId("SID:ANON:w3.org:j6oAOxCWZh/CD723LGeXlf-01:034")
      

````





