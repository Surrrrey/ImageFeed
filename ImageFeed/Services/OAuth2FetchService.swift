import Foundation

final class OAuth2FetchService {
    
    // MARK: - Properties
    
    static let shared = OAuth2FetchService()
    private init() {}
    
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
        let urlRequest = makeAuthTokenRequest(code: code)
        
        guard let urlRequest else { return }
        
        let task = URLSession.shared.data(for: urlRequest, completion: { result in
            switch result {
            case .success(let data):
                do {
                    let oAuthTokenResponseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    let token = oAuthTokenResponseBody.access_token
                    OAuth2TokenStorage().saveAccessToken(token: token)
                    completion(Result.success(token))
                } catch {
                    print("TryDataError")
                    completion(Result.failure(error))
                }
            case .failure(let error):
                print("DataTaskError: \(error)")
                completion(Result.failure(error))
            }
        })
        
        task.resume()
    }
}
