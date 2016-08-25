import UIKit
import XCTest
import BreinApi

class TestLocation: XCTestCase {

    typealias apiSuccess = (result:BreinResult?) -> Void
    typealias apiFailure = (error:NSDictionary?) -> Void

    let baseUrl = "http://dev.breinify.com/api"
    let validApiKey = "A187-B1DF-E3C5-4BDB-93C4-4729-7B54-E5B1"
    let breinUser = BreinUser(email: "toni.maroni@me.com")
    let breinCategory: BreinCategoryType = .HOME
    var breinConfig: BreinConfig!

    override func setUp() {
        super.setUp()

        do {
            breinConfig = try BreinConfig(apiKey: validApiKey, baseUrl: baseUrl, breinEngineType: .ALAMOFIRE)

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
    func testWithLocation() {

        let successBlock: apiSuccess = {(result: BreinResult?) -> Void in
            print ("Api Success : result is:\n \(result)")

        }
        let failureBlock: apiFailure = {(error: NSDictionary?) -> Void in
            print ("Api Failure : error is:\n \(error)")
        }

        // set additional user information
        breinUser.setFirstName("Toni")
        breinUser.setLastName("Maroni")

        BreinLocationManager().fetchWithCompletion {location, error in

            // fetch location or an error
            if location != nil {
                print(location)

                var locationInfo = ""

                // invoke activity call
                do {
                    try Breinify.activity(self.breinUser,
                            activityType: .CHECKOUT,
                            category: .SERVICES,
                            description: locationInfo,
                            sign: false,
                            success: successBlock,
                            failure: failureBlock)
                } catch {
                    print("Error is: \(error)")
                }


            } else if let err = error {
                print(err.localizedDescription)
            }
        }

    }

}
