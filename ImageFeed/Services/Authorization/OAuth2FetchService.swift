import Foundation

private enum AuthServiceError: Error {
    case invalidAuthRequest
}

final class OAuth2FetchService {
    
    // MARK: - Properties
    
    static let shared = OAuth2FetchService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var sessionTask: URLSessionTask?
    private var lastCode: String?
    
    // MARK: - Private Methods
    
    private func makeAuthTokenRequest(code: String) -> URLRequest? {
        guard
            var urlComponents = URLComponents(string: WebConstants.unsplashTokenURLString)
        else { print("URLComponentsForTokenConfigureError")
            return nil }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let authTokenUrl = urlComponents.url else {
            print("TokenURLError")
            return nil
        }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchOAuthToken(code: String,
                         completion: @escaping (Swift.Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidAuthRequest))
            return
        }
        
        sessionTask?.cancel()
        
        lastCode = code
        
        guard
            let urlRequest = makeAuthTokenRequest(code: code)
        else { completion(.failure(AuthServiceError.invalidAuthRequest))
            return
        }
        
        let task = urlSession.objectTask(for: urlRequest) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let oAuthTokenResponseBody):
                
                    let token = oAuthTokenResponseBody.access_token
                OAuth2TokenStorage.shared.saveAccessToken(token: token)
                
                    completion(Result.success(token))
                
            case .failure(let error):
                print("AuthTaskError: \(error.localizedDescription)")
                completion(Result.failure(error))
            }
            self?.sessionTask = nil
            self?.lastCode = nil
        }
        
        self.sessionTask = task
        task.resume()
    }
}
