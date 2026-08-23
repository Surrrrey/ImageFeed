import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        let fulfillCompletionOnTheMainTread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = ( response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainTread(.success(data))
                } else {
                    fulfillCompletionOnTheMainTread(.failure(NetworkError.httpStatusCode(statusCode)))
                    print("NetworkErrorWithCode: \(NetworkError.httpStatusCode(statusCode))")
                }
            } else if let error = error {
                fulfillCompletionOnTheMainTread(.failure(NetworkError.urlRequestError(error)))
                print("UrlRequestError: \(NetworkError.urlRequestError(error))")
            } else {
                fulfillCompletionOnTheMainTread(.failure(NetworkError.urlSessionError))
                print("UrlSessionError: \(NetworkError.urlSessionError)")
            }
        })
        
        return task
    }
}
