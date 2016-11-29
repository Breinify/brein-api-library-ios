//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation
import CoreLocation

public class BreinBase {

    //  contains the User that will be used for the request
    var breinUser: BreinUser!

    //  Configuration
    var breinConfig: BreinConfig!

    //  contains the timestamp when the request will be generated
    var unixTimestamp: NSTimeInterval!

    // private final BreinBaseRequest breinBaseRequest = new BreinBaseRequest();
    var breinBaseRequest = BreinBaseRequest()

    // location coordinates
    var locationData: CLLocation?

    //  if set to yes then a secret has to bo sent
    var sign: Bool!

    public init() {
        self.sign = false
        self.unixTimestamp = 0
    }

    public func setLocationData(locationData: CLLocation?) -> BreinBase {
        self.locationData = locationData
        return self
    }

    public func getLocationData() -> CLLocation? {
        return locationData
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

    public func getBreinBaseRequest() -> BreinBaseRequest! {
        return breinBaseRequest
    }

    public func prepareJsonRequest() -> [String: AnyObject]! {
        let timeInterval = NSDate().timeIntervalSince1970
        setUnixTimestamp(timeInterval)
        return [String: AnyObject]()
    }

    public func getEndPoint() -> String! {
        return ""
    }

    public func getUnixTimestamp() -> Int {
        return Int(unixTimestamp)
    }

    public func setUnixTimestamp(unixTimestamp: NSTimeInterval) {
        self.unixTimestamp = unixTimestamp
    }

    public func isSign() -> Bool {
        return sign
    }

    public func setSign(sign: Bool) {
        self.sign = sign
    }

    /// needs to be implemented by sub-classes
    public func createSignature() -> String {
        return ""
    }

}
