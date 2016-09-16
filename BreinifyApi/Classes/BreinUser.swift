//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

public class BreinUser {

    //  user email
    var email: String!

    //  user first name
    var firstName: String!

    //  user last name
    var lastName: String!

    //  user date of birth
    var dateOfBirth: String!

    //  user imei number
    var imei: String!

    //  user deviceId
    var deviceId: String!

    //  user sessionId
    var sessionId: String!

    // contains the userAgent in additional part
    var userAgent: String!

    // contains the referrer in additional part
    var referrer: String!

    // contains the url in additional part
    var url: String!

    // contains the url in additional part
    var ipAddress: String!

    // Ctor
    public init(email: String!) {
        setEmail(email)
    }

    public func getEmail() -> String! {
        return email
    }

    public func setEmail(email: String!) -> BreinUser! {
        self.email = email
        return self
    }

    public func getFirstName() -> String! {
        return firstName
    }

    public func setFirstName(firstName: String!) -> BreinUser! {
        self.firstName = firstName
        return self
    }

    public func getLastName() -> String! {
        return lastName
    }

    public func setLastName(lastName: String!) -> BreinUser! {
        self.lastName = lastName
        return self
    }

    public func getDateOfBirth() -> String! {
        return dateOfBirth
    }

    public func setDateOfBirth(month: Int, day: Int, year: Int) -> BreinUser! {

        if case 1 ... 12 = month {
            if case 1 ... 31 = day {
                if case 1900 ... 2100 = year {
                    self.dateOfBirth = "\(month)/\(day)/\(year)"
                }
            }
        }
        return self
    }

    // this will reset the value of dateOfBirth to ""
    public func resetDateOfBirth() {
        self.dateOfBirth = ""
    }

    public func getImei() -> String! {
        return imei
    }

    public func setImei(imei: String!) -> BreinUser! {
        self.imei = imei
        return self
    }

    public func getDeviceId() -> String! {
        return deviceId
    }

    public func setDeviceId(deviceId: String!) -> BreinUser! {
        self.deviceId = deviceId
        return self
    }

    public func getSessionId() -> String! {
        return sessionId
    }

    public func setSessionId(sessionId: String!) -> BreinUser! {
        self.sessionId = sessionId
        return self
    }

    public func setUserAgent(userAgent: String!) -> BreinUser! {
        self.userAgent = userAgent
        return self
    }

    public func getUserAgent() -> String! {
        return userAgent
    }

    public func setReferrer(referrer: String!) -> BreinUser! {
        self.referrer = referrer
        return self
    }

    public func getReferrer() -> String! {
        return referrer
    }

    public func setUrl(url: String!) -> BreinUser! {
        self.url = url
        return self
    }

    public func getUrl() -> String! {
        return url
    }

    public func setIpAddress(ipAddress: String!) -> BreinUser! {
        self.ipAddress = ipAddress
        return self
    }

    public func getIpAddress() -> String! {
        return ipAddress
    }

    public func description() -> String! {
        return (((((((((((((((("BreinUser details: "
                + "\r") + " name: ")
                + (self.firstName == nil ? "n/a" : self.firstName))
                + " ") + (self.lastName == nil ? "n/a" : self.lastName))
                + " email: ") + (self.email == nil ? "n/a" : self.email))
                + " dateOfBirth: ") + (self.dateOfBirth == nil ? "n/a" : self.dateOfBirth))
                + "\r") + " imei: ") + (self.imei == nil ? "n/a" : self.imei))
                + " deviceId: ") + (self.deviceId == nil ? "n/a" : self.deviceId))
                + "\r") + " sessionId: ") + (self.sessionId == nil ? "n/a" : self.sessionId)
    }

}
