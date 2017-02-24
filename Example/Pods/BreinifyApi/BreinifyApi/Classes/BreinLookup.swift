//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

public class BreinLookup: BreinBase, ISecretStrategy {

    //  used for lookup request
    var breinDimension: BreinDimension!

    public func getBreinDimension() -> BreinDimension! {
        return breinDimension
    }

    public func setBreinDimension(breinDimension: BreinDimension!) {
        self.breinDimension = breinDimension
    }

    /**
      Lookup implementation. For a given user (BreinUser) a lookup will be performed with the requested dimensions
      (BreinDimension)

      - parameter breinUser:      contains the breinify user
      - parameter breinDimension: contains the dimensions to look after
      - parameter successBlock : A callback function that is invoked in case of success.
      - parameter failureBlock : A callback function that is invoked in case of an error.

      - returns: response from request or null if no data can be retrieved
    */
    public func lookUp(breinUser: BreinUser!,
                breinDimension: BreinDimension!,
                success successBlock: BreinEngine.apiSuccess,
                failure failureBlock: BreinEngine.apiFailure) throws {

        if nil == getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        setBreinUser(breinUser)
        setBreinDimension(breinDimension)

        return try getBreinEngine()!.performLookUp(self, success: successBlock, failure: failureBlock)
    }

    /**
      prepares a JSON request for a lookup

      - returns: Dictionary that will be used for rest call (body)
    */
    override public func prepareJsonRequest() -> [String:AnyObject]! {
        // call base class
        super.prepareJsonRequest()

        var requestData = [String: AnyObject]()

        if let breinUser = getBreinUser() {
            var userData = [String: AnyObject]()
            userData["email"] = breinUser.getEmail()
            requestData["user"] = userData
        }

        //  Dimensions
        if let breinDimension = getBreinDimension() {
            var lookupData = [String: AnyObject]()
            var dimensions = [String]()
            for field in breinDimension.getDimensionFields() {
                dimensions.append(field)
            }
            lookupData["dimensions"] = dimensions
            requestData["lookup"] = lookupData
        }

        //  API key
        if let apiKey = getConfig()?.getApiKey() where !apiKey.isEmpty {
            requestData["apiKey"] = apiKey
        }

        // Unix time stamp
        requestData["unixTimestamp"] = getUnixTimestamp()

        // set secret
        if isSign() {
            do {
                requestData["signatureType"] = try createSignature()
            } catch {
                print("not possible to generate signature")
            }
        }

        // Just in case the JSON is important
        /*
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(requestData,
                options: NSJSONWritingOptions.PrettyPrinted)

        let jsonString = NSString(data: jsonData,
                encoding: NSUTF8StringEncoding) as! String
         */

        return requestData
    }

    override public func getEndPoint() -> String? {
        return getConfig()?.getLookupEndpoint()
    }

    /**
      Creates the signature for lookup

       - returns: signature
    */
    public override func createSignature() throws -> String! {
        let dimensions = getBreinDimension().getDimensionFields()
        let dimEmpty = dimensions.isEmpty ? "0" : dimensions[0]
        let dimCount = dimensions.isEmpty ? 0 : dimensions.count

        // we need the first one
        let message = String(dimEmpty) + String(getUnixTimestamp()) + String(dimCount)

        /*
        let message: String! = String(format: "%s%d%d", dimensions.isEmpty ? 0 : dimensions[0],
                getUnixTimestamp(),
                dimensions.isEmpty ? 0 : dimensions.count)
                */

        return try BreinUtil.generateSignature(message, secret: getConfig().getSecret())
    }

}
