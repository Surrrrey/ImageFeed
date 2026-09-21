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
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        sessionTask?.cancel()
        
        guard let request = makeImagesRequest() else {
            completion(.failure(ImagesListServiceError.invalidImagesRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            guard let self else {
                completion(.failure(ImagesListServiceError.invalidImagesObjectTask))
                return
            }
            
            self.sessionTask = nil
            
            switch result {
            case .success(let photoResult):
                let photos = [Photo(id: photoResult.id,
                                          size: CGSize(width: photoResult.width, height: photoResult.height),
                                          createdAt: photoResult.createdAt,
                                          description: photoResult.description,
                                          thumbImageURL: photoResult.urls.thumb,
                                          lagreImageURL: photoResult.urls.raw,
                                          isLiked: photoResult.isLiked)]
                self.photos.append(contentsOf: photos)
                completion(.success(photos))
                
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
    
    // MARK: - Private Methods
    
    private func makeImagesRequest() -> URLRequest? {
        guard
            let imagesUrl = URL(string: Constants.defaultBaseURLString + Constants.photoList)
        else { print("URLForImagesListRequestConfigureError")
        return nil }
        
        var request = URLRequest(url: imagesUrl)
        request.httpMethod = "GET"
        
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
