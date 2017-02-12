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
}
