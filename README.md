#BreinifyApi

<p align="center">
 <img src="https://raw.githubusercontent.com/Breinify/brein-api-library-ios/master/logo.png" alt="Breinify API iOS Library" width="250">
</p>

<p align="center">
Breinify's DigitalDNA API puts dynamic behavior-based, people-driven data right at your fingertips.
</p>


[![Version](https://img.shields.io/cocoapods/v/BreinifyApi.svg?style=flat)](http://cocoapods.org/pods/BreinifyApi)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/BreinifyApi.svg?style=flat)](http://cocoapods.org/pods/BreinifyApi)
[![Platform](https://img.shields.io/cocoapods/p/BreinifyApi.svg?style=flat)](http://cocoapods.org/pods/BreinifyApi)


### Step By Step Introduction

#### What is Breinify's DigitialDNA

Breinify's DigitalDNA API puts dynamic behavior-based, people-driven data right at your fingertips. We believe that in many situations, a critical component of a great user experience is personalization. With all the data available on the web it should be easy to provide a unique experience to every visitor, and yet, sometimes you may find yourself wondering why it is so difficult.

Thanks to **Breinify's DigitalDNA** you are now able to adapt your online presence to your visitors needs and **provide a unique experience**. Let's walk step-by-step through a simple example.


## Requirements

- iOS 9.0+ 
- Xcode 8.2+
- AppCode 2016.3
- Swift 3.0


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
platform :ios, '10.0'
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
This will fetch dependencies into a Carthage/Checkouts folder. Drag BreinifyApi.framework into your Xcode project.


## Dependencies

BreinifyApi includes the following two libraries:

- Alamofire
- IDZSwiftCommonCrypto

## License

BreinifyApi is available under the MIT license. This applies also for Alamofire and IDZSwiftCommonCrypto. 
See the LICENSE file for more info.


## BreinifyApi Integration 

#### Step 1: Request API-key

In order to use the library you need a valid API-key, which you can get for free at [https://www.breinify.com](https://www.breinify.com). In this example, we assume you have the following api-key:

**772A-47D7-93A3-4EA9-9D73-85B9-479B-16C6**


### Step 2: Include the BreinifyApi module

Add the following line to your swift file (e.g. ViewController.swift)

```Swift
import BreinifyApi

```

### Step 3: Configure the Library

The BreinifyApi needs to be configured with an instance of BreinConfig containing a valid API-key and a secret (optional).  

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

##### Option 2 
Assume that you have an asynchronous flow of information and will collect user data at first and
will send activity requests later on. In this use case you could simlpy use class Breinify and collect the user data. When sending the activity request the class Breinify will use the previous saved user data.

We take a look at this example.

Anywhere in your swift file you have the chance to identify the user like this:

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
data.


#####  Placing temporalData triggers

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

##### Placing look-up triggers

Look-ups are used to retrieve dedicated information for a given user. This code snippet assumes that the typealias and further objects from above are in the same scope. 

```swift
typealias apiSuccess = (result:BreinResult?) -> Void
typealias apiFailure = (error:NSDictionary?) -> Void

// create a user you are interested in with his email (mandatory field)
let breinUser = BreinUser(email: "fred.firestone@email.com")

// define an array of subjects of interest
let dimensions: [String] = ["firstname", "gender",
                                "age", "agegroup", 
                                "digitalfootprint", "images"]

// wrap this array into BreinDimension object
let breinDimension = BreinDimension(dimensionFields: dimensions)

// invoke the lookup
let successBlock: apiSuccess = {(result: BreinResult?) -> Void in
     print ("Api Success!")

     if let dataFirstname = result!.get("firstname") {
         print ("Firstname is: \(dataFirstname)")
     }

     if let dataGender = result!.get("gender") {
         print ("Gender is: \(dataGender)")
     }

     if let dataAge = result!.get("age") {
         print ("Age is: \(dataAge)")
     }

     if let dataAgeGroup = result!.get("agegroup") {
         print ("AgeGroup is: \(dataAgeGroup)")
     }

     if let dataDigitalFootprinting = result!.get("digitalfootprinting") {
            print ("DigitalFootprinting is: \(dataDigitalFootprinting)")
     }

     if let dataImages = result!.get("images") {
         print ("DataImages is: \(dataImages)")
     }
 }

let failureBlock: apiFailure = {(error: NSDictionary?) -> Void in
     print ("Api Failure : error is:\n \(error)")
}

do {
   try Breinify.lookup(breinUser,
        dimension: breinDimension,
          success: successBlock,
          failure: failureBlock)
} catch {
    print("Error is: \(error)")
}

```

## App Capabilities 
The BreinifyApi can automatically send the users location information if the permission for this has been granted within the app. The following two options needs to be set within the info.plist file:

```
...
<key>NSLocationAlwaysUsageDescription</key>
<string>Please allow this app to provide location data.</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>Please allow this app to provide location data.</string>
...
```


## Full working sample 

Let’s navigate back to Xcode and inside the IDE, go to ViewController.swift. The code should look like this:

```swift
import UIKit
import BreinifyApi

class ViewController: UIViewController {

    typealias apiSuccess = (_ result: BreinResult?) -> Void
    typealias apiFailure = (_ error: NSDictionary?) -> Void

    // create Brein user
    let breinUser = BreinUser()         

    // invoked when activityButton has been pressed
    @IBAction func actionButtonPressed(sender: AnyObject) {

        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            print("Api Success : result is:\n \(result)")
        }

        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            print("Api Failure : error is:\n \(error)")
        }

        // set additional user information
        breinUser.setFirstName("Fred")
                 .setLastName("Firestone")

        // invoke activity call
        do {
            try Breinify.activity(breinUser,
                    activityType: "paginaUno",
                    category: "home",
                    description: "paginaUno-Description",
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            dump("Error is: \(error)")
        }
    }

   override func viewDidLoad() {
    super.viewDidLoad()

    // this has to be a valid api-key & secret
    let validApiKey = "772A-47D7-93A3-4EA9-9D73-85B9-479B-16C6"
    let validSecret = "lmcoj4k27hbbszzyiqamhg=="

    // create the configuration object
    let breinConfig = BreinConfig(validApiKey, secret: validSecret)
    
    // set configuration
    Breinify.setConfig(breinConfig)    
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





