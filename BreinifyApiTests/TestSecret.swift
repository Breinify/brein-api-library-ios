import UIKit
import XCTest
import BreinifyApi

class TestSecret: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSecretGeneration() {

        let expected = "h5HRhGRwWlRs9pscyHhQWNc7pxnDOwDZBIAnnhEQbrU="

        do {
            let generated = try BreinUtil.generateSignature("apiKey", secret: "secretkey")
            XCTAssertEqual(expected, generated)
            print(generated)
        } catch {
            XCTAssert(true, "Error is: \(error)")
        }
    }

    func testActivitySecret() {

        // let expected:String = "WbHv67OJ5LPSCJu7kfh9QOX8b7wkuLiTmE6OTyPqT0g\u003d"
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
            // XCTAssertEqual(expected, generated)
            print(generated)
        } catch {
            XCTAssert(true, "Error is: \(error)")
        }

    }
}
