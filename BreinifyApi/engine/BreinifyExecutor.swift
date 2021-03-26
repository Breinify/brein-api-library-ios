//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class BreinifyExecutor {

    //  contains the configuration
    var config: BreinConfig!

    //  contains the activity object
    var breinActivity: BreinActivity! = BreinActivity()

    //  contains the lookup object
    var breinLookup: BreinLookup! = BreinLookup()

    /// Set the config
    ///
    /// - Parameter breinConfig:
    public func setConfig(_ breinConfig: BreinConfig!) {
        config = breinConfig
        breinActivity.setConfig(breinConfig)
        breinLookup.setConfig(breinConfig)
    }

    /// Returns the config
    ///
    /// - Returns:
    public func getConfig() -> BreinConfig! {
        config
    }

    /// Invokes an activity request
    ///
    /// - Parameters:
    ///   - user:
    ///   - activityType:
    ///   - category:
    ///   - description:
    ///   - successBlock:
    ///   - failureBlock:
    /// - Throws:
    public func activity(_ user: BreinUser!,
                         activityType: String!,
                         category: String!,
                         description: String!,
                         success successBlock: @escaping BreinEngine.apiSuccess,
                         failure failureBlock: @escaping BreinEngine.apiFailure) throws {

        do {
            try activity(breinActivity,
                    user: user,
                    activityType: activityType,
                    category: category,
                    description: description,
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            BreinLogger.shared.log(error.localizedDescription)
        }
    }

    /// Invokes an activity request
    ///
    /// - Parameters:
    ///   - breinActivity:
    ///   - user:
    ///   - activityType:
    ///   - category:
    ///   - description:
    ///   - successBlock:
    ///   - failureBlock:
    /// - Throws:
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
        breinActivity.setCategory(category)
        breinActivity.setDescription(description)

        do {
            try breinActivity.getBreinEngine()?.sendActivity(breinActivity, success: successBlock, failure: failureBlock)
        } catch {
            BreinLogger.shared.log(error.localizedDescription)
        }
    }

    /// Invokes a lookup request
    ///
    /// - Parameters:
    ///   - user:
    ///   - dimension:
    ///   - successBlock:
    ///   - failureBlock:
    /// - Throws:
    public func lookup(_ user: BreinUser!,
                       dimension: BreinDimension!,
                       success successBlock: @escaping BreinEngine.apiSuccess,
                       failure failureBlock: @escaping BreinEngine.apiFailure) throws {

        do {
            return try lookup(breinLookup,
                    user: user,
                    dimension: dimension,
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            BreinLogger.shared.log(error.localizedDescription)
        }
    }

    /// Invokes a lookup request
    ///
    /// - Parameters:
    ///   - breinLookup:
    ///   - user:
    ///   - dimension:
    ///   - successBlock:
    ///   - failureBlock:
    /// - Throws:
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

        do {
            return try breinLookup.getBreinEngine()!.performLookUp(breinLookup,
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            BreinLogger.shared.log(error.localizedDescription)
        }
    }

    /// shutdown of the engine
    public func shutdown() {
        if getConfig() != nil {
            getConfig().shutdownEngine()
        }
    }
}
