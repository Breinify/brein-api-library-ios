//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation


public class BreinBase {

    // means nothing -> no value
    static let NO_VALUE_DEFINED = ""

    //  contains the User that will be used for the request
    var breinUser: BreinUser?

    //  Configuration
    var breinConfig: BreinConfig!

    //  contains the timestamp when the request will be generated
    var unixTimestamp: NSTimeInterval!

    /// base dictionary
    var baseDic: [String:AnyObject]?

    public init() {
        self.unixTimestamp = 0
    }

    public func setBaseDic(baseDic: [String:AnyObject]) -> BreinBase {
        self.baseDic = baseDic
        return self
    }

    public func getBaseDic() -> [String:AnyObject]!{
        return self.baseDic
    }

    public func getConfig() -> BreinConfig! {
        return breinConfig
    }

    public func setConfig(breinConfig: BreinConfig!) {
        self.breinConfig = breinConfig
    }

    public func getBreinUser() -> BreinUser! {
        return breinUser
    }

    public func setBreinUser(breinUser: BreinUser!) {
        self.breinUser = breinUser
    }

    public func getBreinEngine() -> BreinEngine! {
        return nil == breinConfig ? nil : getConfig().getBreinEngine()
    }

    public func prepareJsonRequest() -> [String: AnyObject]! {
        let timeInterval = NSDate().timeIntervalSince1970
        setUnixTimestamp(timeInterval)
        return [String: AnyObject]()
    }

    // base level data...
    public func prepareBaseRequestData(inout requestData: [String: AnyObject]) {

        if let apiKey = getConfig()?.getApiKey() where !apiKey.isEmpty {
            requestData["apiKey"] = apiKey
        }

        requestData["unixTimestamp"] = getUnixTimestamp()

        // if sign is active
        if isSign() {
            do {
                requestData["signature"] = try self.createSignature()
                requestData["signatureType"] = "HmacSHA256"
            } catch {
                print("not possible to generate signature")
            }
        }

        if let ipAddress = self.getBreinUser().getIpAddress() {
            requestData["ipAddress"] = ipAddress
        }

        if let bMap = self.getBaseDic() {
            if bMap.count > 0 {
                BreinMapUtil.fillMap(bMap, requestStructure: &requestData)
            }
        }
    }

    public func createSignature() throws -> String! {
        return BreinBase.NO_VALUE_DEFINED
    }

    public func getEndPoint() -> String! {
        return BreinBase.NO_VALUE_DEFINED
    }

    public func getUnixTimestamp() -> Int {
        return Int(unixTimestamp)
    }

    public func setUnixTimestamp(unixTimestamp: NSTimeInterval) {
        self.unixTimestamp = unixTimestamp
    }
    
    public func isSign() -> Bool {

        if breinConfig == nil {
            return false
        }

        if breinConfig.getSecret() == nil {
            return false
        }
        return breinConfig.getSecret().characters.count > 0
    }

}
