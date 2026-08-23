import Foundation

final class OAuth2TokenStorage: OAuth2StorageProtocol {
    
    // MARK: - Keys
    
    enum Keys: String {
        case accessToken
        case tokenType
        case scope
        case createdId
    }
    
    // MARK: - Properties
    
    private let storage: UserDefaults = .standard
    
    var accessToken: String {
        get {
            storage.string(forKey: Keys.accessToken.rawValue) ?? ""
        }
        set {
            storage.set(newValue, forKey: Keys.accessToken.rawValue)
        }
    }
    
    var tokenType: String {
        get {
            storage.string(forKey: Keys.tokenType.rawValue) ?? ""
        }
        set {
            storage.set(newValue, forKey: Keys.tokenType.rawValue)
        }
    }
    
    var scope: String {
        get {
            storage.string(forKey: Keys.scope.rawValue) ?? ""
        }
        set {
            storage.set(newValue, forKey: Keys.scope.rawValue)
        }
    }
    
    var createdId: Int {
        get {
            storage.integer(forKey: Keys.createdId.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.createdId.rawValue)
        }
    }
    
    // MARK: - Public Methods
    
    func saveAccessToken(token: String) {
        accessToken = token
    }
}
