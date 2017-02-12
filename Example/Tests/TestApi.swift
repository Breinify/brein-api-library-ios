import UIKit
import XCTest
import BreinifyApi


class TestApi: XCTestCase {

    typealias apiSuccess = (result: BreinResult?) -> Void
    typealias apiFailure = (error: NSDictionary?) -> Void

    let baseUrl = "https://api.breinify.com"

    let validApiKeyWithSecret = "CA8A-8D28-3408-45A8-8E20-8474-06C0-8548"
    let validSecret = "lmcoj4k27hbbszzyiqamhg=="

    let breinUser = BreinUser(email: "toni.maroni@email.me")
    let breinCategory = "home"
    var breinConfig: BreinConfig!

    var myGroup = dispatch_group_create()

    override func setUp() {
        super.setUp()

        do {
            breinConfig = try BreinConfig(apiKey: validApiKeyWithSecret,
                    secret: validSecret)

            // set configuration
            Breinify.setConfig(breinConfig)
        } catch {
            XCTAssert(true, "Error is: \(error)")
        }
    }

    override func tearDown() {
        NSThread.sleepForTimeInterval(5)
        Breinify.shutdown()
        super.tearDown()
    }

    // test case how to use the activity api with secret
    func testLoginWithSecret() {

        dispatch_group_enter(myGroup)

        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            print("Api Success : result is:\n \(result)")

            dispatch_group_leave(self.myGroup)

        }
        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            print("Api Failure : error is:\n \(error)")

            dispatch_group_leave(self.myGroup)
        }

        // set additional user information
        breinUser.setFirstName("Fred")
                .setLastName("Firestone")

        // invoke activity call
        do {
            try Breinify.activity(breinUser,
                    activityType: "login",
                    category: "home",
                    description: "Login-Description",
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            print("Error is: \(error)")
        }

        dispatch_group_notify(myGroup, dispatch_get_main_queue(), {
            print("Finished all requests.")
        })

        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 4 * Int64(NSEC_PER_SEC))
        dispatch_after(time, dispatch_get_main_queue()) {
            print("Finished")
        }


    }

    // test case how to use the activity api
    func testLogin() {

        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            print("Api Success : result is:\n \(result)")

        }
        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            print("Api Failure : error is:\n \(error)")
            XCTAssert(true, "Error is: \(error)")
        }

        // set additional user information
        breinUser.setFirstName("Marco")
                .setLastName("Recchioni")

        // invoke activity call
        do {
            try Breinify.activity(breinUser,
                    activityType: "login",
                    category: "home",
                    description: "Login-Description",
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            XCTAssert(true, "Error is: \(error)")
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
            XCTAssert(true, "Error is: \(error)")
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
                    activityType: "login",
                    category: "home",
                    description: "Login-Description",
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            XCTAssert(true, "Error is: \(error)")
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
            XCTAssert(true, "Error is: \(error)")
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
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            XCTAssert(true, "Error is: \(error)")
        }
    }

    //
    // Test recommendation functionality
    //
    func testRecommendation() {

        let failureBlock: apiFailure = {
            (error: NSDictionary?) -> Void in
            print("Api Failure : error is:\n \(error)")
            XCTAssert(true, "Error is: \(error)")
        }

        let successBlock: apiSuccess = {
            (result: BreinResult?) -> Void in
            print("Api Success : result is:\n \(result!)")
        }

        do {
            let breinRecommendation = BreinRecommendation(breinUser: breinUser)
            breinRecommendation.setNumberOfRecommendations(5)
                    .setCategory("SampleCat")

            try Breinify.recommendation(breinRecommendation,
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            XCTAssert(true, "Error is: \(error)")
        }
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
                    .setAdditionalDic(locationAdditionalMap)

            try Breinify.temporalData(user,
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
                    success: successBlock,
                    failure: failureBlock)
        } catch {
            print("Error")
        }

        // allow processing
        NSThread.sleepForTimeInterval(5)


    } 

    func testStressRequests() {

        for index in 0 ... 100 {
            print("Request: # \(index)")
            testLogin()
        }
    }
}
