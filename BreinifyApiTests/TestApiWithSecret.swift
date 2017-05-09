import UIKit
import XCTest
import BreinifyApi

class TestApiWithSecret: XCTestCase {

    typealias apiSuccess = (_ result: BreinResult?) -> Void
    typealias apiFailure = (_ error: NSDictionary?) -> Void

    let baseUrl = "https://api.breinify.com";
    let validApiKey = "CA8A-8D28-3408-45A8-8E20-8474-06C0-8549"

    let breinUser = BreinUser(email: "fred.firestone@email.com")
    let breinCategory = "home"
    var breinConfig: BreinConfig!

    override func setUp() {
        super.setUp()

        breinConfig = BreinConfig(validApiKey)

        // set the secret
        breinConfig.setSecret("lmcoj4k27hbbszzyiqamhg==")

        // set configuration
        Breinify.setConfig(breinConfig)
    }

    override func tearDown() {
        Thread.sleep(forTimeInterval: 5)
        Breinify.shutdown()
        super.tearDown()
    }


    // testcase how to use the activity api with secret
    func testLoginWithSecret() {

        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            print("Api Success : result is:\n \(result)")

        }
        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            print("Api Failure : error is:\n \(error)")
        }

        // set additional user information
        breinUser.setFirstName("Fred")
        breinUser.setLastName("Firestone")

        // invoke activity call
        do {
            try Breinify.activity(breinUser,
                    activityType: "login",
                    "home",
                    "Login-Description",
                    successBlock,
                    failureBlock)
        } catch {
            print("Error is: \(error)")
        }
        
    }

    // testcase how to use the activity api
    func testPageVisitWithTagsWithSecret() {

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
        .setLastName("Recchioni")
        .setIpAddress("10.11.12.130")
        .setUrl("http://sample.com")

        let tagsDic: [String: AnyObject] = ["A": "STRING" as AnyObject,
                                            "B": 100 as AnyObject,
                                            "C": 2.22 as AnyObject]

        let breinActivity = Breinify.getBreinActivity()
        breinActivity?.setTagsDic(tagsDic)

        // invoke activity call
        do {
            try Breinify.activity(breinUser,
                    activityType: "pageVisit",
                    "food",
                    "pageVisit-Description",
                    successBlock,
                    failureBlock)
        } catch {
            print("Error is: \(error)")
        }

        // allow processing
        Thread.sleep(forTimeInterval: 5)
        print("Test finished")
    }


    //
    // Test lookup functionality
    //
    func testLookupWithSecret() {

        let dimensions: [String] = ["firstname", "gender", "age", "agegroup", "digitalfootprint", "images"]
        let breinDimension = BreinDimension(dimensionFields: dimensions)

        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            print("Api Failure : error is:\n \(error)")
        }
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

        do {
            try Breinify.lookup(breinUser,
                    dimension: breinDimension,
                    successBlock,
                    failureBlock)
        } catch {
            print("Error")
        }

        // allow processing
        Thread.sleep(forTimeInterval: 5)
    }
}
