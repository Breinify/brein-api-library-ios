import UIKit
import XCTest
import BreinifyApi
import NetUtils


class TestDomain: XCTestCase {

    let validApiKey = "41B2-F48C-156A-409A-B465-317F-A0B4-E0E8"
    let validApiKeyWithSecret = "CA8A-8D28-3408-45A8-8E20-8474-06C0-8548"
    let validSecret = "lmcoj4k27hbbszzyiqamhg=="

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

        let breinConfig = BreinConfig(validApiKey)
        let breinUser = BreinUser()
        breinUser.setFirstName("Marco")
                .setLastName("Recchioni")

        let breinActivity = BreinActivity()
        breinActivity.setConfig(breinConfig)
        breinActivity.setUser(breinUser)
        breinActivity.setActivityType("login")
                .setDescription("Super-Desription")
                .setCategoryType("home")

        if let jsonOutput = breinActivity.prepareJsonRequest() {
            dump("output is: \(jsonOutput)")
            XCTAssertFalse(jsonOutput.isEmpty)
        }
    }

    /**
    * creates a brein request object that will be used within the body
    * of the request but with less data
    */
    func testBreinRequestWithLessData() {

        let breinConfig = BreinConfig()
        breinConfig.setApiKey(validApiKey)

        let breinUser = BreinUser(email: "m.recchioni@me.com")
        breinUser.setFirstName("")

        let breinActivity = BreinActivity()
        breinActivity.setConfig(breinConfig)
        breinActivity.setUser(breinUser)
        breinActivity.setActivityType("login")
                .setDescription("Super-Desription")
                .setCategoryType("food")

        if let jsonOutput = breinActivity.prepareJsonRequest() {
            dump("output is: \(jsonOutput)")
            XCTAssertFalse(jsonOutput.isEmpty)
        }
    }

    /**
     * Test the birthday settings
     */
    func testBirthday() {

        let breinUser = BreinUser(email: "test.me@email.com")

        // set right values
        breinUser.setDateOfBirth(1, day: 22, year: 1966)
        XCTAssertFalse(breinUser.getDateOfBirth().isEmpty)

        // set wrong day
        breinUser.resetDateOfBirth()
        breinUser.setDateOfBirth(1, day: 77, year: 1966)
        XCTAssertTrue(breinUser.getDateOfBirth().isEmpty)

        // set wrong month
        breinUser.resetDateOfBirth()
        breinUser.setDateOfBirth(13, day: 22, year: 1966)    // this is correct date
        XCTAssertTrue(breinUser.getDateOfBirth().isEmpty)

        // set wrong year
        breinUser.resetDateOfBirth()
        breinUser.setDateOfBirth(1, day: 22, year: 1700)
        XCTAssertTrue(breinUser.getDateOfBirth().isEmpty)
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

        dump(breinUser.description())
        XCTAssertFalse(breinUser.description().isEmpty)
    }

    /*
    func testNetworkInfo() {

        var breinUser = BreinUser()
        var data = [String: AnyObject]()

        // breinUser.prepareNetworkInfo(&data)

        dump(data)
    }
    */


    /**
    * Tests all BreinUser Methods
    */
    func testBreinUserWithNoMethods() {
        let breinUser = BreinUser(email: "user.anywhere@email.com")

        dump(breinUser.description())
        XCTAssertFalse(breinUser.description().isEmpty)
    }

    func testUser() {
        let breinUser = BreinUser()
        let kUUID = "55gggdd"

        breinUser.setUserId(kUUID)
        let getUserId = breinUser.getUserId()
        XCTAssertEqual(kUUID, getUserId)
    }

    func testLocalDateTime() {
        let breinUser = BreinUser()

        TimeZone.current

        print(breinUser.detectLocalDateTime())

        // XCTAssertEqual(kUUID, getUserId)
    }

    /**
       This test is intended to retrieve the network information

    */
    func testNetworkInformation() {


    }

    func testLocalDateTimeFormat() {
        let user = BreinUser()
        let localDateTime = user.detectLocalDateTime()
        print("LocaldateTime is: \(localDateTime)")
    }


    func testWifiDetection() {

        // let ip = getWiFiAddress()
        // print("IP is: \(ip)")

        let interfaces = Interface.allInterfaces()

        for i in interfaces {
            let running = i.isRunning ? "running" : "not running"
            let up = i.isUp ? "up" : "down"
            let loopback = i.isLoopback ? ", loopback" : ""
            print("\(i.name) (\(running), \(up)\(loopback))")
            print("    Family: \(i.family.toString())")
            if let a = i.address {
                print("    Address: \(a)")
            }
            if let nm = i.netmask {
                print("    Netmask: \(nm)")
            }
            if let b = i.broadcastAddress {
                print("    broadcast: \(b)")
            }
            let mc = i.supportsMulticast ? "yes" : "no"
            print("    multicast: \(mc)")
        }


    }

    /*
    func getWiFiAddress() -> String? {
        var address : String?

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {

                    // Convert interface address to a human readable string:
                    var addr = interface.ifa_addr.pointee
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
    }
    */

}
