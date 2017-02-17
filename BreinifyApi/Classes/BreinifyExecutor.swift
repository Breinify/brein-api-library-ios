//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

public class BreinifyExecutor {
    
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

    public func activity(user: BreinUser!,
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

    public func activity(breinActivity: BreinActivity!,
                  user: BreinUser!,
                  activityType: String!,
                  category: String!,
                  description: String!,
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
        
        try breinActivity.getBreinEngine()?.sendActivity(breinActivity, success: successBlock, failure: failureBlock)
    }

    public func lookup(user: BreinUser!,
                dimension: BreinDimension!,
                success successBlock: BreinEngine.apiSuccess,
                failure failureBlock: BreinEngine.apiFailure) throws {
        
        return try lookup(breinLookup,
                user: user,
                dimension: dimension,
                success: successBlock,
                failure: failureBlock)
    }

    public func lookup(breinLookup: BreinLookup!,
                user: BreinUser!,
                dimension: BreinDimension!,
                success successBlock: BreinEngine.apiSuccess,
                failure failureBlock: BreinEngine.apiFailure) throws {

        //  invoke the lookup request
        if nil == breinLookup.getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinLookup.setBreinUser(user)
        breinLookup.setBreinDimension(dimension)
       
        return try breinLookup.getBreinEngine()!.performLookUp(breinLookup,
                success: successBlock,
                failure: failureBlock)
    }

    /// shutdown of the engine
    public func shutdown() {
        if getConfig() != nil {
            getConfig().shutdownEngine()
        }
    }
}
