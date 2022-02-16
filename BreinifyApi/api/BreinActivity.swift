//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

/**
 Sends an activity to the engine utilizing the API. The call is done asynchronously as a POST request.
 It is important, that a valid API-key is configured prior to use this.
*/

open class BreinActivity: BreinBase, ISecretStrategy {

    ///  ActivityType of the activity
    var activityType: String?

    ///  Category of the activity
    var category: String?

    ///  Description of the activity
    var desc: String?

    /// tags dictionary
    var tagsDic: [String: Any]?

    /// activity dictionary
    var activityDic: [String: Any]?

    /// returns activity type
    ///
    /// - Returns: the BreinActivity itself
    public func getActivityType() -> String! {
        activityType
    }

    /// sets the activity type
    ///
    /// - Parameter activityType: an activityType as String
    /// - Returns: the BreinActivity itself
    @discardableResult
    @objc
    public func setActivityType(_ activityType: String?) -> BreinActivity {
        self.activityType = activityType
        return self
    }

    /// Provides the category
    ///
    /// - Returns: the category as String
    @discardableResult
    public func getCategory() -> String! {
        category
    }

    /// Sets the category.
    ///
    /// - Parameter category:
    /// - Returns: the BreinActivity itself
    @discardableResult
    @objc
    public func setCategory(_ category: String?) -> BreinActivity {
        self.category = category
        return self
    }

    /// Provides the description of the activity
    ///
    /// - Returns: the description as String
    public func getDescription() -> String! {
        desc
    }

    @discardableResult
    @objc
    public func setDescription(_ description: String!) -> BreinActivity {
        desc = description
        return self
    }

    /// Provides the Activity Endpoint for HTTP requests to the Breinify Engine
    ///
    /// - Returns: the HTTP endpoint as String
    override public func getEndPoint() -> String! {
        getConfig()?.getActivityEndpoint()
    }

    @discardableResult
    @objc
    public func setTagsDic(_ tagsDic: [String: Any]?) -> BreinActivity {
        self.tagsDic = tagsDic
        return self
    }

    public func getTagsDic() -> [String: Any]? {
        tagsDic
    }

    @discardableResult
    @objc
    public func setTag(_ key: String, _ value: AnyObject) -> BreinActivity {
        if tagsDic == nil {
            tagsDic = [String: Any]()
        }

        tagsDic?[key] = value
        return self
    }

    @discardableResult
    public func setActivityDic(_ activityDic: [String: Any]) -> BreinActivity {
        self.activityDic = activityDic
        return self
    }

    public func getActivityDic() -> [String: Any]? {
        activityDic
    }

    /// Sends an activity to the Breinify server.
    ///
    /// - Parameters:
    ///   - breinUser: the user-information
    ///   - breinActivityType: the type of activity
    ///   - breinCategoryType: the category (can be null or undefined)
    ///   - description: the description for the activity
    ///   - success: a callback function that is invoked in case of success.
    ///   - failure: a callback function that is invoked in case of an error.
    /// - Throws: BreinRuntimeError
    public func activity(_ breinUser: BreinUser!,
                         breinActivityType: String!,
                         _ breinCategoryType: String! = nil,
                         _ description: String! = nil,
                         _ success: @escaping BreinEngine.apiSuccess = { _ in
                         },
                         _ failure: @escaping BreinEngine.apiFailure = { _ in
                         }) throws {

        //  set the values for further usage
        setUser(breinUser)
        setActivityType(breinActivityType)
        setCategory(breinCategoryType)
        setDescription(description)

        //  invoke the request, "self" has all necessary information
        if nil == getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine.")
        }

        do {
            try getBreinEngine()?.sendActivity(self, success: success, failure: failure)
        } catch {
            BreinLogger.shared.log(error.localizedDescription)
        }
    }

    /// Creates a dictionary that will be used for the request.
    ///
    /// - Returns: Dictionary
    override public func prepareJsonRequest() -> [String: Any]! {

        // call base class
        super.prepareJsonRequest()

        var requestData = [String: Any]()

        if let breinUser = getUser() {
            var userData = [String: Any]()
            breinUser.prepareUserRequest(&userData, breinConfig: getConfig())
            requestData["user"] = userData as Any?
        }

        //  activity data
        var activityData = [String: Any]()
        if let activityType = getActivityType() {
            activityData["type"] = activityType as Any?
        }
        if let description = getDescription() {
            activityData["description"] = description as Any?
        }
        if let category = getCategory() {
            activityData["category"] = category as Any?
        }

        // add tags
        if tagsDic?.isEmpty == false {
            activityData["tags"] = tagsDic as Any?
        }

        // activity dic
        if let aActivityDic = getActivityDic() {
            if aActivityDic.count > 0 {
                BreinMapUtil.fillMap(aActivityDic, requestStructure: &activityData)
            }
        }

        // add all to the activity dictionary
        requestData["activity"] = activityData as Any?

        // add base stuff
        prepareBaseRequestData(&requestData)

        return requestData
    }

    /// Used to create a clone of an activity. This is important in order to prevent
    /// concurrency issues.
    ///
    /// - Returns: the clone of the activity object
    public func clone() -> BreinActivity {

        // create a new activity object
        let clonedBreinActivity = BreinActivity()
                .setActivityType(getActivityType())
                .setCategory(getCategory())
                .setDescription(getDescription())

        // clone dictionaries => simple copy is enough
        if let clonedActivityDic = getActivityDic() {
            clonedBreinActivity.setActivityDic(clonedActivityDic)
        }

        if let clonedTagsDic = getTagsDic() {
            clonedBreinActivity.setTagsDic(clonedTagsDic)
        }

        // clone from base class
        clonedBreinActivity.cloneBase(self)

        return clonedBreinActivity
    }

    override
    public func clear() {
        super.clear()

        activityDic?.removeAll()
        tagsDic?.removeAll()
        category = ""
        desc = ""
        activityType = ""
    }

    /// Generates the signature for the request
    ///
    /// - Returns: full signature
    /// - Throws: BreinRuntimeError
    public override func createSignature() throws -> String! {

        let breinActivityType = getActivityType() ?? ""
        let unixTimestamp = getUnixTimestamp()
        let message = breinActivityType + String(unixTimestamp) + "1"

        return try BreinUtil.generateSignature(message, secret: getConfig()?.getSecret())
    }

}
