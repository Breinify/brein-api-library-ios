//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

public class BreinActivity: BreinBase, ISecretStrategy {

    //  ActivityType of the activity
    var breinActivityType: BreinActivityType?

    //  Category of the activity
    var breinCategoryType: BreinCategoryType?

    //  Description of the activity
    var description: String?

    public func getBreinActivityType() -> BreinActivityType! {
        return breinActivityType
    }

    public func setBreinActivityType(breinActivityType: BreinActivityType?) {
        self.breinActivityType = breinActivityType
    }

    public func getBreinCategoryType() -> BreinCategoryType! {
        return breinCategoryType
    }

    public func setBreinCategoryType(breinCategoryType: BreinCategoryType?) {
        self.breinCategoryType = breinCategoryType
    }

    public func getDescription() -> String! {
        return description
    }

    public func setDescription(description: String!) {
        self.description = description
    }

    override public func getEndPoint() -> String! {
        return getConfig().getActivityEndpoint()
    }

    public func activity(breinUser: BreinUser!,
                  breinActivityType: BreinActivityType!,
                  breinCategoryType: BreinCategoryType!,
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

    override public func prepareJsonRequest() -> [String:AnyObject]! {
        // call base class
        super.prepareJsonRequest()

        var requestData = [String: AnyObject]()

        if let breinUser = getBreinUser() {
            var userData = [String: AnyObject]()
             userData["email"] = breinUser.getEmail()
             if let firstName = breinUser.getFirstName() where !firstName.isEmpty {
                userData["firstName"] = firstName
            }
            if let user = breinUser.getLastName() where !user.isEmpty {
                userData["lastName"] = user
            }
            requestData["user"] = userData
        }

        //  activity data
        var activityData = [String: AnyObject]()
        if let activityType = getBreinActivityType() {
            activityData["type"] = activityType.rawValue
        }
        if let description = getDescription() where !description.isEmpty {
            activityData["description"] = description
        }
        if let categoryType = getBreinCategoryType() {
            activityData["category"] = categoryType.rawValue
        }
        requestData["activity"] = activityData

        if let apiKey = getConfig()?.getApiKey() where !apiKey.isEmpty {
            requestData["apiKey"] = apiKey
        }

        requestData["unixTimestamp"] = getUnixTimestamp()

        // if sign is active
        if isSign() {
            do {
                requestData["signatureType"] = try createSignature()
            } catch {
                print("not possible to generate signature")
            }
        }

        // just in case the JSON representation is important
        /*
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(requestData,
                options: NSJSONWritingOptions.PrettyPrinted)

        let jsonString = NSString(data: jsonData,
                encoding: NSUTF8StringEncoding) as! String

        */
        return requestData
    }

    public func createSignature() throws -> String! {

        let message = String(format: "%s%d%d", getBreinActivityType() == nil ? "" : getBreinActivityType().rawValue, getUnixTimestamp(), 1)

        return try BreinUtil.generateSignature(message, secret: getConfig().getSecret())
    }
}