import UIKit

private enum ImagesListServiceError: Error {
    case invalidImagesRequest
    case invalidImagesObjectTask
}

final class ImagesListService {
    
    // MARK: - Properties
    
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    private var sessionTask: URLSessionTask?
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    // MARK: - Public Methods
    
    func fetchPhotosNextPage() {
        fetchPhotosAndConvert() { [weak self] result in
            
            switch result {
            case .success(let photo):
                
            case .failure(let error):
                
            }
        }
    }
    
    
    // MARK: - Private Methods
    
    private func fetchPhotosAndConvert(completion: @escaping (Result<[Photo], Error>) -> Void) {
        sessionTask?.cancel()
        
        guard let request = makeImagesRequest() else {
            completion(.failure(ImagesListServiceError.invalidImagesRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
                        
            self?.sessionTask = nil
            
            switch result {
            case .success(let result):
                let photosArray = result.map { element in
                    Photo(
                        id: element.id,
                        size: CGSize(width: element.width, height: element.height),
                        createdAt: element.createdAt,
                        description: element.description,
                        thumbImageURL: element.urls.thumb,
                        lagreImageURL: element.urls.regular,
                        isLiked: element.isLiked)
                }
                self?.photos.append(contentsOf: photosArray)
                completion(.success(photosArray))
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self)
                
            case .failure(let error):
                print("ImagesListTaskError: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        self.sessionTask = task
        task.resume()
    }
    
    private func makeImagesRequest() -> URLRequest? {
        guard
            let imagesUrl = URL(string: Constants.defaultBaseURLString + Constants.photoList)
        else { print("URLForImagesListRequestConfigureError")
            return nil }
        
        guard let token = OAuth2TokenStorage.shared.accessToken else { print("MakeImagesRequestError: Token = nil")
            return nil }
        
        var request = URLRequest(url: imagesUrl)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if
            lastLoadedPage == nil {
            let actualLoadedPage = 1
            lastLoadedPage = actualLoadedPage
            request.setValue(String(actualLoadedPage), forHTTPHeaderField: "page")
        } else
        if var lastLoadedPage {
            lastLoadedPage += 1
            request.setValue(String(lastLoadedPage), forHTTPHeaderField: "page")
        }
        
        return request
    }
}
