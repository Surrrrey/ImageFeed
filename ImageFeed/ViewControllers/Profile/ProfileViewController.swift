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
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profileService = ProfileService.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlackIOS
        if let profileImage { configurationProfileImage(image: profileImage) }
        
        configureUILabels(with: profileService.profile)
        configurationButton()
        
        addObs()
        updateAvatar()
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
        
        var name = ""
        
        if let firstName = profile.firstName {
            name.append(firstName)
        }
        if let lastName = profile.lastName {
            name.append(" " + lastName)
        }
        
        configurationProfileName(name: name)
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
}

//MARK: - Observers

extension ProfileViewController {
    
    private func addObs() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main,
            ) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
    }
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.avatarURL else { return }
            //TODO: Update avatar with kingfisher
    }
}
