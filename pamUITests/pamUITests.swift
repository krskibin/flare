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
        
        testApp.navigationBars["Test"].buttons["Settings"].tap()
        XCTAssertEqual(testApp.navigationBars["Settings"].staticTexts["Settings"].label, "Settings")
    }
    
    func testShouldGenerateTables() {
        
        let tablesQuery = XCUIApplication().tables
        
        // swiftlint:disable line_length
        XCTAssertEqual(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Apple się kończy"]/*[[".cells.staticTexts[\"Apple się kończy\"]",".staticTexts[\"Apple się kończy\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.label,
                       "Apple się kończy")
        XCTAssertEqual(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["SGS9 jest super"]/*[[".cells.staticTexts[\"SGS9 jest super\"]",".staticTexts[\"SGS9 jest super\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.label,
                       "SGS9 jest super")
        XCTAssertEqual(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Xiaomi podbija Polskę"]/*[[".cells.staticTexts[\"Xiaomi podbija Polskę\"]",".staticTexts[\"Xiaomi podbija Polskę\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.label,
                       "Xiaomi podbija Polskę")        
    }
}
