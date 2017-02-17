//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation


public class BreinBase {

    public typealias apiSuccess = (result: BreinResult?) -> Void
    public typealias apiFailure = (error: NSDictionary?) -> Void

    // means nothing -> no value
    static let NO_VALUE_DEFINED = ""

    //  contains the User that will be used for the request
    var breinUser: BreinUser?

    // contains the ipAddress
    var ipAddress: String = ""

    //  Configuration
    var breinConfig: BreinConfig?

    //  contains the timestamp when the request will be generated
    var unixTimestamp: NSTimeInterval!

    /// base dictionary
    var baseDic: [String: AnyObject]?

    /// contains block invoked in case of success
    var successBlock: BreinBase.apiSuccess?

    /// contains block invoked in case of failure
    var failureBlock: BreinBase.apiFailure?

    public init() {
        self.unixTimestamp = 0
    }

    public func setBaseDic(baseDic: [String: AnyObject]) -> BreinBase {
        self.baseDic = baseDic
        return self
    }

    public func getBaseDic() -> [String: AnyObject]? {
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

    public func setIpAddress(ipAddressPara: String?) -> BreinBase {
        if let ipAdr = ipAddressPara {
            self.ipAddress = ipAdr
        }
        return self
    }

    public func getIpAddress() -> String? {
        return self.ipAddress
    }

    public func getBreinEngine() -> BreinEngine? {
        return self.getConfig()?.getBreinEngine()
    }

    public func getSuccessBlock() -> BreinBase.apiSuccess? {
        return successBlock
    }

    public func setSuccessBlock(success: BreinBase.apiSuccess?) -> BreinBase {
        if let sucBlock = success {
            self.successBlock = sucBlock
        }
        return self
    }

    public func getFailureBlock() -> BreinBase.apiFailure? {
        return failureBlock
    }

    public func setFailureBlock(failure: BreinBase.apiFailure?) -> BreinBase {
        if let faiBlock = failure {
            self.failureBlock = faiBlock
        }
        return self
    }

    public func prepareJsonRequest() -> [String: AnyObject]! {
        let timeInterval = NSDate().timeIntervalSince1970
        setUnixTimestamp(timeInterval)
        return [String: AnyObject]()
    }

    // prepares the map on base level for the json request
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

    /// empty -> needs to be implemented by subclass
    public func createSignature() throws -> String! {
        return BreinBase.NO_VALUE_DEFINED
    }

    /// empty -> needs to be implemented by subclass
    public func getEndPoint() -> String! {
        return BreinBase.NO_VALUE_DEFINED
    }

    /// returns the unixtimestamp (as part of the request)
    public func getUnixTimestamp() -> Int {
        return Int(unixTimestamp)
    }

    /// sets the unixtimestamp
    public func setUnixTimestamp(unixTimestamp: NSTimeInterval) {
        self.unixTimestamp = unixTimestamp
    }

    /// detects if message should be sent in 'sing' mode
    public func isSign() -> Bool {

        if breinConfig == nil {
            return false
        }

        if breinConfig?.getSecret() == nil {
            return false
        }
        
        return breinConfig?.getSecret().characters.count > 0
    }
    
    /**
    * Clones from base class
    *
    * @param source to clone from
    */
    public func cloneBase(source: BreinBase) {

        // set further data...
        self.setIpAddress(source.getIpAddress());
        self.unixTimestamp = source.unixTimestamp

        // callback_s
        self.setSuccessBlock(source.getSuccessBlock())
        self.setFailureBlock(source.getFailureBlock())

        // configuration
        self.setConfig(source.getConfig());

        // clone user
        let clonedUser = BreinUser.clone(source.getBreinUser());
        self.setBreinUser(clonedUser);

        // clone maps
        if let clonedBaseDic = source.getBaseDic() {
            self.setBaseDic(clonedBaseDic)
        }
    }
}
