import UIKit
import XCTest
import BreinifyApi


class TestConfig: XCTestCase {

    let validApiKey = "9D9C-C9E9-BC93-4D1D-9A61-3A0F-9BD9-CF14"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    //
    // This should be the normal configuration  methods
    //
    func testNormalConfigUsage() {

        do {
            let breinConfig = try BreinConfig(apiKey: validApiKey)
            let breinActivity = BreinActivity()
            breinActivity.setConfig(breinConfig)

            XCTAssertFalse(breinActivity.getConfig().getApiKey().isEmpty)
        } catch {
            XCTAssert(true, "Error is: \(error)")
        }
    }

    //
    // Test of Breinify class with empty configuration api-key
    //
    func testEmptyConfig() {

        do {
            let breinConfig = try BreinConfig(apiKey: "")
            let breinActivity = BreinActivity()
            breinActivity.setConfig(breinConfig)

            XCTAssertTrue(breinActivity.getConfig().getApiKey().isEmpty)
        } catch {
            XCTAssert(true, "Error is: \(error)")
        }
    }

    //
    // Tet a config with a secret
    //
    func testConfigWithSecret() {

        let secret = "ddddfdsfdsfdsfdfdf"
        do {
            try BreinConfig(apiKey: "TEST-API-KEY", secret: secret)
        } catch {
            XCTAssert(true, "Error is: \(error)")
        }
    }

}
