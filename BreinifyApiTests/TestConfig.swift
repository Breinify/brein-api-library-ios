//
// Created by Marco Recchioni
// Copyright (c) 2020 Breinify. All rights reserved.
//

import UIKit
import XCTest
@testable import BreinifyApi

class TestConfig: XCTestCase {

    let validApiKey = "9D9C-C9E9-BC93-4D1D-9A61-3A0F-9BD9-CF14"

    //
    // This should be the normal configuration  methods
    //
    func testNormalConfigUsage() {

        let breinConfig = BreinConfig(validApiKey)
        let breinActivity = BreinActivity()
        breinActivity.setConfig(breinConfig)

        XCTAssertFalse(breinActivity.getConfig().getApiKey().isEmpty)
    }

    //
    // Test of Breinify class with empty configuration api-key
    //
    func testEmptyConfig() {

        let breinConfig = BreinConfig("")
        let breinActivity = BreinActivity()
        breinActivity.setConfig(breinConfig)

        XCTAssertTrue(breinActivity.getConfig().getApiKey().isEmpty)
    }

    //
    // Tet a config with a secret
    //
    func testConfigWithSecret() {

        let secret = "ddddfdsfdsfdsfdfdf"
        let _ = BreinConfig("TEST-API-KEY", secret: secret)
    }

}
