### Installation using Carthage
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

### Dependencies

BreinifyApi includes the following two libraries:

- Alamofire
- IDZSwiftCommonCrypto


### License

BreinifyApi is available under the MIT license. This applies also for Alamofire and IDZSwiftCommonCrypto. 
See the LICENSE file for more info.

