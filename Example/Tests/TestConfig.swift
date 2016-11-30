import UIKit
import XCTest
import BreinifyApi

class TestConfig: XCTestCase {
    
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

        let validApiKey = "9D9C-C9E9-BC93-4D1D-9A61-3A0F-9BD9-CF14"
        let breinConfig = BreinConfig(apiKey: validApiKey)

        let breinActivity = BreinActivity()
        breinActivity.setConfig(breinConfig)

        XCTAssertFalse(breinActivity.getConfig().getApiKey().isEmpty)
    }

    //
    // Test of Breinify class with empty configuration api-key
    //
    func testEmptyConfig() {
        let emptyString = ""
        let breinConfig = BreinConfig(apiKey: emptyString)

        let breinActivity = BreinActivity()
        breinActivity.setConfig(breinConfig)

        XCTAssertTrue(breinActivity.getConfig().getApiKey().isEmpty)
    }

    //
    // Tet a config with a wrong url
    //
    func testConfigWithWrongUrl() {

        let wrongUrl = "https://breeeeeinify.com"
        do {
            try BreinConfig(apiKey: "TEST-API-KEY").setBaseUrl(wrongUrl)
        } catch  {
            print("Error is: \(error)")
        }
    }

}
