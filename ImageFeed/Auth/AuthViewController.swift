import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Properties
    
    private let backgroundColor = UIColor(resource: .ypBlackIOS)
    
    private let logoView = UIImageView(image: .logoOfUnsplash)
    
    private let button = UIButton()
    private let buttonColor = UIColor(resource: .ypWhiteIOS)
    private let buttonText = "Войти"
    private let buttonFont = UIFont.systemFont(ofSize: 17, weight: .bold)
    
    private let segueWebViewId = "ShowWebView"
    
    private let oAuth2Service = OAuth2FetchService.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = self.backgroundColor // Я знаю что у меня на экране сейчас отображается две картинки и две кнопки, я сверстал экран кодом сразу на будущее, а как делать переход без сториборда пока не учили
        configLogoView()
        configAuthButton()
        configBackButton()
    }
    
    // MARK: - Public Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueWebViewId {
            guard
                let webViewViewController = segue.destination as? WebViewViewController else {
                assertionFailure("Failed to prepare for \(segueWebViewId)")
                return }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    
    private func configLogoView() {
        logoView.tintColor = .ypWhiteIOS
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoView)
        
        NSLayoutConstraint.activate([
            logoView.widthAnchor.constraint(equalToConstant: 60),
            logoView.heightAnchor.constraint(equalToConstant: 60),
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
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction {_ in
            self.performSegue(withIdentifier: self.segueWebViewId, sender: self)},
                         for: .touchUpInside)
        
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
}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oAuth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                // TODO: AUTHENTICATE
                break
            case .failure(let error):
                break
            }
            
            
            
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    
}
