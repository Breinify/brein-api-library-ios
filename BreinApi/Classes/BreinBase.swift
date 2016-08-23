//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//


import Foundation

class BreinBase {

    //  contains the User that will be used for the request
    var breinUser: BreinUser!

    //  Configuration
    var breinConfig: BreinConfig!

    //  contains the timestamp when the request will be generated
    var unixTimestamp: NSTimeInterval!

    //  if set to yes then a secret has to bo sent
    var sign: Bool!

    init() {
        self.sign = false
        self.unixTimestamp = 0
    }

    func getConfig() -> BreinConfig! {
        return breinConfig
    }

    func setConfig(breinConfig: BreinConfig!) {
        self.breinConfig = breinConfig
    }

    func getBreinUser() -> BreinUser! {
        return breinUser
    }

    func setBreinUser(breinUser: BreinUser!) {
        self.breinUser = breinUser
    }

    func getBreinEngine() -> BreinEngine! {
        return nil == breinConfig ? nil : getConfig().getBreinEngine()
    }

    func prepareJsonRequest() -> [String: AnyObject]! {
        let timeInterval = NSDate().timeIntervalSince1970
        setUnixTimestamp(timeInterval)
        return [String: AnyObject]()
    }

    func getEndPoint() -> String! {
        return ""
    }

    func getUnixTimestamp() -> Int {
        return Int(unixTimestamp)
    }

    func setUnixTimestamp(unixTimestamp: NSTimeInterval) {
        self.unixTimestamp = unixTimestamp
    }

    func isSign() -> Bool {
        return sign
    }

    func setSign(sign: Bool) {
        self.sign = sign
    }

}
