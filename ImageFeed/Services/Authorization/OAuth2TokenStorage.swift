import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage: OAuth2StorageProtocol {
    
    static let shared = OAuth2TokenStorage()
    private init() {}
    
    // MARK: - Keys
    
    enum Keys: String {
        case accessToken
        case tokenType
        case scope
        case createdId
    }
    
    // MARK: - Properties
    
    private let storage: KeychainWrapper = .standard
    
    private(set) var accessToken: String? {
        get {
            storage.string(forKey: Keys.accessToken.rawValue)
        }
        set {
            if let token = newValue {
                let saveSuccess = storage.set(token, forKey: Keys.accessToken.rawValue)
                guard saveSuccess else {
                    print("SaveTokenError")
                    return }
            } else {
                storage.removeObject(forKey: Keys.accessToken.rawValue)
            }
        }
    }
    
    private(set) var tokenType: String? {
        get {
            storage.string(forKey: Keys.tokenType.rawValue)
        }
        set {
            if let tokenType = newValue {
                let saveSuccess = storage.set(tokenType, forKey: Keys.tokenType.rawValue)
                guard saveSuccess else {
                    print("SaveTokenTypeError")
                    return }
            } else {
                storage.removeObject(forKey: Keys.tokenType.rawValue)
            }
        }
    }
    
    private(set) var scope: String? {
        get {
            storage.string(forKey: Keys.scope.rawValue)
        }
        set {
            if let scope = newValue {
                let saveSuccess = storage.set(scope, forKey: Keys.scope.rawValue)
                guard saveSuccess else {
                    print("SaveScopeError")
                    return }
            } else {
                storage.removeObject(forKey: Keys.scope.rawValue)
            }
        }
    }
    
    private(set) var createdId: Int? {
        get {
            storage.integer(forKey: Keys.createdId.rawValue)
        }
        set {
            if let createdId = newValue {
                let saveSuccess = storage.set(createdId, forKey: Keys.createdId.rawValue)
                guard saveSuccess else {
                    print("SaveCreatedIDError")
                    return }
            } else {
                storage.removeObject(forKey: Keys.createdId.rawValue)
            }
        }
    }
    
    // MARK: - Public Methods
    
    func saveAccessToken(token: String) {
        accessToken = token
    }
    
    func removeToken() {
        accessToken = nil
    }
}
