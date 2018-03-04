import XCTest
@testable import pam

class PamTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformanceExample() {
        self.measure {
        }
    }
    
    func testIsNumberEven() {
        let _firstViewController = FirstViewController()
        XCTAssertTrue(_firstViewController.isNumberEven(number: 2))
    }
}
