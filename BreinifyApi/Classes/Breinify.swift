//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

public class Breinify {

    ///  contains the current version of the usage library
    static let version: String! = "0.3.5"

    ///  contains the configuration
    static var config: BreinConfig!

    ///  contains the activity object
    static var breinActivity: BreinActivity! = BreinActivity()

    /// contains the recommendation object
    static var breinRecommendation: BreinRecommendation! = BreinRecommendation()

    ///  contains the lookup object
    static var breinLookup: BreinLookup! = BreinLookup()

    /// contains the temporaldata object
    static var breinTemporalData: BreinTemporalData = BreinTemporalData()

    ///
    public static func getBreinRecommendation() -> BreinRecommendation! {
        return breinRecommendation
    }

    ///
    public static func getBreinActivity() -> BreinActivity! {
        return breinActivity
    }

    ///
    public static func getBreinLookup() -> BreinLookup! {
        return breinLookup
    }

    public class func setConfig(breinConfig: BreinConfig!) {
        self.config = breinConfig

        // apply the configuration to all instances
        self.getBreinActivity().setConfig(breinConfig)
        self.getBreinLookup().setConfig(breinConfig)
        self.getBreinRecommendation().setConfig(breinConfig)
        self.breinTemporalData.setConfig(breinConfig)
    }

    // retrieves the configuration
    public class func getConfig() -> BreinConfig! {
        return config
    }

    // retrieves the version
    public static func getVersion() -> String! {
        return version
    }

    ///
    public class func activity(user: BreinUser!,
                               activityType: String!,
                               category: String!,
                               description: String!,
                               success successBlock: BreinEngine.apiSuccess,
                               failure failureBlock: BreinEngine.apiFailure) throws {

        try activity(breinActivity,
                user: user,
                activityType: activityType,
                category: category,
                description: description,
                success: successBlock,
                failure: failureBlock)
    }

    ///
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
                               success successBlock: BreinEngine.apiSuccess,
                               failure failureBlock: BreinEngine.apiFailure) throws {

        guard breinActivity?.getBreinEngine() != nil else {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinActivity.setBreinUser(user)
        breinActivity.setBreinActivityType(activityType)
        breinActivity.setBreinCategoryType(category)
        breinActivity.setDescription(description)

        try breinActivity.getBreinEngine().sendActivity(breinActivity,
                success: successBlock,
                failure: failureBlock)
    }

    public class func recommendation(breinRecommendation: BreinRecommendation!,
                                     success successBlock: BreinEngine.apiSuccess,
                                     failure failureBlock: BreinEngine.apiFailure) throws {

        if breinRecommendation == nil {
            throw BreinError.BreinRuntimeError("BreinRecommendation is nil");
        }

        // apply the current configuration
        breinRecommendation.setConfig(self.getBreinRecommendation().getConfig());

        return try breinRecommendation.getBreinEngine().invokeRecommendation(breinRecommendation,
                success: successBlock,
                failure: failureBlock)
    }

    ///
    public class func temporalData(user: BreinUser!,
                                   success successBlock: BreinEngine.apiSuccess,
                                   failure failureBlock: BreinEngine.apiFailure) throws {

        return try temporalData(breinTemporalData,
                user: user,
                success: successBlock,
                failure: failureBlock)
    }

    /// 
    public class func temporalData(breinTemporalData: BreinTemporalData!,
                                   user: BreinUser!,
                                   success successBlock: BreinEngine.apiSuccess,
                                   failure failureBlock: BreinEngine.apiFailure) throws {

        guard breinTemporalData?.getBreinEngine() != nil else {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinTemporalData.setBreinUser(user)

        return try breinTemporalData.getBreinEngine().performTemporalDataRequest(breinTemporalData,
                success: successBlock,
                failure: failureBlock)
    }


    /// 
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

    /// 
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

        return try breinLookup.getBreinEngine().performLookUp(breinLookup,
                success: successBlock,
                failure: failureBlock)
    }

    ///
    public class func shutdown() {
        if getConfig() != nil {
            getConfig().shutdownEngine()
        }
    }
}
