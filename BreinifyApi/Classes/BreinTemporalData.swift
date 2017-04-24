//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

open class BreinTemporalData: BreinBase, ISecretStrategy {

    /// The following fields are used within the location
    let kTextField = "text"
    let kLocationField = "location"
    let kLatitudeField = "latitude"
    let kLongitudeField = "longitude"
    
    public func setLocation(key: String, value: AnyObject) -> BreinTemporalData {

        var additionalDic = self.getUser()?.getAdditionalDic()
        if additionalDic == nil {
            let newDic = [String: AnyObject]()
            self.getUser()?.setAdditionalDic(newDic)
            additionalDic = self.getUser()?.getAdditionalDic()
        }
        var hasLocationEntry = additionalDic?[kLocationField]

        if hasLocationEntry == nil {
            var locationDic = [String: AnyObject]()
            locationDic[key] = value as AnyObject?
            additionalDic?[kLocationField] = locationDic as AnyObject?
            self.getUser()?.setAdditional(kLocationField, map: locationDic)
        } else {
            hasLocationEntry = value as AnyObject?
        }

        return self
    }

    @discardableResult
    public func setLocation(freeText: String) -> BreinTemporalData {
        self.setLocation(key: kTextField, value: freeText as AnyObject!)
        return self
    }

    public func setLongitude(_ longitude: Double) -> BreinTemporalData {
        self.setLocation(key: kLongitudeField, value: longitude as AnyObject!)
        return self
    }

    public func setLatitude(_ latitude: Double) -> BreinTemporalData {
        self.setLocation(key: kLatitudeField, value: latitude as AnyObject!)
        return self
    }

    public func setLocalDateTime(_ localDateTime: String) -> BreinTemporalData {
        self.getUser()?.setLocalDateTime(localDateTime)
        return self
    }

    public func setTimezone(_ timezone: String) -> BreinTemporalData {
        self.getUser()?.setTimezone(timezone)
        return self
    }

    // Lookup ip is part of the user.additional section
    public func setLookUpIpAddress(_ ipAddress: String)-> BreinTemporalData {
        self.getUser()?.setIpAddress(ipAddress)
        return self
    }

    public func getLookUpIpAddress() -> String? {
        return self.getUser()?.getIpAddress()
    }
    
    /**
       TemporalData implementation. For a given user (BreinUser) a temporalData request will be performed.

         - parameter breinUser:  contains the breinify user
         - parameter successBlock : A callback function that is invoked in case of success.
         - parameter failureBlock : A callback function that is invoked in case of an error.

         - returns response: from request or null if no data can be retrieved
    */
    public func temporalData(_ breinUser: BreinUser!,
                             success successBlock: @escaping BreinEngine.apiSuccess,
                             failure failureBlock: @escaping BreinEngine.apiFailure) throws {

        if nil == getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        setUser(breinUser)

        return try getBreinEngine()!.performTemporalDataRequest(self,
                success: successBlock,
                failure: failureBlock)
    }

    override public func prepareJsonRequest() -> [String: AnyObject]! {
        // call base class
        super.prepareJsonRequest()

        var requestData = [String: AnyObject]()

        if let breinUser = getUser() {
            var userData = [String: AnyObject]()
            breinUser.prepareUserRequest(&userData, breinConfig: self.getConfig())
            requestData["user"] = userData as AnyObject?
        }

        // base level data...
        self.prepareBaseRequestData(&requestData)

        return requestData
    }

    /**
      Used to create a clone of the temporal data object. This is important in order to prevent
      concurrency issues.

      - returns: the clone of the temporal data object
    */
    public func clone() -> BreinTemporalData {

        // create a new recommendation object
        let clonedBreinTemporalData = BreinTemporalData()

        // clone from base class
        clonedBreinTemporalData.cloneBase(self)

        return clonedBreinTemporalData
    }

    /// contains the temporal data endpoint
    override public func getEndPoint() -> String! {
        return getConfig()?.getTemporalDataEndpoint()
    }

    /**

      Creates the signature for the temporal data secret
      
    */
    public override func createSignature() -> String! {
        let localDateTime = getUser()?.getLocalDateTime()
        let paraLocalDateTime = localDateTime == nil ? "" : localDateTime

        let timezone = getUser()?.getTimezone()
        let paraTimezone = timezone == nil ? "" : timezone

        let message = String(getUnixTimestamp()) +
                "-" +
                paraLocalDateTime! +
                "-" +
                paraTimezone!

        var signature = ""
        do {
            signature = try BreinUtil.generateSignature(message, secret: getConfig()?.getSecret())
        } catch {
            // TODO: throw error ?
            print("Ups: Error while trying to generate signature")
        }

        return signature
    }

}

