//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

public class Breinify {

    //  contains the current version of the usage library
    static let version: String! = "1.0.0-snapshot"

    //  contains the configuration
    static var config: BreinConfig!

    //  contains the activity object
    static var breinActivity: BreinActivity! = BreinActivity()

    //  contains the lookup object
    static var breinLookup: BreinLookup = BreinLookup()

    public class func setConfig(breinConfig: BreinConfig!) {
        config = breinConfig
        breinActivity.setConfig(breinConfig)
        breinLookup.setConfig(breinConfig)
    }

    // retrieves the configuration
    public class func getConfig() -> BreinConfig! {
        return config
    }

    // retrieves the version
    public static func getVersion() -> String! {
        return version
    }

    public static func getBreinActivity() -> BreinActivity {
        return breinActivity
    }

    /**
        * Sends an activity to the engine utilizing the API. The call is done asynchronously as a POST request. It is
        * important that a valid API-key is configured prior to using this function.
        * <p>
        * This request is asynchronous.
        *
        * @param user          a plain object specifying the user information the activity belongs to
        * @param activityType  the type of the activity collected, i.e., one of search, login, logout, addToCart,
        *                      removeFromCart, checkOut, selectProduct, or other. if not specified, the default other will
        *                      be used
        * @param categoryType  the category of the platform/service/products, i.e., one of apparel, home, education, family,
        *                      food, health, job, services, or other
        * @param description   a string with further information about the activity performed
        * @param sign          a boolean value specifying if the call should be signed
        */
    public class func activity(user: BreinUser!,
                               activityType: String!,
                               category: String!,
                               description: String!,
                               sign: Bool,
                               success successBlock: BreinEngine.apiSuccess,
                               failure failureBlock: BreinEngine.apiFailure) throws {

        try activity(breinActivity,
                user: user,
                activityType: activityType,
                category: category,
                description: description,
                sign: sign,
                success: successBlock,
                failure: failureBlock)
    }

    /**
    Sends an activity to the engine utilizing the API. The call is done asynchronously as a POST request. It is
    important that a valid API-key is configured prior to using this function.
    Furthermore it uses the internal instance of BreinActivity. In order to use this method correctly you have
    to do the following:
    <p>
    // retrieve BreinActivity instance from Breinify class
    BreinActivity breinActivity = Breinify.getBreinActivity();
    <p>
    // set methods as desired to breinActivity (for instance)
    breinActivity.setBreinUser(new BreinUser("user.name@email.com");
    ...
    <p>
    // invoke this method
    Breinify.activity();
    <p>
    <p>
    This request is asynchronous.
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

        // invoke the activity call
        try breinActivity.getBreinEngine().sendActivity(breinActivity,
                success: successBlock,
                failure: failureBlock)
    }

    //
    public class func activity(breinActivity: BreinActivity!,
                               user: BreinUser!,
                               activityType: String!,
                               category: String!,
                               description: String!,
                               sign: Bool,
                               success successBlock: BreinEngine.apiSuccess,
                               failure failureBlock: BreinEngine.apiFailure) throws {

        guard breinActivity?.getBreinEngine() != nil else {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinActivity.setBreinUser(user)
        breinActivity.setBreinActivityType(activityType)
        breinActivity.setBreinCategoryType(category)
        breinActivity.setDescription(description)
        breinActivity.setSign(sign)

        try breinActivity.getBreinEngine().sendActivity(breinActivity,
                success: successBlock,
                failure: failureBlock)
    }

    //
    public class func lookup(user: BreinUser!,
                             dimension: BreinDimension!,
                             sign: Bool,
                             success successBlock: BreinEngine.apiSuccess,
                             failure failureBlock: BreinEngine.apiFailure) throws {

        return try lookup(breinLookup,
                user: user,
                dimension: dimension,
                sign: sign,
                success: successBlock,
                failure: failureBlock)
    }

    public class func lookup(breinLookup: BreinLookup!,
                             user: BreinUser!,
                             dimension: BreinDimension!,
                             sign: Bool,
                             success successBlock: BreinEngine.apiSuccess,
                             failure failureBlock: BreinEngine.apiFailure) throws {

        guard breinLookup?.getBreinEngine() != nil else {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinLookup.setBreinUser(user)
        breinLookup.setBreinDimension(dimension)
        breinLookup.setSign(sign)

        return try breinLookup.getBreinEngine().performLookUp(breinLookup,
                success: successBlock,
                failure: failureBlock)
    }

    public class func shutdown() {
        if getConfig() != nil {
            getConfig().shutdownEngine()
        }
    }
}