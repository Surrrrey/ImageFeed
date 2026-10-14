import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    private let login = "sergei-novoselsev2013@yandex.ru" //Логин сюда
    private let password = "46283355Unsplash" //Пароль сюда
    private let unsplashLogin = "surrrrey" //Логин ансплеша сюда
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAuth() {
        app.buttons["Authenticate"].tap()
        sleep(3)
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))

        loginTextField.tap()
        loginTextField.typeText(login)
        
        webView.swipeUp()
        sleep(3)
        
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        passwordTextField.tap()
        passwordTextField.typeText(password)
        
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        print(app.debugDescription)
        
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 0)
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 6))
    }
    
    func testFeed() {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        
        cellToLike.buttons["like button off"].tap()
        
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 5))
        
        cellToLike.buttons["like button on"].tap()
        
        XCTAssertTrue(cellToLike.waitForExistence(timeout: 10))
        
        cellToLike.tap()
        
        let image = app.scrollBars.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["navBackButtonWhiteButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() {
        sleep(5)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["@\(unsplashLogin)"].exists)
        
        app.buttons["logout button"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
