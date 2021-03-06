//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import UIKit
import XCTest
@testable import BreinifyApi

class TestSecret: XCTestCase {

    func testSecretGeneration() {
        do {
            let expected = "h5HRhGRwWlRs9pscyHhQWNc7pxnDOwDZBIAnnhEQbrU="
            let generated = try BreinUtil.generateSignature("apiKey", secret: "secretkey")
            XCTAssertEqual(expected, generated)
            print(generated)
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }
    }

    func testActivitySecret() {
        let expected:String = "WbHv67OJ5LPSCJu7kfh9QOX8b7wkuLiTmE6OTyPqT0g="
        let timestamp: TimeInterval = 1487235949
        let activityType = "paginaUno"

        let breinActivity = BreinActivity()

        breinActivity.setUnixTimestamp(timestamp)
        breinActivity.setActivityType(activityType)

        do {
            let validApiKeyWithSecret = "CA8A-8D28-3408-45A8-8E20-8474-06C0-8548"
            let validSecret = "lmcoj4k27hbbszzyiqamhg=="
            let breinConfig = BreinConfig(validApiKeyWithSecret, secret: validSecret)

            breinActivity.setConfig(breinConfig)

            let generated: String = try breinActivity.createSignature()
            print(generated)
            XCTAssertEqual(expected, generated)
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }
    }

    func testActivitySecretAgain() {
        let expected:String = "mPVaFF5yr2RmZF+pAcHsjCA4kK8tjxnlfYNnCZYlKSk="
        let timestamp: TimeInterval = 1606827661
        let activityType = "login"

        let breinActivity = BreinActivity()

        breinActivity.setUnixTimestamp(timestamp)
        breinActivity.setActivityType(activityType)

        do {
            let validApiKeyWithSecret = "1662-7D6D-1082-4774-9EC2-A856-BC3B-32CF"
            let validSecret = "0qpejxdbwrflx79ixx+55a=="
            let breinConfig = BreinConfig(validApiKeyWithSecret, secret: validSecret)

            breinActivity.setConfig(breinConfig)

            let generated: String = try breinActivity.createSignature()
            print(generated)
            XCTAssertEqual(expected, generated)
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }
    }

    func testSignature() {
        do {
            var expected = "h5HRhGRwWlRs9pscyHhQWNc7pxnDOwDZBIAnnhEQbrU="
            var generated = try BreinUtil.generateSignature("apiKey", secret: "secretkey")
            XCTAssertEqual(expected, generated)

            expected = "qnR8UCqJggD55PohusaBNviGoOJ67HC6Btry4qXLVZc="
            generated = try BreinUtil.generateSignature("Message", secret: "secret")
            XCTAssertEqual(expected, generated)
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }
    }

    func testSignatureWithSecret() {

        do {
            let expected = "PBr2QxM9kRRcL0d4GvUPvkN16YdrpRwYWqnMpHYkJ8c="
            let message = "identify16069883961"
            let secret = "lmcoj4k27hbbszzyiqamhg=="
            let generated = try BreinUtil.generateSignature(message, secret: secret)
            XCTAssertEqual(expected, generated)
        } catch {
            XCTFail("Error is: \(error.localizedDescription)")
        }

    }

}