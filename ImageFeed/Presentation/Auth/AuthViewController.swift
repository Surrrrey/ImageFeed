import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    // MARK: - Layout
    
    private let backgroundColor = UIColor(resource: .ypBlackIOS)
    
    private let logoView = UIImageView(image: .logoOfUnsplash)
    private let logoWidthAndHeight = 60.0
    
    private let button = UIButton()
    private let buttonColor = UIColor(resource: .ypWhiteIOS)
    private let buttonText = "Войти"
    private let buttonFont = UIFont.systemFont(ofSize: 17, weight: .bold)
    private let buttonCornerRadius = 16.0
    
    // MARK: - Properties
    
    private let oAuth2Service = OAuth2FetchService.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OAuth2TokenStorage.shared.accessToken != nil {
            delegate?.didAuthenticate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = self.backgroundColor
        
        configLogoView()
        configAuthButton()
        configBackButton()
    }
    
    // MARK: - Layout Methods
    
    private func configLogoView() {
        logoView.tintColor = .ypWhiteIOS
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoView)
        
        NSLayoutConstraint.activate([
            logoView.widthAnchor.constraint(equalToConstant: logoWidthAndHeight),
            logoView.heightAnchor.constraint(equalToConstant: logoWidthAndHeight),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configAuthButton() {
        button.backgroundColor = buttonColor
        button.setTitle(buttonText, for: .normal)
        button.setTitleColor(.ypBlackIOS, for: .normal)
        button.titleLabel?.textColor = .ypBlackIOS
        button.titleLabel?.font = buttonFont
        button.layer.cornerRadius = buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            showWebView()
        }, for: .touchUpInside)
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func configBackButton() {
        navigationController?.navigationBar.backIndicatorImage = .backward
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = .backward
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .ypBlackIOS
    }
    
    // MARK: - Private Methods
    
    private func showWebView() {
        let webViewController = WebViewViewController()
        webViewController.delegate = self
        navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(webViewController, animated: true)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        
        UIBlockingProgressHUD.show()
        
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success:
                self.delegate?.didAuthenticate()
            case .failure:
                showAuthError()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
    private func showAuthError() {
        let alert = AlertModel(title: "Что-то пошло не так(",
                               message: "Не удалось войти в систему",
                               buttonText: "ОК") { }
        AlertPresenter().show(in: self, model: alert)
    }
}
