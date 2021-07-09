<p align="center">
  <img src="https://www.breinify.com/img/Breinify_logo.png" alt="Breinify: Leading Temporal AI Engine" width="250">
</p>


# Breinify's API Library - Objective-C

[![Version](https://img.shields.io/cocoapods/v/BreinifyApi.svg?style=flat)](http://cocoapods.org/pods/BreinifyApi)
[![License](https://img.shields.io/cocoapods/l/BreinifyApi.svg?style=flat)](http://cocoapods.org/pods/BreinifyApi)
[![Platform](https://img.shields.io/cocoapods/p/BreinifyApi.svg?style=flat)](http://cocoapods.org/pods/BreinifyApi)

<sup>Features: **Temporal Data**, **(Reverse) Geocoding**, **Events**, **Weather**, **Holidays**, **Analytics**</sup>


This library utilizes [Breinify's API](https://www.breinify.com) to provide tasks like `PushNotifications`, `geocoding`, `reverse geocoding`, `weather and events look up`, `holidays determination` through the API's endpoints, i.e., `/activity` and `/temporaldata`. Each endpoint provides different features, which are explained in the following paragraphs. In addition, this documentation gives detailed examples for each of the features available for the different endpoints.

**PushNotifications**:
The goal of utilizing Breinify’s Time-Driven push notifications is to send highly dynamic & individualized engagements to single app-users (customer) rather than the everyone in a traditional segments. These push notifications are triggered due to user behavior and a combination of hyper-relevant weather, events, and holidays.

**Activity Endpoint**: The endpoint is used to understand the usage-patterns and the behavior of a user using, e.g., an application, a mobile app, or a web-browser. The endpoint offers analytics and insights through Breinify's dashboard.

**TemporalData Endpoint**: The endpoint offers features to resolve temporal information like a timestamp, a location (latitude and longitude or free-text), or an IP-address, to temporal information (e.g., timezone, epoch, formatted dates, day-name),  holidays at the specified time and location, city, zip-code, neighborhood, country, or county of the location, events at the specified time and location (e.g., description, size, type), weather at the specified time and location (e.g., description, temperature).


## Getting Started

### Retrieving an API-Key

First of all, you need a valid API-key, which you can get for free at [https://www.breinify.com](https://www.breinify.com). In the examples, we assume you have the following api-key:

**938D-3120-64DD-413F-BB55-6573-90CE-473A**


It is recommended to use signed messages when utilizing the iOS library. A signed messages ensures, that the request is authorized. To activate signed message ensure that Verification Signature is enabled for your key (see Breinify's API Docs for further information). In this documentation we assume that the following secret is attached to the API key and used to sign a message.

**utakxp7sm6weo5gvk7cytw==**

### Requirements

- iOS 9.0+
- Xcode 12.1
- AppCode 2020.2+
- Swift 5.0


### Installation

Please follow this [link](Documentation/cocoapods_instructions.md) if you're new to Cocoapods and need some information how to setup the environment.

#### Including the Library

Add in your pod file:

```
...
pod 'BreinifyApi', '~> 2.0.2'
...

```

#### Consideration of  Firebase Libraries

In case of Firebase Message support the following Firebase Libraries needs to be included as well:

```
...
pod 'Firebase/Core'
pod 'Firebase/Messaging'
...
```

#### Permissions

The Breinify SDK needs some permission in order to retrieve the appropriate information. In your `info.plist` file you have to add the following permissions:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>api.breinify.com</key>
        <dict>
            <!--Include to allow subdomains-->
            <key>NSIncludesSubdomains</key>
            <true/>
            <!--Include to allow HTTP requests-->
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <!--Include to specify minimum TLS version-->
            <key>NSTemporaryExceptionMinimumTLSVersion</key>
            <string>TLSv1.1</string>
        </dict>
        <key>ip-api.com</key>
        <dict>
            <!--Include to allow subdomains-->
            <key>NSIncludesSubdomains</key>
            <true/>
            <!--Include to allow HTTP requests-->
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <!--Include to specify minimum TLS version-->
            <key>NSTemporaryExceptionMinimumTLSVersion</key>
            <string>TLSv1.1</string>
        </dict>
    </dict>
</dict>
```




### Configuring the Library with Firebase Cloud Message Service

In case the Push Notifications will come from Firebase add the following statements in your `AppDelegate.m` file:

```objective-c
#import "Firebase.h"
#import "BreinifyApi-Swift.h"
 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    [FIRApp configure];
 
    NSString *validApiKey = @"D60F-8A6B-D367-416D-ADD5-C3F3-0DAE-E455";
    NSString *validSecret = @"73cchgmlooisxiqchjd1rq==";
    [Breinify initializeWithApiKey:validApiKey secret:validSecret];
    return YES;
}
 
 - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
 
    [[FIRMessaging messaging] tokenWithCompletion:^(NSString *fcmToken, NSError *error) {
        if (error != nil) {
            NSLog(@"Error getting FCM registration token: %@", error);
        } else {
            NSLog(@"FCM registration token: %@", fcmToken);
 
            NSDictionary *userInfo = @{@"firstName": @"Elvis",
                    @"lastName": @"Presley",
                    @"phone": @"0123456789",
                    @"email": @"elvis.presly@mail.com"};
 
            const char *data = [deviceToken bytes];
            NSMutableString *apnsToken = [NSMutableString string];
 
            for (NSUInteger i = 0; i < [deviceToken length]; i++) {
                [apnsToken appendFormat:@"%02.2hhX", data[i]];
            }
 
            [Breinify initWithDeviceTokensWithApnsToken:apnsToken fcmToken:fcmToken userInfo:userInfo];
        }
    }];
}

```

Whenever the library is used, it needs to be configured, i.e., the configuration defines which API key and which secret (if signed messages are enabled, i.e., `Verification Signature` is checked) to use.

### Clean-Up after Usage

Whenever the library is not used anymore, it is recommended to clean-up and release the resources held. To do so, the `Breinify.shutdown()`
method is used. A typical framework may look like that:

```objective-c
- (void)applicationWillTerminate:(NSNotification *)notification {
    [Breinify shutdown];
}
```



## Activity: Selected Usage Examples

The `/activity` endpoint is used to track the usage of, e.g., an application, an app, or a web-site. There are several libraries available to be used for different system (e.g.,  [Node.js](https://github.com/Breinify/brein-api-library-node), [Android](https://github.com/Breinify/brein-api-library-android), [Java](https://github.com/Breinify/brein-api-library-java), [JavaScript](https://github.com/Breinify/brein-api-library-javascript-browser), [Ruby](https://github.com/Breinify/brein-api-library-ruby), [PHP](https://github.com/Breinify/brein-api-library-php), [Python](https://github.com/Breinify/brein-api-library-python)).

### Sending Activity Data (Login)

The example shows, how to send a login activity, reading the data from an request. In general, activities are added to the interesting measure points within your applications process (e.g., `login`, `addToCart`, `readArticle`). The endpoint offers analytics and insights through Breinify's dashboard.

```objective-c
BreinActivity *breinActivity = [Breinify getBreinActivity];
 
[breinActivity setActivityType:@"login"];
[breinActivity setCategory:@"home"];
 
[Breinify sendActivity:breinActivity];
```



### Sending Activity Data (CheckOut)

The example shows, how to send a checkOut activity, reading the data from an request. In general, activities are added to the interesting measure points within your applications process (e.g., `login`, `addToCart`, `readArticle`). The endpoint offers analytics and insights through Breinify's dashboard.

```objective-c
NSArray *productPrices = @[@10000];
NSArray *productIds = @[@"packageOption"];
NSArray *productQuantities = @[@1];
 
NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
[dict setValue:productPriceValue forKey:@"productPrices"];
[dict setValue:productIds forKey:@"productIds"];
[dict setValue:productQuantities forKey:@"productQuantities"];
[dict setValue:@10000 forKey:@"transactionPriceTotal"];
[dict setValue:@10000 forKey:@"transactionTotal"];
 
BreinActivity *breinActivity = [Breinify getBreinActivity];
[breinActivity setActivityType:@"checkOut"];
[breinActivity setTagsDic:dict];
[Breinify sendActivity:breinActivity];
```



### Further links
To understand all the capabilities of Breinify's APIs, have a look at:

* [Breinify's Website](https://www.breinify.com).

