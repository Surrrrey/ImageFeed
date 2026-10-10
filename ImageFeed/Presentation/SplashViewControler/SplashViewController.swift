import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Layout Properties
    private let logoImage = UIImage(resource: .logoOfUnsplash)
    private var logoImageView = UIImageView()
    
    private let backgroundColor = UIColor(resource: .ypBlackIOS)
    
    // MARK: - Properties
    
    private var navigationHandler: ViewControllerSwitcherProtocol?
    
    private let storage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.accessToken != nil {
            fetchProfile()
        } else {
            showAuthView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundColor
        configLogo()
    }
    
    // MARK: - Layout Methods
    
    private func configLogo() {
        logoImageView.image = logoImage
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Private Methods
    
    private func showAuthView() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        
        navigationHandler = ViewControllerSwitcher()
            
            navigationHandler?.presentNavigationRootController(self: self, authViewController, isHiddenNavigationBar: true)
    }
    
    private func switchToTabBarController() {
        let tabBarController = TabBarController()
        
        navigationHandler = ViewControllerSwitcher()
        
        navigationHandler?.switchToNewRootController(newController: tabBarController)
    }
}

// MARK: - AuthViewController Delegate

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate() {
        
        fetchProfile()
    }
}

// MARK: - FetchProfile

extension SplashViewController {
    private func fetchProfile() {
        guard let token = storage.accessToken else { return }
        
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token: token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImageURL(token: token, username: profile.login) { _ in }
                self.switchToTabBarController()
            case .failure(let error):
                print(error)
                let alertModel = AlertModel(
                    title: "Что-то пошлло не так(",
                    message: "Ошибка получения профиля",
                    firstButtonText: "Попробовать снова",
                    secondButtonText: "Выйти из профиля",
                    firstCompletion: { [weak self] in
                        guard let self else { return }
                        self.fetchProfile() },
                    secondCompletion: { [weak self] in
                        guard let self else { return }
                        ProfileLogoutService.shared.logout()
                        showAuthView()
                    })
                AlertPresenter.shared.showTwoButtonAlert(in: self, model: alertModel)
                break
            }
        }
    }
}
