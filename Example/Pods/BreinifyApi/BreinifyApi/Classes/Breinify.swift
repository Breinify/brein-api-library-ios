//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

public class Breinify {

    ///  contains the current version of the usage library
    static let version: String! = "0.4.4"

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
    static var breinUser: BreinUser?

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

    /// set config to work with
    public class func setConfig(breinConfig: BreinConfig!) {
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
    public static func setBreinUser(user: BreinUser?) {
        if user != nil {
            self.breinUser = user
        }
    }

    /// returns the brein user
    public static func getBreinUser() -> BreinUser? {
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
        - parameter successBlock : A callback function that is invoked in case of success.
        - parameter failureBlock : A callback function that is invoked in case of an error.
    */
    public class func activity(user: BreinUser!,
                               activityType: String!,
                               category: String!,
                               description: String!,
                               success successBlock: BreinEngine.apiSuccess,
                               failure failureBlock: BreinEngine.apiFailure) throws {


        // clone breinActivty
        let clonedBreinActivity = self.getBreinActivity().clone()

        clonedBreinActivity.setSuccessBlock(successBlock)
        clonedBreinActivity.setFailureBlock(failureBlock)

        try activity(clonedBreinActivity,
                user: user,
                activityType: activityType,
                category: category,
                description: description,
                success: successBlock,
                failure: failureBlock)
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
        - parameter successBlock : A callback function that is invoked in case of success.
        - parameter failureBlock : A callback function that is invoked in case of an error.
    */
    public class func activity(activityType: String!,
                               category: String!,
                               description: String!,
                               success successBlock: BreinEngine.apiSuccess,
                               failure failureBlock: BreinEngine.apiFailure) throws {

        // firstly check if user is valid
        guard let user = self.getBreinUser() else {
            throw BreinError.BreinRuntimeError("User not set.")
        }

        try activity(getBreinActivity(),
                user: user,
                activityType: activityType,
                category: category,
                description: description,
                success: successBlock,
                failure: failureBlock)
    }

    /**
        Sends an activity to the engine utilizing the API. The call is done asynchronously as a POST request. It is
        important that a valid API-key is configured prior to using this function.
        This request is asynchronous. This method will used the already set objects of class Breinify.

        - parameter successBlock : A callback function that is invoked in case of success.
        - parameter failureBlock : A callback function that is invoked in case of an error.
    */
    public class func activity(success successBlock: BreinEngine.apiSuccess,
                               failure failureBlock: BreinEngine.apiFailure) throws {

        // use the own instance
        let activity = getBreinActivity()

        guard activity.getBreinUser() != nil else {
            throw BreinError.BreinRuntimeError("User not set.")
        }

        guard activity.getBreinActivityType() != nil else {
            throw BreinError.BreinRuntimeError("ActivityType not set.")
        }

        guard activity.getBreinEngine() != nil else {
            throw BreinError.BreinRuntimeError("No Rest Engine configured.")
        }

        if activity.getBreinCategoryType() == nil {
            // check if there is an default category set
            if let defaultCategory = getConfig()?.getCategory() {
                activity.setBreinCategoryType(defaultCategory)
            }
        }

        activity.setSuccessBlock(successBlock)
        activity.setFailureBlock(failureBlock)

        let clonedActivity = activity.clone()

        // invoke the activity call
        try clonedActivity.getBreinEngine()?.sendActivity(clonedActivity,
                success: successBlock,
                failure: failureBlock)
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
        - Parameter successBlock : A callback function that is invoked in case of success.
        - Parameter failureBlock : A callback function that is invoked in case of an error.
    */
    public class func activity(breinActivity: BreinActivity!,
                               user: BreinUser!,
                               activityType: String!,
                               category: String!,
                               description: String!,
                               success successBlock: BreinEngine.apiSuccess,
                               failure failureBlock: BreinEngine.apiFailure) throws {

        guard breinActivity?.getBreinEngine() != nil else {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinActivity.setBreinUser(user)
        breinActivity.setBreinActivityType(activityType)
        breinActivity.setBreinCategoryType(category)
        breinActivity.setDescription(description)
        breinActivity.setSuccessBlock(successBlock)
        breinActivity.setFailureBlock(failureBlock)

        // clone breinActivty
        let clonedBreinActivity = breinActivity.clone()

        try clonedBreinActivity.getBreinEngine()?.sendActivity(clonedBreinActivity,
                success: successBlock,
                failure: failureBlock)
    }

    /**
      Sends a recommendation request to the engine utilizing the API. The call is done synchronously as a POST request. It is
      important that a valid API-key is configured prior to using this function.

        - parameter breinRecommendation: contains the brein recommendation object
        - parameter successBlock : A callback function that is invoked in case of success.
        - parameter failureBlock : A callback function that is invoked in case of an error.

        - returns:  BreinResult object
     */
    public class func recommendation(aBreinRecommendation: BreinRecommendation!,
                                     success successBlock: BreinEngine.apiSuccess,
                                     failure failureBlock: BreinEngine.apiFailure) throws {

        if aBreinRecommendation == nil {
            throw BreinError.BreinRuntimeError("BreinRecommendation is nil");
        }
        
        // clone breinRecommendation
        let clonedBreinRecommendation = self.getBreinRecommendation().clone()

        clonedBreinRecommendation.setSuccessBlock(successBlock)
        clonedBreinRecommendation.setFailureBlock(failureBlock)

        // apply the current configuration
        clonedBreinRecommendation.setConfig(self.getBreinRecommendation().getConfig());

        return try clonedBreinRecommendation.getBreinEngine()!.invokeRecommendation(clonedBreinRecommendation,
                success: successBlock,
                failure: failureBlock)
    }

    /**
       Sends a temporalData to the engine utilizing the API. The call is done synchronously as a POST request. It is
       important that a valid API-key is configured prior to using this function.

       Furthermore it uses the internal instance of BreinTemporalData.

         - parameter user: a plain object specifying information about the user to retrieve data for.
         - parameter successBlock : A callback function that is invoked in case of success.
         - parameter failureBlock : A callback function that is invoked in case of an error.

         - returns: result from the Breinify engine
    */
    public class func temporalData(user: BreinUser!,
                                   success successBlock: BreinEngine.apiSuccess,
                                   failure failureBlock: BreinEngine.apiFailure) throws {

        return try temporalData(breinTemporalData,
                user: user,
                success: successBlock,
                failure: failureBlock)
    }

    /**
        Sends a temporalData to the engine utilizing the API. The call is done synchronously as a POST request. It is
        important that a valid API-key is configured prior to using this function.

        Furthermore it uses the internal instance of BreinTemporalData.

        - parameter breinTemporalData: contains a breinTemporalData object.
        - parameter user: a plain object specifying information about the user to retrieve data for.
        - Parameter successBlock : A callback function that is invoked in case of success.
        - Parameter failureBlock : A callback function that is invoked in case of an error.

        - returns: result from the Breinify engine
     */
    public class func temporalData(breinTemporalData: BreinTemporalData!,
                                   user: BreinUser!,
                                   success successBlock: BreinEngine.apiSuccess,
                                   failure failureBlock: BreinEngine.apiFailure) throws {

        guard breinTemporalData?.getBreinEngine() != nil else {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinTemporalData.setBreinUser(user)


        // clone breinTemporalData
        let clonedBreinTemporalData = self.getBreinTemporalData().clone()

        clonedBreinTemporalData.setSuccessBlock(successBlock)
        clonedBreinTemporalData.setFailureBlock(failureBlock)

        // apply the current configuration
        clonedBreinTemporalData.setConfig(self.getBreinTemporalData().getConfig());


        return try breinTemporalData.getBreinEngine()!.performTemporalDataRequest(breinTemporalData,
                success: successBlock,
                failure: failureBlock)
    }

    /**
      Retrieves a lookup result from the engine. The function needs a valid API-key to be configured to succeed.
      This request is synchronous.

        - parameter user:      a plain object specifying information about the user to retrieve data for.
        - parameter dimension: an object (with an array) containing the names of the dimensions to lookup.
        - Parameter successBlock : A callback function that is invoked in case of success.
        - Parameter failureBlock : A callback function that is invoked in case of an error.

        - returns response from request wrapped in an object called BreinResponse
    */
    public class func lookup(user: BreinUser!,
                             dimension: BreinDimension!,
                             success successBlock: BreinEngine.apiSuccess,
                             failure failureBlock: BreinEngine.apiFailure) throws {

        return try lookup(breinLookup,
                user: user,
                dimension: dimension,
                success: successBlock,
                failure: failureBlock)
    }

    /**
       Retrieves a lookup result from the engine. The function needs a valid API-key to be configured to succeed.
       This request is synchronous.

         - parameter breinLookup:     an instance of BreinLookup.
         - parameter user:      a plain object specifying information about the user to retrieve data for.
         - parameter dimension: an object (with an array) containing the names of the dimensions to lookup.
         - Parameter successBlock : A callback function that is invoked in case of success.
         - Parameter failureBlock : A callback function that is invoked in case of an error.

         - returns response from request wrapped in an object called BreinResponse
     */
    public class func lookup(breinLookup: BreinLookup!,
                             user: BreinUser!,
                             dimension: BreinDimension!,
                             success successBlock: BreinEngine.apiSuccess,
                             failure failureBlock: BreinEngine.apiFailure) throws {

        guard breinLookup?.getBreinEngine() != nil else {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinLookup.setBreinUser(user)
        breinLookup.setBreinDimension(dimension)

        return try breinLookup.getBreinEngine()!.performLookUp(breinLookup,
                success: successBlock,
                failure: failureBlock)
    }

    /// Initiates the shutdown of the engine
    public class func shutdown() {
        if getConfig() != nil {
            getConfig().shutdownEngine()
        }
    }
}