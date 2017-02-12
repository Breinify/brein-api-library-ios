import UIKit
import XCTest
import BreinifyApi


class TestEngine: XCTestCase {

    typealias apiSuccess = (result: BreinResult?) -> Void
    typealias apiFailure = (error: NSDictionary?) -> Void

    let validApiKey = "41B2-F48C-156A-409A-B465-317F-A0B4-E0E8"
    let validApiKeyWithSecret = "CA8A-8D28-3408-45A8-8E20-8474-06C0-8548"
    let validSecret = "lmcoj4k27hbbszzyiqamhg=="

    let breinUser = BreinUser(email: "Toni.Maroni@me.com")
    var breinConfig: BreinConfig!

    override func setUp() {
        super.setUp()

        do {
            breinConfig = try BreinConfig(apiKey: validApiKeyWithSecret,
                    secret: validSecret)

            // set configuration
            Breinify.setConfig(breinConfig)
        } catch {
            print("Error is: \(error)")
        }
    }

    override func tearDown() {
        NSThread.sleepForTimeInterval(5)

        Breinify.shutdown()
        super.tearDown()
    }

    // testcase how to use the activity api
    func testActivity() {

        let successBlock: apiSuccess = { (result: BreinResult?) -> Void in
            print("Api Success : result is:\n \(result)")

        }
        let failureBlock: apiFailure = { (error: NSDictionary?) -> Void in
            print("Api Failure : error is:\n \(error)")
        }

        // set additional user information
        breinUser.setFirstName("Toni")
                .setLastName("Maroni")

        // invoke activity call
        do {
            try Breinify.activity(breinUser,
                    activityType: "selectProdcut",
                    category: "food",
                    description: "Selected Product Information",
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            print("Error is: \(error)")
        }
    }
}
