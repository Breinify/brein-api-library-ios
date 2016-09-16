//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation
import CoreLocation

public class BreinActivity: BreinBase, ISecretStrategy {

    //  ActivityType of the activity
    var breinActivityType: String?

    //  Category of the activity
    var breinCategoryType: String?

    //  Description of the activity
    var description: String?

    // location coordinates
    var locationData: CLLocation?

    // tags dictionary
    var tagsDic: [String:AnyObject]?

    public func setLocationData(locationData: CLLocation?) -> BreinActivity {
        self.locationData = locationData
        return self
    }

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

    public func setTagsDic(tagsDic: [String:AnyObject]) -> BreinActivity {
        self.tagsDic = tagsDic
        return self
    }

    public func getTagsDic() -> [String:AnyObject]? {
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
    override public func prepareJsonRequest() -> [String:AnyObject]! {
        // call base class
        super.prepareJsonRequest()

        var requestData = [String: AnyObject]()

        if let breinUser = getBreinUser() {
            var userData = [String: AnyObject]()

            if let email = breinUser.getEmail() where !email.isEmpty {
                userData["email"] = breinUser.getEmail()
            }

            if let session = breinUser.getSessionId() where !session.isEmpty {
                userData["sessionId"] = breinUser.getSessionId()
            }

            if let firstName = breinUser.getFirstName() where !firstName.isEmpty {
                userData["firstName"] = firstName
            }

            if let user = breinUser.getLastName() where !user.isEmpty {
                userData["lastName"] = user
            }

            // additional part
            var additionalData = [String: AnyObject]()
            if locationData != nil {
                // only a valid location will be taken into consideration
                // this is the case when the corrdiantes are different from 0
                if locationData?.coordinate.latitude != 0 {
                    var locData = [String: AnyObject]()
                    locData["accuracy"] = locationData?.horizontalAccuracy
                    locData["latitude"] = locationData?.coordinate.latitude
                    locData["longitude"] = locationData?.coordinate.longitude
                    locData["speed"] = locationData?.speed

                    additionalData["location"] = locData
                }
            }

            if let url = breinUser.getUrl() where !url.isEmpty {
                additionalData["url"] = url
            }

            // check if an userAgent has been set, if not build one
            if let userAgent = breinUser.getUserAgent() where !userAgent.isEmpty {
                additionalData["userAgent"] = userAgent
            } else {

                // user-agent is build not set
                let generatedUserAgent = getConfig().getBreinEngine().getUserAgent()
                additionalData["userAgent"] = generatedUserAgent
            }

            if let ipAddress = breinUser.getIpAddress() where !ipAddress.isEmpty {
                additionalData["ipAddress"] = ipAddress
            }

            // only add if something is there
            if !additionalData.isEmpty {
                userData["additional"] = additionalData
            }

            requestData["user"] = userData
        }

        //  activity data
        var activityData = [String: AnyObject]()
        if let activityType = getBreinActivityType() {
            activityData["type"] = activityType
        }
        if let description = getDescription() where !description.isEmpty {
            activityData["description"] = description
        }
        if let categoryType = getBreinCategoryType() {
            activityData["category"] = categoryType
        }

        // add tags
        if tagsDic?.isEmpty == false {
            activityData["tags"] = tagsDic
        }

        // add all to the activity dictionary
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

    //
    public func createSignature() throws -> String! {

        let message = String(format: "%s%d%d",
                getBreinActivityType() == nil
                ? "" : getBreinActivityType(), getUnixTimestamp(), 1)

        return try BreinUtil.generateSignature(message, secret: getConfig().getSecret())
    }
}