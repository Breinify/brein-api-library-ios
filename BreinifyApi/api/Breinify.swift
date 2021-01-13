//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class Breinify: NSObject {

    typealias apiSuccess = (_ result: BreinResult) -> Void
    typealias apiFailure = (_ error: NSDictionary) -> Void

    ///  contains the current version of the usage library
    static let version: String! = "2.0.6"

    /// contains the configuration
    static var config: BreinConfig?

    ///  contains the activity object
    static var breinActivity: BreinActivity = BreinActivity()

    /// contains the recommendation object
    static var breinRecommendation: BreinRecommendation = BreinRecommendation()

    /// contains the lookup object
    static var breinLookup: BreinLookup = BreinLookup()

    /// contains the temporaldata object
    static var breinTemporalData: BreinTemporalData = BreinTemporalData()

    /// contains the brein user
    static var breinUser: BreinUser = BreinUser()

    /// contains the brein notification call back handling
    static var notification: BreinNotificationHandler = BreinNotificationHandler()

    @objc
    public static func setLogging(_ isDebug: Bool) {
        BreinLogger.shared.setDebug(isDebug)
    }

    @objc
    public static func setNotificationHandler(_ notification: BreinNotificationHandler) {
        self.notification = notification
    }

    @objc
    public static func configure(apiKey: String, secret: String) {
        Breinify.didFinishLaunchingWithOptions(apiKey: apiKey, secret: secret)
    }

    @objc
    public static func initialize(apiKey: String, secret: String) {
        Breinify.didFinishLaunchingWithOptions(apiKey: apiKey, secret: secret)
    }

    @objc
    public static func registerPushNotification() {
        /// user notification registration
        BreinifyManager.shared.registerPushNotifications()
    }

    @objc
    public static func isBreinifyNotificationExtensionRequest(_ request: UNNotificationRequest) -> Bool {
        BreinifyManager.shared.isBreinifyNotificationExtensionRequest(request)
    }

    @objc
    public static func didReceiveNotificationExtensionRequest(_ request: UNNotificationRequest,
                                                              bestAttemptContent: UNMutableNotificationContent) {
        BreinifyManager.shared.didReceiveNotificationExtensionRequest(request, bestAttemptContent: bestAttemptContent)
    }

    @objc
    public static func serviceExtensionTimeWillExpire(_ bestAttemptContent: UNMutableNotificationContent) {
        BreinifyManager.shared.serviceExtensionTimeWillExpire(bestAttemptContent)
    }

    @objc
    public static func setUserInfo(firstName: String,
                                   lastName: String,
                                   phone: String,
                                   email: String) {

        let appUser = Breinify.getBreinUser()

        appUser.setFirstName(firstName)
        appUser.setLastName(lastName)
        appUser.setPhone(phone)
        appUser.setEmail(email)

        BreinifyManager.shared.setEmail(email)

        saveUserDefaults()
    }

    @objc
    public static func initWithDeviceTokens(apnsToken: String,
                                            fcmToken: String?,
                                            userInfo: [String: String]?) {

        let appUser = Breinify.getBreinUser()
        appUser.setApnsToken(apnsToken)

        var deviceToken = apnsToken
        if fcmToken != nil {
            appUser.setFcmToken(fcmToken)

            // this is the main token to use
            deviceToken = fcmToken!
        }

        setDeviceToken(deviceToken)

        let firstName: String = userInfo?[BreinUser.UserInfo.firstName] ?? ""
        let lastName: String = userInfo?[BreinUser.UserInfo.firstName] ?? ""
        let phone: String = userInfo?[BreinUser.UserInfo.phoneNumber] ?? ""
        let email: String = userInfo?[BreinUser.UserInfo.email] ?? ""

        Breinify.setUserInfo(firstName: firstName,
                lastName: lastName,
                phone: phone,
                email: email)

        // send identify
        Breinify.sendIdentifyInfo()
    }

    @objc
    public class func setDeviceToken(_ token: String) {

        let breinUser = self.getBreinUser()
        breinUser.setDeviceToken(token)

        BreinifyManager.shared.setDeviceToken(token)
    }

    @objc
    public static func sendIdentifyInfo() {
        BreinLogger.shared.log("Breinify sendIdentify called")
        sendUserNotification(activityType: "identify")
    }

    @objc
    public static func sendLocationInfo() {
        BreinLogger.shared.log("Breinify sendLocation called")
        sendUserNotification(activityType: "sendLoc")
    }

    @objc
    public static func sendActivity(_ breinActivity: BreinActivity) {
        // callback in case of success
        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            if result != nil {
                BreinLogger.shared.log("Breinify api success")
            }
        }

        // callback in case of a failure
        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            if let val = error {
                BreinLogger.shared.log("Breinify api failure - error is: \(String(describing: val))")
            }
        }

        // check if activity has an activity type
        let actType = breinActivity.getActivityType()
        if actType != nil {
            do {
                // set user from instance explicitly
                breinActivity.setUser(getBreinUser())

                try Breinify.activity(breinActivity,
                        successBlock,
                        failureBlock)
            } catch {
                BreinLogger.shared.log("Breinify sendActivity error is: \(error)")
            }
        } else {
            BreinLogger.shared.log("Breinify activity does not contain an activity type")
        }
    }

    @objc
    public static func sendUserNotification(activityType: String) {
        let id = UIDevice.current.identifierForVendor
        let model = UIDevice.current.model
        let name = UIDevice.current.name
        let username = NSUserName()
        let fullUsername = NSFullUserName()

        print("ID is: \(String(describing: id))")
        print("Name is: \(name)")
        print("Model is: \(model)")
        print("Username is: \(username) - Full-Username is: \(fullUsername)")

        // callback in case of success
        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            if result != nil {
                BreinLogger.shared.log("Breinify sendUserNotification - api success")
            }
        }

        // callback in case of a failure
        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            if let val = error {
                BreinLogger.shared.log("Breinify sendUserNotification - api failure - error is: \(String(describing: val))")
            }
        }

        let activity = Breinify.getBreinActivity()
        activity.setActivityType(activityType)

        let breinUser = Breinify.getBreinUser()
        activity.setUser(breinUser)

        // invoke activity call
        do {
            try Breinify.activity(activity,
                    successBlock,
                    failureBlock)
        } catch {
            BreinLogger.shared.log("Breinify sendUserNotification error is: \(error)")
        }
    }

    @objc
    public static func readUserDefaults() {
        let defaults = UserDefaults.standard
        if let email = defaults.string(forKey: "userEmail") {
            Breinify.setEmail(email)
        }

        if let userId = defaults.string(forKey: "userId") {
            Breinify.setUserId(userId)
        }
    }

    @objc
    public static func saveUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.setValue(Breinify.getEmail(), forKey: "userEmail")

        if let curUserId = Breinify.getUserId() {
            Breinify.setUserId(curUserId)
        } else {
            let uuid = UUID().uuidString
            Breinify.setUserId(uuid)
        }

        defaults.setValue(Breinify.getUserId(), forKey: "userId")
        defaults.synchronize()
    }

    public static func getNotificationHandler() -> BreinNotificationHandler? {
        self.notification
    }

    /// returns the brein recommendation instance
    public static func getBreinRecommendation() -> BreinRecommendation {
        breinRecommendation
    }

    /// returns the brein temporal data instance
    public static func getBreinTemporalData() -> BreinTemporalData {
        breinTemporalData
    }

    /// returns breinActivity
    @objc
    public static func getBreinActivity() -> BreinActivity {
        breinActivity
    }

    ///  returns breinLookup
    public static func getBreinLookup() -> BreinLookup {
        breinLookup
    }

    /// set and create BreinConfiguration 
    public static func setConfig(_ apiKey: String, secret: String) {
        let breinConfig = BreinConfig(apiKey, secret: secret)
        self.setConfig(breinConfig)
    }

    /// set config to work with
    public static func setConfig(_ breinConfig: BreinConfig!) {
        self.config = breinConfig

        // apply the configuration to all instances
        self.getBreinActivity().setConfig(breinConfig)
        self.getBreinLookup().setConfig(breinConfig)
        self.getBreinRecommendation().setConfig(breinConfig)
        self.breinTemporalData.setConfig(breinConfig)
    }

    /// retrieves the configuration
    public static func getConfig() -> BreinConfig! {
        config
    }

    /// retrieves the version
    public static func getVersion() -> String! {
        version
    }

    /// sets the brein user for later usage
    @objc
    public static func setBreinUser(_ user: BreinUser?) {
        if user != nil {
            self.breinUser = user!
        }
    }

    /// returns the brein user
    public static func getBreinUser() -> BreinUser {
        self.breinUser
    }

    public static func retrieveDeviceToken(_ deviceToken: Data) -> String {
        BreinifyManager.shared.retrieveDeviceToken(deviceToken)
    }

    /**
       Sends an activity to the engine utilizing the API. The call is done asynchronously as a POST request. It is
       important that a valid API-key is configured prior to using this function.

       This request is asynchronous.

       - parameter user:          A plain object specifying the user information the activity belongs to.
       - parameter activityType:  The type of the activity collected, i.e., one of search, login, logout, addToCart,
                                  removeFromCart, checkOut, selectProduct, or other. if not specified, the default other will
                                  be used
       - parameter categoryType:  The category of the platform/service/products, i.e., one of apparel, home, education, family,
                                  food, health, job, services, or other
       - parameter description:   A string with further information about the activity performed
       - parameter success:       A callback function that is invoked in case of success.
       - parameter failure:       A callback function that is invoked in case of an error.
   */
    public class func activity(_ user: BreinUser!,
                               activityType: String!,
                               _ success: @escaping BreinEngine.apiSuccess = { _ in
                               },
                               _ failure: @escaping BreinEngine.apiFailure = { _ in
                               }) throws {

        // set user in class Breinify ...
        self.setBreinUser(user)

        // ...and in class BreinActivity (will be used later when cloning)
        let breinAct = getBreinActivity()
        breinAct.setUser(user)

        try activity(breinAct,
                user: user,
                activityType: activityType,
                nil,
                nil,
                success,
                failure)
    }

    /**
        Sends an activity to the engine utilizing the API. The call is done asynchronously as a POST request. It is
        important that a valid API-key is configured prior to using this function.

        This request is asynchronous.

        - parameter user:          A plain object specifying the user information the activity belongs to.
        - parameter activityType:  The type of the activity collected, i.e., one of search, login, logout, addToCart,
                                   removeFromCart, checkOut, selectProduct, or other. if not specified, the default other will
                                   be used
        - parameter categoryType:  The category of the platform/service/products, i.e., one of apparel, home, education, family,
                                   food, health, job, services, or other
        - parameter description:   A string with further information about the activity performed
        - parameter success:       A callback function that is invoked in case of success.
        - parameter failure:       A callback function that is invoked in case of an error.
    */
    public class func activity(_ user: BreinUser!,
                               activityType: String!,
                               _ category: String! = nil,
                               _ description: String! = nil,
                               _ success: @escaping BreinEngine.apiSuccess = { _ in
                               },
                               _ failure: @escaping BreinEngine.apiFailure = { _ in
                               }) throws {

        // set user in class Breinify ...
        self.setBreinUser(user)

        // ...and in class BreinActivity (will be used later when cloning)
        let breinAct = getBreinActivity()
        breinAct.setUser(user)

        try activity(breinAct,
                user: user,
                activityType: activityType,
                category,
                description,
                success,
                failure)
    }

    /**
        Sends an activity to the engine utilizing the API. The call is done asynchronously as a POST request. It is
        important that a valid API-key is configured prior to using this function.

        Important: this method will only work if the property breinUser of this class is valid (not nil)

        This request is asynchronous.

        - parameter activityType:  The type of the activity collected, i.e., one of search, login, logout, addToCart,
                                   removeFromCart, checkOut, selectProduct, or other. if not specified, the default other will
                                   be used
        - parameter categoryType:  The category of the platform/service/products, i.e., one of apparel, home, education, family,
                                   food, health, job, services, or other
        - parameter description:   A string with further information about the activity performed
        - parameter success:       A callback function that is invoked in case of success.
        - parameter failure:       A callback function that is invoked in case of an error.
    */
    public class func activity(_ activityType: String!,
                               _ category: String! = nil,
                               _ description: String! = nil,
                               _ success: @escaping BreinEngine.apiSuccess = { _ in
                               },
                               _ failure: @escaping BreinEngine.apiFailure = { _ in
                               }) throws {

        // firstly check if user is valid
        let user = self.getBreinUser()

        try activity(getBreinActivity(),
                user: user,
                activityType: activityType,
                category,
                description,
                success,
                failure)
    }

    /**
        Sends an activity to the engine utilizing the API. The call is done asynchronously as a POST request. It is
        important that a valid API-key is configured prior to using this function.
        
        This request is asynchronous. This method will used the already set objects of class Breinify.

        - parameter success: A callback function that is invoked in case of success.
        - parameter failure: A callback function that is invoked in case of an error.
    */
    public class func activity(_ success: @escaping BreinEngine.apiSuccess = { _ in
    },
                               _ failure: @escaping BreinEngine.apiFailure = { _ in
                               }) throws {

        // use the own instance
        let activity = getBreinActivity()

        guard activity.getUser() != nil else {
            throw BreinError.BreinRuntimeError("User not set.")
        }

        guard activity.getActivityType() != nil else {
            throw BreinError.BreinRuntimeError("ActivityType not set.")
        }

        guard activity.getBreinEngine() != nil else {
            throw BreinError.BreinRuntimeError("No Rest Engine configured.")
        }

        if activity.getCategory() == nil {
            // check if there is an default category set
            if let defaultCategory = getConfig()?.getCategory() {
                activity.setCategory(defaultCategory)
            }
        }

        activity.setSuccessBlock(success)
        activity.setFailureBlock(failure)

        let clonedActivity = activity.clone()

        // invoke the activity call
        try clonedActivity.getBreinEngine()?.sendActivity(clonedActivity,
                success: success,
                failure: failure)
    }

    /**
        Sends an activity to the engine utilizing the API. The call is done asynchronously as a POST request. It is
        important that a valid API-key is configured prior to using this function.

        This request is asynchronous.

        - Parameter breinActivity: Contains a valid object of class BreinActivity that will be used for this request.
        - Parameter success: A callback function that is invoked in case of success.
        - Parameter failure: A callback function that is invoked in case of an error.
    */
    public class func activity(_ breinActivity: BreinActivity!,
                               _ success: @escaping BreinEngine.apiSuccess = { _ in
                               },
                               _ failure: @escaping BreinEngine.apiFailure = { _ in
                               }) throws {

        if breinActivity?.getConfig() == nil {
            // apply previous config
            breinActivity?.setConfig(self.getConfig())
        }

        guard breinActivity?.getBreinEngine() != nil else {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinActivity.setSuccessBlock(success)
        breinActivity.setFailureBlock(failure)

        // clone breinActivity
        let clonedBreinActivity = breinActivity.clone()

        try clonedBreinActivity.getBreinEngine()?.sendActivity(clonedBreinActivity,
                success: success,
                failure: failure)
    }


    /**
        Sends an activity to the engine utilizing the API. The call is done asynchronously as a POST request. It is
        important that a valid API-key is configured prior to using this function.

        This request is asynchronous.

        - Parameter breinActivity: Contains a valid object of class BreinActivity that will be used for this request.
        - Parameter user:          A plain object specifying the user information the activity belongs to.
        - Parameter activityType:  The type of the activity collected, i.e., one of search, login, logout, addToCart,
                                   removeFromCart, checkOut, selectProduct, or other. if not specified, the default other will
                                   be used
        - Parameter categoryType:  The category of the platform/service/products, i.e., one of apparel, home, education, family,
                                   food, health, job, services, or other
        - Parameter description:   A string with further information about the activity performed
        - Parameter success:       A callback function that is invoked in case of success.
        - Parameter failure:       A callback function that is invoked in case of an error.
    */
    public class func activity(_ breinActivity: BreinActivity!,
                               user: BreinUser!,
                               activityType: String!,
                               _ category: String! = nil,
                               _ description: String! = nil,
                               _ success: @escaping BreinEngine.apiSuccess = { _ in
                               },
                               _ failure: @escaping BreinEngine.apiFailure = { _ in
                               }) throws {

        if breinActivity?.getConfig() == nil {
            // apply previous config
            breinActivity?.setConfig(self.getConfig())
        }

        guard breinActivity?.getBreinEngine() != nil else {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinActivity.setUser(user)
        breinActivity.setActivityType(activityType)
        breinActivity.setCategory(category)
        breinActivity.setDescription(description)
        breinActivity.setSuccessBlock(success)
        breinActivity.setFailureBlock(failure)

        // clone breinActivity
        let clonedBreinActivity = breinActivity.clone()

        try clonedBreinActivity.getBreinEngine()?.sendActivity(clonedBreinActivity,
                success: success,
                failure: failure)
    }

    /**
      Sends a recommendation request to the engine utilizing the API. The call is done synchronously as a POST request. It is
      important that a valid API-key is configured prior to using this function.

        - parameter breinRecommendation: Contains the brein recommendation object
        - parameter success:    A callback function that is invoked in case of success.
        - parameter failure:    A callback function that is invoked in case of an error.

        - returns:  BreinResult object
     */
    public class func recommendation(_ aBreinRecommendation: BreinRecommendation!,
                                     _ success: @escaping BreinEngine.apiSuccess = { _ in
                                     },
                                     _ failure: @escaping BreinEngine.apiFailure = { _ in
                                     }) throws {

        if aBreinRecommendation == nil {
            throw BreinError.BreinRuntimeError("BreinRecommendation is nil");
        }

        // apply the current configuration
        aBreinRecommendation.setConfig(self.getConfig())

        // clone given instance
        let clonedBreinRecommendation = aBreinRecommendation.clone()

        clonedBreinRecommendation.setSuccessBlock(success)
        clonedBreinRecommendation.setFailureBlock(failure)

        return try clonedBreinRecommendation.getBreinEngine()!.invokeRecommendation(clonedBreinRecommendation,
                success: success,
                failure: failure)
    }

    /**
       Sends a temporalData to the engine utilizing the API. The call is done synchronously as a POST request. It is
       important that a valid API-key is configured prior to using this function.

       Furthermore it uses the internal instance of BreinTemporalData.

         - parameter user:    A plain object specifying information about the user to retrieve data for.
         - parameter success: A callback function that is invoked in case of success.
         - parameter failure: A callback function that is invoked in case of an error.

         - returns: result from the Breinify engine
    */
    public class func temporalData(_ user: BreinUser!,
                                   _ success: @escaping BreinEngine.apiSuccess = { _ in
                                   },
                                   _ failure: @escaping BreinEngine.apiFailure = { _ in
                                   }) throws {

        self.breinTemporalData.setUser(user)

        return try temporalData(breinTemporalData,
                success,
                failure)
    }

    /**
       Sends a temporalData to the engine utilizing the API. The call is done synchronously as a POST request. It is
       important that a valid API-key is configured prior to using this function.

       Furthermore it uses the internal instance of BreinTemporalData.

       - Parameter success: A callback function that is invoked in case of success.
       - Parameter failure: A callback function that is invoked in case of an error.

       - returns: result from the Breinify engine
    */
    public class func temporalData(_ success: @escaping BreinEngine.apiSuccess = { _ in
    },
                                   _ failure: @escaping BreinEngine.apiFailure = { _ in
                                   }) throws {

        // clone breinTemporalData
        let clonedBreinTemporalData = self.getBreinTemporalData().clone()

        clonedBreinTemporalData.setSuccessBlock(success)
        clonedBreinTemporalData.setFailureBlock(failure)

        // apply the current configuration
        clonedBreinTemporalData.setConfig(self.getBreinTemporalData().getConfig())

        return try breinTemporalData.getBreinEngine()!.performTemporalDataRequest(breinTemporalData,
                success: success,
                failure: failure)
    }

    /**
       Sends a temporalData to the engine utilizing the API. The call is done synchronously as a POST request. It is
       important that a valid API-key is configured prior to using this function.

       Furthermore it uses the internal instance of BreinTemporalData.

       - parameter ipAddress: Contains an ipAddress to resolve.
       - Parameter success:   A callback function that is invoked in case of success.
       - Parameter failure:   A callback function that is invoked in case of an error.

       - returns: result from the Breinify engine
    */
    public class func temporalData(_ ipAddress: String,
                                   _ success: @escaping BreinEngine.apiSuccess = { _ in
                                   },
                                   _ failure: @escaping BreinEngine.apiFailure = { _ in
                                   }) throws {

        // set ipAddress
        _ = self.getBreinTemporalData().setLookUpIpAddress(ipAddress)

        // clone breinTemporalData
        let clonedBreinTemporalData = self.getBreinTemporalData().clone()

        clonedBreinTemporalData.setSuccessBlock(success)
        clonedBreinTemporalData.setFailureBlock(failure)

        // apply the current configuration
        clonedBreinTemporalData.setConfig(self.getBreinTemporalData().getConfig())

        return try breinTemporalData.getBreinEngine()!.performTemporalDataRequest(breinTemporalData,
                success: success,
                failure: failure)
    }

    /**
        Sends a temporalData to the engine utilizing the API. The call is done synchronously as a POST request. It is
        important that a valid API-key is configured prior to using this function.

        Furthermore it uses the internal instance of BreinTemporalData.

        - parameter breinTemporalData: Contains a breinTemporalData object.
        - Parameter success:           A callback function that is invoked in case of success.
        - Parameter failure:           A callback function that is invoked in case of an error.

        - returns: result from the Breinify engine
     */
    public class func temporalData(_ breinTemporalData: BreinTemporalData!,
                                   _ success: @escaping BreinEngine.apiSuccess = { _ in
                                   },
                                   _ failure: @escaping BreinEngine.apiFailure = { _ in
                                   }) throws {

        if breinTemporalData?.getBreinEngine() == nil {
            // apply the Breinify config
            breinTemporalData.setConfig(self.getBreinTemporalData().getConfig())
            guard breinTemporalData?.getBreinEngine() != nil else {
                throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
            }
        }

        // clone breinTemporalData
        let clonedBreinTemporalData = self.getBreinTemporalData().clone()

        clonedBreinTemporalData.setSuccessBlock(success)
        clonedBreinTemporalData.setFailureBlock(failure)

        // apply the current configuration
        clonedBreinTemporalData.setConfig(self.getBreinTemporalData().getConfig())

        return try breinTemporalData.getBreinEngine()!.performTemporalDataRequest(breinTemporalData,
                success: success,
                failure: failure)
    }

    /**
      Retrieves a lookup result from the engine. The function needs a valid API-key to be configured to succeed.
      This request is synchronous.

        - parameter user:       A plain object specifying information about the user to retrieve data for.
        - parameter dimension:  An object (with an array) containing the names of the dimensions to lookup.
        - Parameter success:    A callback function that is invoked in case of success.
        - Parameter failure:    A callback function that is invoked in case of an error.

        - returns response from request wrapped in an object called BreinResponse
    */
    public class func lookup(_ user: BreinUser!,
                             dimension: BreinDimension!,
                             _ success: @escaping BreinEngine.apiSuccess = { _ in
                             },
                             _ failure: @escaping BreinEngine.apiFailure = { _ in
                             }) throws {

        return try lookup(breinLookup,
                user: user,
                dimension: dimension,
                success,
                failure)
    }

    /**
       Retrieves a lookup result from the engine. The function needs a valid API-key to be configured to succeed.
       This request is synchronous.

         - parameter breinLookup: An instance of BreinLookup.
         - parameter user:        A plain object specifying information about the user to retrieve data for.
         - parameter dimension:   An object (with an array) containing the names of the dimensions to lookup.
         - Parameter success:     A callback function that is invoked in case of success.
         - Parameter failure:     A callback function that is invoked in case of an error.

         - returns response from request wrapped in an object called BreinResponse
     */
    public class func lookup(_ breinLookup: BreinLookup!,
                             user: BreinUser!,
                             dimension: BreinDimension!,
                             _ success: @escaping BreinEngine.apiSuccess = { _ in
                             },
                             _ failure: @escaping BreinEngine.apiFailure = { _ in
                             }) throws {

        guard breinLookup?.getBreinEngine() != nil else {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinLookup.setUser(user)
        breinLookup.setBreinDimension(dimension)

        return try breinLookup.getBreinEngine()!.performLookUp(breinLookup,
                success: success,
                failure: failure)
    }

    // todo
    //   - check if willTerminate should be used instead

    /// Initiates the shutdown of the engine
    @objc
    public class func shutdown() {
        if getConfig() != nil {

            // save possible unsent requests
            BreinRequestManager.shared.shutdown()

            getConfig().shutdownEngine()
        }
    }
}
