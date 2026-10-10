import UIKit
import Kingfisher

// MARK: - Protocol

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    
    func updateAvatar()
    func configLabel(text: String, color: UIColor, font: UIFont) -> UILabel
    func switchToSplashView()
}
// MARK: - Presenter

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    var navigationHandler: ViewControllerSwitcherProtocol?
    
    func configLabel(text: String, color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = font
        
        return label
    }
    
    func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL else { return }
        
        view?.profileImageView.kf.setImage(with: profileImageURL,
                                           placeholder: view?.profileImage)
    }
    
    func switchToSplashView() {
        navigationHandler = ViewControllerSwitcher()
        let splashViewController = SplashViewController()
        
        navigationHandler?.switchToNewRootController(newController: splashViewController)
    }
}
