
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

Click on the selected option `Apple Push Notification Authentication Key (Sandbox & Production). This will generate a so call P8 certificate.

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
