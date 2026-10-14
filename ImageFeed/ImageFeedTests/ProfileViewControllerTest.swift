import XCTest
import UIKit
@testable import ImageFeed

// MARK: - Spy

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var isCalled = false
    
    func updateAvatar() {
        isCalled = true
    }
    
    func switchToSplashView() {
        // do nothing
    }
}

final class ProfileViewControllerMock: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
        
    var profileImageView = UIImageView()
}

// MARK: - TESTS

final class ProfileViewTest: XCTestCase {
    
    func testUpdateAvatarDoesNothingWithoutURL() {
        let view = ProfileViewControllerMock()
        let presenter = ProfileViewPresenter()
        view.presenter = presenter
        presenter.view = view
        let profileService = ProfileImageService.shared
        profileService.removeAvatarUrl()
        
        presenter.updateAvatar()
        
        XCTAssertNil(profileService.avatarURL)
    }
    
    func testViewControllerCalledAvatarUpdate() {
        let view = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        view.presenter = presenter
        presenter.view = view
        
        _ = view.view
        
        XCTAssertTrue(presenter.isCalled)
    }
}
