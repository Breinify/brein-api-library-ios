//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation


/**
 Sends an activity to the engine utilizing the API. The call is done asynchronously as a POST request.
 It is important, that a valid API-key is configured prior to using this function.
*/

public class BreinActivity: BreinBase, ISecretStrategy {

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

    public func setBreinActivityType(breinActivityType: String?) -> BreinActivity {
        self.breinActivityType = breinActivityType
        return self
    }

    public func getBreinCategoryType() -> String! {
        return breinCategoryType
    }

    public func setBreinCategoryType(breinCategoryType: String?) -> BreinActivity {
        self.breinCategoryType = breinCategoryType
        return self
    }

    public func getDescription() -> String! {
        return description
    }

    public func setDescription(description: String!) -> BreinActivity {
        self.description = description
        return self
    }

    override public func getEndPoint() -> String! {
        return getConfig().getActivityEndpoint()
    }

    public func setTagsDic(tagsDic: [String: AnyObject]) -> BreinActivity {
        self.tagsDic = tagsDic
        return self
    }

    public func getTagsDic() -> [String: AnyObject]? {
        return self.tagsDic
    }

    public func setActivityDic(activityDic: [String: AnyObject]) -> BreinActivity {
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
    */
    public func activity(breinUser: BreinUser!,
                         breinActivityType: String!,
                         breinCategoryType: String!,
                         description: String!,
                         success successBlock: BreinEngine.apiSuccess,
                         failure failureBlock: BreinEngine.apiFailure) throws {

        //  set the values for further usage
        setBreinUser(breinUser)
        setBreinActivityType(breinActivityType)
        setBreinCategoryType(breinCategoryType)
        setDescription(description)

        //  invoke the request, "self" has all necessary information
        if nil == getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine.")
        }
        try getBreinEngine().sendActivity(self, success: successBlock, failure: failureBlock)
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
            requestData["user"] = userData
        }

        //  activity data
        var activityData = [String: AnyObject]()
        if let activityType = getBreinActivityType() {
            activityData["type"] = activityType
        }
        if let description = getDescription() {
            activityData["description"] = description
        }
        if let categoryType = getBreinCategoryType() {
            activityData["category"] = categoryType
        }

        // add tags
        if tagsDic?.isEmpty == false {
            activityData["tags"] = tagsDic
        }

        // activity dic
        if let aActivityDic = self.getActitivityDic() {
            if aActivityDic.count > 0 {
                BreinMapUtil.fillMap(aActivityDic, requestStructure: &activityData)
            }
        }

        // add all to the activity dictionary
        requestData["activity"] = activityData

        // add base stuff
        self.prepareBaseRequestData(&requestData)

        return requestData
    }

    /**
      Generates the signature for the request
     
      returns: full signature
    */
    public override func createSignature() throws -> String! {

        let breinActivityType = self.getBreinActivityType() ?? ""
        let unixTimestamp = self.getUnixTimestamp()
        let message = breinActivityType + String(unixTimestamp) + "1"

        return try BreinUtil.generateSignature(message, secret: getConfig().getSecret())
    }

}
