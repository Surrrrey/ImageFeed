import UIKit

private enum ProfileServiceError: Error {
    case invalidAccessToken
    case invalidProfileRequest
}

final class ProfileService {
    
    // MARK: - Singleton
    
    static let shared = ProfileService()
    private init() {}
    
    // MARK: - Properties
    
    private(set) var profile: ProfileUI?
    
    private var sessionTask: URLSessionTask?
    
    // MARK: - Public Methods
    
    func fetchProfile(token: String,
                      completion: @escaping (Result<ProfileUI, Error>) -> Void) {
        sessionTask?.cancel()
        
        guard let request = makeProfileRequest(token: token)
        else {
            completion(.failure(ProfileServiceError.invalidProfileRequest))
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                    let profileUI = ProfileUI(
                        login: profileResult.login,
                        firstName: profileResult.firstName,
                        lastName: profileResult.lastName,
                        bio: profileResult.bio)
                    
                    self?.profile = profileUI
                    
                    completion(Result.success(profileUI))
                } catch {
                    print("TryProfileDataError")
                    completion(Result.failure(error))
                }
            case .failure(let error):
                print("ProfileDataTaskError: \(error)")
                completion(Result.failure(error))
            }
            self?.sessionTask = nil
        }
        
        self.sessionTask = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard
            let profileUrl = URL(string: Constants.defaultBaseURLString + Constants.userProfile)
        else { print("URLForProfileRequestConfigureError")
            return nil }
        
        var request = URLRequest(url: profileUrl)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
