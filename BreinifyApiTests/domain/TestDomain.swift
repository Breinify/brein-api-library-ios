//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import UIKit
import XCTest
@testable import BreinifyApi

class TestDomain: XCTestCase {

    let validApiKey = "41B2-F48C-156A-409A-B465-317F-A0B4-E0E8"
    let validApiKeyWithSecret = "CA8A-8D28-3408-45A8-8E20-8474-06C0-8548"
    let validSecret = "lmcoj4k27hbbszzyiqamhg=="

    func testBreinRequest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let breinConfig = BreinConfig(validApiKey)
        let breinUser = BreinUser()
        breinUser.setFirstName("Marco")
                .setLastName("Recchioni")

        let breinActivity = BreinActivity()
        breinActivity.setConfig(breinConfig)
        breinActivity.setUser(breinUser)
        breinActivity.setActivityType("login")
                .setDescription("Super-Desription")
                .setCategory("home")

        if let jsonOutput = breinActivity.prepareJsonRequest() {
            dump("output is: \(jsonOutput)")
            XCTAssertFalse(jsonOutput.isEmpty)
        }
    }

    /**
    * creates a brein request object that will be used within the body
    * of the request but with less data
    */
    func testBreinRequestWithLessData() {

        let breinConfig = BreinConfig()
        breinConfig.setApiKey(validApiKey)

        let breinUser = BreinUser(email: "m.recchioni@me.com")
        breinUser.setFirstName("")

        let breinActivity = BreinActivity()
        breinActivity.setConfig(breinConfig)
        breinActivity.setUser(breinUser)
        breinActivity.setActivityType("login")
                .setDescription("Super-Desription")
                .setCategory("food")

        if let jsonOutput = breinActivity.prepareJsonRequest() {
            dump("output is: \(jsonOutput)")
            XCTAssertFalse(jsonOutput.isEmpty)
        }
    }

    /**
     * Test the birthday settings
     */
    func testBirthday() {

        let breinUser = BreinUser(email: "test.me@email.com")

        // set right values
        breinUser.setDateOfBirth(1, day: 22, year: 1966)
        XCTAssertFalse(breinUser.getDateOfBirth().isEmpty)

        // set wrong day
        breinUser.resetDateOfBirth()
        breinUser.setDateOfBirth(1, day: 77, year: 1966)
        XCTAssertTrue(breinUser.getDateOfBirth().isEmpty)

        // set wrong month
        breinUser.resetDateOfBirth()
        breinUser.setDateOfBirth(13, day: 22, year: 1966)    // this is correct date
        XCTAssertTrue(breinUser.getDateOfBirth().isEmpty)

        // set wrong year
        breinUser.resetDateOfBirth()
        breinUser.setDateOfBirth(1, day: 22, year: 1700)
        XCTAssertTrue(breinUser.getDateOfBirth().isEmpty)
    }

    /**
    * Tests all BreinUser Methods
    */
    func testBreinUserMethods() {
        let breinUser = BreinUser(email: "user.anywhere@email.com")

        breinUser.setFirstName("User")
                .setLastName("Anywhere")
                .setImei("356938035643809")
                .setDateOfBirth(6, day: 20, year: 1985)
                .setDeviceId("AAAAAAAAA-BBBB-CCCC-1111-222222220000")
                .setSessionId("SID:ANON:w3.org:j6oAOxCWZh/CD723LGeXlf-01:034")

        dump(breinUser.getFirstName()!)
        XCTAssertFalse(breinUser.getFirstName()!.isEmpty)
    }

    /**
      * Tests all BreinUser Methods
    */
    func testBreinUserWithNoMethods() {
        let breinUser = BreinUser(email: "user.anywhere@email.com")

        dump(breinUser.getEmail()!)
        XCTAssertFalse(breinUser.getEmail()!.isEmpty)
    }

    func testUser() {
        let breinUser = BreinUser()
        let kUUID = "55gggdd"

        breinUser.setUserId(kUUID)
        let getUserId = breinUser.getUserId()
        XCTAssertEqual(kUUID, getUserId)
    }

    func testLocalDateTime() {
        let breinUser = BreinUser()

        // TimeZone.current
        print(breinUser.detectLocalDateTime()!)

        // XCTAssertEqual(kUUID, getUserId)
    }

    func testLocalDateTimeFormat() {
        let user = BreinUser()
        let localDateTime = user.detectLocalDateTime()
        print("LocaldateTime is: \(String(describing: localDateTime))")
    }

}
