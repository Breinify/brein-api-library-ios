//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

public class BreinActivity: BreinBase, ISecretStrategy {

    //  ActivityType of the activity
    var breinActivityType: String?

    //  Category of the activity
    var breinCategoryType: String?

    //  Description of the activity
    var description: String?

    // tags dictionary
    var tagsDic: [String: AnyObject]?

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

    public func activity(breinUser: BreinUser!,
                         breinActivityType: String!,
                         breinCategoryType: String!,
                         description: String!,
                         sign: Bool,
                         success successBlock: BreinEngine.apiSuccess,
                         failure failureBlock: BreinEngine.apiFailure) throws {

        //  set the values for further usage
        setBreinUser(breinUser)
        setBreinActivityType(breinActivityType)
        setBreinCategoryType(breinCategoryType)
        setDescription(description)
        setSign(sign)

        //  invoke the request, "self" has all necessary information
        if nil == getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine.")
        }
        try getBreinEngine().sendActivity(self, success: successBlock, failure: failureBlock)
    }

    /**
      * creates a dictionary that will be used for the request.
      *
      * @return Dictionary
      */
    override public func prepareJsonRequest() -> [String: AnyObject]! {

        // call base class
        super.prepareJsonRequest()

        var requestData = [String: AnyObject]()

        if let breinUser = getBreinUser() {
            breinUser.getBreinUserRequest().prepareUserRequestData(self,
                    request: &requestData,
                    breinUser: breinUser)
        }

        // activity part
        var activityData = [String: AnyObject]()
        prepareActivityRequestData(&activityData)

        // add all to the activity dictionary
        requestData["activity"] = activityData

        // base level data...
        getBreinBaseRequest().prepareBaseRequestData(self,
                requestData: &requestData,
                isSign: isSign());

        return requestData
    }

    public func prepareActivityRequestData(inout activityRequestData: [String: AnyObject]) {

        if let activityType = getBreinActivityType() {
            activityRequestData["type"] = activityType
        }
        if let description = getDescription() where !description.isEmpty {
            activityRequestData["description"] = description
        }
        if let categoryType = getBreinCategoryType() {
            activityRequestData["category"] = categoryType
        }

        // add tags
        if tagsDic?.isEmpty == false {
            activityRequestData["tags"] = tagsDic
        }
    }

    // creates the signature for the activity message
    public func createSignature() -> String! {

        let activityType = getBreinActivityType() == nil ? "" : getBreinActivityType()
        let message = activityType + String(format: "%d%d", getUnixTimestamp(), 1)

        var signature = ""
        do {
            signature = try BreinUtil.generateSignature(message, secret: getConfig().getSecret())
        } catch {
            print("Ups: Error while trying to generate signature")
        }

        return signature
    }
}