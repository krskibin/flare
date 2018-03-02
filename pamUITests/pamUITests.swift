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
        let app = XCUIApplication()
        
        app.tabBars.buttons["Second"].tap()
        puts(app.staticTexts["Second View"].label)
        XCTAssertEqual(app.staticTexts["Second View"].label, "Second View")
    }
}
