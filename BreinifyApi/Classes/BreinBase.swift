//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

public class BreinBase {

    //  contains the User that will be used for the request
    var breinUser: BreinUser?

    //  Configuration
    var breinConfig: BreinConfig!

    //  contains the timestamp when the request will be generated
    var unixTimestamp: NSTimeInterval!

    //  if set to yes then a secret has to bo sent
    var sign: Bool!

    public init() {
        self.sign = false
        self.unixTimestamp = 0
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

}
