### Installation using CocoaPods


#### Step 1 - Install CocoaPods

Installing the BreinifyApi via the iOS [CocoaPods](http://cocoapods.org) automates the majority of the installation process.

Please follow this link if you're new to Cocoapods and need some information how to setup the environment.



Before beginning this process please ensure that you are using Ruby version 2.0.0 or greater. Don’t worry, knowledge of Ruby syntax isn’t necessary to install the Library.

Simply run the following command to get started:

```bash
$ sudo gem install cocoapods
```

*Note:* If you are new to Cocopods further details can be found [here](http://guides.cocoapods.org/using/getting-started.html)

#### Step 2 - Create Podfile

To integrate BreinifyApi into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
#platform :ios, '10.0'
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

### Dependencies

BreinifyApi includes the following two libraries:

- Alamofire
- IDZSwiftCommonCrypto
- NetUtils


### License

BreinifyApi is available under the MIT license. This applies also for Alamofire and IDZSwiftCommonCrypto. 
See the LICENSE file for more info.

