import UIKit

private enum ProfileImageServiceError: Error {
    case invalidProfileImageRequest
}

final class ProfileImageService {
    
    // MARK: - Singleton
    
    static let shared = ProfileImageService()
    private init() {}
    
    // MARK: - Properties
    
    private(set) var avatarURL: URL?
    
    private var sessionTask: URLSessionTask?
    
    private var profile = ProfileService.shared
    
    // MARK: - Public Methods
    
    func fetchProfileImageURL(token: String,
                              username: String,
                              completion: @escaping (Result<URL, Error>) -> Void) {
        sessionTask?.cancel()
        
        guard
            let profile = profile.profile?.login,
            let request = makeProfileImageRequest(username, token: token)
        else {
            completion(.failure(ProfileImageServiceError.invalidProfileImageRequest))
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(ProfileImageResult.self, from: data)
                    
                    guard let profileImage = result.profileImage,
                          let smallProfileImage = profileImage["small"]
                    else { return }
                    
                    self?.avatarURL = profileImage["small"]
                    
                    completion(Result.success(smallProfileImage))
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: [NotificationKeys.URL: smallProfileImage])
                } catch {
                    print("TryProfileImageError")
                    completion(Result.failure(error))
                }
            case .failure(let error):
                print("ProfileImageDataError: \(error)")
                completion(Result.failure(error))
            }
            self?.sessionTask = nil
        }

        self.sessionTask = task
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeProfileImageRequest(_ username: String, token: String) -> URLRequest? {
        guard
            let avatarURL = URL(string: Constants.defaultBaseURLString + Constants.userPublicProfile + username)
        else { print("AvatarUrlError")
            return nil }
        
        var request = URLRequest(url: avatarURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}

// MARK: - Notification

extension ProfileImageService {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private enum NotificationKeys {
        static let URL = "URL"
    }
}
