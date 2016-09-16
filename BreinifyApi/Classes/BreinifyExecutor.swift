//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

public class BreinifyExecutor {

    //  contains the current version of the usage library
    static let Version: String! = "1.0.0-snapshot"

    //  contains the configuration
    var config: BreinConfig!

    //  contains the activity object
    var breinActivity: BreinActivity! = BreinActivity()

    //  contains the lookup object
    var breinLookup: BreinLookup! = BreinLookup()

    public func setConfig(breinConfig: BreinConfig!) {
        config = breinConfig
        breinActivity.setConfig(breinConfig)
        breinLookup.setConfig(breinConfig)
    }

    public func getConfig() -> BreinConfig! {
        return config
    }

    public static func getVersion() -> String! {
        return Version
    }

    public func activity(user: BreinUser!,
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

    public func activity(breinActivity: BreinActivity!,
                  user: BreinUser!,
                  activityType: String!,
                  category: String!,
                  description: String!,
                  sign: Bool,
                  success successBlock: BreinEngine.apiSuccess,
                  failure failureBlock: BreinEngine.apiFailure) throws {

        //  invoke the request, "this" has all necessary information
        if nil == breinActivity.getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinActivity.setBreinUser(user)
        breinActivity.setBreinActivityType(activityType)
        breinActivity.setBreinCategoryType(category)
        breinActivity.setDescription(description)
        breinActivity.setSign(sign)

        try breinActivity.getBreinEngine().sendActivity(breinActivity, success: successBlock, failure: failureBlock)
    }

    public func lookup(user: BreinUser!,
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

    public func lookup(breinLookup: BreinLookup!,
                user: BreinUser!,
                dimension: BreinDimension!,
                sign: Bool,
                success successBlock: BreinEngine.apiSuccess,
                failure failureBlock: BreinEngine.apiFailure) throws {

        //  invoke the lookup request
        if nil == breinLookup.getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinLookup.setBreinUser(user)
        breinLookup.setBreinDimension(dimension)
        breinLookup.setSign(sign)

        return try breinLookup.getBreinEngine().performLookUp(breinLookup,
                success: successBlock,
                failure: failureBlock)
    }

    public func shutdown() {
        if getConfig() != nil {
            getConfig().shutdownEngine()
        }
    }
}
