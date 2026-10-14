import UIKit
import Kingfisher

// MARK: - Protocol

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    
    func updateAvatar()
    func switchToSplashView()
}
// MARK: - Presenter

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    let placeholder = UIImage(systemName: "person.crop.circle.fill")
    
    weak var view: ProfileViewControllerProtocol?
    
    var navigationHandler: ViewControllerSwitcherProtocol?
    
    func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL else { return }
        
        view?.profileImageView.kf.setImage(with: profileImageURL,
                                           placeholder: placeholder)
    }
    
    func switchToSplashView() {
        navigationHandler = ViewControllerSwitcher()
        let splashViewController = SplashViewController()
        
        navigationHandler?.switchToNewRootController(newController: splashViewController)
    }
}
