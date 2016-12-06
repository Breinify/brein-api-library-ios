//
// Created by Marco Recchioni
// Copyright (c) 2016 Breinify. All rights reserved.
//

import Foundation

public class BreinUserRequest {

    var additional = [String: AnyObject]()

    var userMap = [String: AnyObject]()

    public func setUserMap(extraUserMap: [String: AnyObject]) {
        self.userMap = extraUserMap
    }

    public func getUserMap() -> [String: AnyObject] {
        return userMap
    }

    public func setAdditional(userAdditionalMap: [String: AnyObject]) {
        self.additional = userAdditionalMap
    }

    public func getAdditional() -> [String: AnyObject] {
        return additional
    }

    public func prepareUserRequestData(breinBase: BreinBase, inout request: [String: AnyObject], breinUser: BreinUser) {

        var userData = [String: AnyObject]()

        // Execute the functions and add it to userData
        executeUserMapFunctions(breinUser, requestMap: &userData)

        // check if there are further extra maps to add on user level
        if userMap.count > 0 {
            BreinMapUtil.fillMap(userMap, requestStructure: &userData)
        }

        var additional = [String: AnyObject]()

        // Execute the functions and add it to userData
        executeAdditionalMapFunctions(breinBase, breinUser: breinUser, requestMap: &additional)

        // check if there are further extra maps to add on user additional level
        if additional.count > 0 {
            BreinMapUtil.fillMap(additional, requestStructure: &additional)
        }

        if (additional.count > 0) {
            userData["additional"] = additional
        }

        // add the data
        request["user"] = userData
    }


    public func executeUserMapFunctions(breinUser: BreinUser, inout requestMap: [String: AnyObject]) {

        if let email = breinUser.getEmail() {
            requestMap["email"] = email
        }

        if let firstName = breinUser.getFirstName() {
            requestMap["firstName"] = firstName
        }

        if let lastName = breinUser.getLastName() {
            requestMap["lastName"] = lastName
        }

        if let dateOfBirth = breinUser.getDateOfBirth() {
            requestMap["dateOfBirth"] = dateOfBirth
        }

        if let imei = breinUser.getImei() {
            requestMap["imei"] = imei
        }

        if let deviceId = breinUser.getDeviceId() {
            requestMap["deviceId"] = deviceId
        }

        if let sessionId = breinUser.getSessionId() {
            requestMap["sessionId"] = sessionId
        }
    }


    public func executeAdditionalMapFunctions(breinBase: BreinBase, breinUser: BreinUser, inout requestMap: [String: AnyObject]) {

        // check if an userAgent has been set, if not build one
        if let userAgent = breinUser.getUserAgent() where !userAgent.isEmpty {
            requestMap["userAgent"] = userAgent
        } else {
            // create userAgent
            let breinConfig = breinBase.getConfig()
            if let generatedUserAgent = breinConfig.getBreinEngine()?.getUserAgent() {
                requestMap["userAgent"] = generatedUserAgent
            }
        }

        if let referrer = breinUser.getReferrer() {
            requestMap["referrer"] = referrer
        }

        if let url = breinUser.getUrl() {
            requestMap["url"] = url
        }

        if let localDateTime = breinUser.getLocalDateTime() {
            requestMap["localDateTime"] = localDateTime
        }

        if let timezone = breinUser.getTimezone() {
            requestMap["timezone"] = timezone
        }

        // location data
        // TODO: check how to react if the location is set via map
        if let locationData = breinBase.getLocationData() {
            // only a valid location will be taken into consideration
            // this is the case when the coordinates are different from 0
            if locationData.coordinate.latitude != 0 {
                var locData = [String: AnyObject]()
                locData["accuracy"] = locationData.horizontalAccuracy
                locData["latitude"] = locationData.coordinate.latitude
                locData["longitude"] = locationData.coordinate.longitude
                locData["speed"] = locationData.speed

                requestMap["location"] = locData
            }
        }
    }
}