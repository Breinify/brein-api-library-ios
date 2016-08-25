import UIKit
import XCTest
import BreinApi

class TestExecutor: XCTestCase {

    typealias apiSuccess = (result:BreinResult?) -> Void
    typealias apiFailure = (error:NSDictionary?) -> Void

    let baseUrl = "https://api.breinify.com"
    let validApiKey = "41B2-F48C-156A-409A-B465-317F-A0B4-E0E8"
    let breinUser = BreinUser(email: "philipp@meisen.net")
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
        super.tearDown()
    }

    // testcase how to use the activity api
    func testLogin() {

        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            print("Api Success : result is:\n \(result)")

        }
        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            print("Api Failure : error is:\n \(error)")
        }

        // set additional user information
        breinUser.setFirstName("Marco")
        breinUser.setLastName("Recchioni")

        // invoke activity call
        do {

            let breinifyExecutor = try BreinConfig()
            .setApiKey(validApiKey)
            .setBaseUrl(baseUrl)
            .setRestEngineType(.ALAMOFIRE)
            .build()

            try breinifyExecutor.activity(breinUser,
                    activityType: .LOGIN,
                    category: .HOME,
                    description: "Login-Description",
                    sign: false,
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            print("Error is: \(error)")
        }
    }

    //
    // Test lookup functionality
    //
    func testLookup() {

        let dimensions: [String] = ["firstname", "gender", "age", "agegroup", "digitalfootprint", "images"]
        let breinDimension = BreinDimension(dimensionFields: dimensions)

        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            print("Api Success : result is:\n \(result!)")

            if let dataFirstname = result!.get("firstname") {
                print("Firstname is: \(dataFirstname)")
            }

            if let dataGender = result!.get("gender") {
                print("Gender is: \(dataGender)")
            }

            if let dataAge = result!.get("age") {
                print("Age is: \(dataAge)")
            }

            if let dataAgeGroup = result!.get("agegroup") {
                print("AgeGroup is: \(dataAgeGroup)")
            }

            if let dataDigitalFootprinting = result!.get("digitalfootprinting") {
                print("DigitalFootprinting is: \(dataDigitalFootprinting)")
            }

            if let dataImages = result!.get("images") {
                print("DataImages is: \(dataImages)")
            }

        }
        let failureBlock: apiFailure = {(error: NSDictionary?) -> Void in
            print ("Api Failure : error is:\n \(error)")
        }


        do {
            try Breinify.lookup(breinUser,
                    dimension: breinDimension,
                    sign: false,
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            print("Error")
        }


        // allow processing
        NSThread.sleepForTimeInterval(5)
    }

}
