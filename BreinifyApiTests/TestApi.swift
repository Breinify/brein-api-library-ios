//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import UIKit
import XCTest
@testable import BreinifyApi

class TestApi: XCTestCase {

    typealias apiSuccess = (_ result: BreinResult) -> Void
    typealias apiFailure = (_ error: NSDictionary) -> Void

    let baseUrl = "https://api.breinify.com"

    let validApiKeyWithSecret = "CA8A-8D28-3408-45A8-8E20-8474-06C0-8548"
    let validSecret = "lmcoj4k27hbbszzyiqamhg=="

    var breinUser = BreinUser(email: "toni.maroni@email.me")
    let breinCategory = "home"
    var breinConfig: BreinConfig!

    override func setUp() {
        super.setUp()

        breinConfig = BreinConfig(validApiKeyWithSecret,
                secret: validSecret)

        // set configuration
        Breinify.setConfig(breinConfig)
    }

    override func tearDown() {
        let when = DispatchTime.now() + 15 // wait 15 seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            Breinify.shutdown()
            super.tearDown()
        }
    }

    // test case how to use the activity api with secret
    func testLoginWithSecret() {

        let successBlock: apiSuccess = {
            (result: BreinResult) -> Void in
            print("Api Success : result is: \(result)")
        }

        let failureBlock: apiFailure = {
            (error: NSDictionary) -> Void in
            XCTFail("Api Failure : error is: \(error)")
        }

        // set additional user information
        breinUser.setFirstName("Fred")
                .setLastName("Firestone")

        // invoke activity call
        do {
            try Breinify.activity(breinUser,
                    activityType: "login",
                    "home",
                    "Login-Description",
                    successBlock,
                    failureBlock)
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }
    }

    // test case how to use the activity api with secret
    func testLoginWithSecretWithoutCallbacks() {

        let successBlock: apiSuccess = {
            (result: BreinResult) -> Void in
            print("Api Success : result is: \(result)")
        }

        let failureBlock: apiFailure = {
            (error: NSDictionary) -> Void in
            XCTFail("Api Failure : error is: \(error)")
        }

        // set additional user information
        breinUser.setFirstName("Fred")
                .setLastName("Firestone")

        // invoke activity call
        do {
            try Breinify.activity(breinUser,
                    activityType: "login",
                    "home",
                    "Login-Description")
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }
    }

    // test case how to use the activity api
    func testLogin() {

        let successBlock: apiSuccess = {
            (result: BreinResult) -> Void in
            print("Api Success : result is: \(result)")
        }
        let failureBlock: apiFailure = {
            (error: NSDictionary) -> Void in
            XCTFail("Error is: \(error)")
        }

        // set additional user information
        breinUser.setFirstName("Marco")
                .setLastName("Recchioni")

        // invoke activity call
        do {
            try Breinify.activity(breinUser,
                    activityType: "login",
                    "home",
                    "Login-Description",
                    successBlock,
                    failureBlock)
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }

        print("Test finished")
    }

    // test case how to use the activity api
    func testLoginWithExtraMaps() {

        let successBlock: apiSuccess = {
            (result: BreinResult) -> Void in
            print("Api Success : result is: \(result)")
        }
        let failureBlock: apiFailure = {
            (error: NSDictionary) -> Void in
            XCTFail("Error is: \(error)")
        }

        // set additional user information
        breinUser.setFirstName("Marco")
                .setLastName("Recchioni")

        // add base dic
        var baseDic = [String: Any]()
        baseDic["baseOne"] = "valueOfBaseOne" as AnyObject
        baseDic["baseTwo"] = "valueOfBaseTwo" as AnyObject

        // add activity dic
        var activityDic = [String: Any]()
        activityDic["activityOne"] = "valueOfActivityOne" as AnyObject
        activityDic["activityTwo"] = "valueOfActivityTwo" as AnyObject

        // add user dic
        var userDic = [String: Any]()
        userDic["userOne"] = "valueOfUserOne" as AnyObject
        userDic["userTwo"] = "valueOfUserTwo" as AnyObject

        // add user additional dic
        var userAdditionalDic = [String: Any]()
        userAdditionalDic["userAdditionalOne"] = "valueOfUserAdditionalOne" as AnyObject
        userAdditionalDic["userAdditionalTwo"] = "valueOfUserAdditionalTwo" as AnyObject

        breinUser.setUserDic(userDic)
        breinUser.setAdditionalDic(userAdditionalDic)

        // invoke activity call
        do {
            if let breinActivity = Breinify.getBreinActivity() {

                breinActivity.setBaseDic(baseDic)
                breinActivity.setActivityDic(activityDic)

                try Breinify.activity(breinActivity,
                        user: breinUser,
                        activityType: String.login,
                        String.home,
                        "Login-Description",
                        successBlock,
                        failureBlock)
            }
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }

        print("Test finished")
    }

    func testSendActivityWithActivity() {

        let breinUser = Breinify.getBreinUser()

        // add user dic
        var userDic = [String: Any]()
        userDic["userOne"] = "valueOfUserOne" as Any
        userDic["userTwo"] = "valueOfUserTwo" as Any
        breinUser.setUserDic(userDic)

        let breinActivity = Breinify.getBreinActivity()
        // add activity dic
        var activityDic = [String: Any]()
        activityDic["activityOne"] = "valueOfActivityOne" as Any
        activityDic["activityTwo"] = "valueOfActivityTwo" as Any

        breinActivity?.setActivityDic(activityDic)

        // add user additional dic
        var userAdditionalDic = [String: Any]()
        userAdditionalDic["userAdditionalOne"] = "valueOfUserAdditionalOne" as Any
        userAdditionalDic["userAdditionalTwo"] = "valueOfUserAdditionalTwo" as Any
        breinUser.setAdditionalDic(userAdditionalDic)

        if breinActivity != nil {
            Breinify.sendActivity(breinActivity!)
        }

    }

    // testcase how to use the activity api
    func testPageVisitWithTags() {

        let successBlock: apiSuccess = {
            (result: BreinResult) -> Void in
            print("Api Success : result is: \(result)")

        }
        let failureBlock: apiFailure = {
            (error: NSDictionary) -> Void in
            XCTFail("Error is: \(error)")
        }

        // set additional user information
        breinUser.setFirstName("Marco")
                .setLastName("Recchioni")
                .setIpAddress("10.11.12.130")
                .setUrl("http://sample.com")

        let tagsDic: [String: Any] = ["A": "STRING" as AnyObject,
                                            "B": 100 as AnyObject,
                                            "C": 2.22 as Any]

        if let breinActivity = Breinify.getBreinActivity() {
            breinActivity.setTagsDic(tagsDic)

            // invoke activity call
            do {
                try Breinify.activity(breinUser,
                        activityType: "login",
                        "home",
                        "Login-Description",
                        successBlock,
                        failureBlock)
            } catch {
                XCTFail("Error is: \(error.localizedDescription)")
            }

            print("Test finished")
        }
    }

    //
    // Test lookup functionality
    //
    func testLookup() {

        let dimensions: [String] = ["firstname", "gender", "age", "agegroup", "digitalfootprint", "images"]
        let breinDimension = BreinDimension(dimensionFields: dimensions)

        let failureBlock: apiFailure = {
            (error: NSDictionary) -> Void in
            XCTFail("Api Failure : error is: \(error)")
        }
        let successBlock: apiSuccess = {
            (result: BreinResult) -> Void in
            print("Api Success : result is: \(result)")

            if let dataFirstname = result.get("firstname") {
                print("Firstname is: \(dataFirstname)")
            }

            if let dataGender = result.get("gender") {
                print("Gender is: \(dataGender)")
            }

            if let dataAge = result.get("age") {
                print("Age is: \(dataAge)")
            }

            if let dataAgeGroup = result.get("agegroup") {
                print("AgeGroup is: \(dataAgeGroup)")
            }

            if let dataDigitalFootprinting = result.get("digitalfootprinting") {
                print("DigitalFootprinting is: \(dataDigitalFootprinting)")
            }

            if let dataImages = result.get("images") {
                print("DataImages is: \(dataImages)")
            }
        }

        do {
            try Breinify.lookup(breinUser,
                    dimension: breinDimension,
                    successBlock,
                    failureBlock)
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }
    }

    //
    // Test recommendation functionality
    //
    func testRecommendation() {

        let failureBlock: apiFailure = {
            (error: NSDictionary) -> Void in
            XCTFail("Api Failure : error is: \(error)")
        }

        let successBlock: apiSuccess = {
            (result: BreinResult) -> Void in
            print("Api Success : result is:\n \(result)")
        }

        do {
            let breinRecommendation = BreinRecommendation(breinUser: breinUser)
            breinRecommendation.setNumberOfRecommendations(5)
                    .setCategory("SampleCat")

            try Breinify.recommendation(breinRecommendation,
                    successBlock,
                    failureBlock)
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }
    }

    //
    // Test temporalData functionality
    //
    func testTemporalData() {

        let failureBlock: apiFailure = {
            (error: NSDictionary) -> Void in
            XCTFail("Api Failure : error is: \(error)")
        }
        let successBlock: apiSuccess = {
            (result: BreinResult) -> Void in
            print("Api Success : result is: \(result)")

            if let holiday = result.get("holidays") {
                print("Holiday is: \(holiday)")
            }
            if let weather = result.get("weather") {
                print("Weather is: \(weather)")
            }
            if let location = result.get("location") {
                print("Location is: \(location)")
            }
            if let time = result.get("time") {
                print("Time is: \(time)")
            }
        }

        do {
            let user = BreinUser(email: "fred.firestone@email.com")
                    .setFirstName("Fred")
                    .setIpAddress("74.115.209.58")
                    .setTimezone("America/Los_Angeles")
                    .setLocalDateTime("Sun Dec 25 2016 18:15:48 GMT-0800 (PST)")

            try Breinify.temporalData(user,
                    successBlock,
                    failureBlock)
        } catch {
            XCTFail("error")
        }

    }

    func testTemporalDataWithAdditionalMap() {

        let failureBlock: apiFailure = {
            (error: NSDictionary) -> Void in
            XCTFail("Api Failure : error is: \(error)")
        }
        let successBlock: apiSuccess = {
            (result: BreinResult) -> Void in
            print("Api Success : result is: \(result)")

            if let holiday = result.get("holidays") {
                print("Holiday is: \(holiday)")
            }
            if let weather = result.get("weather") {
                print("Weather is: \(weather)")
            }
            if let location = result.get("location") {
                print("Location is: \(location)")
            }
            if let time = result.get("time") {
                print("Time is: \(time)")
            }
        }

        do {
            // create dictionary here...
            var locationAdditionalMap = [String: Any]()
            var locationValueMap = [String: Any]()
            let valueLatitude = drand48() * 10.0 + 39.0 - 5.0
            let valueLongitude = drand48() * 50.0 - 98.0 - 25.0

            locationValueMap["latitude"] = valueLatitude as AnyObject
            locationValueMap["longitude"] = valueLongitude as AnyObject
            locationAdditionalMap["location"] = locationValueMap as AnyObject

            let user = BreinUser(email: "fred.firestone@email.com")
                    .setFirstName("Fred")
                    .setIpAddress("74.115.209.58")
                    .setAdditionalDic(locationAdditionalMap)

            try Breinify.temporalData(user,
                    successBlock,
                    failureBlock)
        } catch {
            XCTFail("Error")
        }
    }

    func testTemporalDataWithSimpleAdditionalMap() {

        let failureBlock: apiFailure = {
            (error: NSDictionary) -> Void in
            XCTFail("Api Failure : error is: \(error)")
        }
        let successBlock: apiSuccess = {
            (result: BreinResult) -> Void in
            print("Api Success : result is: \(result)")

            if let holiday = result.get("holidays") {
                print("Holiday is: \(holiday)")
            }
            if let weather = result.get("weather") {
                print("Weather is: \(weather)")
            }
            if let location = result.get("location") {
                print("Location is: \(location)")
            }
            if let time = result.get("time") {
                print("Time is: \(time)")
            }
        }

        do {
            // create dictionary here...
            let locationValueMap = [String: Any]()
            // let valueLatitude = drand48() * 10.0 + 39.0 - 5.0
            // let valueLongitude = drand48() * 50.0 - 98.0 - 25.0

            // Todo: something missing here: valueLatitude & valueLongitude

            let user = BreinUser(email: "fred.firestone@email.com")
                    .setFirstName("Fred")
                    .setIpAddress("74.115.209.58")
                    .setAdditional("location", map: locationValueMap)

            try Breinify.temporalData(user,
                    successBlock,
                    failureBlock)
        } catch {
            XCTFail("Error")
        }

    }

    func testStressRequests() {

        for index in 0...100 {
            print("Request: # \(index)")
            testLogin()
        }
    }

    func testBreinRequestManager() {

        let jsonString = "{ dfdjdskfkjdsfjkdjsj } "
        let jsonString2 = "werewr xcvnxnnvn 898889"

        BreinRequestManager.shared.addRequest(timeStamp: 1489512440,
                fullUrl: "https://api.breinify.com/activity",
                json: jsonString)

        BreinRequestManager.shared.addRequest(timeStamp: 1489512441,
                fullUrl: "https://api.breinify.com/activity",
                json: jsonString2)

        BreinRequestManager.shared.safeMissedRequests()
        BreinRequestManager.shared.clearMissedRequests()
        BreinRequestManager.shared.loadMissedRequests()
    }

    func testFreeTextToLocations() {

        let failureBlock: apiFailure = {
            (error: NSDictionary) -> Void in
            XCTFail("Api Failure : error is: \(error)")
        }
        let successBlock: apiSuccess = {
            (result: BreinResult) -> Void in
            print("Api Success : result is: \(result)")

            if let holiday = result.get("holidays") {
                print("Holiday is: \(holiday)")
            }
            if let weather = result.get("weather") {
                print("Weather is: \(weather)")
            }
            if let location = result.get("location") {
                print("Location is: \(location)")
            }
            if let time = result.get("time") {
                print("Time is: \(time)")
            }
        }

        do {
            let temporalData = BreinTemporalData().setLocation(freeText: "The Big Apple")

            try Breinify.temporalData(temporalData,
                    successBlock,
                    failureBlock)
        } catch {
            XCTFail("Error")
        }

    }

    func testTag() {

        let breinUser = BreinUser(email: "max@sample.com")
        breinUser.setSessionId("966542c6-2399-11e7-93ae-92361f002671")

        let breinActivity = BreinActivity()
        breinActivity.setTag("productPrices", [134.23, 15.13, 12.99] as AnyObject)
                .setTag("productIds", ["125689", "982361", "157029"] as AnyObject)

        // invoke activity call
        do {
            try Breinify.activity(breinActivity, user: breinUser, activityType: "checkOut", nil, nil,
                    {
                        // success block
                        (result: BreinResult) -> Void in
                        print("Api Success : result is: \(result)")
                    },
                    {
                        // failure block
                        (error: NSDictionary) -> Void in
                        XCTFail("Api Failure : error is: \(error)")
                    })
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }
    }

    func testJSON() {

        var dictionary = ["nacho": ["1","2","3"]]
        var jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: [])
        var jsonString = String(data: jsonData!, encoding: .utf8)
        print(jsonString)


        let str = "{\"names\": [\"Bob\", \"Tim\", \"Tina\"]}"
        let data = Data(str.utf8)

        do {
            // make sure this JSON is in the format we expect
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // try to read out a string array
                if let names = json["names"] as? [String] {
                    print(names)
                }
            }
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }


        var dict:  [String: Any] = [
            "countries": [
                "japan": [
                    "capital": [
                        "name": "tokyo",
                        "lat": "35.6895",
                        "lon": "139.6917"
                    ],
                    "language": "japanese"
                ]
            ],
            "airports": [
                "germany": ["FRA", "MUC", "HAM", "TXL"]
            ]
        ]



        let dic = ["2": "B", "1": "A", "3": "C"]
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dic) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        }


        do {
            if var jsonX = dict as? NSDictionary {
                var jsonData = try JSONSerialization.data(withJSONObject: jsonX, options: [])

                var jsonString = String(data: jsonData, encoding: .utf8)
            }

        } catch {
            print (error)
        }

    }
}

