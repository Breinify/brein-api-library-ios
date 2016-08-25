#BreinApi

<p align="center">
 <img src="https://raw.githubusercontent.com/Breinify/brein-api-library-ios/master/logo.png" alt="Breinify API Java Library" width="250">
</p>

<p align="center">
Breinify's DigitalDNA API puts dynamic behavior-based, people-driven data right at your fingertips.
</p>


[![Version](https://img.shields.io/cocoapods/v/BreinApi.svg?style=flat)](http://cocoapods.org/pods/BreinApi)
[![License](https://img.shields.io/cocoapods/l/BreinApi.svg?style=flat)](http://cocoapods.org/pods/BreinApi)
[![Platform](https://img.shields.io/cocoapods/p/BreinApi.svg?style=flat)](http://cocoapods.org/pods/BreinApi)


### Step By Step Introduction

#### What is Breinify's DigitialDNA

Breinify's DigitalDNA API puts dynamic behavior-based, people-driven data right at your fingertips. We believe that in many situations, a critical component of a great user experience is personalization. With all the data available on the web it should be easy to provide a unique experience to every visitor, and yet, sometimes you may find yourself wondering why it is so difficult.

Thanks to **Breinify's DigitalDNA** you are now able to adapt your online presence to your visitors needs and **provide a unique experience**. Let's walk step-by-step through a simple example.


To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0+ 
- Xcode 7.3+
- AppCode 2016


## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate BreinApi into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'BreinApi'
end
```

Then, run the following command:

```bash
$ pod install
```

The BreinApi Dependency will be added and a XCode workspace will be generated. This workspace file bundles your original Xcode project, the BreinApi library, and its dependencies.

So from now on, you have to use <ProjectName>.xcworkspace instead of <ProjectName>.xcodeproj.

## Dependencies

BreinApi includes the following two libraries:

- Alamofire
- IDZSwiftCommonCrypto

## License

BreinApi is available under the MIT license. See the LICENSE file for more info.


## Usage

#### Step 1: Request API-key

In order to use the library you need a valid API-key, which you can get for free at [https://www.breinify.com](https://www.breinify.com). In this example, we assume you have the following api-key:

**772A-47D7-93A3-4EA9-9D73-85B9-479B-16C6**


### Step 2: Include the BreinApi module

```Swift
import BreinApi

```


### Step 3: Configure the Libary



The Breinify class needs to be configured with an instance of BreinConfig containing a valid API-key, the URL of the Breinify Backend and the Rest-Engine. Currently only Alamofire is supported.  

This would look like this:

```Swift
// this has to be a valid api-key
let validApiKey = "772A-47D7-93A3-4EA9-9D73-85B9-479B-16C6"

// this is the URL of the Breinify service
let baseUrl = "https://api.breinify.com"

// create the configuration object
let breinConfig = try BreinConfig(apiKey: validApiKey,
              baseUrl: baseUrl, 
      breinEngineType: .ALAMOFIRE)
            
// set configuration
Breinify.setConfig(breinConfig)
```

#### Step 3: Start using the library

##### Placing activity triggers

The engine powering the DigitalDNA API provides two endpoints. The first endpoint is used to inform the engine about the activities performed by visitors of your site. The activities are used to understand the user's current interest and infer the intent. It becomes more and more accurate across different users and verticals as more activities are collected. It should be noted, that any personal information is not stored within the engine, thus each individual's privacy is well protected. The engine understands several different activities performed by a user, e.g., landing, login, search, item selection, or logout.

The engine is informed of an activity by executing *Breinify.activity(...)*. 

```Swift
// create a user you are interested in with his email (mandatory field)
let breinUser = BreinUser(email: "fred.firestone@email.com")

typealias apiSuccess = (result:BreinResult?) -> Void
typealias apiFailure = (error:NSDictionary?) -> Void

// callback in case of success
let successBlock: apiSuccess = {(result: BreinResult?) -> Void in
    print ("Api Success : result is:\n \(result!)")
}

// callback in case of a failure
let failureBlock: apiFailure = {(error: NSDictionary?) -> Void in
    print ("Api Failure: error is:\n \(error)")

}

// set additional user information (optional)
breinUser.setFirstName("Fred")
breinUser.setLastName("Firestone")

// invoke activity call
do {
   try Breinify.activity(breinUser,
          activityType: .LOGIN,
              category: .HOME,
           description: "Login-Description",
                  sign: false,
               success: successBlock,
               failure: failureBlock)
} catch {
   print("Error is: \(error)")
}

```

That's it! The call will be run asynchronously in the background and depending of the result the successBlock or failureBlock callback will be invoked.


##### Placing look-up triggers

Look-ups are used to retrieve dedicated information for a given user. This code snippet assumes that the typealias and further objects from above are in the same scope. 

```swift
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

```


## Full working sample 

Let’s navigate back to Xcode and inside the IDE, go to ViewController.swift. The code should look like this:

```swift
import UIKit
import BreinApi

class ViewController: UIViewController {

    typealias apiSuccess = (result:BreinResult?) -> Void
    typealias apiFailure = (error:NSDictionary?) -> Void

    let baseUrl = "https://api.breinify.com"
    
    let validApiKey = "772A-47D7-93A3-4EA9-9D73-85B9-479B-16C6"
    let breinCategory: BreinCategoryType = .HOME
    let breinUser = BreinUser(email: "fred.firestone@gmail.com")

    var breinConfig: BreinConfig?
    var manager: BreinLocationManager?
    var output = ""

    @IBOutlet weak var resultView: UITextView!
    
    @IBAction func lookUpInvoked(sender: AnyObject) {

        doLookup()
    }

    @IBAction func activityInvoked(sender: AnyObject) {

        doActivity()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        do {

            breinConfig = try BreinConfig(apiKey: validApiKey, 
                  baseUrl: baseUrl, 
                  breinEngineType: .ALAMOFIRE)
            
            // set configuration
            Breinify.setConfig(breinConfig)

        } catch {
            print("Error")
        }

    }

 
    func doLookup() {

        let dimensions: [String] = ["firstname", "gender", 
        "age", "agegroup", "digitalfootprint", "images"]
        
        let breinDimension = BreinDimension(dimensionFields: dimensions)

        let successBlock: apiSuccess = {(result: BreinResult?) -> Void in
            print ("Api Success!")
            
            
            if let dataFirstname = result!.get("firstname") {
                print ("Firstname is: \(dataFirstname)")
                self.output = self.output + "Firstname is: \(dataFirstname)"
            }

            if let dataGender = result!.get("gender") {
                print ("Gender is: \(dataGender)")
                self.output = self.output + "Gender is: \(dataGender)"            }

            if let dataAge = result!.get("age") {
                print ("Age is: \(dataAge)")
                self.output = self.output + "Age is: \(dataAge)"
            }

            if let dataAgeGroup = result!.get("agegroup") {
                print ("AgeGroup is: \(dataAgeGroup)")
                self.output = self.output + "AgeGroup is: \(dataAgeGroup)"
            }

            if let dataDigitalFootprinting = result!.get("digitalfootprinting") {
                print ("DigitalFootprinting is: \(dataDigitalFootprinting)")
                self.output = self.output + "DigitalFootprinting is: \(dataDigitalFootprinting)"
            }

            if let dataImages = result!.get("images") {
                print ("DataImages is: \(dataImages)")
                self.output = self.output + "DataImages is: \(dataImages)"
            }
            
            print("output is: \(self.output)")
            self.resultView.text = self.output
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


    func doActivity() {

        let successBlock: apiSuccess = {(result: BreinResult?) -> Void in
            print ("Api Success : result is:\n \(result!)")
            self.resultView.text = "Succes!"

        }
        let failureBlock: apiFailure = {(error: NSDictionary?) -> Void in
            print ("Api Failure : error is:\n \(error)")
            self.resultView.text = "Failure: \(error)"
        }

        // set additional user information
        breinUser.setFirstName("Fred")
        breinUser.setLastName("Firestone")

        // invoke activity call
        do {
            try Breinify.activity(breinUser,
                activityType: .LOGIN,
                    category: .HOME,
                 description: "Login-Description",
                        sign: false,
                     success: successBlock,
                     failure: failureBlock)
        } catch {
            print("Error is: \(error)")
        }

    }
}
```

