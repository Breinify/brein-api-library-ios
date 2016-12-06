import UIKit
import XCTest
import BreinifyApi

class TestApi: XCTestCase {

    typealias apiSuccess = (result: BreinResult?) -> Void
    typealias apiFailure = (error: NSDictionary?) -> Void

    let baseUrl = "https://api.breinify.com";
    let validApiKey = "41B2-F48C-156A-409A-B465-317F-A0B4-E0E8"

    let breinUser = BreinUser(email: "fred.firestone@email.com")
    let breinCategory = "home"
    var breinConfig: BreinConfig!

    override func setUp() {
        super.setUp()

        breinConfig = BreinConfig(apiKey: validApiKey)

        // set configuration
        Breinify.setConfig(breinConfig)
    }

    override func tearDown() {
        NSThread.sleepForTimeInterval(5)
        Breinify.shutdown()
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
            try Breinify.activity(breinUser,
                    activityType: "login",
                    category: "home",
                    description: "Login-Description",
                    sign: false,
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            print("Error is: \(error)")
        }

        print("Test finished")
    }


    // testcase how to use the activity api
    func testPageVisitWithTags() {

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

        let tagsDic: [String: AnyObject] = ["A": "STRING",
                                            "B": 100,
                                            "C": 2.22]

        let breinActivity = Breinify.getBreinActivity()
        breinActivity.setTagsDic(tagsDic)

        // invoke activity call
        do {
            try Breinify.activity(breinUser,
                    activityType: "pageVisit",
                    category: "food",
                    description: "pageVisit-Description",
                    sign: false,
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            print("Error is: \(error)")
        }

        print("Test finished")
    }


    //
    // Test lookup functionality
    //
    func testLookup() {

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
                    sign: false,
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            print("Error")
        }

        // allow processing
        NSThread.sleepForTimeInterval(5)
    }


    //
    // Test temporalData functionality
    //
    func testTemporalData() {

        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            print("Api Failure : error is:\n \(error)")
        }
        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            print("Api Success : result is:\n \(result!)")

            if let holiday = result!.get("holidays") {
                print("Holiday is: \(holiday)")
            }
            if let weather = result!.get("weather") {
                print("Weather is: \(weather)")
            }
            if let location = result!.get("location") {
                print("Location is: \(location)")
            }
            if let time = result!.get("time") {
                print("Time is: \(time)")
            }
        }


        do {

            let user = BreinUser(email: "fred.firestone@email.com")
            .setFirstName("Fred")
            .setIpAddress("74.115.209.58")
            .setTimezone("America/Los_Angeles")
            .setLocalDateTime("Sun Dec 25 2016 18:15:48 GMT-0800 (PST)")

            try Breinify.temporalData(user,
                    sign: false,
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            print("Error")
        }

        // allow processing
        NSThread.sleepForTimeInterval(5)
    }


    func testTemporalDataWithAdditionalMap() {

        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            print("Api Failure : error is:\n \(error)")
        }
        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            print("Api Success : result is:\n \(result!)")

            if let holiday = result!.get("holidays") {
                print("Holiday is: \(holiday)")
            }
            if let weather = result!.get("weather") {
                print("Weather is: \(weather)")
            }
            if let location = result!.get("location") {
                print("Location is: \(location)")
            }
            if let time = result!.get("time") {
                print("Time is: \(time)")
            }
        }


        do {

            // create dictionary here...
            var locationAdditionalMap = [String: AnyObject]()
            var locationValueMap = [String: AnyObject]()

            locationValueMap["latitude"] = drand48() * 10 + 39 - 5
            locationValueMap["longitude"] = drand48() * 50 - 98 - 25
            locationAdditionalMap["location"] = locationValueMap

            let user = BreinUser(email: "fred.firestone@email.com")
            .setFirstName("Fred")
            .setIpAddress("74.115.209.58")
            .setAdditional(locationAdditionalMap)

            try Breinify.temporalData(user,
                    sign: false,
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            print("Error")
        }

        // allow processing
        NSThread.sleepForTimeInterval(5)


    }

    func testTemporalDataWithSimpleAdditionalMap() {

        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            print("Api Failure : error is:\n \(error)")
        }
        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            print("Api Success : result is:\n \(result!)")

            if let holiday = result!.get("holidays") {
                print("Holiday is: \(holiday)")
            }
            if let weather = result!.get("weather") {
                print("Weather is: \(weather)")
            }
            if let location = result!.get("location") {
                print("Location is: \(location)")
            }
            if let time = result!.get("time") {
                print("Time is: \(time)")
            }
        }


        do {

            // create dictionary here...
            var locationValueMap = [String: AnyObject]()

            locationValueMap["latitude"] = drand48() * 10 + 39 - 5
            locationValueMap["longitude"] = drand48() * 50 - 98 - 25

            let user = BreinUser(email: "fred.firestone@email.com")
            .setFirstName("Fred")
            .setIpAddress("74.115.209.58")
            .setAdditional("location", map: locationValueMap)

            try Breinify.temporalData(user,
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
