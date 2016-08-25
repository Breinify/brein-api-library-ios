import UIKit
import XCTest
import BreinApi

class TestDomain: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBreinRequest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        let breinConfig = BreinConfig()
        let validApiKey = "9D9C-C9E9-BC93-4D1D-9A61-3A0F-9BD9-CF14"
        breinConfig.setApiKey(validApiKey)

        let breinUser = BreinUser(email: "m.recchioni@me.com")
        breinUser.setFirstName("Marco")
        breinUser.setLastName("Recchioni")

        let breinActivity = BreinActivity()
        breinActivity.setConfig(breinConfig)
        breinActivity.setBreinUser(breinUser)
        breinActivity.setBreinActivityType(.LOGIN)
        breinActivity.setDescription("Super-Desription")
        breinActivity.setBreinCategoryType(.HOME)

        let jsonOutput = breinActivity.prepareJsonRequest();
        NSLog("output is: \(jsonOutput)")
        XCTAssertFalse(jsonOutput.isEmpty)
    }

    /**
    * creates a brein request object that will be used within the body
    * of the request but with less data
    */
    func testBreinRequestWithLessData() {

        let breinConfig = BreinConfig()
        let validApiKey = "9D9C-C9E9-BC93-4D1D-9A61-3A0F-9BD9-CF14"
        breinConfig.setApiKey(validApiKey)

        let breinUser = BreinUser(email: "m.recchioni@me.com")
        breinUser.setFirstName("")

        let breinActivity = BreinActivity()
        breinActivity.setConfig(breinConfig)
        breinActivity.setBreinUser(breinUser)
        breinActivity.setBreinActivityType(.LOGIN)
        breinActivity.setDescription("Super-Desription")
        breinActivity.setBreinCategoryType(.FOOD)

        let jsonOutput = breinActivity.prepareJsonRequest();
        NSLog("output is: \(jsonOutput)")
        XCTAssertFalse(jsonOutput.isEmpty)
    }

    /**
     * Test the birthday settings
     */
    func testBirthday() {

        let breinUser = BreinUser(email: "test.me@email.com")

        // set right values
        breinUser.setDateOfBirth("")
        breinUser.setDateOfBirth(1, day: 22, year: 1966)
        XCTAssertFalse(breinUser.getDateOfBirth().isEmpty)

        // set wrong day
        breinUser.setDateOfBirth("")
        breinUser.setDateOfBirth(1, day: 77, year: 1966)
        XCTAssertTrue(breinUser.getDateOfBirth().isEmpty)

        // set wrong month
        breinUser.setDateOfBirth("")              // empty value
        breinUser.setDateOfBirth(13, day: 22, year: 1966)    // this is correct date
        XCTAssertTrue(breinUser.getDateOfBirth().isEmpty)

        // set wrong year
        breinUser.setDateOfBirth("")          // empty value
        breinUser.setDateOfBirth(1, day: 22, year: 1700)
        XCTAssertTrue(breinUser.getDateOfBirth().isEmpty)

        // this can not be detected
        breinUser.setDateOfBirth("SuperDate")
        XCTAssertFalse(breinUser.getDateOfBirth().isEmpty)
    }

    /**
    * Tests all BreinUser Methods
    */
    func testBreinUserMethods() {
        let breinUser = BreinUser(email: "user.anywhere@email.com")

        breinUser.setFirstName("User")
        .setLastName("Anywhere")
        .setImei("356938035643809")
        .setDateOfBirth(6, day: 20, year: 1985)
        .setDeviceId("AAAAAAAAA-BBBB-CCCC-1111-222222220000")
        .setSessionId("SID:ANON:w3.org:j6oAOxCWZh/CD723LGeXlf-01:034")

        NSLog(breinUser.description())
        XCTAssertFalse(breinUser.description().isEmpty)
    }


    /**
    * Tests all BreinUser Methods
    */
    func testBreinUserWithNoMethods() {
        let breinUser = BreinUser(email: "user.anywhere@email.com")

        NSLog(breinUser.description())
        XCTAssertFalse(breinUser.description().isEmpty)
    }


}
