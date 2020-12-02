//
// Created by Marco on 11/17/20.
// Copyright (c) 2020 Breinify. All rights reserved.
//

import XCTest
import Foundation
@testable import BreinifyApi

class TestLifecycle: XCTestCase {

    let validApiKeyWithSecret = "CA8A-8D28-3408-45A8-8E20-8474-06C0-8548"
    let validSecret = "lmcoj4k27hbbszzyiqamhg=="

    override func setUp() {
        super.setUp()

        let breinConfig = BreinConfig(validApiKeyWithSecret,
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

    func testSendActivity() {

        // create a user you're interested in
        let breinUser = BreinUser(firstName: "Fred", lastName: "Firestone")

        // create activity object with collected data
        let breinActivity = BreinActivity(user: breinUser)
                .setTag("key-a", Int(100) as AnyObject)
                .setTag("key-b", String("keyString") as AnyObject)
                .setActivityType("pageVisit")
                .setDescription("this is a description")
                .setCategory("sampleCategory")
        
        // invoke activity call
        do {
            try Breinify.activity(breinActivity)
        } catch {
            print("Error is: \(error.localizedDescription)")
        }

    }

    func testCycleWithSignature() {

        // configure API
        Breinify.configure(apiKey: validApiKeyWithSecret, secret: validSecret)

        // configure the app user
        let appUser = Breinify.getBreinUser()
        appUser.setEmail("user.name@gmail.com")
                .setFirstName("Elvis")
                .setLastName("Presley")


        // provide device token
        Breinify.initWithDeviceTokens(deviceToken: "superToken", apnsToken: "superToken", fcmToken: nil)

        // send some activities
        let breinActivity = Breinify.getBreinActivity()!

        breinActivity.getCategory()

        breinActivity.setCategory("ttt")

        breinActivity.setActivityType(BreinActivityType.LOGIN.rawValue)
                .setCategory("this is the home category")
                .setDescription("This is a good description")

        try! Breinify.sendActivity(breinActivity)

        Breinify.shutdown()
    }


}
