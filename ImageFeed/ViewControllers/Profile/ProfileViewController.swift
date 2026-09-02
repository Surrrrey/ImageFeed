import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Layout
    
    private var profileImage = UIImage(systemName: "person.crop.circle.fill")
    private var profileImageView = UIImageView()
    
    private var profileName = UILabel()
    private var profileLogin = UILabel()
    private var profileDescription = UILabel()
    
    private var button = UIButton()
    
    // MARK: - Properties

    private let profileService = ProfileService.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurationButton()
//        fetchProfile()

        view.backgroundColor = .ypBlackIOS
        if let profileImage { configurationProfileImage(image: profileImage) }
        
        configureUILabels(with: profileService.profile)
    }
    
    // MARK: - Layout Methods
    
    private func configurationProfileImage(image: UIImage) {
        profileImageView.image = image
        profileImageView.tintColor = .gray
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
    }
    
    private func configurationProfileName(name: String) {
        profileName =  configLabel(text: name, color: .ypWhiteIOS, font: .systemFont(ofSize: 23, weight: .bold))
        profileName.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileName)
        
        NSLayoutConstraint.activate([
            profileName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            profileName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16)
        ])
    }
    
    private func configurationProfileLogin(login: String) {
        profileLogin = configLabel(text: login,
                                   color: .ypGrayIOS,
                                   font: .systemFont(ofSize: 13, weight: .regular))
        profileLogin.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileLogin)
        
        NSLayoutConstraint.activate([
            profileLogin.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileLogin.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8),
            profileLogin.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16)
        ])
    }
    
    private func configurationProfileDescription(description: String) {
        profileDescription = configLabel(text: description, color: .ypWhiteIOS, font: .systemFont(ofSize: 13, weight: .regular))
        
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileDescription)
        
        NSLayoutConstraint.activate([
            profileDescription.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileDescription.topAnchor.constraint(equalTo: profileLogin.bottomAnchor, constant: 8),
            profileDescription.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16)
        ])
    }
    
    private func configurationButton() {
        button = .systemButton(with: UIImage(resource: .exit), target: self, action: #selector(buttonTap))
        button.tintColor = .ypRedIOS
        button.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 44),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
    
    private func configureUILabels(with profile: ProfileUI?) {
        guard let profile = profileService.profile else { return }
        
        configurationProfileName(name: profile.name)
        configurationProfileLogin(login: "@" + profile.login)
        guard let bio = profile.bio else { return }
        configurationProfileDescription(description: bio)
    }
    
    // MARK: - Private Methods
    
    private func configLabel(text: String, color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = font
        
        return label
    }
    
    @objc private func buttonTap(_ sender: UIButton) {
        //todo
    }
    
//    private func fetchProfile() {
//        UIBlockingProgressHUD.show()
//
//        guard let token = OAuth2TokenStorage().accessToken else { return } //TODO: МОЖНО ПЕРЕБРОСИТЬ ПОЛЬЗОВАТЕЛЯ НА ЭКРАН С АВТОРИЗАЦИЕЙ
//
//        profileService.fetchProfile(token: token) { [weak self] result in
//            UIBlockingProgressHUD.dismiss()
//
//            guard let self else { return }
//
//            switch result {
//            case .success(let profile):
//                updateProfileUI(from: profile)
//            case .failure(let error):
//                // TODO: Обработать ошибку загрузки профиля
//                print("LoadProfileError: \(error)")
//            }
//        }
//    } ЗАКОМЕНТИЛ НА ВСЯКИЙ СЛУЧАЙ
//
//    private func updateProfileUI(from profile: ProfileUI) {
//        profileUI?.name = profile.name.isEmpty
//        ? "Имя Фамилия"
//        : profile.name
//        profileUI?.login = profile.login.isEmpty
//        ? "login"
//        : profile.login
//        profileUI?.bio = (profile.bio?.isEmpty ?? true)
//        ? "Hello, World!"
//        : profile.bio
//    }
}
