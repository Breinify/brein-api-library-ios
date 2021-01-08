//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class BreinBase: NSObject {

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
    var baseDic: [String: Any]?

    /// contains block invoked in case of success
    var successBlock: BreinBase.apiSuccess?

    /// contains block invoked in case of failure
    var failureBlock: BreinBase.apiFailure?

    override
    public init() {
        self.unixTimestamp = 0
    }

    public init(user: BreinUser) {
        self.unixTimestamp = 0
        self.breinUser = user
    }

    @discardableResult
    public func setBaseDic(_ baseDic: [String: Any]) -> BreinBase {
        self.baseDic = baseDic
        return self
    }

    public func getBaseDic() -> [String: Any]? {
        self.baseDic
    }

    public func getConfig() -> BreinConfig! {
        breinConfig
    }

    public func setConfig(_ breinConfig: BreinConfig!) {
        self.breinConfig = breinConfig
    }

    public func getUser() -> BreinUser? {
        breinUser
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
        self.ipAddress
    }

    public func getBreinEngine() -> BreinEngine? {
        self.getConfig()?.getBreinEngine()
    }

    public func getSuccessBlock() -> BreinBase.apiSuccess? {
        successBlock
    }

    @discardableResult
    public func setSuccessBlock(_ success: @escaping BreinBase.apiSuccess) -> BreinBase {
        self.successBlock = success
        return self
    }

    public func getFailureBlock() -> BreinBase.apiFailure? {
        failureBlock
    }

    @discardableResult
    public func setFailureBlock(_ failure: @escaping BreinBase.apiFailure) -> BreinBase {
        self.failureBlock = failure
        return self
    }

    @discardableResult
    public func prepareJsonRequest() -> [String: Any]! {
        // in case the unixtimestamp has already been set
        let timeStamp = getUnixTimestamp()
        if timeStamp == 0 {
            let timeInterval = NSDate().timeIntervalSince1970
            setUnixTimestamp(timeInterval)
        }

        return [String: Any]()
    }

    // prepares the map on base level for the json request
    public func prepareBaseRequestData(_ requestData: inout [String: Any]) {

        if let apiKey = getConfig()?.getApiKey(), !apiKey.isEmpty {
            requestData["apiKey"] = apiKey as Any?
        }

        requestData["unixTimestamp"] = getUnixTimestamp() as Any?

        // if sign is active
        if isSign() {
            do {
                requestData["signature"] = try self.createSignature() as Any?
                requestData["signatureType"] = "HmacSHA256" as Any?
            } catch {
                BreinLogger.shared.log("not possible to generate signature")
            }
        }

        // check if an ip address has been set or if it should be detected
        if let ipAddress = BreinUtil.containsValue(self.getIpAddress()!) {
            requestData["ipAddress"] = ipAddress as Any?
        } else {
            // detect ip
            let ip = BreinUtil.detectIpAddress()
            if ip.count > 0 {
                requestData["ipAddress"] = ip as Any?
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
        BreinBase.kNoValueDefined
    }

    /// empty -> needs to be implemented by subclass
    public func getEndPoint() -> String! {
        BreinBase.kNoValueDefined
    }

    /// returns the unixtimestamp (as part of the request)
    public func getUnixTimestamp() -> Int {
        Int(unixTimestamp)
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

        return (breinConfig?.getSecret().count)! > 0
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
