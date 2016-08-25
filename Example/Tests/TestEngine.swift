import UIKit
import XCTest
import BreinApi

class TestEngine: XCTestCase {

    typealias apiSuccess = (result:BreinResult?) -> Void
    typealias apiFailure = (error:NSDictionary?) -> Void

    let baseUrl = "https://api.breinify.com"
    let validApiKey = "41B2-F48C-156A-409A-B465-317F-A0B4-E0E8"
    let breinUser = BreinUser(email: "Toni.Maroni@me.com")
    var breinConfig: BreinConfig!

    override func setUp() {
        super.setUp()

        do {
            breinConfig = try BreinConfig(apiKey: validApiKey,
                    baseUrl: baseUrl,
                    breinEngineType: .ALAMOFIRE)

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

        let successBlock: apiSuccess = {(result: BreinResult?) -> Void in
            print ("Api Success : result is:\n \(result)")

        }
        let failureBlock: apiFailure = {(error: NSDictionary?) -> Void in
            print ("Api Failure : error is:\n \(error)")
        }

        // set additional user information
        breinUser.setFirstName("Toni")
        breinUser.setLastName("Maroni")

        // invoke activity call
        do {
            try Breinify.activity(breinUser,
                    activityType: .SELECT_PRODUCT,
                    category: .FOOD,
                    description: "Selected Product Information",
                    sign: false,
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            print("Error is: \(error)")
        }
    }
}
