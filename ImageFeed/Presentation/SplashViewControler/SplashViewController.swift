import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Layout Properties
    private let logoImage = UIImage(resource: .logoOfUnsplash)
    private var logoImageView = UIImageView()
    
    private let backgroundColor = UIColor(resource: .ypBlackIOS)
    
    // MARK: - Properties
    
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
        
        let navigationController = UINavigationController(rootViewController: authViewController)
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.isHidden = true
        
        present(navigationController, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
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
        UIBlockingProgressHUD.show()
        
        guard let token = storage.accessToken else { return }
        
        profileService.fetchProfile(token: token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImageURL(token: token, username: profile.login) { _ in }
                switchToTabBarController()
            case .failure(let error):
                print(error)
                //TODO: Обработать ошибку получения профиля
                break
            }
        }
    }
}
