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
        Breinify.initWithDeviceTokens(apnsToken: "superToken", fcmToken: nil, userInfo: nil)

        // send some activities
        let breinActivity = Breinify.getBreinActivity()

        breinActivity.setActivityType(BreinActivityType.LOGIN.rawValue)
                .setCategory(BreinCategoryType.HOME.rawValue)
                .setDescription("This is a good description")

        Breinify.sendActivity(breinActivity)

        Breinify.shutdown()
    }

    func testCycleWithSignatureTwo() {

        // configure API
        Breinify.configure(apiKey: validApiKeyWithSecret, secret: validSecret)

        // configure the app user
        let appUser = Breinify.getBreinUser()
        appUser.setEmail("user.name@gmail.com")
                .setFirstName("Elvis")
                .setLastName("Presley")

        // provide device token
        Breinify.initWithDeviceTokens(apnsToken: "superToken", fcmToken: nil, userInfo: nil)

        // send some activities
        let breinActivity = Breinify.getBreinActivity()

        breinActivity.setActivityType(BreinActivityType.LOGIN.rawValue)
                .setCategory(BreinCategoryType.HOME.rawValue)
                .setDescription("This is a good description")
                .setUnixTimestamp(1606988396)

        Breinify.sendActivity(breinActivity)

        Breinify.shutdown()
    }

    func testFulliOSLifeCycle() {

        // 1. configure API
        Breinify.configure(apiKey: validApiKeyWithSecret, secret: validSecret)

        // use this for pushNotification registration

        // 2. get device Token and provide User Info

        var userInfoDic = [String: String]()
        userInfoDic["firstName"] = "Toni"
        userInfoDic["lastName"] = "Maroni"
        userInfoDic["phone"] = "0123456789"
        userInfoDic["email"] = "elvis.presly@mail.com"


        // let apnsToken = Breinify.retrieveDeviceToken(deviceToken)

        let apnsToken = "sdkjfkjdsfjdsfsdfjfdf"
        let token = "ewrewrewrjwerkrjwerjrjrjer"

        Breinify.initWithDeviceTokens(apnsToken: apnsToken,
                fcmToken: token,
                userInfo: userInfoDic)

        // PushNotification

        // activity sending with additional info
        let breinActivity = Breinify.getBreinActivity()
        breinActivity.setActivityType(BreinActivityType.PAGE_VISIT.rawValue)

        // add activity tags
        var tagsDic = [String: Any]()
        tagsDic["pageId"] = "packages" as Any
        breinActivity.setTagsDic(tagsDic)
        Breinify.sendActivity(breinActivity)
    }

    func testCheckout() {
        let jsonDict = [
            "saldo": 6.902,
            "recharge": 0,
            "package": 0,
            "consumption": 3.498,
            "disponsible": 2.904,
            "other": 0,
            "pageId": "consumptionDetails"
        ] as [String: Any]

        let breinActivity = Breinify.getBreinActivity()
        breinActivity.setTagsDic(jsonDict)

        breinActivity.setActivityType(BreinActivityType.PAGE_VISIT.rawValue)
        Breinify.sendActivity(breinActivity)
    }

    func testPageView() {
        let jsonDict = [
            "saldo": 6.902,
            "recharge": 0,
            "package": 0,
            "consumption": 3.498,
            "disponsible": 2.904,
            "other": 0,
            "pageId": "consumptionDetails"
        ] as [String: Any]

        let breinActivity = Breinify.getBreinActivity()
        breinActivity.setTagsDic(jsonDict)

        breinActivity.setActivityType(BreinActivityType.PAGE_VISIT.rawValue)
        Breinify.sendActivity(breinActivity)
    }

    func testBalance() {
        let jsonDict = [
            "balancePromotional": 0,
            "balanceCampaign": 0,
            "pageId": "otherBalance"
        ] as [String: Any]


        BreinLogger.shared.setDebug(true)

        let breinActivity = Breinify.getBreinActivity()
        breinActivity.setTagsDic(jsonDict)

        breinActivity.setActivityType(BreinActivityType.PAGE_VISIT.rawValue)

        Breinify.sendActivity(breinActivity)
    }
}



