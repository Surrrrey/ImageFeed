import XCTest
import Foundation
@testable import ImageFeed

// MARK: - Spy

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol?
    var loaderIsCalled = false

    func loadAuthView() {
        loaderIsCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        nil
    }
}

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var presenter: WebViewPresenterProtocol?
    var loadIsCalled = false
    
    func load(_ request: URLRequest) {
        loadIsCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}

// MARK: - TESTS
final class WebViewTest: XCTestCase {
    
    func testViewControllerCallsLoadRequest() {
        let view = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        view.presenter = presenter
        presenter.view = view
        
        _ = view.view
        
        XCTAssertTrue(presenter.loaderIsCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        let view = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        presenter.view = view
        view.presenter = presenter
        
        presenter.loadAuthView()
        
        XCTAssertTrue(view.loadIsCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        let config = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: config)
        
        let url = authHelper.authURL()
        
        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }
        
        XCTAssertTrue(urlString.contains(config.unsplashAuthorizeURLString))
        XCTAssertTrue(urlString.contains(config.accessKey))
        XCTAssertTrue(urlString.contains(config.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(config.accessScope))
    }
    
    func testCodeFromURL() {
        let config = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: config)
        
        guard var urlComponents = URLComponents(string: config.receivingCodeAdress) else {
            XCTFail("UrlComponents is nil")
            return }
        
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
       
        guard let url = urlComponents.url else {
            XCTFail("UrlComponents.url is nil")
            return
        }
        
        let result = authHelper.code(from: url)
        
        XCTAssertEqual("test code", result)
    }
}
