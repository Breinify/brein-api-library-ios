//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import UIKit
import XCTest
@testable import BreinifyApi

class TestExecutor: XCTestCase {

    typealias apiSuccess = (_ result: BreinResult?) -> Void
    typealias apiFailure = (_ error: NSDictionary?) -> Void

    let validApiKey = "41B2-F48C-156A-409A-B465-317F-A0B4-E0E8"
    let validApiKeyWithSecret = "CA8A-8D28-3408-45A8-8E20-8474-06C0-8548"
    let validSecret = "lmcoj4k27hbbszzyiqamhg=="

    let breinUser = BreinUser(email: "toni.maroni@email.me")
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

        Breinify.shutdown()

        Thread.sleep(forTimeInterval: 5)
        super.tearDown()
    }

    // testcase how to use the activity api
    func testLogin() {

        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            print("Api Success : result is: \(String(describing: result))")
        }
        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            XCTFail("Error is: \(String(describing: error))")
        }

        // set additional user information
        breinUser.setFirstName("Marco")
                .setLastName("Recchioni")

        // invoke activity call
        do {
            let breinifyExecutor = try BreinConfig()
                    .setApiKey(validApiKey)
                    .setRestEngineType(.URLSession)
                    .build()

            try breinifyExecutor.activity(breinUser,
                    activityType: "login",
                    category: "home",
                    description: "Login-Description",
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }
    }

    //
    // Test lookup functionality
    //
    func testLookup() {

        let dimensions: [String] = ["firstname", "gender", "age", "agegroup", "digitalfootprint", "images"]
        let breinDimension = BreinDimension(dimensionFields: dimensions)

        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            print("Api Success : result is:\n \(result!)")

            if let dataFirstname = result!.get("firstname") {
                print("Firstname is: \(dataFirstname)")
            }

            if let dataGender = result!.get("gender") {
                print("Gender is: \(dataGender)")
            }

            if let dataAge = result!.get("age") {
                print("Age is: \(dataAge)")
            }

            if let dataAgeGroup = result!.get("agegroup") {
                print("AgeGroup is: \(dataAgeGroup)")
            }

            if let dataDigitalFootprinting = result!.get("digitalfootprinting") {
                print("DigitalFootprinting is: \(dataDigitalFootprinting)")
            }

            if let dataImages = result!.get("images") {
                print("DataImages is: \(dataImages)")
            }

        }
        let failureBlock: apiFailure = { (error: NSDictionary?) -> Void in
            XCTFail("Error is: \(String(describing: error))")
        }

        do {
            try Breinify.lookup(breinUser,
                    dimension: breinDimension,
                    successBlock,
                    failureBlock)
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }

        let when = DispatchTime.now() + 15 // wait for 15 seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            print("Finish")
        }
    }

}
