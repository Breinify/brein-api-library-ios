//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation


open class BreinBase {

    public typealias apiSuccess = (_ result: BreinResult) -> Void
    public typealias apiFailure = (_ error: NSDictionary) -> Void

    // means nothing -> no value
    static let kNoValueDefined = ""

    //  contains the User that will be used for the request
    var breinUser = BreinUser()

    // contains the ipAddress for base level
    var ipAddress: String = ""

    //  Configuration
    var breinConfig: BreinConfig?

    //  contains the timestamp when the request will be generated
    var unixTimestamp: TimeInterval!

    /// base dictionary
    var baseDic: [String: AnyObject]?

    /// contains block invoked in case of success
    var successBlock: BreinBase.apiSuccess?

    /// contains block invoked in case of failure
    var failureBlock: BreinBase.apiFailure?

    public init() {
        self.unixTimestamp = 0
    }

    public init(user: BreinUser) {
        self.unixTimestamp = 0
        self.breinUser = user
    }

    @discardableResult
    public func setBaseDic(_ baseDic: [String: AnyObject]) -> BreinBase {
        self.baseDic = baseDic
        return self
    }

    public func getBaseDic() -> [String: AnyObject]? {
        return self.baseDic
    }

    public func getConfig() -> BreinConfig! {
        return breinConfig
    }

    public func setConfig(_ breinConfig: BreinConfig!) {
        self.breinConfig = breinConfig
    }

    public func getUser() -> BreinUser? {
        return breinUser
    }

    public func setUser(_ breinUser: BreinUser!) {
        self.breinUser = breinUser
    }

    /// IpAddress for base level
    @discardableResult
    public func setIpAddress(_ ipAddressPara: String?) -> BreinBase {
        if let ipAdr = ipAddressPara {
            self.ipAddress = ipAdr
        }
        return self
    }

    /// IpAddress for base level
    public func getIpAddress() -> String? {
        return self.ipAddress
    }

    public func getBreinEngine() -> BreinEngine? {
        return self.getConfig()?.getBreinEngine()
    }

    public func getSuccessBlock() -> BreinBase.apiSuccess? {
        return successBlock
    }

    @discardableResult
    public func setSuccessBlock(_ success: @escaping BreinBase.apiSuccess) -> BreinBase {
        self.successBlock = success
        return self
    }

    public func getFailureBlock() -> BreinBase.apiFailure? {
        return failureBlock
    }

    @discardableResult
    public func setFailureBlock(_ failure: @escaping BreinBase.apiFailure) -> BreinBase {
        self.failureBlock = failure
        return self
    }

    @discardableResult
    public func prepareJsonRequest() -> [String: AnyObject]! {
        let timeInterval = NSDate().timeIntervalSince1970
        setUnixTimestamp(timeInterval)
        return [String: AnyObject]()
    }

    // prepares the map on base level for the json request
    public func prepareBaseRequestData(_ requestData: inout [String: AnyObject]) {

        if let apiKey = getConfig()?.getApiKey(), !apiKey.isEmpty {
            requestData["apiKey"] = apiKey as AnyObject?
        }

        requestData["unixTimestamp"] = getUnixTimestamp() as AnyObject?

        // if sign is active
        if isSign() {
            do {
                requestData["signature"] = try self.createSignature() as AnyObject?
                requestData["signatureType"] = "HmacSHA256" as AnyObject?
            } catch {
                print("not possible to generate signature")
            }
        }

        // check if an ip has been set or if it should be detected
        if let ipAddress = BreinUtil.containsValue(self.getIpAddress()!) {
            requestData["ipAddress"] = ipAddress as AnyObject?
        } else {
            // detect ip
            let ip = BreinUtil.detectIpAddress()
            if ip.characters.count > 0 {
                requestData["ipAddress"] = ip as AnyObject?
            }
        }

        if let bMap = self.getBaseDic() {
            if bMap.count > 0 {
                BreinMapUtil.fillMap(bMap, requestStructure: &requestData)
            }
        }
    }

    /// empty -> needs to be implemented by subclass
    public func createSignature() throws -> String! {
        return BreinBase.kNoValueDefined
    }

    /// empty -> needs to be implemented by subclass
    public func getEndPoint() -> String! {
        return BreinBase.kNoValueDefined
    }

    /// returns the unixtimestamp (as part of the request)
    public func getUnixTimestamp() -> Int {
        return Int(unixTimestamp)
    }

    /// sets the unixtimestamp
    public func setUnixTimestamp(_ unixTimestamp: TimeInterval) {
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

        return (breinConfig?.getSecret().characters.count)! > 0
    }

    /**
    * Clones from base class
    *
    * @param source to clone from
    */
    public func cloneBase(_ source: BreinBase) {

        // set further data...
        self.setIpAddress(source.getIpAddress());
        self.unixTimestamp = source.unixTimestamp

        // callback_s
        if let suc = source.getSuccessBlock() {
            self.setSuccessBlock(suc)
        }

        if let fail = source.getFailureBlock() {
            self.setFailureBlock(fail)
        }

        // configuration
        self.setConfig(source.getConfig());

        // clone user
        if let sourceUser = source.getUser() {
            let clonedUser = BreinUser.clone(sourceUser);
            self.setUser(clonedUser);
        }

        // clone maps
        if let clonedBaseDic = source.getBaseDic() {
            self.setBaseDic(clonedBaseDic)
        }
    }
}
