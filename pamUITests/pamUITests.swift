import XCTest

class PamUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShouldChangeTab() {
        let testApp = XCUIApplication()
        
        testApp.tabBars.buttons["Second"].tap()
        puts(testApp.staticTexts["Second View"].label)
        XCTAssertEqual(testApp.staticTexts["Second View"].label, "Second View")
    }
    
    func testShouldGoToSettings() {
        let testApp = XCUIApplication()
        
        testApp.navigationBars["Articles"].buttons["Settings"].tap()
        XCTAssertEqual(testApp.navigationBars["Settings"].staticTexts["Settings"].label, "Settings")
    }
}
