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

    // Ctor
    init(email: String!) {
        setEmail(email)
    }

    func getEmail() -> String! {
        return email
    }

    func setEmail(email: String!) -> BreinUser! {
        self.email = email
        return self
    }

    func getFirstName() -> String! {
        return firstName
    }

    func setFirstName(firstName: String!) -> BreinUser! {
        self.firstName = firstName
        return self
    }

    func getLastName() -> String! {
        return lastName
    }

    func setLastName(lastName: String!) -> BreinUser! {
        self.lastName = lastName
        return self
    }

    func getDateOfBirth() -> String! {
        return dateOfBirth
    }

    func setDateOfBirth(month: Int, day: Int, year: Int) -> BreinUser! {

        if case 1...12 = month {
            if case 1...31 = day {
                if case 1900...2100 = year {
                    self.dateOfBirth = "\(month)/\(day)/\(year)"
                }
            }
        }

        return self
    }

    func setDateOfBirth(dateOfBirth: String!) -> BreinUser! {
        self.dateOfBirth = dateOfBirth
        return self
    }

    func getImei() -> String! {
        return imei
    }

    func setImei(imei: String!) -> BreinUser! {
        self.imei = imei
        return self
    }

    func getDeviceId() -> String! {
        return deviceId
    }

    func setDeviceId(deviceId: String!) -> BreinUser! {
        self.deviceId = deviceId
        return self
    }

    func getSessionId() -> String! {
        return sessionId
    }

    func setSessionId(sessionId: String!) -> BreinUser! {
        self.sessionId = sessionId
        return self
    }

    func description() -> String! {
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
