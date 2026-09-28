import UIKit

private enum ProfileImageServiceError: Error {
    case invalidProfileImageRequest
    case invalidProfileImageResponse
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
            profile.profile?.login != nil,
            let request = makeProfileImageRequest(username, token: token)
        else {
            completion(.failure(ProfileImageServiceError.invalidProfileImageRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileImageResult, Error>) in
            switch result {
            case .success(let profileImage):
                guard let image = profileImage.profileImage,
                      let smallProfileImage = image["large"]
                else {
                    let error = ProfileImageServiceError.invalidProfileImageResponse
                    print("ProfileImageServiceError")
                    completion(.failure(error))
                    return
                }
                
                self?.avatarURL = smallProfileImage
                
                completion(Result.success(smallProfileImage))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: [NotificationKeys.URL: smallProfileImage])
                
            case .failure(let error):
                print("ProfileImageTaskError: \(error.localizedDescription)")
                completion(Result.failure(error))
            }
            self?.sessionTask = nil
        }
        
        self.sessionTask = task
        task.resume()
    }
    
    func removeAvatarUrl() {
        self.avatarURL = nil
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
