//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

open class Breinify {

    typealias apiSuccess = (_ result: BreinResult) -> Void
    typealias apiFailure = (_ error: NSDictionary) -> Void

    ///  contains the current version of the usage library
    static let version: String! = "1.4.4"

    /// contains the configuration
    static var config: BreinConfig?

    ///  contains the activity object
    static var breinActivity: BreinActivity = BreinActivity()

    /// contains the recommendation object
    static var breinRecommendation: BreinRecommendation! = BreinRecommendation()

    /// contains the lookup object
    static var breinLookup: BreinLookup = BreinLookup()

    /// contains the temporaldata object
    static var breinTemporalData: BreinTemporalData = BreinTemporalData()

    /// contains the brein user
    static var breinUser: BreinUser = BreinUser()

    /// contains the brein notification call back handling
    static var notification: BreinNotificationHandler = BreinNotificationHandler()

    public static func setNotificationHandler(_ notification: BreinNotificationHandler) {
        self.notification = notification
    }

    public static func getNotificationHandler() -> BreinNotificationHandler? {
        return self.notification
    }

    /// returns the brein recommendation instance
    public static func getBreinRecommendation() -> BreinRecommendation! {
        return breinRecommendation
    }

    /// returns the brein temporal data instance
    public static func getBreinTemporalData() -> BreinTemporalData! {
        return breinTemporalData
    }

    /// returns breinActivity
    public static func getBreinActivity() -> BreinActivity! {
        return breinActivity
    }

    ///  returns breinLookup
    public static func getBreinLookup() -> BreinLookup! {
        return breinLookup
    }

    /// set and create BreinConfiguration 
    public class func setConfig(_ apiKey: String, secret: String) {
        let breinConfig = BreinConfig(apiKey, secret: secret)
        self.setConfig(breinConfig)
    }

    /// set config to work with
    public class func setConfig(_ breinConfig: BreinConfig!) {
        self.config = breinConfig

        // apply the configuration to all instances
        self.getBreinActivity().setConfig(breinConfig)
        self.getBreinLookup().setConfig(breinConfig)
        self.getBreinRecommendation().setConfig(breinConfig)
        self.breinTemporalData.setConfig(breinConfig)
    }

    /// retrieves the configuration
    public class func getConfig() -> BreinConfig! {
        return config
    }

    /// retrieves the version
    public static func getVersion() -> String! {
        return version
    }

    /// sets the brein user for later usage
    public static func setBreinUser(_ user: BreinUser?) {
        if user != nil {
            self.breinUser = user!
        }
    }

    /// returns the brein user
    public static func getBreinUser() -> BreinUser {
        return self.breinUser
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
        if let breinAct = getBreinActivity() {
            breinAct.setUser(user)

            try activity(breinAct,
                    user: user,
                    activityType: activityType,
                    nil,
                    nil,
                    success,
                    failure)
        }
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
        if let breinAct = getBreinActivity() {
            breinAct.setUser(user)

            try activity(breinAct,
                    user: user,
                    activityType: activityType,
                    category,
                    description,
                    success,
                    failure)
        }
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

        guard activity?.getUser() != nil else {
            throw BreinError.BreinRuntimeError("User not set.")
        }

        guard activity?.getActivityType() != nil else {
            throw BreinError.BreinRuntimeError("ActivityType not set.")
        }

        guard activity?.getBreinEngine() != nil else {
            throw BreinError.BreinRuntimeError("No Rest Engine configured.")
        }

        if activity?.getCategoryType() == nil {
            // check if there is an default category set
            if let defaultCategory = getConfig()?.getCategory() {
                activity?.setCategoryType(defaultCategory)
            }
        }

        activity?.setSuccessBlock(success)
        activity?.setFailureBlock(failure)

        let clonedActivity = activity?.clone()

        // invoke the activity call
        try clonedActivity?.getBreinEngine()?.sendActivity(clonedActivity,
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
        breinActivity.setCategoryType(category)
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

    /// Initiates the shutdown of the engine
    public class func shutdown() {
        if getConfig() != nil {

            // save possible unsend requests
            BreinRequestManager.sharedInstance.shutdown()

            getConfig().shutdownEngine()
        }
    }
}
