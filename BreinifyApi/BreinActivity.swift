//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

/**
 Sends an activity to the engine utilizing the API. The call is done asynchronously as a POST request.
 It is important, that a valid API-key is configured prior to using this function.
*/

open class BreinActivity: BreinBase, ISecretStrategy {

    ///  ActivityType of the activity
    var activityType: String?

    ///  Category of the activity
    var categoryType: String?

    ///  Description of the activity
    var description: String?

    /// tags dictionary
    var tagsDic: [String: AnyObject]?

    /// activity dictionary
    var actitivityDic: [String: AnyObject]?

    /// returns activity type
    /// - return activity type as String
    public func getActivityType() -> String! {
        return activityType
    }

    @discardableResult
    public func setActivityType(_ activityType: String?) -> BreinActivity {
        self.activityType = activityType
        return self
    }

    public func getCategoryType() -> String! {
        return categoryType
    }

    @discardableResult
    public func setCategoryType(_ categoryType: String?) -> BreinActivity {
        self.categoryType = categoryType
        return self
    }

    public func getDescription() -> String! {
        return description
    }

    @discardableResult
    public func setDescription(_ description: String!) -> BreinActivity {
        self.description = description
        return self
    }

    override public func getEndPoint() -> String! {
        return getConfig()?.getActivityEndpoint()
    }

    @discardableResult
    public func setTagsDic(_ tagsDic: [String: AnyObject]) -> BreinActivity {
        self.tagsDic = tagsDic
        return self
    }

    public func getTagsDic() -> [String: AnyObject]? {
        return self.tagsDic
    }

    public func setTag(_ key: String, _ value: AnyObject) -> BreinActivity {

        if self.tagsDic == nil {
            self.tagsDic = [String : AnyObject] ()
        }

        tagsDic?[key] = value
        return self
    }

    @discardableResult
    public func setActivityDic(_ activityDic: [String: AnyObject]) -> BreinActivity {
        self.actitivityDic = activityDic
        return self
    }

    public func getActitivityDic() -> [String: AnyObject]? {
        return self.actitivityDic
    }

    /**
      Sends an activity to the Breinify server.

      - parameter breinUser:         the user-information
      - parameter breinActivityType: the type of activity
      - parameter breinCategoryType: the category (can be null or undefined)
      - parameter description:       the description for the activity
      - parameter success:           A callback function that is invoked in case of success.
      - parameter failure:           A callback function that is invoked in case of an error.
    */
    public func activity(_ breinUser: BreinUser!,
                         breinActivityType: String!,
                         _ breinCategoryType: String! = nil,
                         _ description: String! = nil,
                         _ success: @escaping BreinEngine.apiSuccess = { _ in },
                         _ failure: @escaping BreinEngine.apiFailure = { _ in }) throws {

        //  set the values for further usage
        setUser(breinUser)
        setActivityType(breinActivityType)
        setCategoryType(breinCategoryType)
        setDescription(description)

        //  invoke the request, "self" has all necessary information
        if nil == getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine.")
        }
        try getBreinEngine()?.sendActivity(self, success: success, failure: failure)
    }

    /**
      Creates a dictionary that will be used for the request.

      returns: Dictionary
    */
    override public func prepareJsonRequest() -> [String: AnyObject]! {

        // call base class
        super.prepareJsonRequest()

        var requestData = [String: AnyObject]()

        if let breinUser = getUser() {
            var userData = [String: AnyObject]()
            breinUser.prepareUserRequest(&userData, breinConfig: self.getConfig())
            requestData["user"] = userData as AnyObject?
        }

        //  activity data
        var activityData = [String: AnyObject]()
        if let activityType = getActivityType() {
            activityData["type"] = activityType as AnyObject?
        }
        if let description = getDescription() {
            activityData["description"] = description as AnyObject?
        }
        if let categoryType = getCategoryType() {
            activityData["category"] = categoryType as AnyObject?
        }

        // add tags
        if tagsDic?.isEmpty == false {
            activityData["tags"] = tagsDic as AnyObject?
        }

        // activity dic
        if let aActivityDic = self.getActitivityDic() {
            if aActivityDic.count > 0 {
                BreinMapUtil.fillMap(aActivityDic, requestStructure: &activityData)
            }
        }

        // add all to the activity dictionary
        requestData["activity"] = activityData as AnyObject?

        // add base stuff
        self.prepareBaseRequestData(&requestData)

        return requestData
    }

    /**
      Used to create a clone of an activity. This is important in order to prevent
      concurrency issues.

      - returns: the clone of the activity object
    */
    public func clone() -> BreinActivity {

        // create a new activity object
        let clonedBreinActivity = BreinActivity()
                .setActivityType(self.getActivityType())
                .setCategoryType(self.getCategoryType())
                .setDescription(self.getDescription())

        // clone dictionaries => simple copy is enough
        if let clonedActivityDic = self.getActitivityDic() {
            clonedBreinActivity.setActivityDic(clonedActivityDic)
        }

        if let clonedTagsDic = self.getTagsDic() {
            clonedBreinActivity.setTagsDic(clonedTagsDic)
        }

        // clone from base class
        clonedBreinActivity.cloneBase(self)

        return clonedBreinActivity
    }

    /**
      Generates the signature for the request
     
      returns: full signature
    */
    public override func createSignature() throws -> String! {

        let breinActivityType = self.getActivityType() ?? ""
        let unixTimestamp = self.getUnixTimestamp()
        let message = breinActivityType + String(unixTimestamp) + "1"

        return try BreinUtil.generateSignature(message, secret: getConfig()?.getSecret())
    }

}
