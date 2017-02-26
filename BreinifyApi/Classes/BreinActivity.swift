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
    var breinActivityType: String?

    ///  Category of the activity
    var breinCategoryType: String?

    ///  Description of the activity
    var description: String?

    /// tags dictionary
    var tagsDic: [String: AnyObject]?

    /// activity dictionary
    var actitivityDic: [String: AnyObject]?

    /// returns activity type
    /// - return activity type as String
    public func getBreinActivityType() -> String! {
        return breinActivityType
    }

    @discardableResult
    public func setBreinActivityType(_ breinActivityType: String?) -> BreinActivity {
        self.breinActivityType = breinActivityType
        return self
    }

    public func getBreinCategoryType() -> String! {
        return breinCategoryType
    }

    @discardableResult
    public func setBreinCategoryType(_ breinCategoryType: String?) -> BreinActivity {
        self.breinCategoryType = breinCategoryType
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
      - parameter successBlock : A callback function that is invoked in case of success.
      - parameter failureBlock : A callback function that is invoked in case of an error.
    */
    public func activity(_ breinUser: BreinUser!,
                         breinActivityType: String!,
                         breinCategoryType: String!,
                         description: String!,
                         success successBlock: @escaping BreinEngine.apiSuccess,
                         failure failureBlock: @escaping BreinEngine.apiFailure) throws {

        //  set the values for further usage
        setBreinUser(breinUser)
        setBreinActivityType(breinActivityType)
        setBreinCategoryType(breinCategoryType)
        setDescription(description)

        //  invoke the request, "self" has all necessary information
        if nil == getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine.")
        }
        try getBreinEngine()?.sendActivity(self, success: successBlock, failure: failureBlock)
    }

    /**
      Creates a dictionary that will be used for the request.

      returns: Dictionary
    */
    override public func prepareJsonRequest() -> [String: AnyObject]! {

        // call base class
        super.prepareJsonRequest()

        var requestData = [String: AnyObject]()

        if let breinUser = getBreinUser() {
            var userData = [String: AnyObject]()
            breinUser.prepareUserRequest(&userData, breinConfig: self.getConfig())
            requestData["user"] = userData as AnyObject?
        }

        //  activity data
        var activityData = [String: AnyObject]()
        if let activityType = getBreinActivityType() {
            activityData["type"] = activityType as AnyObject?
        }
        if let description = getDescription() {
            activityData["description"] = description as AnyObject?
        }
        if let categoryType = getBreinCategoryType() {
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
           .setBreinActivityType(self.getBreinActivityType())
           .setBreinCategoryType(self.getBreinCategoryType())
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

        let breinActivityType = self.getBreinActivityType() ?? ""
        let unixTimestamp = self.getUnixTimestamp()
        let message = breinActivityType + String(unixTimestamp) + "1"

        return try BreinUtil.generateSignature(message, secret: getConfig()?.getSecret())
    }

}
