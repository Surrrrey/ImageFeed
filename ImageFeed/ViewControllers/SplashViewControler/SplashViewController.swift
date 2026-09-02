import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    private let segueAuthViewId = "ShowAuthView"
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.accessToken != nil {
            fetchProfile()
        } else {
            performSegue(withIdentifier: segueAuthViewId, sender: nil)
        }
    }
    
    // MARK: - Private Methods
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController =  UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
}

// MARK: - Segue

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueAuthViewId {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(segueAuthViewId)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - AuthViewController Delegate

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        fetchProfile()
    }
}

// MARK: - FetchProfile

extension SplashViewController {
    private func fetchProfile() {
        guard let token = OAuth2TokenStorage().accessToken else { return }
        
        profileService.fetchProfile(token: token) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                switchToTabBarController()
            case .failure:
                //TODO: Обработать ошибку получения профиля
                break
            }
        }
    }
}
