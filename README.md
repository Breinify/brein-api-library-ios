#BreinifyApi

<p align="center">
 <img src="https://raw.githubusercontent.com/Breinify/brein-api-library-ios/master/logo.png" alt="Breinify API iOS Library" width="250">
</p>

<p align="center">
Breinify's DigitalDNA API puts dynamic behavior-based, people-driven data right at your fingertips.
</p>


[![Version](https://img.shields.io/cocoapods/v/BreinifyApi.svg?style=flat)](http://cocoapods.org/pods/BreinifyApi)
[![License](https://img.shields.io/cocoapods/l/BreinifyApi.svg?style=flat)](http://cocoapods.org/pods/BreinifyApi)
[![Platform](https://img.shields.io/cocoapods/p/BreinifyApi.svg?style=flat)](http://cocoapods.org/pods/BreinifyApi)


### Step By Step Introduction

#### What is Breinify's DigitialDNA

Breinify's DigitalDNA API puts dynamic behavior-based, people-driven data right at your fingertips. We believe that in many situations, a critical component of a great user experience is personalization. With all the data available on the web it should be easy to provide a unique experience to every visitor, and yet, sometimes you may find yourself wondering why it is so difficult.

Thanks to **Breinify's DigitalDNA** you are now able to adapt your online presence to your visitors needs and **provide a unique experience**. Let's walk step-by-step through a simple example.


## Requirements

- iOS 9.3+ 
- Xcode 8.0+
- AppCode 2016.2


## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate BreinifyApi into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.3'
use_frameworks!

target '<Your Target Name>' do
    pod 'BreinifyApi'
end
```

Then, run the following command:

```bash
$ pod install
```

The BreinifyApi Dependency will be added and a XCode workspace will be generated. This workspace file bundles your original Xcode project, the BreinifyApi library, and its dependencies.

So from now on, you have to use <ProjectName>.xcworkspace instead of <ProjectName>.xcodeproj.

## Dependencies

BreinifyApi includes the following two libraries:

- Alamofire
- IDZSwiftCommonCrypto

## License

BreinifyApi is available under the MIT license. This applies also for Alamofire and IDZSwiftCommonCrypto. See the LICENSE file for more info.


## Usage

#### Step 1: Request API-key

In order to use the library you need a valid API-key, which you can get for free at [https://www.breinify.com](https://www.breinify.com). In this example, we assume you have the following api-key:

**772A-47D7-93A3-4EA9-9D73-85B9-479B-16C6**


### Step 2: Include the BreinifyApi module

```Swift
import BreinifyApi

```


### Step 3: Configure the Library



The Breinify class needs to be configured with an instance of BreinConfig containing a valid API-key, the URL of the Breinify Backend and the Rest-Engine. 
Alamofire is used for any requests.  

This would look like this:

```Swift
// this has to be a valid api key
let validApiKey = "772A-47D7-93A3-4EA9-9D73-85B9-479B-16C6"

// create the configuration object
let breinConfig = BreinConfig(apiKey: validApiKey)

// set configuration
Breinify.setConfig(breinConfig)

```

#### Step 3: Start using the library

##### Placing activity triggers

The engine powering the DigitalDNA API provides two endpoints. The first endpoint is used to inform the engine about the activities performed by visitors of your site. The activities are used to understand the user's current interest and infer the intent. It becomes more and more accurate across different users and verticals as more activities are collected. It should be noted, that any personal information is not stored within the engine, thus each individual's privacy is well protected. The engine understands several different activities performed by a user, e.g., landing, login, search, item selection, or logout.

The engine is informed of an activity by executing *Breinify.activity(...)*. 

```Swift
// create a user you are interested in with his email
let breinUser = BreinUser(email: "fred.firestone@email.com")

typealias apiSuccess = (result:BreinResult?) -> Void
typealias apiFailure = (error:NSDictionary?) -> Void

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

// set additional user information (optional)
breinUser.setFirstName("Fred")
breinUser.setLastName("Firestone")

// invoke activity call
do {
    try Breinify.activity(breinUser,
         activityType: "login",
             category: "home",
          description: "Login-Description",
                 sign: false,
              success: successBlock,
              failure: failureBlock)
  } catch {
    print("Error is: \(error)")
} 
```

That's it! The call will be run asynchronously in the background and depending of the result the successBlock or failureBlock callback will be invoked.

#####  Placing temporalData triggers

Temporal Intelligence API provides temporal triggers and visualizes patterns
enabling you to predict a visitor’s dynamic activities. Currently this will
cover:
* Current Weather
* Upcoming Holidays
* Time Zone
* Regional Events

They can be requested like this:

```swift
func testTemporalData() {

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
         .setIpAddress("74.115.209.58")
         .setTimezone("America/Los_Angeles")
         .setLocalDateTime("Sun Dec 25 2016 18:15:48 GMT-0800 (PST)")

         try Breinify.temporalData(user,
                 sign: false,
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
             sign: false,
          success: successBlock,
          failure: failureBlock)
} catch {
    print("Error is: \(error)")
}

```



## Full working sample 

Let’s navigate back to Xcode and inside the IDE, go to ViewController.swift. The code should look like this:

```swift
import UIKit
import BreinifyApi

class ViewController: UIViewController {

    @IBAction func activityPressed(sender: AnyObject) {

    // create a user you are interested in with his email (mandatory field)
    let breinUser = BreinUser(email: "fred.firestone@email.com")

    typealias apiSuccess = (result:BreinResult?) -> Void
    typealias apiFailure = (error:NSDictionary?) -> Void

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

    // set additional user information (optional)
    breinUser.setFirstName("Fred")
    breinUser.setLastName("Firestone")

    // invoke activity call
    do {
       try Breinify.activity(breinUser,
            activityType: "login",
                category: "home",
             description: "Login-Description",
                    sign: false,
                 success: successBlock,
                 failure: failureBlock)
    } catch {
       print("Error is: \(error)")
    }

}

@IBAction func lookupPressed(sender: AnyObject) {

    typealias apiSuccess = (result:BreinResult?) -> Void
    typealias apiFailure = (error:NSDictionary?) -> Void

    // create a user you are interested in with his email (mandatory field)
    let breinUser = BreinUser(email: "fred.firestone@email.com")

    // define an array of subjects of interest
    let dimensions: [String] = ["firstname", "gender",
                                "age", "agegroup", "digitalfootprint", "images"]

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
                sign: false,
                success: successBlock,
                failure: failureBlock)
    } catch {
        print("Error is: \(error)")
    }
  }

   override func viewDidLoad() {
    super.viewDidLoad()

    // this has to be a valid api-key
    let validApiKey = "772A-47D7-93A3-4EA9-9D73-85B9-479B-16C6"

    // create the configuration object
    let breinConfig = BreinConfig(apiKey: validApiKey)
    
    // set configuration
    Breinify.setConfig(breinConfig)
    
   }
}

```

### Additional Code Snippets

The following code snippets provides addtional information how to use the *BreinifyApi* library for iOS.

#### BreinExecutor
Instead of using Breinify class methods you could also use the BreinExecutor class in order to invoke activity or lookup calls.

The following example will create a user and a configuration for Breinify and will invoke the activity and lookup calls.

```swift
import BreinifyApi

class BreinifySample {

typealias apiSuccess = (result:BreinResult?) -> Void
typealias apiFailure = (error:NSDictionary?) -> Void

let baseUrl = "https://api.breinify.com"
let validApiKey = "772A-47D7-93A3-4EA9-9D73-85B9-479B-16C6"
let breinUser = BreinUser(email: "fred.firestone@emaill.com")
let breinCategory = "home"
var breinConfig: BreinConfig!

func config() {
        
do {
   breinConfig = try BreinConfig(apiKey: validApiKey, 
                baseUrl: baseUrl, 
        breinEngineType: .ALAMOFIRE)

   // set configuration
   Breinify.setConfig(breinConfig)
   } catch {
     print("Error is: \(error)")
  }
}

 
 // testcase how to use the activity api
 func testLogin() {

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
 breinUser.setLastName("Firestone")

 // invoke activity call
 do {
    let breinifyExecutor = try BreinConfig()
           .setApiKey(validApiKey)
           .setBaseUrl(baseUrl)
           .setRestEngineType(.ALAMOFIRE)
           .build()

     try breinifyExecutor.activity(breinUser,
            activityType: "login",
                category: "home",
             description: "Login-Description",
                    sign: false,
                 success: successBlock,
                 failure: failureBlock)
    } catch {
      print("Error is: \(error)")
    }
}

//
// Test lookup functionality
//
func testLookup() {

let dimensions: [String] = ["firstname", "gender", 
        "age", "agegroup", "digitalfootprint", "images"]
let breinDimension = BreinDimension(dimensionFields: dimensions)

let successBlock: apiSuccess = {
    (result: BreinResult?) -> Void in
    print("Api Success : result is:\n \(result!)")

    if let dataFirstname = result!.get("firstname") {
         print("Firstname is: \(dataFirstname)")
    }

    if let dataGender = result!.get("gender") {
         print("Gender is: \(dataGender)")
    }

    if let dataAge = result!.get("age") {
         print("Age is: \(dataAge)")
    }

    if let dataAgeGroup = result!.get("agegroup") {
         print("AgeGroup is: \(dataAgeGroup)")
    }

    if let dataDigitalFootprinting = result!.get("digitalfootprinting") {
         print("DigitalFootprinting is: \(dataDigitalFootprinting)")
    }

    if let dataImages = result!.get("images") {
         print("DataImages is: \(dataImages)")
    }
}
        
let failureBlock: apiFailure = {(error: NSDictionary?) -> Void in
       print ("Api Failure : error is:\n \(error)")
}

do {
  try Breinify.lookup(breinUser,
           dimension: breinDimension,
                sign: false,
             success: successBlock,
             failure: failureBlock)
   } catch {
     print("Error")
  }
 }
}

```

#### BreinUser
BreinUser provides some methods to add further data. This example shows all possible option. 


````swift
let breinUser = BreinUser(email: "user.anywhere@email.com")

breinUser.setFirstName("User")
         .setLastName("Anywhere")
         .setImei("356938035643809")
         .setDateOfBirth(6, day: 20, year: 1985)
         .setDeviceId("AAAAAAAAA-BBBB-CCCC-1111-222222220000")
         .setSessionId("SID:ANON:w3.org:j6oAOxCWZh/CD723LGeXlf-01:034")

````


#### Exception

The BreinifyAPI provides two exceptions. These are:


1. BreinException
2. BreinInvalidConfigurationException

BreiException will be thrown for instance when an activity call fails. BreinInvalidConfigurationException will only be thrown in case of an invalid BreinConfig. This is the case when a wrong URL is configured.

#### Secret

In conjunction with your API key you can attach a secret. This secret will be part of the REST request from the client to the Breinify backend. 

You have to configre the attached secret with the BreinConfig object and the sign flag for the REST call needs to be set to true.


````swift
// testcase how to use the activity api with secret
func testLoginWithSecret() {
 
  typealias apiSuccess = (result:BreinResult?) -> Void
  typealias apiFailure = (error:NSDictionary?) -> Void

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
  breinUser.setLastName("Firestone")

  // set the secret
  breinConfig.setSecret("h5HRhGRwWlRs9pscyHhQWNc7pxnDOwDZBIAnnhEQbrU=")

  // invoke activity call
  do {
     try Breinify.activity(breinUser,
          activityType: "login",
              category: "home",
           description: "Login-Description",
                  sign: true,  // must be true!!!
               success: successBlock,
               failure: failureBlock)
   } catch {
      print("Error is: \(error)")
   }
}

````




