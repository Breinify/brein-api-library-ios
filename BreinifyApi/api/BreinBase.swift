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
        unixTimestamp = 0
    }

    public init(user: BreinUser) {
        unixTimestamp = 0
        breinUser = user
    }

    @discardableResult
    public func setBaseDic(_ baseDic: [String: Any]) -> BreinBase {
        self.baseDic = baseDic
        return self
    }

    public func getBaseDic() -> [String: Any]? {
        baseDic
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
            ipAddress = ipAdr
        }
        return self
    }

    /// IpAddress for base level
    public func getIpAddress() -> String? {
        ipAddress
    }

    public func getBreinEngine() -> BreinEngine? {
        getConfig()?.getBreinEngine()
    }

    public func getSuccessBlock() -> BreinBase.apiSuccess? {
        successBlock
    }

    @discardableResult
    public func setSuccessBlock(_ success: @escaping BreinBase.apiSuccess) -> BreinBase {
        successBlock = success
        return self
    }

    public func getFailureBlock() -> BreinBase.apiFailure? {
        failureBlock
    }

    @discardableResult
    public func setFailureBlock(_ failure: @escaping BreinBase.apiFailure) -> BreinBase {
        failureBlock = failure
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
                requestData["signature"] = try createSignature() as Any?
                requestData["signatureType"] = "HmacSHA256" as Any?
            } catch {
                BreinLogger.shared.log("Breinify not possible to generate signature")
            }
        }

        // check if an ip address has been set or if it should be detected
        /*
        if let ipAddress = BreinUtil.containsValue(getIpAddress()!) {
            requestData["ipAddress"] = ipAddress as Any?
        } else {
            // detect ip
            let ip = BreinUtil.detectIpAddress()
            if ip.count > 0 {
                requestData["ipAddress"] = ip as Any?
            }
        }
         */

        if let bMap = getBaseDic() {
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
        setIpAddress(source.getIpAddress());
        unixTimestamp = source.unixTimestamp

        // callback_s
        if let suc = source.getSuccessBlock() {
            setSuccessBlock(suc)
        }

        if let fail = source.getFailureBlock() {
            setFailureBlock(fail)
        }

        // configuration
        setConfig(source.getConfig());

        // clone user
        if let sourceUser = source.getUser() {
            let clonedUser = BreinUser.clone(sourceUser);
            setUser(clonedUser);
        }

        // clone maps
        if let clonedBaseDic = source.getBaseDic() {
            setBaseDic(clonedBaseDic)
        }
    }

    func clear() {
        unixTimestamp = 0
        ipAddress = ""
        baseDic?.removeAll()
    }
}
