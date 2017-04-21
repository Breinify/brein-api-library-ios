//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

open class BreinifyExecutor {
    
    //  contains the configuration
    var config: BreinConfig!

    //  contains the activity object
    var breinActivity: BreinActivity! = BreinActivity()

    //  contains the lookup object
    var breinLookup: BreinLookup! = BreinLookup()

    public func setConfig(_ breinConfig: BreinConfig!) {
        config = breinConfig
        breinActivity.setConfig(breinConfig)
        breinLookup.setConfig(breinConfig)
    }

    public func getConfig() -> BreinConfig! {
        return config
    }

    // Todo: Comment missing
    public func activity(_ user: BreinUser!,
                  activityType: String!,
                  category: String!,
                  description: String!,
                  success successBlock: @escaping BreinEngine.apiSuccess,
                  failure failureBlock: @escaping BreinEngine.apiFailure) throws {

        try activity(breinActivity,
                user: user,
                activityType: activityType,
                category: category,
                description: description,
                success: successBlock,
                failure: failureBlock)
    }

    // Todo: Comment missing
    public func activity(_ breinActivity: BreinActivity!,
                  user: BreinUser!,
                  activityType: String!,
                  category: String!,
                  description: String!,
                  success successBlock: @escaping BreinEngine.apiSuccess,
                  failure failureBlock: @escaping BreinEngine.apiFailure) throws {

        //  invoke the request, "this" has all necessary information
        if nil == breinActivity.getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinActivity.setUser(user)
        breinActivity.setActivityType(activityType)
        breinActivity.setCategoryType(category)
        breinActivity.setDescription(description)
        
        try breinActivity.getBreinEngine()?.sendActivity(breinActivity, success: successBlock, failure: failureBlock)
    }

    // Todo: Comment missing
    public func lookup(_ user: BreinUser!,
                dimension: BreinDimension!,
                success successBlock: @escaping BreinEngine.apiSuccess,
                failure failureBlock: @escaping BreinEngine.apiFailure) throws {
        
        return try lookup(breinLookup,
                user: user,
                dimension: dimension,
                success: successBlock,
                failure: failureBlock)
    }

    // Todo: Comment missing
    public func lookup(_ breinLookup: BreinLookup!,
                user: BreinUser!,
                dimension: BreinDimension!,
                success successBlock: @escaping BreinEngine.apiSuccess,
                failure failureBlock: @escaping BreinEngine.apiFailure) throws {

        //  invoke the lookup request
        if nil == breinLookup.getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        breinLookup.setUser(user)
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
