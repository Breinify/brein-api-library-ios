//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import Foundation

open class BreinTemporalData: BreinBase, ISecretStrategy {

    /// The following fields are used within the location
    let kTextField = "text"
    let kLocationField = "location"
    let kLatitudeField = "latitude"
    let kLongitudeField = "longitude"
    let kShapeTypesField = "shapeTypes"

    public func setLocation(key: String, value: AnyObject) -> BreinTemporalData {
        _ = self.getUser()?.setAdditionalLocationEntry(key: key, value: value)
        return self
    }

    @discardableResult
    public func setLocation(freeText: String) -> BreinTemporalData {
        _ = self.setLocation(key: kTextField, value: freeText as AnyObject)
        return self
    }

    public func setLongitude(_ longitude: Double) -> BreinTemporalData {
        _ = self.setLocation(key: kLongitudeField, value: longitude as AnyObject)
        return self
    }

    public func setLatitude(_ latitude: Double) -> BreinTemporalData {
        _ = self.setLocation(key: kLatitudeField, value: latitude as AnyObject)
        return self
    }

    public func setLocalDateTime(_ localDateTime: String) -> BreinTemporalData {
        _ = self.getUser()?.setLocalDateTime(localDateTime)
        return self
    }

    public func setTimezone(_ timezone: String) -> BreinTemporalData {
        _ = self.getUser()?.setTimezone(timezone)
        return self
    }

    // Lookup ip is part of the user.additional section
    public func setLookUpIpAddress(_ ipAddress: String) -> BreinTemporalData {
        _ = self.getUser()?.setIpAddress(ipAddress)
        return self
    }

    public func getLookUpIpAddress() -> String? {
        self.getUser()?.getIpAddress()
    }

    /**
     * Adds the specified {@code shapeTypes} to the currently defined shape-types to be returned with the response of
     * the request, i.e.:
     * <p>
     * <pre>
     *     {
     *         user: {
     *              additional: {
     *                  location: {
     *                      'shapeTypes': [...]
     *                  }
     *              }
     *         }
     *     }
     * </pre>
     *
     * @param shapeTypes the shapeTypes to be added
     *
     * @return {@code this}
     */
    public func addShapeTypes(_ shapeTypes: [String]) -> BreinTemporalData {
        if shapeTypes.count > 0 {
            _ = self.setLocation(key: kShapeTypesField, value: shapeTypes as AnyObject)
        }
        return self
    }

/**
   TemporalData implementation. For a given user (BreinUser) a temporalData request will be performed.

     - parameter breinUser:  contains the breinify user
     - parameter success:    A callback function that is invoked in case of success.
     - parameter failure:    A callback function that is invoked in case of an error.

     - returns response: from request or null if no data can be retrieved
*/
    public func temporalData(_ breinUser: BreinUser!,
                             _ success: @escaping BreinEngine.apiSuccess = { _ in
                             },
                             _ failure: @escaping BreinEngine.apiFailure = { _ in
                             }) throws {

        if nil == getBreinEngine() {
            throw BreinError.BreinRuntimeError("Rest engine not initialized. You have to configure BreinConfig with a valid engine")
        }

        setUser(breinUser)

        return try getBreinEngine()!.performTemporalDataRequest(self,
                success: success,
                failure: failure)
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
            BreinLogger.shared.log("Ups: Error while trying to generate signature")
        }

        return signature
    }
}
