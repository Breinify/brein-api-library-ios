#BreinApi

<p align="center">
  <img src="https://raw.githubusercontent.com/Breinify/brein-api-library-ios/documentation/img/logo.png" alt="Breinify API iOS Library" width="250">
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

## Author

Marco, marco.recchioni@breinify.com

## License

BreinApi is available under the MIT license. See the LICENSE file for more info.


## Usage

#### Step 1: Request API-key

In order to use the library you need a valid API-key, which you can get for free at [https://www.breinify.com](https://www.breinify.com). In this example, we assume you have the following api-key:

**772A-47D7-93A3-4EA9-9D73-85B9-479B-16C6**


### Step 2: Configure the Library
